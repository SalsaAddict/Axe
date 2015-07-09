/// <reference path="../typings/angularjs/angular.d.ts" />
/// <reference path="../typings/angularjs/angular-route.d.ts" />
/// <reference path="../typings/moment/moment.d.ts" />
"use strict";
module Axe {
    "use strict";
    export function IsBlank(expression: any): boolean {
        if (expression === undefined) { return true; }
        if (expression === null) { return true; }
        if (expression === {}) { return true; }
        if (expression === []) { return true; }
        if (String(expression).trim().length === 0) { return true; }
        return false;
    }
    export function IfBlank(expression: any, defaultValue: any = undefined): any {
        return (IsBlank(expression)) ? defaultValue : expression;
    }
    export function Option(value: any, defaultValue: string = "", allowedValues: string[] = []): string {
        var option: string = angular.lowercase(value).trim();
        if (allowedValues.length > 0) {
            var found: boolean = false;
            angular.forEach(allowedValues, (allowedValue: string) => {
                if (angular.lowercase(allowedValue).trim() === option) { found = true; }
            });
            if (!found) { option = undefined; }
        }
        return IfBlank(option, angular.lowercase(defaultValue).trim());
    }
    export module Main {
        export interface IScope extends angular.IScope { }
        export class Controller {
            static $inject: string[] = ["$scope"];
            constructor(private $scope: IScope) { }
            private $procedures: { [alias: string]: Procedure.Controller; } = {};
            addProcedure = (procedure: Procedure.Controller) => {
                this.$procedures[procedure.alias] = procedure;
            }
        }
    }
    export module Procedure {
        export enum ERunType { manual = 1, auto, once }
        export enum EModelType { array = 1, singleton, object }
        export interface IScope extends angular.IScope {
            name: string; alias: string; run: string; model: string; type: string; root: string;
        }
        export class Controller {
            static $inject: string[] = ["$scope"];
            constructor(private $scope: IScope) { }
            get name(): string { return IfBlank(this.$scope.name); }
            get alias(): string { return IfBlank(this.$scope.alias, this.name); }
            get runType(): ERunType { return IfBlank(ERunType[this.$scope.type], ERunType.manual); }
            get hasModel(): boolean { return !IsBlank(this.$scope.model); }
            get modelExpression(): string { return IfBlank(this.$scope.model); }
            get modelType(): string {
                if (!this.hasModel) { return "none"; }
                if (IsBlank(this.$scope.type)) { return (IfBlank(this.$scope.root)) ? "array" : "object"; }
                return Option(this.$scope.type, "array", ["singleton", "object"]);
            }
            get objectRoot(): string { return (this.modelType === "object") ? this.$scope.root : undefined; }
        }
    }
}


var axe = angular.module("axe", ["ngRoute"]);