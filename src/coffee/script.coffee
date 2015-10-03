(($) ->
	date = new Date()
	d = date.getDate()
	m = date.getMonth()
	y = date.getFullYear()
	$('#calendar').fullCalendar
		header: 
            left: ''
            center: 'title'
            right: ''
        theme: true
        timeFormat: 'H'
        events:[]
    #*************************Drag and Drop Name List**********************************    
    #   I've found a great way to move an array item
    # stackoverflow.com/questions/5306680/move-an-array-element-from-one-array-position-to-another
	Array::move = (old_index, new_index) ->
        if new_index >= @length
            k = new_index - @length
            while ((k--) + 1) 
                @push undefined
        @splice new_index, 0, @splice(old_index, 1)[0]
        return
    # this function moves items in a array that correspond to a moved DOM element
	moveArrayItem = (a, b) ->
		arr2 = getLocalStorage()
		arr2.move a, b
		setLocalStorage arr2
		addNamesToCalendar()
		return
	started = null
	# jQueryUI sortable method 
    # returns start and stop indexes of DOM items in a node list when they are dragged and dropped
    # and then passes those values to moveArrayItem()
	$("#nameList").sortable
		start: (event, ui) ->
			started = $(ui.item).index()
			return
		stop: (event, ui) ->
			stopped = $(ui.item).index()
			moveArrayItem started, stopped
			return
    # *************************end Drag and Drop Name List**********************************    
    # SET local storage helper function
    # it accepts any array as the argument then
    # stringifies it and avoids a cyclic error by using the replacer array argument
	setLocalStorage = (arr) ->
		localStorage.setItem "savedEvents", JSON.stringify(arr, [
			"title"
			"start"
			"end"
			"allDay"
			"backgroundColor"
			"textColor"
		])
		return
	getLocalStorage = ->
		JSON.parse(localStorage.getItem("savedEvents"))
	# returns focus to & clears text from input
	focusAndClear = ->
		$('#txt_name').focus().val('')
	updateNameList = ->
		console.log "update name list fired"		
		namesArr = []
		namesArr.push evt.title for evt in getLocalStorage()
		$('#nameList').empty()
		$('#nameList').fadeIn(500)
		$('#clear_events').fadeIn(500).removeClass "hidden"
		$('#nameList').append "<div> #{name} </div>" for name in namesArr
		$('#nameList').removeClass "hidden"
		return
	addNamesToCalendar = ->
		console.log "addNamesToCalendar fired"
		$('#calendar').fullCalendar 'removeEvents'
		nd = new Date(y, m + 1, 0)
		evtL = getLocalStorage().length
		dayNumber = nd.getDate()
		dayz = (dayNumber * 3)
		arr = new Array(dayz)
		hour = 1
		dayCounter = 1
		newEventArray = []
		i = 0
		while i < arr.length
			arr[i] = getLocalStorage()[i % evtL]
			i++

		$.each arr, (i, v) ->
			dateVar = new Date(y, m, d, 1)
			if (dayCounter > dayz) # this stops the loop at end of the month
			else if (hour > 3)
				hour = 1
				dayCounter++
				dateVar.setDate(dayCounter)
				dateVar.setHours(hour)
				hour++
			else
				dateVar.setDate(dayCounter)
				dateVar.setHours(hour)
				hour++
			v.start = dateVar
			obj = 
				title: v.title
				start: v.start
				end: ''
				allDay: false
				className:'classy'
			newEventArray.push obj
			return
		$('#calendar').fullCalendar "removeEvents", (event) ->
			event.backgroundColor
			return
		$('#calendar').fullCalendar 'addEventSource', newEventArray, true
		return
	addAName = (e) ->
		e.preventDefault()
		console.log "add a name fired"
		unless $("#txt_name").val()
			console.log "blank name" # change to alert
			focusAndClear()
			return
		else
			eventObject =
				title : $.trim( $("#txt_name").val() )
				start : ""
				end : ""
				allDay: false
				backgroundColor: "black"
				textColor: "yellow"
			if localStorage.getItem "savedEvents"
				arr0 =  getLocalStorage()
				arrZ = arr0.some (el) ->
					eventObject.title is el.title
				if arrZ is false
					arr0.push eventObject
					setLocalStorage arr0
					addNamesToCalendar()
					updateNameList()
				focusAndClear()
				console.log "arr2" + " " +  getLocalStorage().length
				return
			else
				arr1 = []
				arr1.push eventObject
				setLocalStorage arr1
				addNamesToCalendar()
				updateNameList()
				focusAndClear()
				console.log "arr3" +" " + 	 getLocalStorage().length
				return
	#load stored events on page load
	unless localStorage.getItem "savedEvents"
		console.log "Nothing Saved"
		focusAndClear()
	else
		addNamesToCalendar()
		updateNameList()
		focusAndClear()
	#clears all events and removes the name list from the DOM
	clearEvents = (e) ->
		e.preventDefault()
		$("#calendar").fullCalendar "removeEvents"
		window.localStorage.clear()
		$("#nameList").hide 500
		$("#clear_events").hide(500).addClass "hidden"
		$("#nameList").empty()
		focusAndClear()
		console.log "clear events fired"
		return
	# removes a name when you double click it in the Name List
	removeAName = (e) ->
		e.preventDefault
		inputtedText = $.trim e.target.innerHTML
		someArray2 = getLocalStorage()
		if someArray2.length <= 1
			clearEvents e
		else
			someArray2 = (el for el in someArray2 when el.title isnt inputtedText)
			setLocalStorage someArray2
			addNamesToCalendar()
			updateNameList()
		return
	# submit a name when the Enter key is pressed
	$("#txt_name").bind "keydown", (e) ->
		if e.keyCode is 13 then addAName e
		return
	$("#txt_name").hover(
		-> $("#txt_name-msg").fadeIn "fast", ->
			$(this).removeClass "hidden"
		-> $("#txt_name-msg").fadeOut "fast", ->
			$(this).addClass "hidden"
	)
	$("#addName").bind "click", (e) ->
		addAName e
		return
	$("#clear_events").bind "click", (e) ->
		clearEvents e
		return
	$("#clear_events").hover(
		-> $(this).fadeOut "fast", ->
			$(this).attr( "value" , "Remove All").removeClass("right").fadeIn()
		-> $(this).fadeOut "fast", ->
			if ! $("#clear_events").hasClass "hidden"
				$(this).attr( "value" , "-").addClass("right").fadeIn()
    return
 )
	$("#nameList").bind "dblclick", (e) ->
		removeAName e
		return
	$("#nameList").hover(
		-> $("#list-msg").fadeIn "slow", ->
			$(this).removeClass "hidden"
		-> $("#list-msg").fadeOut "slow", ->
			$(this).addClass "hidden"
	)
	return
)	jQuery