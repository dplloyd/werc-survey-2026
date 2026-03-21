



count_column_pc_table <-  function(df, var, sort = c("none", "desc", "asc")) {
  sort <- match.arg(sort)  # ensures valid option
  
  # Build the tabyl table
  tbl <- df %>%
    tabyl({{ var }}) %>%                 # counts
    adorn_pct_formatting(digits = 1) %>% # format percentages
    adorn_totals(where = "row")          # add totals row
  
  # Apply sorting if requested (skip the totals row)
  if (sort != "none") {
    n_rows <- nrow(tbl)
    totals <- tbl[n_rows, , drop = FALSE]  # keep totals aside
    
    tbl <- tbl[-n_rows, ]                  # remove totals for sorting
    tbl <- switch(
      sort,
      "desc" = tbl %>% arrange(desc(n)),
      "asc"  = tbl %>% arrange(n)
    )
    
    tbl <- bind_rows(tbl, totals)          # add totals back at the bottom
  }
  
  # Convert to gt table
  gt::gt(tbl)                               # create gt table
}
  
  