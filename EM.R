setwd("/Users/jianyanglum/Documents/year 3 quarter 1/STATS 229/Final Project/Final Dataset")
#indiv = read.csv("Individual Voices Full Dataset.csv")
#indiv$voiceType = factor(indiv$voiceType, levels(indiv$voiceType)[c(3, 1, 4, 2)])
full = read.csv("Whole Chorale Full Dataset.csv")
full$voiceType = factor(full$voiceType, levels(full$voiceType)[c(3, 1, 4, 2)])
scaleFull = scale(full[, c(3:ncol(full))])
scaleFull = scaleFull[, -3]


install.packages("mclust")
library(mclust) 
model = Mclust(scaleFull)

BIC = mclustBIC(scaleFull)
plot(BIC)
plot(model)
newModel = Mclust(scaleFull, G = 4)
##densityOld = densityMclust(scaleFull)
dimRed = MclustDR(model)
plot.MclustDR(dimRed)

dimRed4 = MclustDR(newModel)
plot.MclustDR(dimRed4)
full$EM2GroupsClassification = model$classification
full$EM4GroupsClassification = newModel$classification

write.csv(full, file = "Full Chorales with EM Clustering Assignments.csv")
