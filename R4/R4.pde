//Ryo
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

float x_accele, y_accele;
int x = width/2, y = height/2;
double dir, yx;
int p_n_x = 1, p_n_y = 1;
boolean flag_x = true, flag_y = true;

void draw()
{
    PImage fish1 = Fish;
    PImage fish2 = Fish;
    PImage fish3 = Fish;
    x_accele = random(6.0)*p_n_x;
    y_accele = random(8.0)*p_n_y;
    x+=(int)x_accele;
    y+=(int)y_accele;
    print(flag_y);

    if (x>width&&flag_x) { 
        p_n_x *= -1;
        flag_x=false;
    }
    if (x<0&&!flag_x) { 
        p_n_x *= -1;
        flag_x=true;
    }
    if (y>height&&flag_y) { 
        p_n_y *= -1;
        flag_y=false;
    }
    if (y<0&&!flag_y) { 
        p_n_y *= -1;
        flag_y=true;
    }

    //dir=Math.atan2(y_accele,x_accele);
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
    //rotate(radians((float)dir));
    image(fish1, x, y, 100, 50);
    image(fish2, x, y, 80, 40); //What is This
    image(fish3, x, y, 150, 80); //What is This
}
