Data        = require('./fits.data')
ImageUtils  = require('./fits.image.utils')

# Image represents a standard image stored in the data unit of a FITS file
class Image extends Data
  @include ImageUtils
  
  constructor: (view, header) ->
    super
    naxis   = header['NAXIS']
    @bitpix  = header['BITPIX']
    
    @naxis = []
    @naxis.push header["NAXIS#{i}"] for i in [1..naxis]
    
    @width  = header['NAXIS1']
    @height = header['NAXIS2'] or 1
    
    
    bytesPerNumber = Math.abs(@bitpix) / 8
    @rowByteSize = @width * bytesPerNumber
    @totalRowsRead = 0
    
    @length = @naxis.reduce( (a, b) -> a * b) * bytesPerNumber
    @data = undefined
    @frame = 0  # Needed for data cubes
    
    # Define the function to interpret the image data
    switch @bitpix
      when 8
        @arrayType  = Uint8Array
        @accessor   = => return @view.getUint8()
        @swapEndian = (value) => return value
      when 16
        @arrayType  = Uint16Array
        @accessor   = => return @view.getInt16()
        @swapEndian = (value) => return (value << 8) | (value >> 8)
      when 32
        @arrayType  = Uint32Array
        @accessor   = => return @view.getInt32()
        @swapEndian = (value) =>
          value = ((value << 8) & 0xFF00FF00 ) | ((value >> 8) & 0xFF00FF )
          return (value << 16) | (value >> 16)
      when -32
        @arrayType  = Float32Array
        @accessor   = => return @view.getFloat32()
      when -64
        @arrayType  = Float64Array
        @accessor   = => return @view.getFloat64()
      else
        throw "Invalid BITPIX"
  
  # Read a row of pixels from the array buffer.  The method initArray
  # must be called before requesting any rows.
  getRow: ->
    @current = @begin + @totalRowsRead * @rowByteSize
    @view.seek(@current)
    
    for i in [0..@width - 1]
      @data[@width * @rowsRead + i] = @accessor()
    
    @rowsRead += 1
    @totalRowsRead += 1

  getFrame: (@frame = @frame) =>
    numPixels = @width * @height
    buffer = @view.buffer.slice(@begin, @begin + @length)
    
    if @bitpix < 0
      @initArray(@arrayType) unless @data?
      height = @height
      while height--
        @getRow()
    else
      @data = new @arrayType(buffer)
      for index in [0..numPixels-1]
        value = @data[index]
        @data[index] = @swapEndian(value)
    
    @frame += 1
    @rowsRead = @totalRowsRead = @frame * @width
    return @data

  # Moves the pointer that is used to read the array buffer to a specified frame.  For 2D images
  # this defaults to the first and only frame.  Indexing of the frame argument begins at 0.
  seek: (frame = 0) ->
    if @naxis.length is 2
      @totalRowsRead = 0
      @frame    = 0
    else
      @totalRowsRead = @height * frame
      @frame    = @height / @totalRowsRead - 1
  
  # Checks if the image is a data cube
  isDataCube: -> return if @naxis.length > 2 then true else false
    
module?.exports = Image