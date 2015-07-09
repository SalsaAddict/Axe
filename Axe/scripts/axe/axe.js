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
        var option = angular.lowercase(value).trim();
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
    var Main;
    (function (Main) {
        var Controller = (function () {
            function Controller($scope) {
                var _this = this;
                this.$scope = $scope;
                this.$procedures = {};
                this.addProcedure = function (procedure) {
                    _this.$procedures[procedure.alias] = procedure;
                };
            }
            Controller.$inject = ["$scope"];
            return Controller;
        })();
        Main.Controller = Controller;
    })(Main = Axe.Main || (Axe.Main = {}));
    var Procedure;
    (function (Procedure) {
        (function (ERunType) {
            ERunType[ERunType["manual"] = 1] = "manual";
            ERunType[ERunType["auto"] = 2] = "auto";
            ERunType[ERunType["once"] = 3] = "once";
        })(Procedure.ERunType || (Procedure.ERunType = {}));
        var ERunType = Procedure.ERunType;
        var Controller = (function () {
            function Controller($scope) {
                this.$scope = $scope;
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
                get: function () { return IfBlank(ERunType[this.$scope.type], ERunType.manual); },
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
                        return "none";
                    }
                    if (IsBlank(this.$scope.type)) {
                        return (IfBlank(this.$scope.root)) ? "array" : "object";
                    }
                    return Option(this.$scope.type, "array", ["singleton", "object"]);
                },
                enumerable: true,
                configurable: true
            });
            Object.defineProperty(Controller.prototype, "objectRoot", {
                get: function () { return (this.modelType === "object") ? this.$scope.root : undefined; },
                enumerable: true,
                configurable: true
            });
            Controller.$inject = ["$scope"];
            return Controller;
        })();
        Procedure.Controller = Controller;
    })(Procedure = Axe.Procedure || (Axe.Procedure = {}));
})(Axe || (Axe = {}));
var axe = angular.module("axe", ["ngRoute"]);
//# sourceMappingURL=axe.js.map