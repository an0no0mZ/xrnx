--[[============================================================================
xStreamUIOptions
============================================================================]]--
--[[

	Supporting class for xStream 

]]

--==============================================================================

class 'xStreamUIOptions' (vDialog)

xStreamUIOptions.DLG_W = 130
xStreamUIOptions.TXT_W = 70


-------------------------------------------------------------------------------

function xStreamUIOptions:__init(xstream)
  TRACE("xStreamUIOptions:__init(xstream)",xstream)

  assert(type(xstream)=="xStream","Expected 'xstream' as argument")

  self.xstream = xstream

  self.prefs = renoise.tool().preferences

  vDialog.__init(self)

  self.title = "xStream options"

  --self.start_option = property(self.get_start_option,self.set_start_option)
  --self.start_option_observable = renoise.Document.ObservableNumber(xStreamUIOptions.START_OPTION.ON_PLAY_EDIT)

  --self.autostart = property(self.get_autostart,self.set_autostart)
  --self.autostart_observable = renoise.Document.ObservableBoolean(false)

  self.update_model_requested = false

  self.selected_tab_index = 1

  -- initialize

  renoise.tool().app_idle_observable:add_notifier(function()
    self:on_idle()
  end)

  self.xstream.selected_model_index_observable:add_notifier(function()    
    if self.prefs.launch_selected_model.value then
      --print(">>> self.xstream.selected_model_index",self.xstream.selected_model_index)
      if (self.xstream.selected_model_index > 0) then
        local model = self.xstream.models[self.xstream.selected_model_index]
        self.prefs.launch_model.value = model.file_path
        --print("model.file_path",model,model.file_path)
      end
      self.update_model_requested = true
    end
  end)

  self.prefs.launch_selected_model:add_notifier(function()
    self.update_model_requested = true
  end)

  self.xstream.models_observable:add_notifier(function()
    self.update_model_requested = true
  end)

  self:show_tab(self.selected_tab_index)

end

--------------------------------------------------------------------------------
-- Get/set methods
--------------------------------------------------------------------------------
--[[
function xStreamUIOptions:get_start_option()
  return self.start_option_observable.value 
end

function xStreamUIOptions:set_start_option(val)
  self.start_option_observable.value = val

end
]]
--------------------------------------------------------------------------------
--[[
function xStreamUIOptions:get_autostart()
  return self.autostart_observable.value 
end

function xStreamUIOptions:set_autostart(val)
  self.autostart_observable.value = val
end
]]

-------------------------------------------------------------------------------
-- Overridden methods
-------------------------------------------------------------------------------

function xStreamUIOptions:show()

  vDialog.show(self)

  self.update_model_requested = true
  self:show_tab(self.selected_tab_index)

end

--------------------------------------------------------------------------------
-- Class methods
--------------------------------------------------------------------------------

function xStreamUIOptions:show_tab(idx)
  TRACE("xStreamUIOptions:show_tab(idx)",idx)

  local tabs = {
    "xStreamOptionsGeneral",
    "xStreamOptionsStreaming",
    "xStreamOptionsOutput",
  }

  for k,v in ipairs(tabs) do
    local tab_elm = self.vb.views[v]
    if tab_elm then
      self.vb.views[v].visible = false
    end
  end

  local tab_elm = self.vb.views[tabs[idx]]
  if tab_elm then
    tab_elm.visible = true
  end

  self.selected_tab_index = idx

end

-------------------------------------------------------------------------------

