MIDIClient.init;
MIDIIn.connectAll;

(
var granular_DX, pos_range, posRateE, posRateM,trigRate,overlap, rate, panMax,bpLo, bpHi,bpRQ, amp, k1, k2, k3, k4, k5, k6, k7, k8, k9, k10, k11;
var pos_spec, posRateE_spec, posRateM_spec, trigRate_spec, overlap_spec, rate_spec, panMax_spec, bpLo_spec, bpHi_spec, bpRQ_spec, amp_spec;
pos_spec=ControlSpec(0,1,\lin, 0.001);
posRateE_spec=ControlSpec(-3, 4, \lin, 1, -1);
posRateM_spec= ControlSpec(0.1, 10, \exp, 0.01, 1.35);
trigRate_spec= ControlSpec(1, 200, \lin, 0.01, 90);
overlap_spec= ControlSpec(0.2, 12, \lin, 0.01, 7);
rate_spec=ControlSpec(0.25, 2, \lin, 0.25, 1);
panMax_spec=ControlSpec(0.0, 1, \lin, 0.005, 0.75);
bpLo_spec=ControlSpec(50, 5000, \lin, 0, 300);
bpHi_spec=ControlSpec(100, 5000, \lin, 0, 3000);
bpRQ_spec=ControlSpec(0.05, 1, \lin, 0, 0.18);
amp_spec=ControlSpec(0.05, 0.99, \lin, 0, 0.48);

granular_DX=Window.new(\granular).front;
granular_DX.layout=VLayout(*[
	HLayout(*[ pos_range=RangeSlider(granular_DX).orientation_(\horizontal).action_({k1.value_(pos_spec.map(pos_range.lo.value));k2.value_(pos_range.hi)}), k1=NumberBox(granular_DX, Rect(0,0, 50,30)).minSize_(Size(45,25)).maxSize_(Size(50,30)),k2=NumberBox(granular_DX, Rect(0,0, 50,30)).minSize_(Size(45,25)).maxSize_(Size(50,30)), StaticText(granular_DX).string_("K1&2 pos_range")]),

	HLayout(*[ posRateE=Slider(granular_DX).orientation_(\horizontal).action_({k3.value_(posRateE_spec.map(posRateE.value))}), k3=NumberBox(granular_DX, Rect(0,0, 50,30)).minSize_(Size(45,25)).maxSize_(Size(50,30)), StaticText(granular_DX).string_("K3 posRateE")]),

	HLayout(*[ posRateM=Slider(granular_DX).orientation_(\horizontal).action_({k4.value_(posRateM_spec.map(posRateM.value))}), k4=NumberBox(granular_DX, Rect(0,0, 50,30)).minSize_(Size(45,25)).maxSize_(Size(50,30)),StaticText(granular_DX).string_("K4 posRateM")]),

	HLayout(*[ trigRate=Slider(granular_DX).orientation_(\horizontal).action_({k5.value_(trigRate_spec.map(trigRate.value))}), k5=NumberBox(granular_DX, Rect(0,0, 50,30)).minSize_(Size(45,25)).maxSize_(Size(50,30)),StaticText(granular_DX).string_("K5 trigRate")]),

	HLayout(*[ overlap=Slider(granular_DX).orientation_(\horizontal).action_({k6.value_(overlap_spec.map(overlap.value))}), k6=NumberBox(granular_DX, Rect(0,0, 50,30)).minSize_(Size(45,25)).maxSize_(Size(50,30)),StaticText(granular_DX).string_("K6 overlap")]),

	HLayout(*[ rate=Slider(granular_DX).orientation_(\horizontal).action_({k7.value_(rate_spec.map(rate.value))}), k7=NumberBox(granular_DX, Rect(0,0, 50,30)).minSize_(Size(45,25)).maxSize_(Size(50,30)),StaticText(granular_DX).string_("K7 rate")]),

	HLayout(*[ bpLo=Slider(granular_DX).orientation_(\horizontal).action_({k8.value_(bpLo_spec.map(bpLo.value))}), k8=NumberBox(granular_DX, Rect(0,0, 50,30)).minSize_(Size(45,25)).maxSize_(Size(50,30)),StaticText(granular_DX).string_("K9 bpLo")]),

	HLayout(*[ bpHi=Slider(granular_DX).orientation_(\horizontal).action_({k9.value_(bpHi_spec.map(bpHi.value))}), k9=NumberBox(granular_DX, Rect(0,0, 50,30)).minSize_(Size(45,25)).maxSize_(Size(50,30)),StaticText(granular_DX).string_("K10 bpHi")]),

	HLayout(*[ bpRQ=Slider(granular_DX).orientation_(\horizontal).action_({k10.value_(bpRQ_spec.map(bpRQ.value))}), k10=NumberBox(granular_DX, Rect(0,0, 50,30)).minSize_(Size(45,25)).maxSize_(Size(50,30)), StaticText(granular_DX).string_("K11 bpRQ")]),

	HLayout(*[ amp=Slider(granular_DX).orientation_(\horizontal).action_({k11.value_(amp_spec.map(amp.value))}), k11=NumberBox(granular_DX, Rect(0,0, 50,30)).minSize_(Size(45,25)).maxSize_(Size(50,30)), StaticText(granular_DX).string_("K8 amp")]),
]);

MIDIdef.cc(\range_lo, {arg ...args;var lo_gui, lo_synt; lo_gui=args[0].linlin(0,127,0,1); lo_synt=lo_gui; b[\knob1].set(lo_synt); {pos_range.lo=lo_gui; k1.value=lo_synt}.defer; }, 17, 0);//pos __ range
MIDIdef.cc(\range_hi, {arg ...args;var hi_gui, hi_synt;hi_gui=args[0].linlin(0,127,0,1); hi_synt=hi_gui; b[\knob2].set(hi_synt); {pos_range.hi=hi_gui; k2.value=hi_synt}.defer;}, 18, 0);

MIDIdef.cc(\posRateE, {arg ...args;var posRateE_gui, posRateE_synt; posRateE_synt=args[0].linlin(0,127,-3,4); posRateE_gui=posRateE_synt.linlin(-3,4,0,1); b[\knob3].set(posRateE_synt); {posRateE.value=posRateE_gui; k3.value=posRateE_synt}.defer}, 19, 0);

MIDIdef.cc(\posRateM, {arg ...args;var posRateM_gui, posRateM_synt; posRateM_synt=args[0].linlin(0,127,-3,4); posRateM_gui=posRateM_synt.linlin(-3,4, 0,1); b[\knob4].set(posRateM_synt); {posRateM.value=posRateM_gui; k4.value=posRateM_synt}.defer;}, 20, 0);

MIDIdef.cc(\trigRate, {arg ...args;var trt_gui, trt_synt; trt_synt=args[0].linexp(0,127,0.01,200); trt_gui=trt_synt.linlin(0.01, 200, 0,1); b[\knob5].set(trt_synt);{trigRate.value=trt_gui; k5.value=trt_synt}.defer}, 21, 0); //trigRate
MIDIdef.cc(\overlap, {arg ...args;var ovr_gui, ovr_synt; ovr_synt=args[0].linlin(0,127,0.01,20); ovr_gui=ovr_synt.linlin(0.01, 20, 0,1); b[\knob6].set(ovr_synt);{overlap.value=ovr_gui; k6.value=ovr_synt}.defer}, 22, 0); //overlap
MIDIdef.cc(\rate, {arg ...args;var rt_gui, rt_synt; rt_synt=args[0].linlin(0,127,0.25,2); rt_gui=rt_synt.linlin(0.25, 2, 0, 1); b[\knob7].set(rt_synt); {rate.value=rt_gui; k7.value=rt_synt}.defer}, 23, 0); //rate
MIDIdef.cc(\amp, {arg ...args; var ampp=args[0].linlin(0,127, 0,1); b[\knob8].set(ampp); {amp.value=ampp; k11.value=ampp}.defer}, 24,0);
MIDIdef.cc(\bp_lo, {arg ...args;var bpl_gui, bpl_synt; bpl_synt=args[0].linlin(0,127,50,5000); bpl_gui=bpl_synt.linlin(50,5000, 0,1); b[\knob9].set(bpl_synt); {bpLo.value=bpl_gui; k8.value=bpl_synt}.defer; }, 51, 0); //bpLo
MIDIdef.cc(\bp_hi, {arg ...args;var bph_gui, bph_synt; bph_synt=args[0].linlin(0,127,100,5000); bph_gui=bph_synt.linlin(100,5000, 0, 1); b[\knob10].set(bph_synt); {bpHi.value=bph_gui; k9.value=bph_synt}.defer}, 52, 0); //bpHi
MIDIdef.cc(\bp_rq, {arg ...args;var bpr_gui, bpr_synt; bpr_synt=args[0].linlin(0,127,0.05,1); bpr_gui=bpr_synt;{bpRQ.value=bpr_gui; b[\knob11].set(bpr_synt); k10.value=bpr_synt}.defer}, 53, 0); //bpRQ

MIDIdef.cc(\panx, {arg ...args;var panx=args[0].linlin(0,127,0.05,1); b[\knob12].set(panx)}, 54); //panX

MIDIdef.cc(\pany, {arg ...args;var pany=args[0].linlin(0,127,0.05,1); b[\knob13].set(pany)}, 55);

)

MIDIdef.freeAll