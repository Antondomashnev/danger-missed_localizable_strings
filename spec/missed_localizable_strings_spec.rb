require File.expand_path("../spec_helper", __FILE__)

module Danger
  describe Danger::DangerMissedLocalizableStrings do
    it "should be a plugin" do
      plugin = Danger::DangerMissedLocalizableStrings.new(nil)
      expect(plugin).to be_a Danger::Plugin
    end

    describe "with Dangerfile" do
      before do
        @dangerfile = testing_dangerfile
        @my_plugin = @dangerfile.missed_localizable_strings
        allow(@my_plugin.git).to receive(:deleted_files).and_return([])
      end

      context "when there are no Localizable.strings in changeset" do
        before do
          allow(@my_plugin.git).to receive(:modified_files)
            .and_return(["spec/fixtures/SomeModifiedFile.swift"])
          allow(@my_plugin.git).to receive(:added_files)
            .and_return(["spec/fixtures/AddedFile.m"])
          @my_plugin.check_localizable_omissions
        end

        it "does not warn about missed entries in Localizable.strings" do
          expect(@my_plugin.status_report[:markdowns].first).to be_nil
        end
      end

      context "when there is one Localizable.strings file in changeset" do
        before do
          allow(@my_plugin.git).to receive(:modified_files)
            .and_return(["spec/fixtures/SomeModifiedFile.swift"])
          allow(@my_plugin.git).to receive(:added_files)
            .and_return(["spec/fixtures/LocalizableOrigin.strings"])
          @my_plugin.check_localizable_omissions
        end

        it "does not warn about missed entries in Localizable.strings" do
          expect(@my_plugin.status_report[:markdowns].first).to be_nil
        end
      end

      context "when there are multiple Localizable.strings in changeset" do
        context "when there are no missed keys in these files" do
          before do
            allow(@my_plugin.git).to receive(:modified_files)
              .and_return(["spec/fixtures/LocalizableWithoutOmissions.strings"])
            allow(@my_plugin.git).to receive(:added_files)
              .and_return(["spec/fixtures/LocalizableOrigin.strings"])
            @my_plugin.check_localizable_omissions
          end

          it "does not warn about missed entries in Localizable.strings" do
            expect(@my_plugin.status_report[:markdowns].first).to be_nil
          end
        end

        context "when there are missed keys in these files" do
          before do
            file1 = "spec/fixtures/LocalizableWithOmissions1.strings"
            file2 = "spec/fixtures/LocalizableWithOmissions2.strings"
            allow(@my_plugin.git).to receive(:modified_files)
              .and_return([file1, file2])
            allow(@my_plugin.git).to receive(:added_files)
              .and_return(["spec/fixtures/LocalizableOrigin.strings"])
            @my_plugin.check_localizable_omissions
            @output = @my_plugin.status_report[:markdowns].first
          end

          it "warns about missed entries in Localizable.strings" do
            expect(@output).to_not be_nil
          end

          it "contains header" do
            title = "Found missed keyes in Localizable.strings files"
            expect(@output.to_s).to include(title)
          end

          it "contains information about the first key from first file" do
            file = "spec/fixtures/LocalizableWithOmissions1.strings"
            key = "Day"
            expect(@output.to_s).to include("| #{file} | \"#{key}\" |")
          end

          it "contains infromation about the second key from first file" do
            file = "spec/fixtures/LocalizableWithOmissions1.strings"
            key = "Year"
            expect(@output.to_s).to include("| #{file} | \"#{key}\" |")
          end

          it "contains infromation about the first key from second file" do
            file = "spec/fixtures/LocalizableWithOmissions2.strings"
            key = "Hello"
            expect(@output.to_s).to include("| #{file} | \"#{key}\" |")
          end
        end
      end
    end
  end
end
