'use strict'

describe 'Kitten App', ->

  beforeEach module('kittensApp')

  describe 'KittensController workings', ->
    scope = null
    ctrl = null
    $httpBackend = null
    $stateParams = null
    $location = null
    beforeEach inject (_$httpBackend_, _$stateParams_ , $rootScope, $controller, _$location_) ->
      $stateParams = _$stateParams_
      $httpBackend = _$httpBackend_
      scope = $rootScope.$new()
      ctrl  = $controller 'KittensController', $scope: scope
      $location = _$location_

    it 'should find all kittens',  ->
      $httpBackend.expectGET 'kittens/all'
        .respond [
          name: 'Nina'
        ,
          name: 'Myu'
        ]

      scope.find()
      $httpBackend.flush()

      expect(scope.kittens).toBeDefined()
      expect(scope.kittens.length).toBe 2

    it 'should find one kitten',  ->
      $httpBackend.expectGET 'kittens/1'
        .respond name: 'Nina'

      $stateParams.kittenId = 1
      scope.findOne()
      $httpBackend.flush()

      expect(scope.kitten).toBeDefined()
      expect(scope.kitten.name).toBe('Nina')

    it 'should be able to remove kittens', ->
      scope.kittens = [
        name: 'Nina'
        '$remove': ->
          1
      ,
        name: 'Myu'
      ]

      scope.remove scope.kittens[0]

      expect(scope.kittens.length).toBe(1)

    it 'wont remove an item if the item has suffer changes (i.e diff keys)', ->
      scope.kittens = [
        name: 'Nina'
        '$remove': ->
          1
      ,
        name: 'Myu'
      ]

      scope.remove
        name: 'Nina'
        '$remove': ->
          1
        aThing: 2

      expect(scope.kittens.length).toBe 2

    it 'should be able to create kittens', ->
      theExpectedId = 4
      $httpBackend.expectPOST 'kittens'
        .respond
          _id: theExpectedId

      scope.name = 'Nina'
      scope.create()

      $httpBackend.flush()
      expect($location.path()).toBe "/#{theExpectedId}"

    it 'should be able to udpate a kitten', ->
      theExpectedId = 5
      scope.kitten =
        _id: theExpectedId
        name: 'Nina'
        '$update': (cb) ->
          cb()

      scope.update()

      expect($location.path()).toBe "/#{theExpectedId}"
