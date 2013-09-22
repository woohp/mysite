@app.directive 'simpleLineWidthPicker', ->
  restrict: 'E'
  replace: true
  scope:
    choices: '='
    ngModel: '='
  template: """
    <div class="dropdown simple-line-width-picker">
      <a class="btn btn-default" dropdown-toggle>
        <hr class="line-width-preview" style="height: {{ngModel}}px">
        {{ngModel}}
      </a>
      <ul class="dropdown-menu">
        <li ng-repeat="choice in choices">
          <a ng-click="$parent.ngModel = choice">
            <hr class="line-width-preview" style="height: {{choice}}px">
            {{choice}}
          </a>
        </li>
      </ul>
    </div>"""
