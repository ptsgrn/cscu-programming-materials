public class Mtx {
    private int row;
    private int col;
    private int[][] values;

    Mtx(int row, int col) {
        this.row = row;
        this.col = col;
    }

    public boolean equalSize(Mtx matrix2) {
        return matrix2.getCol() == this.col && matrix2.getRow() == this.row;
    }

    public boolean compatible(Mtx matrix2) {
        return this.col == matrix2.getRow();
    }

    public int[][] add(Mtx matrix2) {
        if (!this.equalSize(matrix2)) {
            System.err.println("Matrix is not equal in size.");
            return null;
        }
        int[][] mc = new int[this.row][this.col];
        for (int i = 0; i < mc.length; i++) {
            for (int j = 0; j < mc[i].length; j++) {
                mc[i][j] = this.values[i][j] + matrix2.values[i][j];
            }
        }
        return mc;
    }

    public int[][] mul(Mtx matrix2) {
        var ma = this.values;
        var mb = matrix2.getValues();
        if (this.compatible(matrix2)) {
            System.err.println("Matrix is not compatible.");
            return null;
        }
        int[][] mc = new int[ma.length][mb[0].length];
        for (int i = 0; i < ma.length; i++) {
            for (int j = 0; j < mb[0].length; j++) {
                int sum = 0;
                for (int k = 0; k < ma[0].length; k++) {
                    sum += ma[i][k] * mb[k][j];
                }
                mc[i][j] = sum;
            }
        }
        return mc;
    }

    public int[][] mul(int n) {
        int r = this.values.length;
        int c = this.values[0].length;
        int[][] mc = this.values;
        for (int i = 0; i < r; i++) {
            for (int j = 0; j < c; j++) {
                mc[i][j] *= n;
            }
        }
        return mc;
    }

    public int getRow() {
        return this.row;
    }

    public int getCol() {
        return this.col;
    }

    public void setValues(int[][] values) {
        this.values = values;
    }

    public int[][] getValues() {
        return this.values;
    }

    public Mtx toMtx(int[][] values) {
        Mtx m = new Mtx(values.length, values[0].length);
        m.setValues(values);
        return m;
    }
}
