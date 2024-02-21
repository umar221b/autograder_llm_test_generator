class Differ
  class << self
    def diff(content1, content2)
      # clean up trailing whitespaces
      begin
        content1&.rstrip!
      rescue StandardError => e
        puts e
      end

      begin
        content2&.rstrip!
      rescue StandardError => e
        puts e
      end

      file1 = Tempfile.new('file1')
      file1.write(content1)
      file1.close

      file2 = Tempfile.new('file2')
      file2.write(content2)
      file2.close

      diff_result = %x( diff -b #{file1.path} #{file2.path} )

      file1.unlink
      file2.unlink

      diff_result
    end

    def no_diff?(content1, content2)
      diff(content1, content2).blank?
    rescue ArgumentError, Encoding::UndefinedConversionError => e
      puts e.message
      false
    end
  end
end