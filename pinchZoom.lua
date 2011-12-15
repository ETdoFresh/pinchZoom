system.activate("multitouch")
local pinchZoom = {}

function pinchZoom:new()
	local self = display.newGroup() -- Create instance
	local dbug = display.newText("TEST", 0, 0, native.systemFont, 16)
	dbug:setTextColor(0,0,0)
	
	-- Local Variables
	local prevTouches
	local prevNumTouches
	local isFocus = false
	local distance
	local xScaleOriginal, yScaleOriginal
	
	
	local dText = {"","","","","","","","","","","","","","","","","","","",""}
	local function updateDbug(msg)
		dText[20] = dText[19]
		dText[19] = dText[18]
		dText[18] = dText[17]
		dText[17] = dText[16]
		dText[16] = dText[15]
		dText[15] = dText[14]
		dText[14] = dText[13]
		dText[13] = dText[12]
		dText[12] = dText[11]
		dText[11] = dText[10]
		dText[10] = dText[9]
		dText[9] = dText[8]
		dText[8] = dText[7]
		dText[7] = dText[6]
		dText[6] = dText[5]
		dText[5] = dText[4]
		dText[4] = dText[3]
		dText[3] = dText[2]
		dText[2] = dText[1]
		dText[1] = tostring(msg)
		dbug.text = dText[1].."\n"..dText[2].."\n"..dText[3].."\n"..dText[4].."\n"..dText[5].."\n"..dText[6].."\n"..dText[7].."\n"..dText[8].."\n"..dText[9].."\n"..dText[10].."\n"
		dbug.text = dbug.text..dText[11].."\n"..dText[12].."\n"..dText[13].."\n"..dText[14].."\n"..dText[15].."\n"..dText[16].."\n"..dText[17].."\n"..dText[18].."\n"..dText[19].."\n"..dText[20]
		dbug.x = dbug.width / 2 + 5
		dbug.y = dbug.height / 2 + 5
	end
	updateDbug("pinchZoom Created.")
	
	-- Listen for touch events
	self:addEventListener("touch", self)
	
	-- Returns the x and y distance from one finger to the other
	local function calcDelta(event)
		local id, touch = next(prevTouches)
		if (event.id == id) then
			id, touch = next(prevTouches, id)
			assert(id ~= event.id)
		end
		
		local dx = touch.x - event.x
		local dy = touch.y - event.y
		return dx, dy
	end
	
	-- Touch Event
	function self:touch(event)
		
		-- Compute number of touches on the screen
		local numTouches = 1
		if (prevTouches) then
			numTouches = prevNumTouches + 1
			if (prevTouches[event.id]) then
				numTouches = numTouches - 1
			end
		end
		
		if (event.phase == "began") then
			
			-- First "began" event
			if (not(isFocus)) then
				-- Focus pinchZoom object
				display.getCurrentStage():setFocus(self)
				isFocus = true
				
				prevTouches = {}
				prevNumTouches = 0
				updateDbug("first touch event")
			-- Following "began" events. Compute distance if not set
			elseif (not(distance)) then
				local dx,dy
				if (prevTouches and numTouches >= 2) then
					dx, dy = calcDelta(event)
				end
				
				-- Get distance and set starting scale
				if (dx and dy) then
					local d = math.sqrt(dx * dx + dy * dy)
					if (d > 0) then
						distance = d
						xScaleOriginal = self.xScale
						yScaleOriginal = self.yScale
						print("distance = "..distance)
					end
				end
			end
			
			-- Update number of previous touches
			if (not(prevTouches[event.id])) then
				prevNumTouches = prevNumTouches + 1
				updateDbug("prevTouches["..tostring(event.id).."] began")
			end
			prevTouches[event.id] = event
			
		elseif (isFocus) then
			if (event.phase == "moved") then
			
				-- Compute distance when touch is moved
				if (distance) then
					local dx,dy
					if (prevTouches and numTouches >= 2) then
						dx, dy = calcDelta(event)
					end
					
					-- Get distance and set scale accordingly
					if (dx and dy) then
						local newDistance = math.sqrt(dx * dx + dy * dy)
						local scale = newDistance / distance
						print( "newDistance(" ..newDistance .. ") / distance(" .. distance .. ") = scale("..  scale ..")" )
						if (scale > 0) then
							self.xScale = xScaleOriginal * scale
							self.yScale = yScaleOriginal * scale
						end
					end
				end
				
				-- Update number of previous touches
				if (not(prevTouches[event.id])) then
					prevNumTouches = prevNumTouches + 1
					updateDbug("prevTouches["..tostring(event.id).."] created and moved")
				end
				prevTouches[event.id] = event
			
			elseif (event.phase == "ended" or event.phase == "cancelled") then
				-- Update number of touches
				if (prevTouches[event.id]) then
					prevNumTouches = prevNumTouches - 1
					prevTouches[event.id] = nil
					updateDbug("prevTouches["..tostring(event.id).."] ended")
				end

				-- Reset Distance
				distance = nil
				
				-- If no more fingers on the screen
				if (prevNumTouches == 0) then
					-- Return focus to the rest of the program
					display.getCurrentStage():setFocus( nil )
					isFocus = false
					
					-- Reset variables and arrays
					xScaleOriginal = nil
					yScaleOriginal = nil
					prevTouches = nil
					prevNumTouches = nil
				end
			end
		end
	end
	
	return self
end

return pinchZoom