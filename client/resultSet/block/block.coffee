
Template.block.rendered = () ->
	item_id = @data._id
	watcher = scrollMonitor.create( document.getElementById( item_id ) )
	colorDependencyAutorun = undefined

	watcher.on "enterViewport", () ->
		setTimeout (->
			if watcher.isInViewport
				#console.log("%cwatcher " + item_id + ": enterViewport...", "border: 1px solid blue;");
				Items.update item_id,
					$set:
						inViewport: true
				colorDependencyAutorun = Tracker.autorun ->
					console.log("watcher colorDependencyAutorun: activePreference changed...")
					activePreference = window.Preferences.findOne({isActive: true})
					Tracker.nonreactive ->
						window.demo.Items.checkForUpdates(item_id)
					#console.log("watcher " + cachedResult_id + ": tasteAutorun (taste changed)");
		), 50
	watcher.on "exitViewport", () ->
		Items.update item_id,
			$set:
				inViewport: false
		colorDependencyAutorun?.stop()