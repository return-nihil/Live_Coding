//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// RETURN_NIHIL
// BOOT FILE FOR SUPERCOLLIDER
// F. Ardan Dal Rì, July 2022
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////


ServerOptions.devices;

// UTILS
s.scope;
s.freqscope;
s.meter;
v = Volume.new(s);
v.gui;


(
Server.default.options.outDevice_("Live_Coding_Stream"); //Scarlett 4i4 USB "Built-in Output" "Dispositivo con uscite multiple"
	s.options.numBuffers = 1024 * 256;
	s.options.memSize = 8192 * 32;
	s.options.maxNodes = 1024 * 32;
	//s.options.numInputBusChannels = 2;
	s.options.numOutputBusChannels = 2;

~cleanup = {
	s.newBusAllocators;
	ServerBoot.removeAll;
	ServerTree.removeAll;
	ServerQuit.removeAll;
	s.freeAll;
};

~buffers_init = {
	// Buffers for granulators:
	~b1 = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");
	~b2 = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");
	~b3 = Buffer.read(s, Platform.resourceDir +/+ "sounds/intro.wav");
	~b4 = Buffer.read(s, Platform.resourceDir +/+ "sounds/grain.wav");

	// Waveshapers:
	~b5 = Buffer.alloc(s, 2048);
	~b6 = Buffer.alloc(s, 2048);
	~p2 = rrand(0.01, 0.89);
	~p3 = rrand(0.01, 0.79);
	~b5.sine3([1, 2, 4], [1, ~p2, ~p3], 0!3, asWavetable:true);
	~b6.sine3([1, 3, 5], [1, ~p2, ~p3], 0!3, asWavetable:true);

};

ServerQuit.add(~cleanup);
ServerBoot.add(~buffers_init);

s.waitForBoot {
	~dirt = SuperDirt(2, s);
  
	// ~dirt.loadSoundFiles;
	// ~dirt.loadSoundFiles("/Users/Ardan/Desktop/TidalCycles/samples-extra/*");
	~dirt.loadSoundFiles(PathName(thisProcess.nowExecutingPath).parentPath +/+ "audio/concrete/*");
	~dirt.loadSoundFiles(PathName(thisProcess.nowExecutingPath).parentPath +/+ "audio/electromagnetic/*");
	~dirt.loadSoundFiles(PathName(thisProcess.nowExecutingPath).parentPath +/+ "audio/instrumental/*");
  
	~dirt.start(57120, 0 ! 16);
	s.sync;
	//StageLimiter.activate;
	s.sync;
	("synthdefs_list.scd").loadRelative;
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
	s.latency = 0.25;

//EVAL -->
)
	~dirt.soundLibrary.addMIDI(\midi, ~midiOut);
