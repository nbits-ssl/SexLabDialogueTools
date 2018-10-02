;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SOLGS_TIF__MorewayOral Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor player = Game.GetPlayer()

if (SOLGetSexFollowers.isRunning())
	SOLGetSexFollowers.Stop()
endif
SOLGetSexFollowers.Start()

Actor[] males = new Actor[5]
Actor[] females = new Actor[5]

ReferenceAlias[] malerefs = new ReferenceAlias[5]
malerefs[0] = Male1
malerefs[1] = Male2
malerefs[2] = Male3
malerefs[3] = Male4
malerefs[4] = Male5

ReferenceAlias[] femalerefs = new ReferenceAlias[5]
femalerefs[0] = Female1
femalerefs[1] = Female2
femalerefs[2] = Female3
femalerefs[3] = Female4
femalerefs[4] = Female5

idx = 0
n = 5
while n
	n -= 1
	if (malerefs[n])
		Actor act = malerefs[n].GetActorRef()
		if (act && act != akSpeaker)
			males[idx] = act
			idx += 1
		endif
	endif
endwhile

int idx = 0
int n = 5
while n
	n -= 1
	if (femalerefs[n])
		Actor act = femalerefs[n].GetActorRef()
		if (act && act != akSpeaker)
			females[idx] = act
			idx += 1
		endif
	endif
endwhile

sslBaseAnimation[] animsall
sslBaseAnimation[] anims
anims = new sslBaseAnimation[1]
animsall = SexLab.GetAnimationsByTags(2, "MF,Oral", "aggressive,Vaginal,Anal")
int x = Utility.RandomInt(0, animsall.Length)
anims[0] = animsall[x]

doSex(player, akSpeaker, anims)

n = 5
while n
	n -= 1
	if (males[n] && females[n])
		Utility.Wait(0.5)
		doSex(males[n], females[n], anims)
	endif
endwhile

;
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Function doSex(Actor male, Actor female, sslBaseAnimation[] anim)
	Actor[] sexActors
	sexActors = new Actor[2]
	sexActors[0] = female
	sexActors[1] = male
	
	; SexLab.StartSex(sexActors, anim)
	; startsex with noleadin
	
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
