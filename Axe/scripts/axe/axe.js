/// <reference path="../typings/angularjs/angular.d.ts" />
/// <reference path="../typings/angularjs/angular-route.d.ts" />
/// <reference path="../typings/moment/moment.d.ts" />
"use strict";
var Axe;
(function (Axe) {
    "use strict";
    function IsBlank(expression) {
        if (expression === undefined) {
            return true;
        }
        if (expression === null) {
            return true;
        }
        if (expression === NaN) {
            return true;
        }
        if (expression === {}) {
            return true;
        }
        if (expression === []) {
            return true;
        }
        if (String(expression).trim().length === 0) {
            return true;
        }
        return false;
    }
    Axe.IsBlank = IsBlank;
    function IfBlank(expression, defaultValue) {
        if (defaultValue === void 0) { defaultValue = undefined; }
        return (IsBlank(expression)) ? defaultValue : expression;
    }
    Axe.IfBlank = IfBlank;
    function Option(value, defaultValue, allowedValues) {
        if (defaultValue === void 0) { defaultValue = ""; }
        if (allowedValues === void 0) { allowedValues = []; }
        var option = angular.lowercase(String(value)).trim();
        if (allowedValues.length > 0) {
            var found = false;
            angular.forEach(allowedValues, function (allowedValue) {
                if (angular.lowercase(allowedValue).trim() === option) {
                    found = true;
                }
            });
            if (!found) {
                option = undefined;
            }
        }
        return IfBlank(option, angular.lowercase(defaultValue).trim());
    }
    Axe.Option = Option;
    (function (EFormat) {
        EFormat[EFormat["text"] = 0] = "text";
        EFormat[EFormat["integer"] = 1] = "integer";
        EFormat[EFormat["decimal"] = 2] = "decimal";
        EFormat[EFormat["percent"] = 3] = "percent";
        EFormat[EFormat["date"] = 4] = "date";
        EFormat[EFormat["time"] = 5] = "time";
        EFormat[EFormat["boolean"] = 6] = "boolean";
        EFormat[EFormat["object"] = 7] = "object";
    })(Axe.EFormat || (Axe.EFormat = {}));
    var EFormat = Axe.EFormat;
    function Parse(expression, format, defaultValue) {
        if (defaultValue === void 0) { defaultValue = undefined; }
        if (IsBlank(expression)) {
            return defaultValue;
        }
        var value = expression;
        switch (format) {
            case EFormat.integer:
                value = parseInt(parseFloat(value).toFixed(0), 10);
                break;
            case EFormat.decimal:
                value = parseFloat(parseFloat(value).toFixed(2));
                break;
            case EFormat.percent:
                value = parseFloat(parseFloat(value).toFixed(4));
                break;
            case EFormat.date:
                var dateFormat = "YYYY-MM-DD";
                switch (Option(value)) {
                    case "today":
                        value = moment().format(dateFormat);
                        break;
                    case "tomorrow":
                        value = moment().add("d", 1).format(dateFormat);
                        break;
                    case "yesterday":
                        value = moment().subtract("d", 1).format(dateFormat);
                        break;
                    default:
                        value = moment(value, "DD/MM/YYYY").format(dateFormat);
                        if (!moment(value).isValid()) {
                            value = undefined;
                        }
                        break;
                }
                break;
            case EFormat.boolean:
                value = Option(expression, "false", ["true", "yes", "1"]) !== "false";
                break;
            case EFormat.object:
                value = angular.fromJson(angular.toJson(value));
                break;
            default:
                value = String(expression);
                break;
        }
        return IfBlank(value, defaultValue);
    }
    Axe.Parse = Parse;
    var Context;
    (function (Context) {
        var Controller = (function () {
            function Controller($scope) {
                var _this = this;
                this.$scope = $scope;
                this.$procedures = {};
                this.addProcedure = function (procedure) {
                    _this.$procedures[procedure.alias] = procedure;
                    if (procedure.runType !== Procedure.ERunType.manual) {
                        procedure.execute();
                    }
                };
                this.removeProcedure = function (alias) {
                    if (angular.isDefined(_this.$procedures[alias])) {
                        delete _this.$procedures[alias];
                    }
                };
                this.execute = undefined;
                this.$scope.$parent.axe = { execute: undefined };
                this.execute = this.$scope.$parent.axe.execute = function (alias) {
                    _this.$procedures[alias].execute();
                };
            }
            Object.defineProperty(Controller.prototype, "heading", {
                get: function () { return IfBlank(this.$scope.heading); },
                enumerable: true,
                configurable: true
            });
            Controller.$inject = ["$scope"];
            return Controller;
        })();
        Context.Controller = Controller;
    })(Context = Axe.Context || (Axe.Context = {}));
    var Procedure;
    (function (Procedure) {
        (function (ERunType) {
            ERunType[ERunType["manual"] = 0] = "manual";
            ERunType[ERunType["auto"] = 1] = "auto";
            ERunType[ERunType["once"] = 2] = "once";
        })(Procedure.ERunType || (Procedure.ERunType = {}));
        var ERunType = Procedure.ERunType;
        (function (EModelType) {
            EModelType[EModelType["array"] = 0] = "array";
            EModelType[EModelType["singleton"] = 1] = "singleton";
            EModelType[EModelType["object"] = 2] = "object";
        })(Procedure.EModelType || (Procedure.EModelType = {}));
        var EModelType = Procedure.EModelType;
        var Controller = (function () {
            function Controller($scope, $routeParams, $parse, $log) {
                var _this = this;
                this.$scope = $scope;
                this.$routeParams = $routeParams;
                this.$parse = $parse;
                this.$log = $log;
                this.$parameters = {};
                this.execute = function () {
                    var hasRequired = true;
                    var procedure = {
                        name: _this.name, parameters: [],
                        object: _this.modelType === EModelType.object,
                        objectRoot: _this.objectRoot
                    };
                    angular.forEach(_this.$parameters, function (parameter, key) {
                        if (parameter.required && IsBlank(parameter.value)) {
                            hasRequired = false;
                        }
                        procedure.parameters.push({
                            name: parameter.name,
                            value: parameter.value,
                            object: parameter.format === EFormat.object
                        });
                    });
                    if (hasRequired) {
                        _this.$log.debug(angular.toJson(procedure));
                    }
                };
                this.addParameter = function (parameter) {
                    _this.$parameters[parameter.name] = parameter;
                    if (_this.runType === Procedure.ERunType.auto) {
                        parameter.$watch = _this.$scope.$watch(function () { return angular.toJson(parameter.value); }, function (newValue, oldValue) {
                            if (newValue !== oldValue) {
                                _this.execute();
                            }
                        });
                    }
                };
                this.removeParameter = function (name) {
                    if (angular.isDefined(_this.$parameters[name])) {
                        if (angular.isFunction(_this.$parameters[name].$watch)) {
                            _this.$parameters[name].$watch();
                        }
                        delete _this.$parameters[name];
                    }
                };
                if (Parse(this.$scope.routeParams, EFormat.boolean)) {
                    angular.forEach(this.$routeParams, function (value, key) {
                        var $scope = _this.$scope.$parent.$new(true);
                        $scope.name = key;
                        $scope.required = "true";
                        _this.addParameter(new Parameter.Controller($scope, _this.$routeParams, _this.$parse));
                    });
                }
            }
            Object.defineProperty(Controller.prototype, "name", {
                get: function () { return IfBlank(this.$scope.name); },
                enumerable: true,
                configurable: true
            });
            Object.defineProperty(Controller.prototype, "alias", {
                get: function () { return IfBlank(this.$scope.alias, this.name); },
                enumerable: true,
                configurable: true
            });
            Object.defineProperty(Controller.prototype, "runType", {
                get: function () { return IfBlank(ERunType[Option(this.$scope.run)], ERunType.manual); },
                enumerable: true,
                configurable: true
            });
            Object.defineProperty(Controller.prototype, "hasModel", {
                get: function () { return !IsBlank(this.$scope.model); },
                enumerable: true,
                configurable: true
            });
            Object.defineProperty(Controller.prototype, "modelExpression", {
                get: function () { return IfBlank(this.$scope.model); },
                enumerable: true,
                configurable: true
            });
            Object.defineProperty(Controller.prototype, "modelType", {
                get: function () {
                    if (!this.hasModel) {
                        return undefined;
                    }
                    if (IsBlank(this.$scope.type)) {
                        return (IsBlank(this.$scope.root)) ? EModelType.array : EModelType.object;
                    }
                    return IfBlank(EModelType[Option(this.$scope.type)], EModelType.array);
                },
                enumerable: true,
                configurable: true
            });
            Object.defineProperty(Controller.prototype, "objectRoot", {
                get: function () { return (this.modelType === EModelType.object) ? this.$scope.root : undefined; },
                enumerable: true,
                configurable: true
            });
            Controller.$inject = ["$scope", "$routeParams", "$parse", "$log"];
            return Controller;
        })();
        Procedure.Controller = Controller;
    })(Procedure = Axe.Procedure || (Axe.Procedure = {}));
    var Parameter;
    (function (Parameter) {
        (function (EType) {
            EType[EType["route"] = 0] = "route";
            EType[EType["scope"] = 1] = "scope";
            EType[EType["value"] = 2] = "value";
        })(Parameter.EType || (Parameter.EType = {}));
        var EType = Parameter.EType;
        var Controller = (function () {
            function Controller($scope, $routeParams, $parse) {
                this.$scope = $scope;
                this.$routeParams = $routeParams;
                this.$parse = $parse;
                this.$watch = undefined;
            }
            Object.defineProperty(Controller.prototype, "name", {
                get: function () { return IfBlank(this.$scope.name); },
                enumerable: true,
                configurable: true
            });
            Object.defineProperty(Controller.prototype, "type", {
                get: function () {
                    if (IsBlank(this.$scope.type)) {
                        return (IsBlank(this.$scope.value)) ? EType.route : EType.value;
                    }
                    return EType[Option(this.$scope.type, EType[EType.value], [EType[EType.route], EType[EType.scope]])];
                },
                enumerable: true,
                configurable: true
            });
            Object.defineProperty(Controller.prototype, "valueExpression", {
                get: function () {
                    if (IsBlank(this.$scope.value)) {
                        return (this.type === EType.route) ? this.name : undefined;
                    }
                    return this.$scope.value;
                },
                enumerable: true,
                configurable: true
            });
            Object.defineProperty(Controller.prototype, "format", {
                get: function () {
                    return IfBlank(EFormat[Option(this.$scope.format)], EFormat.text);
                },
                enumerable: true,
                configurable: true
            });
            Object.defineProperty(Controller.prototype, "value", {
                get: function () {
                    if (IsBlank(this.valueExpression)) {
                        return null;
                    }
                    var value = undefined;
                    switch (this.type) {
                        case EType.route:
                            value = this.$routeParams[this.valueExpression];
                            break;
                        case EType.scope:
                            value = this.$parse(this.valueExpression)(this.$scope.$parent);
                            break;
                        default:
                            value = this.valueExpression;
                            break;
                    }
                    return Parse(value, this.format, null);
                },
                enumerable: true,
                configurable: true
            });
            Object.defineProperty(Controller.prototype, "required", {
                get: function () {
                    return Boolean(Parse(this.$scope.required, EFormat.boolean));
                },
                enumerable: true,
                configurable: true
            });
            Controller.$inject = ["$scope", "$routeParams", "$parse"];
            return Controller;
        })();
        Parameter.Controller = Controller;
    })(Parameter = Axe.Parameter || (Axe.Parameter = {}));
    var Form;
    (function (Form) {
        var Controller = (function () {
            function Controller($scope, $window, $location, $route) {
                var _this = this;
                this.$scope = $scope;
                this.$window = $window;
                this.$location = $location;
                this.$route = $route;
                this.context = undefined;
                this.back = function () {
                    if (IsBlank(_this.$scope.back)) {
                        _this.$window.history.back();
                    }
                    else {
                        _this.$location.path(_this.$scope.back);
                    }
                };
                this.undo = function () { _this.$route.reload(); };
                this.save = function () { _this.context.execute(_this.$scope.save); };
                this.delete = function () { _this.context.execute(_this.$scope.delete); };
            }
            Object.defineProperty(Controller.prototype, "heading", {
                get: function () { return IfBlank(this.$scope.heading); },
                enumerable: true,
                configurable: true
            });
            Object.defineProperty(Controller.prototype, "subheading", {
                get: function () { return IfBlank(this.$scope.subheading); },
                enumerable: true,
                configurable: true
            });
            Object.defineProperty(Controller.prototype, "loadProcedure", {
                get: function () { return IfBlank(this.$scope.load); },
                enumerable: true,
                configurable: true
            });
            Object.defineProperty(Controller.prototype, "editable", {
                get: function () { return !IsBlank(this.$scope.save); },
                enumerable: true,
                configurable: true
            });
            Object.defineProperty(Controller.prototype, "deleteable", {
                get: function () { return !IsBlank(this.$scope.delete); },
                enumerable: true,
                configurable: true
            });
            Controller.$inject = ["$scope", "$window", "$location", "$route"];
            return Controller;
        })();
        Form.Controller = Controller;
    })(Form = Axe.Form || (Axe.Form = {}));
})(Axe || (Axe = {}));
var axe = angular.module("axe", ["ngRoute",
    "templates/axeContext.html",
    "templates/axeForm.html"]);
