class @PortraitCropper

  constructor: ->

    partLayoutAspectRatio = partLayoutWidth / partLayoutHeight
    # Is the part layout a portrait or landscape?
    layoutIsPortrait = partLayoutHeight >=  partLayoutWidth
    console.log "layoutIsPortrait " + layoutIsPortrait

    # Position initial select box one-sixth inside principal dimension of cropbox.
    # Sixths seems pleasing since the resulting selection box will be two-thirds the principal dimension.
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
    console.log " cropbox width: " + $('#cropbox').width()
    console.log "x1 " + x1
    console.log "y1 " + y1
    console.log "x2 " + x2
    console.log "y2 " + y2
    window.setSelect = [Math.round(x1), Math.round(y1), Math.round(x2), Math.round(y2)]
    console.log "setSelect " + setSelect

    # Configure the Jcrop box.
    $('#cropbox').Jcrop(
      aspectRatio: partLayoutAspectRatio
      onSelect: @update
      onChange: @update
      , ->
        window.jcrop = this
        waitUntil cropboxReady, 2000, ->
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

window.cropboxReady = ->
  window.ready = false
  # ready = true if $('#cropbox').readyState == 4
  $('#cropbox').load ->
    window.ready = true
  true


#      if($img[0].readyState === 4){ // image is cached in IE
#          alert("Image loaded!");
#      }else{
#          $img.load(function(){ // for other browsers and IE, if not cached
#              alert("Image loaded!");
#          });
#      }
#