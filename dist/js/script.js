(function($) {
  var addAName, addNamesToCalendar, clearEvents, d, date, focusAndClear, getLocalStorage, m, moveArrayItem, removeAName, setLocalStorage, started, updateNameList, y;
  date = new Date();
  d = date.getDate();
  m = date.getMonth();
  y = date.getFullYear();
  $('#calendar').fullCalendar({
    header: {
      left: '',
      center: 'title',
      right: ''
    },
    theme: true,
    timeFormat: 'H',
    events: []
  });
  Array.prototype.move = function(old_index, new_index) {
    var k;
    if (new_index >= this.length) {
      k = new_index - this.length;
      while ((k--) + 1) {
        this.push(void 0);
      }
    }
    this.splice(new_index, 0, this.splice(old_index, 1)[0]);
  };
  moveArrayItem = function(a, b) {
    var arr2;
    arr2 = getLocalStorage();
    arr2.move(a, b);
    setLocalStorage(arr2);
    addNamesToCalendar();
  };
  started = null;
  $("#nameList").sortable({
    start: function(event, ui) {
      started = $(ui.item).index();
    },
    stop: function(event, ui) {
      var stopped;
      stopped = $(ui.item).index();
      moveArrayItem(started, stopped);
    }
  });
  setLocalStorage = function(arr) {
    localStorage.setItem("savedEvents", JSON.stringify(arr, ["title", "start", "end", "allDay", "backgroundColor", "textColor"]));
  };
  getLocalStorage = function() {
    return JSON.parse(localStorage.getItem("savedEvents"));
  };
  focusAndClear = function() {
    return $('#txt_name').focus().val('');
  };
  updateNameList = function() {
    var evt, j, l, len, len1, name, namesArr, ref;
    console.log("update name list fired");
    namesArr = [];
    ref = getLocalStorage();
    for (j = 0, len = ref.length; j < len; j++) {
      evt = ref[j];
      namesArr.push(evt.title);
    }
    $('#nameList').empty();
    for (l = 0, len1 = namesArr.length; l < len1; l++) {
      name = namesArr[l];
      $('#nameList').append("<div> " + name + " </div>");
    }
  };
  addNamesToCalendar = function() {
    var arr, dayCounter, dayNumber, dayz, evtL, hour, i, nd, newEventArray;
    console.log("addNamesToCalendar fired");
    $('#calendar').fullCalendar('removeEvents');
    nd = new Date(y, m + 1, 0);
    evtL = getLocalStorage().length;
    dayNumber = nd.getDate();
    dayz = dayNumber * 3;
    arr = new Array(dayz);
    hour = 1;
    dayCounter = 1;
    newEventArray = [];
    i = 0;
    while (i < arr.length) {
      arr[i] = getLocalStorage()[i % evtL];
      i++;
    }
    $.each(arr, function(i, v) {
      var dateVar, obj;
      dateVar = new Date(y, m, d, 1);
      if (dayCounter > dayz) {

      } else if (hour > 3) {
        hour = 1;
        dayCounter++;
        dateVar.setDate(dayCounter);
        dateVar.setHours(hour);
        hour++;
      } else {
        dateVar.setDate(dayCounter);
        dateVar.setHours(hour);
        hour++;
      }
      v.start = dateVar;
      obj = {
        title: v.title,
        start: v.start,
        end: '',
        allDay: false,
        className: 'classy'
      };
      newEventArray.push(obj);
    });
    $('#calendar').fullCalendar("removeEvents", function(event) {
      event.backgroundColor;
    });
    $('#calendar').fullCalendar('addEventSource', newEventArray, true);
  };
  addAName = function(e) {
    var arr0, arr1, arrZ, eventObject;
    e.preventDefault();
    console.log("add a name fired");
    if (!$("#txt_name").val()) {
      console.log("blank name");
      focusAndClear();
    } else {
      eventObject = {
        title: $.trim($("#txt_name").val()),
        start: "",
        end: "",
        allDay: false,
        backgroundColor: "black",
        textColor: "yellow"
      };
      if (localStorage.getItem("savedEvents")) {
        arr0 = getLocalStorage();
        arrZ = arr0.some(function(el) {
          return eventObject.title === el.title;
        });
        if (arrZ === false) {
          arr0.push(eventObject);
          setLocalStorage(arr0);
          addNamesToCalendar();
          updateNameList();
        }
        focusAndClear();
        console.log("arr2" + " " + getLocalStorage().length);
      } else {
        arr1 = [];
        arr1.push(eventObject);
        setLocalStorage(arr1);
        addNamesToCalendar();
        updateNameList();
        focusAndClear();
        console.log("arr3" + " " + getLocalStorage().length);
      }
    }
  };
  if (!localStorage.getItem("savedEvents")) {
    console.log("Nothing Saved");
    focusAndClear();
  } else {
    addNamesToCalendar();
    updateNameList();
    focusAndClear();
  }
  clearEvents = function(e) {
    e.preventDefault();
    $('#calendar').fullCalendar("removeEvents");
    window.localStorage.clear();
    $("#nameList").empty();
    focusAndClear();
    console.log("clear events fired");
  };
  removeAName = function(e) {
    var el, inputtedText, someArray2;
    e.preventDefault;
    inputtedText = $.trim(e.target.innerHTML);
    someArray2 = getLocalStorage();
    if (someArray2.length <= 1) {
      clearEvents(e);
    } else {
      someArray2 = (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = someArray2.length; j < len; j++) {
          el = someArray2[j];
          if (el.title !== inputtedText) {
            results.push(el);
          }
        }
        return results;
      })();
      setLocalStorage(someArray2);
      addNamesToCalendar();
      updateNameList();
    }
  };
  $("#txt_name").bind("keydown", function(e) {
    if (e.keyCode === 13) {
      addAName(e);
    }
  });
  $("#addName").bind("click", function(e) {
    addAName(e);
  });
  $("#clear_events").bind("click", function(e) {
    clearEvents(e);
  });
  $("#nameList").bind("dblclick", function(e) {
    removeAName(e);
  });
})(jQuery);
