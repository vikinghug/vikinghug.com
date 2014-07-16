
_   = require "underscore"
$   = require "jquery"
vex = require "../../bower_components/vex/coffee/vex.coffee"

$ ->

  toggleMenu = ->
    if $('body.open').length > 0
      closeMenu()
    else
      $('body').addClass('open')

  closeMenu = -> $('body').removeClass('open')

  handleScroll = ->
    if $(this).scrollTop() <= 10
      $('body').removeClass('scrolled')
    else
      $('body').addClass('scrolled')

  gotoAnchor = ($el) ->
    position = $($el.attr('href')).offset().top
    distance = position - $(document).scrollTop()
    speed = 10
    time = Math.abs(distance) / speed
    $('html, body').animate
      scrollTop: position
    , Math.floor time


  vex.defaultOptions.className = 'vex-theme-vikinghug'
  $("[data-screenshot]").on 'click', (e) ->
    e.preventDefault()
    console.log "HI", $(this).html()
    vex.open
      content: $(this).html()
      afterOpen: ($vexContent) ->
        console.log $vexContent.data().vex
        $vexContent.append $vexContent.content
      afterClose: ->
        console.log 'vexClose'

  _gotoAnchor   = _.throttle gotoAnchor, 500, { trailing: false }
  _handleScroll = _.throttle handleScroll, 300, true
  _toggleMenu   = _.throttle toggleMenu, 300, true

  $('.menu').on 'click', _toggleMenu

  $('navigation [href]').on 'click', (e) =>
    e.preventDefault()
    closeMenu()
    _gotoAnchor($(e.currentTarget))


  $.each $('.title'), ->
    offset = $(this).find('a').outerWidth()
    $(this).find('.tooltip').css('left', offset)

  $(document).on 'scroll', _handleScroll
