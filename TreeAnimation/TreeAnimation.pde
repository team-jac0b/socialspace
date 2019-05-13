float theta;
int level = 0;
int scale = 50;
PImage leaf;
PImage tree;

String saved = "";
String typing = "";

ArrayList<String> keywords;
int[] leafX = {135, 339, 275, 127, 328, 391, 59, 134, 442, 268}; 
int[] leafY = {573, 526, 319, 428, 435, 378, 526, 373, 528, 391};

void setup() {
  size(1280, 800);
  textSize(50);
  keywords = new ArrayList<String>();
  leaf = loadImage("Leaf.png");
  tree = loadImage("Tree.png");
}

void keyPressed() {
  if (keyCode == LEFT || keyCode == RIGHT) {
    if (keyCode == LEFT) {
      if (level > 0) {
        level--;
      }
    }
    if (keyCode == RIGHT) {
      if (level < 5) {
        level++;
      }
    }
  } else {
    if (key == '\n' ) {
      keywords.add(typing);
      // A String can be cleared by setting it equal to ""
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
  stroke(#472f18);
  strokeWeight(50);
  
  // print(mouseX + ", " + mouseY + "\n");

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

}

void drawTrees() {
  pushMatrix();
  translate(550,0);
  scale(-1,1); // You had it right!
  image(tree,30,250, 500, 500);
  popMatrix();
  
  image(tree, 750, 250, 500, 500);
  
  text("ALLEN", 325, 750);
  text("GATES", 790, 750);
  
  for (int i = 0; i < level * 2; i++) {
    drawLeaf(leafX[i], leafY[i], 0);
  }

}

void drawLeaf(int x, int y, int rotation) {
  pushMatrix();
  translate(x,y);
  rotate(radians(rotation));
  //scale(1,-1); // You had it right!
  image(leaf,0,0,20,50);
  //image(leaf,10,10,20,50);
  popMatrix();
}

void branch(float h, float s, float num) {
  // Each branch will be 2/3rds the size of the previous one
  h *= 0.66;

  // Each branch gets smaller
  s *= 0.7;

  num--;

  // All recursive functions must have an exit condition!!!!
  // Here, ours is when the length of the branch is 2 pixels or less
  if (h > 10 && num > 0) {
    strokeWeight(s);
    pushMatrix();    // Save the current state of transformation (i.e. where are we now)
    rotate(theta);   // Rotate by theta
    line(0, 0, 0, -h);  // Draw the branch
    translate(0, -h); // Move to the end of the branch
    branch(h, s, num);       // Ok, now call myself to draw two new branches!!
    popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state

    // Repeat the same thing, only branch off to the "left" this time!
    strokeWeight(s);
    pushMatrix();
    rotate(-theta);
    line(0, 0, 0, -h);
    translate(0, -h);
    branch(h, s, num);
    popMatrix();
  }

}
