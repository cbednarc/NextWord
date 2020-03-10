source("loadngrams.R")
source("predictNextWord.R")

# Create training, testing, and validation data
set.seed(1234)
numtrain = 10
k = 1
numtest = 1e3

inds.all = sample(1:100, numtrain+2)
inds.train = inds.all[1:numtrain]
inds.test = inds.all[numtrain+1]
inds.validate = inds.all[numtrain+2]

ngrams.train = loadngrams(inds.train, k=k)
# save(ngrams.train, file="ngramsForApp.Rdata")

ngrams.test = loadngrams(inds.test)
save(ngrams.test, file="ngramsForTesting.Rdata")

numtest.all = rep(0, 5)
numcorrect.all = rep(0, 5)
for (i in 2:5) {
     # print(i)
     set.seed(1234)
     n = nrow(ngrams.test[[i]])
     inds = sample(1:n, numtest)
     ngrams.test[[i]] = ngrams.test[[i]][inds,]
     for (j in 1:numtest) {
          # Input phrase
          inputphrase = ngrams.test[[i]][["V1"]][j]
          # Use input phrase and training ngramsList to predict next word.
          predword = predictNextWord(inputphrase, ngramsList=ngrams.train)
          # Correct next word.
          correctword = ngrams.test[[i]][["V2"]][j]
          # Count number of correct predictions.
          numcorrect.all[i] = numcorrect.all[i] + (predword == correctword)
     
     }
     numtest.all[i] = numtest
}
# print(numcorrect.all/numtest.all)
