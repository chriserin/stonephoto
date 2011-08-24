# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


jQuery ->
  $(".big_display").hide()
  $(".about_meredith").hide()
  $(".contact_meredith").hide()

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
  width = 0
  loaded = 0
  $("img").each( (i, item) ->
    $(item).load( ->
      width += this.clientWidth
      loaded++
      if loaded is $("img").length then $(".images_wrapper").width(width + $("img").length * 10)
    )
  )

  $.getJSON("photos.json?frontpage=IMAGES", (data) ->
    show_photos_from_json(data)
  )

loading_colors = ["rgba(200, 10, 10, .3)", "rgba(10, 10, 200, .3)", "rgba(50, 100, 200, .3)", "rgba(10, 200, 200, .3)", "rgba(200, 100, 50, .3)", "rgba(100, 40, 100, .3)", "rgba(200, 150, 120, .3)", "rgba(50, 10, 110, .3)", "rgba(165, 90, 200, .3)", "rgba(110, 110, 0, .3)"]


show_photos_from_json = (data) ->
  items = []
  width = 0
  $.each(data, (index, photo) ->
    items.push("<div class='photo' style='width:#{photo.image_width}px'><div class='white_panel'></div><div class='color_panel' style='background-color:#{loading_colors[Math.floor(Math.random() * 10)]};'><div class='loading_label'>Loading</div></div><img src='#{photo.medium_url}'></img></div>")
    width += photo.image_width
  )
  items[items.length - 1] = items[items.length - 1].replace('photo', 'photo last_photo')

  $(".images_wrapper").width(width + items.length * 10)
  $(".images_wrapper").html(items.join(''))

  $("img").load( ->
    $(this).siblings(".color_panel").fadeOut("slow")
    $(this).siblings(".white_panel").fadeOut("slow")
  )

  $(".about_meredith").hide()
  $(".images").show()
  $(".contact_meredith").hide()
