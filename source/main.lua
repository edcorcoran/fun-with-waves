import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"

local pd<const> = playdate
local snd<const> = pd.sound
local gfx<const> = pd.graphics

local synth = snd.synth.new(snd.kWaveSine)
synth:setVolume(0.5)

local synth2 = snd.synth.new(snd.kWaveSine)
synth2:setVolume(0.5)

local synthSelector = 1

function freqToMIDINote(f)
    return 39.863137 * math.log(f) - 36.376317
  end


-- notes on pixel math
-- the drawSineWave function uses pixels, not frequency
-- so I need to translate frequency to pixels
-- for now, leave startXY and endXY as hardcoded.
-- For sound amplitude represents volume. I can play with that later. 
-- Volume goes from 0 to 1; Amplitude should be a relative thing when I start stacking sine waves

-- period: T = 1/f; interval between oscilations in seconds; need to translate this to pixels
-- period in pixels = (pixels per second) * T
-- 

-- phase shift: I'll need to translate this from degrees/radians to pixels
-- phi is the phase and specifies (in radians) where in its cycle the oscillation is at t = 0.
-- When phi is non-zero, the entire waveform appears to be shifted backwards in time by the amount
-- phi / omega seconds.  A negative value represents a delay, and a positive value represents an advance.
-- omega = angular frequency and is measured in radians
-- omega = 2*pi*f, where f is the frequency in oscilations per second
-- phaseShift in pixels = (pixels per second) * phi / omega
-- = (pixels per second) * phi/2pi * 1/f
-- = (pixels per second) * (% of cycle in degrees or rads) * T

-- set frequency variables
local freq=220
-- local pixelspersecond = freq*100 -- anchors the period to be 100 pixels long
local pixelspersecond = 30000 -- just a tuning variable, really, to make the waves look nice. Can easily change. 
local Period = 1/freq
local pixelPeriod = pixelspersecond * Period
local pi = math.pi
local phaseShift = 0 -- in radians
local pixelPhaseShift = pixelspersecond * Period * phaseShift/(2*pi)

-- second wave
local freq2=300
local Period2 = 1/freq2
local pixelPeriod2 = pixelspersecond * Period2



-- set parameters for drawn sine wave
local startX = 0 -- left edge
local startY = 120 -- centered vertically
local endX = 400 -- right edge
local endY = 120 -- straight across 
local startAmplitude = 50 -- arbitrary
local endAmplitude = startAmplitude -- arbitrary but I don't want it to change

function pd.upButtonDown()
  synthSelector += 1
  synthSelector = math.fmod(synthSelector-1,2)+1
end 

function pd.downButtonDown()
  synthSelector += 1
  synthSelector = math.fmod(synthSelector-1,2)+1
end 

function pd.update()

  if synthSelector == 1 then 
    freq = freq + pd.getCrankTicks(60)
    if freq < 0 then freq = 0 end
    Period = 1/freq
    pixelPeriod = pixelspersecond * Period
  end

  if synthSelector == 2 then 
    freq2 = freq2 + pd.getCrankTicks(60)
    if freq2 < 0 then freq2 = 0 end
    Period2 = 1/freq2
    pixelPeriod2 = pixelspersecond * Period2
  end


  -- play freq
  synth:playNote(freq)
  synth2:playNote(freq2)

  -- draw wave 
  gfx.clear()  
  gfx.drawSineWave(startX,startY,endX,endY, startAmplitude, endAmplitude, pixelPeriod, pixelPhaseShift)
  gfx.drawSineWave(startX,startY,endX,endY, startAmplitude, endAmplitude, pixelPeriod2, pixelPhaseShift)

  gfx.sprite.update()
  pd.timer.updateTimers()


end
