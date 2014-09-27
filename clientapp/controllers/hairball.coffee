'use strict'

angular.module 'hairball', ['ui.router']
.controller 'HairballController', ['$scope', 'Global',
  ($scope, Global) ->
    $scope.global = Global

    $scope.info = 'meow'
    $scope.number = 42
]
.controller 'SiblingController', ['$scope', 'Global',
  ($scope, Global) ->

    $scope.changeThing = ->
      Global.aThing = 'changedThing'

    $scope.global = Global
    $scope.info = 'purr'
]
