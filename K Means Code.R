setwd("/Users/jianyanglum/Documents/year 3 quarter 1/STATS 229/Final Project/Final Dataset")
indiv = read.csv("Individual Voices Full Dataset.csv")
indiv$voiceType = factor(indiv$voiceType, levels(indiv$voiceType)[c(3, 1, 4, 2)])
full = read.csv("Whole Chorale Full Dataset.csv")



isAllZeros = rep(FALSE, ncol(full))
for (i in 1:ncol(full)) {
  if (i != 2) {
    if (isAllZero(full[, i])) {
      isAllZeros[i] = TRUE
    }
  }
}

full = full[, c(which(!isAllZeros))]
scaleFull = scale(full[, c(3:ncol(full))])
kmmFull = kmeans(scaleFull, 4, iter.max = 100)
kmmFull.results = cbind(indiv[, 1:2], kmm$cluster)
kmmFull.results$originals = rep(seq(1, 4), nrow(indiv)/4)
table(kmmFull.results$originals, kmmFull.results$`kmm$cluster`)

indiv = indiv[, c(which(!isAllZeros))]
scaleIndiv = scale(indiv[, c(3:ncol(indiv))])
kmm = kmeans(scaleIndiv, 4, iter.max = 3000)
kmm.results = cbind(indiv[, 1:2], kmm$cluster)
kmm.results$originals = rep(seq(1, 4), nrow(indiv)/4)
table(kmm.results$originals, kmm.results$`kmm$cluster`)


centers = kmm$centers
write.csv(centers, file = "K-Means Centers v2.csv")

pcrResult = prcomp(scaleIndiv, scale=TRUE)
newpca1 = pcrResult$rotation[, 1]
pcaMatrixForm1 = as.matrix(newpca1)
prcomp1 = scaleIndiv %*% pcaMatrixForm1
newpca2 = pcrResult$rotation[, 2]
pcaMatrixForm2 = as.matrix(newpca2)
prcomp2 = scaleIndiv %*% pcaMatrixForm2
toPlot = as.data.frame(kmm.results$voiceType)
toPlot = cbind(toPlot, kmm.results$`kmm$cluster`, prcomp1, prcomp2)
names(toPlot) = c("Voice Type", "Cluster Results", "First Principal Component", "Second Principal Component")
plot(toPlot$`First Principal Component`, toPlot$`Second Principal Component`, pch=c('S', 'A', 'T', 'B')[as.numeric(toPlot$`Voice Type`)], col = c('red', 'green', 'blue', 'black')[toPlot$`Cluster Results`], xlab = "First Principal Component", ylab = "Second Principal Component", main = "Cluster Results")

library(cluster)
install.packages("HSAUR")
library(HSAUR)
disse = daisy(scaleIndiv)
dE2 = disse^2
sk2 = silhouette(kmm$cluster, dE2)
plot(sk2)
library(cluster)
install.packages("fpc")
library(fpc)

install.packages("extrafont")
library(extrafont)
loadfonts()
font_import()

plotcluster(scaleIndiv, kmm$cluster, xlab = "First Principal Component", ylab = "Second Principal Component", main = "Clustering Results for Different Voices")
text(locator(1), "4 = Soprano\n3 = Alto\n2 = Tenor\n1 = Bass")

install.packages("gridExtra")
library(gridExtra)
newTable = table(kmm.results$voiceType, kmm.results$`kmm$cluster`)
