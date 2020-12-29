file.edit(file.path("~", ".Rprofile")) # edit .Rprofile in HOME
file.edit(".Rprofile") # edit project specific .Rprofile    
devtools::install_github("rstudio/reticulate")
install.packages("devtools")
remove.packages('reticulate')
reticulate::py_config()

