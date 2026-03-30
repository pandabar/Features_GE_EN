speaker_id<-c("English", "English", "German", "German") 
vowel_id<-c("i", "e", "i", "e") 
context<- NA
F1<-c(333, 611, 329, 431) 
F2<-c(2760, 2186, 2316, 2241)
F3<- NA
F1_glide<-c(NA, 422, NA, NA) 
F2_glide<-c(NA, 2618, NA, NA)
F3_glide<- NA
gereng<-data.frame(speaker_id, vowel_id, context, F1, F2, F3, F1_glide, F2_glide, F3_glide)
write.csv(gereng, "gereng.csv", row.names = FALSE)

library(vowels)
gereng<-read.csv("gereng.csv")
vowelplot(gereng, speaker=NA, color="speakers", color.choice=c("#F8766D", "#7CAE00"),
          shape="speakers", shape.choice=NA, size=NA, labels="vowels",
          leg="speakers", a.size=NA, l.size=NA, subtitle=NA,
          ylim=c(800, 300), xlim=c(2800, 1000))
