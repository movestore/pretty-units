library('prettyunits')
library("futile.logger")

rFunction = function(data) {
    flog.warn(pretty_bytes(93333337))
    data
}
