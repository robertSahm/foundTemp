jQuery ->
  $(".alert-message").alert()
  $(".tabs").button()
  $(".carousel").carousel()
  $(".collapse").collapse()
  $(".dropdown-toggle").dropdown()
  $(".navbar").scrollspy()
  $(".tab").tab "show"
  $(".typeahead").typeahead() 

jQuery ->
  new PhotoCropper()

class PhotoCropper
  constructor: ->
    $('#cropbox').Jcrop
      aspectRatio: 1
      setSelect: [0, 0, 400, 400]
      onSelect: @update
      onChange: @update

  update: (coords) =>
    $('#user_crop_x').val(coords.x)
    $('#user_crop_y').val(coords.y)
    $('#user_crop_w').val(coords.w)
    $('#user_crop_h').val(coords.h)
