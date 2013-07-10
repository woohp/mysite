@app.controller 'WhiteboardsIndexCtrl', ['$http', '$location', ($http, $location) ->
  $http.get('/api/utils/secure_random').success (whiteboardToken) ->
    $location.path "/whiteboards/#{whiteboardToken}"
]


@app.controller 'WhiteboardsShowCtrl', ['$scope', ($scope) ->

]
