@app.controller 'FilingsShowCtrl', ['$scope', '$http', '$routeParams', ($scope, $http, $routeParams) ->
  $http.get("/api/filings/#{$routeParams.id}").success (filing) ->
    $scope.filing = filing
]
