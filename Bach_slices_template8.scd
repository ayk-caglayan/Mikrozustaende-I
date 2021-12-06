ServerOptionsGui.new
s.memSize()
(
~micBus=Bus.audio(s,1);
~sinthBus1=Bus.audio(s,1);
~sinthBus2=Bus.audio(s,1);
~sinthBus3=Bus.audio(s,1);
~sinthBus4=Bus.audio(s,1);
~sinthBus5=Bus.audio(s,1);
~sinthBus6=Bus.audio(s,1);
~sinthBus7=Bus.audio(s,1);
~sinthBus8=Bus.audio(s,1);
~sinthBus9=Bus.audio(s,1);
)
(
~micGroup=Group.new;
~sinthGroup=Group.after(~micGroup);
~fxGroup=Group.after(~sinthGroup);
)
(
SynthDef("kal", {
	arg freq, dur;
	var sig, env;
	//dur = dur * playback_speed;
	env = EnvGen.kr(Env.perc(0.01, dur), doneAction:2);
	sig = SinOsc.ar(freq)*env;
	Out.ar(0, Pan2.ar(sig));
}).add;


SynthDef("proto", {arg out=0, freq=430, dur=1;
	var sig, excite, env,gate=1;
	excite=BrownNoise.ar(0.7);
	//env=EnvGen.ar(Env.asr(0.02, 0.7, dur), gate, doneAction:2);
	env=EnvGen.ar(Env.new([0,1,0], [0.05, dur]), levelScale:0.3, doneAction:2);
	sig=CombC.ar(excite*env, 0.2, 1/freq, dur).tanh;
	Out.ar(out, sig);
}).add;

SynthDef("rev", {arg in=0, out=0;
	var in_sig=In.ar(in), out_sig;
	out_sig=GVerb.ar(in_sig);
	DetectSilence.ar(out_sig, doneAction: 2);
	Out.ar(out, out_sig);
}).add;


)
//read
x=TabFileReader.readInterpret("/Users/aykutcaglayan/Library/Mobile Documents/com~apple~CloudDocs/Mikrozustände/bach_modules/all_modules.txt");



p=Synth("proto");

{CombC.ar([BrownNoise.ar()*Blip.ar(10), WhiteNoise.ar()*Blip.ar(7)], 0.1, LFNoise1.kr(MouseX.kr(1, 400)).range(0.0001, 0.002), 0.4)}.play;
x={Out.ar(2, Pluck.ar([Decay.ar(Blip.ar(1), 0.33, 0.6), Decay.ar(Blip.ar(2), 0.25, 0.7)], Dust.ar(7), 0.1, LFNoise1.kr(MouseX.kr(1, 100)).range(0.01, 0.1), 0.4))}.play;
x.free








(
//scales whole module to the time given//
~choral_4_voices_x_y_scaled={arg module_num=1, time_sum_s=1, pitch_space_min=65, pitch_space_max=1046, synthh="proto", out=0, main_out=0;
	var soprano, alto, tenor, bass, relative_scaler, dur_array=Array.new(100), time_sum_scaled;

	x.do{arg item;
		var mo, part_code, dur;
		mo=item[0];
		part_code=item[1];
		//hz=item[4];
		dur=item[5];
		if (module_num==mo && part_code==1, {
			//time_sum=time_sum+dur;
			dur_array=dur_array.add(dur);
	})};


	time_sum_scaled=dur_array.normalizeSum*time_sum_s;
	relative_scaler=dur_array[0]/time_sum_scaled[0];

	soprano=Routine.new({

		x.do{arg item;
			var mo, part_code, hz, dur;
			mo=item[0];
			part_code=item[1];
			//hz=item[4];
			hz=item[4].expexp(65, 1046, pitch_space_min, pitch_space_max);
			dur=item[5];
			dur=dur/relative_scaler;
			if (module_num==mo && part_code==1, {
				item.postln;
				Synth(synthh, [\out, out, \freq, hz, \dur, dur], ~sinthGroup);
				Synth(\rev, [\in, out, \out, main_out], ~fxGroup);
				dur.wait;});
	}});



	alto=Routine.new({
		x.do{arg item;
			var mo, part_code, hz, dur;
			mo=item[0];
			part_code=item[1];
			//hz=item[4];
			hz=item[4].expexp(65, 1046, pitch_space_min, pitch_space_max);
			dur=item[5];
			dur=dur/relative_scaler;
			if (module_num==mo && part_code==2, {
				item.postln;
				Synth(synthh, [\out, out, \freq, hz, \dur, dur], ~sinthGroup);
				Synth(\rev, [\in, out, \out, main_out], ~fxGroup);
				dur.wait;})
	}});

	tenor=Routine.new({
		x.do{arg item;
			var mo, part_code, hz, dur;
			mo=item[0];
			part_code=item[1];
			//hz=item[4];
			hz=item[4].expexp(65, 1046, pitch_space_min, pitch_space_max);
			dur=item[5];
			dur=dur/relative_scaler;
			if (module_num==mo && part_code==3, {
				item.postln;
				Synth(synthh, [\out, out, \freq, hz, \dur, dur], ~sinthGroup);
				Synth(\rev, [\in, out, \out, main_out], ~fxGroup);
				dur.wait;})
	}});

	bass=Routine.new({
		x.do{arg item;
			var mo, part_code, hz, dur;
			mo=item[0];
			part_code=item[1];
			//hz=item[4];
			hz=item[4].expexp(65, 1046, pitch_space_min, pitch_space_max);
			dur=item[5];
			dur=dur/relative_scaler;
			if (module_num==mo && part_code==4, {
				item.postln;
				Synth(synthh, [\out, out, \freq, hz, \dur, dur], ~sinthGroup);
				Synth("rev", [\in, out, \out, main_out], ~fxGroup);
				dur.wait;})
	}});

	soprano.play;
	alto.play;
	tenor.play;
	bass.play;

}
)
(

~choral_4_voices_x_y_scaled.value(module_num:175, time_sum_s:6.4, pitch_space_min:200, pitch_space_max:560, out:~sinthBus1, synthh: "kal");
~choral_4_voices_x_y_scaled.value(module_num:176, time_sum_s:6.4, pitch_space_min:150, pitch_space_max:300, out:~sinthBus2);//, synthh: "kal");
~choral_4_voices_x_y_scaled.value(module_num:177, time_sum_s:6.4, pitch_space_min:50, pitch_space_max:300, out:~sinthBus3);//, synthh: "kal");
)
(
~choral_4_voices_time_scaled.value(module_num:1278, time_sum_s:4, synthh: "kal");
~choral_4_voices_time_scaled.value(module_num:975, time_sum_s:4, synthh: "kal");
~choral_4_voices_time_scaled.value(module_num:178, time_sum_s:4, synthh: "kal");

)
(
Routine.new({
	~choral_4_voices_x_y_scaled.value(module_num:174, time_sum_s:2.4, pitch_space_min:400, pitch_space_max:1060, synthh: "kal");
	0.1.wait;
	~choral_4_voices_x_y_scaled.value(module_num:175, time_sum_s:2.4, pitch_space_min:300, pitch_space_max:900, synthh: "kal");
	0.1.wait;
	~choral_4_voices_x_y_scaled.value(module_num:176, time_sum_s:2.4, pitch_space_min:50, pitch_space_max:250, synthh: "kal");
	0.1.wait;

}).play;
)

