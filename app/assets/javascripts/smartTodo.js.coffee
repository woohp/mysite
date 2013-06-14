@app = angular.module('smartTodo', ['sync'], ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
  $routeProvider.
    when('/', templateUrl: 'index', controller: 'TodosIndexCtrl').
    when('/:id', templateUrl: 'todos/show', controller: 'TodosShowCtrl')

  $locationProvider.html5Mode true
])

