--!strict
local NarrativeController = {}
NarrativeController.__index = NarrativeController

function NarrativeController.new(gui, onAdvance)
 local self = setmetatable({gui=gui, onAdvance=onAdvance},NarrativeController)
 gui.Card.Advance.Activated:Connect(onAdvance)
 return self
end

function NarrativeController:showCard(title, text, buttonText)
 local touchGui = self.gui.Parent:FindFirstChild("TouchGui")
 if touchGui then touchGui.Enabled = false end
 local card = self.gui.Card
 card.Title.Text = title
 card.Reading.Body.Text = text
 card.Reading.CanvasPosition = Vector2.zero
 card.Advance.Text = buttonText or "Lanjut"
 card.Advance.Visible = buttonText ~= nil
 card.Visible = true
 self.gui.Header.Visible = false
end

function NarrativeController:showObjective(text)
 self.gui.Card.Visible = false
 self.gui.Header.Visible = true
 self.gui.Header.Objective.Text = text
end

return NarrativeController
