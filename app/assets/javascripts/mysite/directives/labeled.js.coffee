@app.directive 'labeled', ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    id = "input-#{Math.floor(Math.random() * 100000000)}"
    element.attr('id', id)
    element.parents('.form-group').find('label[labeler]').attr('for', id)
