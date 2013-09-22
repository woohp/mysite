@app.directive 'simpleColorPicker', ->
  restrict: 'E'
  replace: true
  scope:
    choices: '='
    ngModel: '='
  template: """
    <div class="dropdown simple-color-picker">
      <a class="btn btn-default" dropdown-toggle>
        <span class="color-preview" style="background-color: {{ngModel}}" /> {{ngModel}}
      </a>
      <ul class="dropdown-menu">
        <li ng-repeat="choice in choices">
          <a ng-click="$parent.ngModel = choice">
            <span class="color-preview" style="background-color: {{choice}}" />
            {{choice}}
          </a>
        </li>
      </ul>
    </div>"""
