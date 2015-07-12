Template.registerHelper "Session", (variable)->
	return Session.get(variable)