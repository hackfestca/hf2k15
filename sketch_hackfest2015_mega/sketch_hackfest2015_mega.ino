#include <Wire.h>   // Uno: A4 (SDA), A5 (SCL)
                    // Mega: 20 (SDA), 21 (SCL)
#include "U8glib.h"
#include <IRremote.h>
#include <AESLib.h>   // https://github.com/DavyLandman/AESLib

#define I2C_ADDRESS 0x04

#define LED_PIN 13
#define CONTRAST_PIN  10
#define BACKLIGHT_PIN 9
#define CONTRAST      125

#define LED_LIGHT_UP 0
#define LED_LIGHT_DOWN 1
#define LED_LIGHT_UP 2
#define LED_LIGHT_OFF 3

#define LCD_BANNER 0
#define LCD_NEWS 1
#define LCD_TOP 2

#define FLAG_CASINO "FLAAAAAAAAAG"
#define I2C_FLAG "FLAGFLAGFLAGFLAG"

IRsend irsend;  //Default: pin 3 on Uno, 9 on Mega

U8GLIB_ST7920_128X64 u8g(13, 12, 11, U8G_PIN_NONE); // SPI connection

boolean FLAG_READY = false;
uint8_t FLAG_KEY[17];
char FLAG_ENC[17];

String lastNews;

/* setup() */
void setup(void) {
  Serial.begin(9600);

  // initialize i2c as slave
  Wire.begin(I2C_ADDRESS); 
  
  // define callbacks for i2c communication
  Wire.onReceive(i2c_receiveData);
  Wire.onRequest(i2c_sendData);
  
  pinMode(LED_PIN, OUTPUT);
  pinMode(CONTRAST_PIN, OUTPUT);
  pinMode(BACKLIGHT_PIN, OUTPUT);
  digitalWrite(BACKLIGHT_PIN, HIGH);
  analogWrite(CONTRAST_PIN, CONTRAST);
  u8g.setColorIndex(1);

  Serial.println("Ready!");
}

/* loop() */
void loop(void) {
  draw();

  Serial.println("Waiting");
  delay(1000);
  //setModelLed(LED_LIGHT_OFF);
}

// callback for received data
void i2c_receiveData(int byteCount){
  char c;
  String msg;
  char cmd;
  String args;
  while(Wire.available()) {
    c = (char)Wire.read();
    msg += c;
  }
  
  Serial.print("Byte Count: ");
  Serial.println(byteCount);
  Serial.print("data received: ");
  Serial.println(msg.c_str());    

  cmd = msg.substring(0,1).c_str()[0];
  args = msg.substring(1);

  do_command(cmd,args);
}

// callback for sending data
void i2c_sendData(){
  if(FLAG_READY){
    Serial.print("Sending flag: ");
    Serial.println(FLAG_ENC);
    Wire.write(FLAG_ENC);
  }else{
    Serial.println("no rsa128 key found");
    Wire.write("no rsa128 key found");
  }
}

void do_command(char cmd, String args){
  Serial.print("Processing command: ");
  Serial.println(cmd);
  switch (cmd) {
    case 'c': updateCountDown(args); break;
    case 'n': updateNews(args); break;
    case 't': updateTop(args); break;
    case 'f': updateFlag(args); break;
    default: break;
  }  
}

void updateCountDown(String args){
  
}

void updateNews(String args){
  
}

void updateTop(String args){
  
}

void updateFlag(String args){
   if(args.length() == 16){
    Serial.print("Updating flag key: ");
    Serial.println(args);
    FLAG_READY = true;
    
    // Converting key
    for(int i=0; i<args.length(); i++){
      FLAG_KEY[i] = (uint8_t)args[i];
    }
    FLAG_KEY[16] = (uint8_t)'\x00';

    // Encrypting flag
    strncpy(FLAG_ENC, I2C_FLAG, 16);
    aes128_enc_single(FLAG_KEY, FLAG_ENC);
  }else{
    Serial.println("Key too small");
  }
}

void draw(void){
  int chgPageDelay = 1000;
  
  // Global settings
  u8g.setRot180();

  // Print banner
  u8g.firstPage();
  do {
    drawBanner();
  } while (u8g.nextPage());  
  delay(chgPageDelay);

  // Print news
  u8g.firstPage();
  do {
    drawNews();
  } while (u8g.nextPage());  
  delay(chgPageDelay);
}

void drawBanner(void) {
  u8g.setRot180();

  u8g.drawFrame(0,0,128,64);
  
  u8g.setFont(u8g_font_10x20);
  u8g.drawCircle(18,18,14);
  u8g.drawStr(10, 26, "HF");
  u8g.drawStr(38, 26, "Casino");

  u8g.setFont(u8g_font_6x10);
  u8g.drawStr(4, 50, "Welcome in Hell");

  //Send also the flag
  u8g.drawStr(128, 128, FLAG_CASINO);
}

void drawNews(void) {
  u8g.setFont(u8g_font_6x10);
  u8g.drawStr(0, 10, "News");
  u8g.drawStr(5, 21, "news1");
  u8g.drawStr(5, 32, "news2");  
  u8g.drawStr(5, 43, "news3");
}

void setModelLed(int action) {
  unsigned long irCode;
  switch (action) {
    case LED_LIGHT_OFF: irCode = 0xF740BF;
      break;
  }
  Serial.print("Sending: ");
  Serial.println(irCode, HEX);
  irsend.sendNEC(irCode, 32);
}

