module Bio
  class BWA
    class Library
      
      require 'rbconfig'      
      
      def self.lib_extension
        case Config::CONFIG['host_os']
          when /linux/ then return 'so'
          when /darwin/ then return 'dylib'
          when /mswin|mingw/ then raise NotImplementedError, "BWA library is not available for Windows platform"  
        end
      end
      
      # Load the correct library for the OS system in use
      # @return [String] the absolute path for the filename of the shared library
      # @note this method is called automatically when the module is loaded
      def self.load
        warn "BWA library should be run on a 64bit system" if arch_type == "32bit"
        path = File.expand_path File.dirname(__FILE__)
        path.gsub!(/lib\/bio\/bwa/,'ext')
        File.join(path,"libbwa.#{self.lib_extension}")
      end
      
      
      
      private
      
      # Chech if the system architecture is 32bit or 64bit
      # @return [String] architecture type (64bit or 32bit)
      # @note this method is used internally
      def self.arch_type
        if RUBY_PLATFORM == 'java'
          return (Config::CONFIG['target_cpu'] == "x86_64") ? "64bit" : "32bit" 
        else
          return (['a'].pack('p').size > 4) ? "64bit" : "32bit" 
        end
      end
      
    end
  end
end