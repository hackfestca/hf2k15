#include <Wire.h>

#define SLAVE_ADDRESS 0x04
#define LED_PIN 13
String data = "";
int state = 0;
boolean dataReceived = false;

void setup() {
  pinMode(13, OUTPUT);
  Serial.begin(9600); // start serial for output
  // initialize i2c as slave
  Wire.begin(SLAVE_ADDRESS); 
  
  // define callbacks for i2c communication
  Wire.onReceive(receiveData);
  Wire.onRequest(sendData);
  
  Serial.println("Ready!");
}

void loop() {
  delay(100);
  if(dataReceived){
    digitalWrite(LED_PIN, HIGH);
    dataReceived = !dataReceived;
  }else{
    digitalWrite(LED_PIN, LOW);
  }
}

// callback for received data
void receiveData(int byteCount){
  while(Wire.available()) {
    data += (char)Wire.read();
  }
  Serial.print("Byte Count: ");
  Serial.println(byteCount);
  Serial.print("data received: ");
  Serial.println(data.c_str());
  data = "";
}

// callback for sending data
void sendData(){
  Wire.write(1);
  Serial.println("Sending back: Boom");
}

String reverse(String data){
  String newData = "";
  for(int i=data.length()-1;i>0;i--){
    newData += (char)data[i];
  }
  return newData;
}

