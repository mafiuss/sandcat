'use strict'

describe 'Kitten App', ->

  beforeEach module('kittensApp')

  describe 'KittensController workings', ->
    scope = null
    ctrl = null
    $httpBackend = null
    $stateParams = null
    beforeEach inject (_$httpBackend_, _$stateParams_ , $rootScope, $controller) ->
      $stateParams = _$stateParams_
      $httpBackend = _$httpBackend_
      scope = $rootScope.$new()
      ctrl  = $controller 'KittensController', $scope: scope

    it 'should find all kittens',  ->
      $httpBackend.expectGET 'kittens/all'
        .respond [
          name: 'Nina'
        ,
          name: 'Myu'
        ]

      scope.find()
      $httpBackend.flush()

      console.log scope.kittens
      expect(scope.kittens).toBeDefined()
      expect(scope.kittens.length).toBe 2

    it 'should find one kitten',  ->
      $httpBackend.expectGET 'kittens/1'
        .respond name: 'Nina'

      $stateParams.kittenId = 1
      scope.findOne()
      $httpBackend.flush()

      console.log scope.kitten
      expect(scope.kitten).toBeDefined()
      expect(scope.kitten.name).toBe('Nina')