function xStreamUIOptions:create_dialog()

  self.xstream.writeahead_factor_observable:add_notifier(function()
    TRACE("*** xStreamUI - self.xstream.writeahead_factor_observable fired...",self.xstream.writeahead_factor)
    local view = self.vb.views["xStreamImplWriteAheadFactor"]
    view.value = self.xstream.writeahead_factor
  end)

  local STREAMING_TXT_W = 120
  local STREAMING_CTRL_W = 100

  local vb = self.vb
  return vb:column{ -- options 
    margin = 6,
    vb:switch{
      id = "xStreamOptionsTab",
      value = self.selected_tab_index,
      items = {
        "General",
        "Streaming",
        "Output",
      },
      width = 300,
      notifier = function(idx)
        self:show_tab(idx)
      end
    },
    vb:space{
      height = 6,
    },

    -- GENERAL OPTIONS ----------------------------------

    vb:column{
      id = "xStreamOptionsGeneral",
      width = "100%",
      visible = false,
      spacing = 6,
      vb:column{
        --style = "group",
        width = "100%",
        --margin = 6,
        vb:row{
          vb:checkbox{
            bind = self.prefs.autostart,
          },
          vb:text{
            text="Autostart tool when Renoise launches",
          },
        },
        vb:row{
          vb:checkbox{            
            bind = self.prefs.launch_selected_model,
          },
          vb:text{
            text= "Remember selected model, or choose"
          },
          vb:popup{
            items = {xStreamUI.NO_MODEL_SELECTED},
            id = "xStreamImplLaunchModel",
            notifier = function(idx)
              local model = self.xstream.models[idx-1]
              if model then
                self.prefs.launch_model.value = model.file_path
              end
            end,
          },
        },
        vb:row{
          vb:text{
            text= "Userdata"
          },
          vb:textfield{
            width = 160,
            bind = self.prefs.user_folder,
          },
          vb:button{
            text = "Browse",
            notifier = function()
              local new_path = renoise.app():prompt_for_path("Specify folder for models, preset and favorites")
              if (new_path ~= "") then
                self.prefs.user_folder.value = new_path
              end
            end,
          },
          vb:button{
            text = "Reset",
            notifier = function()
              self.prefs.user_folder.value = xStreamPrefs.USER_FOLDER
            end,
          }        },
        --[[
        vb:button{
          text = "remove trace statements",
          notifier = function()
            xDebug.remove_trace_statements()
          end
        }
        ]]

      },
      vb:column{ -- stats
        margin = 4,
        width = "100%",
        style = "group",
        vb:text{
          text= "Stats",
          font = "bold",
        },
        vb:text{
          text= "",
          id = "xStreamImplStats",
        },
      },
    },
    
    -- STREAMING OPTIONS ----------------------------------

    vb:column{
      id = "xStreamOptionsStreaming",
      visible = false,
      spacing = 6,
      --style = "group",
      width = "100%",
      vb:row{
        vb:checkbox{
          id = "xStreamImplSuspend",
          bind = self.prefs.suspend_when_hidden,
        },
        vb:text{
          text="Suspend streaming while interface is hidden",
        },
      },

      vb:column{
        margin = 6,
        style = "group",
        width = "100%",
        vb:row{
          vb:text{
            text="Enable streaming",
            width = STREAMING_TXT_W,
          },
          vb:row{
            vb:popup{
              bind = self.prefs.start_option,
              items = xStreamPrefs.START_OPTIONS,
              width = STREAMING_CTRL_W,
            },
          },
        },

        vb:row{
          vb:text{
            text = "Default scheduling",
            width = STREAMING_TXT_W,
          },
          vb:popup{
            items = xStream.SCHEDULES,
            bind = self.prefs.scheduling,
            width = STREAMING_CTRL_W,
          },
        },

        vb:row{
          vb:text{
            text = "Stream mute-mode",
            width = STREAMING_TXT_W,
          },
          vb:popup{
            items = xStream.MUTE_MODES,
            bind = self.xstream.mute_mode_observable,
            width = STREAMING_CTRL_W,
          },
        },

        vb:row{
          tooltip = "Control how far ahead xStream should produce output (smaller = longer)",
          vb:text{
            text="Writeahead factor",
            width = STREAMING_TXT_W,
          },
          vb:valuebox{
            id = "xStreamImplWriteAheadFactor",
            min = 125,
            max = 400,
            width = STREAMING_CTRL_W,
            --bind = self.xstream.writeahead_factor_observable
            value = self.xstream.writeahead_factor,
            notifier = function(val)
              self.xstream.writeahead_factor = val
            end
          },
        },


      },

    },

    -- OUTPUT OPTIONS ----------------------------------

    vb:column{ -- panel
      id = "xStreamOptionsOutput",
      visible = false,
      width = "100%",
      vb:column{
        vb:text{
          text =  "These settings are provided as default values - each model"
                .."\ncan choose to override the values with it's own ones.",
        },
        vb:space{
          height = 6,
        }
      },
      vb:column{ 
        margin = 6,
        style = "group",
        width = "100%",
        --[[
        vb:row{
          tooltip = "The active track at which xStream will produce output",
          vb:text{
            text = "track_index",
          },
          vb:valuebox{
            min = 0,
            max = 255,
            bind = self.xstream.track_index_observable,
          },
        },
        vb:row{
          tooltip = "The automation device-parameter where automation is written",
          vb:text{
            text = "param_index",
          },
          vb:valuebox{
            min = 0,
            max = 255,
            bind = self.xstream.device_param_index_observable,
          },
        },
        ]]

        vb:row{
          tooltip = "Determine the default automation interpolation/playmode",
          vb:text{
            text = "Automation playmode",
          },
          vb:popup{
            items = xStream.PLAYMODES,
            bind = self.xstream.automation_playmode_observable,
          },
        },

        vb:row{
          tooltip = "Whether to include hidden columns when writing output",
          vb:checkbox{
            bind = self.xstream.include_hidden_observable,
          },
          vb:text{
            text = "include_hidden",
          },
        },
        vb:row{
          tooltip = "Whether to clear undefined values, columns",
          vb:checkbox{
            bind = self.xstream.clear_undefined_observable,
          },
          vb:text{
            text = "clear_undefined",
          },
        },
        vb:row{
          tooltip = "Automatically reveal (sub-)columns with output",
          vb:checkbox{
            bind = self.xstream.expand_columns_observable,
          },
          vb:text{
            text = "expand_columns",
          },
        },
      },

    },
  }

