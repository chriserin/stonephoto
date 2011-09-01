# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.current_images
window.current_index = 0
window.app = {}

jQuery ->
  $(".big_display").hide()
  $(".about_meredith").hide()
  $(".contact_meredith").hide()
  $(".loading_images").hide()
  
  $(".left_arrow_holder").click( ->
    if(window.stop_click)
      window.stop_click = false
      return
    window.current_index -= 1 unless window.current_index is 0
    set_image_wrapper_margin()
  )

  $(".right_arrow_holder").click( ->
    if(window.stop_click)
      window.stop_click = false
      return
      
    window.current_index += 1 unless window.current_index == window.current_images.length - 1
    set_image_wrapper_margin()
  )

  $("body").bind("mouseup touchend", (event) ->
    stop_slide()
  )

  $(".left_arrow_holder").bind("mousedown touchstart", (event) ->
    window.stop_scroll = false
    window.scroll_direction = "left"
    setTimeout( ->
      slideLeft()
    , 140)
  )

  $("body").bind("mouseup touchend", (event) ->
    stop_slide()
  )

  $(".right_arrow_holder").bind("mousedown touchstart", (event) ->
    window.stop_scroll = false
    window.scroll_direction = "right"
    setTimeout( ->
      slideRight()
    , 140)
  )

  slideLeft = () ->
    arrow_slide("+=40")

  slideRight = () ->
    arrow_slide("-=40")

  arrow_slide = (slide_distance) ->
    if(window.stop_scroll) then return
    window.stop_click = true
    current_margin = -get_images_left()
    if current_margin < -50 and window.scroll_direction is "left" then return
    slide_distance = increment_slide_distance(slide_distance)
    $(".images_wrapper").animate({left: slide_distance  }, 50, "linear")
    setTimeout( ->
      arrow_slide(slide_distance)
    , 50)
    set_current_image_index()


  $(".image_rep").live('click', ->
    window.current_index = $(".image_rep").index(this)
    set_image_wrapper_margin()
  )

  $(".photo").live('click', ->
    $(".big_display").empty()
    $(".big_display").show()
    src = $(this).find("img").attr("src")
    $(".big_display").append("<img class='big_display_photo' src='#{src.replace('medium', 'big_display')}'></img>")
  )

  $(".big_display").click( ->
    $(".big_display").hide()
  )

  $(".study").click( ->
    window.stone_router.navigate($.trim($(this).text().split('&')[0]), true)
  )

  $(".frontpage_images").click( ->
    window.stone_router.navigate("Images", true)
  )

  $(".about_about").click( ->
    window.stone_router.navigate("About", true)
  )

  $(".about_contact").click( ->
    window.stone_router.navigate("Contact", true)
  )
  

  $(".images").touchwipe(
    {
      wipeLeft: ->
        window.current_index += 1 unless window.current_index == window.current_images.length - 1
        set_image_wrapper_margin()
      wipeRight: ->
        window.current_index -= 1 unless window.current_index is 0
        set_image_wrapper_margin()
    }
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
  window.stone_router = new app.StoneRouter()
  Backbone.history.start()

loading_colors = ["rgba(200, 10, 10, .3)", "rgba(10, 10, 200, .3)", "rgba(50, 100, 200, .3)", "rgba(10, 200, 200, .3)", "rgba(200, 100, 50, .3)", "rgba(100, 40, 100, .3)", "rgba(200, 150, 120, .3)", "rgba(50, 10, 110, .3)", "rgba(165, 90, 200, .3)", "rgba(110, 110, 0, .3)"]

show_photos_from_json = (data) ->
  window.show_photos_from_json(data)

window.show_photos_from_json = (data) ->
  window.current_images = data
  window.current_index = 0
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
  $(".arrow_holder").show()
  $(".image_reps").show()
  draw_image_reps()
  set_image_wrapper_margin()
  window.image_widths = [-50]
  margin_left = -50
  for index in [0..window.current_images.length - 1]
    margin_left += (window.current_images[index].image_width + 10)
    if(index is 0) then margin_left -= 10
    window.image_widths[window.image_widths.length] = margin_left

set_image_wrapper_margin = ->
  if window.current_index is 0
    margin_left = 10
  else
    margin_left = 0
  for index in [0..window.current_images.length - 1]
    if(index is window.current_index)
      break
    margin_left += window.current_images[index].image_width + 10
  $(".images_wrapper").animate({left: "#{-(margin_left - 60)}px" }, 300 )
  draw_image_reps()

draw_image_reps = ->
  $(".image_reps_wrapper").empty()
  $(".image_reps_wrapper").width(28 * window.current_images.length)
  $.each(window.current_images, (index, photo) ->
    $(".image_reps_wrapper").append("<div class='image_rep'></div>")
  )
  $($(".image_rep")[window.current_index]).css("background-color", "rgba(67, 0, 90, 1)")

set_current_image_index = ->
  current_margin = -get_images_left()
  current_index = window.current_index
  if(current_margin > window.image_widths[window.image_widths.length - 2]) and window.scroll_direction is "right"
    stop_slide()
  for i in [0...window.image_widths.length]
    if(window.image_widths[i] < current_margin) && (window.image_widths[i + 1] > current_margin)
      window.current_index = i
      break
  if current_index isnt window.current_index
    draw_image_reps()

stop_slide = ->
  $(".images_wrapper").clearQueue()
  #$(".images_wrapper").stop()
  window.stop_scroll = true
  #$(".images_wrapper").css("transform","")
  #$(".images_wrapper").css("-webkit-transform","")

increment_slide_distance = (slide_distance) ->
  distance = parseInt(slide_distance.replace("=", ""))
  if(distance < 0) and distance > -120
    distance--
    return "-=#{Math.abs(distance)}"
  if(distance > 0) and distance < 120
    distance++
    return "+=#{distance}"
  return slide_distance

get_images_left = () ->
  left = parseInt($(".images_wrapper").css("left").replace("px", ""))
  trans = $(".images_wrapper").css("-webkit-transform")
  firstIndex = trans.indexOf(",", 16) + 1
  lastIndex = trans.indexOf(",", 20)
  fullString = trans.substring(firstIndex, lastIndex)
  leftDif = Math.floor(parseInt(fullString))
  leftDif = if isNaN(leftDif) then 0 else leftDif
  return (left + leftDif)

