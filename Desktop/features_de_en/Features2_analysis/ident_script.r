data<-read.csv("readyformining.csv")

ident<-subset(data, grepl("0.0-17.", data$internal_node_id))

ident2<-ident[
  with(ident, order(subject, trial_index)),
  ]
ident2$stimulus<-as.character(ident2$stimulus)
#subset stimulus rows
ident0<-subset(ident2, trial_type=="audio-keyboard-response")
stimnames<-ident0$stimulus
length(stimnames)
#subset response rows
ident3<-subset(ident2, trial_type=="image-keyboard-response")
nrow(ident3)
#attach stimnames to response rows
ident3$audiostim<-stimnames
ident3$audionodeid<-ident0$internal_node_id

#remove nulls
ident4<-subset(ident3, response!="null")

library(stringr)
ident4$audiostim<-str_remove(ident4$audiostim, "audio_projekt/")
ident4$audiogiven<-str_remove(ident4$audiostim, ".wav")
ident4$audiogiven<-str_remove(ident4$audiogiven, "2")
ident4$pic_choices<-str_remove(ident4$stimulus, "pics/scaled/")
ident4$pic_choices<-str_remove(ident4$pic_choices, ".jpg")
ident4$pic_choices<-str_remove(ident4$pic_choices, ".png")
ident4$pic_choices<-str_remove(ident4$pic_choices, "2")
#I create a col for each picture shown in a trial. It turned out that many pictures were named backwards, so I'll make a "left pic" col which removes the name of the right stimulus for the ones that were correctly named, and removes the name of the left stimulus for those who were incorrectly named.
ident4$leftpic<-ifelse(ident4$pic_choices=="kiel_kuehl" | ident4$pic_choices=="biene_buehne"| ident4$pic_choices=="spielen_spuelen" | ident4$pic_choices=="spulen_spuelen" | ident4$pic_choices=="stiel_stuhl" | ident4$pic_choices=="tier_tour" | ident4$pic_choices=="bieten_beten", sub("_.*", "", ident4$pic_choices),  sub(".*_", "", ident4$pic_choices))

#Now I create a column named rightpic
ident4$rightpic<-ifelse(ident4$pic_choices=="kiel_kuehl" | ident4$pic_choices=="biene_buehne"| ident4$pic_choices=="spielen_spuelen" | ident4$pic_choices=="spulen_spuelen" | ident4$pic_choices=="stiel_stuhl" | ident4$pic_choices=="tier_tour" | ident4$pic_choices=="bieten_beten",  sub(".*_", "", ident4$pic_choices), sub("_.*", "", ident4$pic_choices))

#column with correct responses. If response==q, is left pic
ident4$correct<-ifelse(ident4$audiogiven==ident4$leftpic & ident4$response=="q", 1, 
                       ifelse(ident4$audiogiven==ident4$rightpic & ident4$response=="p", 1, 0))

#CREATE A COL WITH THE CONTRASTS WE'RE INTERESTED IN
ident4$vowelcontrast<-ifelse(ident4$pic_choices=="lieder_leder"| ident4$pic_choices=="siegel_segel", "i/e",
                             ifelse(ident4$pic_choices=="spulen_spuelen"|ident4$pic_choices=="tuer_tour"|ident4$pic_choices=="bluten_blueten", "y/u", 
                                    ifelse(ident4$pic_choices=="tier_tour" | ident4$pic_choices=="spielen_spulen" | ident4$pic_choices=="stiel_stuhl", "i/u", "y/i")))
#save ident4 as ident_data
write.csv(ident4, "ident_data.csv")
