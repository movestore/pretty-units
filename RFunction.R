library('prettyunits')
library("futile.logger")

rFunction = function(data) {
    flog.warn(pretty_bytes(89981234493333337))
    data
}
