#   Install Package:           'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

library(pbapply)
library(parallel)
library(feather)
library(data.table)
library(dplyr)
library(dqrng)
library(anytime)
library(ggplot2)

# Helpers
factor_to_int = function (x) { as.numeric(as.character(x)) }
