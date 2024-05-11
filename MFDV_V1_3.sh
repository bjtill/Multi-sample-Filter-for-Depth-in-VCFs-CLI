#!/bin/bash
#BT May 10, 2024
#Command line version. V1.3 first stable version.

##################################################################################################################################

# Help
[ "$1" = "-h" -o "$1" = "--help" ] && echo "
Multi-sample Filter for Depth in VCFs (MFDV) Version 1.3
ABOUT: 
This filters a multi-sample VCF for depth of each individual in the file.  Many tools can filter for the VCF INFO DP field, that is the combined depth across samples. When there is more than one sample in the VCF, filtering this way can result in some samples with very low depth being included. For example, variant A in a five sample VCF would be retained if three samples had a depth of 50 and two had zero coverage if an INFO DP filter of 20x were used.  This tool that you are now running filters using the FORMAT DP of each sample in the file.  Applying a 20x depth filter in the example variant A would result in the variant being removed from the VCF.  Only variants where each sample has a minimum of 20x will be retained.  

PREREQUISITES:
1) A VCF file with DP repoted in the FORMAT field (most have this).  The VCF can be .vcf or .vcf.gz.
2) Bcftools, bedtools and bgzip 

TO RUN:
1) Provide permission for this program to run on your computer (open a terminal window and type chmod +x Multisample_Filter_for_Depth_in_VCFs_MFDV_V1.sh).  Check to make sure that the name is an exact match to the .sh file you are using as the version may change.

2) Test to see if this works by launching the program without any arguments (./Multisample_Filter_for_Depth_in_VCFs_MFDV_V1.sh). You should should see some information on what you need to do to run the program.  

3) Run the program with the arguments. You need to enter the path of the VCF input file.  If you have problems, run this program in the same directory as the VCF file, and you can skip worrying about paths.  	
	
LICENSE:  
MIT License 
Copyright (c) 2023 Bradley John Till
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the *Software*), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
Version Information:  Version 1.0, May 10, 2024
" && exit

############################################################################################################################

helpFunction()
{
   echo ""
   echo "Usage: $0 -d depth -v path to VCF"
   echo ""
   echo -e "\t-d Depth should be an integer, eg. 20. \n"
   echo -e "\t-v path to your VCF.  Note that spaces in a path will likely cause problems.  If your VCF is on an external drive named My Book, this program will probably not work."
   echo ""
   echo "For more detailed help and to view the license, type $0 -h"
   exit 1 # Exit script after printing help
}

while getopts "d:v:" opt
do
   case "$opt" in
      d ) parameterd="$OPTARG" ;;
      v ) parameterv="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$parameterd" ] || [ -z "$parameterv" ] 
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

############################################################################################################################

log=MFDVt.log
now=$(date)  
echo "Multisample_Filter_for_Depth_in_VCFs (MFDV) command line version 1.3
-h for help
Program Started $now." > $log

OR='\033[0;33m'
NC='\033[0m'
printf "${OR}Multisample_Filter_for_Depth_in_VCFs (MFDV) command line version 1.3
-h for help
Program Started $now.${NC}\n" 

############################################################################################################################
##Determine if there is a control sample (used later)
a=$(cat *.sh | awk -v var=$parameterv 'NR==1 {print var}' | awk -F/ '{print $NF}' | sed 's/.gz//g' | sed 's/.vcf//g')

printf "${OR}Processing VCF file.${NC}\n"
bcftools query -f '%CHROM %POS[\t%DP]\n' $parameterv | awk -v var=$parameterd '{for(i=3;i<=NF;i++)if($i<(var-1))next;print}' | awk '{print $1, $2, $2+1}' | tr ' ' '\t' | bedtools intersect -a $parameterv -b - -header > ${a}_${parameterd}_depth_filtered.vcf
bgzip ${a}_${parameterd}_depth_filtered.vcf

now=$(date)  
echo "Program finished $now." >> $log
printf "${OR}Program finished.${NC}\n"

now=$(date)  
printf "${OR}Program Finished $now. The logfile is named MFDV.log. With the date and time added to the name.${NC}\n" 
b=$(date +"%m_%d_%y_%H_%M")
mv MFDVt.log MFDV_${b}.log 
################################### END OF PROGRAM #############################################################################
