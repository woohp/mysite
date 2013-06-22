@app.controller 'SignupCtrl', ['$scope', '$rootScope', '$http', '$location', 'User', ($scope, $rootScope, $http, $location, User) ->
  $rootScope.title = 'Smart Todo'

  $scope.submit = ->
    $http.post('/api/users', $scope.signup).success (user) ->
      User.username = user.username
      User.id = user.id
      $location.path '/'
]
