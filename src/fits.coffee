FITS = {}

FITS.VERSION    = '0.1.5'
FITS.HDU        = require('./fits.hdu')
FITS.File       = require('./fits.file')
FITS.Header     = require('./fits.header')
FITS.Image      = require('./fits.image')
FITS.BinTable   = require('./fits.binarytable')
FITS.CompImage  = require('./fits.compressedimage')
FITS.Table      = require('./fits.table')

module?.exports = FITS