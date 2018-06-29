//Ryo
//Toru

import processing.video.*;
import jp.nyatla.nyar4psg.*;

int _kingyo_num = 5;
Fish[] Kingyos = new Fish[_kingyo_num];
PShape poi, kinpoi;
PImage Hanarete;

Capture cam;
MultiMarker nya;

void setup() {
    frameRate(30);
    size(640, 480, P3D);
    colorMode(RGB, 100);
    println(MultiMarker.VERSION);  
    cam=new Capture(this, 640, 480);
    nya=new MultiMarker(this, width, height, "../data/camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
    nya.addARMarker("../data/patt.hiro", 80);//id=0
    nya.addARMarker("../data/patt.kanji", 80);//id=1
    cam.start();
    Kingyos = new Fish[_kingyo_num];
    for (int i=0; i<_kingyo_num; i++) {
        Kingyos[i] = new Fish();
        Kingyos[i].Sakana = loadImage("../data/GoldFish.png");
    }
    poi = loadShape("../data/poi.obj");
    kinpoi = loadShape("../data/poikingyo.obj");
    Hanarete = loadImage("../data/Hanarete.jpg");
}

void draw()
{
    imageMode(CORNER);
    if (cam.available() != true) {
        return;
    }
    cam.read();
    nya.detect(cam);
    background(0);
    nya.drawBackground(cam);

    imageMode(CENTER);
    nyafanc();
    DrawFish(Kingyos);
}

public class Fish {
    boolean invisible = true;
    float x_accele, y_accele;
    float randomx=3, randomy=3, randomed=1;
    int p_n_x = 1, p_n_y = 1;
    boolean flag_x = true, flag_y = true;
    PImage Sakana;
    int x=(int)random((float)width);
    int y=(int)random((float)height);
}

void DrawPoi(PShape poi) {

    lights();
    pushMatrix();
    translate(0, 0, 0);
    scale(0.4);
    rotateX(90.0);
    shape(poi);
    popMatrix();
}

void DrawFish(Fish fish[]) {
    for (int i=0; i<_kingyo_num; i++) {
        MoveFish(fish[i]);
        TurnFish(fish[i]);
    }
}

void MoveFish(Fish fish) {
    int change = second();
    if (change%((int)random(10)+6)==0 && change != fish.randomed) {
        fish.randomed = second();
        fish.randomx = random(5.0);
        fish.randomy = random(5.0);
        ;
    }
    fish.x_accele = fish.randomx*fish.p_n_x;
    fish.y_accele = fish.randomy*fish.p_n_y;
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
    if (fish.y>height+50&&fish.flag_y) { 
        fish.p_n_y *= -1;
        fish.flag_y=false;
    }
    if (fish.y<-50&&!fish.flag_y) { 
        fish.p_n_y *= -1;
        fish.flag_y=true;
    }
}

void TurnFish(Fish fish) {
    int fish_width=80, fish_height=40;

    pushMatrix();
    translate(fish.x, fish.y);
    float dim = atan2(-(float)fish.y_accele, (float)fish.x_accele);
    rotate(-dim);
    if (fish.invisible) {
        image(fish.Sakana, 0, 0, fish_width, fish_height);
    } else {
    }
    popMatrix();
}

void nyafanc() {
    int[] x = new int[4];
    int[] y = new int[4];

    for (int i=0; i<1; i++) {
        if ((!nya.isExist(i))) {
            continue;
        }
        for (int j=0; j<4; j++) {
            x[j] = (int)nya.getMarkerVertex2D(i)[j].x;
            y[j] = (int)nya.getMarkerVertex2D(i)[j].y;
        }
        if (!OkMarker(x, y)) {
            image(Hanarete, width/2, height/2, width-100, height-100);
            continue;
        }
        nya.beginTransform(i);
        noFill();
        for (Fish k : Kingyos) {
            if (x[0] <= k.x && k.x <= x[1]) {
                if (y[0] <= k.y && k.y <= y[3]) {
                    k.invisible = false;
                    DrawPoi(kinpoi);
                } else {
                    k.invisible = true;
                    DrawPoi(poi);
                }
            } else {
                k.invisible = true;
                DrawPoi(poi);
            }
        }
        nya.endTransform();
    }
}

boolean OkMarker(int[] x, int[] y) {
    int OK = 100;
    if ( (x[1] - x[0]) >=  OK) {
        return false;
    } else {
        return true;
    }
}
