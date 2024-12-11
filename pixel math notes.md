notes on pixel math
the drawSineWave function uses pixels, not frequency
so I need to translate frequency to pixels
for now, leave startXY and endXY as hardcoded.
For sound amplitude represents volume. I can play with that later. 
Volume goes from 0 to 1; Amplitude should be a relative thing when I start stacking sine waves

period: T = 1/f; interval between oscilations in seconds; need to translate this to pixels
period in pixels = (pixels per second) * T


phase shift: I'll need to translate this from degrees/radians to pixels
phi is the phase and specifies (in radians) where in its cycle the oscillation is at t = 0.
When phi is non-zero, the entire waveform appears to be shifted backwards in time by the amount
phi / omega seconds.  A negative value represents a delay, and a positive value represents an advance.
omega = angular frequency and is measured in radians
omega = 2*pi*f, where f is the frequency in oscilations per second
phaseShift in pixels = (pixels per second) * phi / omega
= (pixels per second) * phi/2pi * 1/f
= (pixels per second) * (% of cycle in degrees or rads) * T