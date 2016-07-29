MAKEFLAGS += --warn-undefined-variables
SHELL := bash
### SHELLFLAGS included only from gnu make 3.82
    .SHELLFLAGS := -eu -o pipefail -c
    .DEFAULT_GOAL := all
    .DELETE_ON_ERROR:
    .SUFFIXES:

BINDIR=

project_dir := /env/export/nfs1/v_projet/EXOMES
db_dir := ${project_dir}/POLRHUMEX/DB_files
regions := ${db_dir}/AllExonsHg19_V5_Regions_150.bed
ref := ${db_dir}/hg19_genome.fa
indels := ${db_dir}/Mills_and_1000G_gold_standard.indels.hg19.vcf
snp := ${db_dir}/dbsnp_135.hg19.vcf
data_dir := ${project_dir}/POLRHUMEX/Alignements
align_dir := ${data_dir}/set*
output_dir := ${output_dir}/Analyses
log_dir := ${output_dir}/Logs
tmp_dir := ${output_dir}/Tmp
sub_project := polrhumex

### extract file name
define extract_name
$(basename $(notdir $(1)))
endef

### prepare output name
define output_name
${tmp_dir}/$(call extract_name,$(1))_$(2).$(3)
endef



### Haplotype Caller ###
####### mettre java, param et .jar dans des variables
$(call output_name,%,raw_HC,g.vcf): ${align_dir}/%.bam ${ref} ${regions} ${snp}
	java -Xmx2g -jar /env/pack/ARCH/x86_64/bin/GenomeAnalysisTK.jar \
	-T HaplotypeCaller -R $(word 2 $^) -I $(word 1 $^) \
	--dbsnp $(word 4 $^) -L $(word 3 $^) -nda -nda -A GCContent \
	-A VariantType -A ClippingRankSumTest -A DepthPerSampleHC \
	-minReadsPerAlignStart 5 -mbq 10 -stand_call_conf 20 -stand_emit_conf 10 \ 
	-A SnpEff -A QualByDepth -A FisherStrand -ERC GVCF -log ${log_dir}/$(call extract_name,$(word 1 $^)).log \
	-o $@ 

${tmp_dir}gvcf.list: ${tmp_dir}/%_raw_HC.g.vcf 
	ls $^ > $@

$(call output_name,${sub_project},hg19_v5_150,vcf): ${tmp_dir}/gvcf.list ${ref} ${regions} ${snp}
	java -Xmx2g -jar /env/pack/ARCH/x86_64/bin/GenomeAnalysisTK.jar \
	-T GenotypeGVCFs -R $(word 2 $^) -V $(word 1 $^) --dbsnp $(word 2 $^) -L $BED \
	-o $OUTFILE_HC2 -nda -A GCContent -A TandemRepeatAnnotator -A VariantType \
	-log $LOGFILE_HC