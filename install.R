# System commands
message("Installing r2u")
system("apt update -qq && apt install --yes --no-install-recommends wget \
    ca-certificates gnupg")
system("wget -q -O- https://eddelbuettel.github.io/r2u/assets/dirk_eddelbuettel_key.asc \
    | tee -a /etc/apt/trusted.gpg.d/cranapt_key.asc")
system('echo "deb [arch=amd64] https://r2u.stat.illinois.edu/ubuntu jammy main" \
     > /etc/apt/sources.list.d/cranapt.list')
system('apt update -qq')
system('echo "Package: *" > /etc/apt/preferences.d/99cranapt')
system('echo "Pin: release o=CRAN-Apt Project" >> /etc/apt/preferences.d/99cranapt')
system('echo "Pin: release l=CRAN-Apt Packages" >> /etc/apt/preferences.d/99cranapt')
system('echo "Pin-Priority: 700"  >> /etc/apt/preferences.d/99cranapt')

#
message("Installing packages")
system("apt-get install r-cran-sf r-cran-terra")


# install.packages(c("terra", "sf", "tidyverse", "devtools", "robis", "arrow", "sfarrow", "stars", "patchwork"))
# devtools::install_github('bio-oracle/biooracler')