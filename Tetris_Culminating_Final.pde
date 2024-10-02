//All of my global variables
ArrayList<block> upcomingBlocks = new ArrayList<block>();
color[][] grid; 
PImage pauseButton;
PImage mainMenu;
PImage mainMenuButton;
PImage quitGameButton;
PImage highScoresTitle;
PImage rules;
int cols = 10;
int rows = 20;
int cellSize = 30;
block currentblock;
block nextBlock;
int score = 0;
int scoreX = cols * cellSize + 16;
boolean gameOver = false;
boolean gamePaused = false;
int pauseButtonX = scoreX + 50; 
int pauseButtonY = 50; 
int mainMenuX = 0;
int mainMenuY = 0;
int easyButtonY = 263;
int buttonWidth = 160;
int buttonHeight = 40;
boolean startGame = false;
int fallSpeed = 30;
int mediumButtonY = 324;
int buttonX = 140; 
int hardButtonY = 385;
int scoreButtonY = 502;
float fadeAmount = 255; 
boolean fadingOut = true; 
int fadeSpeed = 5;
boolean viewingHighScores = false;
String currentPlayerPlayerName = "";
boolean isEnteringPlayerName = false;
int mainMenuButtonX; 
int mainMenuButtonY;
int nextBlockX = cols * cellSize + 15;
int nextBlockY = 130; 
int nextLetterX = cols * cellSize + 15;
int nextLetterY = 110;
int quitGameButtonX;
int quitGameButtonY;
int highScoresTitleX = 10;
int highScoresTitleY = 25;
PFont blockFont;
import processing.sound.*;
SoundFile music;
int rulesButtonY = 445;
boolean viewingRules = false;
boolean resourcesLoaded = false;

//Three-dimensional array to make the block shapes
int[][][] blockShapes = {
    {{1, 1, 1, 1}}, // I shape
    {{1, 0, 0}, {1, 1, 1}}, // J shape
    {{0, 0, 1}, {1, 1, 1}}, // L shape
    {{1, 1}, {1, 1}}, // O shape
    {{0, 1, 1}, {1, 1, 0}}, // S shape
    {{0, 1, 0}, {1, 1, 1}}, // T shape
    {{1, 1, 0}, {0, 1, 1}} // Z shape
};

//Setting up the window screen Method
void setup() {
    size(10 * 30 + 200, 20 * 30); 
    thread("loadResources");
}

//Method to draw stuff on the screen
void draw() {
    if (isEnteringPlayerName) {
        handlePlayerNameInput();
    } else if (viewingRules) {
        drawRulesScreen();
    } else if (viewingHighScores) {
        drawHighScores();
    } else if (startGame) { //If user is playing any of the 3 levels
        if (!gameOver) {
            background(0, 0, 128); 
            drawgrid();
            drawScore();
            drawNextBlock();
            drawPauseButton();
            currentblock.show(); 
            image(mainMenuButton, mainMenuButtonX, mainMenuButtonY);

            if (startGame && !gameOver && !gamePaused) {
              if (frameCount % fallSpeed == 0) {
                  if (currentblock.canMove(currentblock.x, currentblock.y + 1)) {
                      currentblock.moveDown();
                  } else {
                      freezeblock();
                      clearRows();
                      if (checkGameOver()) { 
                          gameOver = true;
                          return;
                      }
                      updateBlockQueue();
                  }
              }
          }
        } else {
            displayGameOver();
        }
    } else {
        drawMainMenu();
    }
}

//Method to load resources 
void loadResources() {
    grid = new color[rows][cols]; //Creates grid
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            grid[i][j] = color(0, 0, 0, 0);
        }
    }
    for (int i = 0; i < 3; i++) {
        upcomingBlocks.add(new block());
    }
    currentblock = upcomingBlocks.remove(0);
    
    blockFont = createFont("Block Stock.ttf", 25); //Intializes text font
    textFont(blockFont); 

    music = new SoundFile(this, "game theme song.wav"); //Imports music
    music.amp(0.5);
    music.loop();

    pauseButton = loadImage("pause button.png");
    pauseButton.resize(40, 40);

    mainMenu = loadImage("main menu.png");
    mainMenu.resize(500, 600);

    mainMenuButton = loadImage("menu button.png");
    mainMenuButton.resize(135, 40);
    
    mainMenuButtonX = width - mainMenuButton.width - 10; 
    mainMenuButtonY = height - mainMenuButton.height - 10; 
    
    nextBlockX = cols * cellSize + 15; 
    nextBlockY = 130;
    
    quitGameButton = loadImage("quit button.png");
    quitGameButton.resize(50,50);
    
    quitGameButtonX = 10;
    quitGameButtonY = height - quitGameButton.height - 10;
    
    highScoresTitle = loadImage("high scores title.png");
    highScoresTitle.resize(450, 100);
    
    rules = loadImage("rules.png");
    rules.resize(500,600);
    
    resourcesLoaded = true;
}

