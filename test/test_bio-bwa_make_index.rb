
$:<<"."
require 'test/helper'
require 'digest/md5'

class TestBwaIndex < Test::Unit::TestCase
  
  def setup
    @testdata = File.join("test","data","testdata")
  end

  def test_make_index_colorspace
    out = File.join("test","data","out")
    Bio::BWA.make_index(:file_in=>"#{@testdata}.fa",:a => 'is',:prefix => "#{out}", :c => true)
    md5_rbwt = Digest::MD5::hexdigest(File.open("#{out}.rbwt","rb") {|f| f.read})
    md5_rpac = Digest::MD5::hexdigest(File.open("#{out}.rpac","rb") {|f| f.read})
    md5_bwt = Digest::MD5::hexdigest(File.open("#{out}.bwt","rb") {|f| f.read})
    md5_pac = Digest::MD5::hexdigest(File.open("#{out}.pac","rb") {|f| f.read})
    md5_sa = Digest::MD5::hexdigest(File.open("#{out}.sa","rb") {|f| f.read})
    assert_equal("6d6fd723604377dc5d6ad6c0f4f1cdf6",md5_rbwt)
    assert_equal("64838ba5ad44f662266853ebc9451191",md5_rpac)
    assert_equal("12fb7007102154f4bc428ea01a99a6ea",md5_bwt)
    assert_equal("8cb0c5f86a5b927c233e3d5268f01f6a",md5_pac)
    assert_equal("95711a0e5c06419017a02c73d12b99a2",md5_sa)
    FileUtils.rm Dir.glob(out+".*")
  end
  
  def test_make_index
    Bio::BWA.make_index(:file_in=>"#{@testdata}.fa",:a => 'is',:prefix => "#{@testdata}")
    md5_bwt = Digest::MD5::hexdigest(File.open("#{@testdata}.bwt","rb") {|f| f.read})
    md5_pac = Digest::MD5::hexdigest(File.open("#{@testdata}.pac","rb") {|f| f.read})
    assert_equal("4f7ee2b68fade083421d8fd93bf024ec",md5_bwt)
    assert_equal("31ab6686d10cf980b9fc910854a38a7a",md5_pac)
  end
end