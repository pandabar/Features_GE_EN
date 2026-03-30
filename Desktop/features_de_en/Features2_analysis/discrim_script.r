data<-read.csv("readyformining.csv")

discrim<-subset(data, grepl("0.0-10.0", data$internal_node_id))

#we sort data by subject and then by trial index
discrim2<-discrim[
  with(discrim, order(subject, trial_index)),
  ]
#We remove the rows with no data
nrow(discrim2)
stimnames<-discrim2$stimulus[discrim2$stimulus !="<div></div>"]
length(stimnames)
discrim3<-subset(discrim2, stimulus== "<div></div>")
discrim3$stimulus<-stimnames

#Now we create a column for the responses called RESP.If response==p, then 1 (signal)
unique(discrim3$stimulus)
discrim3$RESP<-ifelse(discrim3$response=="p", 1, 0)

library(stringr)
#create Stimssameordiff col by creating cols containing word 1 and word 2. Then we do if word1==word 2 then same, else different
discrim3$stimulus<-str_remove(discrim3$stimulus, "audio_projekt/")
discrim3$stimulus<-str_remove(discrim3$stimulus, ".wav")
discrim3$word1<-sub("1500.*", "", discrim3$stimulus)
discrim3$word2<-sub(".*1500", "", discrim3$stimulus)
discrim3$sameordiffstims<-ifelse(discrim3$word1 == discrim3$word2, 0,1)

#Create a vowelcontrast col where it shows which vowels were being measured. that could be done by creating a vector with the words corresponding to, e.g. /I/ and then using the %in% function
unique(discrim3$word1)
unique(discrim3$word2)

ywords<-c("kuehl", "tuer", "buehne", "spuelen", "blueten")
uwords<-c("tour", "stuhl", "spulen", "bluten")
longiwords<-c("spielen", "siegel", "stiel", "tier", "kiel", "lieder", "biene")
longewords<-c("leder", "segel")
#we create column where it shows which vowels are in the words

discrim3$vowel_word1<- ifelse(discrim3$word1 %in% ywords , "y",
                                ifelse(discrim3$word1 %in% uwords, "u",
                                              ifelse(discrim3$word1 %in% longiwords, "i_long", "e_long")))

discrim3$vowel_word2<- ifelse(discrim3$word2 %in% ywords , "y",
                                ifelse(discrim3$word2 %in% uwords, "u",
                                              ifelse(discrim3$word2 %in% longiwords, "i_long", "e_long")))

#Now, since y/u and u/y are the same contrast, I group them as one.

discrim3$vowelcontrast<-ifelse(discrim3$sameordiffstims == 0, "sames", paste(discrim3$vowel_word1, sep="/", discrim3$vowel_word2))     
#we rewrite the column by stating that y/u is u/y, i/e is e/e, etc.
discrim3$vowelcontrast<-ifelse(discrim3$vowel_word1=="y" & discrim3$vowel_word2=="u", "u/y",
                                 ifelse(discrim3$vowel_word1=="i_long" & discrim3$vowel_word2=="e_long", "e_long/i_long",
                                        ifelse(discrim3$vowel_word1=="i_long" & discrim3$vowel_word2=="y", "y/i_long", 
                                               ifelse(discrim3$vowel_word1=="i_long" & discrim3$vowel_word2=="u", "u/i_long", paste(discrim3$vowel_word1, sep="/", discrim3$vowel_word2)))))

#tHE COLUMN "tributesto" joins the sames and the differents that tribute to one contrast. HOWEVER, there is a problem: the words spielen, spulen, spuelen, and tour have a double militancy. So: we'll build a dataframe and then go through the new cols with a match 

words<-c("spielen1500spielen", "spulen1500spulen", "spuelen1500spuelen", "tour1500tour", "tier1500tier", "tuer1500tuer")
tributesto<-c("u/i", "u/i", "y/i", "u/i", "y/i", "y/i")
tributesto2<-c("y/i", "u/y", "u/y", "u/y", "u/i", "u/i")
doublets<-data.frame(words, tributesto, tributesto2, stringsAsFactors = F)
doublets$tributesto<-as.character(doublets$tributesto)
doublets$tributesto2<-as.character(doublets$tributesto2)

