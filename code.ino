#include <WiFi.h>
#include <ESP32Firebase.h>

#define _SSID "SSID"
#define _PWD "PASSWORD"
#define DATABASE_URL "FIREBASE_URL"

Firebase firebase(DATABASE_URL);

void setup() {
  Serial.begin(115200);
  pinMode(13, OUTPUT);
  Serial.println("WiFi connecting...");
  WiFi.begin(_SSID, _PWD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(250);
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
}

void loop() {
  bool data1 = firebase.getInt("door/door-id/open");
  Serial.print("Received String:\t");
  Serial.println(data1);
  if(data1 == 0){
    digitalWrite(13, HIGH);
    Serial.println("Puerta cerrada!");
  }else if (data1 == 1){
    digitalWrite(13, LOW);
    Serial.println("Puerta abierta!");
  }
}