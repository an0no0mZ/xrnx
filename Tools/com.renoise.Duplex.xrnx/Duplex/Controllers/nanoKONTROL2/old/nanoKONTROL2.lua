--[[----------------------------------------------------------------------------
-- Duplex.NanoKontrol2
----------------------------------------------------------------------------]]--

-- default configuration of the NanoKontrol2
-- uses a custom device class, a control map and the Mixer application


--==============================================================================

class "NanoKontrol2" (MidiDevice)

function NanoKontrol2:__init(display_name, message_stream, port_in, port_out)
  TRACE("NanoKontrol2:__init", display_name, message_stream, port_in, port_out)

  MidiDevice.__init(self, display_name, message_stream, port_in, port_out)


end


--------------------------------------------------------------------------------

-- setup "Mixer + Transport" for this configuration

duplex_configurations:insert {

  -- configuration properties
  name = "Mixer + Transport",
  pinned = true,

  -- device properties
  device = {
    class_name = "NanoKontrol2",          
    display_name = "nanoKONTROL2",
    device_port_in = "nanoKONTROL2",
    device_port_out = "nanoKONTROL2",
    control_map = "Controllers/nanoKONTROL2/nanoKONTROL2.xml",
    thumbnail = "nanoKONTROL2.bmp",
    protocol = DEVICE_MIDI_PROTOCOL
  },
  
  applications = {
    Mixer = {
      mappings = {
        solo = {
          group_name = "Buttons1",
        },
        mute = {
          group_name = "Buttons2",
        },
        panning = {
          group_name= "Encoders",
        },
        levels = {
          group_name = "Faders",
        },
        mode = {
          group_name = "MARKER",
          index = 1,
        },
      },
      options = {
        invert_mute = 1,
        follow_track = 1,
      }
    },
    Transport = {
      mappings = {
        loop_pattern = {
          group_name = "CYCLE",
          index = 1,
        },
        goto_previous = {
          group_name = "Transport",
          index = 1,
        },
        goto_next = {
          group_name = "Transport",
          index = 2,
        },
        stop_playback = {
          group_name = "Transport",
          index = 3,
        },
        start_playback = {
          group_name = "Transport",
          index = 4,
        },
        edit_mode = {
          group_name = "Transport",
          index = 5,
        },
      },
      options = {
      }
    },
    TrackSelector = {
      mappings = {
        prev_next_track = {
          group_name = "TRACK",
          index = 1,
        },
        select_track = {
          group_name = "Buttons3",
          index = 1,
        },
        prev_next_page = {
          group_name = "MARKER",
          index = 2,
        },
      },
    },
  }
}


--------------------------------------------------------------------------------

-- setup "NOW" for this configuration

duplex_configurations:insert {

  -- configuration properties
  name = "NOW",
  pinned = true,

  -- device properties
  device = {
    class_name = "NanoKontrol2",          
    display_name = "nanoKONTROL2",
    device_port_in = "nanoKONTROL2",
    device_port_out = "nanoKONTROL2",
    control_map = "Controllers/nanoKONTROL2/nanoKONTROL2.xml",
    thumbnail = "nanoKONTROL2.bmp",
    protocol = DEVICE_MIDI_PROTOCOL
  },
  
  applications = {
    Transport = {
      mappings = {
        loop_pattern = {
          group_name = "CYCLE",
          index = 1,
        },
        goto_previous = {
          group_name = "Transport",
          index = 1,
        },
        goto_next = {
          group_name = "Transport",
          index = 2,
        },
        stop_playback = {
          group_name = "Transport",
          index = 3,
        },
        start_playback = {
          group_name = "Transport",
          index = 4,
        },
      },
    },
    NotesOnWheels = {
      mappings = {
        multi_sliders = {
          group_name = "Faders",
        },
        pitch_adjust = {
          group_name = "Encoders",
          index = 1,
        },
        velocity_adjust = {
          group_name = "Encoders",
          index = 2,
        },
        offset_adjust = {
          group_name = "Encoders",
          index = 3,
        },
        gate_adjust = {
          group_name = "Encoders",
          index = 4,
        },
        retrig_adjust = {
          group_name = "Encoders",
          index = 5,
        },
        step_spacing = {
          group_name = "Encoders",
          index = 6,
        },
        num_lines = {
          group_name = "Encoders",
          index = 7,
        },
        multi_adjust = {
          group_name = "Encoders",
          index = 8,
        },
        position = {
          group_name = "Buttons1",
        },
        num_steps = {
          group_name = "Buttons2",
          orientation = HORIZONTAL,
        },
        write = {
          group_name = "Transport",
          index = 5,
        },
        learn = {
          group_name = "Buttons3",
          index = 1,
        },
        fill = {
          group_name = "Buttons3",
          index = 2,
        },
        global = {
          group_name = "Buttons3",
          index = 3,
        },
        set_mode_pitch = {
          group_name = "Buttons3",
          index = 4,
        },
        set_mode_velocity = {
          group_name = "Buttons3",
          index = 5,
        },
        set_mode_offset = {
          group_name = "Buttons3",
          index = 6,
        },
        set_mode_gate = {
          group_name = "Buttons3",
          index = 7,
        },
        set_mode_retrig = {
          group_name = "Buttons3",
          index = 8,
        },
        shift_up = {
          group_name = "MARKER",
          index = 2,
        },
        shift_down = {
          group_name = "MARKER",
          index = 3,
        },
      },
    },
    TrackSelector = {
      mappings = {
        prev_next_track = {
          group_name = "TRACK",
          index = 1,
        },
      },
    },
  }
}
