Template.resultSet.created = ->
	Session.set 'resultSetReady', false
	options = @data
	itemsSubsMananger = new SubsManager
	itemsSubsMananger.subscribe 'readItems', {
		limit: options.limit
		skip: options.skip
	}, ->
		Deps.autorun (computation) ->
			lastItem = Items.findOne({sequence_id: (options.limit + options.skip - 1)}, {sort: {sequence_id: -1} })
			if lastItem?
				Session.set 'resultSetReady', true
				computation.stop()

Template.resultSet.rendered = ->
	self = this
	templateReadyAutorun = Deps.autorun (computation)->
		if Session.equals('resultSetReady', true)
			$(self.firstNode).removeClass 'loading'
			computation.stop()

Template.resultSet.helpers
	results: ->
		Items.find {},
			sort: sequence_id: 1
			limit: @limit
			skip: @skip