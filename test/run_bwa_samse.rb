$:<<"."
require "lib/bio-bwa"

testdata = File.join("test","data","testdata")

Bio::BWA.samse("#{testdata}","#{testdata}.sai","#{testdata}.fa",:f => "#{testdata}.sam")

