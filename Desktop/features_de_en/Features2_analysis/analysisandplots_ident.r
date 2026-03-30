#ANALYSIS
#reg, así a potope
library(lme4)
library(car)
library(optimx)
library(emmeans)
ident4<-read.csv("ident_data.csv")
ident4$vowelcontrast<-as.factor(ident4$vowelcontrast)
ident4$vowelcontrast<-relevel(ident4$vowelcontrast, ref = "i/u")

#reg
thisreg<-glmer(correct  ~ vowelcontrast + (1|subject) + (1|pic_choices), family=binomial, data=ident4)
posthoc<-emmeans(thisreg, list(pairwise ~ vowelcontrast))

#Separate dataframes per contrast, so I can plot
ieident<-subset(ident4, vowelcontrast=="i/e")
calcie<-data.frame(tapply(ieident$correct, list(ieident$subject, ieident$correct), length))
calcie[is.na(calcie)]<- 0
propsie<-c(calcie$X1/12)
iemean<-mean(propsie)
se<- function(x) sd(x)/sqrt(length(x))
seie<-se(propsie)

uyident<-subset(ident4, vowelcontrast=="y/u")
calcuy<-data.frame(tapply(uyident$correct, list(uyident$subject, uyident$correct), length))
calcuy[is.na(calcuy)]<- 0
propsuy<-c(calcuy$X1/18)
uymean<-mean(propsuy)
seuy<-se(propsuy)

uiident<-subset(ident4, vowelcontrast=="i/u")
calcui<-data.frame(tapply(uiident$correct, list(uiident$subject, uiident$correct), length))
calcui[is.na(calcui)]<- 0
propsui<-c(calcui$X1/18)
uimean<-mean(propsui)
seui<-se(propsui)

yiident<-subset(ident4, vowelcontrast=="y/i")
calcyi<-data.frame(tapply(yiident$correct, list(yiident$subject, yiident$correct), length))
calcyi[is.na(calcyi)]<- 0
propsyi<-c(calcyi$X1/18)
yimean<-mean(propsyi)
seyi<-se(propsyi)

contrast<-c("/i-e/", "/u-i/", "/u-y/", "/i-y/")
allmeans<-c(iemean, uimean, uymean, yimean)
allses<-c(seie, seui, seuy, seyi)
margin2<-qt(0.975,df=29-1)*allses/sqrt(29)
margin<-allses*0.95
my_stuff<-data.frame(contrast, allmeans, allses, margin)
my_stuff$contrast<-as.factor(my_stuff$contrast)
write.csv(my_stuff, "barplotidentdf.csv", row.names=F)
#plot
library(ggplot2)
library(plotrix)
my_stuff<-read.csv("barplotidentdf.csv")
ggplot(my_stuff, aes(x=contrast, y=allmeans, fill = contrast)) +
  geom_bar(stat="identity") + labs(x="Contrast", y = "Correct (prop.)")+ theme_classic(base_size = 15) +
  geom_errorbar(aes(x=contrast, ymin=allmeans-margin, ymax=allmeans+margin), width=0.08, colour="black", alpha=0.9, size=1)


#rts
labelnoNA$rt<-as.numeric(labelnoNA$rt)
ggboxplot(labelnoNA, x="vowelcontrast", y="rt", add="jitter")
anothermodel<-lmer(rt ~ vowelcontrast + (1|subject), data=labelnoNA)
emmeans(anothermodel, list(pairwise ~ vowelcontrast))


graph2<-ggplot(spanish, aes(x=vowelcontrast, y=rt, fill=vowelcontrast)) + 
  geom_violin(adjust=1.5) + 
  geom_jitter(width=0.1, alpha=0.5) +
  #geom_boxplot(width=0.1, fill="white") +
  labs(x="Contrast", y="RT (ms)", fill="")
graph2 + scale_fill_manual(values = cols)

