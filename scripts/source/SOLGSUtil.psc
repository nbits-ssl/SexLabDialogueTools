Scriptname SOLGSUtil extends Quest  

Function QuickSex(Actor follower, Actor speaker)
	if (SexLab.GetGender(speaker) == 1) ; female
		SexLab.QuickStart(speaker, follower)
	else
		SexLab.QuickStart(follower, speaker)
	endif
EndFunction

Function _restartFollowerQuest()
	if (SOLGetSexFollowers.isRunning())
		SOLGetSexFollowers.Stop()
	endif
	SOLGetSexFollowers.Start()
EndFunction

ReferenceAlias[] Function _getMaleRefs()
	ReferenceAlias[] malerefs = new ReferenceAlias[5]
	malerefs[0] = Male1
	malerefs[1] = Male2
	malerefs[2] = Male3
	malerefs[3] = Male4
	malerefs[4] = Male5
	
	return malerefs
EndFunction

ReferenceAlias[] Function _getFemaleRefs()
	ReferenceAlias[] femalerefs = new ReferenceAlias[5]
	femalerefs[0] = Female1
	femalerefs[1] = Female2
	femalerefs[2] = Female3
	femalerefs[3] = Female4
	femalerefs[4] = Female5
	
	return femalerefs
EndFunction

Function Moreway(Actor player, Actor speaker)
	self._restartFollowerQuest()

	Actor[] males = new Actor[5]
	Actor[] females = new Actor[5]
	ReferenceAlias[] malerefs = self._getMaleRefs()
	ReferenceAlias[] femalerefs = self._getFemaleRefs()

	int male_idx = 0
	int female_idx = 0
	int n = 5
	
	while n
		n -= 1
		if (malerefs[n])
			Actor act = malerefs[n].GetActorRef()
			if (act && act != speaker)
				males[male_idx] = act
				male_idx += 1
			endif
		endif
		if (femalerefs[n])
			Actor act = femalerefs[n].GetActorRef()
			if (act && act != speaker)
				females[female_idx] = act
				female_idx += 1
			endif
		endif
	endwhile
	
	sslBaseAnimation[] anims = SexLab.GetAnimationsByTags(2, "MF", "aggressive,Oral,LeadIn", true)
	self.doSex(player, speaker, anims)

	n = 5
	while n
		n -= 1
		if (males[n] && females[n])
			Utility.Wait(0.5)
			doSex(males[n], females[n], anims)
		endif
	endwhile
EndFunction


Function doSex(Actor act1, Actor act2, sslBaseAnimation[] anim)
	Actor[] sexActors = SexLabUtil.MakeActorArray(act1, act2)
	sexActors = SexLab.SortActors(sexActors)
	
	sslThreadModel Thread = SexLab.NewThread()
	Thread.AddActors(sexActors)
	Thread.SetAnimations(anim)
	Thread.DisableLeadIn()
	Thread.StartThread()
EndFunction

SexLabFramework Property SexLab  Auto  

Quest Property SOLGetSexFollowers  Auto  
ReferenceAlias Property Male1  Auto  
ReferenceAlias Property Male2  Auto  
ReferenceAlias Property Male3  Auto  
ReferenceAlias Property Male4  Auto  
ReferenceAlias Property Male5  Auto  
ReferenceAlias Property Female1  Auto  
ReferenceAlias Property Female2  Auto  
ReferenceAlias Property Female3  Auto  
ReferenceAlias Property Female4  Auto  
ReferenceAlias Property Female5  Auto  
