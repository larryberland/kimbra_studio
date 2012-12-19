$(document).ready(function () {
    setUpDataTable(
        $('#studios_table'),
        {
            "aaSorting":[[ 12, 'desc' ]], // default sort on created_at desc
            "aoColumnDefs":[
                { "bVisible":false, "aTargets":[ 12 ] }, // make long format date field hidden
                { "iDataSort":11, "aTargets":[ 12 ] }    // but when you sort on short format, use hidden long format column
            ]
        });
});