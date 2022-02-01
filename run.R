library(cytomapper)
library(SingleCellExperiment)
library(dplyr)


## Helpers ##

add_channel_names<- function(images, data_dir, lookup_file){
  # name all images based on channels in first image
  # if lookup_file is a file, it will be used to translate tags to marker names
  names_fp <- file.path(data_dir, paste0(names(images[1]), '.csv'))
  channelNames(images) <- read.csv(names_fp , header = F)$V1
  
  # check all same 
  for(i in 1:length(images)){
    ni <- read.csv(file.path(data_dir, paste0(names(images[i]), '.csv')), header = F)$V1
    stopifnot(channelNames(images) == ni)
  }
  
  # check for lookup
  if (file.exists(lookup_file)){
    lookup <- read.csv(lookup_file, row.names = 1)
    stopifnot(names(lookup) ==  c("Target","full","IA","shortname","Clone"))
    channelNames(images) <- lookup[channelNames(images), "Target"]
  }
  
  return(images)
}

asinh_transform <- function(images){
  # like cytomapper::scaleImages
  endoapply(images, asinh)
}

#### 

data_dir <- 'data/DDR_titration_series'
panel_names <- file.path('data/DDR_titration_series/config/Panel.csv')

# Read in images
images <- file.path(data_dir, 'tiffs') %>%
  list.files(pattern = "*full.tiff", full.names = T) %>%
  loadImages(as.is=T) %>%
  add_channel_names(file.path(data_dir, 'tiffs'), lookup_file = panel_names)

# Read in masks
masks <- file.path(data_dir, 'cpout') %>%
  list.files(pattern = "*mask.tiff", full.names = T) %>%
  loadImages(as.is = T)

# Match naming
mcols(images) <- gsub("_full", "", names(images))
mcols(masks) <- gsub("_IA_mask", "", names(masks))


## asinh transform, and scale onto [0,1]
png()
images[1:3] %>% 
  normalize(separateImages = TRUE) %>%
  plotPixels()
dev.off()

png()
images[1:3] %>% 
  normalize(separateImages = FALSE) %>%
  plotPixels()
dev.off()

png()
images[39:44] %>% 
  asinh_transform() %>%
  normalize(separateImages = TRUE) %>%
  plotPixels(colour_by = 'DNA2')
dev.off()

dim(imageData(images[[1]]))

# pixel-level correlations
a <- asinh(imageData(images[[1]]))
a <- t(matrix(a, dim(a)[1]*dim(a)[2], dim(a)[3]))

png()
plot(a[19,], a[20,])
dev.off()


## measure objects in masks
sce <- measureObjects(masks, images, 'X', feature_types = c('basic', 'shape', 'moment', 'haralick'), 
  haralick_feature = paste0( c("asm", "con", "cor", "var", "idm", "sav", "sva", "sen", "ent", "dva", "den", "f12", "f13"), '.s1'))


plotCells(masks[5], object = sce, img_id='X', cell_id = 'object_id', colour_by = 's.area')

sel <- sce[,colData(sce)$object_id %in% c(100, 101, 102, 103, 104)]
plotCells(masks, object = sel, img_id='X', cell_id = 'object_id', colour_by = 'yH2AX')

#corrgram::corrgram(as.matrix(colData(sce)[3:10]))

# get cpixel correlation - whole image
apply(image[[1]], FUN=function(x){unlist(x)}, MARGIN=3) %>%
  as.data.frame() %>%
  cor(.x)[upper.tri(cor(.x))]


# Read in quant

# Cells
cells <- 
  readr::read_csv('data/IR_161121/RescaledCells.csv') %>%
  rename_



cells <- cells[c(1:2, grep("Intensity_MeanIntensity_full_c", colnames(cells)))]


# Nuclei
nucs <- readr::read_csv('data/IR_161121/Nuclei.csv')
nucs <- nucs[c(1:2, grep("Intensity_MeanIntensity_full_c", colnames(nucs)))]


#rename_with(~ newnames[which(oldnames == .x)], .cols = oldnames)


