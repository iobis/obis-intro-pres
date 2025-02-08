# Install packages
message("Installing packages from CRAN")
install.packages("tidyverse")        # Tidyverse
install.packages(c("terra", "sf"))   # Spatial
install.packages(c("DBI", "duckdb")) # Database
install.packages(c(                  # Others
    "arrow",
    "devtools",
    "robis", 
    "rnaturalearth",
    "mgcv",
    "gifski",
    "fs",
    "h3jsr"

))
# Install those from GitHub
message("Installing packages from GitHub")
devtools::install_github("iobis/obistools")
devtools::install_github("ropensci/mregions2")
