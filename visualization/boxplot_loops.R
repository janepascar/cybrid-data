# plots generation time based on start dates and nauplii dates
# plots productivity time

library(ggplot2)
library(dplyr)
library(ggsignif)
library(gridExtra)
library(ggpubr)

# Import transformed data
Cy <- read.csv("cybrid_transformed.csv", head = TRUE)

####
#### Generation Time Boxplots
####

# Define nuclear and mitochondrial lines
males <- unique(Cy$nuc)
females <- unique(Cy$mito)

# Outer loop : switches between nuclear lines
# Inner loops : switches between mito lines & which date is used to calculate generation time
for (m in males) {
  # first loop plots start.gen.time
  for (f in females) {
    control <- Cy %>%
      # filter for the control crosses BRxBR and SDxSD
      filter(nuc == m, mito == m)
    test <- Cy %>%
      # filter for the cross you want to compare
      filter(nuc == m, mito == f)
    # bind these dataframes together
    a <- rbind(control, test)
    b <- ggplot(a, aes(x = mito, y = start.gen.time, fill = mito)) +
                geom_boxplot() +
                geom_signif(comparisons = list(c(m, f))) +
                facet_grid(~ gen) +
                theme_bw(18) +
                scale_fill_manual(values = c("BR" = "#FFC300", "CAT" = "#BFFF67", "LB" = "#A2FFE8", "LJS" = "#DEA2FF", "SD" = "#A9A9A9", "FHL" = "#FA86C7")) +
                labs(title = paste(m, f, sep = "_")) +
                ylim(20,110) +
                labs(x = "Mitochondrial Line", y = "Generation Time (Days)", title = "")
    name <- paste(m, f, "start", sep = "_")
    assign(name, b)
    #print(b)
  }
  #second loop plots naup.gen.time
  for(f in females) {
    control <- Cy %>%
      filter(nuc == m, mito == m)
    test <- Cy %>%
      filter(nuc == m, mito == f)
    a <- rbind(control, test)
    b <- ggplot(a, aes(x = mito, y = naup.gen.time, fill = mito)) +
      geom_boxplot() +
      geom_signif(comparisons = list(c(m, f))) +
      facet_grid(~ gen) +
      theme_bw(18) +
      scale_fill_manual(values = c("BR" = "#FFC300", "CAT" = "#BFFF67", "LB" = "#A2FFE8", "LJS" = "#DEA2FF", "SD" = "#A9A9A9", "FHL" = "#FA86C7")) +
      labs(title = paste(m, f, sep = "_")) +
      ylim(20,110) +
      labs(x = "Mitochondrial Line", y = "Generation Time (Days)", title = "")
    name <- paste(m, f, "naup", sep = "_")
    assign(name, b)
    #print(b)
  }
}

g <- ggarrange(BR_CAT_start, BR_FHL_start, BR_LJS_start, BR_LB_start, BR_SD_start, ncol = 1, nrow = 5, labels = "AUTO")
h <- ggarrange(BR_CAT_naup, BR_FHL_naup, BR_LJS_naup, BR_LB_naup, BR_SD_naup, ncol = 1, nrow = 5, labels = "AUTO")
i <- ggarrange(SD_CAT_start, SD_FHL_start, SD_LJS_start, SD_LB_start, SD_BR_start, ncol = 1, nrow = 5, labels = "AUTO")
j <- ggarrange(SD_CAT_naup, SD_FHL_naup, SD_LJS_naup, SD_LB_naup, SD_BR_naup, ncol = 1, nrow = 5, labels = "AUTO")

ggsave(g, filename = "BR_gen_start", width = 12, height = 22)
ggsave(h, filename = "BR_gen_naup", width = 12, height = 22)
ggsave(i, filename = "SD_gen_start", width = 12, height = 22)
ggsave(j, filename = "SD_gen_naup", width = 12, height = 22)

#### Locally Weighted Scatterplot Smoothing Regression
Cy$gen.num <- substr(Cy$gen,3,4)
Cy$gen.num <- as.numeric(as.character(Cy$gen.num))

k <- ggplot(Cy, aes(gen.num, start.gen.time, col = mito)) + 
		geom_point() + 
		geom_smooth(method = "loess", se = FALSE) +
		theme_classic(18) + 
		facet_wrap(~nuc) + 
		xlab("Generations after F1") + 
		ylab("Start to Start")
#print(k)
l <- ggplot(Cy, aes(gen.num, naup.gen.time, col = mito)) + 
		geom_point() + 
		geom_smooth(method = "loess", se = FALSE) +
		theme_classic(18) + 
		facet_wrap(~ nuc) + 
		xlab("Generations after F1") + 
		ylab("Nauplii to nauplii")
#print(l)
m <- ggplot(Cy, aes(gen.num, productivity.time, col = mito)) + 
		geom_point() + 
		geom_smooth(method = "loess", se = FALSE) +
		theme_classic(18) + 
		facet_wrap(~ nuc) + 
		xlab("Generations after F1") + 
		ylab("Start to nauplii")
#print(m)
