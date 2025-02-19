import java.util.Collections;

ArrayList<Enemy> enemies = new ArrayList<>();
ArrayList<Projectile> projectiles = new ArrayList<>();
ArrayList<Tower> towers = new ArrayList<>();
ArrayList<Reward> rewards = new ArrayList<>();

int projectileSize = 20;
ArrayList<Enemy> enemySpawnPool = new ArrayList<>();

int enemyCooldownMax = 40;
int waveCooldownMax = 360;

int enemyCooldown = 0;
int waveCooldown = 360;
int moneyAlertTimer = 0;
int placeAlertTimer = 0;
int limitAlertTimer = 0;
int hurtTimer = 0;

int health = 3;

int money = 170;
int basicTowerPrice = 100;
int rangedTowerPrice = 100;
int speedyTowerPrice = 150;

int towerLimit = 5;

int wave = 1;
boolean waveOngoing = false;

String placementMode = "none";
int currentTowerPrice = 0;

void setup() {
  size(1500, 800);
}

void draw() {
  background(84, 140, 47);
  noStroke();
  
  //Path
  fill(200);
  rect(0, 400, 375, 80);
  rect(375, 200, 80, 280);
  rect(375, 200, 375, 80);
  rect(750, 200, 80, 450);
  rect(750, 650, 375, 80);
  rect(1125, 400, 80, 330);
  rect(1125, 400, 375, 80);
  
  //Prepare wave
  if (!waveOngoing && waveCooldown == 0) {
    switch (wave){
      case 1:
        //10 slow - $50
        enemyCooldownMax = 60;
        createWave(10, 0);
        break;
      case 2:
        // 10 slow, 2 fast - $70
        enemyCooldownMax = 30;
        createWave(10, 2);
        break;
      case 3:
        // 12 slow, 3 fast - $90
        enemyCooldownMax = 30;
        createWave(12, 3);
        break;
      case 4:
        // 15 slow, 5 fast - $125
        enemyCooldownMax = 30;
        createWave(15, 5);
        break;
      case 5:
        // 17 slow, 8 fast - $165
        enemyCooldownMax = 25;
        createWave(17, 8);
        break;
      case 6:
        // 20 slow, 15 fast - $250
        enemyCooldownMax = 20;
        createWave(20, 15);
        break;
      case 7:
        // 30 slow, 20 fast - $350
        enemyCooldownMax = 20;
        createWave(30, 20);
        break;
      case 8:
        // 0 slow, 50 fast - $500
        enemyCooldownMax = 8;
        createWave(0, 50);
        break;
    }
    waveOngoing = true;
  }
  
  //Spawn enemy
  if (enemySpawnPool.size() > 0 && enemyCooldown == 0) {
    enemies.add(enemySpawnPool.remove(0));
    enemyCooldown = enemyCooldownMax;
  }
  if (enemyCooldown > 0) enemyCooldown -= 1;
  
  if (enemies.isEmpty() && waveOngoing) {
    if (wave == 8) {
      fill(0, 255, 0);
      textSize(256);
      textAlign(CENTER,CENTER);
      text("YOU WIN!", width/2, height/2);
      stop();
    } else {
      wave++;
      waveOngoing = false;
      waveCooldown = waveCooldownMax;
    }
  }
  
  if (waveCooldown > 0) waveCooldown -= 1;

  //Towers
  for (Tower tower : towers) {
    tower.display();
    tower.update();
    if (tower.cooldown > 0) tower.cooldown -= 1;
  }
  
  //Projectiles
  for (Projectile projectile : projectiles) {
    projectile.display();
    projectile.move();
  }
  
  //Enemies
  for (Enemy enemy : enemies) {
    enemy.display();
    enemy.move();
  }
  
  //Rewards
  for (Reward reward : rewards) {
    reward.display();
    reward.move();
  }
  rewards.removeIf(reward -> reward.timer == 0);
  
  //Remove inactive enemies and projectiles
  enemies.removeIf(enemy -> !enemy.active);
  projectiles.removeIf(projectile -> !projectile.active);

  //Display wave, health, money
  fill(0);
  textSize(32);
  textAlign(LEFT);
  text("Wave: " + wave + "/8", 25, 50);
  text("Health: " + health + "/3", 25, 100);
  text("Money: $" + money, 25, 150);
  
  //Display instructions
  text("You can place up to " + towerLimit + " towers", 25, 650);
  text("Press 1 to place a basic tower", 25, 690);
  text("Press 2 to place a ranged tower", 25, 730);
  text("Press 3 to place a speedy tower", 25, 770);
  
  //Display money alert
  if (moneyAlertTimer > 0) {
    fill(255, 165, 0);
    textAlign(CENTER);
    text("Not enough money!", width/2, 125);
  }
  if (moneyAlertTimer > 0 ) moneyAlertTimer -= 1;
  
  //Display place alert
  if (placeAlertTimer > 0) {
    fill(255, 100, 100);
    textAlign(CENTER);
    text("Tower is too close to road or other tower!", width/2, 125);
  }
  if (placeAlertTimer > 0 ) placeAlertTimer -= 1;
  
  //Display limit alert
  if (limitAlertTimer > 0) {
    fill(255, 200, 100);
    textAlign(CENTER);
    text("You've reached the tower limit!", width/2, 125);
  }
  if (limitAlertTimer > 0 ) limitAlertTimer -= 1;
  
  //Display placement mode text
  if (!placementMode.equals("none")) {
    fill(0, 0, 200);
    textSize(64);
    textAlign(CENTER);
    text("Click to place a " + placementMode + " tower (cost: $" + currentTowerPrice + ")", width/2, 75);
  }
  
  //Display hurt
  if (hurtTimer > 0) {
    fill(255, 0, 0, hurtTimer);
    rect(0, 0, width, height);
  }
  if (hurtTimer > 0 ) hurtTimer -= 1;
  
  //Game Over
  if (health <= 0) {
    fill(255, 0, 0);
    textSize(256);
    textAlign(CENTER,CENTER);
    text("GAME OVER", width/2, height/2);
    stop();
  }

}

