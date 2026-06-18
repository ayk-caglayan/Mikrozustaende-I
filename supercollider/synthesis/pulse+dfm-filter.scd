(
SynthDef(\pulser, {
	arg out=1, freq=40, amp=0.4, width_freq=0.4, width_mul=0.2, width_add=0.3, filter_freq=430, rq=1;
	var widt, ses, filt;
	widt=LFCub.ar(width_freq, 0, width_mul, width_add);
	ses=Pulse.ar(freq+20, widt, amp);
	filt=RLPF.ar(ses, filter_freq, rq, 0.5);
	Out.ar(out, filt);
}).add
)



p=Synth(\pulser,[\out, 2],~sig_generators)
p=Synth(\pulser, [\out, 2, \freq, "c"++(b[\fa1].index).asString], ~sig_generators);
p.free

i[\pulser1]=Synth(\pulser, [\out, a[\sig1], \freq, "c"++(b[\fa1].index).asString], ~sig_generators);
i[\pulser2]=Synth(\pulser, [\out, a[\sig2], \freq, "c"++(b[\fa2].index).asString], ~sig_generators);
i[\pulser3]=Synth(\pulser, [\out, a[\sig3], \freq, "c"++(b[\fa3].index).asString], ~sig_generators);
i[\pulser4]=Synth(\pulser, [\out, a[\sig4], \freq, "c"++(b[\fa4].index).asString], ~sig_generators);

i[\pulser1]=Synth(\pulser, [\out, 2, \freq, ~p_f.asList[0], \amp, ~p_a.asList[0]], ~sig_generators);
i[\pulser2]=Synth(\pulser, [\out, 2, \freq, ~p_f.asList[1], \amp, ~p_a.asList[1]], ~sig_generators);
i[\pulser3]=Synth(\pulser, [\out, 2, \freq, ~p_f.asList[2], \amp, ~p_a.asList[2]], ~sig_generators);
i[\pulser4]=Synth(\pulser, [\out, 2, \freq, ~p_f.asList[3], \amp, ~p_a.asList[3]], ~sig_generators);
i[\pulser5]=Synth(\pulser, [\out, 2, \freq, ~p_f.asList[4], \amp, ~p_a.asList[4]], ~sig_generators);
i[\pulser6]=Synth(\pulser, [\out, 2, \freq, ~p_f.asList[5], \amp, ~p_a.asList[5]], ~sig_generators);

i[\pulser1].set(\freq, ~p_f.asList[0])
i[\pulser1].set(\freq, ~p_f.asList[0])
i[\pulser1].set(\freq, ~p_f.asList[0])
i[\pulser1].set(\freq, ~p_f.asList[0])

s.sendMsg(\n_free, 1011)

// s.sendMsg("n_free", 1408)