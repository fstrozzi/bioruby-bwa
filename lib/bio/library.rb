module Bio
  class BWA
    class Library
      def self.filename
        lib_os = case RUBY_PLATFORM
          when /linux/ then 'a'
          when /darwin/ then 'dylib'
          when /windows/ then raise NotImplementedError, "BWA software is not available for Windows platform"  
        end
        File.join(File.expand_path(File.dirname(__FILE__)),'ext',"libbwa.#{lib_os}")
      end
    end
  end
end