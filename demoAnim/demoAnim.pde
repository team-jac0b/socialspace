import mqtt.*;

MQTTClient client;
PFont font;

PImage floatie;
PImage icecream;
PImage mountain;
PImage movie;
PImage music;

PImage bench;
PShape person;

PImage bSummer1A;
PImage bSummer2A;
PImage bSummer3A;
PImage bSummer4A;
PImage bSummer5A;

PImage bSummer1B;
PImage bSummer2B;
PImage bSummer3B;
PImage bSummer4B;
PImage bSummer5B;

PImage bAdv1A;
PImage bAdv2A;
PImage bAdv3A;
PImage bAdv4A;
PImage bAdv5A;

PImage bAdv1B;
PImage bAdv2B;
PImage bAdv3B;
PImage bAdv4B;
PImage bAdv5B;

PImage bSound1A;
PImage bSound2A;
PImage bSound3A;
PImage bSound4A;
PImage bSound5A;

PImage bSound1B;
PImage bSound2B;
PImage bSound3B;
PImage bSound4B;
PImage bSound5B;

PImage bShow1A;
PImage bShow2A;
PImage bShow3A;
PImage bShow4A;
PImage bShow5A;

PImage bShow1B;
PImage bShow2B;
PImage bShow3B;
PImage bShow4B;
PImage bShow5B;

PImage bCream1A;
PImage bCream2A;
PImage bCream3A;
PImage bCream4A;
PImage bCream5A;

PImage bCream1B;
PImage bCream2B;
PImage bCream3B;
PImage bCream4B;
PImage bCream5B;

int currPrompt; // 0 - Summer, 1 - Adventure, 2 - Sound, 3 - Show, 4 - Flavor

int gatesWords;

int allenWords;

int gatesPeople = 0;

int allenPeople = 0;

float scale = 2.0;

Timer t;

Animation summerAnim, adventureAnim, soundAnim, showAnim, flavorAnim;

Word[] currWordsGates = new Word[9];
Word[] currWordsAllen = new Word[9];
Word[] summerWordsGates = new Word[9];
Word[] summerWordsAllen = new Word[9];
Word[] adventureWordsGates = new Word[9];
Word[] adventureWordsAllen = new Word[9];
Word[] soundWordsGates = new Word[9];
Word[] soundWordsAllen = new Word[9];
Word[] showWordsGates = new Word[9];
Word[] showWordsAllen = new Word[9];
Word[] flavorWordsGates = new Word[9];
Word[] flavorWordsAllen = new Word[9];

int[] leftPositions = {287, 55, 72, 382, 246, 508, 75, 183, 113, 457, 200, 568, 176, 125, 193, 318, 130, 251};
int[] rightPositions = {681, 85, 743, 366, 772, 581, 862, 186, 685, 508, 618, 215, 874, 463, 843, 91, 819, 287};

