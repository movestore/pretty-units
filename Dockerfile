FROM registry.gitlab.com/couchbits/movestore/movestore-groundcontrol/movestore-apps/copilot-r:pilot1.0.0-r3.6.3 AS buildstage

WORKDIR /root/app
RUN ls -al
COPY RFunction.R ./r

# install the R dependencies this app needs
RUN Rscript -e 'remotes::install_version("prettyunits")'
RUN Rscript -e 'remotes::install_version("futile.logger")'
RUN Rscript -e 'packrat::snapshot()'
RUN ls -al

# start again from the vanilla r-base image and copy only
# the needed binaries from the buildstage.
# this will reduce the resulting image size dramatically
# <none>            <none>                           cdc0210196df        31 seconds ago      1.69GB
# pretty-units      packrat-multi-stage              cef6391e7f83        41 seconds ago      711MB
FROM rocker/r-base:3.6.3
#RUN mkdir -p /root/app/shiny
WORKDIR /root/app
COPY --from=buildstage /root/app .