axe.directive("axeContext", function () {
    return {
        restrict: "E",
        templateUrl: "templates/axeContext.html",
        transclude: true,
        scope: { heading: "@" },
        controller: Axe.Context.Controller,
        controllerAs: "axeContext"
    };
});
axe.directive("axeProcedure", function () {
    return {
        restrict: "E",
        scope: { name: "@", alias: "@", run: "@", model: "@", type: "@", root: "@", routeParams: "@" },
        controller: Axe.Procedure.Controller,
        require: ["^axeContext", "axeProcedure"],
        link: function ($scope, iElement, iAttrs, controllers) {
            controllers[0].addProcedure(controllers[1]);
            $scope.$on("$destroy", function () { controllers[0].removeProcedure(controllers[1].alias); });
        }
    };
});
axe.directive("axeParameter", function () {
    return {
        restrict: "E",
        scope: { name: "@", type: "@", value: "@", format: "@", required: "@" },
        controller: Axe.Parameter.Controller,
        require: ["^axeProcedure", "axeParameter"],
        link: function ($scope, iElement, iAttrs, controllers) {
            controllers[0].addParameter(controllers[1]);
            $scope.$on("$destroy", function () { controllers[0].removeParameter(controllers[1].name); });
        }
    };
});
axe.directive("axeForm", function () {
    return {
        restrict: "E",
        templateUrl: "templates/axeForm.html",
        transclude: true,
        scope: {
            heading: "@", subheading: "@",
            back: "@", load: "@", save: "@", delete: "@"
        },
        controller: Axe.Form.Controller,
        controllerAs: "axeForm",
        require: ["^axeContext", "axeForm"],
        link: function ($scope, iElement, iAttrs, controllers) {
            controllers[1].context = controllers[0];
        }
    };
});
angular.module("templates/axeContext.html", []).run(["$templateCache",
    function ($templateCache) {
        $templateCache.put("templates/axeContext.html", "<div ng-if=\"axeContext.heading\" class=\"text-center\">" +
            "<h4 class=\"text-uppercase text-primary\">{{axeContext.heading}}</h4>" +
            "</div><ng-transclude></ng-transclude>");
    }]);