color[] colors = {#E08287, #4FB4B4, #87A138, #DD9F4B, #3972D3, #C9AE60, #CD6557, #3AB698, #CE7C49, #E56FA3};

String[] prompts = {"What are your plans for \n          the summer?",
                    "What’s an interesting adventure \n              you’ve been on?",
                    "What is the best sound \n         in the world?",
                    "What is your favorite \n     show or movie?",
                    "If you could be any ice cream flavor, \n       what would you be and why?"};

void setup() {
  //size(1200, 800);
  fullScreen(2);
  client = new MQTTClient(this);
  client.connect("mqtt://c4cc8af9:959dcc8e063b9572@broker.shiftr.io");
  client.subscribe("uwsocialspacewordsAllen");
  client.subscribe("uwsocialspacenumsAllen");
  client.subscribe("uwsocialspacewordsGates");
  client.subscribe("uwsocialspacenumsGates");
  
  Word blankWord = new Word("", #000000, 0, 0, true);
  
  for (int i = 0; i < 9; i++) {
    currWordsGates[i] = blankWord;
    currWordsAllen[i] = blankWord;
    summerWordsGates[i] = blankWord;
    summerWordsAllen[i] = blankWord;
    adventureWordsGates[i] = blankWord;
    adventureWordsAllen[i] = blankWord;
    soundWordsGates[i] = blankWord;
    soundWordsAllen[i] = blankWord;
    showWordsGates[i] = blankWord;
    showWordsAllen[i] = blankWord;
    flavorWordsGates[i] = blankWord;
    flavorWordsAllen[i] = blankWord;
  }
  
  bench = loadImage("Bench.png");
  
  person = loadShape("Person.svg");
  
  bSummer1A = loadImage("benchsummer/summer1@2x.png");
  bSummer2A = loadImage("benchsummer/summer2@2x.png");
  bSummer3A = loadImage("benchsummer/summer3@2x.png");
  bSummer4A = loadImage("benchsummer/summer4@2x.png");
  bSummer5A = loadImage("benchsummer/summer5@2x.png");
  
  bAdv1A = loadImage("benchAdv2/adventure1a@2x.png");
  bAdv2A = loadImage("benchAdv2/adventure2a@2x.png");
  bAdv3A = loadImage("benchAdv2/adventure3a@2x.png");
  bAdv4A = loadImage("benchAdv2/adventure4a@2x.png");
  bAdv5A = loadImage("benchAdv2/adventure5a@2x.png");
  
  bSound1A = loadImage("benchSound/sound1a@2x.png");
  bSound2A = loadImage("benchSound/sound2a@2x.png");
  bSound3A = loadImage("benchSound/sound3a@2x.png");
  bSound4A = loadImage("benchSound/sound4a@2x.png");
  bSound5A = loadImage("benchSound/sound5a@2x.png");

  bShow1A = loadImage("benchShow/movie1a@2x.png");
  bShow2A = loadImage("benchShow/movie2a@2x.png");
  bShow3A = loadImage("benchShow/movie3a@2x.png");
  bShow4A = loadImage("benchShow/movie4a@2x.png");
  bShow5A = loadImage("benchShow/movie5a@2x.png");
  
  bCream1A = loadImage("benchCream/icecream1a@2x.png");
  bCream2A = loadImage("benchCream/icecream2a@2x.png");
  bCream3A = loadImage("benchCream/icecream3a@2x.png");
  bCream4A = loadImage("benchCream/icecream4a@2x.png");
  bCream5A = loadImage("benchCream/icecream5a@2x.png");
  
  // ALLEN ISH
  
  bSummer1B = loadImage("benchsummer2/summer1a@2x.png");
  bSummer2B = loadImage("benchsummer2/summer2a@2x.png");
  bSummer3B = loadImage("benchsummer2/summer3a@2x.png");
  bSummer4B = loadImage("benchsummer2/summer4a@2x.png");
  bSummer5B = loadImage("benchsummer2/summer5a@2x.png");
  
  bAdv1B = loadImage("benchAdv/adventure1@2x.png");
  bAdv2B = loadImage("benchAdv/adventure2@2x.png");
  bAdv3B = loadImage("benchAdv/adventure3@2x.png");
  bAdv4B = loadImage("benchAdv/adventure4@2x.png");
  bAdv5B = loadImage("benchAdv/adventure5@2x.png");
  
  bSound1B = loadImage("benchSound2/sound1@2x.png");
  bSound2B = loadImage("benchSound2/sound2@2x.png");
  bSound3B = loadImage("benchSound2/sound3@2x.png");
  bSound4B = loadImage("benchSound2/sound4@2x.png");
  bSound5B = loadImage("benchSound2/sound5@2x.png");

  bShow1B = loadImage("benchShow2/movie1@2x.png");
  bShow2B = loadImage("benchShow2/movie2@2x.png");
  bShow3B = loadImage("benchShow2/movie3@2x.png");
  bShow4B = loadImage("benchShow2/movie4@2x.png");
  bShow5B = loadImage("benchShow2/movie5@2x.png");
  
  bCream1B = loadImage("benchCream2/iceream1@2x.png");
  bCream2B = loadImage("benchCream2/iceream2@2x.png");
  bCream3B = loadImage("benchCream2/iceream3@2x.png");
  bCream4B = loadImage("benchCream2/iceream4@2x.png");
  bCream5B = loadImage("benchCream2/iceream5@2x.png");
  
  summerAnim = new Animation("Floatie/Floatie2Converted-", 90);
  adventureAnim = new Animation("Mountain/mountainsmall-", 100);
  soundAnim = new Animation("Music/MusicNotes4Converted-", 90);
  showAnim = new Animation("Movie/MovieReel2Converted-", 81);
  flavorAnim = new Animation( "Cream/ice-cream-small-", 91);
 
  font = createFont("Roboto-Bold.ttf", 32);
  textFont(font);
  
  t = new Timer();
  t.start();
}

void keyPressed() {
    Word blankWord = new Word("", #000000, 0, 0, true);
    if (keyCode == DOWN) {
      t.stop();
      gatesWords = 0;
      allenWords = 0;
      if (currPrompt != 4) {
        currPrompt++;
      } else {
        currPrompt = 0;
      }
      currWordsGates = new Word[9];
      currWordsAllen = new Word[9];
      for (int i = 0; i < 9; i++) {
        currWordsGates[i] = blankWord;
        currWordsAllen[i] = blankWord;
      }
      t.start();
      
    }
}

void draw() {
  background(#000000);
  frameRate(30);
  textSize(32);
  //text(t.minute() + ":" + t.second(), 100, 100);
  stroke(#FFFFFF);
  strokeWeight(16);
  fill(#FFFFFF);
  text("Next Prompt:", 80, 45);
  line(300, 35, 2300 - (((float)t.getElapsedTime() / 120000) * 2000) , 35);
  // Draws the current prompt
  textSize(72);
  fill(#FFFFFF);
  if (t.minute() >= 2) {
    t.stop();
    Word blankWord = new Word("", #000000, 0, 0, true);
    gatesWords = 0;
    allenWords = 0;
    if (currPrompt != 4) {
      currPrompt++;
    } else {
      currPrompt = 0;
    }
    currWordsGates = new Word[9];
    currWordsAllen = new Word[9];
    for (int i = 0; i < 9; i++) {
      currWordsGates[i] = blankWord;
      currWordsAllen[i] = blankWord;
    }
    t.start();
  }
  switch(currPrompt) {
    case 0:
      textSize(72);
      fill(#FFFFFF);
      
      if (currPrompt == 0) {
        summerAnim.display(490 * scale, 350 * scale, 300 * scale, 225 * scale);
        text(prompts[currPrompt], 445 * scale, 320 * scale);
      }
    case 1:
      textSize(72);
      fill(#FFFFFF);
      
      if (currPrompt == 1) {
        adventureAnim.display(480 * scale, 345 * scale, 320 * scale, 225 * scale);
        text(prompts[currPrompt], 390 * scale, 320 * scale);
      }
    case 2:
      textSize(72);
      fill(#FFFFFF);
      
      if (currPrompt == 2) {
        soundAnim.display(470 * scale, 350 * scale, 300 * scale, 225 * scale);
        text(prompts[currPrompt], 450 * scale, 320 * scale);

      }
    case 3:
      textSize(72);
      fill(#FFFFFF);
      
      
      if (currPrompt == 3) {
        showAnim.display(480 * scale, 390 * scale, 300 * scale * 0.8, 225 * scale * 0.8);
        text(prompts[currPrompt], 470 * scale, 320 * scale);
        
      }
    case 4:
      textSize(72);
      fill(#FFFFFF);
      
      if (currPrompt == 4) {
        flavorAnim.display(520 * scale, 400 * scale, 300 * scale * 0.8, 225 * scale * 0.8);
        text(prompts[currPrompt], 350 * scale, 320 * scale);
        
      }
  }
  
  for (int i = 0; i < 9; i++) {
    currWordsGates[i].drawWord();
    currWordsAllen[i].drawWord();
  }

  //drawGrid();
  // Draws the labels for each installation
  textSize(24);
  fill(colors[2 * currPrompt]);
  text("Responses in", 51 * scale, 720 * scale);
  
  fill(colors[2 * currPrompt + 1]);
  text("Responses in", 1150 * scale, 720 * scale);

  textSize(48);
  fill(colors[2 * currPrompt]);
  text("Gates", 55 * scale, 750 * scale);
  
  fill(colors[2 * currPrompt + 1]);
  text("Allen", 1160 * scale, 750 * scale);
  
  if (currPrompt == 0) {
    if (gatesPeople == 0) {
      image(bench, 147 * scale, 730 * scale , width/8, height/40);
    } else if (gatesPeople == 1 && currPrompt == 0) {
      image(bSummer1A, 80 * scale, 655 * scale , width/4, height/8);
    } else if (gatesPeople == 2 && currPrompt == 0) {
      image(bSummer2A, 80 * scale, 655 * scale , width/4, height/8);
    } else if (gatesPeople == 3 && currPrompt == 0) {
      image(bSummer3A, 80 * scale, 655 * scale , width/4, height/8);
    } else if (gatesPeople == 4 && currPrompt == 0) {
      image(bSummer4A, 80 * scale, 655 * scale , width/4, height/8);
    } else if (gatesPeople == 5 && currPrompt == 0) {
      image(bSummer5A, 80 * scale, 655 * scale , width/4, height/8);
    }
  }
  
  if (currPrompt == 0) {
    if (allenPeople == 0) {
      image(bench, 965 * scale, 730 * scale , width/8, height/40);
    } else if (allenPeople == 1 && currPrompt == 0) {
      image(bSummer1B, 885 * scale, 655 * scale , width/4, height/8);
    } else if (allenPeople == 2 && currPrompt == 0) {
      image(bSummer2B, 885 * scale, 655 * scale , width/4, height/8);
    } else if (allenPeople == 3 && currPrompt == 0) {
      image(bSummer3B, 885 * scale, 655 * scale , width/4, height/8);
    } else if (allenPeople == 4 && currPrompt == 0) {
      image(bSummer4B, 885 * scale, 655 * scale , width/4, height/8);
    } else if (allenPeople == 5 && currPrompt == 0) {
      image(bSummer5B, 885 * scale, 655 * scale , width/4, height/8);
    }
  }
  
  if (currPrompt == 1) {
    if (gatesPeople == 0) {
      image(bench, 147 * scale, 730 * scale , width/8, height/40);
    } else if (gatesPeople == 1 && currPrompt == 1) {
      image(bAdv1A, 80 * scale, 655 * scale , width/4, height/8);
    } else if (gatesPeople == 2 && currPrompt == 1) {
      image(bAdv2A, 80 * scale, 655 * scale , width/4, height/8);
    } else if (gatesPeople == 3 && currPrompt == 1) {
      image(bAdv3A, 80 * scale, 655 * scale , width/4, height/8);
    } else if (gatesPeople == 4 && currPrompt == 1) {
      image(bAdv4A, 80 * scale, 655 * scale , width/4, height/8);
    } else if (gatesPeople == 5 && currPrompt == 1) {
      image(bAdv5A, 80 * scale, 655 * scale , width/4, height/8);
    }
  }
  
  if (currPrompt == 1) {
    if (allenPeople == 0) {
      image(bench, 965 * scale, 730 * scale , width/8, height/40);
    } else if (allenPeople == 1 && currPrompt == 1) {
      image(bAdv1B, 885 * scale, 655 * scale , width/4, height/8);
    } else if (allenPeople == 2 && currPrompt == 1) {
      image(bAdv2B, 885 * scale, 655 * scale , width/4, height/8);
    } else if (allenPeople == 3 && currPrompt == 1) {
      image(bAdv3B, 885 * scale, 655 * scale , width/4, height/8);
    } else if (allenPeople == 4 && currPrompt == 1) {
      image(bAdv4B, 885 * scale, 655 * scale , width/4, height/8);
    } else if (allenPeople == 5 && currPrompt == 1) {
      image(bAdv5B, 885 * scale, 655 * scale , width/4, height/8);
    }
  }
  
  if (currPrompt == 2) {
    if (gatesPeople == 0) {
      image(bench, 147 * scale, 730 * scale , width/8, height/40);
    } else if (gatesPeople == 1 && currPrompt == 2) {
      image(bSound1A, 80 * scale, 655 * scale , width/4, height/8);
    } else if (gatesPeople == 2 && currPrompt == 2) {
      image(bSound2A, 80 * scale, 655 * scale , width/4, height/8);
    } else if (gatesPeople == 3 && currPrompt == 2) {
      image(bSound3A, 80 * scale, 655 * scale , width/4, height/8);
    } else if (gatesPeople == 4 && currPrompt == 2) {
      image(bSound4A, 80 * scale, 655 * scale , width/4, height/8);
    } else if (gatesPeople == 5 && currPrompt == 2) {
      image(bSound5A, 80 * scale, 655 * scale , width/4, height/8);
    }
  }
  
  if (currPrompt == 2) {
    if (allenPeople == 0) {
      image(bench, 965 * scale, 730 * scale , width/8, height/40);
    } else if (allenPeople == 1 && currPrompt == 2) {
      image(bSound1B, 885 * scale, 655 * scale , width/4, height/8);
    } else if (allenPeople == 2 && currPrompt == 2) {
      image(bSound2B, 885 * scale, 655 * scale , width/4, height/8);
    } else if (allenPeople == 3 && currPrompt == 2) {
      image(bSound3B, 885 * scale, 655 * scale , width/4, height/8);
    } else if (allenPeople == 4 && currPrompt == 2) {
      image(bSound4B, 885 * scale, 655 * scale , width/4, height/8);
    } else if (allenPeople == 5 && currPrompt == 2) {
      image(bSound5B, 885 * scale, 655 * scale , width/4, height/8);
    }
  }
  
   if (currPrompt == 3) {
    if (gatesPeople == 0) {
      image(bench, 147 * scale, 730 * scale , width/8, height/40);
    } else if (gatesPeople == 1 && currPrompt == 3) {
      image(bShow1A, 80 * scale, 655 * scale , width/4, height/8);
    } else if (gatesPeople == 2 && currPrompt == 3) {
      image(bShow2A, 80 * scale, 655 * scale , width/4, height/8);
    } else if (gatesPeople == 3 && currPrompt == 3) {
      image(bShow3A, 80 * scale, 655 * scale , width/4, height/8);
    } else if (gatesPeople == 4 && currPrompt == 3) {
      image(bShow4A, 80 * scale, 655 * scale , width/4, height/8);
    } else if (gatesPeople == 5 && currPrompt == 3) {
      image(bShow5A, 80 * scale, 655 * scale , width/4, height/8);
    }
  }
  
    
  if (currPrompt == 3) {
    if (allenPeople == 0) {
      image(bench, 965 * scale, 730 * scale , width/8, height/40);
    } else if (allenPeople == 1 && currPrompt == 3) {
      image(bShow1B, 885 * scale, 655 * scale , width/4, height/8);
    } else if (allenPeople == 2 && currPrompt == 3) {
      image(bShow2B, 885 * scale, 655 * scale , width/4, height/8);
    } else if (allenPeople == 3 && currPrompt == 3) {
      image(bShow3B, 885 * scale, 655 * scale , width/4, height/8);
    } else if (allenPeople == 4 && currPrompt == 3) {
      image(bShow4B, 885 * scale, 655 * scale , width/4, height/8);
    } else if (allenPeople == 5 && currPrompt == 3) {
      image(bShow5B, 885 * scale, 655 * scale , width/4, height/8);
    }
  }
  
  if (currPrompt == 4) {
    if (gatesPeople == 0) {
      image(bench, 147 * scale, 730 * scale , width/8, height/40);
    } else if (gatesPeople == 1 && currPrompt == 4) {
      image(bCream1A, 80 * scale, 655 * scale , width/4, height/8);
    } else if (gatesPeople == 2 && currPrompt == 4) {
      image(bCream2A, 80 * scale, 655 * scale , width/4, height/8);
    } else if (gatesPeople == 3 && currPrompt == 4) {
      image(bCream3A, 80 * scale, 655 * scale , width/4, height/8);
    } else if (gatesPeople == 4 && currPrompt == 4) {
      image(bCream4A, 80 * scale, 655 * scale , width/4, height/8);
    } else if (gatesPeople == 5 && currPrompt == 4) {
      image(bCream5A, 80 * scale, 655 * scale , width/4, height/8);
    }
  }
  
  if (currPrompt == 4) {
    if (allenPeople == 0) {
      image(bench, 965 * scale, 730 * scale , width/8, height/40);
    } else if (allenPeople == 1 && currPrompt == 4) {
      image(bCream1B, 885 * scale, 655 * scale , width/4, height/8);
    } else if (allenPeople == 2 && currPrompt == 4) {
      image(bCream2B, 885 * scale, 655 * scale , width/4, height/8);
    } else if (allenPeople == 3 && currPrompt == 4) {
      image(bCream3B, 885 * scale, 655 * scale , width/4, height/8);
    } else if (allenPeople == 4 && currPrompt == 4) {
      image(bCream4B, 885 * scale, 655 * scale , width/4, height/8);
    } else if (allenPeople == 5 && currPrompt == 4) {
      image(bCream5B, 885 * scale, 655 * scale , width/4, height/8);
    }
  }
  
  
  //image(bench, 147 * scale, 730 * scale , width/8, height/40);
  //image(bench, 965 * scale, 730 * scale, width/8, height/40);
  
  //for (int i = 0; i < gatesPeople; i++) {
  //  person.disableStyle();
  //  fill(colors[2 * currPrompt]);
  //  stroke(colors[2 * currPrompt]);
  //  shape(person, (165 + (i * 27)) * scale, 700 * scale, 30, 100);
  //}
  
  //for (int i = 0; i < allenPeople; i++) {
  //  person.disableStyle();
  //  fill(colors[2 * currPrompt + 1]);
  //  stroke(colors[2 * currPrompt + 1]);
  //  shape(person, (985 + (i * 27)) * scale, 700 * scale, 30, 100);
  //}

  //println(mouseX + ", " + mouseY + "\n");
  // 340, 250    850, 550
}

// Draws a grid for help with seeing how wide text is
void drawGrid() {
  fill(#FFFFFF);
  stroke(#FFFFFF);
  for (int i = 0; i < 800; i+=10) {
    line(0, i, 1200, i);
  }
  for (int i = 0; i < 1200; i+=10) {
    line(i, 0, i, 800);
  }
}

void mouseClicked() {
  println(mouseX + ", " + mouseY + "\n");
}

void messageReceived(String topic, byte[] payload) {
  println("new message: " + topic + " - " + new String(payload));
  if (topic.equals("uwsocialspacenumsGates")) {
    gatesPeople = int(new String(payload));
    if (gatesPeople > 5) {
      gatesPeople = 5;
    }
  } else if (topic.equals("uwsocialspacenumsAllen")) {
    allenPeople = int(new String(payload));
    if (allenPeople > 5) {
      allenPeople = 5;
    }
  } else if (topic.equals("uwsocialspacewordsGates")) {
    Boolean notDuplicate = true;
    for (Word w: currWordsGates) {
      String input = new String(payload);
      if (input.equals(w.word)) {
        w.updateSize();
        notDuplicate = false;
      }
    }
    if (notDuplicate) {
      switch(currPrompt) {
        case 0:
          currWordsGates[gatesWords] = new Word(new String(payload), colors[2 * currPrompt], gatesWords * 2, (gatesWords * 2) + 1, true);
          summerWordsGates[gatesWords] = new Word(new String(payload), colors[2 * currPrompt], gatesWords * 2, (gatesWords * 2) + 1, true);
        case 1:
          currWordsGates[gatesWords] = new Word(new String(payload), colors[2 * currPrompt], gatesWords * 2, (gatesWords * 2) + 1, true);
          adventureWordsGates[gatesWords] = new Word(new String(payload), colors[2 * currPrompt], gatesWords * 2, (gatesWords * 2) + 1, true);
        case 2:
          currWordsGates[gatesWords] = new Word(new String(payload), colors[2 * currPrompt], gatesWords * 2, (gatesWords * 2) + 1, true);
          soundWordsGates[gatesWords] = new Word(new String(payload), colors[2 * currPrompt], gatesWords * 2, (gatesWords * 2) + 1, true);
        case 3:
          currWordsGates[gatesWords] = new Word(new String(payload), colors[2 * currPrompt], gatesWords * 2, (gatesWords * 2) + 1, true);
          showWordsGates[gatesWords] = new Word(new String(payload), colors[2 * currPrompt], gatesWords * 2, (gatesWords * 2) + 1, true);
        case 4:
          currWordsGates[gatesWords] = new Word(new String(payload), colors[2 * currPrompt], gatesWords * 2, (gatesWords * 2) + 1, true);
          flavorWordsGates[gatesWords] = new Word(new String(payload), colors[2 * currPrompt], gatesWords * 2, (gatesWords * 2) + 1, true);
      }
      if (gatesWords != 8) {
        gatesWords++;
      } else {
        gatesWords = 0;
      }
    }
  } else if (topic.equals("uwsocialspacewordsAllen")) {
    Boolean notDuplicate = true;
    for (Word w: currWordsGates) {
      String input = new String(payload);
      if (input.equals(w.word)) {
        w.updateSize();
        notDuplicate = false;
      }
    }
    if (notDuplicate) {
     switch(currPrompt) {
      case 0:
        currWordsAllen[allenWords] = new Word(new String(payload), colors[2 * currPrompt + 1], allenWords * 2, (allenWords * 2) + 1, false);
        summerWordsAllen[allenWords] = new Word(new String(payload), colors[2 * currPrompt + 1], allenWords * 2, (allenWords * 2) + 1, false);
      case 1:
        currWordsAllen[allenWords] = new Word(new String(payload), colors[2 * currPrompt + 1], allenWords * 2, (allenWords * 2) + 1, false);
        adventureWordsAllen[allenWords] = new Word(new String(payload), colors[2 * currPrompt + 1], allenWords * 2, (allenWords * 2) + 1, false);
      case 2:
        currWordsAllen[allenWords] = new Word(new String(payload), colors[2 * currPrompt + 1], allenWords * 2, (allenWords * 2) + 1, false);
        soundWordsAllen[allenWords] = new Word(new String(payload), colors[2 * currPrompt + 1], allenWords * 2, (allenWords * 2) + 1, false);
      case 3:
        currWordsAllen[allenWords] = new Word(new String(payload), colors[2 * currPrompt + 1], allenWords * 2, (allenWords * 2) + 1, false);
        showWordsAllen[allenWords] = new Word(new String(payload), colors[2 * currPrompt + 1], allenWords * 2, (allenWords * 2) + 1, false);
      case 4:
        currWordsAllen[allenWords] = new Word(new String(payload), colors[2 * currPrompt + 1], allenWords * 2, (allenWords * 2) + 1, false);
        flavorWordsAllen[allenWords] = new Word(new String(payload), colors[2 * currPrompt + 1], allenWords * 2, (allenWords * 2) + 1, false);
      }
      if (allenWords != 8) {
        allenWords++;
      } else {
        allenWords = 0;
      }
    }
  } else {
    // Do nothing
  }
}

// Class for a word

class Word {
  String word;
  int occurrences;
  int topLeftX;
  int topLeftY;
  int botRightX;
  int botRightY;
  int size;
  int yModifier;
  int xModifier;
  color drawColor;
  Boolean isGates;

  Word(String word, color drawColor, int x, int y, Boolean isGates) {
    this.word = word;
    this.drawColor = drawColor;
    this.occurrences = 1;
    this.isGates = isGates;
    if (!isGates) {
      this.topLeftX = rightPositions[x];
      this.topLeftY = rightPositions[y];
      this.xModifier = 500;
    } else {
      this.topLeftX = leftPositions[x];
      this.topLeftY = leftPositions[y];
      this.xModifier = 0;
    }
    this.yModifier = 0;
    this.size = 52;
    //updateSize();
  }

  Word(String word, int occurrences, color drawColor) {
    this.word = word;
    this.drawColor = drawColor;
    this.occurrences = occurrences;
    updateSize();
  }

  void updateSize() {
    // Update the position markers for the word based on what the word is + num of ocurrences
    //topLeftX = 50;
    //topLeftY = 50;
    this.size += 20;
    this.yModifier += 10;
  }

  // draws the word on the canvas with values stored in the fields
  void drawWord() {
    textSize(size);
    fill(drawColor);
    text(word, topLeftX * 2 + xModifier, topLeftY * 2 + yModifier);
  }
}

// Class for animating a sequence of GIFs

class Animation {
  PImage[] images;
  int imageCount;
  int frame;

  Animation(String imagePrefix, int count) {
    imageCount = count;
    images = new PImage[imageCount];

    for (int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = imagePrefix + i + ".jpg";
      images[i] = loadImage(filename);
    }
  }

  void display(float xpos, float ypos, float scaleX, float scaleY) {
    frame = (frame+1) % imageCount;
    image(images[frame], xpos, ypos, scaleX, scaleY);
  }

  int getWidth() {
    return images[0].width;
  }
}


// This class based on code found here: http://www.goldb.org/stopwatchjava.html
class Timer {
  int startTime = 0, stopTime = 0, maxTime = 120000;
  boolean running = false;  
  
    void start() {
        startTime = millis();
        running = true;
    }
    void stop() {
        stopTime = millis();
        running = false;
    }
    int getElapsedTime() {
        int elapsed;
        if (running) {
             elapsed = (millis() - startTime);
        }
        else {
            elapsed = (stopTime - startTime);
        }
        return elapsed;
    }
    int second() {
      return (getElapsedTime() / 1000) % 60;
    }
    int minute() {
      return (getElapsedTime() / (1000*60)) % 60;
    }
    int hour() {
      return (getElapsedTime() / (1000*60*60)) % 24;
    }
}
