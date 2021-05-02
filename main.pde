Pop p;
//Shuttle s = new Shuttle();
float ground = 350;

void setup() {
    size(600, 400);
    stroke(255);    
    p = new Pop(4);
    frameRate(120);
    noFill();
}

void draw() {
    background(0);
    line(0, ground, width, ground);

    if (!p.allDead) {
        p.update();
    } else {
        p.makeNewPop();
    }
    //s.update();
    //s.show();
}
void keyPressed() {
    if (key == ' ') {
        p.display = !p.display;
    }
    if (key == 'p') {
        frameRate(frameRate + 20);
        print(frameRate + 20);
    }
    if (key == 'o') {
        frameRate(frameRate - 20);
        print(frameRate - 20);
    }
}
//void keyPressed() {
//    if (keyCode == UP) {
//        s.thrust = true;
//    } else if (keyCode == RIGHT) {
//        s.rotating = 1;
//    } else if (keyCode == LEFT) {
//        s.rotating = - 1;
//    } else {
//        s.rotating = 0;
//    }
//}
//void keyReleased() {
//    if (keyCode == UP) {
//        s.thrust = false;
//    } else if (keyCode == LEFT || keyCode == RIGHT) {
//        s.rotating = 0;
//    }
//}
