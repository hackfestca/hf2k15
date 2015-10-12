#include <Wire.h>   // Uno: A4 (SDA), A5 (SCL)
                    // Mega: 20 (SDA), 21 (SCL)
#include "U8glib.h"
#include <IRremote.h>

#define SLAVE_ADDRESS 0x04

#define LED_PIN 13
#define CONTRAST_PIN  10
#define BACKLIGHT_PIN 8
#define CONTRAST      125

#define LED_LIGHT_UP 0
#define LED_LIGHT_DOWN 1
#define LED_LIGHT_UP 2
#define LED_LIGHT_OFF 3

String i2c_data = "";

IRsend irsend;  //Default: pin 3 on Uno, 9 on Mega

U8GLIB_ST7920_128X64 u8g(13, 12, 11, U8G_PIN_NONE); // SPI connection

/* setup() */
void setup(void) {
  Serial.begin(9600);

  // initialize i2c as slave
  Wire.begin(SLAVE_ADDRESS); 
  
  // define callbacks for i2c communication
  Wire.onReceive(i2c_receiveData);
  Wire.onRequest(i2c_sendData);
  
  pinMode(LED_PIN, OUTPUT);
  pinMode(CONTRAST_PIN, OUTPUT);
  pinMode(BACKLIGHT_PIN, OUTPUT);
  digitalWrite(BACKLIGHT_PIN, HIGH);
  analogWrite(CONTRAST_PIN, CONTRAST);
  u8g.setColorIndex(1); // Affichage en mode N&B (obligatoire vu que  l'on a pas un Ã©cran couleur)

  Serial.println("Ready!");
}

/* loop() */
void loop(void) {
  u8g.firstPage(); // SÃ©lectionne la 1er page mÃ©moire de l'Ã©cran
  do {
    draw(); // Redessine tout l'Ã©cran
  } while (u8g.nextPage()); // SÃ©lectionne la page mÃ©moire suivante

  /* Delai avant de recommencer */
  delay(1000);
  //setModelLed(LED_LIGHT_OFF);
}

// callback for received data
void i2c_receiveData(int byteCount){
  while(Wire.available()) {
    i2c_data += (char)Wire.read();
  }
  Serial.print("Byte Count: ");
  Serial.println(byteCount);
  Serial.print("data received: ");
  Serial.println(i2c_data.c_str());
  i2c_data = "";
}

// callback for sending data
void i2c_sendData(){
  Wire.write(1);
  Wire.write(2);
  Wire.write(3);
  Serial.println("Sending back: Boom");
}


/* Fonction permettant de redessiner TOUT l'Ã©cran */
void draw(void) {
  u8g.setFont(u8g_font_10x20); // Utilise la police de caractÃ¨re standard
  u8g.drawStr( 0, 22, "Hello World"); // Affiche hello world
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

