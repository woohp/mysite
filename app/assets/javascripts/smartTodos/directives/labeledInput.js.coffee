@app.directive 'labeledInput', ->
  restrict: 'E'
  replace: true
  scope:
    label: '@'
    ngModel: '='
  template: '<div class="control-group"><label class="control-label">{{label}}</label><div class="controls"><input ng-model="ngModel"></div></div>'
  link: (scope, element, attrs) ->
    id = "input-#{Math.floor(Math.random() * 100000)}"
    element.find('label').attr('for', id)
    inputElement = element.find('input')
    inputElement.attr('id', id)

    for key, val of attrs when !key.match(/^\$/) and key != 'label' and key != 'ngModel'
      val = val.replace(/\s*control-group\s*/g, '') if key == 'class'
      inputElement.attr(key, val)

