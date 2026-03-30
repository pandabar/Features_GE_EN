names<-c("1fss_ns", "8t67_ne", "jw5c_ns", "klvq_ns", "mxr8_ng", "o2oe_ns", "pfem_ns", "rxrx_ns", "ggqa_ng")

for (i in 1:length(names)) {
name<-names[i]
features[i]<- read.csv(paste0("~/Desktop/features_results/raw_by_participant/", name, ".csv"))
}

features_exp_pilot <- read.csv(file)
View(features_exp_pilot)
nrow(features_exp_pilot)
pseudo<-substring(basename(file), 6,7)
#subset by task
discrim<-subset(features_exp_pilot, grepl("0.0-8.0", features_exp_pilot$internal_node_id))
identif<-subset(features_exp_pilot, grepl("0.0-12.0", features_exp_pilot$internal_node_id))
nativeornot<-subset(features_exp_pilot, grepl("0.0-2.0", features_exp_pilot$internal_node_id))
if(pseudo!="ng"){
  nndata<-subset(features_exp_pilot, grepl("0.0-3.0", features_exp_pilot$internal_node_id))
}
nndata$responses<-as.character(nndata$responses)
#rts<-features_exp_pilot$rt
#rts_clean <- rts[ rts != "NULL" ]
#length(rts_clean)
library(RJSONIO)
res <- do.call(rbind.data.frame,
               lapply(nndata$responses, FUN=function(x){ as.list(fromJSON(x))}))

res
View(res)



nrow(discrim)
stimnames<-discrim$stimulus[discrim$stimulus !="<div></div>"]
length(stimnames)
discrim_ok<-subset(discrim, stimulus== "<div></div>")
#Key number 80=P, that is, reponse was "unterschiedlich". Therefore, if key_press==80, then 1 (signal)
unique(discrim_ok$stimulus)
discrim_ok$RESP<-ifelse(discrim_ok$key_press=="80", 1, 0)
levels(discrim_ok$stimulus)
library(stringr)
#create Stimssameordiff col by creating cols containing word 1 and word 2. Then we do if word1==word 2 then same, else different
discrim_ok$stimulus<-str_remove(discrim_ok$stimulus, "audio_projekt/")
discrim_ok$stimulus<-str_remove(discrim_ok$word1, ".wav")
discrim_ok$word1<-sub("1500.*", "", discrim_ok$stimulus)
discrim_ok$word2<-sub(".*1500", "", discrim_ok$stimulus)
discrim_ok$sameordiffstims<-ifelse(discrim_ok$word1 == discrim_ok$word2, 0,1)
#Create a vowelcontrast col where it shows which vowels were being measured. that could be done by creating a vector with the words corresponding to, e.g. /I/ and then using the %in% function
ywords<-c("kuehl", "tuer", "buehne", "spuelen", "blueten")
uwords<-c("tour", "stuhl", "spulen", "bluten")
shortiwords<-c("stillen", "still", "mitte", "schiff", "ritter", "zinn")
longiwords<-c("schief", "spielen", "siegel", "stiel", "tier", "miete", "kiel", "lieder", "biene", "bier")
longewords<-c("zehn", "segel", "stehlen", "leder")
shortewords<-c("baer", "retter", "chef")

discrim_ok$vowel_word1<- ifelse(discrim_ok$word1 %in% ywords , "y",
                                ifelse(discrim_ok$word1 %in% uwords, "u",
                                       ifelse(discrim_ok$word1 %in% shortiwords, "i_short",
                                              ifelse(discrim_ok$word1 %in% longiwords, "i_long",
                                                     ifelse(discrim_ok$word1 %in% longewords, "e_long", "e_short")))))

discrim_ok$vowel_word2<- ifelse(discrim_ok$word2 %in% ywords , "y",
                                ifelse(discrim_ok$word2 %in% uwords, "u",
                                       ifelse(discrim_ok$word2 %in% shortiwords, "i_short",
                                              ifelse(discrim_ok$word2 %in% longiwords, "i_long",
                                                     ifelse(discrim_ok$word2 %in% longewords, "e_long", "e_short")))))

discrim_ok$vowelcontrast<-ifelse(discrim_ok$sameordiffstims == 0, "sames", paste(discrim_ok$vowel_word1, sep="/", discrim_ok$vowel_word2))     
 
discrim_ok$vowelcontrast<-ifelse(discrim_ok$vowel_word1=="y" & discrim_ok$vowel_word2=="u", "u/y",
                                 ifelse(discrim_ok$vowel_word1=="i_long" & discrim_ok$vowel_word2=="e_long", "e_long/i_long",
                                        ifelse(discrim_ok$vowel_word1=="i_long" & discrim_ok$vowel_word2=="y", "y/i_long", 
                                               ifelse(discrim_ok$vowel_word1=="i_long" & discrim_ok$vowel_word2=="u", "u/i_long",
                                                      ifelse(discrim_ok$vowel_word1=="i_long" & discrim_ok$vowel_word2=="i_short", "i_short/i_long",
                                                             ifelse(discrim_ok$vowel_word1=="i_short" & discrim_ok$vowel_word2=="e_short", "e_short/i_short",
ifelse(discrim_ok$vowel_word1=="i_short" & discrim_ok$vowel_word2=="e_long", "e_long/i_short",
  ifelse(discrim_ok$vowel_word1=="i_long" & discrim_ok$vowel_word2=="e_short", "e_short/i_long", paste(discrim_ok$vowel_word1, sep="/", discrim_ok$vowel_word2)))))))))

##Finally we attach the metadata


meta<-rbind(res, res[rep(1, nrow(discrim_ok)-1), ])
alldone<-data.frame(discrim_ok, meta)
