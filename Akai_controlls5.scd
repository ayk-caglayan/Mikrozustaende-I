MIDIClient.init;
MIDIIn.connectAll;

MIDIIn.disconnectAll
MIDIIn.connect(1,1);
MIDIIn.connect(2,2);

(
var akai, joy, pad1, pad2, pad3, pad4, pad5, pad6, pad7, pad8, k1,k2,k3,k4,k5,k6,k7,k8, box1, box2, box3, box4, box5, box6, box7, box8, box9, box10, box11, box12, box13, box14, box15, box16;
var pad1t, pad2t, pad3t, pad4t, pad5t, pad6t, pad7t, pad8t, k1t, k2t, k3t, k4t, k5t, k6t, k7t, k8t;
~checkedA1=false; ~checkedA2=false; ~checkedA3=false; ~checkedA4=false; ~checkedA5=false; ~checkedA6=false;~checkedA7=false; ~checkedA8=false; ~checkedB1=false; ~checkedB2=false; ~checkedB3=false; ~checkedB4=false; ~checkedB5=false; ~checkedB6=false;~checkedB7=false; ~checkedB8=false;

akai=Window.new("microstates").front;
akai.layout=HLayout(*[
	//joystick
	joy=Slider2D(akai, Rect(10,10,80,80)).maxSize_(Size(70,70)).minSize_(Size(60,60)),
	//pads
	VLayout(*[pad1t=StaticText(akai), pad1=Slider(akai).action_({pad1t.string_(pad1.value.linlin(0,1,0,127).asInteger)}).step_(0.01), StaticText(akai).string_("pad1"), box1=CheckBox(akai).string_("A1"),box9=CheckBox(akai).string_("B1")]),
	VLayout(*[pad2t=StaticText(akai), pad2=Slider(akai).action_({pad2t.string_(pad2.value.linlin(0,1,0,127).asInteger)}).step_(0.01), StaticText(akai).string_("pad2"), box2=CheckBox(akai).string_("A2"), box10=CheckBox(akai).string_("B2")]),
	VLayout(*[pad3t=StaticText(akai), pad3=Slider(akai).action_({pad3t.string_(pad3.value.linlin(0,1,0,127).asInteger)}).step_(0.01), StaticText(akai).string_("pad3"), box3=CheckBox(akai).string_("A3"), box11=CheckBox(akai).string_("B3")]),
	VLayout(*[pad4t=StaticText(akai), pad4=Slider(akai).action_({pad4t.string_(pad4.value.linlin(0,1,0,127).asInteger)}).step_(0.01), StaticText(akai).string_("pad4"), box4=CheckBox(akai).string_("A4"), box12=CheckBox(akai).string_("B4")]),
	VLayout(*[pad5t=StaticText(akai), pad5=Slider(akai).action_({pad5t.string_(pad5.value.linlin(0,1,0,127).asInteger)}).step_(0.01), StaticText(akai).string_("pad5"), box5=CheckBox(akai).string_("A5"), box13=CheckBox(akai).string_("B5")]),
	VLayout(*[pad6t=StaticText(akai), pad6=Slider(akai).action_({pad6t.string_(pad6.value.linlin(0,1,0,127).asInteger)}).step_(0.01), StaticText(akai).string_("pad6"), box6=CheckBox(akai).string_("A6"), box14=CheckBox(akai).string_("B6")]),
	VLayout(*[pad7t=StaticText(akai), pad7=Slider(akai).action_({pad7t.string_(pad7.value.linlin(0,1,0,127).asInteger)}).step_(0.01), StaticText(akai).string_("pad7"), box7=CheckBox(akai).string_("A7"), box15=CheckBox(akai).string_("B7")]),
	VLayout(*[pad8t=StaticText(akai), pad8=Slider(akai).action_({pad8t.string_(pad8.value.linlin(0,1,0,127).asInteger)}).step_(0.01), StaticText(akai).string_("pad8"), box8=CheckBox(akai).string_("A8"), box16=CheckBox(akai).string_("B8")]),

	//knobs
	VLayout(*[k1=NumberBox(akai, Rect(0,0, 50,30)).value_(20).minSize_(Size(45,25)).maxSize_(Size(50,30)).step_(1).action_({arg val; b[\knob1].set(val.value)}), k5=NumberBox(akai, Rect(0,0, 50,30)).value_(20).minSize_(Size(45,25)).maxSize_(Size(50,30)).step_(1).action_({arg val; b[\knob5].set(val.value)})]),
	VLayout(*[k2=NumberBox(akai, Rect(0,0, 50,30)).value_(20).minSize_(Size(45,25)).maxSize_(Size(50,30)).step_(1).action_({arg val; b[\knob2].set(val.value)}), k6=NumberBox(akai, Rect(0,0, 50,30)).value_(20).minSize_(Size(45,25)).maxSize_(Size(50,30)).step_(1).action_({arg val; b[\knob6].set(val.value)})]),
	VLayout(*[k3=NumberBox(akai, Rect(0,0, 50,30)).value_(20).minSize_(Size(45,25)).maxSize_(Size(50,30)).step_(1).action_({arg val; b[\knob3].set(val.value)}), k7=NumberBox(akai, Rect(0,0, 50,30)).value_(20).minSize_(Size(45,25)).maxSize_(Size(50,30)).step_(1).action_({arg val; b[\knob7].set(val.value)})]),
	VLayout(*[k4=NumberBox(akai, Rect(0,0, 50,30)).value_(20).minSize_(Size(45,25)).maxSize_(Size(50,30)).step_(1).action_({arg val; b[\knob4].set(val.value)}), k8=NumberBox(akai, Rect(0,0, 50,30)).value_(20).minSize_(Size(45,25)).maxSize_(Size(50,30)).step_(1).action_({arg val; b[\knob8].set(val.value)})])
]);
m=Dictionary.new ;//holds MIDIdef's
// m[\absolut1]
//Slider2d
MIDIFunc.cc({|val| b[\stick_x_plus].set(val); {joy.x=val.linlin(0,127, 0.5, 1)}.defer}, 81, 0);
MIDIFunc.cc({|val| b[\stick_x_minus].set(val); {joy.x=val.linlin(0,127, 0.5, 0)}.defer}, 80, 0);
MIDIFunc.cc({|val| b[\stick_y_plus].set(val); {joy.y=val.linlin(0,127, 0.5, 1)}.defer}, 82, 0);
MIDIFunc.cc({|val| b[\stick_y_minus].set(val); {joy.y=val.linlin(0,127, 0.5, 0)}.defer}, 83, 0);

MIDIFunc.cc({|val| b[\stick_x].set(val); {joy.x=val.linlin(0,127, 0, 1)}.defer}, 90, 0);
MIDIFunc.cc({|val| b[\stick_y].set(val); {joy.y=val.linlin(0,127, 0, 1)}.defer}, 91, 0);


//pads
MIDIFunc.polytouch({|val| var spe; spe=val.linlin(0,127, 0, 1); b[\pad1].set(spe); {pad1.value=spe.round(0.01); pad1t.string=val.asString}.defer}, 0, 9);
MIDIFunc.polytouch({|val| var spe; spe=val.linlin(0,127, 0, 1); b[\pad2].set(spe); {pad2.value=spe.round(0.01); pad2t.string=val.asString}.defer}, 1, 9);
MIDIFunc.polytouch({|val| var spe; spe=val.linlin(0,127, 0, 1); b[\pad3].set(spe); {pad3.value=spe.round(0.01); pad3t.string=val.asString}.defer}, 2, 9);
MIDIFunc.polytouch({|val| var spe; spe=val.linlin(0,127, 0, 1); b[\pad4].set(spe); {pad4.value=spe.round(0.01); pad4t.string=val.asString}.defer}, 3, 9);
MIDIFunc.polytouch({|val| var spe; spe=val.linlin(0,127, 0, 1); b[\pad5].set(spe); {pad5.value=spe.round(0.01); pad5t.string=val.asString}.defer}, 4, 9);
MIDIFunc.polytouch({|val| var spe; spe=val.linlin(0,127, 0, 1); b[\pad6].set(spe); {pad6.value=spe.round(0.01); pad6t.string=val.asString}.defer}, 5, 9);
MIDIFunc.polytouch({|val| var spe; spe=val.linlin(0,127, 0, 1); b[\pad7].set(spe); {pad7.value=spe.round(0.01); pad7t.string=val.asString}.defer}, 6, 9);
MIDIFunc.polytouch({|val| var spe; spe=val.linlin(0,127, 0, 1); b[\pad8].set(spe); {pad8.value=spe.round(0.01); pad8t.string=val.asString}.defer}, 7, 9);

MIDIFunc.cc({|val| var spe; spe=val.linlin(0,127, 0, 1); b[\pad1].set(spe); {pad1.value=spe.round(0.01); pad1t.string=val.asString}.defer}, 1, 9);
MIDIFunc.cc({|val| var spe; spe=val.linlin(0,127, 0, 1); b[\pad2].set(spe); {pad2.value=spe.round(0.01); pad2t.string=val.asString}.defer}, 2, 9);
MIDIFunc.cc({|val| var spe; spe=val.linlin(0,127, 0, 1); b[\pad3].set(spe); {pad3.value=spe.round(0.01); pad3t.string=val.asString}.defer}, 3, 9);
MIDIFunc.cc({|val| var spe; spe=val.linlin(0,127, 0, 1); b[\pad4].set(spe); {pad4.value=spe.round(0.01); pad4t.string=val.asString}.defer}, 4, 9);
MIDIFunc.cc({|val| var spe; spe=val.linlin(0,127, 0, 1); b[\pad5].set(spe); {pad5.value=spe.round(0.01); pad5t.string=val.asString}.defer}, 5, 9);
MIDIFunc.cc({|val| var spe; spe=val.linlin(0,127, 0, 1); b[\pad6].set(spe); {pad6.value=spe.round(0.01); pad6t.string=val.asString}.defer}, 6, 9);
MIDIFunc.cc({|val| var spe; spe=val.linlin(0,127, 0, 1); b[\pad7].set(spe); {pad7.value=spe.round(0.01); pad7t.string=val.asString}.defer}, 7, 9);
MIDIFunc.cc({|val| var spe; spe=val.linlin(0,127, 0, 1); b[\pad8].set(spe); {pad8.value=spe.round(0.01); pad8t.string=val.asString}.defer}, 8, 9);


// //knobs
// MIDIdef.cc(\absolut1, {|val| if(val>50, {{k1.decrement}.defer}, {{k1.increment}.defer})}, 17, 0); //a func to get infinite knob value
// MIDIdef.cc(\absolut2, {|val| if(val>50, {{k2.decrement}.defer}, {{k2.increment}.defer})}, 18, 0);
// MIDIdef.cc(\absolut3, {|val| if(val>50, {{k3.decrement}.defer}, {{k3.increment}.defer})}, 19, 0);
// MIDIdef.cc(\absolut4, {|val| if(val>50, {{k4.decrement}.defer}, {{k4.increment}.defer})}, 20, 0);
// MIDIdef.cc(\absolut5, {|val| if(val>50, {{k5.decrement}.defer}, {{k5.increment}.defer})}, 21, 0);
// MIDIdef.cc(\absolut6, {|val| if(val>50, {{k6.decrement}.defer}, {{k6.increment}.defer})}, 22, 0);
// MIDIdef.cc(\absolut7, {|val| if(val>50, {{k7.decrement}.defer}, {{k7.increment}.defer})}, 23, 0);
// MIDIdef.cc(\absolut8, {|val| if(val>50, {{k8.decrement}.defer}, {{k8.increment}.defer})}, 24, 0);

// k=MIDIdef.cc(\sil, {arg ...args; args.postln});

// MIDIdef.cc(\absORrel, {}, );
// pad check boxes
MIDIdef.cc(\switch, {arg ...args;
	{~checkedA1=box1.value}.defer;
	{~checkedA2=box2.value}.defer;
	{~checkedA3=box3.value}.defer;
	{~checkedA4=box4.value}.defer;
	{~checkedA5=box5.value}.defer;
	{~checkedA6=box6.value}.defer;
	{~checkedA7=box7.value}.defer;
	{~checkedA8=box8.value}.defer;
	{~checkedB1=box9.value}.defer;
	{~checkedB2=box10.value}.defer;
	{~checkedB3=box11.value}.defer;
	{~checkedB4=box12.value}.defer;
	{~checkedB5=box13.value}.defer;
	{~checkedB6=box14.value}.defer;
	{~checkedB7=box15.value}.defer;
	{~checkedB8=box16.value}.defer;
	// checked1.postln;
	// args.postln;
	//pad1
	if( (args[0] != 0 && args[1]==1) && ~checkedA1,
		{{box1.value=false}.defer});
	if( (args[0] != 0 && args[1]==1) && ~checkedA1.not,
		{{box1.value=true}.defer});
	//pad2
	if( (args[0] != 0 && args[1]==2) && ~checkedA2,
		{{box2.value=false}.defer});
	if( (args[0] != 0 && args[1]==2) && ~checkedA2.not,
		{{box2.value=true}.defer});
	//pad3
	if( (args[0] != 0 && args[1]==3) && ~checkedA3,
		{{box3.value=false}.defer});
	if( (args[0] != 0 && args[1]==3) && ~checkedA3.not,
		{{box3.value=true}.defer});
	//pad4
	if( (args[0] != 0 && args[1]==4) && ~checkedA4,
		{{box4.value=false}.defer});
	if( (args[0] != 0 && args[1]==4) && ~checkedA4.not,
		{{box4.value=true}.defer});
	//pad5
	if( (args[0] != 0 && args[1]==5) && ~checkedA5,
		{{box5.value=false}.defer});
	if( (args[0] != 0 && args[1]==5) && ~checkedA5.not,
		{{box5.value=true}.defer});
	//pad6
	if( (args[0] != 0 && args[1]==6) && ~checkedA6,
		{{box6.value=false}.defer});
	if( (args[0] != 0 && args[1]==6) && ~checkedA6.not,
		{{box6.value=true}.defer});
	//pad7
	if( (args[0] != 0 && args[1]==7) && ~checkedA7,
		{{box7.value=false}.defer});
	if( (args[0] != 0 && args[1]==7) && ~checkedA7.not,
		{{box7.value=true}.defer});
	//pad8
	if( (args[0] != 0 && args[1]==8) && ~checkedA8,
		{{box8.value=false}.defer});
	if( (args[0] != 0 && args[1]==8) && ~checkedA8.not,
		{{box8.value=true}.defer});
	//pad9
	if( (args[0] != 0 && args[1]==9) && ~checkedB1,
		{{box9.value=false}.defer});
	if( (args[0] != 0 && args[1]==9) && ~checkedB1.not,
		{{box9.value=true}.defer});
	//pad10
	if( (args[0] != 0 && args[1]==10) && ~checkedB2,
		{{box10.value=false}.defer});
	if( (args[0] != 0 && args[1]==10) && ~checkedB2.not,
		{{box10.value=true}.defer});
	//pad11
	if( (args[0] != 0 && args[1]==11) && ~checkedB3,
		{{box11.value=false}.defer});
	if( (args[0] != 0 && args[1]==11) && ~checkedB3.not,
		{{box11.value=true}.defer});
	//pad12
	if( (args[0] != 0 && args[1]==12) && ~checkedB4,
		{{box12.value=false}.defer});
	if( (args[0] != 0 && args[1]==12) && ~checkedB4.not,
		{{box12.value=true}.defer});
	//pad13
	if( (args[0] != 0 && args[1]==13) && ~checkedB5,
		{{box13.value=false}.defer});
	if( (args[0] != 0 && args[1]==13) && ~checkedB5.not,
		{{box13.value=true}.defer});
	//pad14
	if( (args[0] != 0 && args[1]==14) && ~checkedB6,
		{{box14.value=false}.defer});
	if( (args[0] != 0 && args[1]==14) && ~checkedB6.not,
		{{box14.value=true}.defer});
	//pad15
	if( (args[0] != 0 && args[1]==15) && ~checkedB7,
		{{box15.value=false}.defer});
	if( (args[0] != 0 && args[1]==15) && ~checkedB7.not,
		{{box15.value=true}.defer});
	//pad16
	if( (args[0] != 0 && args[1]==16) && ~checkedB8,
		{
			{box16.value=false}.defer;

	});
	if( (args[0] != 0 && args[1]==16) && ~checkedB8.not,
		{
			{box16.value=true}.defer;

	});

	///decide the knobs whether absolut oder relative
	if( ~checkedB8,
		{
			{box16.string="relative"}.defer;
			MIDIdef.cc(\knob1, {|val| if(val>50, {{k1.decrement}.defer}, {{k1.increment}.defer})}, 17, 0); //a func to update gui and to get infinite knob value
			MIDIdef.cc(\knob2, {|val| if(val>50, {{k2.decrement}.defer}, {{k2.increment}.defer})}, 18, 0);
			MIDIdef.cc(\knob3, {|val| if(val>50, {{k3.decrement}.defer}, {{k3.increment}.defer})}, 19, 0);
			MIDIdef.cc(\knob4, {|val| if(val>50, {{k4.decrement}.defer}, {{k4.increment}.defer})}, 20, 0);
			MIDIdef.cc(\knob5, {|val| if(val>50, {{k5.decrement}.defer}, {{k5.increment}.defer})}, 21, 0);
			MIDIdef.cc(\knob6, {|val| if(val>50, {{k6.decrement}.defer}, {{k6.increment}.defer})}, 22, 0);
			MIDIdef.cc(\knob7, {|val| if(val>50, {{k7.decrement}.defer}, {{k7.increment}.defer})}, 23, 0);
			MIDIdef.cc(\knob8, {|val| if(val>50, {{k8.decrement}.defer}, {{k8.increment}.defer})}, 24, 0);

		},
		{
			{box16.string="absolut"}.defer;
			MIDIdef.cc(\knob1, {|val| {k1.valueAction=val}.defer}, 17, 0); //a func to update gui and to get infinite knob value
			MIDIdef.cc(\knob2, {|val| {k2.valueAction=val}.defer}, 18, 0);
			MIDIdef.cc(\knob3, {|val| {k3.valueAction=val}.defer}, 19, 0);
			MIDIdef.cc(\knob4, {|val| {k4.valueAction=val}.defer}, 20, 0);
			MIDIdef.cc(\knob5, {|val| {k5.valueAction=val}.defer}, 21, 0);
			MIDIdef.cc(\knob6, {|val| {k6.valueAction=val}.defer}, 22, 0);
			MIDIdef.cc(\knob7, {|val| {k7.valueAction=val}.defer}, 23, 0);
			MIDIdef.cc(\knob8, {|val| {k8.valueAction=val}.defer}, 24, 0);
		}
	);
});
)
