Select common SNPs

```
~/Documents/programs/plink --bfile 600K/GreatTitsPlink --extract resources/list_common_snps_600K --make-bed --out common_snps/common_snps_600K --chr-set 33
```

```
~/Documents/programs/plink --bfile 10K/Wytham10K --extract resources/list_common_snps_10K --make-bed --out common_snps/common_snps_10K --chr-set 33
```

Replace the loci names with the equivalent from the 600K. Use custom Python script. THIS IS WRONG. IT  SUBSTITUTES EVERYTHING IN ORDER RATHER THAN FINDING THE KEY. NEED TO UPDATE. NOW IT SEEMS TO WORK TRY TOMORROW.

```
python ../../src/substitute_loci_plink.py common_snps/common_snps_10K.bim out resources/equivalence_common_snps_10K_600K.txt
```

Select those individuals that are from Wytham in the 600K dataset

```
~/Documents/programs/plink-1.07-x86_64/plink --bfile common_snps/common_snps_600K --keep resources/wytham_ind_600K --make-bed --out common_snps/common_snps_600K_noduplicates --noweb
```

Tried to merge both datasets but it’s telling me problems with chr27

```
~/Documents/programs/plink --bfile common_snps/common_snps_600K_noduplicates --bmerge common_snps/common_snps_10K.bed common_snps/common_snps_10K.bim common_snps/common_snps_10K.fam --make-bed --out merged_datasets --chr-set 33
```

```
~/Documents/programs/plink-1.07-x86_64/plink --bfile common_snps/merged_datasets --keep resources/unduplicated_ind --make-bed --out common_snps/common_snps_merged_dataset --noweb
```

```
cd common_snps
mkdir tmp_files
mv * tmp_files
mv tmp_files/common_snps_merged_dataset* .
```

Pruning and filtering data. NOTE no sex chromosomes present

```
~/Documents/programs/plink --bfile common_snps/common_snps_merged_dataset --indep-pairwise 1000 50 0.2 --out common_snps/common_snps_pruned --chr-set 33
~/Documents/programs/plink --bfile common_snps/common_snps_merged_dataset --extract common_snps/common_snps_pruned.prune.in --make-bed --out common_snps/common_snps_merged_pruned_dataset --chr-set 33
```

```
~/Documents/programs/plink --bfile common_snps/common_snps_merged_pruned_dataset --geno 0.05 --mind 0.05 --hwe 1e-6 --maf 0.1 --make-bed --out common_snps/common_snps_merged_pruned_dataset_clean --chr-set 33
```

```
~/Documents/programs/plink --bfile common_snps/common_snps_merged_pruned_dataset_clean --make-rel triangle --chr-set 33
```

```
~/Documents/programs/plink --bfile common_snps/common_snps_merged_pruned_dataset_clean -make-grm-gz no-gz --chr-set 33
```

```
~/Documents/programs/plink --bfile common_snps/common_snps_merged_pruned_dataset_clean --pca --chr-set 33
```

600K

```
~/Documents/programs/plink-1.07-x86_64/plink --bfile 600K/GreatTitsPlink --keep resources/wytham_ind_600K --make-bed --out 600K_processed/600K --noweb

~/Documents/programs/plink --bfile 600K_processed/600K --indep-pairwise 1000 50 0.2 --out 600K_processed/600K_pruned --chr-set 33
~/Documents/programs/plink --bfile 600K_processed/600K --extract 600K_processed/600K_pruned.prune.in --make-bed --out 600K_processed/600K_pruned --chr-set 33

~/Documents/programs/plink --bfile 600K_processed/600K_pruned --geno 0.05 --mind 0.05 --hwe 1e-6 --maf 0.1 --make-bed --out 600K_processed/600K_pruned_clean --chr-set 33

#Recode for R format (.raw)
~/Documents/programs/plink --bfile 600K_processed/600K_pruned_clean --recode A --chr-set 33

~/Documents/programs/plink --bfile 600K_processed/600K_pruned_clean --pca --chr-set 33 --out 600K_processed/600K_pca


```

Find inds with no coordinate data

```
pca <- 
  read.table(file.path(data_path,
                             "plink",
                             "600K_processed/600K_pca.eigenvec"),
                    header=F) 

colnames(pca) <- c("dataset", "bto_ring", paste0("PC", seq(1:(dim(pca)[2]-3))))

immigrant_resident <- read.csv(file.path(data_path,
                                          "wytham_ringing_breeding",
                                          "immigrant_resident.csv"))
#Nestbox where they've bred
nb <- read.csv(file.path(data_path,
                         "wytham_ringing_breeding",
                         "Nest_box_habitat_data.csv"))
                         
tmp <- pca[,c(1:21)] %>% 
    left_join(immigrant_resident) %>% 
    left_join(nb) %>% 
  as.tibble()

noNA <- tmp %>%
  filter(is.na(y))

removeInd <- noNA$bto_ring
```

Exclude individuals from spatial PCA and recode to vcf to be able to import to 

```
~/Documents/programs/plink --bfile 600K_pruned_clean --keep remove_ind --make-bed --recode vcf --chr-set 33
```

