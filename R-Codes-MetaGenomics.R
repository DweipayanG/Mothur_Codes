# Open R studio > Session (on top) >  Set working directory
getwd()
setwd("Address of the folder") 

#install.packages("tidyr")
#install.packages("readr")


#HEATMAP 

library(tidyr)
library(readr)


count <- read_delim("final.full.count_table",
                    delim = "\t", escape_double = FALSE,
                    trim_ws = TRUE)

contig <- read_delim("final.taxonomy", 
                     delim = "\t", escape_double = FALSE, col_names = FALSE, 
                     trim_ws = TRUE) 

contig_tax <- contig %>% separate(2,sep = ";",into= c("Kingdom","Phylum","Class","Order","Family","Genus","Species"))
contig_tax <- contig_tax[,-8]
View(contig_tax)
head(contig_tax)
OTU <- read.delim("final.opti_mcc.0.03.cons.taxonomy")
OTU_tax <- OTU %>% separate(3,sep = ";",into= c("Kingdom","Phylum","Class","Order","Family","Genus","Species"))
OTU_tax <- OTU_tax[,-9]


# To install packages use following command 
#For ggplot2 
#Install.packages(“ggplot2”)

#For ComplexHeatMap 
#if (!require("BiocManager", quietly = TRUE))
#install.packages("BiocManager")

#BiocManager::install("ComplexHeatmap")

library(ggplot2)
library(ComplexHeatmap)

count_high <- count[count$total >100,]
count_high2 <- count_high[,-c(1,2)]
count_high2 <- log10(count_high2+1)
count_high2  <- as.matrix(count_high2,ncol=19)
#Here for next step make sure how many rows are there in the file 'count_high2' [1:50, 1] in this case, so command is as follows: 
rownames(count_high2) <- count$Representative_Sequence[1:50] 
Heatmap(count_high2, row_names_gp = gpar(fontsize = 7))

OTU_tax_high <- OTU_tax[OTU_tax$Size>5,] #This number 5 0can be diffternt it was set to 100 in ideal code 
OTU_tax_high$Size <- log10(OTU_tax_high$Size+1)
ggplot(data = OTU_tax_high, aes(x = OTU,y=Size, fill=Class)) +
  geom_bar(aes(), stat="identity", position="stack") +
  theme(axis.text.x = element_text(angle=45, vjust=.5, hjust=1,size = 8))

#rarefaction 
rarefaction <- read_delim("final.opti_mcc.groups.ave-std.summary",
                          delim = "\t", escape_double = FALSE,
                          trim_ws = TRUE)
rarefaction_coverage <- rarefaction[rarefaction$method == "ave",]
ggplot(data=rarefaction_coverage,aes(x=group,y=coverage))+ geom_col()+
  theme(axis.text.x = element_text(angle=45, vjust=1, hjust=1,size = 8))

##HEATMAP 
count <- read_delim("final.full.count_table",
                    delim = "\t", escape_double = FALSE,
                    trim_ws = TRUE)
contig <- read_delim("final.taxonomy", delim = "\t",
                     escape_double = FALSE, col_names = FALSE,
                     trim_ws = TRUE)
contig_tax <- contig %>% separate(2,sep = ";",into= c("Kingdom","Phylum","Class","Order","Family","Genus","Species"))
contig_tax <- contig_tax[,-8]

