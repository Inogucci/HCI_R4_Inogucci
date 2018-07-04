//Ryo
//Toru

import processing.video.*;
import jp.nyatla.nyar4psg.*;

int _kingyo_num = 5;
Fish[] Kingyos = new Fish[_kingyo_num];
PShape poi, kinpoi, kingyo, anapoi;
PImage Hanarete, End, Oke;

Capture cam;
MultiMarker nya;
int s_m, s_s;
boolean END = false;
int A = 0;
int B = 0;
int timeout = 5;
boolean BREAK = false;

void setup() {
    frameRate(30);
    size(640, 480, P3D);
    colorMode(RGB, 100);
    println(MultiMarker.VERSION);  
    cam=new Capture(this, 640, 480);
    nya=new MultiMarker(this, width, height, "../data/camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
    nya.addARMarker("../data/patt.hiro", 80);//id=0
    cam.start();
    Kingyos = new Fish[_kingyo_num];
    for (int i=0; i<_kingyo_num; i++) {
        Kingyos[i] = new Fish();
        Kingyos[i].Sakana = loadImage("../data/GoldFish.png");
    }
    poi = loadShape("../data/poi.obj");
    kinpoi = loadShape("../data/poikingyo.obj");
    kingyo = loadShape("../data/kingyo.obj");
    anapoi = loadShape("../data/poi_ana.obj");
    Hanarete = loadImage("../data/Hanarete.jpg");
    End = loadImage("../data/End.jpg");
    Oke = loadImage("../data/Oke.png");
    s_m = minute();
    s_s = millis()/100;
}

void draw()
{
    imageMode(CORNER);
    if (cam.available() != true) {
        return;
    }
    cam.read();
    nya.detect(cam);

    nya.drawBackground(cam);
    drawOke();

    imageMode(CENTER);
    nyafanc();
    DrawFish(Kingyos);
}

public class Fish {
    boolean visible = true, onPoi = false;
    boolean END = false;
    float x_accele, y_accele;
    float randomx=3, randomy=3, randomed=1;
    int p_n_x = 1, p_n_y = 1;
    boolean flag_x = true, flag_y = true;
    PImage Sakana;
    int x=(int)random((float)width);
    int y=(int)random((float)height);
    int startTime = -1;
    
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

void DrawAnaPoi(PShape poi) {
    lights();
    pushMatrix();
    translate(0, 42, 0);
    scale(0.4);
    rotateX(90.0);
    shape(poi);
    popMatrix();
}

void DrawKingyo(PShape kingyo) {
    lights();
    pushMatrix();
    translate(0, 0, 20);
    rotateY(80.0);    
    scale(1000.0);
    shape(kingyo);
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
    if (fish.visible) {
        image(fish.Sakana, 0, 0, fish_width, fish_height);
    } else {
    }
    popMatrix();
}

void nyafanc() {
    int[] x = new int[4];
    int[] y = new int[4];

    if (EndGame()) {
        image(End, width/2, height/2, width-100, height-100);
        fill(0);
        textSize(24);
        if (!END) {
            A = minute()-s_m;
            B = abs(millis()/1000-s_s);
            END = true;
        }
        text(A + "m" + B + "s", 100, 153);
        return;
    }

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
            if(BREAK) {
                DrawAnaPoi(anapoi);
                continue;
            }
            int onPoiSum=0;
            for (Fish K : Kingyos) {
                if (K.onPoi)onPoiSum++;
            }
            if(k.onPoi && (k.startTime!=-1) && (timeout <= (abs(millis()/1000 - k.startTime)))) {
                k.visible = false;
                BREAK = true;
            }
            if(OkRelease(x,y) && k.onPoi){
                k.END = true;
                k.onPoi = false;
            }
            if (x[0] <= k.x && k.x <= x[1] && k.visible && onPoiSum ==0) {
                if (y[0] <= k.y && k.y <= y[3]) {
                    k.visible = false;
                    k.onPoi = true;
                    k.startTime = millis()/1000;
                    DrawKingyo(kingyo);
                } else {
                    DrawPoi(poi);
                }
            } else if (k.onPoi) {
                k.x=(x[0]+x[1])/2;
                k.y=(y[0]+y[3])/2;
                DrawKingyo(kingyo);
            } else {
                DrawPoi(poi);
            }
        }
        nya.endTransform();
    }
}
void drawOke() {
    image(Oke, 0, height-130, 130, 130);
}

boolean OkMarker(int[] x, int[] y) {
    int OK = 100;
    if ( (x[1] - x[0]) >=  OK) {
        return false;
    } else {
        return true;
    }
}

boolean EndGame() {
    int i=0;
    for (Fish k : Kingyos) {
        if (k.END) i++;
    }
    if (i==_kingyo_num) {
        return true;
    } else {
        return false;
    }
}

boolean OkRelease(int[] x, int[] y) {
    int cx, cy;
    cx = (x[0]+x[1])/2;
    cy = (y[1]+y[2])/2;
    if ( cx>=15 && cx<=115 ) {
        if ( cy<=height-15 && cy>=height-115 ) {
            return true;
        }
    }
    return false;
}
