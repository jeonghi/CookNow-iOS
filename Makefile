project:
	tuist clean
	tuist install
	tuist generate --no-open &&  open CookNow.xcworkspace

open: 
	tuist generate --no-open &&  open CookNow.xcworkspace

asset:
	tuist generate