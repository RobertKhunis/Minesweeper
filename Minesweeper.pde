import de.bezier.guido.*;
public final static int NUM_ROWS = 10;
public final static int NUM_COLS = 10;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
int theMines = NUM_ROWS * NUM_COLS/3;

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < buttons.length; r++){
      for(int c = 0; c< buttons[r].length; c++){
      buttons[r][c] = new MSButton(r, c);
      }
    }
    setMines();
    

}
public void setMines()
{  int r_loc = (int)(Math.random()*(NUM_ROWS));
   int c_loc = (int)(Math.random()*(NUM_COLS));
   //int avg = (NUM_ROWS+NUM_COLS)/2;
   
   
   //(NUM_ROWS*NUM_COLS)* 2/9
   //System.out.println(numMines);
    for(int i = 0; i < theMines; i++){
    if(!(mines.contains(buttons[r_loc][c_loc]))){
    mines.add(buttons[r_loc][c_loc]);//new MSButton(c_loc, r_loc));
    }else{
      
    i--;
    }
    r_loc = (int)(Math.random()*(NUM_ROWS));
    c_loc = (int)(Math.random()*(NUM_COLS));
    }
    
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
  int safeFound = 0;
    for(int r = 0; r < NUM_ROWS; r++){
    for(int c = 0; c < NUM_COLS; c++){
    
     if(buttons[r][c].clicked == true && buttons[r][c].flagged == false){
     safeFound++;
     } 
      
    }
    }
    
    
    if(safeFound == (NUM_ROWS * NUM_COLS - theMines)){
      
    return true;
    
    }
    return false;
}
public void displayLosingMessage()
{
    for(int r = 0; r < NUM_ROWS; r++){
    for(int c = 0; c < NUM_COLS; c++){
    
     buttons[r][c].setLabel("Loser");   
    }
    }
    
    for(int i = 0; i < mines.size(); i++){
    mines.get(i).clicked = true;
    }
    noLoop();
}
public void displayWinningMessage()
{
  for(int r = 0; r < buttons.length; r++){
    for(int c = 0; c < buttons[r].length; c++){
    buttons[r][c].setLabel(" Winner \n Winner \n Chicken \n Dinner");
    }
  }
}
public boolean isValid(int r, int c)
{
     if (r>=0 && r < NUM_ROWS && c>=0 && c < NUM_COLS) {
    return true;
  }
  return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    
    for(int r = row-1; r <= row + 1; r++){
    for(int c = col - 1; c <= col + 1; c++){
      if(isValid(r, c) == true){
        if(mines.contains(buttons[r][c])){
        if(r != row || c != col){
          numMines++;
        }
        }
      }
    }
  }
    //System.out.println(numMines);
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT){
        flagged = !flagged;
          if (flagged == false){
          clicked = false;
          }
        } else if(mines.contains(this)){
         displayLosingMessage();
        } else if(countMines(myRow, myCol)>0){
         this.setLabel(countMines(myRow,myCol));
        } else {
          
        /*if(isValid(myRow, myCol-1) == true ){
         buttons[myRow][myCol-1].mousePressed();
        } */
        
        for(int r = myRow - 1; r <= myRow + 1; r++){
    for(int c = myCol - 1; c <= myCol + 1; c++){
      if(isValid(r, c) == true && !buttons[r][c].clicked){
        //if(r != myRow || c != myCol){
          buttons[r][c].mousePressed();
        //}
        }
      }
    }
        
        }
        
    }
    public void draw () 
    {    
        if (flagged)
            fill(0,0,255);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    public int getmyRow(){
    return myRow;
    }
    public int getmyCol(){
    return myCol;
    }
}
