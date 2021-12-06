//basic excite & loop algorithm with real piano sound, it sharpens high frequencies

(
{
var freq,time, ex, delay, filter, local, piano;
	freq= 440;
	//freq=MouseX.kr(5, 1000)*LFNoise1.kr(5).range(0.5,2);
	time= freq.reciprocal;

	//ex= WhiteNoise.ar(EnvGen.kr(Env([1.0,1.0,0.0,0.0], [time,0,100]), Impulse.kr(1.2)));
	//ex=WhiteNoise.ar(Decay.ar(Impulse.ar(1))*0.5);
	piano=Buffer.read(s, "/Users/ike/samples/piano.wav");

	ex=PlayBuf.ar(1, piano.bufnum, MouseY.kr(-12,12), loop:1.0);
	//ex=SoundIn.ar(0);
	local= LocalIn.ar(1);

	filter= LPZ1.ar(ex+local); //apply filter


	delay= DelayN.ar(filter, time, time-ControlDur.ir);

	//ControlDur.ir.poll;

	LocalOut.ar(delay*0.95);
	Out.ar(0, Pan2.ar(filter,0.0));

}.play
)


//using triple CombL filter with detuning // great sound
(


x={
var piano, strike, noise, pitch, delayTime, detune;
	//strike = Impulse.ar(0.5);
	//env = Decay2.ar(strike, 0.008, 0.04);

	// piano=Buffer.read(s, "/Users/ike/samples/piano.wav");
	// strike=PlayBuf.ar(1, piano.bufnum, [1,3/5, 2/3], Impulse.kr(0.5), loop:1.0)*0.5;
	strike=SoundIn.ar(0);

	//pitch = (36 + 54.rand);
	// pitch=MouseY.kr(12, 82);
	pitch = Tartini.kr(strike);

	Out.ar(2, Pan2.ar(
		// array of 3 strings per note
		Mix.ar(Array.fill(3, { arg i;
			// detune strings, calculate delay time :
			detune = #[-0.05, 0, 0.04].at(i);
			// delayTime = 1 / (pitch + detune).midicps;
			delayTime=1/pitch;
			// each string gets own exciter :
			noise = LFNoise2.ar(MouseX.kr(20, 7000), strike); // 3000 Hz was chosen by ear..
			CombL.ar(noise,		// used as a string resonator
				delayTime, 		// max delay time
				delayTime,			// actual delay time
				6) 				// decay time of string
		})),
		0
		// (pitch - 36)/27 - 1 // pan position: lo notes left, hi notes right
	))

}.play;
)

x.free
s.sendMsg(\n_free, 1027)
//using Pluck ugen //
(
x={
	arg inn=0.0, trigg=1.0, maxdel=0.2, dell=0.2, decayt=1.0, coeff=0.5, mull=1.0;
	var freq, time, piano, sig;
	freq= MouseX.kr(20, 2000);
	time= freq.reciprocal;
	// piano=Buffer.read(s, "/Users/ike/samples/piano.wav");
	// sig=PlayBuf.ar(2, piano.bufnum, loop:1.0);
	sig=SoundIn.ar(0);
	sig=Pluck.ar(sig, trigg, maxdel, dell, decayt, coeff);
	Out.ar(2, sig!2);

}.play;

)

t=Bus.control(s, 1);
i={arg freq=1; Out.kr(t, Impulse.kr(freq))}.play;

i.set(\freq, 78)
a.set(\trigg, t.asMap)
a.set(\maxdel, 0.7, \dell, 0.25, \decayt, 0.2)
a.free;
i.free;