// Slave

#define SCK_PIN   13
#define MISO_PIN  12
#define MOSI_PIN  11
#define SS_PIN    10

void SlaveInit(void) {
  // Set MISO output, all others input
  pinMode(SCK_PIN, INPUT);
  pinMode(MOSI_PIN, INPUT);
  pinMode(MISO_PIN, OUTPUT);
  pinMode(SS_PIN, INPUT);

  // Enable SPI
  SPCR = B00000000;
  SPCR = (1 << SPE);
}

byte ReadByte(void) {
  while (!(SPSR & (1 << SPIF))) ;
  return SPDR;
}

void WriteByte(byte value) {
  SPDR = value;
  while (!(SPSR & (1 << SPIF))) ;
  return;
}

unsigned long lastSent;

void setup() {
  Serial.begin(57600);
  digitalWrite(5, HIGH);
  SlaveInit();
  lastSent = millis();
  pinMode(5, OUTPUT);
}

void loop() {
  if (digitalRead(SS_PIN) == LOW) {
    Serial.println("Pin 10 low...");
    byte rxData;
    rxData = ReadByte();
    Serial.print("Command: ");
    Serial.println(rxData, DEC);
    if (rxData == 17) {
      Serial.println("Sending data to master...");
      WriteByte(19);
      Serial.println("Done Sending data...");
    }
  }
  if (millis() > lastSent + 2000) {
    Serial.println("Pin 5 low...");
    digitalWrite(5, LOW);
    delay(10);
    digitalWrite(5, HIGH);
    lastSent = millis();
  }
}
