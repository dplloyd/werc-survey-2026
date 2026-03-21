# =============================================================================
# Script Name:    00_read_data.R
# Author:         Diarmuid Lloyd
# Date Created:   14-Feb-2026
# Last Updated:   14-Feb-2026
# Version:        1.0
# R Version:      4.3.1
# Purpose:        Rename Google Forms survey response columns to QIDs
#                 based on metadata, including handling multi-part grid questions.
# Notes:          - Multi-part grid questions (e.g., QC_2, QE_1) are numbered sequentially
# =============================================================================


library(tidyverse)
library(readxl)


# READING DATA ------

# Survey data, previsouly saved from https://docs.google.com/spreadsheets/d/1hXjg0BQ91lbozODwLvyeK23sw4D-Nw_SVOiikIO83rg/edit?gid=1498115047#gid=1498115047
survey_df <- read_excel("data/werc_member_survey_20251112.xlsx")


survey_meta <- read_csv("data/survey_metadata_expanded.csv")

# Remove the "intro" instances
survey_meta <- survey_meta |> filter(!str_detect(QID, "Intro"))

# RENAMING COLUMNS -----

# Google Form column headers are the full question text. Use metadata to 
# rename them as the QID, applying approx. string distance as the meta
# data question may not exactly match.

 # Lowercase and clean the questions for matching
 survey_meta <- survey_meta  |> 
   mutate(Question_clean = tolower(str_squish(Question)))
 
 survey_df_colnames <- tolower(str_squish(names(survey_df)))
 
 # Function to match a survey column to QID
 match_qid <- function(col_name, meta_df) {
   # Exact match or containment
   contains_match <- meta_df |>
     filter(str_detect(col_name, Question_clean))
   
   if(nrow(contains_match) > 0) return(contains_match$QID[1])
   
   # Fallback: approximate string distance
   distances <- stringdist::stringdist(col_name, meta_df$Question_clean, method = "jw")
   closest_qid <- meta_df$QID[which.min(distances)]
   
   if(min(distances) > 0.25) return(col_name) else return(closest_qid)
 }
 
 # Apply to all columns
 new_colnames <- sapply(survey_df_colnames, match_qid, meta_df = survey_meta)
 
 # Rename columns
 colnames(survey_df) <- new_colnames
 
 # Check result
 names(survey_df)
 
 # glimpse(survey_df)
 
 
# DATA FORMATS ----------

## QA_1 ---- 
 # Define the desired order
 QA_1_duration_levels <- c("0-3 months",
                      "4-6 months",
                      "7-9 months",
                      "9-12 months",
                      "More than 12 months")
 
 survey_df <- survey_df |>
   mutate(
     QA_1 = fct_relevel(
       QA_1,
       "0-3 months",
       "4-6 months",
       "7-9 months",
       "9-12 months",
       "More than 12 months"
     )
   )
 
 
 # QD_2
 survey_df <- survey_df |>
   mutate(
     QD_2 = fct_relevel(
       QD_2,
       "I don't want to travel beyond Saughton Park",
       "... within 1/2 mile (0.8km) of Saughton Park",
       "... within 1 mile (1.6km) of Saughton Park",
       "... within 2 miles (3.2km) of Saughton Park",
       "... more than 2 miles (3.2km) from Saughton Park"
     )
   )
                        
                        
                        
                    
 