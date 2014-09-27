'use strict'

angular.module 'kittens'
.config ['$stateProvider', '$urlRouterProvider',
  ($stateProvider, $urlRouterProvider) ->
    # default state
    $urlRouterProvider.otherwise '/home'

    $stateProvider
    .state 'list',
        url: '/home'
        templateUrl: 'partials/kittens/list'
    .state 'create',
        url: '/create'
        templateUrl: 'partials/kittens/create'
    .state 'edit',
        url: '/edit/:kittenId'
        templateUrl: 'partials/kittens/edit'

]
.config ['$locationProvider',
  ($locationProvider) ->
    $locationProvider.hashPrefix '!'
]
