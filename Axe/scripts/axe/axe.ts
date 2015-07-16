/// <reference path="../typings/angularjs/angular.d.ts" />
/// <reference path="../typings/angularjs/angular-route.d.ts" />
/// <reference path="../typings/angular-ui-bootstrap/angular-ui-bootstrap.d.ts" />
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
    export enum ESize { sm, md, lg }
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
    export module Confirm {
        export class Service {
            static $inject: string[] = ["$modal"];
            constructor(private $modal: angular.ui.bootstrap.IModalService) { }
            confirm = (
                heading: string, message: string, size: ESize = ESize.md,
                yesButtonText: string = "Yes",
                noButtonText: string = "No"): angular.ui.bootstrap.IModalServiceInstance => {
                return this.$modal.open({
                    templateUrl: "templates/axeConfirm.html",
                    backdrop: "static",
                    size: ESize[size],
                    resolve: {
                        heading: () => { return heading; },
                        message: () => { return message; },
                        yesButtonText: () => { return yesButtonText; },
                        noButtonText: () => { return noButtonText; }
                    },
                    controller: Controller,
                    controllerAs: "axeConfirm"
                });
            }
        }
        export class Controller {
            static $inject: string[] = ["$scope", "$modalInstance", "heading", "message", "yesButtonText", "noButtonText"];
            constructor(
                private $scope: angular.ui.bootstrap.IModalScope,
                private $modalInstance: angular.ui.bootstrap.IModalServiceInstance,
                public heading: string, public message: string,
                public yesButtonText: string, public noButtonText: string) {
            }
            yes = () => { this.$modalInstance.close(); }
            no = () => { this.$modalInstance.dismiss(); }
        }
    }
    export module Context {
        export interface IParentScope extends angular.IScope { axe: { execute: Function; } }
        export interface IScope extends angular.IScope { heading: string; }
        export class Controller {
            get heading(): string { return IfBlank(this.$scope.heading); }
            private $procedures: { [alias: string]: Procedure.Controller; } = {};
            addProcedure = (procedure: Procedure.Controller) => {
                this.$procedures[procedure.alias] = procedure;
                if (procedure.runType !== Procedure.ERunType.manual) { procedure.execute(); }
            }
            removeProcedure = (alias: string) => {
                if (angular.isDefined(this.$procedures[alias])) { delete this.$procedures[alias]; }
            }
            execute: Function = undefined;
            static $inject: string[] = ["$scope", "$log"];
            constructor(private $scope: IScope, private $log: angular.ILogService) {
                (<IParentScope>this.$scope.$parent).axe = { execute: undefined };
                this.execute = (<IParentScope>this.$scope.$parent).axe.execute = (alias: string) => {
                    if (angular.isDefined(this.$procedures[alias])) {
                        this.$procedures[alias].execute();
                    } else {
                        $log.error("Axe.Context.Execute: \"" + alias + "\" has not been defined");
                    }
                };
            }
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
                    this.$log.debug(angular.toJson(procedure));
                }
            }
            addParameter = (parameter: Parameter.Controller) => {
                this.$parameters[parameter.name] = parameter;
                if (this.runType === Procedure.ERunType.auto) {
                    parameter.$watch = this.$scope.$watch(function () { return angular.toJson(parameter.value); },
                        (newValue: any, oldValue: any) => {
                            if (newValue !== oldValue) { this.execute(); }
                        });
                }
            }
            removeParameter = (name: string) => {
                if (angular.isDefined(this.$parameters[name])) {
                    if (angular.isFunction(this.$parameters[name].$watch)) { this.$parameters[name].$watch(); }
                    delete this.$parameters[name];
                }
            }
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
        }
    }
    export module Parameter {
        export enum EType { route, scope, value }
        export interface IScope extends angular.IScope {
            name: string; type: string; value: string; format: string; required: string;
        }
        export class Controller {
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
            public $watch: any = undefined;
            static $inject: string[] = ["$scope", "$routeParams", "$parse"];
            constructor(
                private $scope: IScope,
                private $routeParams: angular.route.IRouteParamsService,
                private $parse: angular.IParseService) { }
        }
    }
    export module Form {
        export interface IScope extends angular.IScope {
            heading: string; subheading: string;
            back: string; load: string; save: string; delete: string;
            form: angular.IFormController;
        }
        export class Controller {
            static $inject: string[] = ["$scope", "$window", "$location", "$route", "$filter", "$axeConfirm"];
            constructor(
                private $scope: IScope,
                private $window: angular.IWindowService,
                private $location: angular.ILocationService,
                private $route: angular.route.IRouteService,
                private $filter: angular.IFilterService,
                private $axeConfirm: Axe.Confirm.Service) { }
            public context: Context.Controller = undefined;
            get heading(): string { return IfBlank(this.$scope.heading); }
            get subheading(): string { return IfBlank(this.$scope.subheading); }
            public back = () => {
                if (IsBlank(this.$scope.back)) {
                    this.$window.history.back();
                } else {
                    this.$location.path(this.$scope.back);
                }
            }
            get editable(): boolean { return !IsBlank(this.$scope.save); }
            get deleteable(): boolean { return !IsBlank(this.$scope.delete); }
            get dirty(): boolean { return this.$scope.form.$dirty; }
            get invalid(): boolean { return this.$scope.form.$invalid; }
            get valid(): boolean { return this.$scope.form.$valid; }
            get showErrors(): boolean { return this.$scope.form.$dirty && this.$scope.form.$invalid; }
            public reload = () => { if (!IsBlank(this.$scope.load)) { this.context.execute(this.$scope.load); } }
            public undo = () => {
                this.$axeConfirm.confirm("Undo Changes", "Are you sure?", ESize.sm)
                    .result.then(() => { this.$route.reload(); });
            }
            public save = () => { this.context.execute(this.$scope.save); }
            public delete = () => { this.context.execute(this.$scope.delete); }
            private $sections: Section.Controller[] = [];
            get sections(): Section.Controller[] { return this.$filter("orderBy")(this.$sections, ["sortOrder", "$index"]); }
            public addSection = (section: Section.Controller) => { section.$index = this.$sections.push(section) - 1; }
            public activateSection = (section: Section.Controller) => {
                angular.forEach(this.$sections, function (item: Section.Controller) { item.$active = false; });
                section.$active = true;
            }
        }
        export module Section {
            export interface IScope extends angular.IScope { heading: string; sort: string; form: angular.IFormController; }
            export class Controller {
                static $inject: string[] = ["$scope"];
                constructor(private $scope: IScope) { }
                public $index: number = 0;
                public $active: boolean = false;
                get heading(): string { return IfBlank(this.$scope.heading, "Tab " + IfBlank(this.$index, 0)); }
                get sortOrder(): number { return Parse(this.$scope.sort, EFormat.integer, 0); }
            }
        }
    }
}

