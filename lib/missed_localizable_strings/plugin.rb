module Danger
  #
  # Sometimes developer adds new key in one Localizable.strings file
  # and forgets to add the same key in another Localizable.strings file.
  # This simple plugin warns the developer about these possible mistakes.
  #
  # @example Checks missing localizable strings in PR changeset
  #
  #          check_localizable_omissions
  #
  # @see  antondomashnev/danger-missed_localizable_strings
  # @tags localization, cocoa
  #
  class DangerMissedLocalizableStrings < Plugin
    #
    # Checks whether there are any missed entries in
    # all Localizable.strings from PR's changeset
    # files and prints out any found entries.
    #
    # @return  [void]
    #
    def check_localizable_omissions
      localizable_files = not_deleted_localizable_files
      keys_by_file = extract_keys_from_files(localizable_files)
      entries = localizable_strings_missed_entries(keys_by_file)
      print_missed_entries entries unless entries.empty?
    end

    private

    #
    # Returns an array of all detected missed keyes in Localizable.strings
    # By entry means the hash with key => filename, value => key name
    # Idea was taken from: https://github.com/AirHelp/danger-duplicate_localizable_strings
    #
    # @param keys_by_file {.strings file: [Array of keys]}
    #
    # @return  [Array of missed Localizable.strings entries]
    def localizable_strings_missed_entries(keys_by_file)
      missed_entries = []
      # The array with modified keyes from Localizable.strings
      # file with the most number of keys
      most_modified_strings_keys = keys_by_file.values.max_by(&:count)
      keys_by_file.each do |file_name, modified_keyes|
        missed_keyes = most_modified_strings_keys - modified_keyes
        next if missed_keyes.empty?
        missed_keyes.each do |key|
          missed_entries << { 'file' => file_name, 'key' => key }
        end
      end
      missed_entries
    end

    #
    # Copy from print_duplicate_entries from https://github.com/AirHelp/danger-duplicate_localizable_strings
    # Prints passed missed entries.
    # @param    [Hash] missed_entries
    #           A hash of `[file => keys]` entries to print.
    #
    # @return  [void]
    #
    def print_missed_entries(missed_entries)
      message = "#### Found missed keyes in Localizable.strings files \n\n"

      message << "| File | Key |\n"
      message << "| ---- | --- |\n"

      missed_entries.each do |entry|
        file = entry['file']
        key = entry['key']

        message << "| #{file} | #{key.strip} | \n"
      end

      markdown message
    end

    # A hash with keyes - Localizable.strings file and
    # values - modified keys from file
    def extract_keys_from_files(localizable_files)
      keys_from_file = {}
      localizable_files.each do |file|
        lines = File.readlines(file)

        # Grab just the keys, we don't need the translation
        keys = lines.map { |e| e.split('=').first }
        # Filter newlines and comments
        keys = keys.select do |e|
          e != "\n" && !e.start_with?('/*') && !e.start_with?('//')
        end
        keys_from_file[file] = keys
      end
      keys_from_file
    end

    def not_deleted_localizable_files
      files = (git.modified_files + git.added_files) - git.deleted_files
      localizable_files = files.select { |line| line.end_with?('.strings') }
      localizable_files
    end
  end
end
