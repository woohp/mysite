@app.controller 'LoginCtrl', ['$scope', 'User', '$route', '$location', '$http', ($scope, User, $route, $location, $http) ->
  $scope.submit = ->
    $http.post('/api/login', $scope.login).success (user) ->
      User.username = user.username
      User.id = user.id
      $location.path '/'
]
