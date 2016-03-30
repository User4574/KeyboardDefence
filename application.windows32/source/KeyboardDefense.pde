int[][] stars;
int starcount;
char[][] board = {
  {'Q','W','E','R','T','Y','U','I','O','P'},
  {'A','S','D','F','G','H','J','K','L',' '},
  {'Z','X','C','V','B','N','M',' ',' ',' '}
};

int starsize = 5;
int boardsize = 28;

int score, level;
boolean playing;

int[][] keyCoords = {
  {0, 1},  //a
  {4, 2},  //b
  {2, 2},  //c
  {2, 1},  //d
  {2, 0},  //e
  {3, 1},  //f
  {4, 1},  //g
  {5, 1},  //h
  {7, 0},  //i
  {6, 1},  //j
  {7, 1},  //k
  {8, 1},  //l
  {6, 2},  //m
  {5, 2},  //n
  {8, 0},  //o
  {9, 0},  //p
  {0, 0},  //q
  {3, 0},  //r
  {1, 1},  //s
  {4, 0},  //t
  {6, 0},  //u
  {3, 2},  //v
  {1, 0},  //w
  {1, 2},  //x
  {5, 0},  //y
  {0, 2}   //z
};

int[] cols = {
  0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
  10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
  20, 21, 22, 24, 25, 27
};

int[] baseKeyColours = {
  #FFFFFF, #FFFFFF, #FFFFFF, #FFFFFF, #FFFFFF,
  #FFFFFF, #FFFFFF, #FFFFFF, #FFFFFF, #FFFFFF,
  #FFFFFF, #FFFFFF, #FFFFFF, #FFBBBB, #FFFFFF,
  #FFFFFF, #FFBBBB, #FFFFFF, #FFFFFF, #FFFFFF,
  #FFFFFF, #FFFFFF, #FFFFFF, #FFFFFF, #FFFFFF, #FFFFFF
};

int[] keyColours;

int keyMap[] = {
  10, 23, 21, 12, 2,
  13, 14, 15, 7, 16,
  17, 18, 25, 24, 8,
  9, 0, 3, 11, 4,
  6, 22, 1, 20, 5, 19
};

long time, startime;

void setup() {
  size(784, 612);
  stars = new int[100][2];
  keyColours = new int[26];
  starcount = 0;
  score = 0;
  level = 5000;
  playing = true;
  textFont(createFont("FreeMono Bold", 20));
  genStar();
  startime = time = millis();
}

void makeStar(int[] star) {
  line(
    star[0] - starsize, star[1] - starsize,
    star[0] + starsize, star[1] + starsize
  );
  line(
    star[0] - starsize, star[1] + starsize,
    star[0] + starsize, star[1] - starsize
  );
}

void makeBoard() {
  noStroke();
  for(int i = 0; i < 28; i+=2) {
    fill(#CCCCCC);
    rect(i*boardsize, 0, boardsize, 612);
    fill(#AAAAAA);
    rect(i*boardsize + boardsize, 0, boardsize, 612);
  }
  for(int i = 0; i < 28; i+=2) {
    fill(#EEEEEE);
    rect(i*boardsize, 500, boardsize, 84);
    fill(#CCCCCC);
    rect(i*boardsize + boardsize, 500, boardsize, 84);
  }
  
  stroke(#000000);
  int box = 0;
  for(int i = 0; i < 10; i++) {
    fill(keyColours[box]);
    rect(i*3*boardsize, 500, boardsize, boardsize);
    fill(#000000);
    text(board[0][i], (i*3*boardsize)+2, 500+15);
    box++;
  }
  for(int i = 0; i < 9; i++) {
    fill(keyColours[box]);
    rect((i*3*boardsize)+boardsize, 500+boardsize, boardsize, boardsize);
    fill(#000000);
    text(board[1][i], (i*3*boardsize)+boardsize+2, 500+boardsize+15);
    box++;
  }
  for(int i = 0; i < 7; i++) {
    fill(keyColours[box]);
    rect((i*3*boardsize)+(2*boardsize), 500+(2*boardsize), boardsize, boardsize);
    fill(#000000);
    text(board[2][i], (i*3*boardsize)+(2*boardsize)+2, 500+(2*boardsize)+15);
    box++;
  }
  
  for (int i = 0; i < 26; i++)
    keyColours[i] = baseKeyColours[i];
}

void makeScore() {
  text("Score: " + score, 644, 610);
}

void genStar() {
  int col = cols[int(random(26))];
  stars[starcount][0] = (col*boardsize) + (boardsize/2);
  stars[starcount][1] = 0;
  starcount++; 
}

void checkFallen() {
  for (int i = 0; i < starcount; i++)
    if (stars[i][1] > 600)
      gameOver();
}

void gameOver() {
  stars = new int[100][2];
  starcount = 0;
  playing = false;
}

void makeGOScreen() {
  clear();
  background(#CCCCCC);
  fill(#000000);
  text("GAME OVER", 350, 300);
  text("Score: " + score, 350, 330);
}

void draw() {
  if (playing) {
    checkFallen();
  
    clear();
    background(#CCCCCC);
  
    if (millis() > (startime + level) && playing) {
      genStar();
      startime = millis();
    }
  
    if (millis() > time) {
      for(int i = 0; i < starcount; i++)
        stars[i][1] += 1;
      time = millis();
    }
  
    makeBoard();
  
    for(int i = 0; i < starcount; i++)
      makeStar(stars[i]);
  
    makeScore();
  } else {
    makeGOScreen();
  }
}

void shiftStars(int star) {
  for (int i = star; i < starcount; i++) {
    stars[i][0] = stars[i+1][0];
    stars[i][1] = stars[i+1][1];
  }
  starcount--;
}

int checkStars(int keyIndex) {
  int sc = -1;
  int
    l = keyCoords[keyIndex][0]*3*boardsize + (keyCoords[keyIndex][1]*boardsize),
    r = (keyCoords[keyIndex][0]*3*boardsize) + (keyCoords[keyIndex][1]*boardsize) + boardsize,
    t = 500 + (keyCoords[keyIndex][1]*boardsize),
    b = 500 + (keyCoords[keyIndex][1]*boardsize) + boardsize;
    
  for (int i = 0; i < starcount; i++)
    if(stars[i][0] > l && stars[i][0] < r) {
      if(stars[i][1] > 500 && stars[i][1] < 584) {
        if(stars[i][1] > t && stars[i][1] < b)
          sc = 2;
        else
          sc = 1;
        shiftStars(i);
        level -= (level == 1000 ? 0 : 100);
      }
    }
    
  return sc;
}

void keyPressed() {
  int keyIndex = -1;
  if (key >= 'A' && key <= 'Z') {
    keyIndex = key - 'A';
  } else if (key >= 'a' && key <= 'z') {
    keyIndex = key - 'a';
  }
  if (keyIndex != -1) {
    score += checkStars(keyIndex);
    keyColours[keyMap[keyIndex]] = #00FF00;
  }
}
