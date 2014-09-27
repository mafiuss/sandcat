'use strict'

angular.module 'hairball'
.config ['$stateProvider', '$urlRouterProvider',
  ($stateProvider, $urlRouterProvider) ->
    # default state
    $urlRouterProvider.otherwise '/landing'

    $stateProvider
    .state 'hairballstate1',
        url: '/landing'
        templateUrl: 'partials/hairballstate1'
    .state 'hairballstate2',
        url: '/b'
        templateUrl: 'partials/hairballstate2'
    .state 'experiment',
        url: '/experiment'
        templateUrl: 'partials/hairballstate3'

]
.config ['$locationProvider',
  ($locationProvider) ->
    $locationProvider.hashPrefix '!'
]
