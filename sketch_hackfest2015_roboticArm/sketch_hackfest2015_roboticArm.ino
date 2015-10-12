#include <Wire.h>   // Uno: A4 (SDA), A5 (SCL)
// Mega: 20 (SDA), 21 (SCL)

#include <SPI.h>    // Uno: 11 (MOSI), 12 (MISO), 13 (SCK)
// Mega: 51 (MOSI), 50 (MISO), 52 (SCK)

#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_PWMServoDriver.h"

#define SLAVE_ADDRESS 0x05

#define SCK_PIN   13
#define MISO_PIN  12
#define MOSI_PIN  11
#define SS_PIN    10

#define M1 0
#define M2 1
#define M3 2
#define M4 3

Adafruit_MotorShield AFMS = Adafruit_MotorShield();
Adafruit_DCMotor *myMotor = AFMS.getMotor(4);

char incomingByte;   // for incoming serial data

unsigned long spi_lastSent;

void setup(void) {
  Serial.begin(9600);

  // initialize i2c as slave
  //Wire.begin(SLAVE_ADDRESS);

  // define callbacks for i2c communication
  //Wire.onReceive(i2c_receiveData);
  //Wire.onRequest(i2c_sendData);

  //myMotor = AFMS.getMotor(1);
  AFMS.begin();

  // SPI
  spi_SlaveInit();
  spi_lastSent = millis();

  Serial.println("Ready!");
}

void loop(void) {
  // send data only when you receive data:
  if (Serial.available() > 0) {
    // read the incoming byte:
    incomingByte = Serial.read();

    // say what you got:
    Serial.print("I received: ");
    Serial.println(incomingByte, DEC);

    do_command((char)incomingByte);
  }

  if (digitalRead(SS_PIN) == LOW) {
    Serial.println("Pin 10 low...");
    byte rxData;
    rxData = spi_ReadByte();
    Serial.print("Command: ");
    Serial.println(rxData, DEC);
    if (rxData == 17) {
      Serial.println("Sending data to master...");
      spi_WriteByte(19);
      Serial.println("Done Sending data...");
    }
  }
  if (millis() > spi_lastSent + 2000) {
    Serial.println("Pin 5 low...");
    digitalWrite(5, LOW);
    delay(10);
    digitalWrite(5, HIGH);
    spi_lastSent = millis();
  }

  //delay(1000);
}

void spi_SlaveInit(void) {
  // Set MISO output, all others input
  pinMode(SCK_PIN, INPUT);
  pinMode(MOSI_PIN, INPUT);
  pinMode(MISO_PIN, OUTPUT);
  pinMode(SS_PIN, INPUT);

  // Enable SPI
  SPCR = B00000000;
  SPCR = (1 << SPE);
}

byte spi_ReadByte(void) {
  while (!(SPSR & (1 << SPIF)));
  return SPDR;
}

void spi_WriteByte(byte value) {
  SPDR = value;
  while (!(SPSR & (1 << SPIF)));
  return;
}

void do_command(char x) {
  Serial.print("Processing command: ");
  Serial.println(x);
  switch (x) {
    case 'w': runMotor(M1, FORWARD); break;
    case 's': runMotor(M1, BACKWARD); break;
    default: break;
  }
}

void runMotor(int m, int d) {
  myMotor->setSpeed(100);
  myMotor->run(d);
  delay(100);
  myMotor->run(RELEASE);
}