//Method for entering name after winning 
void handlePlayerNameInput() {
    if (isEnteringPlayerName) {
        background(0, 0, 128); 
        fill(255); 
        textSize(25);
        text("Enter Name: " + currentPlayerPlayerName, width / 2, height / 2);
        textSize(12);
        text("Press Enter to submit", width / 2, height / 2 + 40);
    }
}

//Method to display game over after losing 
void displayGameOver() {
    background(0, 0, 128);
    fill(255, 0, 0); 
    textAlign(CENTER, CENTER);
    textFont(blockFont);
    textSize(40);
    text("GAME OVER", width / 2, height / 2);
    image(mainMenuButton, mainMenuButtonX, mainMenuButtonY);
    for (HighScore hs : highScores) {
        if (score > hs.score) {
            isEnteringPlayerName = true;
            break;
        }
    }
}

//Boolen to check if game is over 
boolean checkGameOver() {
    for (int j = 0; j < cols; j++) {
        if (grid[0][j] != color(0, 0, 0, 0)) {
            return true; 
        }
    }
    return false;
}


//Method to display the three highscores
void drawHighScores() {
    background(0, 0, 128); 
    fill(237,218,218); 
    textFont(blockFont);
    textSize(30);

    highScoresTitleX = (width - highScoresTitle.width) / 2; 
    image(highScoresTitle, highScoresTitleX, highScoresTitleY);

    int spacing = 125; 
    int startY = highScoresTitleY + 150; 
    int rankX = width / 2 - 120; 
    int PlayerNameX = width / 2; 
    int score2X = width / 2 + 120;

    //Right aligns the number
    textAlign(RIGHT, CENTER); 
    for (int i = 0; i < highScores.length; i++) {
        text((i + 1) + ".", rankX, startY + i * spacing);
    }

    //Center aligns the name
    textAlign(CENTER, CENTER); // Center align for the PlayerName
    for (int i = 0; i < highScores.length; i++) {
        text(highScores[i].playerName, PlayerNameX, startY + i * spacing);
    }

    //Left aligns the score
    textAlign(LEFT, CENTER); // Left align for the scores
    for (int i = 0; i < highScores.length; i++) {
        text(highScores[i].score, score2X, startY + i * spacing);
    }

    image(mainMenuButton, mainMenuButtonX, mainMenuButtonY);
}

//Method to update highscores 
void updateHighScores() {
    for (int i = 0; i < highScores.length; i++) {
        if (score > highScores[i].score) {
            // Lower scores shift down
            for (int j = highScores.length - 1; j > i; j--) {
                highScores[j] = highScores[j - 1];
            }
            // New high score is added
            highScores[i] = new HighScore(score, "NEW"); 
            break;
        }
    }
}

//Method to draw pause button
void drawPauseButton() {
    if (resourcesLoaded) {
        image(pauseButton, pauseButtonX, pauseButtonY);
    }
}

//Method to draw main menu
void drawMainMenu() {
    if (resourcesLoaded) {
        image(mainMenu, mainMenuX, mainMenuY);
        image(quitGameButton, quitGameButtonX, quitGameButtonY);
    }
}
    
//Method that draws score on the top left corner in the 3 levels
void drawScore() {
    fill(255); 
    textSize(16);
    textAlign(LEFT, TOP);
    text("Score: " + score, scoreX, 20);
}

//Method that displays the rules of the game
void drawRulesScreen() {
    background(255);
    image(rules, 0, 0); 
    image(mainMenuButton, mainMenuButtonX, mainMenuButtonY); 
}

//Method to get the current coordinates of the blocks on the grid and setting the colour accordingly
void freezeblock() {
    for (int i = 0; i < currentblock.shape.length; i++) {
        for (int j = 0; j < currentblock.shape[i].length; j++) {
            if (currentblock.shape[i][j] == 1) {
                int finalY = currentblock.y + i;
                int finalX = currentblock.x + j;
                if (finalY >= 0 && finalY < rows && finalX >= 0 && finalX < cols) {
                    grid[finalY][finalX] = currentblock.blockColor;
                }
            }
        }
    }
}

