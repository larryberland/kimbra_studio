class @PortraitCropper

  constructor: ->
    window.viewportAspectRatio = viewportWidth / viewportHeight
    # Is the part layout a portrait or landscape?
    layoutIsPortrait = viewportHeight >=  viewportWidth

    cropbox_w = $('#cropbox').width()
    cropbox_h =  $('#cropbox').height()
    # Position initial select box one-sixth inside principal dimension of cropbox.
    # Sixths seems pleasing since the resulting selection box will be two-thirds the principal dimension.
    if layoutIsPortrait
      x1 = (cropbox_w / 6) + 0.5 * (cropbox_w * 4 / 6 - cropbox_h * 4 / 6 * viewportAspectRatio)
      y1 = cropbox_h / 6 # one-sixth the way down
      x2 = (cropbox_w * 5 / 6) - 0.5 * (cropbox_w * 4 / 6 - cropbox_h * 4 / 6 * viewportAspectRatio)
      y2 = cropbox_h * 5 / 6 # five-sixths the way down
    else # landscape style
      x1 = cropbox_w / 6 # one-sixth the way across
      y1 = (cropbox_h / 6) + 0.5 * (cropbox_h * 4 / 6 - cropbox_w * 4 / 6 / viewportAspectRatio)
      x2 = cropbox_w * 5 / 6 # five-sixths the way across
      y2 = (cropbox_h * 5 / 6) - 0.5 * (cropbox_h * 4 / 6 - cropbox_w * 4 / 6 / viewportAspectRatio)
    setSelect = [Math.round(x1), Math.round(y1), Math.round(x2), Math.round(y2)]

    # Configure the Jcrop box.
    $('#cropbox').Jcrop(
      aspectRatio: viewportAspectRatio
      onSelect: @update
      onChange: @update
      , ->
        window.jcrop = this
        jcrop.animateTo setSelect)

  update: (coords) =>
    # This is how much we reduced the part image to fit in the 300px wide view. Use this to scale down the preview image by this factor.
    # If we choose a different part image width, that can be done in the css without changing any values here.
    # In both scaling factors the aspect ratio is preserved so we can use only the width for the calcs. Let the browser do the height.
    window.viewportScalingFactor = $('#part_template').width() / partWidth
    # This is how much we reduced the portrait to fit in the croppable area on the left.
    window.portraitScalingFactor = $('#cropbox').width() / portraitWidth
    # Notice cropScalingFactor gets bigger as you zoom in! Use this to scale up the preview image by this factor.
    window.cropScalingFactor = viewportWidth * viewportScalingFactor / coords.w
    # Set hidden fields with integer values.
    $('#admin_customer_item_side_crop_x').val(Math.round((coords.x / portraitScalingFactor)))
    $('#admin_customer_item_side_crop_y').val(Math.round((coords.y / portraitScalingFactor)))
    $('#admin_customer_item_side_crop_w').val(Math.round((coords.w / portraitScalingFactor)))
    $('#admin_customer_item_side_crop_h').val(Math.round((coords.h / portraitScalingFactor)))

    console.log("por x=>#{$('#admin_customer_item_side_crop_x').val()} cropbox.x=>#{coords.x} por w=>#{$('#admin_customer_item_side_crop_w').val()} cropbox w=>#{coords.w} port w=>#{portraitWidth} box width=>#{$('#cropbox').width()}")
    @updatePreview(coords)

  updatePreview: (coords) =>
    # Zoom and move underlying preview image.
    $('#preview').css
      width:  Math.round( portraitWidth  * cropScalingFactor  * portraitScalingFactor ) + 'px'
      marginLeft: Math.round( viewportOffsetX * viewportScalingFactor - coords.x * cropScalingFactor  ) + 'px'
      marginTop:  Math.round( viewportOffsetY * viewportScalingFactor - coords.y * cropScalingFactor  ) + 'px'