$(document).ready ->

	$(".bio").hide()
	$(".bio-link").leanModal {top: 20, closeButton: ".closeButton"}

	$(".involvement").hide()
	$(".involvement-link").leanModal {top: 20, closeButton: ".closeButton"}
	

	$("nav a").on "click", (evt) ->

		evt.preventDefault()
		destination = 0

		target = @.hash
		navHeight = $("nav").height()
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


	$("#support form").submit (evt) ->

		evt.preventDefault()
		$(@).find("p.alert, p.success").fadeOut().remove()
		form = $(@)
		target = $(@).children(":first")

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
			error: (jqXHR, textStatus, errorThrown) ->
				target.prepend("<p class='alert'>" + jqXHR.responseText + "</p>")
				$("p.alert").fadeIn 200