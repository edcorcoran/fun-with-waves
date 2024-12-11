import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"

local pd<const> = playdate
local snd<const> = pd.sound
local gfx<const> = pd.graphics

function freqToMIDINote(f)
  return 39.863137 * math.log(f) - 36.376317
end

function freqToPixelPeriod(f)
  local pixelspersecond = 30000 -- just a tuning variable, really, to make the waves look nice. Can easily change. 
  local Period = 1/f
  local pixelPeriod = pixelspersecond * Period
  return pixelPeriod
end

function phaseShiftToPixelPhaseShift(r, f)
  -- r is a value in radians
  -- just sending 0 to this because I haven't really implementing phase shift yet
  local pi = math.pi
  local pixelPhaseShift = freqToPixelPeriod(f) * r/(2*pi)
  return pixelPhaseShift
end

function addSynth(f)
  if synthSelector == 0 then
    synthSelector = 1
    else synthSelector = #synths+1
  end
  synths[synthSelector] = snd.synth.new(snd.kWaveSine)
  synths[synthSelector]:setVolume(0.5)
  freqs[synthSelector] = f
end 

function deleteSynth(n)
  -- delete synth n
  synths[n]:stop()
  table.remove(synths, n)
  synthSelector = n-1
end

-- set parameters for drawn sine wave
local startX = 0 -- left edge
local startY = 120 -- centered vertically
local endX = 400 -- right edge
local endY = 120 -- straight across 
local startAmplitude = 50 -- arbitrary
local endAmplitude = startAmplitude -- arbitrary but I don't want it to change

-- create initial waves
synthSelector = 0
synths = {}
freqs = {}
addSynth(220)


function pd.upButtonDown()
  synthSelector += 1
  synthSelector = (synthSelector-1) % #synths + 1
end 

function pd.downButtonDown()
  synthSelector -= 1
  synthSelector = (synthSelector-1) % #synths + 1
end 

function pd.AButtonDown()
  -- add a new synth and make it selected synth 
  addSynth(220)
end

function pd.BButtonDown()
  -- remove selected synth
  if synthSelector > 0 then deleteSynth(synthSelector) end
end


function pd.update()
  -- change active wave
  if synthSelector > 0 then
    freqs[synthSelector] = freqs[synthSelector]+ pd.getCrankTicks(60)
    if freqs[synthSelector] < 0 then freqs[synthSelector] = 0 end
    -- Play waves
    for i=1, #synths
    do
      synths[i]:playNote(freqs[i])
    end
  end

  -- display current info
  gfx.clear()  
  if synthSelector > 0 then
    update = "Wave " .. synthSelector .. " selected with frequency " .. freqs[synthSelector]
  else update = "No Waves" end
  gfx.drawText(update, 0, 0)
  

  -- draw waves
  if synthSelector > 0 then
    for i=1, #synths
    do
      gfx.drawSineWave(startX,startY,endX,endY, startAmplitude, endAmplitude, freqToPixelPeriod(freqs[i]), phaseShiftToPixelPhaseShift(0, freqs[i]))
    end
  end

  gfx.sprite.update()
  pd.timer.updateTimers()

end
