# EE5731R Visual Computing Project 1
# Saliency Detection
### Ruoteng Li
### A0055830J
### README file

## 1. Files
=================

1. computeSaliencyMaps.m 
2. evaluateSaliencyMaps.m
3. saliencyAlgorithm.m
4. saliencyAlgorithmImprove.m
5. utils/gabor_filter.m
6. utils/differenceOfGaussian.m
7. utils/local_maxima.m
8. utils/scale_normalize.m
9. utils/convolutional_separation.m


## 2. Run
=================

1. To run baseline model, just type
   >> computeSaliencyMaps 

2. To run improved model, please change line 17 in computeSaliencyMaps.m to
   saliencyMap = saliencyAlgorithmImprove(image)
   and run: 
   >> computeSaliencyMaps