Scriptname SOLGSUtil extends Quest

sslBaseAnimation CurrentAnimation

Function QuickSex(Actor follower, Actor speaker)
	if (SexLab.GetGender(speaker) == 1) ; female
		SexLab.QuickStart(speaker, follower)
	else
		SexLab.QuickStart(follower, speaker)
	endif
EndFunction

Function _restartFollowerQuest()
	if (SOLGetSexFollowers.IsRunning())
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
	self._moreway(player, speaker)
EndFunction

Function MorewayOral(Actor player, Actor speaker)
	self._moreway(player, speaker, true)
EndFunction

Function _moreway(Actor player, Actor speaker, bool oral = false)
	self._restartFollowerQuest()
	Utility.Wait(0.5)

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
	
	sslBaseAnimation[] anims
	if (oral)
		anims = SexLab.GetAnimationsByTags(2, "MF,Oral", "aggressive", true)
	else
		anims = SexLab.GetAnimationsByTags(2, "MF", "aggressive,Oral,LeadIn", true)
	endif
	
	int tid
	tid = self.doSex(player, speaker, anims, none, true)
	sslBaseAnimation startAnim = SexLab.GetController(tid).Animation
	
	sslThreadController controller
	n = 5
	while n
		n -= 1
		if (males[n] && females[n])
			Utility.Wait(5.0)
			self._moveNearPlayer(player, males[n])
			self._moveNearPlayer(player, females[n])
			Utility.Wait(0.5)
			tid = doSex(males[n], females[n], anims, startAnim)
			debug.notification(males[n].GetLeveledActorBase().GetName() + " x " + females[n].GetLeveledActorBase().GetName())
			controller = SexLab.GetController(tid)
			controller.AutoAdvance = false
		endif
	endwhile
	CurrentAnimation = startAnim
	RegisterForSingleUpdate(1.0)
EndFunction

Function _moveNearPlayer(Actor player, Actor act)
	if (act.GetDistance(player) > 500)
		act.MoveTo(player)
	endif
EndFunction

Event OnUpdate()
	Actor player = Game.GetPlayer()
	if (player.HasKeywordString("SexLabActive"))
		sslThreadController controller = SexLab.GetPlayerController()
		sslBaseAnimation anim = controller.Animation
		
		self.Log("now: " + anim.Name + ", prev: " + CurrentAnimation.Name)
		if (anim != CurrentAnimation)
			self._syncEvent("Animation", 0.5)
			CurrentAnimation = anim
		endif
		RegisterForSingleUpdate(3.0)
	else
		; stop OnUpdate
	endif
EndEvent

Event StageStartEventSOLGS(int tid, bool HasPlayer)
	self.Log("detect stage start")
	self._syncEvent("Animation", 0.5)
EndEvent

Event AnimationChangeEventSOLGS(int tid, bool HasPlayer)
	self.Log("detect animation change")
	self._syncEvent("Animation", 0.5)
EndEvent

Event OrgasmEndEventSOLGS(int tid, bool HasPlayer)
	self.Log("detect orgasm end")
	self._syncEvent("OrgasmEnd", 0.5)
EndEvent

Event AnimationEndEventSOLGS(int tid, bool HasPlayer)
	self.Log("detect animation end")
	self._syncEvent("End", 0.5)
EndEvent

Function _syncEvent(string eventName, float waitTime)
	sslThreadController playerController = SexLab.GetPlayerController()
	sslThreadController actorController
	ReferenceAlias[] malerefs = self._getMaleRefs()
	int n = 5
	
	while n
		n -= 1
		if (malerefs[n])
			Actor act = malerefs[n].GetActorRef()
			if (act && act.HasKeywordString("SexLabActive"))
				Utility.Wait(waitTime)
				actorController = SexLab.GetActorController(act)
				if (eventName == "Animation")
					self._syncSexAnimation(actorController, playerController)
				elseif (eventName == "OrgasmEnd")
					actorController.SendThreadEvent("OrgasmEnd") ; for Aroused
				elseif (eventName == "End")
					; self._sendOrgasm(actorController)
					actorController.EndAnimation()
				endif
			endif
		endif
	endwhile
EndFunction

Function _sendOrgasm(sslThreadController controller)
	if (controller.Animation.IsSexual())
		controller.Positions[0].SetFactionRank(sla_Arousal, 0)
	endif
	controller.Positions[1].SetFactionRank(sla_Arousal, 0)
EndFunction

Function _syncSexAnimation(sslThreadController npcCtrl, sslThreadController pcCtrl)
	sslBaseAnimation pcAnim = pcCtrl.Animation
	sslBaseAnimation npcAnim = npcCtrl.Animation
	
	self.Log("PC: " + pcAnim.Name + ", NPC: " + npcAnim.Name)
	self.Log("PC: " + pcCtrl.Animations.length + ", NPC: " + npcCtrl.Animations.length)
	
	if (pcAnim != npcAnim)
		npcCtrl.SetAnimation(npcCtrl.Animations.Find(pcAnim))
		npcCtrl.SendThreadEvent("AnimationChange")
		npcCtrl.RegisterForSingleUpdate(0.2)
	elseif (pcCtrl.Stage != npcCtrl.Stage)
		npcCtrl.GoToStage(pcCtrl.Stage)
	endif
EndFunction


int Function doSex(Actor act1, Actor act2, sslBaseAnimation[] anim, sslBaseAnimation startAnim = none, bool hook = false)
	Actor[] sexActors = SexLabUtil.MakeActorArray(act1, act2)
	sexActors = SexLab.SortActors(sexActors)
	
	sslThreadModel Thread = SexLab.NewThread()
	Thread.AddActors(sexActors)
	Thread.SetAnimations(anim)
	if (startAnim)
		Thread.SetStartingAnimation(startAnim)
	endif
	Thread.DisableLeadIn()
	
	if (hook)
		Thread.SetHook("SOLGS")
		RegisterForModEvent("HookStageStart_SOLGS", "StageStartEventSOLGS")
		RegisterForModEvent("HookAnimationChange_SOLGS", "AnimationChangeEventSOLGS")
		RegisterForModEvent("HookAnimationEnd_SOLGS", "AnimationEndEventSOLGS")
		RegisterForModEvent("HookOrgasmEnd_SOLGS", "OrgasmEndEventSOLGS")
	endif
	
	if Thread.StartThread()
		return Thread.tid
	endif
	return -1
EndFunction

Function Log(String msg)
	; bool debugLogFlag = true
	bool debugLogFlag = false

	if (debugLogFlag)
		debug.trace("[SSLSyncSex] " + msg)
	endif
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

Faction Property sla_Arousal  Auto  