//Method to determine which keys are pressed
void keyPressed() {
    if (keyCode == LEFT) {
        currentblock.moveLeft();
    } else if (keyCode == RIGHT) {
        currentblock.moveRight();
    } else if (keyCode == DOWN) {
        currentblock.moveDown();
    } else if (keyCode == UP) {
        currentblock.rotate();
    // If spacebar is pressed, block falls directly down on the grid
    } if (key == ' ') {
       if (!gamePaused && !gameOver) {
            currentblock.dropDown();
            freezeblock();
            clearRows();
            if (gameOver) { 
                return;
            }
            updateBlockQueue();
        }
    }
     if (isEnteringPlayerName) {
        if ((key >= 'A' && key <= 'Z') || (key >= 'a' && key <= 'z')) { //Allows user to use lowercase or uppercase letters
            if (currentPlayerPlayerName.length() < 8) { //Allows a 8-letter name
                currentPlayerPlayerName += key; 
            }
        } else if (keyCode == BACKSPACE && currentPlayerPlayerName.length() > 0) {
            currentPlayerPlayerName = currentPlayerPlayerName.substring(0, currentPlayerPlayerName.length() - 1);
        } else if (keyCode == ENTER && currentPlayerPlayerName.length() > 0) { 
            updateHighScores(currentPlayerPlayerName); //Updates high sore
            currentPlayerPlayerName = "";
            isEnteringPlayerName = false;
            gameOver = false; 
            viewingHighScores = true;
        }
    }
}

//Method to update thhe next blocks c
void updateBlockQueue() {
    currentblock = upcomingBlocks.remove(0);
    upcomingBlocks.add(new block());
    nextBlock = upcomingBlocks.get(0); 
}

//Updates the name of the person with the high score
void updateHighScores(String PlayerName) {
    for (int i = 0; i < highScores.length; i++) {
        if (score > highScores[i].score) {
            for (int j = highScores.length - 1; j > i; j--) {
                highScores[j] = highScores[j - 1];
            }
            highScores[i] = new HighScore(score, PlayerName);
            break;
        }
    }
}

//Checks X-Y coordinates of the mouse
void mouseMoved(){
  println("Mouse X: " + mouseX + ", Mouse Y: " + mouseY);
}

//Method to check when and where the mouse is pressed
void mousePressed() {
    if (!startGame) { //SHows the high scores
        if (mouseX >= buttonX && mouseX <= buttonX + buttonWidth &&
            mouseY >= scoreButtonY && mouseY <= scoreButtonY + buttonHeight) {
            viewingHighScores = !viewingHighScores; 
        }
    }//Button for the easy level
    if (mouseX >= buttonX && mouseX <= buttonX + buttonWidth &&
        mouseY >= easyButtonY && mouseY <= easyButtonY + buttonHeight) {
        startGame = true; 
        fallSpeed = 30;
    }
    //Button for the medium level
    if (mouseX >= buttonX && mouseX <= buttonX + buttonWidth &&
        mouseY >= mediumButtonY && mouseY <= mediumButtonY + buttonHeight) {
        startGame = true;
        fallSpeed = 20; 
    }
    //Button for the hard level
    if (mouseX >= buttonX && mouseX <= buttonX + buttonWidth &&
        mouseY >= hardButtonY && mouseY <= hardButtonY + buttonHeight) {
        startGame = true;
        fallSpeed = 15;
    }
    //Main menu button on game over screen
    if (gameOver && 
        mouseX >= mainMenuButtonX && mouseX <= mainMenuButtonX + mainMenuButton.width &&
        mouseY >= mainMenuButtonY && mouseY <= mainMenuButtonY + mainMenuButton.height) {
        resetGame();
        return;
    }
    //Main menu button on high scores screen
    if (viewingHighScores && 
        mouseX >= mainMenuButtonX && mouseX <= mainMenuButtonX + mainMenuButton.width &&
        mouseY >= mainMenuButtonY && mouseY <= mainMenuButtonY + mainMenuButton.height) {
        resetGame();
        return;
    }
    //Button to quit the game
    if (mouseX >= quitGameButtonX && mouseX <= quitGameButtonX + quitGameButton.width &&
        mouseY >= quitGameButtonY && mouseY <= quitGameButtonY + quitGameButton.height) {
        exit(); 
    }
    //Button to display the rules
    if (!viewingRules && !startGame && 
        mouseX >= buttonX && mouseX <= buttonX + buttonWidth &&
        mouseY >= rulesButtonY && mouseY <= rulesButtonY + buttonHeight) {
        viewingRules = true;
    } //Button for main menu on the 3 levels
    if (startGame && 
        mouseX >= mainMenuButtonX && mouseX <= mainMenuButtonX + mainMenuButton.width &&
        mouseY >= mainMenuButtonY && mouseY <= mainMenuButtonY + mainMenuButton.height) {
        resetGame(); 
    }
    //Button for main menu button on rules screen
    if (viewingRules && 
        mouseX >= mainMenuButtonX && mouseX <= mainMenuButtonX + mainMenuButton.width &&
        mouseY >= mainMenuButtonY && mouseY <= mainMenuButtonY + mainMenuButton.height) {
        viewingRules = false;
    }
    //Button to pause the game
    if (startGame) {
        int pauseButtonWidth = pauseButton.width; 
        int pauseButtonHeight = pauseButton.height; 

        if (mouseX >= pauseButtonX && mouseX <= pauseButtonX + pauseButtonWidth &&
            mouseY >= pauseButtonY && mouseY <= pauseButtonY + pauseButtonHeight) {
            gamePaused = !gamePaused; 
        }
    }
}

