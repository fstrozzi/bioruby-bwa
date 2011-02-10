#include "main.h"

int main (int argc, char const *argv[])
{
	
	char *se[6];
	se[0] = "bwa_sai2sam_se";
	se[1] = "-f";
	se[2] = "testdata.sam";
	se[3] = "testdata";
	se[4] = "testdata.sai";
	se[5] = "testdata.fa";
	bwa_sai2sam_se(6,se);
	
	char *aln[6];
	aln[0] = "bwa_aln";
	aln[1] = "-f";
	aln[2] = "testdata.sai";
	aln[3] = "testdata";
	aln[4] = "testdata.fa";
	bwa_aln(5,aln);

}