var axe = angular.module("axe", [
    "ngRoute", "ui.bootstrap",
    "templates/axeConfirm.html",
    "templates/axeContext.html",
    "templates/axeForm.html",
    "templates/axeFormSection.html"]);

axe.service("$axeConfirm", Axe.Confirm.Service);

axe.directive("axeContext", function () {
    return {
        restrict: "E",
        templateUrl: "templates/axeContext.html",
        transclude: true,
        scope: <Axe.Context.IScope> { heading: "@" },
        controller: Axe.Context.Controller,
        controllerAs: "axeContext"
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

axe.directive("axeForm", function () {
    return {
        restrict: "E",
        templateUrl: "templates/axeForm.html",
        transclude: true,
        scope: <Axe.Form.IScope> {
            heading: "@", subheading: "@",
            back: "@", load: "@", save: "@", delete: "@"
        },
        controller: Axe.Form.Controller,
        controllerAs: "axeForm",
        require: ["^axeContext", "axeForm"],
        link: function (
            $scope: Axe.Parameter.IScope,
            iElement: angular.IAugmentedJQuery,
            iAttrs: angular.IAttributes,
            controllers: [Axe.Context.Controller, Axe.Form.Controller]) {
            controllers[1].context = controllers[0];
            controllers[1].reload();
            if (controllers[1].sections.length > 0) {
                controllers[1].activateSection(controllers[1].sections[0]);
            }
        }
    };
});

axe.directive("axeFormSection", function () {
    return {
        restrict: "E",
        templateUrl: "templates/axeFormSection.html",
        transclude: true,
        scope: <Axe.Form.Section.IScope> { heading: "@", sort: "@" },
        controller: Axe.Form.Section.Controller,
        controllerAs: "axeFormSection",
        require: ["^axeForm", "axeFormSection"],
        link: function (
            $scope: Axe.Form.Section.IScope,
            iElement: angular.IAugmentedJQuery,
            iAttrs: angular.IAttributes,
            controllers: [Axe.Form.Controller, Axe.Form.Section.Controller]) {
            controllers[0].addSection(controllers[1]);
        }
    };
});



angular.module("templates/axeConfirm.html", []).run(["$templateCache",
    function ($templateCache: angular.ITemplateCacheService) {
        $templateCache.put("templates/axeConfirm.html",
            "<div class=\"modal-header\"><h4 class=\"text-primary\">" +
            "<i class=\"fa fa-question-circle\"></i> {{axeConfirm.heading }}</h4></div>" +
            "<div class=\"modal-body\"><p>{{axeConfirm.message}}</p></div>" +
            "<div class=\"modal-footer\">" +
            "<div class=\"btn-group axe-btn-group\">" +
            "<button type=\"submit\" class=\"btn btn-primary\" ng-click=\"axeConfirm.yes()\">" +
            "{{axeConfirm.yesButtonText}}</button>" +
            "<button type=\"reset\" class=\"btn btn-default\" ng-click=\"axeConfirm.no()\">" +
            "{{axeConfirm.noButtonText}}</button>" +
            "</div></div>");
    }]);

angular.module("templates/axeContext.html", []).run(["$templateCache",
    function ($templateCache: angular.ITemplateCacheService) {
        $templateCache.put("templates/axeContext.html",
            "<div ng-if=\"axeContext.heading\" class=\"text-center\">" +
            "<h4 class=\"text-primary\">{{axeContext.heading}}</h4>" +
            "</div><ng-transclude></ng-transclude>");
    }]);

angular.module("templates/axeForm.html", []).run(["$templateCache",
    function ($templateCache: angular.ITemplateCacheService) {
        $templateCache.put("templates/axeForm.html",
            "<div class=\"panel panel-default\" ng-form=\"form\">" +
            "<div ng-if=\"axeForm.heading\" class=\"panel-heading\"><h4>" +
            "{{axeForm.heading}}" +
            "<span ng-show=\"axeForm.showErrors\"> <i class=\"fa fa-exclamation-triangle text-danger\"></i></span>" +
            "<span ng-if=\"axeForm.subheading\" class=\"small\"><br />{{axeForm.subheading}}</span>" +
            "</h4></div>" + // panel-heading
            "<div class=\"panel-body\">" +
            "<ul ng-if=\"axeForm.sections.length > 1\" class=\"nav nav-tabs\">" +
            "<li ng-repeat=\"section in axeForm.sections\" ng-class=\"{active: section.$active}\" " +
            "ng-click=\"axeForm.activateSection(section)\"><a href>{{section.heading}}</a></li>" +
            "</ul>" + // section tabs
            "<br /><ng-transclude></ng-transclude>" +
            "</div>" + // panel-body
            "<div class=\"panel-footer clearfix\">" +
            "<div class=\"pull-right\">" +
            "<div ng-hide=\"axeForm.dirty\" class=\"btn-group axe-btn-group\">" +
            "<button ng-if=\"axeForm.deleteable\" type=\"button\" class=\"btn btn-danger\" ng-click=\"axeForm.delete()\">" +
            "<i class=\"fa fa-trash-o\"></i> Delete</button>" +
            "<button type=\"button\" class=\"btn btn-default\" ng-click=\"axeForm.back()\">" +
            "<i class=\"fa fa-chevron-circle-left\"></i> Back</button>" +
            "</div>" + // button-group (delete/back)
            "<div ng-show=\"axeForm.dirty\" class=\"btn-group axe-btn-group\">" +
            "<button type=\"button\" class=\"btn btn-warning\" ng-click=\"axeForm.undo()\">" +
            "<i class=\"fa fa-undo\"></i> Undo</button>" +
            "<button type=\"button\" class=\"btn\" ng-class=\"{'btn-primary': axeForm.valid, 'btn-default': axeForm.invalid}\" " +
            "ng-click=\"axeForm.save()\" ng-disabled=\"axeForm.invalid\">" +
            "<i class=\"fa fa-save\"></i> Save</button>" +
            "</div>" + // button-group (undo/save)
            "</div>" + // pull-right
            "</div>" + // panel-footer
            "</div>"); // panel
    }]);

angular.module("templates/axeFormSection.html", []).run(["$templateCache",
    function ($templateCache: angular.ITemplateCacheService) {
        $templateCache.put("templates/axeFormSection.html",
            "<div ng-show=\"axeFormSection.$active\" ng-form=\"form\" ng-transclude></div>");
    }]);