#!/bin/bash

FILE="$1"
TMP="${FILE%.csv}.jsonl"

SCRIPT="import pandas as pd
import srsly

df = pd.read_csv('${FILE}', encoding='windows-1252', low_memory=False)
df = df.where(pd.notnull(df), None)

srsly.write_josnl('${TMP}', df.to_dict(orient='records'))"
python3 -c ${SCRIPT} 

cat ${TMP} | jq -R -r '. | fromjson |
    {
        cdr3: {amino_acid: {alpha: (if .cdr3_alpha_aa then [.cdr3_alpha_aa] else [] end), 
                            beta: (if .cdr3_beta_aa then [.cdr3_beta_aa] else [] end)},
               nucleotide: {alpha: (if .cdr3_alpha_nt then [.cdr3_alpha_nt] else [] end),
                            beta: (if .cdr3_beta_nt then [.cdr3_beta_nt] else [] end)}
                        },
        antigen: {id: .protein_id, name: .antigen_protein, 
                  pathogen: {id: .pathology_mesh_id, name: .pathology},
                  epitope: {id: .epitope_id, sequence: .epitope_peptide}},
        v_gene: {alpha: .trav, beta: .trbv},
        d_gene: {alpha: null, beta: .trbd},
        j_gene: {alpha: .traj, beta: .trbj},
        meta: {study_details: .additional_study_details, 
               remarks: .remarks, 
               pmid: .pubmed_id, 
               category: .category},
        method: {ngs: .ngs, 
                 single_cell: .single_cell,
                 species: .species,
                 strain: .mouse_strain,
                 tissue: .tissue,
                 antigen_identification: .antigen_identification_method},
        t_cell: {type: .t_cell_type, characteristics: ((.t_cell_characteristics // "") | 
                                                       (if (. | startswith("effector")) 
                                                           then ( . | gsub("(?<a>[a-zA-Z]) (?<b>[a-zA-Z])"; "\(.a)_\(.b)")) 
                                                           else . end) | 
                                                       gsub(" $"; "") | 
                                                       split("[, ]"; "") | 
                                                       map(select(. != "")))},
        mhc: .mhc,
        misc: {reconstructed_j_annotation: .reconstructed_j_annotation}
    } | @json'
