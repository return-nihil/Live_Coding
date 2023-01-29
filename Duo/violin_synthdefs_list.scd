//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// RETURN_NIHIL + VIOLIN
// SYNTHDEFS LIST
// By F. Ardan Dal Rì, September 2022
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////



SynthDef(\violin, { |in = 0, out = 2, volume = 1|

	var sig, exit;

	sig = LeakDC.ar(SoundIn.ar(in));
	sig = sig * volume;

	exit = OffsetOut.ar(out, sig!2);

}).add;




SynthDef(\rec, { |out = 0, gate = 0, bufnum|

    var curve, env, input;

	curve = Env.adsr(0.01, 0.9, 1, 0.01, curve: 0);
	env = EnvGen.kr(curve, gate: gate, doneAction: Done.freeSelf);

	input = LeakDC.ar(SoundIn.ar(0));
    RecordBuf.ar(input * env, bufnum, loop: 0);

}).add;



SynthDef(\buf, {|bufn, begin = 0, end = 1, tran = 0, rate = 1, pan = 0, sustain, accelerate, offset, out = 0|

	var bdur, ratio, speed, dur, curve, env, initbuf, endbuf, sig, exit;

	bdur = BufFrames.kr(bufn);
	ratio = tran.midiratio;
	speed = rate*ratio;
	dur = (bdur/s.sampleRate) * (end - begin) * sustain;

	curve = Env.linen(0.01, dur - 0.02, 0.01);
	env = EnvGen.kr(curve, doneAction: Done.freeSelf);

	initbuf = bdur * begin * speed.abs;
	endbuf = bdur * end * speed.abs;

	sig = BufRd.ar(1, bufn, Phasor.ar(0, (BufRateScale.kr(bufn) * speed), initbuf, endbuf), loop: 0);
	sig = LeakDC.ar(sig * env);

	exit = OffsetOut.ar(out, Pan2.ar(sig, pan));
}).add;



SynthDef(\bufG, {|bufn, gden = 10, gdur = 0.1, gpos = 0.1, gpit = 1, gpan = 1, sustain = 1, accelerate, offset, out = 0|

    var trig, position, panning, line, func, env, sig, exit;

	trig = Dust.kr(gden);
	position =  ((LFNoise1.kr(0.1).range(0, 1))*0.05) + gpos;
    panning = LFNoise1.kr.range(-1, 1) * gpan;

	line = Line.kr(0, 1, sustain, doneAction: Done.freeSelf);
	func = Env.new([0, 1, 0.9, 0], [0.3, 0.4, 0.3], curve: [-4, 0, -4]);
    env = IEnvGen.kr(func, line);

	sig = GrainBuf.ar(2, trig, gdur, bufn, gpit, position, 2, panning, -1, maxGrains: 100);
	sig = sig * env;

	exit = OffsetOut.ar(out, sig);

}).add;



SynthDef(\bufFM, {|bufn, begin = 0, end = 1, freq = 440, rate = 1, amod = 100, mode = 0, sustain = 1, accelerate, offset, out = 0, pan = 0|

    var bdur, dur, curve, env, initbuf, endbuf, sig, ampmod, carr, exit;

	bdur = BufFrames.kr(bufn);
	dur = (bdur/s.sampleRate) * (end - begin) * sustain;

	curve = Env.perc(0.01, 0.2);
	env = EnvGen.kr(curve, doneAction: Done.freeSelf);

	initbuf = bdur * begin * rate.abs;
	endbuf = bdur * end * rate.abs;

	sig = BufRd.ar(1, bufn, Phasor.ar(0, (BufRateScale.kr(bufn) * 1), initbuf, endbuf), loop: 0);
	ampmod = sig * env * amod;

	carr = Select.ar(mode, [
		                  SinOsc.ar(freq + ampmod),
			              Saw.ar(freq + ampmod),
		                  Pulse.ar(freq + ampmod),
		                  Blip.ar(freq + ampmod, numharm: 5)
	                   ]);

	sig = carr * env;

	exit = OffsetOut.ar(out, Pan2.ar(sig, pan));

}).add;