discrim3$tributesto<-ifelse(discrim3$vowelcontrast=="u/i_long" | discrim3$stimulus=="stiel1500stiel" | discrim3$stimulus=="stuhl1500stuhl", "u/i",
                                       ifelse(discrim3$stimulus %in% doublets$words==T, doublets$tributesto[match(discrim3$stimulus, doublets$words)],                                         
                                        ifelse(discrim3$vowelcontrast=="u/y" | discrim3$stimulus=="bluten1500bluten" | discrim3$stimulus=="blueten1500blueten" | discrim3$stimulus=="tuer1500tuer", "u/y", 
                                               ifelse(discrim3$vowelcontrast=="y/i_long" | discrim3$stimulus=="kiel1500kiel" | discrim3$stimulus=="kuehl1500kuehl" | discrim3$stimulus=="biene1500biene" | discrim3$stimulus=="buehne1500buehne", "y/i", "i/e" ))))

discrim3$tributesto2<-ifelse(discrim3$stimulus %in% doublets$words==T, doublets$tributesto2[match(discrim3$stimulus, doublets$words)],   "0")
unique(discrim3$subject)
###I REALIZED THAT THERE ARE NULL RESPONSES. WE WILL REMOVE THEM NOW =11 TOTAL
discrim4<-subset(discrim3, response!="null")

###ANALYSIS
#subset by contrast
ie<-subset(discrim4, tributesto=="i/e"| tributesto2=="i/e")
uy<-subset(discrim4, tributesto=="u/y"| tributesto2=="u/y")
ui<-subset(discrim4, tributesto=="u/i"| tributesto2=="u/i")
yi<-subset(discrim4, tributesto=="y/i"| tributesto2=="y/i")

#split by id
ieid<-split(ie, as.character(ie$subject))
uyid<-split(uy, as.character(uy$subject))
uiid<-split(ui, as.character(ui$subject))
yiid<-split(yi, as.character(yi$subject))


#contingency tables
for (i in 1:length(ieid)) {
  ieid[[i]]<-table(as.character(ieid[[i]]$vowelcontrast), as.character(ieid[[i]]$response))
}
for (i in 1:length(uyid)) {
uyid[[i]]<-table(as.character(uyid[[i]]$vowelcontrast), as.character(uyid[[i]]$response))
}

for (i in 1:length(uiid)) {
  uiid[[i]]<-table(as.character(uiid[[i]]$vowelcontrast), as.character(uiid[[i]]$response))
}

for (i in 1:length(yiid)) {
  yiid[[i]]<-table(as.character(yiid[[i]]$vowelcontrast), as.character(yiid[[i]]$response))
}

#this loop collapses signals with noises and adds row and column names
# spanish
for (i in 1:length(ieid)) {
  ieid[[i]]<-rbind(ieid[[i]][1,] + ieid[[i]][3,],  ieid[[i]][2,])+0.5
  dimnames(ieid[[i]]) = list(c("noiseei", "signalei"), c("rdiff", "rsame"))
} 

for (i in 1:length(uyid)) {
  uyid[[i]]<-rbind(uyid[[i]][1,] + uyid[[i]][3,],  uyid[[i]][2,])+0.5
  dimnames(uyid[[i]]) = list(c("noiseuy", "signaluy"), c("rdiff", "rsame"))
} 

for (i in 1:length(uiid)) {
  uiid[[i]]<-rbind(uiid[[i]][1,] + uiid[[i]][3,],  uiid[[i]][2,])+0.5
  dimnames(uiid[[i]]) = list(c("noiseui", "signalui"), c("rdiff", "rsame"))
} 

