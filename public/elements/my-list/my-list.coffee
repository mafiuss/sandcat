Polymer
  is: 'my-list'
  behaviors: [SandCatBehaviors.ListBehavior]
  properties:
    thing: String

  created: ->
    # console.log 'my-list created'
    return

  ready: ->
    # console.log 'my-list-data ready'
    return

  attached: ->
    # console.log 'my-list-data attached'
    return

  detached: ->
    # console.log 'my-list-data detached'
    return

  attributeChanged: (attrName, oldVal, newVal) ->
    console.log "#{attrName} changed, before: #{oldVal} now: #{newVal}"

  itemSelected: (event, detail) ->
    return unless event.model?.item?
    @selected = event.model.item
    @fire 'item-selected', @selected
