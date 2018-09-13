library(dplyr);library(ggplot2);library(ggalt);library(ggExtra)
dat <- read.csv(file = "cybrid_transformed.csv", header = T)

mit <- unique(dat$mito)

for (m in mit) {
  a <- dat %>%
    dplyr::filter(mito == m)
  name <- paste(m, sep = "")
  assign(name, a)
}

dat$gen <- factor(dat$gen, levels = c("F1", "BC1", "BC2", "BC3", "BC4", "BC5", "BC6", "BC7", "BC8", "BC9"))


ggplot(dat, aes(x = gen.num, y = start.gen.time)) +
  geom_jitter(alpha = .75, aes(color = mito)) +
  scale_colour_viridis_d() +
  scale_x_continuous(expand=c(0.02,0)) +
  scale_y_continuous(expand=c(0.02,0)) +
  theme_bw() +
  NULL
theme0 <- function(...) theme( legend.position = "none",
                               panel.background = element_blank(),
                               panel.grid.major = element_blank(),
                               panel.grid.minor = element_blank(),
                               panel.margin = unit(0,"null"),
                               axis.ticks = element_blank(),
                               axis.text.x = element_blank(),
                               axis.text.y = element_blank(),
                               axis.title.x = element_blank(),
                               axis.title.y = element_blank(),
                               axis.ticks.length = unit(0,"null"),
                               axis.ticks.margin = unit(0,"null"),
                               panel.border=element_rect(color=NA),...)
b <- ggplot(dat, aes(x=gen.num, colour=mito, fill=mito)) + 
  geom_density(alpha=0.5) + 
  scale_x_continuous(breaks=NULL,expand=c(0.02,0)) +
  scale_y_continuous(breaks=NULL,expand=c(0.02,0)) +
  theme_bw() +
  scale_colour_viridis_d() +
  scale_fill_viridis_d() +
  theme0(plot.margin = unit(c(1,0,0,2.2),"lines")) +
  NULL
c <- ggplot(dat, aes(x=start.gen.time, colour=mito, fill=mito)) + 
  geom_density(alpha=0.5) + 
  coord_flip()  + 
  scale_colour_viridis_d() +
  scale_fill_viridis_d() +
  scale_x_continuous(labels = NULL,breaks=NULL,expand=c(0.02,0)) +
  scale_y_continuous(labels = NULL,breaks=NULL,expand=c(0.02,0)) +
  theme_bw() +
  theme0(plot.margin = unit(c(0,1,1.2,0),"lines")) +
  NULL


grid.arrange(arrangeGrob(a,c,ncol=2,widths=c(1,1)),
             heights=c(1,1))
