# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  if Stripe?
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
      name: $('#shopping_purchase_cart_address_attributes_name').val()
      address_line1: $('#shopping_purchase_cart_address_attributes_address1').val()
      address_line2: $('#shopping_purchase_cart_address_attributes_address2').val()
      address_state: $('#shopping_purchase_cart_address_attributes_state_stripe').val()
      address_zip: $('#shopping_purchase_cart_address_attributes_zip_code').val()
      address_country: $('#shopping_purchase_cart_address_attributes_country_stripe').val()
    Stripe.createToken(card, $('#shopping_purchase_total_cents').val(), subscription.handleStripeResponse)

  handleStripeResponse: (status, response) ->
    $('#shopping_purchase_stripe_create_token_status').val(status)
    $('#shopping_purchase_stripe_create_token_response').val(response)
    if status == 200
      $('#shopping_purchase_stripe_card_token').val(response.id)
      frm = $('form.new_shopping_purchase')
      if !frm[0]
        frm = $('form.edit_shopping_purchase')
      frm[0].submit()
    else
      $('#stripe_error').text(response.error.message)
      $('#stripe_error').show().effect('highlight', 4000)
      $('.flash_error').delay(10000).slideUp('slow')
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

# Support for update links on shopping cart page (items/_index.html.erb).
# This implements an unobtrusive ajax call on the links, but prevents the link itself firing.
# New links are added to the document by the ajax, so the function needs to be called after the
# ajax response each time.
# Sent as a javascript request and the response is evaled into the document.
# I have no idea what happens if the ajax response is a failure.
$ ->
  window.updateQuantityLinks()

window.updateQuantityLinks = ->
  $('button.update_quantity').click (event) ->
    sel = $(this).closest('td').find('select')
    qty = $(this).closest('td').find('input')
    event.preventDefault()
    $.post(
      $(this).attr('href')
      quantity: qty.val()
      option: sel.attr('name')
      option_selected: sel.val()
      (data) ->
        eval data
        updateQuantityLinks()
      'script'
    )
