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
    export enum EContext { primary, success, warning, danger }
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
                        value = moment(value).format(dateFormat);
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
    export module Alert {
        export class Service {
            static $inject: string[] = ["$modal", "$timeout"];
            constructor(
                private $modal: angular.ui.bootstrap.IModalService,
                private $timeout: angular.ITimeoutService) { }
            alert = (context: EContext, message: string, size: ESize = ESize.sm, timeout: number = 0) => {
                var modal: angular.ui.bootstrap.IModalServiceInstance = this.$modal.open({
                    templateUrl: "templates/axeAlert.html",
                    backdrop: "static",
                    keyboard: false,
                    size: ESize[size],
                    resolve: { context: () => { return context; }, message: () => { return message; } },
                    controller: Controller,
                    controllerAs: "axeAlert"
                });
                if (Parse(timeout, EFormat.integer, 0) > 0) { this.$timeout(() => { modal.close(); }, timeout); }
            }
        }
        export class Controller {
            static $inject: string[] = ["$scope", "$modalInstance", "context", "message"];
            constructor(
                private $scope: angular.ui.bootstrap.IModalScope,
                private $modalInstance: angular.ui.bootstrap.IModalServiceInstance,
                public context: EContext, public message: string) {
            }
            get heading(): string {
                switch (this.context) {
                    case EContext.primary: return "Info";
                    case EContext.success: return "Success";
                    case EContext.warning: return "Warning";
                    case EContext.danger: return "Error";
                }
            }
            get faIcon(): string {
                switch (this.context) {
                    case EContext.primary: return "fa-info-circle";
                    case EContext.success: return "fa-check-circle";
                    case EContext.warning: return "fa-exclamation-circle";
                    case EContext.danger: return "fa-times-circle";
                }
            }
            get textContext(): string { return "text-" + EContext[this.context]; }
            close = () => { this.$modalInstance.close(); }
        }
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
                    keyboard: false,
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
            addParameter = (procedureAlias: string, parameter: Procedure.Parameter.Controller) => {
                this.$procedures[procedureAlias].addParameter(parameter);
            }
            removeParameter = (procedureAlias: string, parameterName: string) => {
                this.$procedures[procedureAlias].removeParameter(parameterName);
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
    }
    export module Form {
        export interface IScope extends angular.IScope {
            heading: string; subheading: string;
            back: string; load: string; save: string; delete: string;
            labelWidth: string;
            form: angular.IFormController;
        }
        export class Controller {
            static $inject: string[] = ["$scope", "$window", "$location", "$route", "$filter", "$axeConfirm", "$axeAlert"];
            constructor(
                private $scope: IScope,
                private $window: angular.IWindowService,
                private $location: angular.ILocationService,
                private $route: angular.route.IRouteService,
                private $filter: angular.IFilterService,
                private $axeConfirm: Axe.Confirm.Service,
                private $axeAlert: Axe.Alert.Service) { }
            public $parent: Context.Controller = undefined;
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
            get hasError(): boolean { return this.$scope.form.$dirty && this.$scope.form.$invalid; }
            public reload = () => { if (!IsBlank(this.$scope.load)) { this.$parent.execute(this.$scope.load); } }
            public undo = () => {
                this.$axeConfirm.confirm("Undo Changes", "Are you sure you want to undo your changes?", ESize.sm)
                    .result.then(() => { this.$route.reload(); });
            }
            public save = () => { this.$parent.execute(this.$scope.save); }
            public delete = () => {
                this.$axeConfirm.confirm("Delete Record", "Are you sure you want to delete this record?", ESize.sm)
                    .result.then(() => {
                    this.$parent.execute(this.$scope.delete);
                    this.$axeAlert.alert(EContext.success, "The record has been successfully deleted.", ESize.sm, 3000);
                });
            }
            private $sections: Section.Controller[] = [];
            get sections(): Section.Controller[] { return this.$filter("orderBy")(this.$sections, ["sortOrder", "$index"]); }
            public addSection = (section: Section.Controller) => {
                section.$parent = this;
                section.$index = this.$sections.push(section) - 1;
            }
            public removeSection = (section: Section.Controller) => {
                var i: number = this.$sections.indexOf(section);
                if (i >= 0) { this.$sections.splice(i, 1); }
            }
            public activateSection = (section: Section.Controller) => {
                angular.forEach(this.$sections, function (item: Section.Controller) { item.$active = false; });
                section.$active = true;
            }
            get labelWidth(): number { return Parse(this.$scope.labelWidth, EFormat.integer, 3); }
            public addSaveParameter = (parameter: Axe.Procedure.Parameter.Controller) => {
                this.$parent.addParameter(this.$scope.save, parameter);
            }
        }
        export module Section {
            export interface IScope extends angular.IScope { heading: string; sort: string; form: angular.IFormController; }
            export class Controller {
                static $inject: string[] = ["$scope"];
                constructor(private $scope: IScope) { }
                public $parent: Form.Controller = undefined;
                public $index: number = 0;
                public $active: boolean = false;
                get heading(): string { return IfBlank(this.$scope.heading, "Tab " + IfBlank(this.$index, 0)); }
                get sortOrder(): number { return Parse(this.$scope.sort, EFormat.integer, 0); }
                get hasError(): boolean {
                    if (this.$scope.form.$valid) { return false; }
                    if (angular.isUndefined(this.$parent)) { return false; }
                    return this.$parent.dirty;
                }
            }
            export module Label {
                export interface IScope extends angular.IScope {
                    heading: string; width: string; form: angular.IFormController;
                }
                export class Controller {
                    static $inject: string[] = ["$scope"];
                    constructor(private $scope: IScope) { }
                    public $parent: Section.Controller = undefined;
                    get heading(): string { return IfBlank(this.$scope.heading); }
                    get labelWidth(): number {
                        var width: number = Parse(this.$scope.width, EFormat.integer);
                        if (IsBlank(width)) {
                            if (angular.isDefined(this.$parent)) {
                                if (angular.isDefined(this.$parent.$parent)) {
                                    width = Parse(this.$parent.$parent.labelWidth, EFormat.integer);
                                }
                            }
                        }
                        width = IfBlank(width, 3);
                        return ((width >= 1) && (width <= 6)) ? width : 3;
                    }
                    get itemWidth(): number { return 12 - this.labelWidth; }
                    get hasError(): boolean {
                        if (this.$scope.form.$valid) { return false; }
                        if (angular.isUndefined(this.$parent)) { return false; }
                        if (angular.isUndefined(this.$parent.$parent)) { return false; }
                        return this.$parent.$parent.dirty;
                    }
                }
            }
        }
    }
}

