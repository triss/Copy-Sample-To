--[[============================================================================
Copy sample to

Author: Tristan Strange <tristan.strange@gmail.com>
Version: 0.1
============================================================================]]--

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

-- returns the higest mapped note in instrument
function find_highest_note(inst)
  local max = 0
  for _,s in pairs(inst.samples) do
    max = math.max(max, s.sample_mapping.note_range[2])
  end
  return max
end

--------------------------------------------------------------------------------
-- Sample copying
--------------------------------------------------------------------------------

function copy_sample_to_inst(sample, inst)
  local note = find_highest_note(inst) + 1
  local s = inst:insert_sample_at(#inst.samples + 1)
  s:copy_from(sample)
  s.sample_mapping.base_note = note
  s.sample_mapping.note_range = {note, note}
end

function copy_selected_sample_to(inst)
 copy_sample_to_inst(renoise.song().selected_sample, inst)
end

function copy_instrument_samples_to(src, dest)
  for _,s in pairs(src.samples) do
    copy_sample_to_inst(s, dest)
  end
end

function copy_selected_instrument_samples_to(dest)
  copy_instrument_samples_to(renoise.song().selected_instrument, dest)
end

--------------------------------------------------------------------------------
-- Add menu items and keyboard shortcuts
--------------------------------------------------------------------------------

for i=1,7 do
  renoise.tool():add_menu_entry{
    name = 'Instrument Box:Copy samples to:Instrument ' .. (i-1),
    invoke = function()
      local inst = renoise.song().instruments[i]
      copy_selected_instrument_samples_to(inst)
                               end }
  renoise.tool():add_menu_entry{
    name = 'Sample Navigator:Copy sample to:Instrument ' ..  (i-1),
    invoke = function()
      local inst = renoise.song().instruments[i]
      copy_selected_sample_to(inst)
                               end }
  renoise.tool():add_keybinding{
    name = 'Global:Copy instrument samples to:Instrument ' .. (i-1),
    invoke = function()
      local inst = renoise.song().instruments[i]
      copy_selected_instrument_samples_to(inst)
                               end }
  renoise.tool():add_keybinding{
    name = 'Global:Copy sample to:Instrument ' .. (i-1),
    invoke = function()
      local inst = renoise.song().instruments[i]
      copy_selected_sample_to(inst)
                               end }
end
