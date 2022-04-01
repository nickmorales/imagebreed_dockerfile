#!/bin/bash

# update.packages(lib.loc="/home/production/cxgn/R_libs", ask = FALSE, checkBuilt = TRUE, Ncpus = 6)

R -e "install.packages('devtools', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('qtl', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('randomForest', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('lme4', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('irlba', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('nlme', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('sfsmisc', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('polycor', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('mvtnorm', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('msm', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('KernSmooth', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('caTools', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('bitops', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('gdata', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('gtools', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('rjson', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('mail', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('plyr', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('rrBLUP', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('RColorBrewer', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('ltm', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('gplots', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('data.table', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('agricolae', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('d3heatmap', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('tidyr', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('ggplot2', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('bioconductor', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('caret', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('R.oo', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('lsmeans', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('dplyr', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('withr', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('fpc', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('ggfortify', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('cluster', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('rlang', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('BGLR', dependencies=TRUE, repos='http://cran.rstudio.com/')"

R -e 'library("devtools");install_version("sommer", version = "4.1.3", repos = "http://cran.us.r-project.org");'
#R -e "install.packages('sommer', dependencies=TRUE, repos='http://cran.rstudio.com/')"

R -e "install.packages('ggthemes', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('GGally', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('gridExtra', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('tidyverse', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('blocksdesign', dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages('psych', dependencies=TRUE, repos='http://cran.rstudio.com/')"

R -e "install.packages('waves', dependencies=TRUE, repos='http://cran.rstudio.com/')"
#R -e 'library("devtools");install_github("GoreLab/waves")'

R -e 'BiocManager::install();BiocManager::install(c("gdsfmt", "SNPRelate"))'
R -e 'library("devtools");install_github("cran/R.methodsS3");install_github("solgenomics/rPackages/genoDataFilter");install_github("solgenomics/rPackages/phenoAnalysis");install_github("reyzaguirre/st4gi")'
#R -e "install.packages('/opt/vsn/asreml/4.x.0.b/asreml_Ubuntu-18_4.1.0.126.tar.gz', repos=NULL)"
#R -e "install.packages('/opt/vsn/asreml/4.x.0.b/ASRgenomics_1.0.0_R_x86_64-pc-linux-gnu.tar.gz', repos=NULL)"
