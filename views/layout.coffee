doctype 5
html ->
  head ->
    meta charset: 'utf-8'
    title 'Line Detection Demonstration'
    meta(name: 'description', content: @description) if @description?
    css('app') + js('line_detection') + js('app')
    
  body ->
    @body
