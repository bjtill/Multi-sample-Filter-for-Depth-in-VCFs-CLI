# Multi-sample-Filter-for-Depth-in-VCFs-CLI
Tool for filtering a multi-sample VCF for minimum depth of each sample.
_____________________________________________________________________________________________________________________________________

Use at your own risk.

I cannot provide support. All information obtained/inferred with this script is without any implied warranty of fitness for any purpose or use whatsoever.

ABOUT: 

This tool filters a multi-sample VCF for depth of each individual in the file.  Many tools can filter at the VCF INFO DP field, that is the combined depth across samples. When there is more than one sample in the VCF, filtering this way can result in some samples with very low depth being included. For example, variant A in a five sample VCF would be retained if three samples had a depth of 50 and two had zero coverage if an INFO DP filter of 20x were used.  This program filters using the FORMAT DP of each sample in the file.  Applying a 20x depth filter in the example variant A would result in the variant being removed from the VCF.  Only variants where each sample has a minimum of 20x will be retained.  

PREREQUISITES:

1) A VCF file with DP repoted in the FORMAT field (most have this).  The VCF can be .vcf or .vcf.gz.
2) Bcftools, bedtools and bgzip 

TO RUN:

1) Provide permission for this program to run on your computer (open a terminal window and type chmod +x MFDV_V1_3.sh).  Check to make sure that the name is an exact match to the .sh file you are using as the version may change.

2) Test to see if this works by launching the program without any arguments (./MFDV_V1_3.sh). You should should see some information on what you need to do to run the program.   

3) Run the program with the arguments. The command line options are -d for depth and -v for the path to the VCF. You need to enter the path of the VCF input file.  If you have problems, run this program in the same directory as the VCF file, and you can skip worrying about paths.

OUTPUTS:

1) A compressed VCF file (using bgzip) containing all variants where all samples in the VCF. This VCF retains the original VCF name plus the depth of filtration used.

2) A log file with a date and time stamp.  
	
