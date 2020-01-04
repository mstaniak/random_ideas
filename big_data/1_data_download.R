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
    filter(number.of.numeric.features != 1025) %>%
    filter(number.of.features < 20000) %>%
    filter(format == 'ARFF')
max(right_datasets[['number.of.features']])
ggplot(right_datasets, aes(x = number.of.features)) +
    geom_histogram(binwidth = 50) +
    theme_bw()
# table(right_datasets[['number.of.features']])
# right_datasets %>%
#     filter(number.of.features == 10937)
# clearOMLCache()
for(i in 1:nrow(right_datasets)) {
    tryCatch({
        dataset <- getOMLDataSet(data.id = right_datasets[['data.id']][i])
        print(paste0('PULL okay: ', i))
        saveRDS(dataset, file = paste0('./data/dataset_', i, ".RDS"))
        rm(dataset)
        clearOMLCache()
    }, error = function(e) print(paste0('PULL failed: ', i, ' ', e)))
}    
