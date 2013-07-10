@app = angular.module('MySite', ['sync'], ['$routeProvider', '$locationProvider', '$httpProvider', ($routeProvider, $locationProvider, $httpProvider) ->
  $routeProvider
    .when('/', templateUrl: 'index', controller: 'TodosIndexCtrl', resolve: { login: requireLogin })
    .when('/signup', templateUrl: 'signup', controller: 'SignupCtrl')
    .when('/login', templateUrl: 'login', controller: 'LoginCtrl')
    .when('/logout', resolve: { logout: logout })
    .when('/settings', templateUrl: 'settings', controller: 'SettingsCtrl')
    .when('/:id', templateUrl: 'todos/show', controller: 'TodosShowCtrl', resolve: { login: requireLogin })

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
      $location.path '/login'
    $http.get('/api/users/current').success(success).error(error)

  return defer.promise
]

logout = ['User', '$http', '$location', (User, $http, $location) ->
  $http.delete('/api/logout').success ->
    User.username = ''
    User.id = ''
    $location.path '/login'
]