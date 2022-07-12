--------------------------------------------------------------------------------
-- RETURN_NIHIL
-- BOOT FILE FOR TIDALCYCLES
-- By F. Ardan Dal Rì, July 2022
--------------------------------------------------------------------------------


:set -XOverloadedStrings
:set prompt ""

import Sound.Tidal.Context

import Data.Maybe

import System.IO (hSetEncoding, stdout, utf8)

import qualified Control.Concurrent.MVar as MV
import qualified Sound.Tidal.Tempo as Tempo
import qualified Sound.OSC.FD as O

hSetEncoding stdout utf8

-- SC port: 57120, P5 port: 57121
:{
let oscmap = [
              ((superdirtTarget {oLatency = 0.15, oPort = 57120}), [superdirtShape])
              ,
              ((superdirtTarget {oLatency = 0.15, oPort = 57121}), [superdirtShape])
             ]
:}

tidal <- startStream (defaultConfig {cFrameTimespan = 1/20}) oscmap

:{
let only = (hush >>)
    p = streamReplace tidal
    hush = streamHush tidal
    panic = do hush
               once $ sound "superpanic"
    list = streamList tidal
    mute = streamMute tidal
    unmute = streamUnmute tidal
    unmuteAll = streamUnmuteAll tidal
    solo = streamSolo tidal
    unsolo = streamUnsolo tidal
    once = streamOnce tidal
    first = streamFirst tidal
    asap = once
    nudgeAll = streamNudgeAll tidal
    all = streamAll tidal
    resetCycles = streamResetCycles tidal
    setcps = asap . cps
    getcps = do tempo <- MV.readMVar $ sTempoMV tidal
                return $ Tempo.cps tempo
    getnow = do tempo <- MV.readMVar $ sTempoMV tidal
                now <- O.time
                return $ fromRational $ Tempo.timeToCycles tempo now
    xfade i = transition tidal True (Sound.Tidal.Transition.xfadeIn 4) i
    xfadeIn i t = transition tidal True (Sound.Tidal.Transition.xfadeIn t) i
    histpan i t = transition tidal True (Sound.Tidal.Transition.histpan t) i
    wait i t = transition tidal True (Sound.Tidal.Transition.wait t) i
    waitT i f t = transition tidal True (Sound.Tidal.Transition.waitT f t) i
    jump i = transition tidal True (Sound.Tidal.Transition.jump) i
    jumpIn i t = transition tidal True (Sound.Tidal.Transition.jumpIn t) i
    jumpIn' i t = transition tidal True (Sound.Tidal.Transition.jumpIn' t) i
    jumpMod i t = transition tidal True (Sound.Tidal.Transition.jumpMod t) i
    mortal i lifespan release = transition tidal True (Sound.Tidal.Transition.mortal lifespan release) i
    interpolate i = transition tidal True (Sound.Tidal.Transition.interpolate) i
    interpolateIn i t = transition tidal True (Sound.Tidal.Transition.interpolateIn t) i
    clutch i = transition tidal True (Sound.Tidal.Transition.clutch) i
    clutchIn i t = transition tidal True (Sound.Tidal.Transition.clutchIn t) i
    anticipate i = transition tidal True (Sound.Tidal.Transition.anticipate) i
    anticipateIn i t = transition tidal True (Sound.Tidal.Transition.anticipateIn t) i
    forId i t = transition tidal False (Sound.Tidal.Transition.mortalOverlay t) i


    -- CUSTOM
    --------------------------------------------------------------------------------
    -- SHORTCUTS
    shh = silence
    stfu = mute
    speak = unmute
    trig = trigger
    r00m = room
    someby = sometimesBy
    sust = sustain
    sus = sustain
    g = gain
    wm = whenmod
    degradeb = degradeBy
    degby = degradeBy
    evr = every
    seg = segment
    stutw = stutWith
    slegato n = legato (range 0.05 n $ rand)
    slegnato n = legato (unwrap $ choose [(range 0.05 (n*0.25) $ perlin), (range (n*0.75) n $ perlin)])
    multispeed n = speed (unwrap $ choose [(range 0.08 (n*0.25) $ perlin), (range (n*0.75) n $ perlin)])
    crazyspeed n = speed (choose [0.02, n*0.05, n*0.1, n*4, n*6, n*8]) # cut 1
    hyperspeed n = speed (range (n*10) (n*100) $ rand)
    sinspat n = pan (range 0 1 (fast n sine))
    sqspat n = pan (range 0 1 (fast n square))
    randspat = pan (range 0 1 $ rand)
    fastspat n = pan (range 0 1 $ rand)
    softrand = (((range 0 1 $ rand) - 0.5) * 0.1) + 1
    densmask st en p = scramble (round <$> (range st en $ sine)) $ fast (range st en $ sine) $ s p --thanks @ndr_brt
    appear x n = gain (trigger x $ range 0 1 $ slow n envL)
    vanish x n = gain (trigger x $ range 1 0 $ slow n envL)
    roll x p = stutWith 2 x id $ p  --d1 $ roll 7 "0 1 2 3" # s "bd"
    destroy n = (# waveloss (trigger 6 $ range 1 n $ slow 10 envL)) . (# gain 1) . (# legato 0.9) . (# lpf 5000)
    lin n = slow n envL
    smarmella n = (degradeBy 0.2) . ((segment n $ range 0 1 $ rand) ~>)
    stutfx = ((|* lpf 0.7) . (|* gain 0.8))
    async n = fast (slow n $ range 0.2 3 $ sine)
    stful = mapM_ mute
    speakl = mapM_ unmute
    verb n = ((# room n) . (# size n))
    det x = (((range 0 x $ rand) - (x/2)) * 0.1)

    --------------------------------------------------------------------------------
    -- SCALES
    scale = getScale (scaleTable ++ [("justint", [0,(90/100),(204/100),(294/100),(408/100),(489/100),(588/100),(702/100),(792/100),(906/100),(996/100),(1100/100)])])
    scale = getScale (scaleTable ++ [("nearby", [0, 0.5, 0.8, 1, 1.2, (1110/100), (1175/100)])])
    
    --------------------------------------------------------------------------------
    -- SYNTHS CONTROLS
    gdens = pF "gdens"
    gdur = pF "gdur"
    gpitch = pF "gpitch"
    gpos = pF "gpos"
    gpan = pF "gpan"
    gsdens = pF "gsdens"
    penv = pF "penv"
    fmcrush = pF "fmcrush"
    fmbits = pF "fmbits"

    --------------------------------------------------------------------------------
    --------------------------------------------------------------------------------

    d1 = p 1 . (|< orbit 0)
    d2 = p 2 . (|< orbit 1)
    d3 = p 3 . (|< orbit 2)
    d4 = p 4 . (|< orbit 3)
    d5 = p 5 . (|< orbit 4)
    d6 = p 6 . (|< orbit 5)
    d7 = p 7 . (|< orbit 6)
    d8 = p 8 . (|< orbit 7)
    d9 = p 9 . (|< orbit 8)
    d10 = p 10 . (|< orbit 9)
    d11 = p 11 . (|< orbit 10)
    d12 = p 12 . (|< orbit 11)
    d13 = p 13 . (|< orbit 12)
    d14 = p 14 . (|< orbit 13)
    d15 = p 15 . (|< orbit 14)
    d16 = p 16 . (|< orbit 15)
:}

:{
let setI = streamSetI tidal
    setF = streamSetF tidal
    setS = streamSetS tidal
    setR = streamSetR tidal
    setB = streamSetB tidal
:}

:set prompt "tidal> "
:set prompt-cont ""