angular.module("templates/axeForm.html", []).run(["$templateCache",
    function ($templateCache) {
        $templateCache.put("templates/axeForm.html", "<div class=\"panel panel-default\" ng-form=\"form\">" +
            "<div ng-if=\"axeForm.heading\" class=\"panel-heading\"><h4 class=\"text-uppercase\">" +
            "<b>{{axeForm.heading}}</b>" +
            "<span ng-show=\"form.$dirty && form.$invalid\"> <i class=\"fa fa-exclamation-triangle text-danger\"></i></span>" +
            "<span ng-if=\"axeForm.subheading\" class=\"small\"><br />{{axeForm.subheading}}</span>" +
            "</h4></div>" +
            "<div class=\"panel-body\" ng-transclude></div>" +
            "<div class=\"panel-footer clearfix\">" +
            "<div class=\"pull-right\">" +
            "<div ng-hide=\"form.$dirty\" class=\"btn-group\">" +
            "<button ng-if=\"axeForm.deleteable\" type=\"button\" class=\"btn btn-danger\" ng-click=\"axeForm.delete()\">" +
            "<i class=\"fa fa-trash-o\"></i> Delete</button>" +
            "<button type=\"button\" class=\"btn btn-default\" ng-click=\"axeForm.back()\">" +
            "<i class=\"fa fa-chevron-circle-left\"></i> Back</button>" +
            "</div>" +
            "<div ng-show=\"form.$dirty\" class=\"btn-group\">" +
            "<button type=\"button\" class=\"btn btn-warning\" ng-click=\"axeForm.undo()\">" +
            "<i class=\"fa fa-undo\"></i> Undo</button>" +
            "<button type=\"button\" class=\"btn\" ng-class=\"{'btn-primary': form.$valid, 'btn-default': form.$invalid}\" " +
            "ng-click=\"axeForm.save()\" ng-disabled=\"form.$invalid\">" +
            "<i class=\"fa fa-save\"></i> Save</button>" +
            "</div>" +
            "</div>" +
            "</div>" +
            "</div>"); // panel
    }]);
//# sourceMappingURL=axe.js.map