//Toru

import processing.video.*;
import jp.nyatla.nyar4psg.*;
PImage Fish;

Capture cam;
MultiMarker nya;

void setup() {
    size(640, 480, P3D);
    colorMode(RGB, 100);
    println(MultiMarker.VERSION);  
    cam=new Capture(this, 640, 480);
    nya=new MultiMarker(this, width, height, "../data/camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
    nya.addARMarker("../data/patt.hiro", 80);//id=0
    //nya.addARMarker("../data/patt.kanji",80);//id=1
    cam.start();
    Fish = loadImage("../data/GoldFish.png");
}

int xS, yS, x, y;

void draw()
{
    imageMode(CORNER);
    if (cam.available() !=true) {
        return;
    }
    cam.read();
    nya.detect(cam);
    background(0);
    nya.drawBackground(cam);
    for (int i=0; i<1; i++) {
        if ((!nya.isExist(i))) {
            continue;
        }
        nya.beginTransform(i);
        fill(0, 100*(i%2), 100*((i+1)%2));
        translate(0, 0, 20);
        box(40);
        nya.endTransform();
    }
    imageMode(CENTER);
    image(Fish, width/2, height/2, 50, 100);
}
