do (window) ->
  window.SandCatBehaviors = window.SandCatBehaviors || {}
  window.SandCatBehaviors.EditBehavior =
    properties:
      modelid: String
      model:
        type: Object
        notify: on
        obsever: '_modelChanged'
        value: ->
          return {}
      baseURL: String
      editURL:
        type: String
        computed: 'computeEditURL(model)'
      editForm: Object
    created: ->
      # console.log 'edit-behavior created'
      return

    ready: ->
      # console.log 'edit-behavior ready'
      return

    attached: ->
      # console.log 'edit-behavior attached'
      return

    detached: ->
      # console.log 'edit-behavior detached'
      return

    attributeChanged: (attrName, oldVal, newVal) ->
      # console.log "#{attrName} changed, before: #{oldVal} now: #{newVal}"
      return

    beforeSubmit: (event, data) ->
      # console.log 'before submitting form', event, data
      unless data.enabled?
        console.log 'enabled is not on form data im afraid'

    afterSubmit: (event, detail) ->
      # console.log 'after submitting form', event, detail
      feedback = ''
      if detail.status is 200
        feedback = 'datos guardados exitosamente.'
      else
        feedback = "ocurrio un problema, #{detail.statusText}"

      @model = detail.model if detail.model?
      @model = detail.response.model if detail.response?.model?
      
      @notify feedback
      @fire 'model-saved', message: feedback

    prepareData: ->
      # console.log 'preparing edit data in behavior.'
      return

    modelidChanged: ->
      if @editURL is ''
        console.log 'editURL attribute missing'
        return
      if @modelid is ''
        console.log 'model id cant be an empty string'
        return
      console.log 'modelid changed', @modelid
      if @modelid isnt 'new'
        @$.resource.url = "#{@editURL}/#{@modelid}"
        @$.resource.go()
      else
        console.log 'no http GET is needed'
        @model = {}
        @fire 'model-read-response', @model

    responseHandler: (event, detail) ->
      return unless detail.response?
      @model = detail.response
      @fire 'model-read-response', @model

    errorHandler: (event, detail) ->
      console.log 'error', event, detail

    computeEditURL: (model) ->
      console.log "in behavior compute "
      return "" unless model?
      return "#{model._id}"

    notify: (msg) ->
      @fire 'edit-notification', msg

    submitForm: (event, data) ->
      console.log 'submit in behavior'
      @prepareData()
      @editForm.submit()

    onFormResponse: (event, detail) ->
      @fire 'form-response', detail

    onFormError: (event, detail) ->
      @fire 'form-error', detail

    _modelChanged: (n) ->
      console.log 'edit-behavior _modelChanged'
      return
