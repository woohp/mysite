@app.controller 'BaseCtrl', ['$scope', '$rootScope', 'User', '$http', ($scope, $rootScope, User, $http) ->
  $scope.user = User
]
