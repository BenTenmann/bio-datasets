#!/bin/bash

FILE="$1"

R -e "df <- read.csv('${FILE}', sep = '\\\t', col.names = c('amino_acid', 
                                                            'v_gene', 
                                                            'id', 
                                                            'cancer_type', 
                                                            'unknown', 
                                                            'nucleotide')); 
      lines <- purrr::pmap(df, function(...) rjson::toJSON(list(...))); 
      writeLines(unlist(lines))" -s 
