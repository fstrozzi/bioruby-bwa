$:<<"."
require 'test/helper'
require 'digest/md5'

class TestBioBwa < Test::Unit::TestCase
  
  def setup
    @testdata = File.join("test","data","testdata")
  end
  
  def test_aln
    #Bio::BWA.aln("#{@testdata}","#{@testdata}.fa",:f=>"#{@testdata}.aln")
  end
  
  
end