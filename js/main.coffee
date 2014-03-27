# Welcome to CoffeeScript!  This file contains all of the JavaScript for the
# site, written in the more beautiful CoffeeScript.  Gulp will compile this to
# browser-readable JavaScript.

$(document).ready ->

	# When the page loads, we hide the various elements that will be shown
	# using the LeanModal plugin.

	$(".bio").hide()
	$(".bio-link").leanModal {top: 20, closeButton: ".closeButton"}

	$(".involvement").hide()
	$(".involvement-link").leanModal {top: 20, closeButton: ".closeButton"}


	$("nav a").on "click", (evt) ->

		evt.preventDefault()
		destination = 0

		# When a button on the nav menu is clicked, we first ask if the user is
		# trying to go to a link or expand the mobile menu.  If the user is not
		# trying to expand the menu (meaning they pressed a link or pressed the
		# menu button again) then we collapse the menu.

		if $(@).hasClass("menu")

			$("nav ul").slideToggle()
			return

		else
			$("nav ul.mobile").slideUp()

		# Deciding where to scroll isn't an easy job.  Because the navigation
		# bar is always at the top of the page, we need to take that into
		# consideration when deciding how far to scroll.

		target = @.hash

		if $("a.menu.mobile").height() == null
			navHeight = $("nav").height()
		else
			navHeight = $("a.menu.mobile").height() + 25

		# In general, we scroll to the top of the desired section if possible,
		# unless that would mean scrolling past the end of the page.

		viewportHeight = $(window).height() - navHeight
		bottomOfPage = $(document).height() - $(window).height()

		if $(target).offset().top > bottomOfPage
			destination = bottomOfPage

		else
			destination = $(target).offset().top - navHeight

		# Using the animate function gives the scroll a smooth feel.

		$('html,body').animate {scrollTop: destination}, 1000, 'swing'


	# When a user scrolls down the page, we want the nav to go with them.  This
	# function checks if the user has scrolled past the nav bar and, if so,
	# attaches it to the top of the screen.  Likewise it deattaches it if the
	# user scrolls back up.

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


	# When the window is loaded and resized, we need to consider whether to
	# style the navigation in a mobile or desktop fashion.  As a general rule,
	# JavaScript should only manage the classes of the element; CSS (Sass)
	# should control how it looks in each situation.  Note that we also show and
	# hide the menu as necessary; someone like me might come along and resize
	# the window back and forth to see how the menu reacts while open or closed.

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


	# When a user clicks on one of the platform categories, show the text.

	$("#platform .points").hide()
	$("#platform a.title").on "click", (evt) ->

		$(@).parent().children(".points").slideToggle()
		evt.preventDefault()


	# Hide the fieldsets that ought to appear only when a user chooses to
	# support the campaign in a certain manner.

	$("fieldset.suggest, fieldset.support, fieldset.join").hide()

	# When a user says that they'd like to support the campaign, show the
	# related fields.

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


	# On page load, check to see if the browser can handle FormData - that is,
	# a special new way of communicating form inputs that includes the ability
	# to upload files.  IE8, for example, doesn't know what FormData is; it
	# won't be able to upload pictures.

	if window.FormData == undefined
		$("#support-form-picture").replaceWith("<p>Bummer! Picture uploads aren't supported in your browser.</p>")


	# When the form is submitted, we need to collect the form's data and send it
	# to the PHP form handler for a response.

	$("#support form").submit (evt) ->

		# Don't use the default POST functionality.
		evt.preventDefault()

		# Remove any old messages (if a user forgot to fill out a field).
		$(@).find("p.alert, p.success").fadeOut().remove()

		form = $(@)
		target = $(@).children(":first")
		formData = null

		# Again, check to see if the broswer can handle the FormData object,
		# and collect the data accordingly.

		if window.FormData == undefined
			formData = $("#support-form").serialize()
		else
			formData = new FormData($("#support-form")[0])

		# Here, we actually ship the POST data to the PHP handler:

		$.ajax 'handler.php',
			type: 'POST'
			processData: false
			contentType: false
			data: formData
			success: (data) ->
				# On success, give the user a nice green message.
				target.prepend("<p class='success'>" + data + "</p>")
				$("p.success").fadeIn 200

				# Reset the form so there isn't temptation to submit it again.
				form[0].reset()
				$("fieldset.suggest, fieldset.support, fieldset.join").hide()

			error: (jqXHR, textStatus, errorThrown) ->
				# On error, give the user the error message.
				target.prepend("<p class='alert'>" + jqXHR.responseText + "</p>")
				$("p.alert").fadeIn 200