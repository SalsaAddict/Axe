/// <reference path="../typings/angularjs/angular.d.ts" />
/// <reference path="../typings/angularjs/angular-route.d.ts" />
/// <reference path="../typings/moment/moment.d.ts" />
var advent = angular.module("advent", ["axe"]);
advent.config(["$routeProvider", function ($routeProvider) {
        $routeProvider
            .when("/home/:IncidentId?/:ClaimId?", { caseInsensitiveMatch: true, templateUrl: "views/home.html" })
            .otherwise({ redirectTo: "/home" });
    }]);
//# sourceMappingURL=advent.js.map