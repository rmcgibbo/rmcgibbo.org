$(document).ready(function() {
    _.each($('p.bib'), function(p, i) {
        var el = $('<div class="bib-container">').append($(p).clone());
        el.addClass(i % 2 == 0 ? 'bib-container-odd' : 'bib-container-even');
        $(p).replaceWith(el);
    });
});
