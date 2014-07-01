

$ ->


  toggleMenu = ->
    if $('body.open').length > 0
      closeMenu()
    else
      $('body').addClass('open')

  closeMenu = ->
    $('body').removeClass('open')

  $(document).on 'scroll', (e) ->
    if $(this).scrollTop() <= 10
      $('body').addClass('top')
    else
      $('body').removeClass('top')

  $('.menu').on 'click', toggleMenu


  $('navigation [href]').on 'click', (e) =>
    e.preventDefault()
    closeMenu()
    $el = $(e.target)
    $('html, body').animate
      scrollTop: $($el.attr('href')).offset().top
    , 1000


