void setup() {
  Serial.begin(9600);

  char name[] = {'R', 'I', 'S', 'H', 'I'};

  for (int i = 0; i < 5; i++) {
    Serial.println(name[i]);
  }
}

void loop() {
}
