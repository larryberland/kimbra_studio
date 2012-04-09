var AvatarCropper,
    __bind = function (fn, me) {
        return function () {
            return fn.apply(me, arguments);
        };
    };

AvatarCropper = (function () {
    function AvatarCropper() {
        this.updatePreview = __bind(this.updatePreview, this);
        this.update = __bind(this.update, this);
        $('#cropbox').Jcrop({
            aspectRatio:1,
            setSelect:[300, 300, 150, 150],
            onSelect:this.update,
            onChange:this.update
        });
    }

    AvatarCropper.prototype.update = function (coords) {
        $('#admin_customer_offer_crop_x').val(coords.x);
        $('#admin_customer_form_crop_y').val(coords.y);
        $('#admin_customer_form_crop_w').val(coords.w);
        $('#admin_customer_form_crop_h').val(coords.h);
        return this.updatePreview(coords);
    };
    AvatarCropper.prototype.updatePreview = function (coords) {
        return $('#preview').css({
            width:Math.round(100 / coords.w * $('#cropbox').width()) + 'px',
            height:Math.round(100 / coords.h * $('#cropbox').height()) + 'px',
            marginLeft:'-' + Math.round(100 / coords.w * coords.x) + 'px',
            marginTop:'-' + Math.round(100 / coords.w * coords.y) + 'px'
        });
    };
    return AvatarCropper;
})(); 