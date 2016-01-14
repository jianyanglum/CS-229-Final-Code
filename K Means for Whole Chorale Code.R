setwd("/Users/jianyanglum/Documents/year 3 quarter 1/STATS 229/Final Project/Final Dataset")
#indiv = read.csv("Individual Voices Full Dataset.csv")
#indiv$voiceType = factor(indiv$voiceType, levels(indiv$voiceType)[c(3, 1, 4, 2)])
full = read.csv("Whole Chorale Full Dataset.csv")
full$voiceType = factor(full$voiceType, levels(full$voiceType)[c(3, 1, 4, 2)])

install.packages("matrixcalc")
library(matrixcalc)
scaleFull = scale(full[, c(3:ncol(full))])
scaleFull = scaleFull[, -3]
noOfClusters = rep(0, 15)
# avg number of independent voices becomes redundant

for (i in 1:15) {
  kmmFull = kmeans(scaleFull, i, iter.max = 1000)
  centers = kmmFull$centers
  rss = rep(0, i)
  for (j in 1:i) {
    subset = scaleFull[which(kmmFull$cluster == j), ]
    toSubtract = matrix(rep(centers[j, ], each=nrow(subset)), nrow = nrow(subset))
    residuals = subset - toSubtract
    rss[j] = matrix.trace(residuals %*% t(residuals))
  }
  noOfClusters[i] = sum(rss)
}

# After picking K, that is
k = 4
kmmFull = kmeans(scaleFull, k, iter.max = 1000)
centers = kmmFull$centers
rss = rep(0, k)
for (j in 1:k) {
  subset = scaleFull[which(kmmFull$cluster == j), ]
  toSubtract = matrix(rep(centers[j, ], each=nrow(subset)), nrow = nrow(subset))
  residuals = subset - toSubtract
  rss[j] = matrix.trace(residuals %*% t(residuals))
}

plot(noOfClusters, type = "b", main = "Elbow Method: Number of Clusters for Whole Chorale Clustering", xlab = "Number of Clusters", ylab = "Residual Sum of Squares from Cluster Centroid", pch = 18)
write.csv(kmmFull$cluster, file = "K Means Whole Chorale Predicted Cluster Assignments.csv")
write.csv(centers, file = "K Means Whole Chorale Centroids.csv")
library(cluster)
library(fpc)
plotcluster(scaleFull, kmmFull$cluster, xlab = "First Principal Component", ylab = "Second Principal Component", main = "Clustering Results for Different Chorales")
