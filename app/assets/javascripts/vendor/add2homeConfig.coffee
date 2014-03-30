# Add 2 Home iPhone script variables
window.addToHomeConfig =
  startDelay: 2000			  # 2 seconds from page load before the balloon appears
  lifespan: 30000			    # 15 seconds before it is automatically destroyed
  expire: 720 					    # Minutes to wait before showing the popup again (0 = always displayed)
  message: 'Install Spokenvote on your %device: tap %icon and then <strong>Add to Home Screen</strong>.'
                          # Customize your message or force a language ('' = automatic)
  touchIcon: true 			  # Display the touch icon

#  autostart: true			  # Automatically open the balloon
#  returningVisitor: false	# Show the balloon to returning visitors only (setting this to true is highly recommended)
#  animationIn: 'drop'		# drop || bubble || fade
#  animationOut: 'fade'		# drop || bubble || fade
#  bottomOffset: 14			  # Distance of the balloon from bottom
#  arrow: true				    # Display the balloon arrow
#  hookOnLoad: true			  # Should we hook to onload event? (really advanced usage)
#  closeButton: true			# Let the user close the balloon
#  iterations: 100				# Internal/debug use