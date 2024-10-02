class block {
    int[][] shape;
    int x, y; 
    color blockColor;

    block() { //Constructor method
        this.shape = blockShapes[(int) random(blockShapes.length)];
        this.x = cols / 2 - this.shape[0].length / 2;
        this.y = 0;
        this.blockColor = generateBlockColor();

    for (int i = 0; i < shape.length; i++) {
        for (int j = 0; j < shape[i].length; j++) {
            if (shape[i][j] == 1) {
                int gridX = x + j;
                int gridY = y + i; 
                if (gridY < rows && grid[gridY][gridX] != color(0, 0, 0, 0)) {
                    gameOver = true;
                    return;
                }
            }
        }
    }
}
    //Specific colours set for the blocks
    color[] blockColors = {
    color(255, 0, 0), 
    color(0, 255, 0), 
    color(255, 255, 0),
    color(255, 0, 255),
    color(0, 255, 255),
    color(255, 127, 0),
    color(127, 0, 255), 
    color(0, 255, 127), 
    color(255, 255, 127), 
    color(127, 255, 0), 
    color(255, 0, 127)  
};

    color generateBlockColor() {
      return blockColors[(int) random(blockColors.length)];
}

    //Allows blocks to move left
    void moveLeft() {
        if (canMove(x - 1, y)) {
            x--;
        }
    }

    //Allows blocks to move right
    void moveRight() {
        if (canMove(x + 1, y)) {
            x++;
        }
    }

    //Allows blocks to move down
    void moveDown() {
        if (canMove(x, y + 1)) {
            y++;
        }
    }
    ////Allows blocks to immediately drop down
    void dropDown() {
        while (canMove(x, y + 1)) {
            y++;
       }
    }  

    //Allows blocks to move witin the grid
    boolean canMove(int newX, int newY) {
    for (int i = 0; i < shape.length; i++) {
        for (int j = 0; j < shape[i].length; j++) {
            if (shape[i][j] == 1) {
                int gridX = newX + j;
                int gridY = newY + i;

                if (gridX < 0 || gridX >= cols || gridY >= rows) {
                    return false;
                }

                if (gridY >= 0 && grid[gridY][gridX] != color(0, 0, 0, 0)) {
                    return false;
                }
            }
        }
    }
    return true;
}

    //Method to rotate the shapes 
    void rotate() {
        int[][] rotatedShape = new int[shape[0].length][shape.length];
        for (int i = 0; i < shape.length; i++) {
            for (int j = 0; j < shape[i].length; j++) {
                rotatedShape[j][shape.length - 1 - i] = shape[i][j];
            }
        }

        if (canMove(x, y, rotatedShape)) {
            shape = rotatedShape;
        }
    }

    boolean canMove(int newX, int newY, int[][] newShape) {
        for (int i = 0; i < newShape.length; i++) {
            for (int j = 0; j < newShape[i].length; j++) {
                if (newShape[i][j] == 1) {
                    int gridX = newX + j;
                    int gridY = newY + i;

                    if (gridX < 0 || gridX >= cols || gridY >= 0 && gridY >= rows) {
                        return false;
                    }

                    if (gridY >= 0 && grid[gridY][gridX] == 1) {
                        return false;
                   
                    }
                    if (gridY >= 0 && grid[gridY][gridX] != color(0, 0, 0, 0)) { 
                        return false;
                    }
                }
            }
        }
        return true;
    }
    //In the hard level, allows the blocks to fade in and out 
    void show() {
    if (fallSpeed == 15) {
        if (fadingOut) {
            fadeAmount -= fadeSpeed;
            if (fadeAmount <= 0) {
                fadingOut = false;
                fadeAmount = 0;
            }
        } else {
            fadeAmount += fadeSpeed;
            if (fadeAmount >= 255) {
                fadingOut = true;
                fadeAmount = 255;
            }
        }
    }

    for (int i = 0; i < shape.length; i++) {
        for (int j = 0; j < shape[i].length; j++) {
            if (shape[i][j] == 1) {
                fill(red(blockColor), green(blockColor), blue(blockColor), fadeAmount);
                rect((x + j) * cellSize, (y + i) * cellSize, cellSize, cellSize);
            }
        }
    }
  }
}
