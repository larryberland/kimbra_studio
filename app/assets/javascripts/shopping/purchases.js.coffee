# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  subscription.setupForm()

subscription =
  setupForm: ->
    frm = $('form.new_shopping_purchase')
    if !frm[0]
      frm = $('form.edit_shopping_purchase')
    frm.submit ->
      $('input[type=submit]').attr('disabled', true)
      if $('#card_number').length
        subscription.processCard()
        false
      else
        true

  processCard: ->
    card =
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    Stripe.createToken(card, $('#shopping_purchase_total_cents').val(), subscription.handleStripeResponse)

  handleStripeResponse: (status, response) ->
    if status == 200
      $('#shopping_purchase_stripe_card_token').val(response.id)
      frm = $('form.new_shopping_purchase')
      if !frm[0]
        frm = $('form.edit_shopping_purchase')
      frm[0].submit()
    else
      $('#stripe_error').text(response.error.message)
      $('#stripe_error').show();
      $('.flash_error').delay(60000).slideUp('slow');
      $('#spinner').toggle()
      $('input[type=submit]').attr('disabled', false)