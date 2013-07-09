@app.controller 'TodosIndexCtrl', ['$scope', '$rootScope', 'User', '$http', ($scope, $rootScope, User, $http) ->
  $http.get("/api/todos").success (todos) -> $scope.todos = todos

  $scope.newTodo = {}
  $scope.createNewTodo = ->
    $http.post('/api/todos', $scope.newTodo).success (todo) ->
      $scope.todos.push todo
]

@app.controller 'TodosShowCtrl', ['$scope', '$rootScope', '$http', '$routeParams', '$location', ($scope, $rootScope, $http, $routeParams, $location) ->
  $http.get("/api/todos/#{$routeParams.id}").success (todo) ->
    $scope.todo = todo

  $scope.update = ->
    $http.put("/api/todos/#{$routeParams.id}", $scope.todo).success ->
      alert 'success!'

  $scope.destroy = ->
    if confirm("Are you sure?")
      $http.delete("/api/todos/#{$routeParams.id}").success ->
        $location.path '/'
]
