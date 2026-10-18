--!strict
local ChapterService = {}
ChapterService.__index = ChapterService

function ChapterService.new(chapter)
 return setmetatable({chapter=chapter, states={}}, ChapterService)
end

function ChapterService:reset(player)
 local previous = self.states[player]
 self.states[player] = {phase="title", objectiveIndex=1, revision=if previous then previous.revision+1 else 1}
end

function ChapterService:snapshot(player)
 local state = self.states[player]
 if not state then return nil end
 return {chapterId=self.chapter.id, phase=state.phase, objectiveIndex=state.objectiveIndex, revision=state.revision, error=state.error}
end

function ChapterService:expectedInteraction(player)
 local state = self.states[player]
 if not state or state.phase ~= "exploring" then return nil end
 local objective = self.chapter.objectives[state.objectiveIndex]
 return if objective then objective.id else nil
end

function ChapterService:interact(player, interactionId)
 if interactionId == nil or interactionId ~= self:expectedInteraction(player) then return false end
 local state = self.states[player]
 state.phase = "dialogue"
 state.revision += 1
 return true
end

function ChapterService:acknowledge(player, revision)
 local state = self.states[player]
 if not state or revision ~= state.revision then return false end
 if state.phase == "title" then
  state.phase = "exploring"
 elseif state.phase == "dialogue" then
  state.objectiveIndex += 1
  state.phase = if state.objectiveIndex > #self.chapter.objectives then "cinematic" else "exploring"
 else
  return false
 end
 state.revision += 1
 return true
end

function ChapterService:finishCinematic(player, revision)
 local state = self.states[player]
 if not state or state.phase ~= "cinematic" or revision ~= state.revision then return false end
 state.phase = "completed"
 state.revision += 1
 return true
end

function ChapterService:remove(player)
 self.states[player] = nil
end

function ChapterService:fail(player, message)
 local state = self.states[player]
 if not state or (state.phase == "error" and state.error == message) then return false end
 state.phase = "error"
 state.error = message
 state.revision += 1
 return true
end

return ChapterService
