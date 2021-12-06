
//records live input to a buffer
(
SynthDef(\record2buffer, {arg in_bus=0, bufnumm=0, on_off=0, overdub_rate=0, loop_on=1;
	var in_sig=SoundIn.ar(in_bus);
	RecordBuf.ar(in_sig, bufnumm, 0, 1, overdub_rate, on_off, loop_on);
}).add;
)
(
f[\live1]=Buffer.alloc(s, s.sampleRate*5.0, 1); //allocates buffer
i[\buf_recorder]=Synth.new(\record2buffer, [\bufnumm, f[\live1].bufnum], ~machine_listening);

MIDIdef.noteOn(\rec_on, {i[\buf_recorder].set(\on_off, 1, \overdub_rate, 0); "rec_on".postln}, 48); //records new
MIDIdef.noteOn(\overdub, {i[\buf_recorder].set(\on_off, 1, \overdub_rate, 1); "overdub_on".postln}, 49); //rec overdub
MIDIdef.noteOff(\rec_off, {i[\buf_recorder].set(\on_off, 0); "rec_off".postln}, 48);
MIDIdef.noteOff(\overdub_off, {i[\buf_recorder].set(\on_off, 0); "overdub_off".postln}, 49);

)
i[\recorder].set(\on_off, 1, \overdub_rate, 0) //on
i[\recorder].set(\on_off, 0)

s.sendMsg(\n_free, 1006);