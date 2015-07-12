if Meteor.isClient
	window.demo 			?= {}
	window.demo.Preferences	= {}

	window.Preferences = new Mongo.Collection(null)

	window.demo.Preferences.createNewPreference = (color) ->
		activePreference = window.Preferences.findOne({isActive: true})

		window.Preferences.insert
			color: color
			date: new Date()
			isActive: true

		if activePreference?
			window.Preferences.update activePreference._id,
				$set:
					isActive: false

	window.demo.Preferences.removeActivePreference = ->
		activePreference = window.Preferences.findOne({isActive: true})
		window.Preferences.remove(activePreference._id)