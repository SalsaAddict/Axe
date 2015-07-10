/// <reference path="../typings/angularjs/angular.d.ts" />
/// <reference path="../typings/angularjs/angular-route.d.ts" />
/// <reference path="../typings/moment/moment.d.ts" />
"use strict";
module Axe {
    "use strict";
    export function IsBlank(expression: any): boolean {
        if (expression === undefined) { return true; }
        if (expression === null) { return true; }
        if (expression === NaN) { return true; }
        if (expression === {}) { return true; }
        if (expression === []) { return true; }
        if (String(expression).trim().length === 0) { return true; }
        return false;
    }
    export function IfBlank(expression: any, defaultValue: any = undefined): any {
        return (IsBlank(expression)) ? defaultValue : expression;
    }
    export function Option(value: any, defaultValue: string = "", allowedValues: string[] = []): string {
        var option: string = angular.lowercase(String(value)).trim();
        if (allowedValues.length > 0) {
            var found: boolean = false;
            angular.forEach(allowedValues, (allowedValue: string) => {
                if (angular.lowercase(allowedValue).trim() === option) { found = true; }
            });
            if (!found) { option = undefined; }
        }
        return IfBlank(option, angular.lowercase(defaultValue).trim());
    }
    export enum EFormat { text, integer, decimal, percent, date, time, boolean, object }
    export function Parse(expression: any, format: EFormat, defaultValue: any = undefined): any {
        if (IsBlank(expression)) { return defaultValue; }
        var value: any = expression;
        switch (format) {
            case EFormat.integer: value = parseInt(parseFloat(value).toFixed(0), 10); break;
            case EFormat.decimal: value = parseFloat(parseFloat(value).toFixed(2)); break;
            case EFormat.percent: value = parseFloat(parseFloat(value).toFixed(4)); break;
            case EFormat.date:
                var dateFormat: string = "YYYY-MM-DD";
                switch (Option(value)) {
                    case "today": value = moment().format(dateFormat); break;
                    case "tomorrow": value = moment().add("d", 1).format(dateFormat); break;
                    case "yesterday": value = moment().subtract("d", 1).format(dateFormat); break;
                    default:
                        value = moment(value, "DD/MM/YYYY").format(dateFormat);
                        if (!moment(value).isValid()) { value = undefined; }
                        break;
                }
                break;
            case EFormat.boolean: value = Option(expression, "false", ["true", "yes", "1"]) !== "false"; break;
            case EFormat.object: value = angular.fromJson(angular.toJson(value)); break;
            default: value = String(expression); break;
        }
        return IfBlank(value, defaultValue);
    }
    export module Context {
        export interface IScope extends angular.IScope { }
        export class Controller {
            static $inject: string[] = ["$scope"];
            constructor(private $scope: IScope) { }
            private $procedures: { [alias: string]: Procedure.Controller; } = {};
            addProcedure = (procedure: Procedure.Controller) => {
                this.$procedures[procedure.alias] = procedure;
            }
            removeProcedure = (alias: string) => {
                if (angular.isDefined(this.$procedures[alias])) { delete this.$procedures[alias]; }
            }
            procedure = (alias: string): Procedure.Controller => { return this.$procedures[alias]; }
        }
    }
    export module Procedure {
        export enum ERunType { manual, auto, once }
        export enum EModelType { array, singleton, object }
        export interface IScope extends angular.IScope {
            name: string; alias: string; run: string; model: string; type: string; root: string; routeParams: string;
        }
        interface IPostParameter {
            name: string; value: any; object: boolean;
        }
        interface IPostProcedure {
            name: string; parameters: IPostParameter[]; object: boolean; objectRoot: string;
        }
        export class Controller {
            static $inject: string[] = ["$scope", "$routeParams", "$parse", "$log"];
            constructor(
                private $scope: IScope,
                private $routeParams: angular.route.IRouteParamsService,
                private $parse: angular.IParseService,
                private $log: angular.ILogService) {
                if (Parse(this.$scope.routeParams, EFormat.boolean)) {
                    angular.forEach(this.$routeParams, (value: string, key: string) => {
                        var $scope: Parameter.IScope = <Parameter.IScope>this.$scope.$parent.$new(true);
                        $scope.name = key;
                        $scope.required = "true";
                        this.addParameter(new Parameter.Controller($scope, this.$routeParams, this.$parse));
                    });
                }
            }
            get name(): string { return IfBlank(this.$scope.name); }
            get alias(): string { return IfBlank(this.$scope.alias, this.name); }
            get runType(): ERunType { return IfBlank(ERunType[Option(this.$scope.run)], ERunType.manual); }
            get hasModel(): boolean { return !IsBlank(this.$scope.model); }
            get modelExpression(): string { return IfBlank(this.$scope.model); }
            get modelType(): EModelType {
                if (!this.hasModel) { return undefined; }
                if (IsBlank(this.$scope.type)) { return (IsBlank(this.$scope.root)) ? EModelType.array : EModelType.object; }
                return IfBlank(EModelType[Option(this.$scope.type)], EModelType.array);
            }
            get objectRoot(): string { return (this.modelType === EModelType.object) ? this.$scope.root : undefined; }
            private $parameters: { [name: string]: Parameter.Controller; } = {};
            addParameter = (parameter: Parameter.Controller) => {
                this.$parameters[parameter.name] = parameter;
                if (this.runType === Procedure.ERunType.auto) {
                    parameter.$unwatch = this.$scope.$watch(() => { return parameter.value; },
                        (newValue: any, oldValue: any) => {
                            if (newValue !== oldValue) { this.execute(); }
                        });
                }
            }
            removeParameter = (name: string) => {
                if (angular.isDefined(this.$parameters[name])) {
                    if (angular.isFunction(this.$parameters[name].$unwatch)) { this.$parameters[name].$unwatch(); }
                    delete this.$parameters[name];
                }
            }
            execute = () => {
                var hasRequired: boolean = true;
                var procedure: IPostProcedure = {
                    name: this.name, parameters: [],
                    object: this.modelType === EModelType.object,
                    objectRoot: this.objectRoot
                };
                angular.forEach(this.$parameters, (parameter: Parameter.Controller, key: string) => {
                    if (parameter.required && IsBlank(parameter.value)) { hasRequired = false; }
                    procedure.parameters.push({
                        name: parameter.name,
                        value: parameter.value,
                        object: parameter.format === EFormat.object
                    });
                });
                if (hasRequired) {
                    this.$log.debug(angular.toJson(procedure, true));
                }
            }
        }
    }
    export module Parameter {
        export enum EType { route, scope, value }
        export interface IScope extends angular.IScope {
            name: string; type: string; value: string; format: string; required: string;
        }
        export class Controller {
            static $inject: string[] = ["$scope", "$routeParams", "$parse"];
            constructor(
                private $scope: IScope,
                private $routeParams: angular.route.IRouteParamsService,
                private $parse: angular.IParseService) { }
            get name(): string { return IfBlank(this.$scope.name); }
            get type(): EType {
                if (IsBlank(this.$scope.type)) { return (IsBlank(this.$scope.value)) ? EType.route : EType.value; }
                return EType[Option(this.$scope.type, EType[EType.value], [EType[EType.route], EType[EType.scope]])];
            }
            get valueExpression(): string {
                if (IsBlank(this.$scope.value)) { return (this.type === EType.route) ? this.name : undefined; }
                return this.$scope.value;
            }
            get format(): EFormat {
                return IfBlank(EFormat[Option(this.$scope.format)], EFormat.text);
            }
            get value(): any {
                if (IsBlank(this.valueExpression)) { return null; }
                var value: any = undefined;
                switch (this.type) {
                    case EType.route: value = this.$routeParams[this.valueExpression]; break;
                    case EType.scope: value = this.$parse(this.valueExpression)(this.$scope.$parent); break;
                    default: value = this.valueExpression; break;
                }
                return Parse(value, this.format, null);
            }
            get required(): boolean {
                return Boolean(Parse(this.$scope.required, EFormat.boolean));
            }
            public $unwatch: any = undefined;
        }
    }
}

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
        scope: <Axe.Procedure.IScope> { name: "@", alias: "@", run: "@", model: "@", type: "@", root: "@", routeParams: "@" },
        controller: Axe.Procedure.Controller,
        require: ["^axeContext", "axeProcedure"],
        link: function (
            $scope: Axe.Parameter.IScope,
            iElement: angular.IAugmentedJQuery,
            iAttrs: angular.IAttributes,
            controllers: [Axe.Context.Controller, Axe.Procedure.Controller]) {
            controllers[0].addProcedure(controllers[1]);
            $scope.$on("$destroy", () => { controllers[0].removeProcedure(controllers[1].alias); });
            controllers[1].execute();
        }
    };
});

axe.directive("axeParameter", function () {
    return {
        restrict: "E",
        scope: <Axe.Parameter.IScope> { name: "@", type: "@", value: "@", format: "@", required: "@" },
        controller: Axe.Parameter.Controller,
        require: ["^axeProcedure", "axeParameter"],
        link: function (
            $scope: Axe.Parameter.IScope,
            iElement: angular.IAugmentedJQuery,
            iAttrs: angular.IAttributes,
            controllers: [Axe.Procedure.Controller, Axe.Parameter.Controller]) {
            controllers[0].addParameter(controllers[1]);
            $scope.$on("$destroy", () => { controllers[0].removeParameter(controllers[1].name); });
        }
    };
});