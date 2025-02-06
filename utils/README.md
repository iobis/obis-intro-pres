# Utilities for developing content

You can use the function within `generate_lesson.R` to create a "lesson" md file, that will be saved in the folder "events". This is a good way to organize content for a specific event. See example of usage at the end of the file.

For this function to work well, **always** follow this pattern when making notebooks:
1. Use level 1 header (#) for the title of the document
2. Use level 3 header (###) for the parts of the lesson. Always numerate those. E.g. ### 1. Download data
3. Level 2 (or others) headers may be used, but are ignored when creating the lesson
4. Just use `library` or `require` to load R packages

# Note for installing R packages

In **Google Colab**, the fastest way to install packages is through the Ubuntu binaries, using system command. They have enabled [`r2u`](https://eddelbuettel.github.io/r2u/) in all instances. Another option is to use `install.packages("bspm")` and then `bspm::enable()`. From that you can use `install.packages` as usual, but faster as it will try to use the binaries.

# Notes about Binder

To configure packages for **Binder**, update `install.R`. If you need to install Ubuntu libraries, edit `apt.txt`. Finally, to change the R runtime edit `runtime.txt`. It is possible to install Python packages also, just add a `requirements.txt` file.

See more here: https://mybinder.readthedocs.io/en/latest/using/config_files.html