# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
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

# client-side Card number validation
CreditCard =
  cleanNumber: (number) -> number.replace /[- ]/g, ""

  validNumber: (number) ->
    total = 0
    number = @cleanNumber(number)
    for i in [(number.length-1)..0]
      n = +number[i]
      if (i+number.length) % 2 == 0
        n = if n*2 > 9 then n*2 - 9 else n*2
      total += n
    total % 10 == 0

$ ->
  $("#card_number").blur ->
    if CreditCard.validNumber(@value)
      $("#card_number_error").text("")
    else
      $("#card_number_error").text("Invalid credit card number.")