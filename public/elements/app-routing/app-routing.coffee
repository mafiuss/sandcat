window.addEventListener 'WebComponentsReady', ->
  # Routes
  # We use Page.js for routing. This is a Micro
  # client-side router inspired by the Express router
  # More info: https://visionmedia.github.io/page.js/
  # Middleware

  scrollToTop = (ctx, next) ->
    return unless app?
    app.scrollPageToTop()
    next()
    return

  page '/', scrollToTop, ->
    app.route = 'home'
    return
  page '/users', scrollToTop, ->
    app.route = 'users'
    return
  page '/users/:name', scrollToTop, (data) ->
    app.route = 'user-info'
    app.params = data.params
    return
  page '/contact', scrollToTop, ->
    app.route = 'contact'
    return
  # add #! before urls
  page hashbang: true
  return
