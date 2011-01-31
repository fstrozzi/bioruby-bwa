$:<<"."
require 'test/helper'
require 'digest/md5'

class TestBioBwa < Test::Unit::TestCase
  
  def setup
    @testdata = File.join("test","data","testdata")
  end
  
  def test_samse
    assert_nothing_raised do 
      Bio::BWA.samse("#{@testdata}","#{@testdata}.sai","#{@testdata}.fa",:f => "#{@testdata}.sam")
    end
    md5 = Digest::MD5::hexdigest(File.open("#{@testdata}.sam","rb") {|f| f.read})
    assert_equal("5c523ae7bf18656190fa0bcd8944bd14",md5)
    FileUtils.rm("#{@testdata}.sam") 
  end
  
  def test_sampe
    assert_nothing_raised do 
      Bio::BWA.sampe("#{@testdata}","#{@testdata}.sai","#{@testdata}.sai","#{@testdata}.fa","#{@testdata}.fa",:f => "#{@testdata}.sampe")
    end
    md5 = Digest::MD5::hexdigest(File.open("#{@testdata}.sampe","rb") {|f| f.read})
    assert_equal("8c3847bade0a19e5de77c274355fe154",md5)
    FileUtils.rm("#{@testdata}.sampe") 
  end
  
end