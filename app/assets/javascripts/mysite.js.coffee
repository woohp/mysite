@app = angular.module('MySite', ['ui.bootstrap', 'ui.bootstrap.tpls'], ['$routeProvider', '$locationProvider', '$httpProvider', ($routeProvider, $locationProvider, $httpProvider) ->

  $routeProvider
    .when('/signup', templateUrl: 'signup', controller: 'SignupCtrl')
    .when('/login', templateUrl: 'login', controller: 'LoginCtrl')
    .when('/logout', resolve: { logout: logout })

    .when('/', templateUrl: 'home', controller: 'HomeCtrl', resolve: { login: requireLogin })
    .when('/settings', templateUrl: 'settings', controller: 'SettingsCtrl')

    .when('/whiteboards', templateUrl: 'whiteboards/index', controller: 'WhiteboardsIndexCtrl', resolve: { login: requireLogin })
    .when('/whiteboards/:id', templateUrl: 'whiteboards/show', controller: 'WhiteboardsShowCtrl', resolve: { login: requireLogin })

    .when('/todos', templateUrl: 'todos/index', controller: 'TodosIndexCtrl', resolve: { login: requireLogin })
    .when('/todos/:id', templateUrl: 'todos/show', controller: 'TodosShowCtrl', resolve: { login: requireLogin })
    .when('/todos/:id/edit', templateUrl: 'todos/show', controller: 'TodosShowCtrl', resolve: { login: requireLogin })

    .when('/companies', templateUrl: 'companies/index', controller: 'CompaniesIndexCtrl')
    .when('/companies/:id', templateUrl: 'companies/show', controller: 'CompaniesShowCtrl')

    .when('/filings/:id', templateUrl: 'filings/show', controller: 'FilingsShowCtrl')

  $locationProvider.html5Mode true

  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])


requireLogin = ['$q', '$http', 'User', '$location', ($q, $http, User, $location) ->
  defer = $q.defer()

  if User.username
    defer.resolve()
  else
    success = (user) ->
      User.username = user.username
      User.id = user.id
      defer.resolve()
    error = ->
      defer.reject("Failed to login")
      $location.path('/login').replace()
    $http.get('/api/users/current').success(success).error(error)

  return defer.promise
]

logout = ['User', '$http', '$location', (User, $http, $location) ->
  $http.delete('/api/logout').success ->
    User.username = ''
    User.id = ''
    $location.path('/login').replace()
]