(
~choral_4_voices_x_y_scaled.value(module_num:175, time_sum_s:4.4, pitch_space_min:2000, pitch_space_max:4000, synthh: "kal");
~choral_4_voices_x_y_scaled.value(module_num:1075, time_sum_s:4.4, pitch_space_min:1100, pitch_space_max:2000, synthh: "kal");
~choral_4_voices_x_y_scaled.value(module_num:276, time_sum_s:4.4, pitch_space_min:800, pitch_space_max:1100, synthh: "kal");
~choral_4_voices_x_y_scaled.value(module_num:977, time_sum_s:4.4, pitch_space_min:400, pitch_space_max:800, synthh: "kal");
~choral_4_voices_x_y_scaled.value(module_num:1278, time_sum_s:4.4, pitch_space_min:150, pitch_space_max:500, synthh: "kal");
~choral_4_voices_x_y_scaled.value(module_num:1679, time_sum_s:4.4, pitch_space_min:50, pitch_space_max:150, synthh: "kal");
)


(
~module_arr=Array.fill(12, {arg i; Array.new(300)});
)


(
var prev_ind=0;
x.do{arg item;
	var indexx, key1, act_ind=0, part_code=1;
	key1=item[6];
	part_code=item[1];
	act_ind=item[0];
	//("bas " ++ prev_ind).postln;


	if (act_ind>prev_ind, {
		//dur_array=dur_array.add(dur);
		("act_ind " ++ act_ind) ++ " key  " ++ key1.postln;

		//~module_dic['\' ++ ' ]=~module_dic[key1].add(act_ind);
		~module_arr[key1]=~module_arr[key1].add(act_ind);
	});

	prev_ind=item[0];
};
)
(
r=Array.new(12);
~module_arr.do{arg item;
	item.size.postln;
	r.add(item.size);
};
r.sum.postln;
)

~module_arr[4].do{arg i;
	i.postln;
}

//trigger with midi note-in

/*
OSCFunc.trace
{SoundIn.ar(0)}.play

{Saw.ar(Tartini.kr(SoundIn.ar(0)), Select.ar(Amplitude.ar(SoundIn.ar(0)>0.5), [K2A.ar(0.6), K2A.ar(0)]))}.play
(
SynthDef("track", {arg out_bus;
	var inn, amp, pit, out;
	inn=SoundIn.ar(0);
	amp=Amplitude.kr(inn);
	pit=Tartini.kr(inn);
	SendTrig.kr(amp > 0.3, 12, pit);
	//Out.kr(out_bus, pit)
	}).add;

o=OSCFunc({arg msg, time;
	//[time, msg].postln;
	msg[3].cpsmidi.postln;
}, '/tr', s.addr);
)

t=Synth("track")
*/

~module_arr[0].choose
[554.3, 415.3, 277.1, 174.6].ratiomidi.midiname

63.mod(12)

(
var notes, on, off;

MIDIClient.init;
MIDIIn.connectAll;

notes = Array.newClear(128);    // array has one slot per possible MIDI note

on = MIDIFunc.noteOn({ |veloc, num, chan, src|
   // notes[num] = Synth(\default, [\freq, num.midicps,
   //     \amp, veloc * 0.00315]);
	num.postln;

	~choral_4_voices_time_scaled.value(module_num:~module_arr[num.mod(12)].choose, time_sum_s: veloc.linlin(0,127, 4, 0.25), synthh: "proto");

});

off = MIDIFunc.noteOff({ |veloc, num, chan, src|
    //notes[num].release;
});

q = { on.free; off.free; };
)
q.value;