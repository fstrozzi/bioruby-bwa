module Bio
  class BWA
    class Library
      
      def self.arch_type
        ['a'].pack('P').length  > 4 ? "64Bit" : "32Bit"
      end
      
      def self.filename
        lib_extension = case RUBY_PLATFORM
          when /linux/ then 'so'
          when /darwin/ then 'dylib'
          when /windows/ then raise NotImplementedError, "BWA software is not available for Windows platform"  
        end
        File.join(File.expand_path(File.dirname(__FILE__)),'ext',"libbwa.#{lib_extension}")
      end
    end
  end
end