//Method to display the next block on the side of the grid
void drawNextBlock() {
    block nextBlock = upcomingBlocks.get(0);
    fill(255);
    textSize(16);
    textAlign(LEFT, TOP); 
    text("Next Block:", nextLetterX, nextLetterY); 

    for (int i = 0; i < nextBlock.shape.length; i++) {
        for (int j = 0; j < nextBlock.shape[i].length; j++) {
            if (nextBlock.shape[i][j] == 1) {
                fill(nextBlock.blockColor);
                rect(nextBlockX + j * cellSize + 20, nextBlockY + i * cellSize + 20, cellSize, cellSize);
            }
        }
    }
}

//Method to draw the grid
void drawgrid() {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            if (grid[i][j] == color(0, 0, 0, 0)) {
                fill(200, 200, 255, 50); 
            } else {
                fill(grid[i][j]); 
            }
            rect(j * cellSize, i * cellSize, cellSize, cellSize);
        }
    }

    stroke(173, 216, 230);
    for (int i = 0; i <= rows; i++) {
        line(0, i * cellSize, cols * cellSize, i * cellSize);
    }
    for (int j = 0; j <= cols; j++) {
        line(j * cellSize, 0, j * cellSize, rows * cellSize);
    }
}

int getHighestStackRow() { //Keeps track of highest row filled
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            if (grid[i][j] != color(0, 0, 0, 0)) {
                return i;
            }
        }
    }
    return rows;
}

//Method to clear the rows once filled
void clearRows() {
    int linesCleared = 0;
    for (int i = rows - 1; i >= 0; i--) {
        boolean rowFilled = true;
        for (int j = 0; j < cols; j++) {
            if (grid[i][j] == color(0, 0, 0, 0)) {  
                rowFilled = false;
                break;
            }
        }

        if (rowFilled) {
            linesCleared++;
            for (int k = i; k > 0; k--) {
                for (int j = 0; j < cols; j++) {
                    grid[k][j] = grid[k - 1][j];
                }
            }

            for (int j = 0; j < cols; j++) {
                grid[0][j] = color(0, 0, 0, 0);
            }

            i++; 
        }
    }

    if (linesCleared > 0) {
        score += linesCleared + (linesCleared - 1) * 2; //Score increases when lines clear
    }
}

//Method to reset all game/grid variables
void resetGame() {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            grid[i][j] = color(0, 0, 0, 0);
        }
    }

    score = 0;
    gameOver = false;
    gamePaused = false;
    startGame = false;
    viewingHighScores = false;
    isEnteringPlayerName = false;
    currentPlayerPlayerName = "";
    upcomingBlocks.clear();
    for (int i = 0; i < 3; i++) { 
        upcomingBlocks.add(new block());
    }
    currentblock = upcomingBlocks.remove(0);
    nextBlock = upcomingBlocks.get(0);
}
