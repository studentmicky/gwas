#!/bin/sh
#Take GWAS output file and find top hits and overlap with genes
#Use editBedPos.sh to alter window size of genes
#getTopHits.py needed

TRAIT=height
DIR=/Users/rotation/downloads/afr_summary_stats/test
GWAS_FILE=$DIR/1.mlma
GENE_FILE=/Users/rotation/downloads/all-genes/genes_RefSeq_200000kb.bed
QUANTILE=0.0001
PYTHON_SCRIPT_LOC=/Users/rotation/OneDrive/Tishkoff/scripts

cd ${DIR}
mkdir ${TRAIT}_tophits$QUANTILE
cd ${TRAIT}_tophits$QUANTILE

python $PYTHON_SCRIPT_LOC/getTopHits.py -o ./${TRAIT}_tophits.tsv \
-i $GWAS_FILE -q $QUANTILE

awk -v OFS='\t' 'FNR > 1 { print "chr" $2,$4-1,$4 }' ${TRAIT}_tophits.tsv > \
${TRAIT}_tophits.bed

bedtools intersect -c -a $GENE_FILE -b ${TRAIT}_tophits.bed \
> ./enriched_genes_${TRAIT}_${QUANTILE}.bed
