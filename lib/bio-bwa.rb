require 'ffi'
 
module Bio
  class BWA
      extend FFI::Library
      ffi_lib "libbwa"
      
      def self.fa2pac(file_in,file_out=nil)
        args = ["fa2pac",file_in]
        args << file_out if file_out != nil
        self.call_function(args)
      end
      
      def self.pac2bwt(file_in,file_out)
        args = ["pac2bwt",file_in,file_out]
        self.call_function(args)
      end
      
      def self.bwtupdate(file_in)
        args = ["bwtupdate",file_in]
        self.call_function(args)
      end
      
      def self.pac_rev(file_in,file_out)
        args = ["pac_rev",file_in,file_out]
        self.call_function(args)
      end
      
      def self.bwt2sa(file_in,file_out,i=32)
        args = ["bwt2sa",file_in,file_out]
        args.insert(0,"-i #{i}") if i != 32
        self.call_function(args)
      end
      
      def self.make_index(file_in, params = {:algorithm => "is",:prefix => nil,:colorspace => nil})
        valid_params = ["bwtsw","is"] # 'div' option is suppressed by BWA author, since require 'libdivsufsort'. Use 'is' instead.
        raise ArgumentError, "'index' function can only accept 'bwtsw' or 'is' as valid algorithms" if !valid_params.include?(params[:algorithm])
        args = ["index"]
        args << "-a"
        args << params[:algorithm]
        if params[:prefix]
          args << "-p"
          args << params[:prefix]
        end
        args << "-c" if params[:colorspace]
        args << file_in
        self.call_function(args)
      end
      
      def self.aln(index_prefix,file_in,params={}) #params={:n => 0.04,:o => 1,:e => -1,:i => 5, :d => 10,:l => 32,:k => 2,:m => 2000000,:t => 1,:M => 3,:O => 11,:E => 4,:R => 30,:q => 0,:f => nil,:B => nil,:c => false,:L=>false,:N=>false,:I=>false,:b=>false,:single => false,:first => false,:second => false}
          args = ["aln"]
          valid_params = %w(n o e i d l k c L R m t N M O E q f b single first second I B)
          params.each_key do |k|
            raise ArgumentError, "Unknown parameter '#{k}' for BWA#aln method!" if !valid_params.include?(k.to_s)
            if params[k] == true
              case k
                when :single then args << "-0"
                when :first then args << "-1"
                when :second then args << "-2"
              else
                args << "-#{k}"
              end 
            elsif params[k]
              args << "-#{k}"
              args << params[k]
            end
          end
          args << index_prefix
          args << file_in
          self.call_function(args)
      end
      
      
      def self.samse(index_prefix,sai_in,fasta_in,params = {}) # params = {:n => 3, :r => nil, :f => "out.sam"}
        args = ["sai2sam_se"]
        valid_params = %w(n r f)
        params.each_key do |k|
          raise ArgumentError, "Unknown parameter '#{k}' for BWA#samse method!" if !valid_params.include?(k.to_s)
          args << "-#{k}"
          args << params[k]
        end
        args << index_prefix
        args << sai_in
        args << fasta_in
        self.call_function(args)
      end
      
      ######## Methods to handle C functions and arguments ########
      
      attach_function :bwa_fa2pac, [:int,:pointer], :int
      attach_function :bwa_pac2bwt, [:int,:pointer], :int
      attach_function :bwa_bwtupdate, [:int,:pointer], :int
      attach_function :bwa_pac_rev, [:int,:pointer], :int
      attach_function :bwa_bwt2sa, [:int,:pointer], :int
      attach_function :bwa_index, [:int,:pointer], :int
      attach_function :bwa_aln, [:int,:pointer], :int
      attach_function :bwa_sai2sam_se, [:int, :pointer], :int
      
      
      def self.call_function(args)
        begin
          c_args = self.build_args(args)
          self.send("bwa_#{args[0]}".to_sym,args.size,c_args)
        rescue 
          raise NoMethodError, "BWA Function '"+args[0]+"' not found!" 
        end
      end 
      
      def self.build_args(args)
        cmd_args = args.map do |arg|
          FFI::MemoryPointer.from_string(arg.to_s)
        end
        exec_args = FFI::MemoryPointer.new(:pointer, cmd_args.length)
        cmd_args.each_with_index do |arg, i|
          exec_args[i].put_pointer(0, arg)
        end
        return exec_args
      end
      
  end
end



