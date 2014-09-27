'use strict'

angular.module 'kittenServices', ['ngResource']
.factory 'Kittens', [ '$resource', ($resource) ->
  $resource 'kittens/:kittenId', kittenId: '@_id',
    update:
      method: 'PUT'

    query:
      params: {kittenId: 'all'}
      isArray: on
]
