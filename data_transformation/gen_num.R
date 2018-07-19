dat <- read.csv("cybrid_transformed.csv", header = TRUE)
dat$gen.num <- ifelse(dat$gen == "F1", 0, substr(Cy$gen , 3 ,4))
dat$gen.num <- as.numeric(as.character(dat$gen.num))
write.csv(dat, file = "cybrid_transformed.csv", quote = F, row.names = F)
