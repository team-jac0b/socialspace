
float theta;
int level = 0;
double scale = 0.0;
int prompt = 0;
int rectx = 0;
int recty = 205;
PImage leaf;
PImage tree;

int angle1 = 0;
int angle2 = 0;
int angle3 = 0;

int x1 = 0;
int x2 = 0;
int x3 = 0;

int y1 = 0;
int y2 = 0;
int y3 = 0;

String saved = "";
String typing = "";

Boolean drawLeaves = true;

ArrayList<String> keywords;
String[] prompts = {"Do you have any big plans for\n the summer? (Keep it hopeful)",
                    "What are you up to for the summer?",
                    "Among your friends, what are you best known for?",
                    "What’s an interesting adventure you’ve been on?",
                    "What’s your most memorable trip?",
                    "What is the best sound in the world?",
                    "What is your favorite show or movie to Netflix?",
                    "If you could be any ice cream flavor, \nwhat would you be and why?",
                    "Top thing on your bucket list",
                    "What’s your favorite thing about your best friend?"};
int[] leafX = {135, 339, 275, 127, 328, 391, 59, 134, 442, 268, 208, 170};
int[] leafY = {573, 526, 319, 428, 435, 378, 526, 373, 528, 391, 495, 530};

void setup() {
  size(1200, 800);
  textSize(50);
  keywords = new ArrayList<String>();
  leaf = loadImage("Leaf.png");
  tree = loadImage("Tree.png");

}

void keyPressed() {
  if (keyCode == LEFT || keyCode == RIGHT || keyCode == DOWN) {
    if (keyCode == LEFT) {
      if (level > 0) {
        level--;
        scale = 0.0;
        angle1 = (int)random(360);
        angle2 = (int)random(360);
        angle3 = (int)random(360);
        x1 = (int)random(-25, 25);
        x2 = (int)random(-25, 25);
        x3 = (int)random(-25, 25);
        y1 = (int)random(-25, 25);
        y2 = (int)random(-25, 25);
        y3 = (int)random(-25, 25);
        loop();
      }
    }
    if (keyCode == RIGHT) {
      if (level < 6) {
        level++;
        scale = 0.0;
        angle1 = (int)random(360);
        angle2 = (int)random(360);
        angle3 = (int)random(360);
        x1 = (int)random(-25, 25);
        x2 = (int)random(-25, 25);
        x3 = (int)random(-25, 25);
        y1 = (int)random(-25, 25);
        y2 = (int)random(-25, 25);
        y3 = (int)random(-25, 25);
        loop();
      }
    }
    if (keyCode == DOWN) {
      if (prompt != 9) {
        prompt++;
      } else {
        prompt = 0;
      }
      keywords = new ArrayList<String>();
      scale -= 0.1;
      redraw();
    }

  } else {
    if (key == '\n' ) {
      keywords.add(typing);
      // A String can be cleared by setting it equal to ""
      typing = "";
      scale -= 0.1;
      redraw();
    } else if (key ==';') {
      typing = "";
    } else {
      // Otherwise, concatenate the String
      // Each character typed by the user is added to the end of the String variable.
      typing = typing + key;
    }
    
  }

}

void draw() {
  // #4286f4
  background(#FFFFFF);
  frameRate(30);
  fill(#472f18);
  for (int i = 0; i < keywords.size(); i++) {
    text(keywords.get(i), ((i + 1) * 150) % 1200, 100 * ((i / 5) + 1));
  }
  //text(typing, 50, 50);
  drawTrees();
  //rectangle(0, 205, 600, 600);

  stroke(#472f18);
  strokeWeight(50);

  textSize(24);
  text(prompts[prompt], 400, 640);

  //print(mouseX + ", " + mouseY + "\n");

  // Let's pick an angle 0 to 90 degrees based on the mouse position
  float a = 30;
  // Convert it to radians
  theta = radians(a);
  // Start the tree from the bottom of the screen
  translate(width/2,height);
  // Draw a line 120 pixels
  //line(0,0,0,-280);
  // Move to the end of that line
  translate(0,-280);
  // Start the recursive branching! 
  // branch(280, 50, numBranches);
  if (scale >= 1) {
      noLoop();
  }
  scale += 0.1;
}

void drawTrees() {
  pushMatrix();
  translate(550,0);
  scale(-1,1); // You had it right!
  image(tree,50,250, 500, 500);
  //image(tree,-50,250, 1000, 1000);
  popMatrix();

  image(tree, 750, 250, 500, 500);

  text("GATES", 325, 750);
  text("ALLEN", 790, 750);
  for (int i = 0; i < level * 2; i++) {
    drawLeaf(leafX[i], leafY[i], 0);
    drawLeaf(leafX[i] + x1, leafY[i] + y1, angle1 + leafX[i]);
    drawLeaf(leafX[i] + x2, leafY[i] + y2, angle2 + leafX[i]);
    drawLeaf(leafX[i] + x3, leafY[i] + y3, angle3 + leafX[i]);
  }

}

void drawLeaf(int x, int y, int rotation) {
  pushMatrix();
  translate(x,y);
  rotate(radians(rotation));
  //scale(1,-1); // You had it right!
  image(leaf,0,0,(int)(20 * scale),(int)(50 * scale));
  //image(leaf,10,10,20,50);
  popMatrix();
}

// void branch(float h, float s, float num) {
//   // Each branch will be 2/3rds the size of the previous one
//   h *= 0.66;
//
//   // Each branch gets smaller
//   s *= 0.7;
//
//   num--;
//
//   // All recursive functions must have an exit condition!!!!
//   // Here, ours is when the length of the branch is 2 pixels or less
//   if (h > 10 && num > 0) {
//     strokeWeight(s);
//     pushMatrix();    // Save the current state of transformation (i.e. where are we now)
//     rotate(theta);   // Rotate by theta
//     line(0, 0, 0, -h);  // Draw the branch
//     translate(0, -h); // Move to the end of the branch
//     branch(h, s, num);       // Ok, now call myself to draw two new branches!!
//     popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state
//
//     // Repeat the same thing, only branch off to the "left" this time!
//     strokeWeight(s);
//     pushMatrix();
//     rotate(-theta);
//     line(0, 0, 0, -h);
//     translate(0, -h);
//     branch(h, s, num);
//     popMatrix();
//   }
//
// }
