@app.filter('camelCaseToHuman', ->
  (input) ->
    input.charAt(0).toUpperCase() + input.substr(1).replace(/[A-Z]/g, ' $&');
)
