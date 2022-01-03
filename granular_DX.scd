// adapted from dkmayer/miSCellaneous_lib 'gran_1f' SynthDef
(
~maxOverlap = 12;
//a is audio bus dictionary
a[\gran_DX] = Bus.audio(s, ~maxOverlap);

// overlap only settable in SC versions >= 3.9

SynthDef(\gran_DX, { |out=2, soundBuf, posLo = 0.6, posHi = 0.9,
    posRateE = 0, posRateM = 1, overlap = 2, trigRate = 1, rate = 1,
    bpRQ = 0.1, bpLo = 50, bpHi = 5000, panX=0, panY=0, amp = 1|
    var sig, bpFreq, dUgen, bufDur, pos, posRate, playbuf, env, maxOverlap = ~maxOverlap, panx, pany, ch1,ch2,ch3,ch4, level1,level2,level3,level4;

    posRate = 10 ** posRateE * posRateM;
    bufDur = BufDur.kr(soundBuf);
    pos = Phasor.ar(0, BufRateScale.kr(soundBuf) * posRate * SampleDur.ir / bufDur, posLo, posHi);

    // multichannel trigger
    env = DXEnvFan.ar(
        Dseq((0..maxOverlap-1), inf),
        trigRate.reciprocal,
        size: maxOverlap,
        maxWidth: maxOverlap,
        width: (Main.versionAtLeast(3, 9)).if { overlap }{ 2 },
        // option to avoid unwanted triggers
        zeroThr: 0.002,
        // take equalPower = 0 for non-squared sine envelopes
        // more efficient with helper bus
        equalPower: 0,
		bus: a[\gran_DX]
    );
    // multichannel playback, pos is triggered for each grain
    playbuf = PlayBuf.ar(1, soundBuf, rate, env, pos * BufFrames.ir(soundBuf), 1);

    dUgen = Dwhite(0, 1);
    // multichannel trigger used to poll values from drate ugen
    bpFreq = Demand.ar(env, 0, dUgen).linlin(0, 1, bpLo, bpHi);

    // generate grains by multiplying with envelope
    sig = playbuf * env;

    // different frequency on each grain channel
    sig = BPF.ar(sig, bpFreq, bpRQ, (bpRQ ** -1) * (400 / bpFreq ** 0.5));
	sig=Mix(sig)*amp;

    // generate array of 5 stereo signals
	// sig = Pan2.ar(sig, Demand.ar(env, 0, Dseq([-1, 1], inf) * panMax));
	level1=Demand.ar(env, 0, Dwhite(0.01,0.75,inf) * panX);
	level2=Demand.ar(env, 0, Dwhite(0.01,0.75,inf) * panY);
	level3=Demand.ar(env, 0, Dwhite(0.01,0.75,inf) * panX);
	level4=Demand.ar(env, 0, Dwhite(0.01,0.75,inf) * panY);
	// pany=Demand.ar(env, 0, Dseq([-1,1], inf) * panY);
	ch1=sig*level1;
	ch2=sig*level2;
	ch3=sig*level3;
	ch4=sig*level4;
    // mix to out
	Out.ar(out, [ch1,ch2,ch3,ch4]);
}, metadata: (
    specs: (
        posLo: [0.01, 0.99, \lin, 0.01, 0],
        posHi: [0.01, 0.99, \lin, 0.01, 0.5],
        posRateE: [-3, 4, \lin, 1, -1],
        posRateM: [0.1, 10, \exp, 0.01, 1.35],
        trigRate: [1, 200, \lin, 0.01, 7],
        overlap: [0.2, 12, \lin, 0.01, 7],
        rate: [0.25, 2, \lin, 0.25, 1],
		// panMax: [0.0, 1, \lin, 0.005, 0.75],
        bpLo: [50, 5000, \lin, 0, 300],
        bpHi: [100, 5000, \lin, 0, 3000],
        bpRQ: [0.05, 1, \lin, 0, 0.18],
        amp: [0.0, 3, \lin, 0.005, 0.01],
		panX: [0.0, 1.0, \lin, 0.005, 0.5],
		panY: [0.0, 1.0, \lin, 0.005, 0.5],
    )
)).add;
)

(
\gran_DX.sVarGui([\soundBuf, f[\live1].bufnum]).gui(
    tryColumnNum: 1,
	// synthColorGroups: (0..12).clumps([1,4,2,1,3,1,1])
)
)

s.sendMsg(\n_map, 1025, [\trigRate, b[\knob5].index])

s.sendMsg(\n_free, 1009)
(
i[\grani]=Synth(\gran_DX,
	[
		\out, 2,
		\soundBuf, f[\live1].bufnum,
		\posLo, "c"++(b[\knob1].index).asString,
		\posHi, "c"++(b[\knob2].index).asString,
		\posRateE, "c"++(b[\knob3].index).asString,
		\posRateM,"c"++(b[\knob4].index).asString,
		\trigRate, "c"++(b[\knob5].index).asString,
		\overlap, "c"++(b[\knob6].index).asString,
		\rate, "c"++(b[\knob7].index).asString,
		\panMax, "c"++(b[\knob8].index).asString,
		\bpLo, "c"++(b[\knob9].index).asString,
		\bpHi, "c"++(b[\knob10].index).asString,
		\bpRQ, "c"++(b[\knob11].index).asString,
		\amp, "c"++(b[\knob8].index).asString,
		\panX, "c"++(b[\knob12].index).asString,
		\panY, "c"++(b[\knob13].index).asString
], ~sig_generators);
)
i[\grani].free
f[\live1].plot
/*
(
i[\grani].set(
		\out, 2,
		\soundBuf, f[\live1].bufnum,
		\posLo, "c"++(b[\knob1].index).asString,
		\posHi, "c"++(b[\knob2].index).asString,
		\posRateE, "c"++(b[\knob3].index).asString,
		\posRateM,"c"++(b[\knob4].index).asString,
		\trigRate, "c"++(b[\knob5].index).asString,
		\overlap, "c"++(b[\knob6].index).asString,
		\rate, "c"++(b[\knob7].index).asString,
		\panMax, "c"++(b[\knob8].index).asString,
		\bpLo, "c"++(b[\knob9].index).asString,
		\bpHi, "c"++(b[\knob10].index).asString,
		\bpRQ, "c"++(b[\knob11].index).asString,
		\amp, "c"++(b[\knob8].index).asString,
);
)

i[\grani]=Synth(\gran_DX, [\out, 2, \soundBuf, f[\live1].bufnum], ~sig_generators);
i[\grani].set(\out, 0)
g.free*/

s.sendMsg("n_free", 1006)

x.map(\x, b[\stick_x], \y, b[\stick_y])
x.free