var axe = angular.module("axe", [
    "ngRoute", "ui.bootstrap",
    "templates/axeAlert.html",
    "templates/axeConfirm.html",
    "templates/axeContext.html",
    "templates/axeForm.html",
    "templates/axeFormSection.html",
    "templates/axeFormLabel.html"]);

axe.service("$axeAlert", Axe.Alert.Service);
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
        link: {
            pre: function (
                $scope: Axe.Procedure.Parameter.IScope,
                iElement: angular.IAugmentedJQuery,
                iAttrs: angular.IAttributes,
                controllers: [Axe.Context.Controller, Axe.Procedure.Controller]) {
                controllers[0].addProcedure(controllers[1]);
                $scope.$on("$destroy", () => { controllers[0].removeProcedure(controllers[1].alias); });
            }
        }
    };
});

axe.directive("axeParameter", function () {
    return {
        restrict: "E",
        scope: <Axe.Procedure.Parameter.IScope> { name: "@", type: "@", value: "@", format: "@", required: "@" },
        controller: Axe.Procedure.Parameter.Controller,
        require: ["^axeProcedure", "axeParameter"],
        link: {
            pre: function (
                $scope: Axe.Procedure.Parameter.IScope,
                iElement: angular.IAugmentedJQuery,
                iAttrs: angular.IAttributes,
                controllers: [Axe.Procedure.Controller, Axe.Procedure.Parameter.Controller]) {
                controllers[0].addParameter(controllers[1]);
                $scope.$on("$destroy", () => { controllers[0].removeParameter(controllers[1].name); });
            }
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
            back: "@", load: "@", save: "@", delete: "@",
            labelWidth: "@"
        },
        controller: Axe.Form.Controller,
        controllerAs: "axeForm",
        require: ["^axeContext", "axeForm"],
        link: {
            pre: function (
                $scope: Axe.Procedure.Parameter.IScope,
                iElement: angular.IAugmentedJQuery,
                iAttrs: angular.IAttributes,
                controllers: [Axe.Context.Controller, Axe.Form.Controller]) {
                controllers[1].$parent = controllers[0];
            },
            post: function (
                $scope: Axe.Procedure.Parameter.IScope,
                iElement: angular.IAugmentedJQuery,
                iAttrs: angular.IAttributes,
                controllers: [Axe.Context.Controller, Axe.Form.Controller]) {
                controllers[1].reload();
                if (controllers[1].sections.length > 0) {
                    controllers[1].activateSection(controllers[1].sections[0]);
                }
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
        link: {
            pre: function (
                $scope: Axe.Form.Section.IScope,
                iElement: angular.IAugmentedJQuery,
                iAttrs: angular.IAttributes,
                controllers: [Axe.Form.Controller, Axe.Form.Section.Controller]) {
                controllers[0].addSection(controllers[1]);
                $scope.$on("$destroy", () => { controllers[0].removeSection(controllers[1]); });
            }
        }
    };
});

axe.directive("axeFormLabel", function () {
    return {
        restrict: "E",
        templateUrl: "templates/axeFormLabel.html",
        transclude: true,
        scope: <Axe.Form.Section.Label.IScope> { heading: "@", width: "@" },
        controller: Axe.Form.Section.Label.Controller,
        controllerAs: "axeFormLabel",
        require: ["^axeFormSection", "axeFormLabel"],
        link: {
            pre: function (
                $scope: Axe.Form.Section.IScope,
                iElement: angular.IAugmentedJQuery,
                iAttrs: angular.IAttributes,
                controllers: [Axe.Form.Section.Controller, Axe.Form.Section.Label.Controller]) {
                controllers[1].$parent = controllers[0];
            }
        }
    };
});

axe.directive("axeFormInput", function () {
    return {
        restrict: "A",
        require: ["ngModel"],
        link: {
            pre: function (
                $scope: angular.IScope,
                iElement: angular.IAugmentedJQuery,
                iAttrs: angular.IAttributes,
                controllers: [angular.INgModelController]) {
                if (!iElement.hasClass("form-control")) { iElement.addClass("form-control"); }
                window.console.log(iAttrs["ngModel"]);
            }
        }
    };
});

axe.directive("axeSave", function () {
    return {
        restrict: "A",
        require: ["ngModel", "^axeFormLabel"],
        link: {
            pre: function (
                $scope: angular.IScope,
                iElement: angular.IAugmentedJQuery,
                iAttrs: angular.IAttributes,
                controllers: [angular.INgModelController, Axe.Form.Section.Label.Controller]) {
                var $injector: angular.auto.IInjectorService = angular.injector(["ngRoute"]);
                var $parameterScope: Axe.Procedure.Parameter.IScope = <Axe.Procedure.Parameter.IScope>$scope.$new(true);
                $parameterScope.name = iAttrs["axeSave"];
                $parameterScope.type = "scope";
                $parameterScope.value = iAttrs["ngModel"];
                $parameterScope.format = iAttrs["axeFormat"];
                if (angular.isDefined(iAttrs["required"])) { $parameterScope.required = "true"; }
                controllers[1].$parent.$parent.addSaveParameter(<Axe.Procedure.Parameter.Controller>
                    $injector.instantiate(Axe.Procedure.Parameter.Controller, { $scope: $parameterScope }));
            }
        }
    };
});

angular.module("templates/axeAlert.html", []).run(["$templateCache",
    function ($templateCache: angular.ITemplateCacheService) {
        $templateCache.put("templates/axeAlert.html",
            "<div class=\"modal-header\"><h4 class=\"{{axeAlert.textContext}}\">" +
            "<i class=\"fa fa-lg {{axeAlert.faIcon}}\"></i> {{axeAlert.heading}}</h4></div>" +
            "<div class=\"modal-body\"><p>{{axeAlert.message}}</p></div>" +
            "<div class=\"modal-footer\">" +
            "<div class=\"btn-group axe-btn-group\">" +
            "<button type=\"submit\" class=\"btn btn-xs btn-default\" ng-click=\"axeAlert.close()\">Ok</button>" +
            "</div></div>");
    }]);

angular.module("templates/axeConfirm.html", []).run(["$templateCache",
    function ($templateCache: angular.ITemplateCacheService) {
        $templateCache.put("templates/axeConfirm.html",
            "<div class=\"modal-header\"><h4 class=\"text-primary\">" +
            "<i class=\"fa fa-lg fa-question-circle\"></i> {{axeConfirm.heading}}</h4></div>" +
            "<div class=\"modal-body\"><p>{{axeConfirm.message}}</p></div>" +
            "<div class=\"modal-footer\">" +
            "<div class=\"btn-group btn-group-xs axe-btn-group\">" +
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
            "<div class=\"panel panel-default form-horizontal\" ng-form=\"form\">" +
            "<div ng-if=\"axeForm.heading\" class=\"panel-heading\"><h4>" +
            "{{axeForm.heading}}" +
            "<span ng-show=\"axeForm.hasError\"> <i class=\"fa fa-exclamation-triangle text-danger\"></i></span>" +
            "<span ng-if=\"axeForm.subheading\" class=\"small\"><br />{{axeForm.subheading}}</span>" +
            "</h4></div>" + // panel-heading
            "<div class=\"panel-body\">" +
            "<ul ng-if=\"axeForm.sections.length > 1\" class=\"nav nav-tabs\">" +
            "<li ng-repeat=\"section in axeForm.sections\" ng-class=\"{active: section.$active}\" " +
            "ng-click=\"axeForm.activateSection(section)\"><a href>{{section.heading}}" +
            "<span ng-show=\"section.hasError\"> <i class=\"fa fa-exclamation-triangle text-danger\"></i></span>" +
            "</a></li>" +
            "</ul>" + // section tabs
            "<br ng-if=\"axeForm.sections.length > 1\" /><ng-transclude></ng-transclude>" +
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

angular.module("templates/axeFormLabel.html", []).run(["$templateCache",
    function ($templateCache: angular.ITemplateCacheService) {
        $templateCache.put("templates/axeFormLabel.html",
            "<div class=\"form-group\" ng-class=\"{'has-error': axeFormLabel.hasError}\" ng-form=\"form\">" +
            "<label class=\"control-label col-sm-{{axeFormLabel.labelWidth}}\">" +
            "{{axeFormLabel.heading}}</label>" +
            "<div class=\"col-sm-{{axeFormLabel.itemWidth}}\" ng-transclude></div>" +
            "</div>");
    }]);
