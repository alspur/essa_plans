# scrape state essa plans
# data scraped on 2017-06-27


# load packages
library(tidyverse)
library(RCurl)
library(rvest )
library(stringr)
library(tidytext)
library(httr)

# scrape html ####

# set state submission page url
ed_url <- getURL("https://www2.ed.gov/admins/lead/account/stateplan17/statesubmission.html ")

# read html from state submission page
ed_page <- readLines(tc <- textConnection(ed_url)); close(tc)

# create tibble of page html
ed_df <- tibble(line = 1:length(ed_page), content = ed_page)

# filter out lines to get abbreviations of states w/ essa plan submissions
state_abbr<- ed_df %>%
  filter(str_detect(content, "/admins/lead/account/stateplan17/map")) %>%
  mutate(clean_name = str_extract(content, "[a-z]+.html"),
         abbr = str_replace_all(clean_name, ".html", "")) %>%
  pull(abbr)

# create template of state plan pages
url_pt1 <- "https://www2.ed.gov/admins/lead/account/stateplan17/"
url_pt2 <- "csa2017.pdf"
url_pt2b <- "csa2017.docx"

https://www2.ed.gov/admins/lead/account/stateplan17/nvcsa2017.docx

# create df of state link info
state_links <- tibble(abbr = state_abbr) %>%
  mutate(pdf_link = str_c(url_pt1, abbr, url_pt2), 
         alt_link = str_c(url_pt1, abbr, url_pt2b),
         file_name = str_c("data/", abbr, "_plan.pdf"),
         alt_file_name = str_c("data/", abbr, "_plan.docx"))

# download pdfs of state essa plans
for(i in seq_along(1:length(state_abbr))){
  
  temp_url <- state_links$pdf_link[i]
  
  if(http_error(temp_url)){
    
    download.file(state_links$alt_link[i],state_links$alt_file_name[i])
  }
  else{
    download.file(temp_url,state_links$file_name[i])
  }

}
