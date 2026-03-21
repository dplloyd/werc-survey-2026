# This script categories free text responses using Ollama
# 
library(ellmer)
source("00_read_data.R")

system_prompt <- readLines("prompt-club-enjoyment-categorisation.md")

chat <- chat_ollama(model = "gemma3:4b", system_prompt = system_prompt)


input_prompts <- as.list(survey_df$QA_3)

chat_output <- parallel_chat_structured(
  chat = chat,
  on_error = "return",
  prompts = input_prompts,
  type = type_object(category = type_number(), reasoning = type_string()),
  
)
