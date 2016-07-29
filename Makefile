MAKEFLAGS += --warn-undefined-variables
SHELL := bash
### SHELLFLAGS included only from gnu make 3.82
    .SHELLFLAGS := -eu -o pipefail -c
    .DEFAULT_GOAL := all
    .DELETE_ON_ERROR:
    .SUFFIXES:


project_dir := /env/export/nfs1/v_projet/EXOMES
db_dir := ${project_dir}/POLRHUMEX/DB_files
regions := ${db_dir}/AllExonsHg19_V5_Regions_150.bed
ref := ${db_dir}/hg19_genome.fa
indels := ${db_dir}/Mills_and_1000G_gold_standard.indels.hg19.vcf
snp := ${db_dir}/dbsnp_135.hg19.vcf
data_dir := ${project_dir}/POLRHUMEX/Alignements
align_files := ${data_dir}/set1/*.bam ${data_dir}/set2/*.bam
output_dir := ${output_dir}/Analyses
log_dir := ${output_dir}/Logs
tmp_dir := ${output_dir}/Tmp