void keyPressed() {
  if (key == '1') {
    if (placementMode.equals("basic")) {
      placementMode = "none";
      return;
    }
    placementMode = "basic";
    currentTowerPrice = basicTowerPrice;
  } else if (key == '2') {
    if (placementMode.equals("ranged")) {
      placementMode = "none";
      return;
    }
    placementMode = "ranged";
    currentTowerPrice = rangedTowerPrice;
  } else if (key == '3') {
    if (placementMode.equals("speedy")) {
      placementMode = "none";
      return;
    }
    placementMode = "speedy";
    currentTowerPrice = speedyTowerPrice;
  }
}

void mouseClicked() {
  if (!placementMode.equals("none")) {
    
    if (towers.size() == 5) {
        limitAlertTimer = 60;
        return;
     }
    
    for (Tower tower : towers) {
      if (dist(mouseX, mouseY, tower.pos.x, tower.pos.y) <= 60) {
        placeAlertTimer = 60;
        return;
      }
    }
    
    if (get(mouseX + 30, mouseY + 30) == color(200) || get(mouseX + 30, mouseY - 30) == color(200) || get(mouseX - 30, mouseY + 30) == color(200) || get(mouseX - 30, mouseY - 30) == color(200)) {
      placeAlertTimer = 60;
      return;
    }
    
    if (money >= currentTowerPrice) {
        towers.add(new Tower(new PVector(mouseX, mouseY), placementMode));
        money -= currentTowerPrice;
      } else {
        moneyAlertTimer = 60;
      }
  }
}

void createWave(int slows, int fasts) {
  for(int i = 0; i < slows; i++) {
    enemySpawnPool.add(new Enemy(new PVector(0, 440), "slow"));
  }
  for(int i = 0; i < fasts; i++) {
    enemySpawnPool.add(new Enemy(new PVector(0, 440), "fast"));
  }
  Collections.shuffle(enemySpawnPool);
}
