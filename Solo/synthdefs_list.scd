//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// RETURN_NIHIL
// SYNTHDEFS LIST
// By F. Ardan Dal Rì, July 2022
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////



// Simple Granular

SynthDef(\grain, { |out, sustain, gate = 1, accelerate, offset, gdens = 10, gdur = 0.1, glag = 0.2, gpos = 0.1, gpan = 0|

    var trig, rate, position, panning, line, func, env, sig, exit;

	trig = Dust.kr(gdens);
	rate = LFNoise1.kr.range(0.1, 3) * \gpitch.kr.lag(glag) + 1;
	position =  ((LFNoise1.kr(0.1).range(0, 1))*0.05) + gpos;
    panning = LFNoise1.kr.range(-1, 1) * gpan;

	line = Line.kr(0, 1, sustain, doneAction: 2);
	func = Env.new([0, 1, 0.9, 0], [0.1, 0.8, 0.1], curve: [-4, 0, -4]);
    env = IEnvGen.kr(func, line);

	sig = GrainBuf.ar(2, trig, gdur, ~b4, rate, position, 2, panning, -1, maxGrains: 400);

	exit = sig * env;

	OffsetOut.ar(out, [exit, exit]);
}).add;



// Double Granular

SynthDef(\gspat, { |out, sustain, gate = 1, accelerate, offset, gsdens = 1|

    var trig1, trig2, rate1, rate2, position1, position2, dur1, dur2, line, func, env, sig1, sig2, exitL, exitR;

	trig1 = Dust.kr(gsdens);
	trig2 = Dust.kr(gsdens);
	rate1 = LFNoise1.kr.range(0.1, 2);
	rate2 = LFNoise1.kr.range(0.1, 2);
	position1 =  LFNoise1.kr(0.1).range(0, 1);
	position2 =  LFNoise1.kr(0.1).range(0, 1);
	dur1 =  LFNoise1.kr(0.1).range(0.01, 0.1);
	dur2 =  LFNoise1.kr(0.1).range(0.01, 0.1);

	line = Line.kr(0, 1, sustain, doneAction: 2);
	func = Env.new([0.001, 1, 0.9, 0.0001], [0.1, 0.8, 0.1], curve: [-4, 0, -4]);
    env = IEnvGen.kr(func, line);

	sig1 = GrainBuf.ar(1, trig1, dur1, ~b1, rate1, position1, 2, -1, -1, maxGrains: 100);
	sig2 = GrainBuf.ar(1, trig2, dur2, ~b2, rate2, position2, 2, 1, -1, maxGrains: 100);

	exitL = sig1 * env;
	exitR = sig2 * env;

	OffsetOut.ar(out, [exitL, exitR]);
}).add;



// Tuned FM

SynthDef(\cry, { |out, gate = 1, sustain, accelerate, offset, freq|

	var pitch, line, func, globalenv, noisenv, noise, env, modulator, carrier, filter, randomness, sig, exitL, exitR;

	pitch = freq * 8;
	randomness = LFNoise1.kr(1, 0.5, 0.5).round;

	line = Line.kr(0, 1, sustain, doneAction: 2);
	func = Env.new([0.0001, 1, 1, 0.0001], [0.1, 0.8, 0.1], curve: [-4, 0, -4]);
    globalenv = IEnvGen.kr(func, line);

	noisenv = EnvGen.kr(Env.perc(0.01, 0.1, curve:[8, -8]), doneAction: 0);
	env = EnvGen.kr(Env.perc(0.02, 0.4, curve:[4, -4]), doneAction: 0);

	modulator = SinOsc.ar(4321, mul: LFNoise1.ar(10, 250, 300));
	carrier = SinOsc.ar(pitch + modulator) * env;
	filter = HPF.ar(carrier, 2000);
	noise = PinkNoise.ar * noisenv * LFNoise1.ar(10, 0.3);
	sig = (filter * env) + noise;

	exitL = sig * globalenv * randomness;
	exitR = sig * globalenv * (randomness - 1).abs;

	OffsetOut.ar(out, [exitL, exitR]);
}).add;



// Tuned Sine

SynthDef(\pure, { |out, freq, sustain, gate = 1, penv = 0, pan, accelerate, offset|

	var line, func, env, amp = 0.4, sig, exit;

	line = SelectX.kr(penv,  [Line.kr(0, 1, sustain, doneAction: 2),
		                          Line.kr(1, 0, sustain, doneAction: 2),
		                          Line.kr(0, 1, sustain, doneAction: 2).exprange,
				                  Line.kr(1, 0, sustain, doneAction: 2).exprange]);
	func = Env.new([0.0001, 0.6, 0.0001], [0.2, 0.8], curve: [2, -2]);
    env = IEnvGen.kr(func, line);

	sig = SinOsc.ar(freq) * amp;

	exit = sig * env;

	Out.ar(out, [exit, exit]);
}).add;



// Noisy FM Cluster

