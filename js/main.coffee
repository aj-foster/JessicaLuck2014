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


	$("fieldset.more").hide()

	$("#support-form-more").on "change", (evt) ->

		if $(@).prop("checked")
			$("fieldset.more").slideDown()
		else
			$("fieldset.more").slideUp()


	$("#support form").submit (evt) ->

		evt.preventDefault()
		$(@).find("p.alert, p.success").fadeOut().remove()
		form = $(@)
		target = $(@).children(":first")

		console.log form.serialize()

		$.ajax 'handler.php',
			type: 'POST'
			dataType: 'html'
			data: form.serialize()
			success: (data) ->
				target.prepend("<p class='success'>" + data + "</p>")
				$("p.success").fadeIn 200
				form[0].reset()
			error: (jqXHR, textStatus, errorThrown) ->
				target.prepend("<p class='alert'>" + jqXHR.responseText + "</p>")
				$("p.alert").fadeIn 200