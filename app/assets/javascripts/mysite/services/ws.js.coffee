@app.factory 'ws', [->
  new WebSocketRails("#{location.host}/websocket")
]

@app.factory 'Channel', ['ws', (ws) ->
  channels = {}
  (channelName) -> channels[channelName] ||= ws.subscribe(channelName)
]