for (i in 1:length(yiid)) {
  yiid[[i]]<-rbind(yiid[[i]][1,] + yiid[[i]][3,],  yiid[[i]][2,])+0.5
  dimnames(yiid[[i]]) = list(c("noiseyi", "signalyi"), c("rdiff", "rsame"))
} 

#this loop calculates dprime by subject. Note that since the cols are reversed (diff same) I changed the order of the cells
#the cell order for correct calculation is samediff(samesame, diffsame, samediff, diffdiff)
library(mysensR)
#spanish
idei<-vector("list", length(ieid))
for (i in 1:length(ieid)) {
  idei[[i]]<-as.matrix(summary(mysensR::samediff(ieid[[i]][1,2], ieid[[i]][1,1], ieid[[i]][2,2], ieid[[i]][2,1]))[[10]])
}

iduy<-vector("list", length(uyid))
for (i in 1:length(uyid)) {
  iduy[[i]]<-as.matrix(summary(mysensR::samediff(uyid[[i]][1,2], uyid[[i]][1,1],uyid[[i]][2,2], uyid[[i]][2,1]))[[10]])
}

idui<-vector("list", length(uiid))
for (i in 1:length(uiid)) {
  idui[[i]]<-as.matrix(summary(mysensR::samediff(uiid[[i]][1,2], uiid[[i]][1,1],uiid[[i]][2,2], uiid[[i]][2,1]))[[10]])
}

idyi<-vector("list", length(yiid))
for (i in 1:length(yiid)) {
  idyi[[i]]<-as.matrix(summary(mysensR::samediff(yiid[[i]][1,2], yiid[[i]][1,1],yiid[[i]][2,2], yiid[[i]][2,1]))[[10]])
}

#and this loop creates a vector of dprime values
#spanish
dprimeei<-vector("numeric", length(idei))
for (i in 1:length(idei)) { 
  dprimeei[i]<-idei[[i]][2] 
}
dprimeuy<-vector("numeric", length(iduy))
for (i in 1:length(iduy)) { 
  dprimeuy[i]<-iduy[[i]][2] 
}
dprimeui<-vector("numeric", length(idui))
for (i in 1:length(idui)) { 
  dprimeui[i]<-idui[[i]][2] 
}

dprimeyi<-vector("numeric", length(idyi))
for (i in 1:length(idyi)) { 
  dprimeyi[i]<-idyi[[i]][2] 
}

###Is this statistically significant? I'll run a friedman test
#first I build a dataframe
ids<-unique(as.character(discrim4$subject))
mydf<-data.frame(id=ids, phondiff=dprimeei, frontback=dprimeui, rounded=dprimeuy, front=dprimeyi)
colnames(mydf)<-c("id", "/i-e/", "/u-i/", "/u-y/", "/y-i/")
test<-data.frame(subj=rep(mydf$id, 4), contrast=stack(mydf, select= c(-id)))
colnames(test)<-c("subj", "dprime", "contrast")
####

##############REACTION TIMES######################
discrim4$rt<-as.numeric(discrim4$rt)
discrim4$trialType<-ifelse(discrim4$sameordiffstims==0, "same", "different")
discrim4$cont<-ifelse(discrim4$vowelcontrast=="e_long/e_long", "e/e", 
                      ifelse(discrim4$vowelcontrast=="i_long/i_long","i/i",
                             ifelse(discrim4$vowelcontrast=="e_long/i_long", "e/i",
                                    ifelse(discrim4$vowelcontrast=="u/y", "u/y",
                                           ifelse(discrim4$vowelcontrast=="y/y", "y/y",
                                                  ifelse(discrim4$vowelcontrast=="u/u", "u/u",
                                                         ifelse(discrim4$vowelcontrast=="u/i_long", "u/i", "i/y")))))))

#Save rearranged data to file 
write.csv(discrim4, "discrim_data_clean.csv", row.names = FALSE)
#Save test df to file
write.csv(test, "dfwithdprime_eng.csv", row.names = FALSE)
