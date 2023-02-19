Tool = Object:extend()

function Tool:new(name, id, isEffect, icon, iconOut)
    self.name = name
    self.id = id
    self.isEffect = isEffect
    self.icon = icon
    self.iconOut = iconOut
end