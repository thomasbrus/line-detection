#= require lib/jquery-1.7.1.min
#= require line_detection

$ ->
  canvas = new Canvas($('#canvas'))
  
  $(window).resize ->
    canvas.resize()
    canvas.redraw()
    
  $('#canvas').one 'click', -> $('#placeholder').fadeOut 'slow'
    
  $('#eraser').click ->
    canvas.clear(true)
    false

class Canvas
  
  constructor: (@canvas) ->
    @points   = []
    @solution = null
    @context  = @canvas.get(0).getContext('2d')
    
    @canvas.mousemove (event) =>
      @redraw event
    
    @canvas.mouseleave (event) =>
      @redraw()
    
    @canvas.click (event) =>
      x = @mouseX event
      y = @mouseY event
      @addPoint x, y
      @drawPoint x, y
      @solution = new Solution(@points).find()
      @drawLine(@solution.line) if @solution?
    
    @resize()
    
  resize: ->
    @canvas.attr('width', $('#region').width() - 40)
  
  redraw: (event) ->
    @clear()
    @drawPoint p.x, p.y, p.alpha for p in @points
    @drawLine(@solution.line) if @solution?
    @drawCursor @mouseX(event), @mouseY(event) if event?
    
  mouseX: (event) ->
    event.pageX - @canvas.offset().left
  
  mouseY: (event) ->
    event.pageY - @canvas.offset().top
  
  clear: (all) ->
    @points = [] if all?
    @context.clearRect 0, 0, @canvas.width(), @canvas.height()
    
  drawCursor: (x, y, radius = 8, alpha = 0.2) ->
    @drawCircle x, y, radius, "rgba(0, 0, 0, #{alpha})"
    
  drawPoint: (x, y, alpha = 0.6) ->
    @drawCircle x, y, 4, "white"
    @drawCircle x, y, 3, "black"
    
  drawCircle: (x, y, radius, fill, stroke) ->
    @context.fillStyle = fill
    @context.strokeStyle = stroke if stroke?
    @context.beginPath()
    @context.arc(x, y, radius, 0, Math.PI * 2, true)
    @context.closePath()
    @context.fill()
    @context.stroke() if stroke?

  drawLine: (line) ->
    @context.strokeStyle = "red"
    @context.beginPath()
    @context.moveTo line.p1.x, line.p1.y
    @context.lineTo line.p2.x, line.p2.y
    @context.closePath()
    @context.stroke()

  addPoint: (x, y) ->
    @points.push new Point(x, y)