--!strict
local ChapterService = {}
ChapterService.__index = ChapterService

function ChapterService.new(chapter)
 return setmetatable({chapter=chapter, states={}, checkpoints={}}, ChapterService)
end

function ChapterService:reset(player)
 local previous = self.states[player]
 self.states[player] = {phase="title", objectiveIndex=1, revision=if previous then previous.revision+1 else 1}
 self.checkpoints[player] = nil
end

function ChapterService:snapshot(player)
 local state = self.states[player]
 if not state then return nil end
 local checkpoint = self.checkpoints[player]
 return {chapterId=self.chapter.id, phase=state.phase, objectiveIndex=state.objectiveIndex, revision=state.revision, error=state.error,
  hasCheckpoint=checkpoint~=nil, checkpointIndex=checkpoint}
end

function ChapterService:enterMenu(player, revision)
 local state = self.states[player]
 if not state or state.revision ~= revision or state.phase == "menu" then return false end
 if state.phase == "exploring" or state.phase == "dialogue" or state.phase == "cinematic" then
  self.checkpoints[player] = math.min(state.objectiveIndex,#self.chapter.objectives)
 elseif state.phase == "completed" then
  self.checkpoints[player] = nil
 end
 state.phase, state.error = "menu", nil
 state.revision += 1
 return true
end

function ChapterService:startChapter(player, revision, chapterId)
 local state = self.states[player]
 if not state or state.phase ~= "menu" or state.revision ~= revision or chapterId ~= self.chapter.id then return false end
 self:reset(player)
 return true
end

function ChapterService:resume(player, revision)
 local state, checkpoint = self.states[player], self.checkpoints[player]
 if not state or state.phase ~= "menu" or state.revision ~= revision or not checkpoint then return false end
 state.phase, state.objectiveIndex, state.error = "exploring", checkpoint, nil
 state.revision += 1
 return true
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
 if state.phase == "exploring" then self.checkpoints[player] = state.objectiveIndex end
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
 self.checkpoints[player] = nil
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
