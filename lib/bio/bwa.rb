module Bio
  class BWA
      extend FFI::Library
      ffi_lib Bio::BWA::Library.filename
      
      def self.fa2pac(params={})
        valid_params = %q(file_in prefix)
        fixed_params = [:file_in,:prefix]
        args = build_parameters("fa2pac",valid_params,fixed_params,params,fixed_params)
        call_BWA_function(args)
      end
      
      def self.pac2bwt(params={})
        valid_params = %q(file_in file_out)
        fixed_params = [:file_in,:file_out]
        args = build_parameters("pac2bwt",valid_params,fixed_params,params,fixed_params)
        call_BWA_function(args)
      end
      
      def self.bwtupdate(params={})
        valid_params = %w(file_in file_out)
        fixed_params = [:file_in]
        args = build_parameters("bwtupdate",valid_params,fixed_params,params,fixed_params)
        call_BWA_function(args)
      end
      
      def self.pac_rev(params={})
        valid_params = %w(file_in file_out)
        fixed_params = [:file_in,:file_out]
        args = build_parameters("pac_rev",valid_params,fixed_params,params,fixed_params)
        call_BWA_function(args)
      end
      
      def self.bwt2sa(params={})
        valid_params = %q(file_in file_out i)
        fixed_params = [:file_in,:file_out]
        args = build_parameters("bwt2sa",valid_params,fixed_params,params,fixed_params)
        call_BWA_function(args)
      end
      
      def self.make_index(params = {})
        valid_params = %w(file_in p a c) # 'div' option will be suppressed by BWA author, since require 'libdivsufsort'. Use 'is' instead.
        mandatory_params = [:p,:file_in]
        last_params = [:file_in]
        new_params = {}
        params.each_pair do |k,v|
          k = :p if k == :prefix
          new_params[k] = v
        end
        args = build_parameters("index",valid_params,mandatory_params,new_params,last_params)        
        call_BWA_function(args)
      end
      
      def self.aln(params={})
          args = ["aln"]
          valid_params = %w(n o e i d l k c L R m t N M O E q f b single first second I B prefix file_in)
          mandatory_params = [:prefix,:file_in,:f]
          last_params = [:prefix,:file_in]
          new_params = {}
          params.each_pair do |k,v|
            k = "0" if k == :single
            k = "1" if k == :first
            k = "2" if k == :second
            k = :f if k == :file_out
            new_params[k] = v
          end
          args = build_parameters("aln",valid_params,mandatory_params,new_params,last_params)
          call_BWA_function(args)
      end
      
      
      def self.samse(params = {})
        valid_params = %w(n r fasta_in sai_in prefix f)
        new_params = {}
        mandatory_params = [:prefix,:sai_in,:fasta_in,:f]
        last_params = [:prefix,:sai_in,:fasta_in]
        params.each_pair do |k,v|
          k = :f if k == :file_out
          new_params[k] = v
        end
        args = build_parameters("sai2sam_se",valid_params,mandatory_params,new_params,last_params)
        call_BWA_function(args)
      end
      
      def self.sampe(params = {})
        valid_params = %w(a o s P n N c f A r prefix first_sai_in second_sai_in first_fasta_in second_fasta_in)
        mandatory_params = [:prefix, :first_sai_in, :second_sai_in, :first_fasta_in, :second_fasta_in, :f]
        last_params = [:prefix, :first_sai_in, :second_sai_in, :first_fasta_in, :second_fasta_in]
        new_params = {}
        params.each_pair do |k,v|
          k = :f if k == :file_out
          new_params[k] = v
        end
        args = build_parameters("sai2sam_pe",valid_params,mandatory_params,new_params,last_params)
        call_BWA_function(args)
      end
      
      def self.bwasw(params = {})
        valid_params = %w(q r a b t T w d z m y s c N H f prefix file_in)
        mandatory_params = [:prefix, :file_in, :f]
        last_params = [:prefix,:file_in]
        new_params = {}
        params.each_pair do |k,v|
          k = :f if k == :file_out
          new_params[k] = v
        end
        args = build_parameters("bwtsw2",valid_params,mandatory_params,new_params,last_params)
        call_BWA_function(args)
      end
      
      def self.stdsw(params = {})
        args = ["stdsw"]
        valid_params = %w(g T f r p file_out long_seq short_seq)
        mandatory_params = [:long_seq,:short_seq]
        last_params = mandatory_params
        new_params = {}
        params.each_pair {|k,v| new_params[k] = v if k != :file_out}
        args = build_parameters("stdsw",valid_params,mandatory_params,new_params,last_params)
        $stdout.reopen(params[:file_out],"w") if params[:file_out]
        call_BWA_function(args)
        $stdout.reopen("/dev/tty","w") if params[:file_out]
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
      attach_function :bwa_sai2sam_pe, [:int,:pointer], :int
      attach_function :bwa_bwtsw2, [:int, :pointer], :int
      attach_function :bwa_stdsw, [:int, :pointer], :int
            
      def self.call_BWA_function(args)
        c_args = build_args_for_BWA(args)  
        self.send("bwa_#{args[0]}".to_sym,args.size,c_args)
      end 
      
      def self.build_args_for_BWA(args)
        cmd_args = args.map do |arg|
          FFI::MemoryPointer.from_string(arg.to_s)
        end
        exec_args = FFI::MemoryPointer.new(:pointer, cmd_args.length)
        cmd_args.each_with_index do |arg, i|
          exec_args[i].put_pointer(0, arg)
        end
        return exec_args
      end
      
      def self.build_parameters(function_name,valid_params,mandatory_params,params,last_params)
        args = [function_name]
        mandatory_params.each {|mp| raise ArgumentError,"You must provide parameter '#{mp}'" unless params.include?(mp)}
        params.each_key do |k|
          raise ArgumentError, "Unknown parameter '#{k}' !" unless valid_params.include?(k.to_s)
          unless last_params.include?(k) then
            args << "-#{k}"
            args << params[k] unless params[k] == true
          end
        end                
        last_params.each {|p| args << params[p]}
        return args
      end
      
      
      
      private_class_method :call_BWA_function
      private_class_method :build_args_for_BWA
      private_class_method :build_parameters
      
  end
end



