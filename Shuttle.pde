class Shuttle {

    PVector pos = new PVector(width/2, 40);//random(0, width), random(0, ground - 200));
    PVector vel = new PVector(0, 0);
    PVector acc = new PVector(0, 0.005);
    PVector origAcc = acc;
    float theta = 0;
    float w = 0.04;
    float thresh = 0.5;
    int rotating = 0;
    boolean thrust = false;

    boolean done = false;
    boolean dead = false;
    boolean col = false;

    NN brain;
    float initFrame = frameCount;
    float stopFrame;
    float fitness;
    float f;

    Shuttle() {
        brain = new NN(7, 12, 12, 3);
    }

    Shuttle(NN b) {
        brain = b;
    }

    void control() {
        float[] i = {pos.x, pos.y, vel.x, vel.y, theta, 3*width/4, ground};
        float[] output = brain.guess(i);

        if (output[0] > 0.7) {
            thrust = true;
        } else {
            thrust = false;
        }

        if (output[1] > 0.7) {
            rotating = 1;
        } else if (output[2] > 0.7) {
            rotating = -1;
        } else {
            rotating = 0;
        }
    } 

    void update() {
        vel.add(acc);
        vel.limit(1.5);
        pos.add(vel);
        theta += w * rotating;
        if (thrust) {
            acc = new PVector(0, - 0.01).rotate(theta);
        } else {
            acc = origAcc;
        }
        checkDone();
    }

    void checkDone() {
        if (pos.y + 10 >= ground) {
            if (vel.magSq() > thresh || abs(theta) > 0.07) {
                dead = true;
            }
            done = true;
            fitness = 1/calcCost();
        }
        if (frameCount - initFrame > 1200) {
            dead = true;
            done = true;
            fitness = 1/calcCost();
        }
    }
    
    void setCol(float c) {
        f = c;
        col = true;
    }
    
    void showData() {
        println("");
        println("Time: ", (stopFrame - initFrame)/100,"Dist: ", PVector.sub(pos, new PVector(3*width/4, ground)).limit(height).mag()/2, "vel: ", vel.magSq()*20, pow(theta % TWO_PI, 2), dead);
        print(1/fitness);
    }

    float calcCost() {
        float d = dead ? 1.2 : 0.8;
        stopFrame = frameCount;
        return ((stopFrame - initFrame)/80 + PVector.sub(pos, new PVector(3*width/4, ground)).limit(height).mag()/2);// + pow(theta % TWO_PI, 2) + vel.magSq()*20)*d;
    }
    void show() {
        push();
        translate(pos.x, pos.y);
        rotate(theta);
        if (col) {
            fill(0, f, 0);
        }
        triangle(-10, 9, 10, 9, 0, -18);
        if (thrust) {
            triangle(-6, 9, 6, 9, 0, 18 + random(-3, 3));
        }
        pop();
    }
}
