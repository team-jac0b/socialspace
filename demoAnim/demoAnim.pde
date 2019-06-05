import mqtt.*;

MQTTClient client;
PFont font;

//color summer1 = #EBB2B5;
//color summer2 = #8ABABA;

//color sound1 = #5B75B2;
//color sound2 = #EADEBB;

//color show1 = #CD6557;
//color show2 = #A6B896;

//color adventure1 = #687934;
//color adventure2 = #DD9F4B;

//color flavor1 = #EEDED4;
//color flavor2 = #DE7EA8;

//color currColorL;
//color currColorR;

PImage floatie;
PImage icecream;
PImage mountain;
PImage movie;
PImage music;

PImage bench;
PShape person;

int currPrompt; // 0 - Summer, 1 - Adventure, 2 - Sound, 3 - Show, 4 - Flavor

int numWords;

int numWords2;

int numPeople = 0;

int numPeople2 = 0;

Animation summerAnim, adventureAnim, soundAnim, showAnim, flavorAnim;

Word[] currWords = new Word[9];
Word[] summerWords = new Word[9];
Word[] summerWords2 = new Word[9];
Word[] adventureWords = new Word[9];
Word[] soundWords = new Word[9];
Word[] showWords = new Word[9];
Word[] flavorWords = new Word[9];

int[] leftPositions = {287, 55, 72, 382, 246, 508, 75, 183, 113, 477, 368, 528, 76, 65, 193, 288, 344, 201};
int[] rightPositions = {681, 85, 843, 366, 772, 581, 862, 186, 685, 508, 618, 185, 874, 463, 1013, 91, 819, 287};

