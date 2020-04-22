FROM registry.gitlab.com/couchbits/movestore/movestore-groundcontrol/movestore-apps/copilot-r:pilot1.0.0-r3.6.3 AS buildstage

WORKDIR /root/app

# install the R dependencies this app needs
RUN Rscript -e 'remotes::install_version("prettyunits")'
RUN Rscript -e 'remotes::install_version("futile.logger")'
RUN Rscript -e 'packrat::snapshot()'

# copy the app as last as possible
# therefore following builds can use the docker cache of the R dependency installations
COPY RFunction.R .

# start again from the vanilla r-base image and copy only
# the needed binaries from the buildstage.
# this will reduce the resulting image size dramatically
# <none>            <none>                           cdc0210196df        31 seconds ago      1.69GB
# pretty-units      packrat-multi-stage              cef6391e7f83        41 seconds ago      1.16GB (JDK) > 1.11GB (JRE)
FROM rocker/r-base:3.6.3
WORKDIR /root/app
COPY --from=buildstage /root/app .

# Install JRE for pilot
RUN apt-get update && \
    apt-get install -y default-jre && \
    apt-get clean;

# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/root/app/app.jar"]
