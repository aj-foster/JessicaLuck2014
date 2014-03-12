$(document).ready ->

	$(".bio").hide()
	$(".bio-link").leanModal {top: 20, closeButton: ".closeButton"}

	$(".involvement").hide()
	$(".involvement-link").leanModal {top: 20, closeButton: ".closeButton"}
	

	$("nav a").on "click", (evt) ->

		evt.preventDefault()
		destination = 0

		if $(@).hasClass("menu")

			$("nav ul").slideToggle()
			return

		else
			$("nav ul.mobile").slideUp()

		target = @.hash

		if $("a.menu.mobile").height() == null
			navHeight = $("nav").height()
		else
			navHeight = $("a.menu.mobile").height() + 25

		viewportHeight = $(window).height() - navHeight
		bottomOfPage = $(document).height() - $(window).height()

		if $(target).offset().top > bottomOfPage
			destination = bottomOfPage

		else
			destination = $(target).offset().top - navHeight

		$('html,body').animate {scrollTop: destination}, 1000, 'swing'


	stickyNav = ->

		nav = $("nav")
		holder = $(".nav-placeholder")
		viewPosition = $(window).scrollTop()
		holderPosition = holder.offset().top

		if viewPosition > holderPosition
			nav.css {position: "fixed", top: 0}
			holder.css {height: nav.height()}

		else
			nav.css {position: "static"}
			holder.css {height: 0}

	stickyNav()
	$(window).on "scroll", stickyNav


	adjustNav = ->

		navUL = $("nav ul")
		navLink = $("nav a.menu")

		if $(document).width() < 650
			navUL.addClass("mobile").removeClass("full").hide()
			navLink.addClass("mobile").removeClass("full").show()
		else
			navUL.addClass("full").removeClass("mobile").show()
			navLink.addClass("full").removeClass("mobile").hide()

	$(window).resize adjustNav
	adjustNav()


	$("#platform .points").hide()
	$("#platform a.title").on "click", (evt) ->

		$(@).parent().children(".points").slideToggle()
		evt.preventDefault()


	$("fieldset.suggest, fieldset.support, fieldset.join").hide()

	$("#support-check-suggest").on "change", (evt) ->

		if $(@).prop("checked")
			$("fieldset.suggest").slideDown()
		else
			$("fieldset.suggest").slideUp()

	$("#support-check-support").on "change", (evt) ->

		if $(@).prop("checked")
			$("fieldset.support").slideDown()
		else
			$("fieldset.support").slideUp()

	$("#support-check-join").on "change", (evt) ->

		if $(@).prop("checked")
			$("fieldset.join").slideDown()
		else
			$("fieldset.join").slideUp()


	if window.FormData == undefined
		$("#support-form-picture").replaceWith("<p>Bummer! Picture uploads aren't supported in your browser.</p>")

	$("#support form").submit (evt) ->

		evt.preventDefault()
		$(@).find("p.alert, p.success").fadeOut().remove()
		form = $(@)
		target = $(@).children(":first")
		formData = null

		if window.FormData == undefined
			formData = $("#support-form").serialize()
		else
			formData = new FormData($("#support-form")[0])

		$.ajax 'handler.php',
			type: 'POST'
			processData: false
			contentType: false
			data: formData
			success: (data) ->
				target.prepend("<p class='success'>" + data + "</p>")
				$("p.success").fadeIn 200
				form[0].reset()
				$("fieldset.suggest, fieldset.support, fieldset.join").hide()
			error: (jqXHR, textStatus, errorThrown) ->
				target.prepend("<p class='alert'>" + jqXHR.responseText + "</p>")
				$("p.alert").fadeIn 200