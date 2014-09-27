'use strict'

angular.module 'systemServices', []

.factory 'Global', [ =>
    this.data =
      aThing: 'aThing1'
      otherThing: 2
]
