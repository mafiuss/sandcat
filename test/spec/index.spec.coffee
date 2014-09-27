'use strict'

describe 'Index Controller', ->

  beforeEach module('home')

  it 'should have an info value', inject ($controller) ->
    scope = {}
    ctrl = $controller 'IndexController', $scope: scope
    expect(scope.info).toBe 'meow'
