#include <Servo.h>



Servo radarServo;

const int trigPin = 10;
const int echoPin = 11;
const int servoPin = 12;

long duration;
int distance;



void setup() {
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
 
  radarServo.attach(servoPin);

  Serial.begin(9600);
}



int getDistance() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  duration = pulseIn(echoPin, HIGH);

  distance = duration * 0.034 / 2;
  return distance;
}

void loop() {

  // Sweep from 0° to 180°
  for (int angle = 0; angle <= 180; angle++) {

    radarServo.write(angle);
    delay(30);

    distance = getDistance();


    Serial.print(angle);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }

  // Sweep back
  for (int angle = 180; angle >= 0; angle--) {

    radarServo.write(angle);
    delay(30);

    distance = getDistance();
   

    Serial.print(angle);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }
}