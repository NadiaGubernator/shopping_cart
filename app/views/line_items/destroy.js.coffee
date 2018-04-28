$("#line_item-<%= line_item.id %>").fadeOut ->
  $(this).remove()
