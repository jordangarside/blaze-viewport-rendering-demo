Router.route '/', () ->
	Session.set('resultSetReady', false)
	@render('main')

ResultSets  = new Mongo.Collection(null)

pushNewResultSet = (limit) ->
	limit = limit or 240
	if ResultSets.find().count() != 0
		lastResultSet = ResultSets.findOne({}, sort: skip: -1)
		skip = lastResultSet.skip + lastResultSet.limit
	else
		skip = 0
	resultSetOptions = 
		limit: limit
		skip: skip
	ResultSets.insert resultSetOptions

Template.main.rendered = () ->
	#pushNewResultSet()
	console.log "Template main: rendered..."

	showMoreVisible = _.throttle (->
		resultSetLoading = !Session.get('resultSetReady')
		if !resultSetLoading
			lastItem = Items.findOne({}, sort: sequence_id: -1)
			target = $('#' + lastItem._id)
			threshold = $(window).scrollTop() + $(window).height() - target.height() + 2000
			if target.offset().top < threshold
				_.defer ->
					pushNewResultSet 120
					return
				return console.log('>>> Template Main: fetching next page... >>>')
		return
	), 200
	#$(window).on 'scroll', showMoreVisible
	Meteor.subscribe("readItems", {skip: 0, limit: 1000})

Template.main.helpers
	resultSets: ->
		return ResultSets.find({}, { sort: { skip: 1 } })
	results: ->
		return Items.find({}, { sort: {sequence_id: 1} })