
$:<<"."
require 'test/helper'
require 'digest/md5'

class TestBioBwa < Test::Unit::TestCase
  
  def setup
    @testdata = File.join("test","data","testdata")
  end
  
  def test_bwa_fa2pac
    out = File.join("test","data","out")
    Bio::BWA.fa2pac("#{@testdata}.fa",out)
    md5 = Digest::MD5::hexdigest(File.open(File.join("test","data","out.pac"),"rb") {|f| f.read})
    assert_equal("31ab6686d10cf980b9fc910854a38a7a",md5)
    FileUtils.rm Dir.glob(File.join("test","data","out.*"))
  end
  
  def test_pac2bwt
    out = File.join("test","data","out.bwt")
    Bio::BWA.pac2bwt("#{@testdata}.pac",out)
    md5 = Digest::MD5::hexdigest(File.open(out,"rb") {|f| f.read})
    assert_equal("3c5e20c123ed8ab961287933e9734e70",md5)
    FileUtils.rm(out)
  end
  
  def test_bwtupdate
    tmp = "#{@testdata}.tmp.bwt"
    FileUtils.cp "#{@testdata}.old.bwt",tmp
    Bio::BWA.bwtupdate(tmp)
    md5 = Digest::MD5::hexdigest(File.open(tmp,"rb") {|f| f.read})
    assert_equal("4f7ee2b68fade083421d8fd93bf024ec",md5)
    FileUtils.rm(tmp)
  end
  
  def test_pac_rev
    out = File.join("test","data","out.rev.pac")
    Bio::BWA.pac_rev("#{@testdata}.pac",out)
    md5 = Digest::MD5::hexdigest(File.open(out,"rb") {|f| f.read})
    assert_equal("879cd21435a314f672c7de6d13977d69",md5)
    FileUtils.rm(out)
  end
  
  def test_bwt2sa
    out = File.join("test","data","out.sa")
    Bio::BWA.bwt2sa("#{@testdata}.updated.bwt",out)
    md5 = Digest::MD5::hexdigest(File.open(out,"rb") {|f| f.read})
    assert_equal("948d0ebf6176f61de3ecdc8c085ae88a",md5)
    FileUtils.rm(out)
  end
  
  def test_no_method
    assert_raise NoMethodError do
      Bio::BWA.fake_method("some_file")
    end
  end

end
