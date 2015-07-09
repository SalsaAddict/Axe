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
                };
                this.removeProcedure = function (alias) {
                    if (angular.isDefined(_this.$procedures[alias])) {
                        delete _this.$procedures[alias];
                    }
                };
                this.procedure = function (alias) { return _this.$procedures[alias]; };
            }
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
            function Controller($scope, $routeParams, $parse) {
                var _this = this;
                this.$scope = $scope;
                this.$routeParams = $routeParams;
                this.$parse = $parse;
                this.$parameters = {};
                this.addParameter = function (parameter) {
                    _this.$parameters[parameter.name] = parameter;
                };
                this.removeParameter = function (name) {
                    if (angular.isDefined(_this.$parameters[name])) {
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
            Controller.$inject = ["$scope", "$routeParams", "$parse"];
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
})(Axe || (Axe = {}));
var axe = angular.module("axe", ["ngRoute"]);
axe.directive("axeContext", function () {
    return {
        restrict: "E",
        controller: Axe.Context.Controller
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
//# sourceMappingURL=axe.js.map