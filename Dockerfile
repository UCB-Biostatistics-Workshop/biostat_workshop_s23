FROM rocker/shiny-verse

RUN apt-get update && \
    install2.r learnr rmarkdown && \
    R -e "remotes::install_github(c('rstudio/gradethis', 'rstudio-education/dsbox', 'allisonhorst/palmerpenguins'))" && \
    rm -rf /tmp/downloaded_packages && \
    rm -rf /srv/shiny-server/*

COPY learnr-tuts /srv/shiny-server

RUN sudo chown -R shiny:shiny /srv/shiny-server && \
    sudo chown -R shiny:shiny /var/log/shiny-server

EXPOSE 3838