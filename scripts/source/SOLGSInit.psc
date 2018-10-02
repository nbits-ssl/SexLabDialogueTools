Scriptname SOLGSInit extends Quest  

Event OnInit()
	SOLFollowers.Start()
	SOLGetSex.Start()
EndEvent

Quest Property SOLFollowers  Auto  
Quest Property SOLGetSex  Auto  
