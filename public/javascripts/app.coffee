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
  # Sets app default base URL
  app.baseUrl = '/'
  if window.location.port == ''
    # if production
    # Uncomment app.baseURL below and
    # set app.baseURL to '/your-pathname/' if running from folder in production
    app.baseUrl = '/mountpath/';

  app.displayInstalledToast = ->
    # Check to make sure caching is actually enabled—it won't be in the dev environment.
    if !Polymer.dom(document).querySelector('platinum-sw-cache').disabled
      Polymer.dom(document).querySelector('#caching-complete').show()
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
  window.addEventListener 'paper-header-transform', (e) ->
    appName = Polymer.dom(document).querySelector('#mainToolbar .app-name')
    middleContainer = Polymer.dom(document).querySelector('#mainToolbar .middle-container')
    bottomContainer = Polymer.dom(document).querySelector('#mainToolbar .bottom-container')
    detail = e.detail
    heightDiff = detail.height - (detail.condensedHeight)
    yRatio = Math.min(1, detail.y / heightDiff)
    # appName max size when condensed. The smaller the number the smaller the condensed size.
    maxMiddleScale = 0.50
    auxHeight = heightDiff - (detail.y)
    auxScale = heightDiff / (1 - maxMiddleScale)
    scaleMiddle = Math.max(maxMiddleScale, auxHeight / auxScale + maxMiddleScale)
    scaleBottom = 1 - yRatio
    # Move/translate middleContainer
    Polymer.Base.transform 'translate3d(0,' + yRatio * 100 + '%,0)', middleContainer
    # Scale bottomContainer and bottom sub title to nothing and back
    Polymer.Base.transform 'scale(' + scaleBottom + ') translateZ(0)', bottomContainer
    # Scale middleContainer appName
    Polymer.Base.transform 'scale(' + scaleMiddle + ') translateZ(0)', appName
    return
  # Scroll page to top and expand header

  app.scrollPageToTop = ->
    app.$.headerPanelMain.scrollToTop true
    return

  app.closeDrawer = ->
    app.$.paperDrawerPanel.closeDrawer()
    return

  app.myListItems = [
    name: 'nina'
    gender: 'female'
  ,
    name: 'hannibal'
    gender: 'male'
  ]
  return
