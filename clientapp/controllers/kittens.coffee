'use strict'

angular.module 'kittens', ['ui.router']
.controller 'KittensController', ['$scope', '$location', '$log',
  '$stateParams', 'Global', 'Kittens',
  ($scope, $location, $log, $stateParams, Global, Kittens) ->
    $scope.global = Global

    $scope.info = 'meow'
    $scope.number = 42

    $scope.create =  ->
      kitten =
        name: this.name
      Kittens.save kitten, (response) ->
        $location.path '/' + response._id

    $scope.update =  ->
      # TODO: validation?
      isValid = on
      if isValid isnt null
        kitten = $scope.kitten
        kitten.updated = new Date().getTime()

        kitten.$update ->
          $location.path '/' + kitten._id

      else
        $scope.submitted = true

    $scope.remove = (kitten) ->
      if kitten isnt null
        kitten.$remove()
        for s, i in $scope.kittens by 1
          if s is kitten
            $scope.kittens.splice i, 1
      else
        $scope.kitten.$remove (response) ->
          $location.path 'kittens'

    $scope.find = ->
      Kittens.query (kittens) ->
        $log.log 'kittens: ', kittens
        $scope.kittens = kittens

    $scope.findOne = ->
      Kittens.get
        kittenId: $stateParams.kittenId
      , (kitten) ->
        $scope.kitten = kitten

]
