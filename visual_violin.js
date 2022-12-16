'use babel'

export default function(p) {


// CREATE WINDOW
  p.windowResized = () => {
    p.resizeCanvas(p.windowWidth, p.windowHeight);
    windowsize = p.windowHeight;
  }




// INIT
  var framerate = 20;

  // Recordings
  var lat = 90
  var dist = 15
  var xpoint = 900
  var ypoint = 740
  var colors = [[0, 0, 0], //RGB
                [0, 0, 0],
                [0, 0, 0],
                [0, 0, 0],
                [0, 0, 0]]

  //Plotter
  var lat2 = 200
  var xpoints = [250, 500, 750, 1000, 1250]
  var ypoints = [500, 300, 500, 300, 500]
  var colors2 = [190, 240, 310, 360, 57] // HUE



  p.setup = () => {
    p.smooth();
    p.frameRate(framerate);


// CREATE SLOT
   setTimeout(() => {

    p.background(0, 0, 0);

   })
  }


// DRAW AT MESSAGES
  this.onOscMessage(message => {
        var mess = message.args;

        messages = {};
          for(var i = 0; i < mess.length; i+=2){
            messages[mess[i]] = mess[i+1]
          };
       console.log(messages);



  // PLOTTER RECORDERS
     if(messages.recbuf){

       let buf = (messages.recbuf - 1)

       let rand1 = Math.random() * 255
       let rand2 = Math.random() * 100
       let rand3 = Math.random() * 255

       colors[buf] = [rand1, rand2, rand3]
     }


  // PLOTTER EVENTS
     if(messages.bufn){

       let bufn = (messages.bufn - 1)
       p.colorMode(p.HSB, 360)

       p.fill(colors2[bufn], 360, 250);
       p.ellipse(xpoints[bufn], ypoints[bufn], lat2, lat2);

      }

  })


 p.draw = () => {

   p.noStroke();
   p.fill(0, 0, 0, 30)
   p.rect(0, 0, p.windowWidth + 500, p.windowHeight);

   create_circles()

  }



   // FUNCTIONS
   function create_circles(){

     p.colorMode(p.RGB, 255)

     p.strokeWeight(6);
     p.stroke(255, 255, 255, 220);
     p.noFill();

     for (var i = 0; i < 5; i++) {
       p.ellipse(xpoint + lat/2 + (lat*i) + (dist*i), ypoint, lat, lat)
     };

     p.noStroke();

     for (var i = 0; i < 5; i++) {
       p.fill(colors[i][0], colors[i][1], colors[i][2], 255);
       p.ellipse(xpoint + lat/2 + (lat*i) + (dist*i), ypoint, lat, lat);
     }
   }

}
