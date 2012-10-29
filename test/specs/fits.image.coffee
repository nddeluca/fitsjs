require = window.require

FITS = require("fits")

describe "FITS Image", ->

  beforeEach ->
    @addMatchers {
      toBeNaN: (expected) -> return isNaN(@actual) == isNaN(expected)
    }        
  
  it 'can read a FITS image', ->
    fits = null
    
    xhr = new XMLHttpRequest()
    xhr.open('GET', 'data/m101.fits')
    xhr.responseType = 'arraybuffer'
    xhr.onload = -> fits = new FITS.File(xhr.response)
    xhr.send()
    
    waitsFor -> return fits?
    
    runs ->
      image = fits.getDataUnit()
      image.getFrame()
          
      # Check the values of the corner pixels ...
      expect(image.getPixel(0, 0)).toEqual(3852)
      expect(image.getPixel(890, 0)).toEqual(4223)
      expect(image.getPixel(890, 892)).toEqual(4015)
      expect(image.getPixel(0, 892)).toEqual(3898)
          
      # ... and a few other random pixels
      expect(image.getPixel(405, 600)).toEqual(9128)
      expect(image.getPixel(350, 782)).toEqual(4351)
      expect(image.getPixel(108, 345)).toEqual(4380)
      expect(image.getPixel(720, 500)).toEqual(5527)
  
  # it 'can read a FITS data cube', ->
  #   precision = 6
  #   fits = null
  #   
  #   xhr = new XMLHttpRequest()
  #   xhr.open('GET', 'data/L1448_13CO.fits')
  #   xhr.responseType = 'arraybuffer'
  #   xhr.onload = -> fits = new FITS.File(xhr.response)
  #   xhr.send()
  #   
  #   waitsFor -> return fits?
  #   
  #   runs ->
  #     image = fits.getDataUnit()
  #   
  #     # Make sure the file is a data cube
  #     expect(image.isDataCube()).toBeTruthy()
  #   
  #     # First Frame
  #     image.getFrame()
  #   
  #     # Check the values of the corner pixels ...
  #     expect(image.getPixel(0, 0)).toBeNaN()
  #     expect(image.getPixel(106, 0)).toBeNaN()
  #     expect(image.getPixel(106, 106)).toBeNaN()
  #     expect(image.getPixel(0, 106)).toBeNaN()
  # 
  #     # ... and a few other random pixels
  #     expect(image.getPixel(54, 36)).toBeCloseTo(0.0340614, precision)
  #     expect(image.getPixel(100, 7)).toBeCloseTo(-0.0275259, precision)
  #     expect(image.getPixel(42, 68)).toBeCloseTo(-0.0534229, precision)
  #     expect(image.getPixel(92, 24)).toBeCloseTo(0.153861, precision)
  #     
      # # Second Frame
      # image.getFrame()
      # 
      # # Check the values of the corner pixels ...
      # expect(image.getPixel(0, 0)).toBeNaN()
      # expect(image.getPixel(106, 0)).toBeNaN()
      # expect(image.getPixel(106, 106)).toBeNaN()
      # expect(image.getPixel(0, 106)).toBeNaN()
      # 
      # # ... and a few other random pixels
      # expect(image.getPixel(54, 36)).toBeCloseTo(0.0329713, precision)
      # expect(image.getPixel(100, 7)).toBeCloseTo(0.0763166, precision)
      # expect(image.getPixel(42, 68)).toBeCloseTo(-0.103573, precision)
      # expect(image.getPixel(92, 24)).toBeCloseTo(0.0360738, precision)
      # 
      # # ... Last Frame
      # image.getFrame(601)
      #     
      # # Check the values of the corner pixels ...
      # expect(image.getPixel(0, 0)).toBeNaN()
      # expect(image.getPixel(106, 0)).toBeNaN()
      # expect(image.getPixel(106, 106)).toBeNaN()
      # expect(image.getPixel(0, 106)).toBeNaN()
      #     
      # # ... and a few other random pixels
      # expect(image.getPixel(54, 36)).toBeCloseTo(-0.105564, precision)
      # expect(image.getPixel(100, 7)).toBeCloseTo(0.202304, precision)
      # expect(image.getPixel(42, 68)).toBeCloseTo(0.221437, precision)
      # expect(image.getPixel(92, 24)).toBeCloseTo(-0.163851, precision)

  # it 'can get extremes, seek, then get data without blowing up', ->
  #   fits = null
  #   
  #   xhr = new XMLHttpRequest()
  #   xhr.open('GET', 'data/m101.fits')
  #   xhr.responseType = 'arraybuffer'
  #   xhr.onload = -> fits = new FITS.File(xhr.response)
  #   xhr.send()
  #   
  #   waitsFor -> return fits?
  #   
  #   runs ->
  #     image = fits.getDataUnit()
  #     expect(image.frame).toEqual(0)
  #   
  #     image.seek()
  #     expect(image.frame).toEqual(0)
  #   
  #     # Grab the data
  #     image.getFrame()
  #     
  #     # Get and check the extremes
  #     image.getExtremes()
  #     
  #     expect(image.min).toEqual(2396)
  #     expect(image.max).toEqual(26203)
  #         
  #     # Check the values of the corner pixels ...
  #     expect(image.getPixel(0, 0)).toEqual(3852)
  #     expect(image.getPixel(890, 0)).toEqual(4223)
  #     expect(image.getPixel(890, 892)).toEqual(4015)
  #     expect(image.getPixel(0, 892)).toEqual(3898)
  #         
  #     # ... and a few other random pixels
  #     expect(image.getPixel(405, 600)).toEqual(9128)
  #     expect(image.getPixel(350, 782)).toEqual(4351)
  #     expect(image.getPixel(108, 345)).toEqual(4380)
  #     expect(image.getPixel(720, 500)).toEqual(5527)

  # it 'can read a file with bitpix -32', ->
  #   fits = null
  #   
  #   xhr = new XMLHttpRequest()
  #   xhr.open('GET', 'data/Deep_32.fits')
  #   xhr.responseType = 'arraybuffer'
  #   xhr.onload = -> fits = new FITS.File(xhr.response)
  #   xhr.send()
  #   
  #   waitsFor -> return fits?
  #   
  #   runs ->
  #     image = fits.getDataUnit()
  #     image.getFrame()
  #     pixel = image.getPixel(0, 0)
  #     console.log pixel
  #     expect(pixel).toEqual(538)
  #     
  #     # Prepare a buffer
  #     ab = new ArrayBuffer(4)
  #     dv = new DataView(ab)
  #     dv.setFloat32(0, 538.123, true)
  #     
  #     arr = new Float32Array(ab)
  #     strRep = String.fromCharCode.apply(null, arr)
  #     
  #     # Convert back to Uint32
  #     buf = new ArrayBuffer(4)
  #     view = new Float32Array(buf)
  #     
  #     for i in [0..strRep.length - 1]
  #       console.log strRep.charCodeAt(i)
      
  it 'can read image with BITPIX = 8', ->
    fits = null
    
    xhr = new XMLHttpRequest()
    xhr.open('GET', 'data/image-uint8.fits')
    xhr.responseType = 'arraybuffer'
    xhr.onload = -> fits = new FITS.File(xhr.response)
    xhr.send()
    
    waitsFor -> return fits?
    
    runs ->
      image = fits.getDataUnit()
      image.getFrame()
      
      expect(image.getPixel(0, 0)).toEqual(1)
      expect(image.getPixel(50, 0)).toEqual(113)
      expect(image.getPixel(99, 0)).toEqual(63)
      
      expect(image.getPixel(0, 50)).toEqual(219)
      expect(image.getPixel(50, 50)).toEqual(246)
      expect(image.getPixel(99, 50)).toEqual(53)
      
      expect(image.getPixel(0, 99)).toEqual(187)
      expect(image.getPixel(50, 99)).toEqual(172)
      expect(image.getPixel(99, 99)).toEqual(181)
  
  it 'can read image with BITPIX = 16', ->
    fits = null
  
    xhr = new XMLHttpRequest()
    xhr.open('GET', 'data/image-int16.fits')
    xhr.responseType = 'arraybuffer'
    xhr.onload = -> fits = new FITS.File(xhr.response)
    xhr.send()
  
    waitsFor -> return fits?
  
    runs ->
      image = fits.getDataUnit()
      image.getFrame()
  
      expect(image.getPixel(0, 0)).toEqual(322)
      expect(image.getPixel(50, 0)).toEqual(29219)
      expect(image.getPixel(99, 0)).toEqual(16339)
      
      expect(image.getPixel(0, 50)).toEqual(-9192)
      expect(image.getPixel(50, 50)).toEqual(-2214)
      expect(image.getPixel(99, 50)).toEqual(13670)
      
      expect(image.getPixel(0, 99)).toEqual(-17403)
      expect(image.getPixel(50, 99)).toEqual(-21201)
      expect(image.getPixel(99, 99)).toEqual(-19013)
  
  it 'can read image with BITPIX = 32', ->
    fits = null
  
    xhr = new XMLHttpRequest()
    xhr.open('GET', 'data/image-uint8.fits')
    xhr.responseType = 'arraybuffer'
    xhr.onload = -> fits = new FITS.File(xhr.response)
    xhr.send()
  
    waitsFor -> return fits?
  
    runs ->
      image = fits.getDataUnit()
      image.getFrame()
  
      console.log image.data
      
  it 'can read image with BITPIX = -32', ->
    fits = null
  
    xhr = new XMLHttpRequest()
    xhr.open('GET', 'data/image-uint8.fits')
    xhr.responseType = 'arraybuffer'
    xhr.onload = -> fits = new FITS.File(xhr.response)
    xhr.send()
  
    waitsFor -> return fits?
  
    runs ->
      image = fits.getDataUnit()
      image.getFrame()
  
      console.log image.data
    
  # it 'can read a file with an IMAGE extension', ->
  #   fits = null
  # 
  #   xhr = new XMLHttpRequest()
  #   xhr.open('GET', 'data/HST_10098_09_ACS_WFC_F555W_drz.fits')
  #   xhr.responseType = 'arraybuffer'
  #   xhr.onload = -> fits = new FITS.File(xhr.response)
  #   xhr.send()
  # 
  #   waitsFor -> return fits?
  # 
  #   runs ->
  #     image = fits.getDataUnit()
  #     image.getFrame()
  #     image.getExtremes()
  #     
  #     expect(image.min).toBeCloseTo(-60.139053, 6)
  #     expect(image.max).toBeCloseTo(1660.3833, 4)