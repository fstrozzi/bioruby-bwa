$:<<"."
require 'test/helper'
require 'digest/md5'

class TestBioBwa < Test::Unit::TestCase
  
  def setup
    @testdata = File.join("test","data","testdata")
  end
  
  def test_aln
    assert_nothing_raised do
      system("ruby test/run_bwa_aln.rb")
    end
    md5 = Digest::MD5::hexdigest(File.open("#{@testdata}.sai","rb") {|f| f.read})
    assert_equal("56793f4473805683a7d494808c19f79e",md5)
  end
  
  
end