# Build .ino programs in esp-idf and Emulate it with QEMU
Yes, the title is pretty self-explanatory, so you need some prerequisites
- First you need to setup esp_idf
- Then, setup esp_idf QEMU, not the normal QEMU, like ESP have their own custom one as espressif's repo, uk for the Xtensia boards
- Yeah that is pretty much it
## Running this
first cd to the project directory
To run this: \
```bash
git clone https://github.com/Rishi-k-s/emulate_esp32_with_ino arduino_to_esp && cd arduino_to_esp \
chmod +x ./ino_to_running.sh 
```

then, just take any .ino file u have and do this and with some majik :stars: it should be working  
```bash
./ino_to_running.sh testing.ino # an example btw
```