$:<<"."
require 'test/helper'
require 'digest/md5'

class TestBioBwa < Test::Unit::TestCase
  
  def setup
    @testdata = File.join("test","data","testdata")
  end
  
  def test_aln
    assert_nothing_raised do
      Bio::BWA.aln(:prefix=>"#{@testdata}",:file_in=>"#{@testdata}.fa",:file_out=>"#{@testdata}.sai")
    end
    md5 = Digest::MD5::hexdigest(File.open("#{@testdata}.sai","rb") {|f| f.read})
    assert_equal("56793f4473805683a7d494808c19f79e",md5)
  end
  
  def test_aln_bwasw
    assert_nothing_raised do
      Bio::BWA.bwasw(:prefix=>"#{@testdata}",:file_in=>"#{@testdata}.fa", :file_out=>"#{@testdata}.bwasw")
    end
    md5 = Digest::MD5::hexdigest(File.open("#{@testdata}.bwasw","rb") {|f| f.read})
    assert_equal("f569b0dfa7482d468bc68eb8151fb117",md5)
    FileUtils.rm("#{@testdata}.bwasw")
  end
  
  def test_aln_stdsw
    assert_nothing_raised do
      Bio::BWA.stdsw(:long_seq=>"#{@testdata}.long.fa",:short_seq=>"#{@testdata}.short.fa",:f => true,:file_out => "#{@testdata}.stdsw")
    end
    md5 = Digest::MD5::hexdigest(File.open("#{@testdata}.stdsw","rb") {|f| f.read})
    assert_equal("cedb41d4ba3581111fbcefec6063dc86",md5)
    FileUtils.rm("#{@testdata}.stdsw")
  end
  
end