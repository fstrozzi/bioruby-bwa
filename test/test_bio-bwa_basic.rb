
$:<<"."
require 'test/helper'
require 'digest/md5'

class TestBioBwa < Test::Unit::TestCase
  
  def setup
    @testdata = File.join("test","data","testdata")
  end
  
  def test_1bwa_fa2pac
    Bio::BWA.fa2pac(:file_in => "#{@testdata}.fa",:prefix => @testdata)
    md5 = Digest::MD5::hexdigest(File.open("#{@testdata}.pac","rb") {|f| f.read})
    assert_equal("31ab6686d10cf980b9fc910854a38a7a",md5)
  end

  
  def test_2pac2bwt
    out = "#{@testdata}.bwt"
    Bio::BWA.pac2bwt(:file_in => "#{@testdata}.pac",:file_out => out)
    md5 = Digest::MD5::hexdigest(File.open(out,"rb") {|f| f.read})
    assert_equal("3c5e20c123ed8ab961287933e9734e70",md5)
  end
  
  def test_4bwtupdate
    out = File.join("test","data","testdata.bwt")
    FileUtils.cp out,"#{@testdata}.updated.bwt"
    Bio::BWA.bwtupdate(:file_in => "#{@testdata}.updated.bwt")
    md5 = Digest::MD5::hexdigest(File.open("#{@testdata}.updated.bwt","rb") {|f| f.read})
    assert_equal("4f7ee2b68fade083421d8fd93bf024ec",md5)
    FileUtils.rm(out)
  end
  
  def test_3pac_rev
    out = File.join("test","data","out.rev.pac")
    Bio::BWA.pac_rev(:file_in => "#{@testdata}.pac",:file_out => out)
    md5 = Digest::MD5::hexdigest(File.open(out,"rb") {|f| f.read})
    assert_equal("879cd21435a314f672c7de6d13977d69",md5)
    FileUtils.rm(out)
  end
  
  def test_5bwt2sa
    out = File.join("test","data","out.sa")
    bwt = File.join("test","data","testdata.updated.bwt")
    Bio::BWA.bwt2sa(:file_in => bwt,:file_out => out)
    md5 = Digest::MD5::hexdigest(File.open(out,"rb") {|f| f.read})
    assert_equal("948d0ebf6176f61de3ecdc8c085ae88a",md5)
    FileUtils.rm(out)
    FileUtils.rm(bwt)
    FileUtils.rm("#{@testdata}.pac")
    FileUtils.rm("#{@testdata}.amb")
    FileUtils.rm("#{@testdata}.ann")
  end
  
  def test_no_method
    assert_raise NoMethodError do
      Bio::BWA.fake_method("some_file")
    end
  end

end
