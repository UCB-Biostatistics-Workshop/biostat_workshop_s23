FROM rocker/shiny-verse

RUN set -x && \
    addgroup --system --gid 101 nginx && \
    adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx

RUN apt-get update && \
    apt-get install -yq dnsutils vim-tiny iputils-ping procps curl nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists && \
    install2.r learnr rmarkdown && \
    R -e "remotes::install_github(c('rstudio/gradethis', 'rstudio-education/dsbox', 'allisonhorst/palmerpenguins'))" && \
    rm -rf /tmp/downloaded_packages && \
    rm -rf /srv/shiny-server/*

RUN curl -L https://github.com/DarthSim/hivemind/releases/download/v1.1.0/hivemind-v1.1.0-linux-amd64.gz -o hivemind.gz \
  && gunzip hivemind.gz \
  && mv hivemind /usr/local/bin

ADD nginx.conf /etc/nginx/nginx.conf
ADD /scripts /fly
ENV NGINX_PORT=8080

COPY Procfile Procfile
RUN chmod +x /usr/local/bin/hivemind
RUN chmod +x /fly/*.sh

COPY learnr-tuts /srv/shiny-server

RUN sudo chown -R shiny:shiny /srv/shiny-server && \
    sudo chown -R shiny:shiny /var/log/shiny-server

# Compile the tutorials
RUN R -e "rmarkdown::render('/srv/shiny-server/intro-r/intro_r.Rmd')" && \
    R -e "rmarkdown::render('/srv/shiny-server/penguins/penguins.Rmd')" && \
    R -e "rmarkdown::render('/srv/shiny-server/star-wars/star_wars.Rmd')"

EXPOSE 8080

CMD ["/usr/local/bin/hivemind"]