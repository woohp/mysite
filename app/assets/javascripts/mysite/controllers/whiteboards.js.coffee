@app.controller 'WhiteboardsIndexCtrl', ['$http', '$location', ($http, $location) ->
  $http.get('/api/utils/secure_random').success (whiteboardToken) ->
    $location.path "/whiteboards/#{whiteboardToken}"
]


@app.controller 'WhiteboardsShowCtrl', ['$scope', 'User', 'Channel', '$routeParams', ($scope, User, Channel, $routeParams) ->
  # initialization
  canvasOffsetTop = $('.btn-group').offset().top + $('.btn-group').height() + 20
  canvasWidth = $('#layers').width()
  canvasHeight = window.innerHeight - canvasOffsetTop
  mousedown = false
  mouseDownPos = null
  $scope.mode = 'pencil'
  user_id = User.username + Math.random()

  canvas1 = document.getElementById('layer1')
  ctx = canvas1.getContext('2d')
  canvas1.width = canvasWidth
  canvas1.height = canvasHeight
  canvas2 = document.getElementById('layer2')
  ctx2 = canvas2.getContext('2d')
  canvas2.width = canvasWidth
  canvas2.height = canvasHeight
  $canvas1 = $(canvas1)

  ctx.lineJoin = 'round'
  ctx.lineCap = 'round'
  ctx2.lineJoin = 'round'
  ctx2.lineCap = 'round'

  $scope.color = 'black'
  $scope.colorChoices = ['black', 'white', 'silver', 'gray',
    'red', 'maroon', 'yellow', 'olive', 'lime', 'green', 'aqua',
    'teal', 'blue', 'navy', 'fuchsia', 'purple']
  $scope.$watch 'color', ->
    ctx.strokeStyle = $scope.color

  $scope.lineWidth = 1
  $scope.lineWidthChoices = [1, 2, 4, 6, 8, 12, 16]
  $scope.$watch 'lineWidth', ->
    ctx.lineWidth = $scope.lineWidth

  # networking
  sendToServer = (context, mode, pt1, pt2, sender_id) ->
    # only send when the sender is myself and is not drawn to the temporary canvas
    return unless sender_id == user_id and context == ctx
    ch.trigger 'update',
      mode: mode
      pt1: pt1
      pt2: pt2
      color: ctx.strokeStyle
      width: ctx.lineWidth
      user_id: sender_id

  recvFromServer = (cmd) ->
    return if cmd.user_id == user_id

    # backup current config
    myStrokeStyle = ctx.strokeStyle
    myLineWidth = ctx.lineWidth
    ctx.strokeStyle = cmd.color
    ctx.lineWidth = cmd.width

    if cmd.mode == 'line'
      drawLine(ctx, cmd.pt1, cmd.pt2, cmd.user_id)
    else if cmd.mode == 'rect'
      drawRect(ctx, cmd.pt1, cmd.pt2, cmd.user_id)
    else if cmd.mode == 'ellipse'
      drawEllipse(ctx, cmd.pt1, cmd.pt2, cmd.user_id)

    # restore current config
    ctx.strokeStyle = myStrokeStyle
    ctx.lineWidth = myLineWidth

  ch = Channel($routeParams.id)
  ch.bind('update', recvFromServer)

  # resizes both canvases. canvasWidth and canvasHeight must both be set already
  resizeCanvas = ->
    img = new Image()
    img.src = canvas1.toDataURL('image/png')
    img.onload = ->
      canvas1.width = canvasWidth
      canvas1.height = canvasHeight
      canvas2.width = canvasWidth
      canvas2.height = canvasHeight
      ctx.drawImage(img, 0, 0)

  window.onresize = ->
    newWidth = $('#layers').width()
    newHeight = window.innerHeight - canvasOffsetTop
    if newWidth > canvasWidth or newHeight > canvasHeight
      canvasWidth = Math.max(newWidth, canvasWidth)
      canvasHeight = Math.max(newHeight, canvasHeight)
      resizeCanvas()

  # drawing functions
  getMousePos = (e) ->
    x: e.pageX - $canvas1.offset().left
    y: e.pageY - $canvas1.offset().top

  drawLine = (context, pt1, pt2, sender_id = user_id) ->
    return if pt1.x == pt2.x and pt1.y == pt2.y
    context.beginPath()
    context.moveTo(pt1.x, pt1.y)
    context.lineTo(pt2.x, pt2.y)
    context.stroke()

    sendToServer(context, 'line', pt1, pt2, sender_id)

  drawRect = (context, pt1, pt2, sender_id = user_id) ->
    return if pt1.x == pt2.x or pt1.y == pt2.y
    x = Math.min(pt1.x, pt2.x)
    y = Math.min(pt1.y, pt2.y)
    width = Math.abs(pt1.x - pt2.x)
    height = Math.abs(pt1.y - pt2.y)

    context.strokeRect(x, y, width, height)

    sendToServer(context, 'rect', pt1, pt2, sender_id)

  drawEllipse = (context, pt1, pt2, sender_id = user_id) ->
    return if pt1.x == pt2.x or pt1.y == pt2.y
    x = Math.min(pt1.x, pt2.x)
    y = Math.min(pt1.y, pt2.y)
    width = Math.abs(pt1.x - pt2.x)
    height = Math.abs(pt1.y - pt2.y)

    circumference = Math.max(width, height)
    context.save()
    context.translate(x + width/2, y + height/2)
    context.scale(width / circumference, height / circumference)
    context.beginPath()
    context.arc(0, 0, circumference/2, 0, Math.PI*2, true)
    context.stroke()
    context.restore()

    sendToServer(context, 'ellipse', pt1, pt2, sender_id)

  # mouse event handlers
  $scope.mousedown = (e) ->
    return if e.which != 1
    mousedown = true
    mousePos = getMousePos(e)
    mouseDownPos = mousePos

    if $scope.mode == 'pencil'
      ctx.beginPath()
      ctx.moveTo(mousePos.x, mousePos.y)
    e.preventDefault()

  $scope.mouseup = (e) ->
    return unless mousedown
    mousedown = false
    mousePos = getMousePos(e)

    if $scope.mode == 'pencil'
      if mousePos.x == mouseDownPos.x and mousePos.y == mouseDownPos.y
        mousePos.x += 0.01
        mousePos.y += 0.01
      drawLine(ctx, mouseDownPos, mousePos)
    else if $scope.mode == 'line'
      drawLine(ctx, mouseDownPos, mousePos)
      ctx2.clearRect(0, 0, canvasWidth, canvasHeight)
    else if $scope.mode == 'rect'
      drawRect(ctx, mouseDownPos, mousePos)
      ctx2.clearRect(0, 0, canvasWidth, canvasHeight)
    else if $scope.mode == 'ellipse'
      drawEllipse(ctx, mouseDownPos, mousePos)
      ctx2.clearRect(0, 0, canvasWidth, canvasHeight)
    e.preventDefault()

  $scope.mousemove = (e) ->
    return unless mousedown
    mousePos = getMousePos(e)

    if $scope.mode == 'pencil'
      drawLine(ctx, mouseDownPos, mousePos)
      mouseDownPos = mousePos
    else if $scope.mode == 'line'
      ctx2.clearRect(0, 0, canvasWidth, canvasHeight)
      drawLine(ctx2, mouseDownPos, mousePos)
    else if $scope.mode == 'rect'
      ctx2.clearRect(0, 0, canvasWidth, canvasHeight)
      drawRect(ctx2, mouseDownPos, mousePos)
    else if $scope.mode == 'ellipse'
      ctx2.clearRect(0, 0, canvasWidth, canvasHeight)
      drawEllipse(ctx2, mouseDownPos, mousePos)
    e.preventDefault()
]
