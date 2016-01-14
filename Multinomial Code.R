setwd("/Users/jianyanglum/Documents/year 3 quarter 1/STATS 229/Final Project/Final Dataset")
indiv = read.csv("Individual Voices Full Dataset.csv")
indiv$voiceType = factor(indiv$voiceType, levels(indiv$voiceType)[c(3, 1, 4, 2)])
full = read.csv("Whole Chorale Full Dataset.csv")
full$voiceType = factor(full$voiceType, levels(full$voiceType)[c(3, 1, 4, 2)])

require(foreign)
require(nnet)
require(ggplot2)
require(reshape2)
require(caret)

j = 10
flds <- createFolds(indiv$voiceType, k = j, list = TRUE, returnTrain = FALSE)
predError = rep(0, j)
for (i in 1:j) {
  indivClean = indiv[, 2:ncol(indiv)]
  train = indivClean[-flds[[i]], ]
  test = indivClean[flds[[i]], ]
  res = multinom(voiceType~., data=train)
  predResult = predict(res, newdata=test[ ,c(2:ncol(test))])
  rightPred = predResult == test$voiceType
  predError[i] = 1 - mean(rightPred)
}
error = mean(predError)
# 0.2553509


kFoldsSample2 = kFoldsSample[-1]
plot(seq(2:20), kFoldsSample2)
plot(seq(2:20), kFoldsSample2, type="b", xlab = "Number of Folds (CV)", ylab = "Average CV Error Rate", pch=18, main="Comparing k-Fold CV error rate")
kFolds = which(min(kFoldsSample2) == kFoldsSample2)


indivClean = indiv[, 2:ncol(indiv)]
train = indivClean
test = indivClean[flds[[1]], ]
res = multinom(voiceType~., data=train)
z = summary(res)$coefficients/summary(res)$standard.errors
p <- (1 - pnorm(abs(z), 0, 1)) * 2
results = exp(coef(res))
multinomialResults = rbind(results, p)
write.csv(multinomialResults, file = "Multinomial Logistic Regression Results, Coefs and P Values for K = 10")


## Interpretation of P results: only those with p-values less than 0.05 (95% CI) will be of any use to use - 
## that proves that for that particular variable the coefficient is statistically significant.
dwrite = data.frame()
for (i in 1:7) {
  if (i == 3) {
    vec = seq(min(indivClean$averageMelodicInterval), max(indivClean$averageMelodicInterval), by = 0.05)
  } else {
    vec = rep(mean(indivClean[,i + 1]), 71)
  }
  if (i == 1) {
    dwrite = as.data.frame(vec)
  } else {
    dwrite = cbind(dwrite, vec)
  }
  names(dwrite)[i] = names(indivClean)[i+1]
}

pp.write <- cbind(dwrite, predict(res, newdata = dwrite, type = "probs", se = TRUE))
by(pp.write[, 8:11], pp.write$ses, colMeans)