end

--------------------------------------------------------------------------------

function xStreamUIOptions:update_model_selector(model_names)
  print("xStreamUIOptions:update_model_selector(model_names)",model_names)

  local model_popup = self.vb.views["xStreamImplLaunchModel"]
  if model_popup then
    local model_names = self.xstream:get_model_names(true)
    table.insert(model_names,1,xStreamUI.NO_MODEL_SELECTED)
    model_popup.items = model_names
    model_popup.active = not self.prefs.launch_selected_model.value
    if self.prefs.launch_selected_model.value then
      model_popup.value = (self.xstream.selected_model_index == 0) 
        and 1 or self.xstream.selected_model_index+1
    else
      for k,v in ipairs(self.xstream.models) do
        if (v.file_path == self.xstream.launch_model) then
          model_popup.value = k
        end
      end
    end
  end
end

--------------------------------------------------------------------------------

function xStreamUIOptions:on_idle()
  
  if self.update_model_requested then
    self.update_model_requested = false
    self:update_model_selector()
  end

  -- display some stats 
  local xs = self.xstream 
  local view = self.vb.views["xStreamImplStats"]
  if view then
    local str_stat = ("Memory usage: %.2f Mb"):format(collectgarbage("count")/1024)
      ..("\nLines Travelled: %d"):format(xs.stream.writepos.lines_travelled)
      ..("\nWritePosition: %d,%d"):format(xs.stream.writepos.sequence,xs.stream.writepos.line)
      ..("\nWriteahead: %d lines"):format(xs.writeahead)
      ..("\nSelected model: %s"):format(xs.selected_model and xs.selected_model.name or "N/A") 
      ..("\nStream active: %s"):format(xs.active and "true" or "false") 
      ..("\nStream muted: %s"):format(xs.muted and "true" or "false") 
    view.text = str_stat
  end

end