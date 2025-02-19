class Enemy{
  PVector pos;
  boolean active;
  String type;
  int size;
  color fill;
  double speed;
  int value;
  
  Enemy(PVector pos, String type) {
    this.pos = pos; 
    this.type = type;
    active = true;
    if (type.equals("slow")) {
      size = 40;
      fill = color(255, 0, 0);
      speed = 2.5;
      value = 5;
    } else if (type.equals("fast")) {
      size = 30;
      fill = color(255, 165, 0);
      speed = 5;
      value = 10;
    }
    
  }
  
  void display() {
    fill(fill);
    circle(pos.x, pos.y, size);
  }
  
  void move() {
    
    //Pathing
    if (pos.y == 440 && pos.x <= 1500 && pos.x >= 1165) {
      pos.x += speed;
    }
    
    else if (pos.x == 1165 && pos.y >= 440) {
      pos.y -= speed;
    }
    
    else if (pos.y == 690 && pos.x <= 1165) {
      pos.x += speed;
    }
    
    else if (pos.x == 790 && pos.y <= 690) {
      pos.y += speed;
    }
    
    else if (pos.y == 240 && pos.x <= 790) {
      pos.x += speed;
    }
    
    else if (pos.x == 415 && pos.y >= 240) {
      pos.y -= speed;
    }
    
    else if (pos.y == 440 && pos.x < 415) {
      pos.x += speed;
    }
    
    //Reaching end of screen
    if (pos.x >= 1500) {
      health -= 1;
      hurtTimer = 60;
      active = false;
    }
    
  }
  
}
