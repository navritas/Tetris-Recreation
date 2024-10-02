class HighScore {
    int score;
    String playerName;

    //Constructor method
    HighScore(int score, String playerName) {
        this.score = score;
        this.playerName = playerName;
    }
}

//Sets the highscores 
HighScore[] highScores = {
    new HighScore(8, "Emma"),
    new HighScore(2, "Sophia"),  
    new HighScore(1, "Kaelin ")   
};
