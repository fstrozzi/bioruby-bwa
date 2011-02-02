require 'rubygems'
require 'ffi'
require 'bio/library'
require 'bio/bwa'


# checking if system architecture is 32bit or 64bit
if Bio::BWA::Library.arch_type == "32Bit" then
  raise SystemError, "Unable to run. BWA library is compiled for 64Bit systems!"
end
  


