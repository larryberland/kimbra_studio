jQuery ->
  new AvatarCropper()

class @AvatarCropper
  constructor: ->
    $('#cropbox').Jcrop
      aspectRatio: 1
      setSelect: [150, 150, 450, 450]
      onSelect: @update
      onChange: @update

  update: (coords) =>
    $('#admin_customer_item_side_crop_x').val(coords.x)
    $('#admin_customer_item_side_crop_y').val(coords.y)
    $('#admin_customer_item_side_crop_w').val(coords.w)
    $('#admin_customer_item_side_crop_h').val(coords.h)
    @updatePreview(coords)

  updatePreview: (coords) =>
    $('#preview').css
      width: Math.round(300 / coords.w * $('#cropbox').width()) + 'px'
      height: Math.round(300 / coords.h * $('#cropbox').height()) + 'px'
      marginLeft: '-' + Math.round(300 / coords.w * coords.x) + 'px'
      marginTop: '-' + Math.round(300 / coords.h * coords.y) + 'px'