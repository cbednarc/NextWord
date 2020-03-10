# rm(list=ls())

library(data.table)

# setwd("C:/Users/Chris Bednarczyk/Documents/Capstone/Coursera-SwiftKey/")
# numbins = 90
# k = 10

loadngrams <- function(inds, k=0) {

     ngrams = list()
     for (i in 1:5) {
          # print(i)
          firstbin = TRUE
          for (j in inds) {
               # if (j%%10 == 0) {print(j)}
               # print(paste0("   ",j))
               
               tmp = fread(paste0("ngrams/ngrams_",i,"_",j,".csv"))
               
               if (firstbin) {
                    grams = tmp
                    firstbin = FALSE
               } else {
                    grams = rbindlist(list(grams, tmp))
               }
               
               rm("tmp")
          } # loop over bins
          
          # Combine duplicates
          if (i == 1) {
               grams = grams[,.(N=sum(N)),V1]
          } else {
               grams = grams[,.(N=sum(N)),.(ngram,V1,V2)]
          }
          grams = grams[N>k,]
          setorder(grams,-N)
          ngrams[[i]] = grams
          rm("grams")
     }
     
     ngrams
}
