;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SOLGS_TIF__MorewayOral Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
(self.GetOwningQuest() as SOLGSUtil).MorewayOral(Game.GetPlayer(), akSpeaker)
;
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

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
