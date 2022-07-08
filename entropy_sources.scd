(
//pulsates with an enveloped entropy// by default oscillates between -1 & +1

SynthDef(\entropy_pulse, {arg out=1, env_len=1, val_freq=10, range=1, center_val=0;
	var impulse, attack, release, env, noise;
	// dur=freq.reciprocal;
	attack=env_len*0.9;
	release=env_len*0.1;
	impulse=Impulse.kr(1/env_len);
	env=Linen.kr(impulse, attack, range, release);
	// noise=WhiteNoise.kr();
	noise=LFDNoise2.kr(val_freq, env, center_val);
	Out.kr(out, noise);
}).add;

//has a center value, range of wiggling (as a fraction of center value), gate on-off for set in and out.
SynthDef(\entropy_flow, {arg out=1, val_freq=10, range=1, center_val=0;
	var noise;
	noise=LFDNoise2.kr(val_freq, range, center_val);
	Out.kr(out, noise);
}).add;



SynthDef(\simple, {arg out=0, freq=430, amp=0.2;
	var sig;
	sig=SinOsc.ar(freq, 0, amp);
	Out.ar(out, sig!2);
}).add;
)

e=Synth(\entropy_pulse, [\out,1, \env_len, 2, \range, 100], ~entropy_sources);
e.set(\range, 200, \center_val, 300, \env_len, 5, \val_freq, 50)
f=Synth(\entropy_pulse, [\out, 2, \env_len, 5, \range, 0.4, \center_val, 0.4], ~entropy_sources)
f.set(\center_val, 0.2, \range, 0.19)
x=Synth(\simple, [\out, 2, \freq, "c1"], ~sig_generators);
x.set(\freq, "c1"+400, \amp, "c2")

e.free
x.free
s.sendMsg("n_free", 1242)
x={In.kr(1)}.plot(4)
// i[\simple6].free
i[\simple4].free
//when mapping a bus to a synth: \out accepts index number, other parameter accepts "c"++index_number (-> functions as 'asMap')

i[\simple1]=Synth(\simple, [\amp, "c"++(b[\fa1].index+1).asString, \freq, "c"++b[\fa1].index, \out, a[\sig1].index], ~sig_generators);
i[\simple2]=Synth(\simple, [\amp, "c"++(b[\fa2].index+1).asString, \freq, "c"++b[\fa2].index, \out, a[\sig2].index], ~sig_generators);
i[\simple3]=Synth(\simple, [\amp, "c"++(b[\fa3].index+1).asString, \freq, "c"++b[\fa3].index, \out, a[\sig3].index], ~sig_generators);
i[\simple4]=Synth(\simple, [\amp, "c"++(b[\fa1].index+1).asString, \freq, "c"++b[\fa1].index, \out, a[\sig4].index], ~sig_generators);
i[\simple5]=Synth(\simple, [\amp, "c"++(b[\fa1].index+1).asString, \freq, "c"++b[\fa1].index, \out, a[\sig5].index], ~sig_generators);
i[\simple6]=Synth(\simple, [\amp, "c"++(b[\fa1].index+1).asString, \freq, "c"++b[\fa1].index, \out, a[\sig6].index], ~sig_generators);


i[\entropyf1]=Synth(\entropy_flow, [\out, b[\fa1].index, \center_val, "c"++(b[\knob1].index).asString, \range, 100], ~entropy_sources); //freq1
i[\entropya1]=Synth(\entropy_flow, [\out, b[\fa1].index+1, \center_val, 0.3, \range, 0.2], ~entropy_sources); //amp1


i[\entropyf2]=Synth(\entropy_flow, [\out, b[\fa2].index, \center_val, "c"++(b[\knob2].index).asString, \range, 100], ~entropy_sources); //freq2
i[\entropya2]=Synth(\entropy_flow, [\out, b[\fa2].index+1, \center_val, 0.3, \range, 0.18], ~entropy_sources); //amp2

i[\entropyf3]=Synth(\entropy_flow, [\out, b[\fa3].index, \center_val, "c"++(b[\knob3].index).asString, \range, 100], ~entropy_sources); //freq3
i[\entropya3]=Synth(\entropy_flow, [\out, b[\fa3].index+1, \center_val, 0.3, \range, 0.2], ~entropy_sources); //amp3

i[\entropyf4]=Synth(\entropy_flow, [\out, b[\fa4].index, \center_val, "c"++(b[\knob4].index).asString, \range, 100], ~entropy_sources); //freq4
i[\entropya4]=Synth(\entropy_flow, [\out, b[\fa4].index+1, \center_val, 0.3, \range, 0.2], ~entropy_sources); //amp4

i[\entropyf5]=Synth(\entropy_flow, [\out, b[\fa5].index, \center_val, "c"++(b[\knob5].index).asString, \range, 100], ~entropy_sources); //freq5
i[\entropya5]=Synth(\entropy_flow, [\out, b[\fa5].index+1, \center_val, 0.3, \range, 0.2], ~entropy_sources); //amp5

i[\entropyf6]=Synth(\entropy_flow, [\out, b[\fa6].index, \center_val, "c"++(b[\knob6].index).asString, \range, 100], ~entropy_sources); //freq6
i[\entropya6]=Synth(\entropy_flow, [\out, b[\fa6].index+1, \center_val, 0.3, \range, 0.2], ~entropy_sources); //amp6

i[\entropyf1]=Synth(\entropy_pulse, [\out, b[\fa1].index, \center_val, "c"++(b[\knob1].index).asString, \range, 100], ~entropy_sources); //freq1
i[\entropya1]=Synth(\entropy_pulse, [\out, b[\fa1].index+1, \center_val, 0.3, \range, 0.2], ~entropy_sources); //amp1


