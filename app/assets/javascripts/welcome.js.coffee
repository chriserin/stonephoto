# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


jQuery ->
  $(".big_display").hide()
  $(".about_meredith").hide()
  $(".contact_meredith").hide()

  $("img").click( ->
    $(".big_display").show()
  )

  $(".photo").live('click', ->
    $(".big_display").empty()
    $(".big_display").show()
    src = $(this).find("img").attr("src")
    $(".big_display").append("<img src='#{src.replace('medium', 'big_display')}'></img>")
  )

  $(".big_display").click( ->
    $(".big_display").hide()
  )

  $(".study").click( ->
    $.getJSON("photos.json?study=#{$(this).text()}", (data) ->
      show_photos_from_json(data)
    )
  )

  $(".frontpage_images").click( ->
    $.getJSON("photos.json?frontpage=#{$(this).text()}", (data) ->
      show_photos_from_json(data)
    )
  )

  $(".about_about").click( ->
    $(".about_meredith").show()
    $(".images").hide()
    $(".contact_meredith").hide()
  )

  $(".about_contact").click( ->
    $(".about_meredith").hide()
    $(".images").hide()
    $(".contact_meredith").show()
  )


show_photos_from_json = (data) ->
  items = []
  $.each(data, (index, photo) ->
    items.push("<div class='photo'><img src='#{photo.medium_url}'></img></div>")
  )
  items[items.length - 1] = items[items.length - 1].replace('photo', 'photo last_photo')

  $(".images_wrapper").html(items.join(''))

  $(".images_wrapper").width(items.length * 600)

  $(".about_meredith").hide()
  $(".images").show()
  $(".contact_meredith").hide()
