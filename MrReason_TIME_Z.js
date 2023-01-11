'use babel'

export default function(p) {

// CREATE WINDOW
  p.windowResized = () => {
    p.resizeCanvas(p.windowWidth, p.windowHeight);
    windowsize = p.windowHeight;
    console.log(p.windowHeight)
  }

// USER VARIABLES
  var globaltime = 10; // total performance time
  const keys = ["piano", "solar", "tumbi", "key", "harp"]; // content of each category
  const pad = ["string", "pad"];
  const lead = ["lead"];
  const bass = ["fbass", "bass"];
  const fx = ["fx"];
  const mel = ["melody", "sally"];
  const voice = ["vc"];
  const drums = ["bd", "hh", "sn", "tom", "cr"];

  const maxfilter = 10000 // maximum lpf filter value



// INIT
  var framerate = 3;
  var start = 0;
  var pos1 = [0, 0];
  var pos2 = [0, p.windowHeight/2];
  var pos3 = [p.windowWidth/4, 0];
  var pos4 = [p.windowWidth/4, p.windowHeight/2];
  var pos5 = [(p.windowWidth/4)*2, 0];
  var pos6 = [(p.windowWidth/4)*2, p.windowHeight/2];
  var pos7 = [(p.windowWidth/4)*3, 0];
  var pos8 = [(p.windowWidth/4)*3, p.windowHeight/2];
  var shiftx = (p.windowWidth/4)/2;
  var shifty = (p.windowHeight/2)/2;
  var centerx = (p.windowWidth/4/2);
  var centery = (p.windowHeight/2/2);
  var timewidget = 0;


  p.setup = () => {
    p.smooth();
    p.frameRate(framerate);
    p.colorMode(p.HSB, 360);

// CREATE STAVES
   setTimeout(() => {
     p.background(0, 0, 0);
         p.strokeWeight(2);
         p.stroke(255, 0, 255);
         p.line(0, p.windowHeight/2, p.windowWidth, p.windowHeight/2);
         p.line(p.windowWidth/4, 0, p.windowWidth/4, p.windowHeight);
         p.line((p.windowWidth/4)*2, 0, (p.windowWidth/4)*2, p.windowHeight);
         p.line((p.windowWidth/4)*3, 0, (p.windowWidth/4)*3, p.windowHeight);
   })
} // setup


// FUNCTIONS
function littleRand(shift) {
  var rnd = ((Math.random() * shift) - shift/2);
    	return rnd;
    }

// DRAW
this.onOscMessage(message => {
      var tidalArgs = message.args;
      start = 1;

        // MESSAGE READER
        tidal = {};
          for(var i = 0; i < tidalArgs.length; i+=2){
            tidal[tidalArgs[i]] = tidalArgs[i+1]
          };
       console.log(tidal);

//SWITCHER + PLOTTER



          // BASS --> BLUE CIRCLE
               if(bass.includes(tidal.s)) {
                 let alpha
                 if (tidal.cutoff) {
                   alpha = ((tidal.cutoff / maxfilter) * 360) + galpha
                 }
                 else {
                   alpha = 330
                 }
                 let sat
                 if (tidal.n <= 360) {
                   sat = Math.abs(((tidal.n%12)/12 * 160)) + 200
                 }
                 else {
                   sat = 200
                 }
                 let oh = littleRand(shiftx);
                 let alt = littleRand(shifty);

                 let xx = centerx + pos1[0] + oh;
                 let yy = centery + pos1[1] + alt;

                 p.noStroke();
                 p.fill(220, sat, 360, alpha);
                 p.ellipse(xx, yy, 50, 50);
               }


           // KEYS --> ORANGE RECTANGLE
                if(keys.includes(tidal.s)) {
                  let alpha
                  if (tidal.cutoff) {
                    alpha = ((tidal.cutoff / maxfilter) * 360) + galpha
                  }
                  else {
                    alpha = 330
                  }
                  let sat
                  if (tidal.n <= 360) {
                    sat = Math.abs(((tidal.n%12)/12 * 160)) + 200
                  }
                  else {
                    sat = 200
                  }

                  let oh = littleRand(shiftx);
                  let alt = littleRand(shifty);

                  let xx = centerx + pos2[0] + oh;
                  let yy = centery + pos2[1] + alt;

                  p.noStroke();
                  p.fill(27, sat, 360, alpha);
                  p.rect(xx, yy, 50, 30);
                }



          // LEAD --> VIOLET LINE
               if(lead.includes(tidal.s)) {
                 let alpha
                 if (tidal.cutoff) {
                   alpha = ((tidal.cutoff / maxfilter) * 360) + galpha
                 }
                 else {
                   alpha = 330
                 }
                 let sat
                 if (tidal.n <= 360) {
                   sat = Math.abs(((tidal.n%12)/12 * 160)) + 200
                 }
                 else {
                   sat = 200
                 }

                 let oh = littleRand(shiftx);
                 let alt = littleRand(shifty);

                 let xx = centerx + pos3[0] + oh;
                 let yy = centery + pos3[1] + alt;

                 p.strokeWeight(8);
                 p.stroke(278, sat, 330, alpha);
                 p.line(xx-50, yy, xx+50, yy);
               }


         // MELODY --> LIGHT VIOLET LINE
              if(mel.includes(tidal.s)) {

                let alpha
                if (tidal.cutoff) {
                  alpha = ((tidal.cutoff / maxfilter) * 360) + galpha
                }
                else {
                  alpha = 330
                }
                let sat
                if (tidal.n <= 360) {
                  sat = Math.abs(((tidal.n%12)/12 * 160)) + 50
                }
                else {
                  sat = 50
                }

                let oh = littleRand(shiftx);
                let alt = littleRand(shifty);

                let xx = centerx + pos4[0] + oh;
                let yy = centery + pos4[1] + alt;

                p.strokeWeight(5);
                p.stroke(264, sat, 360, alpha);
                p.line(xx-40, yy, xx+40, yy);
              }

        // PAD --> YELLOW RECTANGLE
             if(pad.includes(tidal.s)) {
               let alpha
               if (tidal.cutoff) {
                 alpha = ((tidal.cutoff / maxfilter) * 360) + galpha
               }
               else {
                 alpha = 330
               }

               let oh = littleRand(shiftx);
               let alt = littleRand(shifty);

               let xx = centerx + pos5[0] + oh;
               let yy = centery + pos5[1] + alt;

               p.noStroke();
               p.fill(56, 360, 360, alpha);
               p.rect(xx, yy, 50, 35);
             }



             // FX --> WHITE CLUDS
                if(fx.includes(tidal.s)) {
                  let exten = 60;
                  let dens = 20;
                  let radius = 6;
                  let alpha
                  if (tidal.cutoff) {
                    alpha = ((tidal.cutoff / maxfilter) * 360) + galpha
                  }
                  else {
                    alpha = 330
                  }

                  let oh = littleRand(shiftx);
                  let alt = littleRand(shifty);

                  let xx = centerx + pos6[0] + oh;
                  let yy = centery + pos6[1] + alt;

                  for (var i = 0; i < dens; i++) {
                    let case1 = Math.random() * exten;
                    let case2 = Math.random() * exten;
                    p.noStroke();
                    p.fill(0, 0, 360, alpha);
                    p.circle(case1 + xx, yy - case2, radius);
                  }
                }

          // VOICE --> GREEN LINE
               if(voice.includes(tidal.s)) {
                 let alpha
                 if (tidal.cutoff) {
                   alpha = ((tidal.cutoff / maxfilter) * 360) + galpha
                 }
                 else {
                   alpha = 330
                 }
                 let sat
                 if (tidal.n <= 360) {
                   sat = Math.abs(((tidal.n%12)/12 * 160)) + 200
                 }
                 else {
                   sat = 200
                 }

                 let oh = littleRand(shiftx);
                 let alt = littleRand(shifty);

                 let xx = centerx + pos7[0] + oh;
                 let yy = centery + pos7[1] + alt;

                 p.strokeWeight(3);
                 p.stroke(138, sat, 360, alpha);
                 p.line(xx, yy-50, xx, yy+50);
               }



         // DRUMS --> BLUE RECTANGLE
              if(drums.includes(tidal.s)) {
                let alpha
                if (tidal.cutoff) {
                  alpha = ((tidal.cutoff / maxfilter) * 360) + galpha
                }
                else {
                  alpha = 330
                }

                let oh = littleRand(shiftx);
                let alt = littleRand(shifty);

                let xx = centerx + pos8[0] + oh;
                let yy = centery + pos8[1] + alt;

                let base = ((drums.indexOf(tidal.s) + 1)/drums.length)*5 + 20

                p.noStroke();
                p.fill(240, 280, 360, alpha);
                p.triangle(xx - base, yy, xx - (drums.indexOf(tidal.s)*20), yy - 70, xx + base, yy);
              }

        }) //oscmessage


// DARK LAYER
p.draw = () => {

if (start == 1) {
  p.noStroke();
  p.fill(0, 0, 0, 15)
  p.rect(0, 0, p.windowWidth, p.windowHeight);
  p.strokeWeight(2);
  p.stroke(255, 0, 255);
  p.line(0, p.windowHeight/2, p.windowWidth, p.windowHeight/2);
  p.line(p.windowWidth/4, 0, p.windowWidth/4, p.windowHeight);
  p.line((p.windowWidth/4)*2, 0, (p.windowWidth/4)*2, p.windowHeight);
  p.line((p.windowWidth/4)*3, 0, (p.windowWidth/4)*3, p.windowHeight);
  p.strokeWeight(50);
  p.stroke(250, 360, 360);
  p.line(0, 0, timewidget, 0)
  timewidget = timewidget + p.windowWidth/globaltime/60/framerate;
      }
  }  // draw


} //export function
