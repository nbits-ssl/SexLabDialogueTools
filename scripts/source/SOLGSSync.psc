Scriptname SOLGSSync extends ReferenceAlias  

Event OnCellLoad()
	Quest qst = self.GetOwningQuest()
	Utility.Wait(3)
	qst.Stop()
	qst.Start()
	SOLGetSex.Stop()
	SOLGetSex.Start()
EndEvent

Quest Property SOLGetSex  Auto  
