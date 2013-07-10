@app.directive 'formModel', [->
  restrict: 'A'
  replace: false
  link: (scope, elem, attrs) ->
    scope.formModel = {}

    elem.find('input, textarea').each (i, e) ->
      name = e.getAttribute 'name'
      if name?
        scope.formModel[name]
        console.log scope.formModel

    console.log scope
    console.log attrs
]
