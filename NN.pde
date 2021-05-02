static class NN {

    Matrix i_h, h_j, j_o;

    NN(int i, int h, int j, int o) {
        i_h = Matrix.randomize(h, i + 1); // Add biases
        h_j = Matrix.randomize(j, h + 1);
        j_o = Matrix.randomize(o, j + 1);
    }

    NN(Matrix _i_h, Matrix _h_j, Matrix _j_o) {
        i_h = _i_h;
        h_j = _h_j;
        j_o = _j_o;
    }

    float[] guess(float[] i) {
        Matrix inputs = Matrix.tpNormBias(i);
        Matrix hidden = Matrix.multiply(i_h, inputs).activ("ReLU").addBias();
        Matrix hidden2 = Matrix.multiply(h_j, hidden).activ("ReLU").addBias();
        Matrix output = Matrix.multiply(j_o, hidden2).activ("ReLU");
        return Matrix.transpose(output).array[0];
    }

    static NN crossAndMutate(NN a, NN b, float m) {
        return new NN(Matrix.crossover(a.i_h, b.i_h, m), Matrix.crossover(a.h_j, b.h_j, m),Matrix.crossover(a.j_o, b.j_o, m));
    }
    
    void mutate(float m) {
        i_h.mutate(m);
        h_j.mutate(m);
        j_o.mutate(m);
    }
}
