class Pop {

    Shuttle[] shuttles;
    boolean allDead = false;
    boolean display = true;
    int gen = 1;

    Pop(int n) {
        shuttles = new Shuttle[n];
        for (int i = 0; i < shuttles.length; i++) {
            shuttles[i] = new Shuttle();
        }
        shuttles[0].col = true;
    }

    void update() {
        allDead = true;
        for (int i = 0; i < shuttles.length; i++) {
            if (!shuttles[i].done) {
                shuttles[i].control();
                shuttles[i].update();
                allDead = false;
            }
            if ((display || shuttles[i].col) && !shuttles[i].dead) {
                shuttles[i].show();
            }
        }
    }

    void makeNewPop() {
        float sum = 0;
        for (int i = 0; i < shuttles.length; i++) {
            sum += shuttles[i].fitness;
        }
        Shuttle bestfit = shuttles[0];
        for (int i = 0; i < shuttles.length; i++) {

            if (shuttles[i].fitness > bestfit.fitness) {
                bestfit = shuttles[i];
            }
        }

        Shuttle[] p = new Shuttle[shuttles.length];
        p[0] = new Shuttle(bestfit.brain);
        bestfit.showData();
        //shuttles[8].showData();
        p[0].setCol(255);
        for (int i = 1; i < shuttles.length; i++) {
            p[i] = makeNewShuttle(sum);
        }
        shuttles = p;
        //replay(bestfit.fitness);
        allDead = false;
        println(++gen);
    }

    void replay(float f) {
        for (int i = 0; i < shuttles.length; i++) {
            println(shuttles[i].fitness);
            float col = map(shuttles[i].fitness, 0, f, 0, 255);
            shuttles[i] = new Shuttle(shuttles[i].brain);
            shuttles[i].setCol(col);
        }
    }

    Shuttle makeNewShuttle(float sum) {
        float rand1 = random(sum);
        float rand2 = random(sum);
        NN b1 = null;
        NN b2 = null;
        float c = 0;
        for (int i = 0; i < shuttles.length; i++) {
            c += shuttles[i].fitness;
            if (c > rand1) {
                b1 = shuttles[i].brain;
            }
            if (c > rand2) {
                b2 = shuttles[i].brain;
            }
        }
        return new Shuttle(NN.crossAndMutate(b1, b2, 0.1));
    }
}
