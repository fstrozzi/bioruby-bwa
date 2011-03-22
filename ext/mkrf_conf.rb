# create Rakefile for shared library compilation

require File.join("..",File.dirname(__FILE__),"lib/bio/bwa/library")

path = File.expand_path(File.dirname(__FILE__))

ext = Bio::BWA::Library.lib_extension

flags = ""
compile = ""
if ext == "so" then 
  flags = "-shared -Wl,-soname,libbwa.so"
  compile = " -fPIC"
elsif ext == "dylib" then 
  flags = "-bundle -undefined dynamic_lookup -flat_namespace"
end


File.open(File.join(path,"Rakefile"),"w") do |rakefile|
rakefile.write <<-RAKE
require 'rake/clean'
    
source = %w(utils.c bwt.c bwtio.c bwtaln.c bwtgap.c is.c bntseq.c bwtmisc.c bwtindex.c stdaln.c simple_dp.c bwaseqio.c bwase.c bwape.c kstring.c cs2nt.c bwtsw2_core.c bwtsw2_main.c bwtsw2_aux.c bwt_lite.c bwtsw2_chain.c bamlite.c main.c)
    
CLEAN.include('*.o')
CLEAN.include('bwt_gen/*.o')

GEN = FileList['bwt_gen/*.c']
OBJ_GEN = GEN.ext('o')
SRC = FileList.new(source)
OBJ_SRC = SRC.ext('o')    

rule '.o' => '.c' do |t|
  sh "gcc#{compile} -c -g -Wall -O2 -DHAVE_PTHREAD "+t.source+" -o "+t.name
end
    
task :compile_gen => OBJ_GEN do
  sh "ar -cru bwt_gen/libbwtgen.a "+OBJ_GEN.join(" ")
end
    
task :compile_lib => OBJ_SRC do
  sh "gcc #{flags} "+OBJ_SRC.join(" ")+" -o libbwa.#{ext} -lm -lz -lpthread -Lbwt_gen -lbwtgen"
end
  
task :default => [:compile_gen, :compile_lib, :clean]
  
RAKE
  
end
  
  

