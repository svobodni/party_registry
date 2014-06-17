// app.js
var routerApp = angular.module('routerApp', ['ui.router','ngGrid']);

routerApp.config(function($stateProvider, $urlRouterProvider) {
    
    $urlRouterProvider.otherwise('/regions');
    
    $stateProvider
        
        // HOME STATES AND NESTED VIEWS ========================================
        .state('national_committees', {
            url: '/national_committees',
            templateUrl: '/client/templates/national_committees.html'
        })
        .state('national_committee', {
            url: '/national_committees/:committeeId',
            templateUrl: '/client/templates/national_committee.html'
        })
        .state('people', {
            url: '/people',
            templateUrl: '/client/templates/people/index.html'
        })
        .state('profile', {
            url: '/profile',
            templateUrl: '/client/templates/profile.html'
        })
        .state('regions', {
            url: '/regions',
            templateUrl: '/client/templates/regions.html'
        })
        .state('region', {
            url: '/regions/:regionId',
            templateUrl: '/client/templates/region.html',
        })
        .state('region.presidency', {
            templateUrl: '/client/templates/regions/presidency.html'
        })
        .state('region.branches', {
            templateUrl: '/client/templates/regions/branches.html'
        })
        .state('region.people', {
            templateUrl: '/client/templates/people/index.html'
        })
        .state('branch', {
            url: '/branches/:branchId',
            templateUrl: '/client/templates/branches/show.html',
        })
        .state('branch.people', {
            templateUrl: '/client/templates/people/index.html'
        })
        .state('awaiting_domestic_people', {
            url: '/regions/:regionId/awaiting_domestic_people',
            templateUrl: '/client/templates/awaiting_domestic_people.html'
        });        
});

function ProfileController($rootScope, $scope, $http) {
    $http.get('/people/profile.json').
        success(function(data) {
            $rootScope.profile = data.person;
            $rootScope.signed_in = true;
        }).error(function(data) {
            $rootScope.signed_in = false;
        });
}

function BranchController($scope, $http, $stateParams) {
    $http.get('/branches/'+$stateParams.branchId+'.json')
    .success(function(data) {
        $scope.branch = data.branch;
    });
}

function PeopleController($scope, $http, $stateParams, $filter) {
    $scope.filterOptions = {
      filterText: ''
    };
    $scope.gridOptions = { 
                data: 'people',
                showGroupPanel: true,
                showFilter: true,
                plugins: [new ngGridCsvExportPlugin()],
                showColumnMenu: true,
                showFooter: true,
                filterOptions: $scope.filterOptions,
                columnDefs: [
                    {field:'first_name', displayName:'Jmeno'},
                    {field:'last_name', displayName:'Prijmeni'},
                    {field:'phone', displayName:'Telefon'},
                    {field:'email', displayName:'Email'},
                    {field:'domestic_region.name', displayName:'Domovsky kraj'},
                    {field:'domestic_branch.name', displayName:'Domovska pobocka'},
                    {field:'type', displayName:'Typ'}
                ]
            };
    if ($stateParams.regionId) {
        path =  '/regions/'+$stateParams.regionId+'/people.json'
    } else if ($stateParams.branchId) {
        path =  '/branches/'+$stateParams.branchId+'/people.json'
    } else {
        path = '/people.json'
    }
    $http.get(path). //, { cache: true }).
        success(function(data) {
            $scope.people = data.people;
            // $scope.branches = _.chain(data.people).map(function(person){ return person.domestic_branch }).uniq(function(branch) {return branch.name;}).sortBy(function(branch){ return branch.name; }).value();

        });
}

function OrganizationsController($scope, $http, $stateParams) {
    $http.get('/bodies.json', { cache: true }).
        success(function(data) {
            $scope.bodies = data.bodies;
        	$scope.national_committees = _.select(data.bodies, function(body){ return body.organization.id == 100; });
        	$scope.regional_committees = _.reject(data.bodies, function(body){ return body.organization.id == 100; });
            // current region
        	$scope.region = _.find(data.bodies, function(body){ return body.organization.id == $stateParams.regionId; });
            // current committee
            $scope.national_committee = _.find(data.bodies, function(body){ return body.id == $stateParams.committeeId; });
        });
}
