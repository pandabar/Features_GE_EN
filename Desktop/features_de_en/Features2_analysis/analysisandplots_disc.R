#plot
library(ggplot2)
library(ggpubr)
dprimes <- read_csv("dfwithdprime_eng.csv")
dprimes$contrast<-as.factor(dprimes$contrast)
p<-ggboxplot(dprimes, x="contrast", y="dprime", add="jitter", color="contrast")
ggpar(p, xlab = "Contrast", ylab = "Sensitivity (d')")

#analysis, dprime by contrast
library(lme4)
library(car)
library(rstatix)
yesorno<- dprimes %>% friedman_test(dprime ~ contrast |subj)
dprimes %>% friedman_effsize(dprime ~ contrast |subj)
pwc<- dprimes %>% wilcox_test(dprime ~ contrast, paired=TRUE, p.adjust.method = "bonferroni", detailed = T) #significant to alpha .05 with outlier, to 0.01 without
pwc

#reg
finalreg<-lmer(dprime~ contrast + (1|subj), data=dprimes)
Anova(finalreg, type="II")
#tried the classic repeated-measures anova
ex1<-aov(dprime~contrast+Error(subj/contrast), data=dprimes)
library(emmeans)
emmeans(finalreg, list(pairwise ~ contrast))

#rts
rtdata <- read_csv("discrim_data_clean.csv")
rtplotdisc<-ggplot(rtdata, aes(x=cont, y=rt, color=trialType)) + geom_jitter(aes(x=cont, y=rt), colour="grey", width=0.2) + geom_boxplot(outlier.shape = NA, alpha = 0.1) + xlab("Stimuli pair") + ylab("Reaction time (ms)") + theme_classic(base_size=12)
rtplotdisc

anothermodel<-lmer(rt ~ vowelcontrast + (1|subject), data=rtdata)
emmeans(anothermodel, list(pairwise ~ vowelcontrast))
rtdatadiff<-subset(rtdata, trialType=="different")
yetanothermodel<-lmer(rt~cont + (1|subject) + (1|stimulus), data=rtdatadiff)
emmeans(yetanothermodel, list(pairwise ~  cont))
