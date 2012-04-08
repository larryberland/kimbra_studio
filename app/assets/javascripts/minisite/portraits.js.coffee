jQuery ->
  new AvatarCropper()

class AvatarCropper
  constructor: ->
    $('#cropbox').Jcrop
      aspectRatio: 1
      setSelect: [0,0, 600, 600]
      onSelect: @update
      onChange: @update

  update: (coords) =>
    $('#admin_customer_offer_crop_x').val(coords.x)
    $('#admin_customer_form_crop_y').val(coords.y)
    $('#admin_customer_form_crop_w').val(coords.w)
    $('#admin_customer_form_crop_h').val(coords.h)
    @updatePreview(coords)

  updatePreview: (coords) =>
    $('#preview').css
      width: Math.round(100/coords.w * $('#cropbox').width()) + 'px'
      height: Math.round(100/coords.h * $('#cropbox').height()) + 'px'
      marginLeft: '-' + Math.round(100/coords.w * coords.x) + 'px'
      marginTop: '-' + Math.round(100/coords.w * coords.y) + 'px'