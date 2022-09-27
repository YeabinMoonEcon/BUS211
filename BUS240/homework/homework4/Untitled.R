library(tidyverse)


library(ggrepel)
library(ggthemes)
setwd("~/Documents/ibs_course/BUS240/data")
load('county_map.rda')
load('county_data.rda')

county_full <- left_join(county_map, county_data, by = "id")


As an example of the problem in action, let’s draw two new county-level choropleths. The first is an effort to replicate a poorly-sourced but widely-circulated county map of firearm-related suicide rates in the United States. The su_gun6 variable in county_data (and county_full) is a measure of the rate of all firearm-related suicides between 1999 and 2015. The rates are binned into six categories. We have a pop_dens6 variable that divides the population density into six categories, too.


orange_pal_rev <- c("#A63603", "#E6550D", "#FD8D3C", "#FDAE6B", "#FDD0A2","#FEEDDE")

gun_p <- ggplot(data = county_full,
                mapping = aes(x = long, y = lat,
                              fill = su_gun6, 
                              group = group))

gun_p + geom_polygon() + coord_equal()

gun_p1 <- gun_p + geom_polygon(color = "gray90", size = 0.05) + coord_equal()
gun_p1

gun_p2 <- gun_p1 + scale_fill_brewer(palette="Reds")
gun_p2
gun_p2 + labs(title = "Gun-Related Suicides, 1999-2015", fill = "Rate per 100,000 pop.") +  theme_map() + theme(legend.position = "bottom")


pop_p <- ggplot(data = county_full, mapping = aes(x = long, y = lat,
                                                  fill = pop_dens6, 
                                                  group = group))

pop_p1 <- pop_p + geom_polygon(color = "gray90", size = 0.05) + coord_equal()
pop_p2 <- pop_p1 + scale_fill_brewer(palette="Reds")

pop_p2 + labs(title = "Reverse-coded Population Density",
              fill = "People per square mile") +
  theme_map() + theme(legend.position = "bottom")

############################################################################
party_colors <- c("#2E74C0", "#CB454A")

quant_val <- quantile(county_data$pop)[4]
quant_val2 <- quantile(county_data$pop)[2]

p0 <- ggplot(data = subset(county_data,
                           pop < quant_val),
             mapping = aes(x = pop,
                           y = black/100))
p1 <- p0 + geom_point(alpha = 0.15, color = "gray50")


p2 <- p1 + geom_point(data = subset(county_data,
                                    flipped == "Yes" & pop < quant_val),
                      mapping = aes(x = pop, y = black/100,
                                    color = partywinner16)) +
  scale_color_manual(values = party_colors)

p3 <- p2 + scale_y_continuous(labels=scales::percent) +
  labs(color = "County flipped to ... ",
       x = "County Population",
       y = "Percent Black Population",
       title = "Flipped counties, 2016",
       caption = "Counties in gray did not flip.")
p3
p4 <- p3 + geom_text_repel(data = subset(county_data,
                                         flipped == "Yes" &
                                           pop < quant_val & partywinner16 == "Democrat"),
                           mapping = aes(x = pop,
                                         y = black/100,
                                         label = name), size = 2)



p4 + theme_minimal() +
  theme(legend.position="top")


