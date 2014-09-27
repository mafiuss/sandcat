'use strict'

describe 'Hairball Controllers', ->

  beforeEach module('hairball')
  beforeEach module('systemServices')

  describe 'HairballController workings', ->
    scope = null
    ctrl = null
    beforeEach inject (_$httpBackend_, $rootScope, $controller) ->
      $httpBackend = _$httpBackend_
      scope = $rootScope.$new()
      ctrl  = $controller 'HairballController', $scope: scope

    it 'should have an info value',  ->
      expect(scope.info).toBe 'meow'

    it 'should have the expected number value',  ->
      expect(scope.number).toBe 42

  describe 'SiblingController workings', ->
    scope = null
    ctrl = null
    beforeEach inject (_$httpBackend_, $rootScope, $controller) ->
      $httpBackend = _$httpBackend_
      scope = $rootScope.$new()
      ctrl  = $controller 'SiblingController', $scope: scope

    it 'should have an info value',  ->
      expect(scope.info).toBe 'purr'
