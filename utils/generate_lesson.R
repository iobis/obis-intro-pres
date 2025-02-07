gen_lesson <- function(notebooks,
                       title,
                       date,
                       event,
                       organizers,
                       contact,
                       summary = NULL,
                       add_part = TRUE) {

    fs::dir_create("events")

    note_contents <- lapply(notebooks, .parse_notebook)

    content <- c(paste("#", title, "\n"), paste("##", event, "\n"))

    header <- paste("Date:", date, "|", organizers, "|", contact)

    content <- c(content, "", header, "")

    content <- c(content, "--------\n")

    if (!is.null(summary)) {
        content <- c(content, "### :page_facing_up: Summary\n", summary, "")
    }

    content <- c(content, "### :open_file_folder: Content\n")

    for (i in seq_along(note_contents)) {
        content <- c(content, paste("####", ifelse(
            add_part, paste(paste0("Part ", i, ":"), note_contents[[i]]$h1[1]), note_contents[[i]]$h1[1]
        )), "")
        content <- c(content, paste0("Notebook: [", basename(notebooks[i]), "](",
            notebooks[i], ")"), "<br>")
        content <- c(content, "", note_contents[[i]]$h3, "")
        content <- c(content, "", paste("Language:", paste0("**", note_contents[[i]]$runtime, "**")))
        content <- c(content, "", paste("Used packages:", ifelse(
            length(note_contents[[i]]$pkg) > 0,
            paste0("**", paste(note_contents[[i]]$pkg, collapse = ", "), "**"),
            " "
        )), "")
    }

    content <- c(content, "-------", "<img src='https://obis.org/images/logo.png' width=150></img>")

    writeLines(content, file.path("events", paste0(gsub(" ", "-", tolower(event)), ".md")))

    message("Lesson saved!")
    return(invisible(NULL))

}

.parse_notebook <- function(note_path) {
    note_content <- jsonlite::read_json(note_path)
    note_cells <- lapply(note_content$cells, function(x){
        if (x$cell_type == "markdown") {
            unlist(x$source)
        } else {
            NULL
        }
    })
    note_cells <- unlist(note_cells)

    titles <- gsub("# ", "", note_cells[grepl("^# ", note_cells)])

    subtitles <- gsub("## ", "", note_cells[grepl("^## ", note_cells)])

    h3 <- gsub("### ", "", note_cells[grepl("^### ", note_cells)])
    h3 <- gsub("\n", "", h3)

    note_cells <- lapply(note_content$cells, function(x){
        if (x$cell_type != "markdown") {
            unlist(x$source)
        } else {
            NULL
        }
    })
    note_cells <- unlist(note_cells)

    packages <- note_cells[grepl("library|require|import|::", note_cells)]
    packages <- gsub(".*library\\(", "", gsub(").*", "", packages))
    packages <- gsub(".*require\\(", "", gsub(").*", "", packages))
    packages <- gsub(".*import ", "", gsub(" as .*| from .*", "", packages))
    if (any(grepl("::", packages))) {
        matches <- gregexpr("(\\w+)::", packages, perl = TRUE)
        matched_strings <- unlist(regmatches(packages, matches))
        matched_strings <- sub("::$", "", matched_strings)
        packages <- packages[!grepl("::", packages)]
        packages <- c(packages, matched_strings)
    }
    # Get only unique
    packages <- unique(packages)
    # Remove those from installation
    packages <- packages[!packages %in% c("bspm", "devtools")]

    runtime <- note_content$metadata$kernelspec$language

    to_return <- list(
        pkg = packages,
        h1 = titles,
        h2 = subtitles,
        h3 = h3,
        runtime = runtime
    )

    return(to_return)
}



### Example usage
# gen_lesson(
#     notebooks = c("notebooks/R/robis_da.ipynb"),
#     title = "OBIS introduction",
#     event = "BioSpace25",
#     date = "2025-02-11",
#     organizers = "Silas C. Principe, Pieter Provoost",
#     contact = "helpdesk@obis.org",
#     summary = "
# The Ocean Biodiversity Information System (OBIS) is the world’s largest open-access repository for marine biodiversity data, containing over 136 million occurrence records from more than 5,000 datasets.  
# OBIS information supports research across a wide range of topics, including biogeography, climate change impacts, invasive species, and taxonomy. In this hands-on demonstration, we will introduce OBIS and the types of data it provides. Through recent research and ongoing projects, we will showcase the diverse applications of OBIS data. Practical examples will illustrate the multiple pathways for accessing OBIS data and demonstrate how it can be processed and integrated with other Earth observation datasets to address critical research questions.  
# At the end of the demonstration, participants are expected to gain a clear understanding of
# (1) the types of information available through OBIS;
# (2) how to access the data using various methods, including APIs, packages, the mapper, and exports;
# (3) how to integrate OBIS data with other datasets;
# (4) how to find support and collaborate with OBIS.
# The demonstrations will use JupyterHub, and participants will have the opportunity to run analyses on their own computers.
#     "
# )
gen_lesson(
    notebooks = c("notebooks/R/biospace_obis_da_r.ipynb", "notebooks/R/biospace_products_r.ipynb"),
    title = "OBIS introduction",
    event = "BioSpace25",
    date = "2025-02-11",
    organizers = "Silas C. Principe, Pieter Provoost, Elizabeth Lawrence",
    contact = "helpdesk@obis.org",
    summary = "
The Ocean Biodiversity Information System (OBIS) is the world’s largest open-access repository for marine biodiversity data, containing over 136 million occurrence records from more than 5,000 datasets.  
OBIS information supports research across a wide range of topics, including biogeography, climate change impacts, invasive species, and taxonomy. In this hands-on demonstration, we will introduce OBIS and the types of data it provides. Through recent research and ongoing projects, we will showcase the diverse applications of OBIS data. Practical examples will illustrate the multiple pathways for accessing OBIS data and demonstrate how it can be processed and integrated with other Earth observation datasets to address critical research questions.  
At the end of the demonstration, participants are expected to gain a clear understanding of
(1) the types of information available through OBIS;
(2) how to access the data using various methods, including APIs, packages, the mapper, and exports;
(3) how to integrate OBIS data with other datasets;
(4) how to find support and collaborate with OBIS.
The demonstrations will use JupyterHub, and participants will have the opportunity to run analyses on their own computers.
    "
)
