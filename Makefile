MAKEFLAGS += --warn-undefined-variables
SHELL := bash
### SHELLFLAGS included only from gnu make 3.82
    .SHELLFLAGS := -eu -o pipefail -c
    .DEFAULT_GOAL := all
    .DELETE_ON_ERROR:
    .SUFFIXES:


input_dir :=
db_dir :=
regions :=
ref :=
indels :=
snp :=
data_dir :=
align_files :=
output_dir :=
log_dir :=
tmp_dir :=