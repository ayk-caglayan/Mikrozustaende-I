(
//osc messages coming from Pd-sigmund~ are written to freq&amp buses
OSCdef(\freq1, {arg msg; b[\freq1].set(msg[1])}, '/freq1');
OSCdef(\freq2, {arg msg; b[\freq2].set(msg[1])}, '/freq2');
OSCdef(\freq3, {arg msg; b[\freq3].set(msg[1])}, '/freq3');
OSCdef(\freq4, {arg msg; b[\freq4].set(msg[1])}, '/freq4');
OSCdef(\freq5, {arg msg; b[\freq5].set(msg[1])}, '/freq5');
OSCdef(\freq6, {arg msg; b[\freq6].set(msg[1])}, '/freq6');
OSCdef(\freq7, {arg msg; b[\freq7].set(msg[1])}, '/freq7');
OSCdef(\freq8, {arg msg; b[\freq8].set(msg[1])}, '/freq8');

OSCdef(\amp1, {arg msg; b[\amp1].set(msg[1])}, '/amp1');
OSCdef(\amp2, {arg msg; b[\amp2].set(msg[1])}, '/amp2');
OSCdef(\amp3, {arg msg; b[\amp3].set(msg[1])}, '/amp3');
OSCdef(\amp4, {arg msg; b[\amp4].set(msg[1])}, '/amp4');
OSCdef(\amp5, {arg msg; b[\amp5].set(msg[1])}, '/amp5');
OSCdef(\amp6, {arg msg; b[\amp6].set(msg[1])}, '/amp6');
OSCdef(\amp7, {arg msg; b[\amp7].set(msg[1])}, '/amp7');
OSCdef(\amp8, {arg msg; b[\amp8].set(msg[1])}, '/amp8');

//pressing D4 updates the set by getting values from the buses
MIDIdef.noteOn(\test_get,
	{|val|
		~p_f=Set.new(8);
		~p_a=Set.new(8);
		8.do({|i| (("b[\\" ++ 'freq' ++i.asString++']').interpret).get({|v| ~p_f.add(v)})});
		8.do({|i| (("b[\\" ++ 'amp' ++i.asString++']').interpret).get({|v| ~p_a.add(v)})});
},50);

//pressing E4 updates synts with new freq - amp values
MIDIdef.noteOn(\test_update,
	{|val|
		///!! that one frees node and reassigns them ++++++///
		~p_f.do({arg fre, am; var sym="\\" ++ 'pulser' ++am.asString;i[sym.interpret].free; i[sym.interpret]=Synth(\pulser, [\out, rand(2), \freq, fre, \amp, ~p_a.asList[am], \filter_freq, 300+500.rand], ~sig_generators)});

},52);

//F4 cleans all running pulser synths
MIDIdef.noteOn(\test_clean,
	{|val|
		~p_f.do({arg fre, am; var sym="\\" ++ 'pulser' ++am.asString;i[sym.interpret].free;})
},53);


)

//!! THAT ONE IS WORKING !!! ///
~p_f.do({arg fre, am; var sym="\\" ++ 'pulser' ++am.asString; (i[sym.interpret]).postln});

///!! that one frees node and reassigns them ++++++///
~p_f.do({arg fre, am; var sym="\\" ++ 'pulser' ++am.asString;i[sym.interpret].free; i[sym.interpret]=Synth(\pulser, [\out, rand(2), \freq, fre, \amp, ~p_a.asList[am], \filter_freq, 100+1000.rand], ~sig_generators)});


//TO CLEAR ACTIVATED SYNTHs///
~p_f.do({arg fre, am; var sym="\\" ++ 'pulser' ++am.asString;i[sym.interpret].free;})

// 7.do({arg i; s.sendMsg(\n_free, 1079+i)})



