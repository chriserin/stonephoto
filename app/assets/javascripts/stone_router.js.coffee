jQuery ->
  class app.StoneRouter extends Backbone.Router
    routes:
      "Animals": "animals"
      "Landscapes": "landscapes"
      "Portraits": "portraits"
      "Products": "products"
      "Images": "images"
      "Contact": "contact"
      "About": "about"
    animals: ->
      @openStudy("Animals")
    landscapes: ->
      @openStudy("Landscapes")
    portraits: ->
      @openStudy("Portraits")
    products: ->
      @openStudy("Products")
    images: ->
      @openFrontPage()
    contact: ->
      $(".about_meredith").hide()
      $(".images").hide()
      $(".contact_meredith").show()
      $(".image_reps").hide()
      $(".arrow_holder").hide()
    about: ->
      $(".about_meredith").show()
      $(".images").hide()
      $(".contact_meredith").hide()
      $(".image_reps").hide()
      $(".arrow_holder").hide()
    openStudy: (study) =>
      $(".loading_images").show()
      $.getJSON("photos.json?study=#{study}", (data) ->
        $(".loading_images").hide()
        show_photos_from_json(data)
      )
    openFrontPage: =>
      $(".loading_images").show()
      $.getJSON("photos.json?frontpage=tru", (data) ->
        $(".loading_images").hide()
        show_photos_from_json(data)
      )

