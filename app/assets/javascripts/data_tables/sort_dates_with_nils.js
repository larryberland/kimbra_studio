jQuery.fn.dataTableExt.oSort['dateswithnils-asc'] = function (x, y) {
    var retVal;
    x = $.trim(x);
    y = $.trim(y);
    if (x == y) retVal = 0;
    else if (x == "" || x == "&nbsp;") retVal = 1;
    else if (y == "" || y == "&nbsp;") retVal = -1;
    else if (Date.parse(x) > Date.parse(y)) retVal = 1;
    else retVal = -1;
    console.log("desc x: " + x + " y: " + y + " retval: " + retVal);
    return retVal;
}

jQuery.fn.dataTableExt.oSort['dateswithnils-desc'] = function (x, y) {
    var retVal;
    x = $.trim(x);
    y = $.trim(y);
    if (x == y) retVal = 0;
    else if (x == "" || x == "&nbsp;") retVal = 1;
    else if (y == "" || y == "&nbsp;") retVal = -1;
    else if (Date.parse(x) < Date.parse(y)) retVal = 1;
    else retVal = -1;
    console.log("desc x: " + x + " y: " + y + " retval: " + retVal);
    return retVal;
}