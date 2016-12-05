FROM rocker/r-base

MAINTAINER mike morris "mike.morris89@github.com"

# system libraries of general use
RUN apt-get update  -qq \
 && apt-get upgrade -y

RUN apt-get install -y --no-install-recommends --allow-downgrades \
	apt-utils \
	default-jdk \
	libssl-dev \
	libxml2-dev \
	libcurl3=7.50.1-1 \
	libcurl4-openssl-dev \
	&& rm -rf /var/lib/apt/lists/*

# basic shiny functionality
RUN R -e "install.packages(c('shiny','rmarkdown' ,'plotly','ggplot2','ggthemes','scales','dplyr','randomForest','mice','shinydashboard','rpart','reshape','htmlwidgets','rpart.plot','rattle'),dep=T)"


# copy the app to the image
RUN mkdir /root/kml
COPY sb /root/kml

COPY Rprofile.site /usr/lib/R/etc/

RUN mkdir /srv/shiny-server
RUN mkdir /srv/shiny-server/kml
VOLUME /srv/shiny-server/kml

EXPOSE 3838

CMD ["R", "-e shiny::runApp('/root/kml')"]