i[\entropyf2]=Synth(\entropy_pulse, [\out, b[\fa2].index, \center_val, "c"++(b[\knob2].index).asString, \range, 100], ~entropy_sources); //freq2
i[\entropya2]=Synth(\entropy_pulse, [\out, b[\fa2].index+1, \center_val, 0.3, \range, 0.18], ~entropy_sources); //amp2

i[\entropyf3]=Synth(\entropy_pulse, [\out, b[\fa3].index, \center_val, "c"++(b[\knob3].index).asString, \range, 100], ~entropy_sources); //freq3
i[\entropya3]=Synth(\entropy_pulse, [\out, b[\fa3].index+1, \center_val, 0.3, \range, 0.2], ~entropy_sources); //amp3

i[\entropyf4]=Synth(\entropy_pulse, [\out, b[\fa4].index, \center_val, "c"++(b[\knob4].index).asString, \range, 100], ~entropy_sources); //freq4
i[\entropya4]=Synth(\entropy_pulse, [\out, b[\fa4].index+1, \center_val, 0.3, \range, 0.2], ~entropy_sources); //amp4

i[\entropyf5]=Synth(\entropy_pulse, [\out, b[\fa5].index, \center_val, "c"++(b[\knob5].index).asString, \range, 100], ~entropy_sources); //freq5
i[\entropya5]=Synth(\entropy_pulse, [\out, b[\fa5].index+1, \center_val, 0.3, \range, 0.2], ~entropy_sources); //amp5

i[\entropyf6]=Synth(\entropy_pulse, [\out, b[\fa6].index, \center_val, "c"++(b[\knob6].index).asString, \range, 100], ~entropy_sources); //freq6
i[\entropya6]=Synth(\entropy_pulse, [\out, b[\fa6].index+1, \center_val, 0.3, \range, 0.2], ~entropy_sources); //amp6

//!!! frees all nodes in the array !!!//
[i[\entropyf1],i[\entropya1],i[\entropyf2],i[\entropya2],i[\entropyf3],i[\entropya3],i[\entropyf4],i[\entropya4],i[\entropyf5],i[\entropya5],i[\entropyf6],i[\entropya6]].do({arg i; i.free});

i[\entropy_numharm1]=Synth(\entropy_flow, [\out, b[\num1].index, \center_val, 80, \range, 40], ~entropy_sources);
i[\entropy_numharm2]=Synth(\entropy_flow, [\out, b[\num2].index, \center_val, 80, \range, 40], ~entropy_sources);
i[\entropy_numharm3]=Synth(\entropy_flow, [\out, b[\num3].index, \center_val, 80, \range, 40], ~entropy_sources);
i[\entropy_numharm4]=Synth(\entropy_flow, [\out, b[\num4].index, \center_val, 80, \range, 40], ~entropy_sources);
i[\entropy_numharm5]=Synth(\entropy_flow, [\out, b[\num5].index, \center_val, 80, \range, 40], ~entropy_sources);
i[\entropy_numharm6]=Synth(\entropy_flow, [\out, b[\num6].index, \center_val, 80, \range, 40], ~entropy_sources);


[i[\entropy_numharm1],i[\entropy_numharm2],i[\entropy_numharm3],i[\entropy_numharm4],i[\entropy_numharm5],i[\entropy_numharm6]].do({arg i; i.free});
i[\entropy_numharm6].set(\val_freq, 1)

i[\entropy10]=Synth(\entropy_pulse, [\out, b[\fa1].index, \env_len, 4, \max_level, 400, \val_freq, 10 ],~entropy_sources); //freq0
i[\entropy11]=Synth(\entropy_pulse, [\out, b[\fa1].index+1, \env_len, 4, \max_level, 1, \val_freq, 10 ],~entropy_sources); //amp0

i[\entropy6].set(\center_val, "c"++(b[\knob4].index).asString, \range, 2);
i[\entropy3].set(\out, "c3",\center_val, 2, \range, 0.2);
i[\entropy5].set(\center_val, 0.3, \range, 0.2);

i[\entropy1].free

i[\entropy11].set(\max_level, 1, \env_len, 6)

s.sendMsg("n_free", 1013)

i[\entropy_env1]=Synth(\bus_update_env, [\out, b[\fa1].index, \env, Env([10, 1],[5])], ~entropy_sources);
i[\entropy_env2]=Synth(\bus_update_env, [\out, b[\fa2].index, \env, Env([5, 1],[5])], ~entropy_sources);
i[\entropy_env3]=Synth(\bus_update_env, [\out, b[\fa3].index, \env, Env([4, 1],[5])], ~entropy_sources);
i[\entropy_env4]=Synth(\bus_update_env, [\out, b[\fa4].index, \env, Env([1, 1],[5])], ~entropy_sources);
i[\entropy_env5]=Synth(\bus_update_env, [\out, b[\fa5].index, \env, Env([8, 1],[5])], ~entropy_sources);
i[\entropy_env6]=Synth(\bus_update_env, [\out, b[\fa6].index, \env, Env([0, 1],[5])], ~entropy_sources);

[i[\entropy_env1],i[\entropy_env2],i[\entropy_env3],i[\entropy_env4],i[\entropy_env5],i[\entropy_env6]].do({arg l;
	l=Synth(\bus_update_env, [], ~entropy_sources);
});

~m={Out.ar(2, Mix.ar([In.ar(a[\sig1].index), In.ar(a[\sig2].index),In.ar(a[\sig3].index),In.ar(a[\sig4].index),In.ar(a[\sig5].index),In.ar(a[\sig6].index)]))}.play(target: ~effects);
~m.free;





