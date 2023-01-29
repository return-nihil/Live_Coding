

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// RETURN_NIHIL + VIOLIN
// BOOT FILE
// F. Ardan Dal Rì, September 2022
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////


ServerOptions.devices;


s.scope;
s.freqscope;
s.meter;
v = Volume.new(s);
v.gui;



(
// Server init
Server.default.options.inDevice_("Scarlett 4i4 USB"); // whatever
Server.default.options.outDevice_("Soundflower (64ch)"); //whatever
s.options.numBuffers = 1024 * 256;
s.options.memSize = 8192 * 32;
s.options.maxNodes = 1024 * 32;
s.options.numInputBusChannels = 1;
s.options.numOutputBusChannels = 3;
o = NetAddr.new("127.0.0.1", 57121);

// Midi
MIDIClient.init;
MIDIIn.connectAll;


~cleanup = {
	s.newBusAllocators;
	ServerBoot.removeAll;
	ServerTree.removeAll;
	ServerQuit.removeAll;
	s.freeAll;
};


~buffers_init = {
	~bufferZ = [1, 2, 3, 4, 5].collect {
		var b;
		b = Buffer.alloc(s, s.sampleRate * 1, 1);
	};
};

ServerQuit.add(~cleanup);
ServerBoot.add(~buffers_init);

s.waitForBoot {
	~dirt = SuperDirt(2, s);
	~dirt.start(57120, 0 ! 16);
	s.sync;
	StageLimiter.activate;
	s.sync;
	(“violin_synthdefs_list.scd").loadRelative;
	s.sync;
	"------> READY".postln;

		(
			~d1 = ~dirt.orbits[0];
			~d2 = ~dirt.orbits[1];
			~d3 = ~dirt.orbits[2];
			~d4 = ~dirt.orbits[3];
			~d5 = ~dirt.orbits[4];
			~d6 = ~dirt.orbits[5];
			~d7 = ~dirt.orbits[6];
			~d8 = ~dirt.orbits[7];
			~d9 = ~dirt.orbits[8];
			~d10 = ~dirt.orbits[9];
			~d11 = ~dirt.orbits[10];
			~d12 = ~dirt.orbits[11];
			~d13 = ~dirt.orbits[12];
			~d14 = ~dirt.orbits[13];
			~d15 = ~dirt.orbits[14];
			~d16 = ~dirt.orbits[15];
		);
};

s.latency = 0.5;
~notestart = 21;

(
MIDIIn.program = { |src, chan, midinote|

	var bufferz = (midinote - ~notestart);

	if ( bufferz < 6,
		{ Synth(\rec, [\bufnum, ~bufferZ[bufferz].bufnum, \gate, 1]);
			o.sendMsg("/hello", \recbuf, bufferz + 1);
	});
	("Recording on buffer" +(midinote-~notestart)).postln

});

)
s.boot


~violin = Synth.new(\violin);
~violin.set([\volume, 1])
