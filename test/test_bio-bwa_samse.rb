$:<<"."
require 'test/helper'
require 'digest/md5'

class TestBioBwa < Test::Unit::TestCase
  
  def setup
    @testdata = File.join("test","data","testdata")
  end
  
  def test_samse
    assert_nothing_raised do 
      system("ruby test/run_bwa_samse.rb")
    end
    md5 = Digest::MD5::hexdigest(File.open("#{@testdata}.sam","rb") {|f| f.read})
    assert_equal("5c523ae7bf18656190fa0bcd8944bd14",md5)
  end
  
end