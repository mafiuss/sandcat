###
Copyright (c) 2015 The Polymer Project Authors. All rights reserved.
This code may only be used under the BSD style license found at http://polymer.github.io/LICENSE.txt
The complete set of authors may be found at http://polymer.github.io/AUTHORS.txt
The complete set of contributors may be found at http://polymer.github.io/CONTRIBUTORS.txt
Code distributed by Google as part of the polymer project is also
subject to an additional IP rights grant found at http://polymer.github.io/PATENTS.txt
###

do (document) ->
  'use strict'
  # Grab a reference to our auto-binding template
  # and give it some initial binding values
  # Learn more about auto-binding templates at http://goo.gl/Dx1u2g
  app = document.querySelector('#app')

  app.displayInstalledToast = ->
    # Check to make sure caching is actually enabled—it won't be in the dev environment.
    if !document.querySelector('platinum-sw-cache').disabled
      document.querySelector('#caching-complete').show()
    return

  # Listen for template bound event to know when bindings
  # have resolved and content has been stamped to the page
  app.addEventListener 'dom-change', ->
    console.log 'Our app is ready to rock!'
    return
  # See https://github.com/Polymer/polymer/issues/1381
  window.addEventListener 'WebComponentsReady', ->
    # imports are loaded and elements have been registered
    return
  # Main area's paper-scroll-header-panel custom condensing transformation of
  # the appName in the middle-container and the bottom title in the bottom-container.
  # The appName is moved to top and shrunk on condensing. The bottom sub title
  # is shrunk to nothing on condensing.
  addEventListener 'paper-header-transform', (e) ->
    appName = document.querySelector('#mainToolbar .app-name')
    middleContainer = document.querySelector('#mainToolbar .middle-container')
    bottomContainer = document.querySelector('#mainToolbar .bottom-container')
    detail = e.detail
    heightDiff = detail.height - (detail.condensedHeight)
    yRatio = Math.min(1, detail.y / heightDiff)
    maxMiddleScale = 0.50
    # appName max size when condensed. The smaller the number the smaller the condensed size.
    scaleMiddle = Math.max(maxMiddleScale, (heightDiff - (detail.y)) / (heightDiff / (1 - maxMiddleScale)) + maxMiddleScale)
    scaleBottom = 1 - yRatio
    # Move/translate middleContainer
    Polymer.Base.transform 'translate3d(0,' + yRatio * 100 + '%,0)', middleContainer
    # Scale bottomContainer and bottom sub title to nothing and back
    Polymer.Base.transform 'scale(' + scaleBottom + ') translateZ(0)', bottomContainer
    # Scale middleContainer appName
    Polymer.Base.transform 'scale(' + scaleMiddle + ') translateZ(0)', appName
    return
  # Close drawer after menu item is selected if drawerPanel is narrow

  app.onDataRouteClick = ->
    drawerPanel = document.querySelector('#paperDrawerPanel')
    if drawerPanel.narrow
      drawerPanel.closeDrawer()
    return

  # Scroll page to top and expand header

  app.scrollPageToTop = ->
    document.getElementById('mainContainer').scrollTop = 0
    return

  return
