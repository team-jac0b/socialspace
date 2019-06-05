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

int currPrompt; // 0 - Summer, 1 - Adventure, 2 - Sound, 3 - Show, 4 - Flavor

int gatesWords;

int allenWords;

int gatesPeople = 0;

int allenPeople = 0;

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

int[] leftPositions = {287, 55, 72, 382, 246, 508, 75, 183, 113, 477, 368, 528, 76, 65, 193, 288, 344, 201};
int[] rightPositions = {681, 85, 843, 366, 772, 581, 862, 186, 685, 508, 618, 185, 874, 463, 1013, 91, 819, 287};

color[] colors = {#EBB2B5, #8ABABA, #687934, #DD9F4B, #5B75B2, #EADEBB, #CD6557, #A6B896, #EEDED4, #DE7EA8};

String[] prompts = {"What are your plans for \n          the summer?",
                    "What’s an interesting \n adventure you’ve been on?",
                    "What is the best sound \n in the world?",
                    "What is your favorite \n show or movie?",
                    "If you could be any ice cream  \nflavor,what would you be and why?"};

void setup() {
  size(1200, 800);
  //fullScreen(2);
  client = new MQTTClient(this);
  client.connect("mqtt://test.mosquitto.org");
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
  
  summerAnim = new Animation("Floatie/Floatie2Converted-", 90);
  adventureAnim = new Animation("Mountain/mountainsmall-", 100);
  soundAnim = new Animation("Music/MusicNotes4Converted-", 90);
  showAnim = new Animation("Movie/MovieReel2Converted-", 81);
  flavorAnim = new Animation( "Cream/ice-cream-small-", 91);
 
  font = createFont("Roboto-Bold.ttf", 32);
  textFont(font);

}

void keyPressed() {
    Word blankWord = new Word("", #000000, 0, 0, true);
    if (keyCode == DOWN) {
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
      //switch(currPrompt) {
      //  case 0:
      //    if (currPrompt == 0) {
      //      for (int i = 0; i < 9; i++) {
      //        currWords[i] = summerWords[i];
      //      }
      //    }
      //  case 1:
      //    for (int i = 0; i < 9; i++) {
      //      currWords[i] = adventureWords[i];
      //    }
      //  case 2: 
      //    for (int i = 0; i < 9; i++) {
      //      currWords[i] = soundWords[i];
      //    }
      //  case 3:
      //    for (int i = 0; i < 9; i++) {
      //      currWords[i] = showWords[i];
      //    }
      //  case 4:
      //    for (int i = 0; i < 9; i++) {
      //      currWords[i] = flavorWords[i];
      //    }
      //}
    }
}

void draw() {
  background(#000000);
  frameRate(30);
  // Draws the current prompt
  textSize(36);
  fill(#FFFFFF);
  switch(currPrompt) {
    case 0:
      textSize(36);
      fill(#FFFFFF);
      
      if (currPrompt == 0) {
        summerAnim.display(450, 350, 300, 225);
        text(prompts[currPrompt], 410, 320);
      }
    case 1:
      textSize(36);
      fill(#FFFFFF);
      
      if (currPrompt == 1) {
        text(prompts[currPrompt], 450, 300);
        adventureAnim.display(450, 350, 300, 225);
      }
    case 2:
      textSize(36);
      fill(#FFFFFF);
      
      if (currPrompt == 2) {
        text(prompts[currPrompt], 450, 300);
        soundAnim.display(440, 370, 300, 225);
      }
    case 3:
      textSize(36);
      fill(#FFFFFF);
      
      
      if (currPrompt == 3) {
        text(prompts[currPrompt], 450, 300);
        showAnim.display(440, 370, 300, 225);
      }
    case 4:
      textSize(36);
      fill(#FFFFFF);
      
      if (currPrompt == 4) {
        text(prompts[currPrompt], 450, 300);
        flavorAnim.display(450, 350, 300, 225);
      }
  }
  
  for (int i = 0; i < 9; i++) {
    currWordsGates[i].drawWord();
    currWordsAllen[i].drawWord();
  }

  //drawGrid();
  // Draws the labels for each installation
  textSize(12);
  fill(colors[2 * currPrompt]);
  text("Responses in", 51, 720);
  
  fill(colors[2 * currPrompt + 1]);
  text("Responses in", 1086, 720);

  textSize(24);
  fill(colors[2 * currPrompt]);
  text("Gates", 51, 750);
  
  fill(colors[2 * currPrompt + 1]);
  text("Allen", 1086, 750);
  
  image(bench, 147, 730, width/8, height/40);
  image(bench, 880, 730, width/8, height/40);
  
  for (int i = 0; i < gatesPeople; i++) {
    person.disableStyle();
    fill(colors[2 * currPrompt]);
    stroke(colors[2 * currPrompt]);
    shape(person, 165 + (i * 25), 700);
  }
  
  for (int i = 0; i < allenPeople; i++) {
    person.disableStyle();
    fill(colors[2 * currPrompt + 1]);
    stroke(colors[2 * currPrompt + 1]);
    shape(person, 890 + (i * 25), 700);
  }

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
    } else {
      this.topLeftX = leftPositions[x];
      this.topLeftY = leftPositions[y];
    }
    this.size = 26;
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
    this.size += 10;
  }

  // draws the word on the canvas with values stored in the fields
  void drawWord() {
    textSize(size);
    fill(drawColor);
    text(word, topLeftX, topLeftY);
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
