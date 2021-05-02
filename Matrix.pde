static class Matrix {

    float[][] array;
    int r, c;

    Matrix(int _r, int _c) {
        r = _r;
        c = _c;
        array = new float[_r][_c];
    }

    Matrix(float[][] a) {
        r = a.length;
        c = a[0].length;
        array = a;
    }

    static Matrix randomize(int r, int c) {
        float[][] arr = new float[r][c];
        for (int i = 0; i < r; i++) {
            for (int j = 0; j < c; j++) {
                arr[i][j] = (float) Math.random() * 2 - 1;
            }
        }
        return new Matrix(arr);
    }

    static Matrix multiply(Matrix a, Matrix b) {
        if (a.c != b.r) {
            throw new IllegalArgumentException("Matrices cannot be multiplied");
        }
        float res[][] = new float[a.r][b.c];
        int i, j, k;
        for (i = 0; i < a.r; i++) {
            for (j = 0; j < b.c; j++) {    
                res[i][j] = 0;
                for (k = 0; k < b.r; k++) {
                    res[i][j] += a.array[i][k] * b.array[k][j];
                }
            }
        }
        return new Matrix(res);
    }

    static Matrix transpose(Matrix a) {
        float res[][] = new float[a.c][a.r];
        for (int i = 0; i < a.r; i++) {
            for (int j = 0; j < a.c; j++) {
                res[j][i] = a.array[i][j];
            }
        }
        return new Matrix(res);
    }

    static Matrix tpNormBias(float[] in) {
        float res[][] = new float[in.length + 1][1];
        for (int i = 0; i < in.length; i++) {
            res[i][0] = in[i];
            //res[i][0] = 1 / (1 + pow((float) Math.E, -in[i]));
        }
        res[in.length][0] = 1;
        return new Matrix(res);
    }

    Matrix addBias() {
        float res[][] = new float[r + 1][1];
        for (int i = 0; i < r; i++) {
            res[i][0] = array[i][0];
        }
        res[r][0] = 1;
        array = res;
        r++;        
        return this;
    }

    void mutate(float mutation) {
        for (int i = 0; i < r; i++) {
            for (int j = 0; j < c; j++) {
                if (Math.random() > mutation) {
                    array[i][j] = (float)Math.random() * 2 - 1;
                }
            }
        }
    }

    static Matrix crossover(Matrix a, Matrix b, float mutation) {
        int rc = floor((float)Math.random() * a.r);
        int rr = floor((float)Math.random() * a.c);
        float[][] res = new float[a.r][a.c];
        for (int i = 0; i < a.r; i++) {
            for (int j = 0; j < a.c; j++) {
                if (i < rr || (i == rr && j <= rc)) {
                    res[i][j] = a.array[i][j];
                } else {
                    res[i][j] = b.array[i][j];
                }
                if (Math.random() > mutation) {
                    res[i][j] = (float)Math.random() * 2 - 1;
                }
            }
        }
        return new Matrix(res);
    }

    Matrix activ(String f) {
        for (int i = 0; i < array.length; i++) {
            if (f == "sigmoid") {
                array[i][0] = 1 / (1 + pow((float) Math.E, -array[i][0]));
            } else if (f == "ReLU") {
                if (array[i][0] < 0) {
                    array[i][0] = 0;
                }
            }
        }
        return this;
    }

    void show() {
        println("[");
        for (int i = 0; i < r; i++) {
            for (int j = 0; j < c; j++) {
                print(array[i][j] + ", ");
            }
            println();
        }
        print("]");
    }
}
