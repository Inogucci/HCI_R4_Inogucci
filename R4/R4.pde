//Ryo
//Toru

import processing.video.*;
import jp.nyatla.nyar4psg.*;
Fish Kingyo1, Kingyo2;

Capture cam;
MultiMarker nya;

void setup() {
    frameRate(60);
    size(640, 480, P3D);
    colorMode(RGB, 100);
    println(MultiMarker.VERSION);  
    cam=new Capture(this, 640, 480);
    nya=new MultiMarker(this, width, height, "../data/camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
    nya.addARMarker("../data/patt.hiro", 80);//id=0
    nya.addARMarker("../data/patt.kanji", 80);//id=1
    cam.start();
    Kingyo1 = new Fish();
    Kingyo2 = new Fish();
    Kingyo1.Sakana_r = loadImage("../data/GoldFish.png");
    Kingyo1.Sakana_l = loadImage("../data/GoldFishL.png");
    Kingyo2.Sakana_r = loadImage("../data/GoldFish.png");
    Kingyo2.Sakana_l = loadImage("../data/GoldFishL.png");
}

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
    DrawFish(Kingyo1);
    DrawFish(Kingyo2);
}

public class Fish {
    float x_accele, y_accele;
    int p_n_x = 1, p_n_y = 1;
    boolean flag_x = true, flag_y = true;
    PImage Sakana_r,Sakana_l;
    int x=(int)random((float)width);
    int y=(int)random((float)height);
}

void MoveFish(Fish fish) {
    fish.x_accele = random(6.0)*fish.p_n_x;
    fish.y_accele = random(6.0)*fish.p_n_y;
    fish.x+=(int)fish.x_accele;
    fish.y+=(int)fish.y_accele;

    if (fish.x>width+50&&fish.flag_x) {
        fish.p_n_x *= -1;
        fish.flag_x=false;
    }
    if (fish.x<-50&&!fish.flag_x) { 
        fish.p_n_x *= -1;
        fish.flag_x=true;
    }
    if (fish.y>height&&fish.flag_y) { 
        fish.p_n_y *= -1;
        fish.flag_y=false;
    }
    if (fish.y<0&&!fish.flag_y) { 
        fish.p_n_y *= -1;
        fish.flag_y=true;
    }
}

void TurnFish(Fish fish) {
    if(fish.flag_x == true){
      image(Kingyo1.Sakana_r, fish.x, fish.y, 100, 50);
    }
    else{
      image(fish.Sakana_l, fish.x, fish.y, 100, 50);
    }
}

void DrawFish(Fish fish) {
    MoveFish(fish);
    TurnFish(fish);
}
