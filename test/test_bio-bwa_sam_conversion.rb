$:<<"."
require 'test/helper'
require 'digest/md5'

class TestBioBwa < Test::Unit::TestCase
  
  def setup
    @testdata = File.join("test","data","testdata")
  end
  
  def test_sai_to_sam_single
    assert_nothing_raised do 
      Bio::BWA.sai_to_sam_single(:prefix=>"#{@testdata}",:sai=>"#{@testdata}.sai",:fastq=>"#{@testdata}.fa",:file_out => "#{@testdata}.sam")
    end
    md5 = Digest::MD5::hexdigest(File.open("#{@testdata}.sam","rb") {|f| f.read})
    assert_equal("5c523ae7bf18656190fa0bcd8944bd14",md5)
    FileUtils.rm("#{@testdata}.sam") 
  end
  
  def test_sai_to_sam_paired
    assert_nothing_raised do 
      Bio::BWA.sai_to_sam_paired(:prefix=>"#{@testdata}",:sai=>["#{@testdata}.sai","#{@testdata}.sai"],:fastq=>["#{@testdata}.fa","#{@testdata}.fa"],:file_out => "#{@testdata}.sampe")
    end
    md5 = Digest::MD5::hexdigest(File.open("#{@testdata}.sampe","rb") {|f| f.read})
    assert_equal("8c3847bade0a19e5de77c274355fe154",md5)
    FileUtils.rm("#{@testdata}.sampe")
  end
  
  def test_zomg_cleanup
    assert_nothing_raised do
      list = Dir.glob("#{@testdata}.*")
      list.delete("#{@testdata}.fa")
      list.delete("#{@testdata}.long.fa")
      list.delete("#{@testdata}.short.fa")
      list.each {|l| FileUtils.rm(l)}
    end
  end
  
  def test_errors
    assert_raise ArgumentError do
      Bio::BWA.sai_to_sam_single(:prefix=>"#{@testdata}",:fastq=>"#{@testdata}.fa",:file_out => "#{@testdata}.sam")
    end
    
    assert_raise ArgumentError do
      Bio::BWA.sai_to_sam_paired(:prefix=>"#{@testdata}",:sai=>"#{@testdata}.sai",:fastq=>["#{@testdata}.fa","#{@testdata}.fa"],:file_out => "#{@testdata}.sampe")
    end
  end
  
end