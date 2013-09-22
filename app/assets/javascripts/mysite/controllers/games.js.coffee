@app.controller 'GamesIndexCtrl', ['$scope', '$rootScope', 'User', '$http', 'angularFire', ($scope, $rootScope, User, $http, angularFire) ->
  angularFire('https://huipeng.firebaseio.com/games', $scope, 'games')

  $scope.createGame = ->
    $scope.games ||= []
    $scope.games.push(5)
]

