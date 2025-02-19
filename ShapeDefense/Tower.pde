class Tower{
  PVector pos;
  int cooldown;
  String type;
  int size;
  int range;
  color fill;
  int cooldownMax;
  int projectileSpeed;
  
  Tower(PVector pos, String type) {
    this.pos = pos;
    this.type = type;
    cooldown = 0;
    
    if (type.equals("basic")) {
      size = 60;
      range = 300;
      fill = color(0, 0, 200);
      cooldownMax = 70;
      projectileSpeed = 15;
    } else if (type.equals("speedy")) {
      size = 55;
      range = 200;
      fill = color(0, 200, 255);
      cooldownMax = 40;
      projectileSpeed = 30;
    } else if (type.equals("ranged")) {
      size = 60;
      range = 500;
      fill = color(100, 0, 200);
      cooldownMax = 100;
      projectileSpeed = 30;
    }
  }
  
  void display() {
    fill(0, 0, 150, 50);
    circle(pos.x, pos.y, range);
    fill(fill);
    if (type.equals("basic")) circle(pos.x, pos.y, size);
    if (type.equals("speedy")) square(pos.x-size/2, pos.y-size/2, size);
    if (type.equals("ranged")) triangle(pos.x, pos.y-size/2, pos.x+size/2, pos.y+size/2, pos.x-size/2, pos.y+size/2);
  }
  
  void update() {
    ArrayList<Enemy> targets = new ArrayList<>();
    for (Enemy enemy : enemies) {
      if (dist(pos.x, pos.y, enemy.pos.x, enemy.pos.y) <= range/2) {
        targets.add(enemy);
      }
    }
    
      for(Enemy enemy : targets) {
        if(enemy.type.equals("fast")) {
          shoot(enemy);
          return;
        }
      }
    
    if (targets.size() > 0) shoot(targets.get(0));
  }
  
  void shoot(Enemy enemy) {
    if (cooldown == 0){
      projectiles.add(new Projectile(new PVector(pos.x, pos.y), new PVector(pos.x-enemy.pos.x, pos.y-enemy.pos.y).normalize(), projectileSpeed));
      cooldown = cooldownMax;
    }
  }
}
