--!strict
local Lobby={}
Lobby.__index=Lobby
function Lobby.new(config)
 return setmetatable({config=config,members={},host=nil,revision=1,phase="waiting"},Lobby)
end
function Lobby:changed() self.revision+=1 end
function Lobby:join(player)
 if self.members[player] then return true end
 if self.phase~="waiting" or #self:players()>=self.config.maxPlayers then return false end
 local used={}
 for _,member in pairs(self.members) do used[member.roleId]=true end
 for _,role in ipairs(self.config.roles) do
  if not used[role.id] then
   self.members[player]={roleId=role.id,ready=false}
   if not self.host then self.host=player end
   self:changed(); return true
  end
 end
 return false
end
function Lobby:players()
 local result={}
 for player in pairs(self.members) do table.insert(result,player) end
 table.sort(result,function(a,b) return a.UserId<b.UserId end)
 return result
end
function Lobby:canStart()
 if self.phase~="waiting" or not self.host then return false end
 for _,member in pairs(self.members) do if not member.ready then return false end end
 return true
end
function Lobby:snapshot(player,notice)
 local result={}
 for _,p in ipairs(self:players()) do
  local m=self.members[p]
  table.insert(result,{userId=p.UserId,displayName=p.DisplayName,roleId=m.roleId,ready=m.ready})
 end
 return {joined=self.members[player]~=nil,revision=self.revision,phase=self.phase,capacity=self.config.maxPlayers,
  hostUserId=if self.host then self.host.UserId else nil,members=result,canStart=self:canStart(),notice=notice}
end
function Lobby:request(player,action,revision,value)
 local member=self.members[player]
 if not member or revision~=self.revision or self.phase~="waiting" then return false end
 if action=="leave" then self:remove(player);return true end
 if action=="ready" and typeof(value)=="boolean" then
  member.ready=value
 elseif action=="role" and typeof(value)=="string" then
  local found=false
  for _,role in ipairs(self.config.roles) do if role.id==value then found=true end end
  if not found then return false end
  for p,m in pairs(self.members) do if p~=player and m.roleId==value then return false end end
  member.roleId=value;member.ready=false
 elseif action=="launch" and self.host==player and self:canStart() then
  self.phase="playing"
 else return false end
 self:changed();return true
end
function Lobby:remove(player)
 if not self.members[player] then return end
 self.members[player]=nil
 if self.host==player then self.host=self:players()[1] end
 if not self.host then self.phase="waiting" end
 self:changed()
end
function Lobby:finish()
 self.phase="waiting"
 for _,m in pairs(self.members) do m.ready=false end
 self:changed()
end
return Lobby
