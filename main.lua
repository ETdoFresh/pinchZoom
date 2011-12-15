local pinchZoom = require 'pinchZoom'

local bg = display.newRect(0,0,display.contentWidth, display.contentHeight)
bg:setFillColor(255,255,255)

local pZoomObject = pinchZoom:new()

local newImage = display.newImageRect("aquariumbackgroundIPhone.jpg", 320, 480)
newImage.x = newImage.width / 2
newImage.y = newImage.height / 2
pZoomObject:insert(newImage)