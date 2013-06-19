@app = angular.module('smartTodo', ['sync'], ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
  $routeProvider
    .when('/', templateUrl: 'index', controller: 'TodosIndexCtrl')
    .when('/signup', templateUrl: 'signup', controller: 'SignupCtrl')
    .when('/login', templateUrl: 'login', controller: 'LoginCtrl')
    .when('/:id', templateUrl: 'todos/show', controller: 'TodosShowCtrl')

  $locationProvider.html5Mode true
])

