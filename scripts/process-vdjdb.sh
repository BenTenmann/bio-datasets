#!/bin/bash

FILE="$1"

cat ${FILE} | jq -R -r '. | fromjson | 
    {antigen: {epitope: .antigen_epitope,
               gene: .antigen_gene,
               species: .antigen_species},
    cdr3: {alpha: (if .cdr3_alpha then [.cdr3_alpha] else [] end),
           beta: (if .cdr3_beta then [.cdr3_beta] else [] end)},
    d_gene: {beta: .d_beta}, 
    j_gene: {alpha: .j_alpha, beta: .j_beta}, 
    meta: {cell_subset: .meta_cell_subset,
           clone_id: .meta_clone_id,
           donor_mhc: (.meta_donor_MHC // "" | split(";") | map(split(","))),
           donor_mhc_method: .meta_donor_MHC_method,
           epitope_id: .meta_epitope_id,
           replica_id: .meta_replica_id,
           structure_id: .meta_structure_id,
           study_id: .meta_study_id,
           subject_cohort: .meta_subject_cohort,
           subject_id: .meta_subject_id,
           tissue: .meta_tissue},
    method: {frequency: .method_frequency,
             identification: .method_identification,
             sequencing: .method_sequencing,
             single_cell: .method_singlecell,
             verification: .method_verification},
    mhc: {a: .mhc_a,
          b: .mhc_b,
          class: .mhc_class},
    reference_id: .reference_id,
    v_gene: {alpha: .v_alpha, beta: .v_beta},
    vdjdb_score: .vdjdb_score} | @json'
