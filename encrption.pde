import java.util.Scanner;

PImage img;
PImage myImage;
int pixelSize = 1;
int[][] pic;
int max = 0;
int min = max;
int temp;
int tempCount; 

String hiddenString = "hello this is a secret string";


void setup(){
 img = loadImage("profile.jpg");
 size(img.width,img.height); 
 pic = new int[img.height][img.width];
 noStroke();
 frameRate(1);
//for(int i = 0; i < 30; i++){
//hiddenString += "my eyes says no, but my heart says yes. <3";
//}
readPicToArray();

  //Somewhere here I need to encode the message
  String binaryString = "";
  for(int i = 0; i < hiddenString.length(); i++){
    binaryString += (binary(hiddenString.charAt(i)));
  }
  //this is the end of message char, so the decoder knows when to stop
  binaryString += binary(round(pow(2,32)-1));

  tempCount = 0; 
  for(int x = 0; x < img.width-5; x += 1){
    for(int y = 0; y < img.height-5; y += 1){
      if(tempCount<binaryString.length()){
      temp = pic[y][x];
      temp = (temp & (round(pow(2,4)) ^ round(pow(2,32)))+1);
      temp = temp | (round(pow(2,32))+1);
      temp = temp | Integer.parseInt(binaryString.substring(tempCount, tempCount+4), 2);
      pic[y][x] = temp; 
      tempCount += 4;
      }
    }
  }
  
  //I forgot I needed an end of line char...I have decided to make it 2**16-1
  
  //by now the picture should be encoded, now I will try to take message out of it
  String newBinaryString = "";
  boolean finished = false;
  tempCount = 0;
    for(int x = 0; x < img.width-5; x += 1){
      for(int y = 0; y < img.height-5; y += 1){
        if(!finished && tempCount < 300){
          String tempStr = binary(pic[y][x]);
          tempStr = tempStr.substring(tempStr.length()-4,tempStr.length());
          newBinaryString += tempStr;
          if(tempStr.equalsIgnoreCase("1111")){
              tempCount++;
          } else {
           tempCount = 0; 
          }
          if(tempCount >= 3){
           finished = true; 
          } 
        }
      }
    }
  //end (for loops)

  //decoding the string
  String decoded = "";
  for(int i = 0; i < newBinaryString.length()-16; i += 16){
    String tempStr = newBinaryString.substring(i,i+16);
    temp = Integer.parseInt(tempStr,2);
    decoded += char(temp);
  }
  print(decoded);

}

void readPicToArray(){
   //This section will be for reading in the data
  for(int x = 0; x < img.width; x += 1){
    for(int y = 0; y < img.height; y += 1){
      color c = img.get(x,y);
      temp = c;
      pic[y][x] = temp;
    }
  }
 
}

void draw(){
 
//This section will be for output the final picture
for(int x = 0; x < img.width; x += pixelSize){
  for(int y = 0; y < img.height; y += pixelSize){
//    temp = (pic[y][x]-min)*(round(pow(2,31))/(max-min));
    temp = pic[y][x];
    fill(color(temp));
    rect(x,y, pixelSize, pixelSize); 
  }
}



}
