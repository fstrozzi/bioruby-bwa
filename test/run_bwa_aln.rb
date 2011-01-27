
$:<<"."
require "lib/bio-bwa"

testdata = File.join("test","data","testdata")
Bio::BWA.aln("#{testdata}","#{testdata}.fa",:f=>"#{testdata}.sai")