color[] colors = {#EBB2B5, #8ABABA, #687934, #DD9F4B, #5B75B2, #EADEBB, #CD6557, #A6B896, #EEDED4, #DE7EA8};

String[] prompts = {"What are your plans \n   for the summer?",
                    "What’s an interesting \n adventure you’ve been on?",
                    "What is the best sound \n in the world?",
                    "What is your favorite \n show or movie?",
                    "If you could be any ice cream  \nflavor,what would you be and why?"};

void setup() {
  size(1200, 800);
  //fullScreen(1);
  client = new MQTTClient(this);
  client.connect("mqtt://test.mosquitto.org");
  client.subscribe("uwsocialspacewords");
  client.subscribe("uwsocialspacenums");
  client.subscribe("uwsocialspacewords2");
  client.subscribe("uwsocialspacenums2");
  
  Word blankWord = new Word("", #000000, 0, 0);
  
  for (int i = 0; i < 9; i++) {
    currWords[i] = blankWord;
    summerWords[i] = blankWord;
    summerWords2[i] = blankWord;
    adventureWords[i] = blankWord;
    soundWords[i] = blankWord;
    showWords[i] = blankWord;
    flavorWords[i] = blankWord;
  }
  
  bench = loadImage("Bench.png");
  
  person = loadShape("Person.svg");
  
  floatie = loadImage("floatie.jpg");
  icecream = loadImage("icecream.jpg");
  mountain = loadImage("mountain.jpg");
  movie = loadImage("movie.jpg");
  music = loadImage("music.jpg");
  
  summerAnim = new Animation("Floatie/Floatie2Converted-", 90);
  //adventureAnim = new Animation("name here", 38);
  soundAnim = new Animation("Music/MusicNotes3Converted-", 90);
  showAnim = new Animation("Movie/MovieReel2Converted-", 81);
  //flavorAnim = new Animation("name here", 38);
  
  //summerWords = new ArrayList<Word>();
  //adventureWords = new ArrayList<Word>();
  //soundWords = new ArrayList<Word>();
  //showWords = new ArrayList<Word>();
  //flavorWords = new ArrayList<Word>();

  font = createFont("Roboto-Bold.ttf", 32);
  textFont(font);

  // Testing code
  //summerWords.add()
}

void keyPressed() {
    Word blankWord = new Word("", #000000, 0, 0);
    if (keyCode == DOWN) {
      numWords = 0;
      if (currPrompt != 4) {
        currPrompt++;
      } else {
        currPrompt = 0;
      }
      currWords = new Word[9];
      for (int i = 0; i < 9; i++) {
        currWords[i] = blankWord;
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
  // #4286f4
  background(#000000);
  frameRate(30);
  // Draws the current prompt
  textSize(36);
  fill(#FFFFFF);
  switch(currPrompt) {
    case 0:
      textSize(36);
      fill(#FFFFFF);
      text(prompts[currPrompt], 450, 300);
      if (currPrompt == 0) {
        summerAnim.display(450, 350, 300, 225);
      }
    case 1:
      textSize(36);
      fill(#FFFFFF);
      text(prompts[currPrompt], 450, 300);
      if (currPrompt == 1) {
        image(mountain, 479, 404, width / 10, height / 10);
      }
    case 2:
      textSize(36);
      fill(#FFFFFF);
      text(prompts[currPrompt], 450, 300);
      if (currPrompt == 2) {
        soundAnim.display(440, 370, 300, 225);
      }
    case 3:
      textSize(36);
      fill(#FFFFFF);
      text(prompts[currPrompt], 450, 300);
      
      if (currPrompt == 3) {
        showAnim.display(440, 370, 300, 225);
      }
    case 4:
      textSize(36);
      fill(#FFFFFF);
      text(prompts[currPrompt], 450, 300);
      if (currPrompt == 4) {
        image(icecream, 479, 404, width / 10, height / 10);
      }
  }
  for (int i = 0; i < 9; i++) {
    currWords[i].drawWord();
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
  
  for (int i = 0; i < numPeople; i++) {
    person.disableStyle();
    fill(colors[2 * currPrompt]);
    stroke(colors[2 * currPrompt]);
    shape(person, 165 + (i * 25), 700);
  }
  
  for (int i = 0; i < numPeople2; i++) {
    person.disableStyle();
    fill(colors[2 * currPrompt + 1]);
    stroke(colors[2 * currPrompt + 1]);
    shape(person, 890 + (i * 25), 700);
  }

  //println(mouseX + ", " + mouseY + "\n");
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
  if (topic.equals("uwsocialspacenums")) {
    numPeople = int(new String(payload));
    if (numPeople > 5) {
      numPeople = 5;
    }
  } else if (topic.equals("uwsocialspacenums2")) {
    numPeople2 = int(new String(payload));
    if (numPeople2 > 5) {
      numPeople2 = 5;
    }
  } else if (topic.equals("uwsocialspacewords")) {
    switch(currPrompt) {
      case 0:
        currWords[numWords] = new Word(new String(payload), colors[2 * currPrompt], numWords * 2, (numWords * 2) + 1);
        summerWords[numWords] = new Word(new String(payload), colors[2 * currPrompt], numWords * 2, (numWords * 2) + 1);
      case 1:
        currWords[numWords] = new Word(new String(payload), colors[2 * currPrompt], numWords * 2, (numWords * 2) + 1);
        adventureWords[numWords] = new Word(new String(payload), colors[2 * currPrompt], numWords * 2, (numWords * 2) + 1);
      case 2:
        currWords[numWords] = new Word(new String(payload), colors[2 * currPrompt], numWords * 2, (numWords * 2) + 1);
        soundWords[numWords] = new Word(new String(payload), colors[2 * currPrompt], numWords * 2, (numWords * 2) + 1);
      case 3:
        currWords[numWords] = new Word(new String(payload), colors[2 * currPrompt], numWords * 2, (numWords * 2) + 1);
        showWords[numWords] = new Word(new String(payload), colors[2 * currPrompt], numWords * 2, (numWords * 2) + 1);
      case 4:
        currWords[numWords] = new Word(new String(payload), colors[2 * currPrompt], numWords * 2, (numWords * 2) + 1);
        flavorWords[numWords] = new Word(new String(payload), colors[2 * currPrompt], numWords * 2, (numWords * 2) + 1);
    }
    //println(numWords);
    if (numWords != 8) {
      numWords++;
    } else {
      numWords = 0;
    }
  } else if (topic.equals("uwsocialspacewords2")) {
        summerWords2[numWords] = new Word(new String(payload), colors[2 * currPrompt + 1], numWords * 2, (numWords * 2) + 1);
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

  Word(String word, color drawColor, int x, int y) {
    this.word = word;
    this.drawColor = drawColor;
    this.occurrences = 1;
    if (drawColor == colors[2 * currPrompt + 1]) {
      this.topLeftX = rightPositions[x];
      this.topLeftY = rightPositions[y];
    } else {
      this.topLeftX = leftPositions[x];
      this.topLeftY = leftPositions[y];
    }
    this.size = 96;
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
    topLeftX = 50;
    topLeftY = 50;
    size = 20;
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
