--[[ 

  Testcase for xSongSettings

--]]

_xlib_tests:insert({
name = "xSongSettings",
fn = function()

  require (_xlibroot.."xLine")
  require (_xlibroot.."xSongSettings")
  _trace_filters = {"^xSongSettings*"}

  LOG(">>> xSongSettings: starting unit-test...")

  local passed,err = nil,nil

  local fooTokenStart = "-- begin FOO"
  local fooTokenEnd = "-- end FOO"

  local fooSettings = {
    some_number = 42,
    some_boolean = true,
    some_object = {
      with = {
        deep = {
          nesting = true
        }
      }
    }
  }

  -- test for non-existing settings
  passed,err = xSongSettings.test("blah","blup")
  if passed then 
    error(err)
  end

  -- clear FooSettings
  passed,err = xSongSettings.clear(fooTokenStart,fooTokenEnd)
  if not passed then 
    error(err)
  end

  -- test for FooSettings 
  passed,err = xSongSettings.test(fooTokenStart,fooTokenEnd)
  if passed then 
    error(err)
  end

  -- save FooSettings 
  passed,err = xSongSettings.store(fooSettings,fooTokenStart,fooTokenEnd)
  if not passed then 
    error(err)
  end
  
  assert(xSongSettings.test(fooTokenStart,fooTokenEnd)==true)

  -- load FooSettings
  local fooRetrieved = xSongSettings.retrieve(fooTokenStart,fooTokenEnd)
  assert(type(fooRetrieved)=="table")
  assert(type(fooRetrieved.some_number)=="number")
  assert(type(fooRetrieved.some_boolean)=="boolean")
  assert(type(fooRetrieved.some_object)=="table")
  assert(type(fooRetrieved.some_object.with)=="table")
  assert(type(fooRetrieved.some_object.with.deep)=="table")
  assert(type(fooRetrieved.some_object.with.deep.nesting)=="boolean")
  

  local barTokenStart = "-- begin BAR"
  local barTokenEnd = "-- end BAR"

  local barSettings = {
    other_number = 3,
    other_boolean = false,
    other_object = {
      with = {
        deep = {
          nesting = false
        }
      }
    }
  }

  -- clear barSettings
  passed,err = xSongSettings.clear(barTokenStart,barTokenEnd)
  if not passed then 
    error(err)
  end

  -- save BarSettings
  passed,err = xSongSettings.store(barSettings,barTokenStart,barTokenEnd)
  if not passed then 
    error(err)
  end

  -- load BarSettings
  local barRetrieved = xSongSettings.retrieve(barTokenStart,barTokenEnd)
  assert(type(barRetrieved)=="table")
  assert(type(barRetrieved.other_number)=="number")
  assert(type(barRetrieved.other_boolean)=="boolean")
  assert(type(barRetrieved.other_object)=="table")
  assert(type(barRetrieved.other_object.with)=="table")
  assert(type(barRetrieved.other_object.with.deep)=="table")
  assert(type(barRetrieved.other_object.with.deep.nesting)=="boolean")

  -- clear FooSettings
  passed,err = xSongSettings.clear(fooTokenStart,fooTokenEnd)
  if not passed then 
    error(err)
  end

  assert(xSongSettings.test(fooTokenStart,fooTokenEnd)==false)
  
  -- clear BarSettings
  passed,err = xSongSettings.clear(barTokenStart,barTokenEnd)
  if not passed then 
    error(err)
  end

  assert(xSongSettings.test(barTokenStart,barTokenEnd)==false)

  LOG(">>> xSongSettings: OK - passed all tests")

end
})
