class @PortraitCropper

  constructor: ->
    window.partLayoutAspectRatio = partLayoutWidth / partLayoutHeight
    # Is the part layout a portrait or landscape?
    layoutIsPortrait = partLayoutHeight >=  partLayoutWidth

    cropbox_w = $('#cropbox').width()
    cropbox_h =  $('#cropbox').height()
    # Position initial select box one-sixth inside principal dimension of cropbox.
    # Sixths seems pleasing since the resulting selection box will be two-thirds the principal dimension.
    if layoutIsPortrait
      x1 = (cropbox_w / 6) + 0.5 * (cropbox_w * 4 / 6 - cropbox_h * 4 / 6 * partLayoutAspectRatio)
      y1 = cropbox_h / 6 # one-sixth the way down
      x2 = (cropbox_w * 5 / 6) - 0.5 * (cropbox_w * 4 / 6 - cropbox_h * 4 / 6 * partLayoutAspectRatio)
      y2 = cropbox_h * 5 / 6 # five-sixths the way down
    else # landscape style
      x1 = cropbox_w / 6 # one-sixth the way across
      y1 = (cropbox_h / 6) + 0.5 * (cropbox_h * 4 / 6 - cropbox_w * 4 / 6 / partLayoutAspectRatio)
      x2 = cropbox_w * 5 / 6 # five-sixths the way across
      y2 = (cropbox_h * 5 / 6) - 0.5 * (cropbox_h * 4 / 6 - cropbox_w * 4 / 6 / partLayoutAspectRatio)
    setSelect = [Math.round(x1), Math.round(y1), Math.round(x2), Math.round(y2)]

    # Configure the Jcrop box.
    $('#cropbox').Jcrop(
      aspectRatio: partLayoutAspectRatio
      onSelect: @update
      onChange: @update
      , ->
        window.jcrop = this
        jcrop.animateTo setSelect)

  update: (coords) =>
    # This is how much we reduced the part image to fit in the 300px wide view. Use this to scale down the preview image by this factor.
    # If we choose a different part image width, that can be done in the css without changing any values here.
    # In both scaling factors the aspect ratio is preserved so we can use only the width for the calcs. Let the browser do the height.
    window.partLayoutScalingFactor = $('#part_template').width() / pieceWidth
    # This is how much we reduced the portrait to fit in the croppable area on the left.
    window.portraitScalingFactor = $('#cropbox').width() / portraitWidth
    # Notice cropScalingFactor gets bigger as you zoom in! Use this to scale up the preview image by this factor.
    window.cropScalingFactor = partLayoutWidth * partLayoutScalingFactor / coords.w
    # Stuff crop coords back into hidden fields to pass back to controller. Scale back to original portrait size.
    $('#admin_customer_item_side_crop_x').val(Math.round(coords.x / portraitScalingFactor))
    $('#admin_customer_item_side_crop_y').val(Math.round(coords.y / portraitScalingFactor))
    $('#admin_customer_item_side_crop_w').val(Math.round(coords.w / portraitScalingFactor))
    $('#admin_customer_item_side_crop_h').val(Math.round(coords.h / portraitScalingFactor))
    @updatePreview(coords)

  updatePreview: (coords) =>
    # Zoom and move underlying preview image.
    $('#preview').css
      width:  Math.round( portraitWidth  * cropScalingFactor  * portraitScalingFactor ) + 'px'
      marginLeft: Math.round( partLayoutOffsetX * partLayoutScalingFactor - coords.x * cropScalingFactor  ) + 'px'
      marginTop:  Math.round( partLayoutOffsetY * partLayoutScalingFactor - coords.y * cropScalingFactor  ) + 'px'