SynthDef(\clust, { |out, gate = 1, sustain, pan, accelerate, offset, freq|

	var line, func, env, linemod1, linemod2, fmod1, fmod2, envmod1, envmod2, mod1, mod2, carrier, det, noise, exit;
	var start1 = 0, end1 = 1, start2 = 1, end2 = 0;

	line = Line.kr(start1, end1, sustain, doneAction: 2);
	linemod1 = Line.kr(start2, end2, sustain * 0.5, doneAction: 0);
	linemod2 = Line.kr(start2, end2, sustain * 0.7, doneAction: 0);
	func = Env.new([0.0001, 1, 1, 0.0001], [0.2, 0.1, 0.7], curve: [-4, 0, -8]);
	fmod1 = Env.new([0.0001, 1, 0.0001], [0.8, 0.2], curve: \lin);
	fmod2 = Env.new([0.0001, 1, 0.0001], [0.4, 0.6], curve: [-2, -2]);
    env = IEnvGen.kr(func, line);
	envmod1 = IEnvGen.kr(fmod1, linemod1);
	envmod2 = IEnvGen.kr(fmod2, linemod2);

	det = LFNoise1.kr(0.2!4).bipolar(0.3).midiratio;

	mod2 = SinOsc.ar(Rand(2000, 4000)) * envmod2 * Rand(400, 900);
	mod1 = SinOsc.ar(Rand(100, 500) + mod2) * envmod1 * Rand(200, 500);
	carrier = SinOsc.ar((freq * det + mod1)!4);

	noise = PinkNoise.ar * EnvGen.kr(Env.perc, doneAction: 0) * 0.6;

	exit = Splay.ar((carrier * 0.7) + noise);
	exit = exit * env * 0.1;


	OffsetOut.ar(out, exit);
}).add;



// Entropy --thanks to @ndr_brt

SynthDef(\entro, { |out, sustain = 0.9, decay = 0, width = 0.3, attack = 0.1, release = 1|

	var env, caboos, pulsefreq, noise1, noise2, sig, verb, mix, room, damp, exit;

	env = EnvGen.kr(Env.new([0, 1, 1, 0], [attack, sustain, release], -8), doneAction: 2);
	caboos = LFNoise0.kr(15);
	pulsefreq = LFPulse.kr(SinOsc.kr(0.3).range(1, caboos.fold(1, 4)), Crackle.kr.range(0, 2pi));
	noise1 = LFNoise1.kr(7).range(0.1, caboos.slew(0.3, 0.9));
	noise2 = LFNoise2.kr(3).range(Line.kr(300, 800, 17), caboos.range(800, 1400));

	sig = SinOscFB.ar(Pulse.kr(pulsefreq, noise1).exprange(noise2))!2;
	sig = sig + Impulse.ar(caboos.slew(0.1, 0.9).range(300, 800));
	sig = sig / 2;

	mix = SinOsc.kr(1/3).range(0.3, 0.9);
	room = LFSaw.kr(1/5).range(0.3, 0.9);
	damp = SinOsc.kr(1/7).range(0.3, 0.9);

	verb = FreeVerb.ar(sig, mix, room, damp);

	exit = [verb, verb + Delay1.ar(verb)];
	exit = exit.tanh;
	exit = exit * env;

	OffsetOut.ar(out, [exit, exit]);
}).add;



// Bass

SynthDef(\sbass, { |out, freq, sustain, gate = 1, pan, accelerate, offset, sawlow = 5000, bwr = 0.6 |

	var line, func, env, osc, exit, filterfunc, filterenv, filter;

	line = Line.kr(0, 1, sustain, doneAction: 2);
	func = Env.new([0.0001, 1, 0.0001], [0.03, 0.97], curve: [2, -2]);
    env = IEnvGen.kr(func, line);
	filterfunc = Env.new([0.0001, 1, 0.0001], [0.2, 0.8], curve: [2, -2]);
    filterenv = IEnvGen.kr(filterfunc, line);

	osc = ((Saw.ar(freq*2, 0.25) + Saw.ar(freq/2) + SinOscFB.ar(freq/4, 0.9)) * 0.7) * env;

	exit = HPF.ar(Resonz.ar(osc, filterenv*sawlow, bwr), 200);
	exit = LeakDC.ar(exit, 0.98);

	OffsetOut.ar(out, [exit, exit]);
}).add;



// Waveshaper

SynthDef.new(\wavet, {|out, freq, sustain = 1, gate = 1 |

	var line, func, env, detune, bufpos, osc, exit;

	line = Line.kr(0, 1, sustain, doneAction: 2);
	func = Env.new([0, 1, 0.8, 0], [0.1, 0.3, 0.6], curve: \lin);
    env = IEnvGen.kr(func, line);

	detune = LFNoise1.kr(0.2!8).bipolar(0.2).midiratio;
	bufpos = ~b5.bufnum + LFNoise1.kr(1).range(0.001, 1);

	osc = VOsc.ar(bufpos, freq * detune, mul: 0.2) * env;
	exit = Splay.ar(osc);

	OffsetOut.ar(out, [exit, exit]);
}).add;
