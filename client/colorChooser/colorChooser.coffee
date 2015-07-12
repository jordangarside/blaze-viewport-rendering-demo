

Template.colorChooser.helpers
	activePreference: ->
		return window.Preferences.findOne({isActive: true})

Template.colorChooser.events
	"click li": (event) ->
		color = event.currentTarget.innerText
		if color != "delete active preference"
			window.demo.Preferences.createNewPreference(color)
		else
			window.demo.Preferences.removeActivePreference()