@app.controller 'CompaniesIndexCtrl', ['$scope', '$http', '$routeParams', ($scope, $http, $routeParams) ->
  $http.get("/api/companies").success (companies) ->
    $scope.companies = companies
]

@app.controller 'CompaniesShowCtrl', ['$scope', '$http', '$routeParams', ($scope, $http, $routeParams) ->
  $http.get("/api/companies/#{$routeParams.id}").success (company) ->
    $scope.company = company
]
