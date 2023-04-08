float[][] field;
final int rez = 5;
final float weight = rez * 0.4;
final float offset = 0.5 * rez;
final float increment = 0.1;
final float timeStep = 0.04;
int cols, rows;
float time = 0;
final OpenSimplexNoise noise = new OpenSimplexNoise();

void setup() {
  //size(600, 400);
  fullScreen(P2D);
  cols = width / rez + 1;
  rows = height / rez + 1;
  field = new float[cols][rows];
}

void line(final PVector v1, final PVector v2) {
  line(v1.x, v1.y, v2.x, v2.y);
}

void draw() {
  for (var i=0; i < cols; ++i) {
    final var xoff = i * increment;
    for (var j=0; j < rows; ++j) {
      final var yoff = j * increment;
      field[i][j] = (float) noise.eval(xoff, yoff, time);
    }
  }
  time += timeStep;

  background(127);

  for (var i=0; i < cols - 1; ++i) {
    final var x = i * rez;
    for (var j=0; j < rows - 1; ++j) {
      final var y = j * rez;

      /**
       * .a.
       * d b
       * .c.
       **/
       final var state =
        ceil(field[i][j]) << 3 |
        ceil(field[i+1][j]) << 2 |
        ceil(field[i+1][j+1]) << 1 |
        ceil(field[i][j+1]);
      
      
      final var aVal = field[i][j] + 1;
      final var bVal = field[i+1][j] + 1;
      final var cVal = field[i+1][j+1] + 1;
      final var dVal = field[i][j+1] + 1;
      
      final var a = new PVector(lerp(x, x + rez, (1 - aVal) / (bVal - aVal)), y);
      final var b = new PVector(x + rez, lerp(y, y + rez, (1 - bVal) / (cVal - bVal)));
      final var c = new PVector(lerp(x, x + rez, (1 - dVal) / (cVal - dVal)), y + rez);
      final var d = new PVector(x, lerp(y, y + rez, (1 - aVal) / (dVal - aVal)));
      
      fill(field[i][j] * 255);
      noStroke();
      rect(i * rez, j * rez, rez, rez);

      stroke(255);
      strokeWeight(1);
      if (state == 1 || state == 10 || state == 14)
        line(c, d);
      if (state == 2 || state == 5 || state == 13)
        line(b, c);
      if (state == 3 || state == 12)
        line(b, d);
      if (state == 4 || state == 10 || state == 11)
        line(a, b);
      if (state == 5 || state == 7 || state == 8)
        line(a, d);
      if (state == 6 || state == 9)
        line(a, c);
    }
  }
}
