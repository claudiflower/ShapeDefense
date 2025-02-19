class Reward {
  PVector pos;
  int value;
  int timer;
  
  Reward(PVector pos, int value) {
    this.pos = pos;
    this.value = value;
    timer = 30;
  }
  
  void display() {
    textSize(48);
    fill(0, 255, 0, 150+timer);
    textAlign(CENTER);
    text("+$" + value, pos.x, pos.y);
  }
  
  void move() {
    pos.y -= 1;
    if (timer > 0 ) timer -= 1;
  }
  
}
