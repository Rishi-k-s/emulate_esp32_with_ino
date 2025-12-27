void setup() {
  Serial.begin(9600);

  char name[] = {'I', 'T', 'W', 'O', 'R', 'K', 'S'};

  for (int i = 0; i < 7; i++) {
    Serial.println(name[i]);
  }
}

void loop() {
    delay(1000);
}
