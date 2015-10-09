#include <LiquidCrystal.h>

LiquidCrystal lcd(12, 11, 5, 4, 3, 2);
#define   CONTRAST_PIN 	 10
#define   BACKLIGHT_PIN  9
#define   CONTRAST       125

void setup()
{
  // Switch on the backlight and LCD contrast levels
  pinMode(CONTRAST_PIN, OUTPUT);
  pinMode(BACKLIGHT_PIN, OUTPUT);

  digitalWrite(BACKLIGHT_PIN, HIGH);
  analogWrite (CONTRAST_PIN, CONTRAST);
    
  lcd.begin(128,64);               // initialize the lcd 

  lcd.home ();                   // go home
  lcd.print("Hello, ARDUINO ");  
  lcd.setCursor ( 0, 1 );        // go to the next line
  lcd.print (" WORLD!");      
}

void loop()
{

}
