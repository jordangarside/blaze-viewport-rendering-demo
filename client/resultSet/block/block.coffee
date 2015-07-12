
Template.block.rendered = () ->
	item_id = @data._id
	watcher = scrollMonitor.create( document.getElementById( item_id ) )
	colorDependencyAutorun = undefined

	watcher.on "enterViewport", () ->
		Items.update item_id,
			$set:
				inViewport: true
		colorDependencyAutorun = Tracker.autorun ->
			console.log("watcher colorDependencyAutorun: activePreference changed...")
			activePreference = window.Preferences.findOne({isActive: true})
			Tracker.nonreactive ->
				window.demo.Items.checkForUpdates(item_id)
	watcher.on "exitViewport", () ->
		Items.update item_id,
			$set:
				inViewport: false
		colorDependencyAutorun?.stop()
