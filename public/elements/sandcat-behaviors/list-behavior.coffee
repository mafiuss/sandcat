do (window) ->
  window.SandCatBehaviors = window.SandCatBehaviors || {}
  window.SandCatBehaviors.ListBehavior =
    properties:
      dataSource: Object
      deleteDataSource: Object
      list:
        type: Array
        notify: on
        value: ->
          return [{}]
        observer: '_listChanged'
      listComplete: Array
      searchKeys:
        type: Array
        value: ->
          return ['name']
      selected:
        type: Object
        notify: on
        value: ->
          return {}
      selectedIndex:
        type: Number
      minListLength:
        type: Number
        value: ->
          return 10
    listeners:
      onResponse: 'responseHandler'
      onError: 'errorHandler'

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

    responseHandler: (event, detail)->
      # console.log "list-behavior handling response.", detail.response
      # console.log event,detail
      @list = detail.response if Array.isArray detail.response
      @list = detail.response.model if detail.response?.model?
      # console.log 'list-behavior parsed list', @list
      @listComplete = @list
      @disabledFilter()

    errorHandler: (data)->
      console.log 'unhandling error. :p', data

    deleteResponse: (event, detail) ->
      console.log event, detail
      return console.log('not ok') unless detail?

      m = detail.response.model if detail.response?.model?
      m = detail.model if detail.model?
      @remove(m)
      @notify('eliminado')
      # @refresh()#FIXME: fix @remove method
      # console.log event, detail

    deleteError: (event, detail) ->
      @notify('ocurrió un error al eliminar post')
      # console.log event, detail

    refresh: ->
      return unless @dataSource?
      @dataSource.generateRequest()

    addNew: ->
      # console.log 'tapping new'
      @fire 'new-model', null

    viewItem: (event)->
      i = @clickedModel(event)
      s = @list[i]
      @fire 'view-model', s

    editItem: (event)->
      i = @clickedModel(event)
      s = @list[i]
      @fire 'edit-model', s

    editSelectedItem: (event)->
      @fire 'edit-model', @selected

    deleteItem: (event)->
      i = @clickedModel(event)
      # console.log 'delete?', i, @selected
      if @deleteDataSource?
        @deleteDataSource.generateRequest()
      @fire 'delete-model', @selected

    deleteSelectedItem: (event)->
      if @deleteDataSource?
        @deleteDataSource.generateRequest()
      @fire 'delete-model', @selected

    removeSelectedItemFromList: ->
      console.log 'remove selected item', @selectedIndex
      return unless @selectedIndex?

      @splice 'list', @selectedIndex, 1
      @selected = null
      @selectedIndex = null

    remove: (model) ->
      return unless model?
      # console.log 'removing', model
      whichIndex = -1
      for item, index in @list
        if item._id is model._id
          whichIndex = index
          break

      @splice 'list', whichIndex, 1
      return

    toDateString: (value) ->
      return '' unless value?
      d = new Date(value)
      "#{d.toDateString()} a las #{d.getHours()}:#{d.getMinutes()}"

    clickedModel: (event) ->
      return unless event.model?.item?
      # console.log 'clicked', event.model?.item
      # event.model.index
      @selected = event.model.item
      @selectedIndex = event.model.index
      return event.model.index

    searchFilter: (event) ->
      return unless @$.searchString.value?
      return unless @list?
      value = @$.searchString.value
      # console.log 'poke', value
      if value is ''
        @list = @listComplete
      else
        @list = @listComplete.filter (item) =>
          @searchFilterFun(item, value)
      # console.log 'size', @list.length, value

    searchFilterFun: (item, value) ->
      # console.log 'searchFilter in behavior', item, value
      return off unless item?
      return off unless value?
      ok = off
      for searchKey in @searchKeys
        k = "#{item[searchKey]}"
        ok = ok or k.indexOf(value) isnt -1
        # console.log  'checking', searchKey, k, value,ok
      ok
      
    hideSearch: (list) ->
      return on unless list
      return on unless Array.isArray(list)

      return list.length < @minListLength

    disabledFilter: (event, detail) ->
      # console.log 'searchFilter in behavior'
      return unless @list?
      @list = @listComplete.filter (item) =>
        @disabledFilterFun(item)
      return

    disabledFilterFun: (item) ->
      # console.log 'disabledFilter in behavior'
      showDisabled = @$.showDisabled?.checked
      return item.enabled unless showDisabled
      return on

    stringy: (model) ->
      "#{JSON.stringify(model)}"

    notify: (msg) ->
      @fire 'list-notification', msg

    _listChanged: (oldValue, newValue) ->
      console.log 'listChanged in behavior'

    _itemTouched: (event, detail) ->
      # console.log 'item selected in behavior'
      @selected = event.model.item
      @selectedIndex = event.model.index
      @fire 'list-item-selected', @selected
