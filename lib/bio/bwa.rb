module Bio
  # @author Francesco Strozzi https://github.com/fstrozzi
  class BWA
      extend FFI::Library
      ffi_lib Bio::BWA::Library.load
      
      # Convert a Fasta to Packed format
      # @param [Hash]. params Options.
      # @option params [String] :file_in the Fasta or FastQ file (REQUIRED)
      # @option params [String] :prefix the prefix name for the PAC file
      def self.fa2pac(params={})
        valid_params = %q(file_in prefix)
        last_params = [:file_in, :prefix]
        mandatory_params = [:file_in]
        check_mandatory(mandatory_params, params)
        args = build_parameters("fa2pac",valid_params,params,fixed_params)
        call_BWA_function(args)
      end
      
      # Convert a Packed file format to Burrows-Wheeler Transform format
      # @param [Hash]. params Options.
      # @option params [String] :file_in the PAC file (REQUIRED)
      # @option params [String] :file_out the name of the BWT file (REQUIRED)
      def self.pac2bwt(params={})
        valid_params = %q(file_in file_out)
        fixed_params = [:file_in,:file_out]
        check_mandatory(fixed_params, params)
        args = build_parameters("pac2bwt",valid_params,params,fixed_params)
        call_BWA_function(args)
      end
      
      # Convert a BWT file to the new BWT format
      # @param [Hash]. params Options.
      # @option params [String] :file_in the BWT file (REQUIRED)
      # @note this method overwrite existing BWT file
      def self.bwtupdate(params={})
        valid_params = %w(file_in)
        fixed_params = [:file_in]
        check_mandatory(fixed_params, params)
        args = build_parameters("bwtupdate",valid_params,params,fixed_params)
        call_BWA_function(args)
      end
      
      # Generate reverse Packed format
      # @param [Hash]. params Options.      
      # @option params [String] :file_in the PAC file (REQUIRED)
      # @option params [String] :file_out the name of the REV PAC (REQUIRED)
      def self.pac_rev(params={})
        valid_params = %w(file_in file_out)
        fixed_params = [:file_in,:file_out]
        check_mandatory(fixed_params, params)
        args = build_parameters("pac_rev",valid_params,params,fixed_params)
        call_BWA_function(args)
      end
      
      # Generate SA file from BWT and Occ files
      # @param [Hash]. params Options.
      # @option params [String] :file_in the PAC file (REQUIRED)
      # @option params [String] :file_out the name of the REV PAC (REQUIRED)
      def self.bwt2sa(params={})
        valid_params = %q(file_in file_out i)
        fixed_params = [:file_in,:file_out]
        check_mandatory(fixed_params, params)
        args = build_parameters("bwt2sa",valid_params,params,fixed_params)
        call_BWA_function(args)
      end
      
      # Generate the BWT index for a Fasta database
      # @param [Hash]. params Options.
      # @option params [String] :file_in the Fasta file (REQUIRED)
      # @option params [String] :p the prefix for the database files that will be generated [default is Fasta name]
      # @option params [String] :a the algorithm to be used for indexing: 'is' (short database)[default] or 'bwtsw' (long database)
      # @option params [Boolean] :c colorspace database index
      # @note Boolean values must be set to 'true'
      def self.make_index(params = {})
        valid_params = %w(file_in p a c)
        mandatory_params = [:file_in]
        last_params = [:file_in]
        check_mandatory(mandatory_params, params)
        new_params = {}
        params.each_pair do |k,v|      
          k = :p if k == :prefix
          new_params[k] = v
        end
        args = build_parameters("index",valid_params,new_params,last_params)        
        call_BWA_function(args)
      end
      
      # Run the alignment for short query sequences
      # @param [Hash] params Options
      # @option params [String] :file_in the FastQ file (REQUIRED)
      # @option params [String] :prefix the prefix of the database index files (REQUIRED)
      # @option params [String] :file_out the output of the alignment in SAI format (REQUIRED)
      # @option params [Integer] :n max #diff (int) or missing prob under 0.02 err rate (float) [0.04]
      # @option params [Integer] :o maximum number or fraction of gap opens [1]
      # @option params [Integer] :e maximum number of gap extensions, -1 for disabling long gaps [-1]
      # @option params [Integer] :m maximum entries in the queue [2000000]
      # @option params [Integer] :t number of threads [1]
      # @option params [Integer] :M mismatch penalty [3]
      # @option params [Integer] :O gap open penalty [11]
      # @option params [Integer] :R stop searching when there are >INT equally best hits [30]
      # @option params [Integer] :q quality threshold for read trimming down to 35bp [0]
      # @option params [Integer] :B length of barcode
      # @option params [Boolean] :c input sequences are in the color space
      # @option params [Boolean] :L log-scaled gap penalty for long deletions
      # @option params [Boolean] :N non-iterative mode: search for all n-difference hits (slow)
      # @option params [Boolean] :I the input is in the Illumina 1.3+ FASTQ-like format
      # @option params [Boolean] :b the input read file is in the BAM format
      # @option params [Boolean] :single use single-end reads only (effective with -b)
      # @option params [Boolean] :first use the 1st read in a pair (effective with -b)
      # @option params [Boolean] :second use the 2nd read in a pair (effective with -b)
      # @option params [Integer] :i do not put an indel within INT bp towards the ends [5]
      # @option params [Integer] :d maximum occurrences for extending a long deletion [10]
      # @option params [Integer] :l seed length [32]
      # @option params [Integer] :k maximum differences in the seed [2]
      # @option params [Integer] :E gap extension penalty [4]
      # @note Boolean values must be set to 'true'
      def self.short_read_alignment(params={})
          args = ["aln"]
          valid_params = %w(n o e i d l k c L R m t N M O E q f b single first second I B prefix file_in)
          mandatory_params = [:prefix,:file_in,:file_out]
          last_params = [:prefix,:file_in]
          check_mandatory(mandatory_params, params)
          new_params = {}
          params.each_pair do |k,v|
            k = "0" if k == :single
            k = "1" if k == :first
            k = "2" if k == :second
            k = :f if k == :file_out
            new_params[k] = v
          end
          args = build_parameters("aln",valid_params,new_params,last_params)
          call_BWA_function(args)
      end
      
      # Convert the SAI alignment output into SAM format (single end)
      # @param [Hash] params Options
      # @option params [String] :fastq the FastQ file (REQUIRED)
      # @option params [String] :prefix the prefix of the database index files (REQUIRED)
      # @option params [String] :sai the alignment file in SAI format (REQUIRED)
      # @option params [String] :file_out the file name of the SAM output
      # @option params [Integer] :n max_occ
      # @option params [String] :r RG_line
      def self.sai_to_sam_single(params = {})
        valid_params = %w(n r fastq sai prefix f)
        mandatory_params = [:prefix,:sai,:fastq]
        last_params = [:prefix,:sai,:fastq]
        check_mandatory(mandatory_params, params)
        new_params = {}
        params.each_pair do |k,v|   
          k = :f if k == :file_out
          new_params[k] = v
        end
        args = build_parameters("sai2sam_se",valid_params,new_params,last_params)
        call_BWA_function(args)
      end
      
      
      # Convert the SAI alignment output into SAM format (paired ends)
      # @param [Hash] params Options
      # @option params [String] :prefix the prefix of the database index files (REQUIRED)
      # @option params [Array] :sai the two alignment files in SAI format (REQUIRED)
      # @option params [Array] :fastq the two fastq files (REQUIRED)
      # @option params [Integer] :a maximum insert size [500]
      # @option params [Integer] :o maximum occurrences for one end [100000]
      # @option params [Integer] :n maximum hits to output for paired reads [3]
      # @option params [Integer] :N maximum hits to output for discordant pairs [10]
      # @option params [Float] :c prior of chimeric rate (lower bound) [1.0e-05]
      # @option params [String] :r read group header line such as '@RG\tID:foo\tSM:bar'
      # @option params [Boolean] :P preload index into memory (for base-space reads only)
      # @option params [Boolean] :s disable Smith-Waterman for the unmapped mate
      # @option params [Boolean] :A disable insert size estimate (force :s)
      # @note Boolean values must be set to 'true'
      def self.sai_to_sam_paired(params = {})
        valid_params = %w(a o s P n N c f A r prefix first_sai second_sai first_fastq second_fastq)
        mandatory_params = [:prefix, :sai, :fastq]
        last_params = [:prefix, :first_sai, :second_sai, :first_fastq, :second_fastq]
        check_mandatory(mandatory_params, params)
        new_params = {}
        params.each_pair do |k,v| 
          if k == :file_out
            k = :f
            new_params[k] = v
          elsif k == :sai
            raise ArgumentError,"you must provide an array with two SAI files!" if !v.is_a?(Array)
            new_params[:first_sai] = v[0]
            new_params[:second_sai] = v[1]
          elsif k == :fastq
            raise ArgumentError,"you must provide an array with two FastQ files!" if !v.is_a?(Array)
            new_params[:first_fastq] = v[0]
            new_params[:second_fastq] = v[1]
          else
            new_params[k] = v
          end         
        end
        args = build_parameters("sai2sam_pe",valid_params,new_params,last_params)
        call_BWA_function(args)
      end
      
      # Run the alignment for long query sequences
      # @param [Hash] params Options
      # @option params [String] :file_in the FastQ file (REQUIRED)
      # @option params [String] :prefix the prefix of the database index files (REQUIRED)
      # @option params [String] :file_out the output of the alignment in SAM format (REQUIRED)
      # @option params [Integer] :a score for a match [1]
      # @option params [Integer] :b mismatch penalty [3]
      # @option params [Integer] :q gap open penalty [5]
      # @option params [Integer] :r gap extension penalty [2]
      # @option params [Integer] :t number of threads [1]
      # @option params [Integer] :w band width [50]
      # @option params [Float] :m mask level [0.50]
      # @option params [Integer] :T score threshold divided by a [30]
      # @option params [Integer] :s maximum seeding interval size [3]
      # @option params [Integer] :z Z-best [1]
      # @option params [Integer] :N number of seeds to trigger reverse alignment [5]
      # @option params [Float] :c coefficient of length-threshold adjustment [5.5]
      # @option params [Boolean] :H in SAM output, use hard clipping rather than soft
      # @note Boolean arguments must be set to 'true'
      def self.long_read_alignment(params = {})
        valid_params = %w(q r a b t T w d z m y s c N H f prefix file_in)
        mandatory_params = [:prefix, :file_in, :file_out]
        last_params = [:prefix,:file_in]
        check_mandatory(mandatory_params, params)
        new_params = {}
        params.each_pair do |k,v|
          k = :f if k == :file_out
          new_params[k] = v
        end
        args = build_parameters("bwtsw2",valid_params,new_params,last_params)
        call_BWA_function(args)
      end
      
      # Run the alignment between multiple short sequences and ONE long sequence
      # @param [Hash] params Options
      # @option params [String] :short_seq the short query sequence (REQUIRED)
      # @option params [String] :long_seq the long database sequence (REQUIRED)
      # @option params [String] :file_out the alignment output
      # @option params [Integer] :T minimum score [1]
      # @option params [Boolean] :p protein alignment (suppressing :r)
      # @option params [Boolean] :f forward strand only
      # @option params [Boolean] :r reverse strand only
      # @option params [Boolean] :g global alignment
      # @note Boolean values must be set to 'true'
      def self.simple_SW(params = {})
        args = ["stdsw"]
        valid_params = %w(g T f r p file_out long_seq short_seq)
        mandatory_params = [:long_seq,:short_seq]
        last_params = mandatory_params
        check_mandatory(mandatory_params, params)
        new_params = {}
        params.each_pair {|k,v| new_params[k] = v if k != :file_out}
        
        args = build_parameters("stdsw",valid_params,new_params,last_params)
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
      
      # Internal method to call the BWA C functions
      # @note this method should not be called directly   
      def self.call_BWA_function(args)
        c_args = build_args_for_BWA(args)  
        self.send("bwa_#{args[0]}".to_sym,args.size,c_args)
      end 
      
      # Internal method to build argument list for BWA C functions
      # @note this method should not be called directly
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
      
      # Internal method to produce a correct parameter list for BWA functions
      # @note this method should not be called directly
      def self.build_parameters(function_name,valid_params,params,last_params)
        args = [function_name]
        params.each_key do |k|
          raise ArgumentError, "Unknown parameter '#{k}'" unless valid_params.include?(k.to_s)
          unless last_params.include?(k) then
            args << "-#{k}"
            args << params[k] unless params[k] == true
          end
        end                
        last_params.each {|p| args << params[p]}
        return args
      end
      
      # Internal method to check if mandatory params have been set
      # @note this method should not be called directly
      def self.check_mandatory(mandatory_params, params)
        mandatory_params.each {|mp| raise ArgumentError,"You must provide parameter '#{mp}'" unless params.include?(mp)}
      end
      
      private_class_method :call_BWA_function
      private_class_method :build_args_for_BWA
      private_class_method :build_parameters
      private_class_method :check_mandatory
      
  end
end



