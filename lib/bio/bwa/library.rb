module Bio
  class BWA
    class Library
      
      require 'rbconfig'      
      
      def self.filename
        # checking if system architecture is 32bit or 64bit
        if Config::CONFIG['target_cpu'] != "x86_64" then
          raise RuntimeError, "Unable to load the shared library. BWA is compiled for 64Bit systems!"
        end
        
        lib_extension = case Config::CONFIG['host_os']
          when /linux/ then 'so'
          when /darwin/ then 'dylib'
          when /mswin|mingw/ then raise NotImplementedError, "BWA library is not available for Windows platform"  
        end
        File.join(File.expand_path(File.dirname(__FILE__)),'ext',"libbwa.#{lib_extension}")
      end
    end
  end
end