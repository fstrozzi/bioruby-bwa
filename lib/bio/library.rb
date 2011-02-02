module Bio
  class BWA
    class Library
      
      def self.filename
        
        # checking if system architecture is 32bit or 64bit
        if Bio::BWA::Library.arch_type == "32Bit" then
          raise SystemError, "Unable to run. BWA library is compiled for 64Bit systems!"
        end
        
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