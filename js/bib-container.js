$(document).ready(function() {
    _.each($('p.bib'), function(p, i) {
        //p.parent)(p, $('<div>').append($(p).cone()))
        var el = $('<div class="bib-container">').append($(p).clone());
        $(p).replaceWith(el);
    });
});
