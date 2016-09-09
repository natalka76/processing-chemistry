PFont tahoma;
Record[] records;
String[] elements;
String[] messages = {"Ура!","Молодец!","Угадали!","Верно!"};
int[] playRecords = new int[2];
int playRecordsNumber = 2;
int recordsNumber = 0;
int buttonX, buttonY; // button
int elementX, elementY; // element
int k; // element's number
int count = 0; //count of right answer
int countAll = 0; // count of questions
int isAnswer = 0;
int column = 10; // count of column
int row = 13;
int level = 0;
int isSelectType = 0; // display of select type
int globalType = 0;
int isHint = 0;

void setup() {
  size(650,650);
  buttonX = width-150;
  buttonY = height-20;
  background(149,40,20);
  tahoma = loadFont("Tahoma-48.vlw");
  textFont(tahoma, 24 );
  noLoop ();
  
  elements = loadStrings("data.csv");
  records = new Record[elements.length];
    for (int i = 0; i < elements.length; i++) {      
      String[] pieces = split(elements[i], ","); // Load data into array      
      records[recordsNumber] = new Record(pieces);
      recordsNumber++;
    }
}

void draw() {
  if (int(isAnswer) == 1) {
    drawResult();
  } else if (int(isSelectType) == 1) {
    drawSelectType();
  } else if (int(isHint) == 1) {
    drawHint();
    isHint = 0;
  } else {
    int x = 0;
    int y = 0;
    int type = globalType;
    if (int(globalType) == 2) {
      type = int(random(2));
    }
    getPlayElements();
    getRandomK();
    background(149,40,20);
    stroke(100);
    fill(254,197,82);
    rect(20,height-110,width-40,50);
    
    textAlign(LEFT);
    textSize(48);
    fill(50);
    text("->", buttonX, buttonY);
    textSize(24);
    text("?  Уровень: " + level + "  Счет: " + count*50 + "  Всего: " + countAll, 20, buttonY);
    
    textSize(28);
    if (int(type) == 0) {
      text(records[k].fullName + " (" + records[k].shortName + ")",30,height-75);
    } else {
      text(records[k].name,30,height-75);
    }
  
    for (int i = 0; i<int(recordsNumber); i++) {
      x = int((i % column) * width/column);
      y = int(floor(i/column) * height/row);
      
      fill(240);
      if (records[i].elColor == 2) {
        fill(40,149,20);
      } else if (records[i].elColor == 1) {
        fill(40,20,149);
      } else if (records[i].elColor == 0) {
        fill(149,40,20);
      }
      rect(x, y, width/column, height/row);
      
      fill(255);
      for (int j = 0; j < playRecords.length; j++) {
        if (playRecords[j] == i) {
          if (int(type) == 0) {
            textSize(24);
            text(records[i].name, x + 10, y + 40);
          } else {
            textSize(12);
            text(records[i].fullName, x + 10, y + 40);
          }
        }
      }
      textSize(10);
      text(records[i].number, x + width/column - 15, y + 15);
      
      if (k == i) {
        elementX = x;
        elementY = y;
      }
    }
    
  }
}

void drawResult() {
  fill(239,112,35);
  rect(50,100, width-100,350);
  fill(50);
  textSize(40);
  textAlign(CENTER);
  text(messages[int(random(4))],width/2,200); 
  text(records[k].name + " - " + records[k].fullName, width/2, 300);
  text("(" + records[k].shortName + ")", width/2, 350);
}

void drawSelectType() {
  background(240);
  fill(50);
  textSize(40);
  textAlign(CENTER);
  text("Название -> Обозначение", width/2, 200);
  text("Обозначение -> Название", width/2, 300);
  text("Смешанный режим", width/2, 400);
}

void drawHint() {
  fill(239,112,35);
  rect(50,100, width-100,350);
  fill(50);
  textSize(40);
  textAlign(CENTER);
  text("Подсказка!",width/2,200); 
  text(records[k].name + " - " + records[k].fullName, width/2, 300);
  text("(" + records[k].shortName + ")", width/2, 350);
}

void getPlayElements() {
  int i = 0;
  int n;
  while (i < playRecordsNumber) {
    n = int(random(recordsNumber));
    if (records[n].level <= level) {
      playRecords[i] = n;
      i++;
    }
  }
}

void mousePressed() {
  if (int(isAnswer) == 1) {
    isAnswer = 0;
    redraw();
  } else if (int(isSelectType) == 1 ) {
    if (mouseY > 130 && mouseY < 230) {
      globalType = 0;
    } else if (mouseY > 230 && mouseY < 330) {
      globalType = 1;
    } else if (mouseY > 330 && mouseY < 430) {
      globalType = 2;
    }
    isSelectType = 0;
    playRecordsNumber = 2;
    playRecords = new int[playRecordsNumber];
    redraw();
  } else if (mouseX > 0 && mouseX < 40 
        && mouseY > height - 50 && mouseY < height) {
    isHint = 1;
    redraw();
  } else if (mouseX > 40 && mouseX < 160 
        && mouseY > height - 50 && mouseY < height) {
    isSelectType = 1;
    redraw();
  } else if (mouseX > buttonX && mouseX < buttonX + 50 
        && mouseY > buttonY - 50 && mouseY < buttonY) {
    countAll++;
    redraw();
  } else if (mouseX > elementX && mouseX < elementX + width/column 
        && mouseY > elementY && mouseY < elementY + height/row) {
    count++;
    countAll++;
    playRecordsNumber++;
    playRecords = new int[playRecordsNumber];
    isAnswer = 1;
    if (count > 50) {level = 1;}
    if (count > 150) {level = 2;}
    redraw();
  } else {
    countAll++;
    redraw();
  }
  
}

void getRandomK() {
  k = playRecords[int(random(playRecordsNumber))];
}

class Record {
  String number;
  String name;
  String fullName;
  String shortName;
  int level;
  int elColor;
  
  public Record(String[] pieces) {
    number = pieces[0];
    name = pieces[1];
    fullName = pieces[2];
    shortName = pieces[3];
    level = int(pieces[4]);
    elColor = int(pieces[5]);
  }
}