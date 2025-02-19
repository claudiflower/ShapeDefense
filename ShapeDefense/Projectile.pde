class Projectile{
  PVector pos;
  PVector direction;
  boolean active = true;
  int speed;
  
  Projectile(PVector pos, PVector direction, int speed) {
    this.pos = pos; 
    this.direction = direction;
    this.speed = speed;
  }
  
  void display() {
    fill(0);
    circle(pos.x, pos.y, projectileSize);
  }
  
  void move() {
    pos.x -= direction.x * speed;
    pos.y -= direction.y * speed;
    
    for (Enemy enemy: enemies) {
     if (dist(pos.x, pos.y, enemy.pos.x, enemy.pos.y) <= (projectileSize/2)+(enemy.size/2)) {
       active = false;
       enemy.active = false;
       money += 5;
       rewards.add(new Reward(new PVector(enemy.pos.x, enemy.pos.y), enemy.value));
     }
    }    
  }
  
}
