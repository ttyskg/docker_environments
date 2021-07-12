#Setting for jupyter lab
install.packages(c("repr", "IRdisplay", "evaluate", "crayon", "pbdZMQ", "devtools", "uuid", "digest"))
install.packages("IRkernel")
IRkernel::installspec(user = FALSE)

# Packages for analysis
install.packages("growthcurver")
