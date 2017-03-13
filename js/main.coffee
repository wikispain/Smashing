ddsmoothmenu.init
	mainmenuid: 'mainmenu'
	orientation: 'h'
	contentsource: 'markup'
	classname: 'menu'

# Responsive menu ---------------

jQuery("nav.menu > ul").tinyNav
	active: 'current-menu-item'


# Isotope ---------------

$container = $('#portfolio-filter')
cols = $container.data('cols')

$(window).load ->
	$container.isotope
		itemSelector : '.portfolio_item'

$(window).resize ->
	$container.isotope
		itemSelector : '.portfolio_item'

$('#filters a').click ->
	selector = $(this).attr('data-filter')
	$('#filters a').removeClass('active')
	$(this).addClass('active')
	$container.isotope
		filter: selector
	
	return false



$(window).load ->
	$('.blog_grid').isotope
			itemSelector : '.post'
			masonry: 
				columnWidth: $('.blog_grid').width() / 3

$(window).resize ->
	$('.blog_grid').isotope
			itemSelector : '.post'
			masonry: 
				columnWidth: $('.blog_grid').width() / 3



$(".portfolio_item a").attr('rel', 'portfolio')

$(".fancybox, .portfolio_item a").fancybox
		padding: 0
		closeBtn: false
		helpers:
			title: 
				type: 'outside'
			buttons:
				position: 'bottom'

		
jQuery('.price-table a').tooltip()

jQuery('.flickr_widget').each ->
	that = $(this)	
	user = $(this).data('flickr-id');
	count = $(this).data('count')
	jQuery.getJSON("http://api.flickr.com/services/feeds/photos_public.gne?ids=" + user + "&lang=en-us&format=json&jsoncallback=?", (data)->
		i = 0
		jQuery.each(data.items, (index, item)->
			if i >= count
				next

			console.log  data.items
			jQuery("<img/>").attr("src", item.media.m).appendTo('.flickr_widget')
			.wrap("<a href='" + item.link + "'></a>")
			i++
		)
	)


# Contact form ---------------

validateEmail = (email)->
	re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\.+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
	return re.test(email)

$('#contact_form').submit ->

	$('.alert', this).remove()

	$('input[type=submit]').attr('disabled', 'disabled')

	name = $('#name', this).val()
	email = $('#email', this).val()
	subject = $('#subject', this).val()
	message = $('#message', this).val()

	if (name is '') or (email is '') or (subject is '') or (message is '')
		$('#contact_form').prepend """
		<div class="alert">
			<button type="button" class="close" data-dismiss="alert">×</button>
			<strong>Error!</strong> No fields can be left blank.
		</div>
		"""

		$('input[type=submit]').removeAttr('disabled')

		return false


	# Validate email
	if !validateEmail(email)
		$('#contact_form').prepend """
		<div class="alert">
			<button type="button" class="close" data-dismiss="alert">×</button>
			<strong>Warning!</strong> That doesn't look like a valid email.
		</div>
		"""
		$('input[type=submit]').removeAttr('disabled')

		return false


	$.post("mailer.php", { name: name, email: email, subject: subject, message: message }, (data)->
		if data is ''
			$('#contact_form').prepend """
			<div class="alert alert-danger">
				<button type="button" class="close" data-dismiss="alert">×</button>
				<strong>Error!</strong> Something went wrong, try later.
			</div>
			"""
		
		if data is 'success'
			$('#contact_form').prepend """
            <div class="alert alert-success">
				<button type="button" class="close" data-dismiss="alert">×</button>
				<strong>Success!</strong> Your message was sent.
			</div>
			"""

			$('#contact_form input[type=text], #contact_form input[type=email], #contact_form textarea').val('')

			$('input[type=submit]').removeAttr('disabled')
	)

	return false


