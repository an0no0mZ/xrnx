--[[----------------------------------------------------------------------------
-- Duplex.Launchpad 
----------------------------------------------------------------------------]]--

--[[

Inheritance: Launchpad > MIDIDevice > Device

A device-specific class 

--]]


--==============================================================================

class "Launchpad" (MIDIDevice)

function Launchpad:__init(name, message_stream)
  TRACE("Launchpad:__init", name, message_stream)

  MIDIDevice.__init(self, name, message_stream)

  -- this device has a color-space with 4 degrees of red and green
  --self.colorspace={4,4,0}
  self.colorspace={4,4,0}

  -- double-buffering features (not used)
  --[[
  self.display = 0
  self.update = 0
  self.flash = 0
  self.copy = 0
  ]]
end


--------------------------------------------------------------------------------

function Launchpad:point_to_value(pt)
  TRACE("Launchpad:point_to_value")

  -- default color is light/yellow
  local rslt = 127

  local red = pt.color[1]
  local green = pt.color[2]


  red = math.floor(red/64)
  green = math.floor(green/64)

  -- 12 for standard flags
  rslt = 16*green+red+12

  return rslt

end

--[[
--------------------------------------------------------------------------------

-- all LEDs are turned off, and the mapping mode, buffer settings, 
-- and duty cycle are reset to defaults

function Launchpad:reset()
    MIDIDevice.send_cc_message(self,0,0)
end


--------------------------------------------------------------------------------

-- set grid mapping mode to X-Y layout

function Launchpad:set_xy_map_mode()
    MIDIDevice.send_cc_message(self,0,1)
end


--------------------------------------------------------------------------------

-- set grid mapping mode to drum rack layout

function Launchpad:set_drum_map_mode()
  MIDIDevice.send_cc_message(self,0,1)
end


--------------------------------------------------------------------------------

-- range: 0-2 (low/medium/high brightness test)

function Launchpad:display_test(number)
  MIDIDevice.send_cc_message(self,0,125+number)
end


--------------------------------------------------------------------------------

-- Set buffer 0 or buffer 1 as the new �displaying� buffer. 

function Launchpad:set_active_display(number)
  self.display = 0
  MIDIDevice.send_cc_message(self,0,self.getCompositeBufferValue())
end


--------------------------------------------------------------------------------

-- Set buffer 0 or buffer 1 as the new �updating� buffer

function Launchpad:set_update_display(number)
  self.update = 0
    MIDIDevice.send_cc_message(self,0,self.getCompositeBufferValue())
end


--------------------------------------------------------------------------------

-- If 1: continually flip �displayed� buffers to make selected LEDs flash

function Launchpad:set_flash_mode(number)
  self.flash = 0
    MIDIDevice.send_cc_message(self,0,self.getCompositeBufferValue())
end


--------------------------------------------------------------------------------

-- copy the LED states from the new �displayed� buffer to the new �updating� buffer

function Launchpad:copy_buffer()
  self.flash = 0
    MIDIDevice.send_cc_message(self,0,self.getCompositeBufferValue())
end


--------------------------------------------------------------------------------

-- utility function
function Launchpad:getCompositeBufferValue()
  local result = 32+display+(update*4)+(flash*8)+(copy*16)
end
]]
