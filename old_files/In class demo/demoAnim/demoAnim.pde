import mqtt.*;

MQTTClient client;
PFont font;

color summer1 = #EBB2B5;
color summer2 = #8ABABA;

color sound1 = #5B75B2;
color sound2 = #EADEBB;

color show1 = #CD6557;
color show2 = #A6B896;

color adventure1 = #687934;
color adventure2 = #DD9F4B;

color flavor1 = #EEDED4;
color flavor2 = #DE7EA8;

color currColorL;
color currColorR;


String saved = "";
String typing = "";

int currPrompt; // 0 - Summer, 1 - Adventure, 2 - Sound, 3 - Show, 4 - Flavor

int numWords;

Animation summerAnim, adventureAnim, soundAnim, showAnim, flavorAnim;

//ArrayList<Word> summerWords;
//ArrayList<Word> adventureWords;
//ArrayList<Word> soundWords;
//ArrayList<Word> showWords;
//ArrayList<Word> flavorWords;

  Word[] summerWords = new Word[9];
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
                    "What is your favorite \n show or movie to Netflix?",
                    "If you could be any ice cream  \nflavor,what would you be and why?"};

void setup() {
  size(1200, 800);

  client = new MQTTClient(this);
  client.connect("mqtt://test.mosquitto.org");
  client.subscribe("uwsocialspacewords");
  client.subscribe("uwsocialspacenums");
  
  Word blankWord = new Word("", #000000, 0, 0);
  
  for (int i = 0; i < 9; i++) {
    summerWords[i] = blankWord;
  }
  
  //summerAnim = new Animation("Floatie1Converted-", 180);
  //adventureAnim = new Animation("name here", 38);
  //soundAnim = new Animation("name here", 38);
  //showAnim = new Animation("name here", 38);
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
    if (keyCode == DOWN) {
      numWords = 0;
      if (currPrompt != 4) {
        currPrompt++;
      } else {
        currPrompt = 0;
      }
    }
    if (key == '\n' ) {
      // client.publish("/test", "hiya");
      // A String can be cleared by setting it equal to ""
      summerWords[numWords] = new Word(typing, summer1, numWords * 2, (numWords * 2) + 1);
      numWords++;
      typing = "";
    } else if (key ==';') {
      typing = "";
    } else {
      // Otherwise, concatenate the String
      // Each character typed by the user is added to the end of the String variable.
      typing = typing + key;
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
      for (int i = 0; i < 9; i++) {
        summerWords[i].drawWord();
      }
      //for (Word w: summerWords) {
      //  w.drawWord();
      //}
      //summerAnim.display(400, 400);
    case 1:
      textSize(36);
      fill(#FFFFFF);
      text(prompts[currPrompt], 450, 300);
      //for (Word w: adventureWords) {
      //  w.drawWord();
      //}
    case 2:
      textSize(36);
      fill(#FFFFFF);
      text(prompts[currPrompt], 450, 300);
      //for (Word w: soundWords) {
      //  w.drawWord();
      //}
    case 3:
      textSize(36);
      fill(#FFFFFF);
      text(prompts[currPrompt], 450, 300);
      //for (Word w: showWords) {
      //  w.drawWord();
      //}
    case 4:
      textSize(36);
      fill(#FFFFFF);
      text(prompts[currPrompt], 450, 300);
      //for (Word w: flavorWords) {
      //  w.drawWord();
      //}
  }
  

  //drawGrid();
  // Draws the labels for each installation
  textSize(12);
  fill(colors[2 * currPrompt]);
  text("Responses in", 51, 720);
  
  fill(colors[2 * currPrompt + 1]);
  text("Responses in", 1056, 720);

  textSize(24);
  fill(colors[2 * currPrompt]);
  text("Gates", 51, 750);
  
  fill(colors[2 * currPrompt + 1]);
  text("Allen", 1056, 750);

  println(mouseX + ", " + mouseY + "\n");
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
    
  } else if (topic.equals("uwsocialspacewords")) {
    switch(currPrompt) {
      case 0:
        summerWords[numWords] = new Word(new String(payload), summer1, numWords * 2, (numWords * 2) + 1);
      case 1:
        adventureWords[numWords] = new Word(new String(payload), adventure1, numWords * 2, (numWords * 2) + 1);
      case 2:
        soundWords[numWords] = new Word(new String(payload), sound1, numWords * 2, (numWords * 2) + 1);
      case 3:
        showWords[numWords] = new Word(new String(payload), show1, numWords * 2, (numWords * 2) + 1);
      case 4:
        flavorWords[numWords] = new Word(new String(payload), flavor1, numWords * 2, (numWords * 2) + 1);
    }
    println(numWords);
    if (numWords != 8) {
      numWords++;
    } else {
      numWords = 0;
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

  Word(String word, color drawColor, int x, int y) {
    this.word = word;
    this.drawColor = drawColor;
    this.occurrences = 1;
    this.topLeftX = leftPositions[x];
    this.topLeftY = leftPositions[y];
    this.size = 22;
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

  void display(float xpos, float ypos) {
    frame = (frame+1) % imageCount;
    image(images[frame], xpos, ypos);
  }

  int getWidth() {
    return images[0].width;
  }
}
