@app.controller 'FilingsShowCtrl', ['$scope', '$http', '$routeParams', ($scope, $http, $routeParams) ->
  $http.get("/api/filings/#{$routeParams.id}").success (filing) ->
    $scope.filing = filing
    $scope.details = []
    for k, v of filing.details
      detail =
        name: k
        entries: []
      for entry in v
        if Array.isArray(entry.period)
          entry.period = "#{entry.period[0]} to #{entry.period[1]}"
        detail.entries.push entry
      $scope.details.push(detail)
]
