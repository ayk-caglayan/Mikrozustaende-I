(//RECEIVER
//creates score_pages and writes them into an array
var dir, file_name, page_number=50, bound; //give total page number
dir="~/Desktop/Mikrozustände/notation/png_folder/"; //directory in which .png pages resides
file_name="lyfile"; //generic name of pages - page number to be appended
bound=Rect(0,0,500,500);
~window_array=Array.fill(page_number, {Window("score", Rect(0,0,500,500))});

~window_array.do({arg item, ind;
	item.view.setBackgroundImage(Image.new(dir++file_name++ind.asString++".png"),1,1,~bound);
});

~window_array.do({arg item, ind;
	//("ind-> "++ ind.asString).postln;
	//("item-> "++ item.asString).postln;
	//item.front;
});

)

(//SENDER & RECEIVER
//NetAddr.langPort //check port for each host!
//OSCFunc.trace(true) //use to diagnose
// !!! sender gives its langPort !!! on its own setting// to send data give sources langPort
// !!! receiver gives senders langPort when setting receivers NetAddr on its own setting  ///
// !!! when to set a target on our own hub, give a chosen port for target ///
/// to get the message we need to give chosen port number, which is given on the senders setting
// ~mac_sender=NetAddr("localhost", NetAddr.langPort);
~mac_receiver=NetAddr("192.168.1.2", 12344); //receiver gives a chosen port to send data
// ~red=NetAddr("192.168.2.104", 12344);

//OSCFunc.trace(true);
)



(//RECEIVER
//create the window!
w=Window("beat_count", Rect(0,0,200,200));
//n=NumberBox(w, Rect(0,0,200,200));
~beat=StaticText(w, w.view.bounds).align_(\left);
~bar=StaticText(w, w.view.bounds).align_(\right);

w.front;
~beat.font = Font("Monaco", 45);
~bar.font= Font("Monaco", 34);

~beat_label=StaticText(w, Rect(2,20,40, 20));
~beat_label.string="Beat";
~bar_label=StaticText(w, Rect(160, 20, 40, 20));
~bar_label.string="Bar";
~beat.font = Font("Monaco", 25);
~bar.font= Font("Monaco", 20);

~beat.string=0.asString;
~bar.string=0.asString;
)

(//RECEIVER
//osc funs to send the received beats to the window
OSCFunc({arg msg, time;  {~beat.string=msg[2].asString}.defer}, "/tempo/bar&beat", ~mac_sender, 57120);
OSCFunc({arg msg, time; {~bar.string=msg[1].asString}.defer}, "/tempo/bar&beat", ~mac_sender, 57120);
)

(//RECEIVER
//give bar numbers as switch values at which a new page has to be shown from ~window_array//
OSCFunc({arg msg, time; switch(msg[1],
	1, {~window_array[0].front},
	4, {~window_array[1].front},
	12, {~window_array[2].front},
	13, {~window_array[3].front},
	15, {~window_array[4].front})}, "/tempo/bar&beat", ~mac_sender, 57120)

)

(//SENDER
//tempo clock

t=TempoClock(1, 4);
//t.schedAbs(1, {t.beats.postln; 1});
//changing tempos..
t.schedAbs(2, {t.tempo=1; t.beatsPerBar=3; nil});
t.schedAbs(5, {t.tempo=3; t.beatsPerBar=7; nil});
t.schedAbs(15, {t.tempo=1.2; t.beatsPerBar=4; nil});
t.schedAbs(25, {t.tempo=1; t.beatsPerBar=5.5; nil});
t.schedAbs(30, {t.tempo=3; t.beatsPerBar=7; nil});

t.schedAbs(1, {arg beat;
	~mac_receiver.sendMsg("/tempo/bar&beat", t.bar.asInteger, t.beatInBar.asInteger);
	//~red.sendMsg("/tempo/bar&beat", t.bar.asInteger, t.beatInBar.asInteger);
	1}) //target
)

t.stop;