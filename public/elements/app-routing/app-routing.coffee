window.addEventListener 'WebComponentsReady', ->
  # Routes
  # We use Page.js for routing. This is a Micro
  # client-side router inspired by the Express router
  # More info: https://visionmedia.github.io/page.js/
  # Removes end / from app.baseUrl which page.base requires for production
  if window.location.port == '' or app.baseUrl isnt '/'
    # if production
    page.base app.baseUrl.replace(/\/$/, '')

  # Middleware
  scrollToTop = (ctx, next) ->
    app.scrollPageToTop()
    next()
    return

  closeDrawer = (ctx, next) ->
    app.closeDrawer()
    next()
    return


  # Routes
  page '*', scrollToTop, closeDrawer, (ctx, next) ->
    next()
    return
  page '/', ->
    app.route = 'home'
    return
  page app.baseUrl, ->
    app.route = 'home'
    return
  page '/users', ->
    app.route = 'users'
    return
  page '/users/:name', (data) ->
    app.route = 'user-info'
    app.params = data.params
    return
  page '/contact', ->
    app.route = 'contact'
    return
  # 404
  page '*', ->
    app.$.toast.text = 'Can\'t find: ' + window.location.href + '. Redirected you to Home Page'
    app.$.toast.show()
    page.redirect app.baseUrl
    return
  # add #! before urls
  page hashbang: true
