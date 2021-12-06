SynthDef(\marimba, {arg out=0, amp=0.06, t_trig=1, freq=100, rq=0.006;// b1=1.987 * 0.9889999999 * cos(0.09), b2=0.998057.neg;
    var env, signal;
    var rho, theta, b1, b2;
    b1 = 1.987 * 0.9889999999 * cos(0.09);
    b2 = 0.998057.neg;
    signal = SOS.ar(K2A.ar(t_trig), 0.3, 0.0, 0.0, b1, b2);
    signal = RHPF.ar(signal*0.8, freq, rq) + DelayC.ar(RHPF.ar(signal*0.9, freq*0.99999, rq*0.999), 0.02, 0.01223);
    signal = Decay2.ar(signal, 0.4, 0.3, signal);
    DetectSilence.ar(signal, 0.01, doneAction:2);
    Out.ar(out, signal*(amp*0.2));
}).add;

Pbindef(\a,
    \instrument, \marimba,
	\midinote, Prand([[1,5], [1,2], [3, 5, 6], [2,7], [2,9], 3], inf) + 48,
	\rq, Pwhite(0.001, 0.002),
    \dur, 1,
	\out, 2
).play;
s.makeGui

x=Synth(\marimba, [\out, 2, \amp, 0.05], ~sig_generators)
x.free
Pbindef(\a).free
s.meter

Tdef(\m, { loop {
	s.sendBundle(0.2, ["/s_new","wood", -1,0,0,
		\out, [2,3].choose,
		// \type, [0,1,2].choose,
		\amp, Pwhite(0.01, 0.09),
		// \freqLo, 800,
		// \freqHi, 1600,
		\freq, Pwhite(200, 600),
	]
	);
	[0.1, 0.5,0.2,0.8].choose.wait;
}}).play;

TdefAllGui.new
// Or perhaps
SynthDef(\wood, {arg out=0, amp=0.3, pan=0, sustain=0.5, t_trig=1, freq=100, rq=0.06;
    var env, signal;
    var rho, theta, b1, b2;
    b1 = 2.0 * 0.97576 * cos(0.161447);
    b2 = 0.9757.squared.neg;
    signal = SOS.ar(K2A.ar(t_trig), 1.0, 0.0, 0.0, b1, b2);
    signal = Decay2.ar(signal, 0.4, 0.8, signal);
    signal = Limiter.ar(Resonz.ar(signal, freq, rq*0.5), 0.9);
    env = EnvGen.kr(Env.perc(0.00001, sustain, amp), doneAction:2);
    Out.ar(out, Pan2.ar(signal, pan)*env);
}).add;

Pbind(
    \instrument, \wood,
    \midinote, Prand([[1,5], 2, [3, 5], 7, 9, 3], inf) + 48,
    \dur, 0.2
).play;

{var b1, b2;
	b1 = 1.987 * 0.9889999999 * cos(0.09);
    b2 = 0.998057.neg;SOS.ar(K2A.ar(1), 0.3, 0.0, 0.0, b1, b2);
}.plot(1);