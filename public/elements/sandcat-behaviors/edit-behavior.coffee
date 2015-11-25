do (window) ->
  window.SandCatBehaviors = window.SandCatBehaviors || {}
  window.SandCatBehaviors.EditBehavior =
    properties:
      model:
        type: Object
    # listeners:
    #   onResponse: 'responseHandler'
    #   onError: 'errorHandler'

    created: ->
      # console.log 'list-behavior created'
      return

    ready: ->
      return

    attached: ->
      # console.log 'list-behavior attached'
      return

    detached: ->
      # console.log 'list-behavior detached'
      return

    attributeChanged: (attrName, oldVal, newVal) ->
      # console.log "#{attrName} changed, before: #{oldVal} now: #{newVal}"
      return

    submitForm: (event, detail) ->
      console.log event, detail
      @$.theForm.submit()

    onFormResponse: (event, detail) ->
      @fire 'form-response', detail

    onFormError: (event, detail) ->
      @fire 'form-error', detail
