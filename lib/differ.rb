class Differ
  class << self
    def diff(content1, content2)
      file1 = Tempfile.new('file1')
      file1.write(content1)

      file2 = Tempfile.new('file2')
      file2.write(content2)

      diff_result = %x( diff -b #{file1.path} #{file2.path} )

      file1.unlink
      file2.unlink

      diff_result
    end

    def no_diff?(content1, content2)
      diff(content1, content2).blank?
    end
  end
end