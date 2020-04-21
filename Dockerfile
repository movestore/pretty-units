FROM movestore/pilot-jetpack:latest

COPY RFunction.R /root/app/r/RFunction.R

WORKDIR /root/app/r
# RUN jetpack init

RUN cat DESCRIPTION
RUN jetpack add move@3.3.0
RUN jetpack add prettyunits
RUN jetpack add futile.logger
RUN jetpack add jsonlite@1.6.1
RUN cat DESCRIPTION

#RUN jetpack check
#RUN jetpack install --deployment
#RUN Rscript init-by-jetpack.R

RUN Rscript -e 'packrat::init()'
