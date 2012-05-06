jQuery ->
  new PortraitCropper()

class @PortraitCropper

  constructor: ->
    partLayoutAspectRatio = partLayoutWidth / partLayoutHeight

    # Is the part layout a portrait or landscape?
    layoutIsPortrait = partLayoutHeight >=  partLayoutWidth

    # Position initial select box one-sixth inside principal dimension of cropbox.
    # Sixths seems pleasing since the resultant selection box will be two-thirds the principal dimension.
    if layoutIsPortrait
      x1 = ($('#cropbox').width() / 6) + 0.5 * ($('#cropbox').width() * 4 / 6 - $('#cropbox').height() * 4 / 6 * partLayoutAspectRatio)
      y1 = $('#cropbox').height() / 6 # one-sixth the way down
      x2 = ($('#cropbox').width() * 5 / 6) - 0.5 * ($('#cropbox').width() * 4 / 6 - $('#cropbox').height() * 4 / 6 * partLayoutAspectRatio)
      y2 = $('#cropbox').height() * 5 / 6 # five-sixths the way down
    else # landscape style
      x1 = $('#cropbox').width() / 6 # one-sixth the way across
      y1 = ($('#cropbox').height() / 6) + 0.5 * ($('#cropbox').height() * 4 / 6 - $('#cropbox').width() * 4 / 6 / partLayoutAspectRatio)
      x2 = $('#cropbox').width() * 5 / 6 # five-sixths the way across
      y2 = ($('#cropbox').height() * 5 / 6) - 0.5 * ($('#cropbox').height() * 4 / 6 - $('#cropbox').width() * 4 / 6 / partLayoutAspectRatio)

    # Configure the Jcrop box.
    $('#cropbox').Jcrop
      aspectRatio: partLayoutAspectRatio
      setSelect: [x1, y1, x2, y2]
      onSelect: @update
      onChange: @update

  update: (coords) =>
    $('#admin_customer_item_side_crop_x').val(coords.x)
    $('#admin_customer_item_side_crop_y').val(coords.y)
    $('#admin_customer_item_side_crop_w').val(coords.w)
    $('#admin_customer_item_side_crop_h').val(coords.h)
    @updatePreview(coords)

  updatePreview: (coords) =>
    # This is how much we reduced the part image to fit in the 300px wide view. Use this to scale down the preview image by this factor.
    # If we choose a different part image width, that can be done in the css without changing any values here.
    previewScalingFactor =
      width:  $('#part_template').width()  / pieceWidth
      height: $('#part_template').height() / pieceHeight
    # Notice cropScalingFactor gets bigger as you zoom in! Use this to scale up the preview image by this factor.
    cropScalingFactor =
      width:  $('#cropbox').width()  / coords.w
      height: $('#cropbox').height() / coords.h
    $('#preview').css
      width:  Math.round( partLayoutWidth  * cropScalingFactor.width  * previewScalingFactor.width  ) + 'px'
      height: Math.round( partLayoutHeight * cropScalingFactor.height * previewScalingFactor.height ) + 'px'
      marginLeft: Math.round( partLayoutOffsetX * previewScalingFactor.width  - coords.x * cropScalingFactor.width  * previewScalingFactor.width ) + 'px'
      marginTop:  Math.round( partLayoutOffsetY * previewScalingFactor.height - coords.y * cropScalingFactor.height * previewScalingFactor.height) + 'px'