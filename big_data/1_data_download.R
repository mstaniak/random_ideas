install.packages('OpenML')
library(OpenML)
library(dplyr)
library(ggplot2)
library(stringr)

oml_datasets <- OpenML::listOMLDataSets()
oml_datasets

ggplot(oml_datasets, aes(x = number.of.features)) +
    geom_histogram(binwidth = 30) +
    theme_bw()
ggplot(oml_datasets, aes(x = number.of.numeric.features)) +
    geom_histogram(binwidth = 50) +
    xlim(c(0, 2000)) +
    theme_bw()

ggplot(oml_datasets, aes(x = number.of.numeric.features)) +
    geom_histogram(binwidth = 50) +
    xlim(c(100, 1500)) +
    theme_bw()

oml_datasets %>%
    filter(number.of.numeric.features >= 850 & number.of.numeric.features <= 1050)

table(oml_datasets$number.of.numeric.features == 1025)

oml_datasets %>%
    filter(number.of.numeric.features == 1025) %>%
    mutate(name_initial = str_sub(name, 1, 4)) %>%
    # head()
    pull(name_initial) %>%
    unique()

qsar_random <- getOMLDataSet(data.id = 3041)

right_datasets <- oml_datasets %>%
    filter(number.of.numeric.features > 100) %>%
    filter(number.of.numeric.features != 1025)

oml_datasets_big <- vector('list', nrow(right_datasets))
for(i in 1:nrow(right_datasets)) {
    try({
        oml_datasets[[i]] <- getOMLDataSet(data.id = right_datasets[['data.id']][i])
        print(paste0('PULL okay: ', i))
    }, silent = TRUE)
}    
