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
  var rows = 8; // number of "staves"
  const keys = ["piano", "solar", "tumbi", "key", "harp"]; // content of each category
  const pad = ["string", "pad"];
  const lead = ["lead"];
  const bass = ["fbass", "bass"];
  const fx = ["fx"];
  const mel = ["melody", "sally"];
  const voice = ["vc"];
  const drums = ["bd", "hh", "sn", "tom", "cr"];

  const order = [drums, pad, bass, keys, fx, mel, lead, voice] // low to high on the y axis

  const maxfilter = 10000 // maximum lpf filter value


// INIT
  var framerate = 20;
  var increment = (p.windowWidth/((globaltime * 60 / rows) * framerate));
  var xpoint = 0;
  var ypoint = Math.trunc(p.windowHeight / rows);
  var start = 0;
  var ynum = 0;
  var stave = p.windowHeight/rows;
  var quarterstave = stave/4
  var galpha = 120;


  p.setup = () => {
    p.smooth();
    p.frameRate(framerate);
    p.colorMode(p.HSB, 360);

    // CREATE STAVE
       setTimeout(() => {
         p.background(0, 0, 0);
         for (i = 0; i < rows; i++) {
             p.strokeWeight(2);
             p.stroke(0, 0, 360);
             p.line(0, ynum, p.windowWidth, ynum);
             ynum = ynum + stave;
           }
       })
    }


// DRAW
this.onOscMessage(message => {
      var tidalArgs = message.args;
      start = 1;

        // READER
        tidal = {};
          for(var i = 0; i < tidalArgs.length; i+=2){
            tidal[tidalArgs[i]] = tidalArgs[i+1]
          };
       console.log(tidalArgs);


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
                 let alt = (((order.indexOf(bass) + 1)/order.length) * stave) - 10
                 p.noStroke();
                 p.fill(220, sat, 360, alpha);
                 p.ellipse(xpoint, ypoint - alt, 20, 20);
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
                  let alt = (((order.indexOf(keys) + 1)/order.length) * stave) - 10
                  p.noStroke();
                  p.fill(27, sat, 360, alpha);
                  p.rect(xpoint, ypoint - alt, 15, 10);
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
                 let alt = (((order.indexOf(lead) + 1)/order.length) * stave) - 10
                 p.strokeWeight(4);
                 p.stroke(278, sat, 330, alpha);
                 p.line(xpoint, ypoint - alt, xpoint + 20, ypoint - alt);
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
                  let alt = (((order.indexOf(mel) + 1)/order.length) * stave) - 10
                  p.strokeWeight(4);
                  p.stroke(264, sat, 360, alpha);
                  p.line(xpoint, ypoint - alt, xpoint + 20, ypoint - alt);
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
                 let alt = (((order.indexOf(pad) + 1)/order.length) * stave) - 10
                 p.noStroke();
                 p.fill(56, 360, 360, alpha);
                 p.rect(xpoint, ypoint - alt, 25, 10);
               }


             // FX --> WHITE CLUDS
                if(fx.includes(tidal.s)) {
                  let exten = 12;
                  let dens = 10;
                  let radius = 3;
                  let alpha
                  if (tidal.cutoff) {
                    alpha = ((tidal.cutoff / maxfilter) * 360) + galpha
                  }
                  else {
                    alpha = 330
                  }
                  for (var i = 0; i < dens; i++) {
                    let case1 = Math.random() * exten;
                    let case2 = Math.random() * exten;
                    p.noStroke();
                    p.fill(0, 0, 360, alpha);
                    p.circle(case1 + xpoint, ypoint - case2, radius);
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
                 let alt = (((order.indexOf(voice) + 1)/order.length) * stave) - 10
                 p.strokeWeight(3);
                 p.stroke(138, sat, 360, alpha);
                 p.line(xpoint, ypoint - alt, xpoint, ypoint - alt + 20);
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
                let alt = (((order.indexOf(drums) + 1)/order.length) * stave) - 10
                let base = ((drums.indexOf(tidal.s) + 1)/drums.length)*5 + 2

                p.noStroke();
                p.fill(240, 280, 360, alpha);
                p.triangle(xpoint - base, ypoint - alt, xpoint - (drums.indexOf(tidal.s)*2), ypoint - alt - 20, xpoint + base, ypoint - alt);
              }

        }) // oscmessage


// POINTER INCREMENT
p.draw = () => {

if (start == 1) {
  xpoint = (xpoint + increment)%(p.windowWidth);
  if (xpoint < (increment)) {
    ypoint = ypoint + Math.trunc(stave);
      }
    }
  }  // draw


} // export function





























// view
