import processing.serial.*;

Serial myPort;        // Serial object
String data = "";     // Incoming serial data
float iAngle = 0;     // Current angle of the radar sweep
float iDistance = 0;  // Current measured distance
float objectAngle = 0;
float objectDistance = 0;
boolean objectDetected = false;
boolean useSimulation = false; 

// UI Configurations
int maxDistance = 100; // Maximum range in cm
float radarRadius;

void setup() {
  fullScreen(); 
  smooth();
  
  try {
    myPort = new Serial(this, "COM8", 9600);
    myPort.bufferUntil('.'); 
    println("Successfully connected to COM8");
  } 
  catch (Exception e) {
    println("Error: Could not open COM8. Switching to simulation mode.");
    useSimulation = true;
  }
  
  
  radarRadius = min(width * 0.32, height - 160); 
}

void draw() {
  background(0); // Deep black radar background
  
  if (useSimulation) {
    simulateRadarSweep(); 
  }

  // UI Elements
  drawRadarGrid();
  drawSweepLine();
  drawDetectedObject();
  drawSystemInfo();
  drawLegend();
  drawObjectData();
  drawMaxRange();
}

// --- SERIAL DATA HANDLING ---
void serialEvent(Serial myPort) {
  try {
    data = myPort.readStringUntil('.');
    data = data.substring(0, data.length() - 1); 
    
    int index = data.indexOf(",");
    if (index > 0) {
      String angleStr = data.substring(0, index).trim();
      String distanceStr = data.substring(index + 1).trim();
      
      iAngle = float(angleStr);
      iDistance = float(distanceStr);
      
      if (iDistance > 0 && iDistance <= maxDistance) {
        objectAngle = iAngle;
        objectDistance = iDistance;
        objectDetected = true;
      } else {
        objectDetected = false;
      }
    }
  } catch (Exception e) {
    
  }
}

// --- UI DRAWING FUNCTIONS ---

void drawRadarGrid() {
  pushMatrix();
  // Anchored dynamically at the absolute bottom-center of the active display window
  translate(width / 2, height - 70); 
  
  noFill();
  strokeWeight(1);
  stroke(0, 120, 0); 
  
  // Draw semi-circle distance arcs
  for (int i = 1; i <= 4; i++) {
    float r = (radarRadius / 4) * i;
    arc(0, 0, r * 2, r * 2, PI, TWO_PI);
  }
  
  // Draw angle line spokes
  for (int angle = 0; angle <= 180; angle += 30) {
    float rad = radians(angle);
    float x = cos(PI + rad) * radarRadius;
    float y = sin(PI + rad) * radarRadius;
    line(0, 0, x, y);
    
    // Position labels clear of the outermost line arc boundary
    fill(0, 200, 0);
    textSize(14);
    textAlign(CENTER, CENTER);
    float textX = cos(PI + rad) * (radarRadius + 25);
    float textY = sin(PI + rad) * (radarRadius + 25);
    text(angle + "°", textX, textY);
  }
  
  // Distance milestones along the main vertical sweep access
  fill(0, 200, 0);
  textSize(13);
  textAlign(CENTER, BOTTOM);
  text("25 cm", 0, -(radarRadius / 4));
  text("50 cm", 0, -(radarRadius / 4) * 2);
  text("75 cm", 0, -(radarRadius / 4) * 3);
  text("100 cm", 0, -radarRadius);
  
  // Horizontal baseline text tags
  textAlign(CENTER, TOP);
  text("25 cm", -radarRadius * 0.5, 10);
  text("50 cm", 0, 10);
  text("75 cm", radarRadius * 0.5, 10);
  text("100 cm", radarRadius, 10);
  
  popMatrix();
  
  // Header Title
  fill(0, 255, 0);
  textSize(32);
  textAlign(CENTER, TOP);
  text("ARDUINO RADAR SYSTEM", width / 2, 30);
}

void drawSweepLine() {
  pushMatrix();
  translate(width / 2, height - 70);
  strokeWeight(3);
  
  // Fading phosphor simulation trailing behind the sweep sweep angle
  for (int i = 0; i < 20; i++) {
    stroke(0, 255, 0, 255 - (i * 12));
    float rad = radians(iAngle - (i * 0.6)); 
    float x = cos(PI + rad) * radarRadius;
    float y = sin(PI + rad) * radarRadius;
    line(0, 0, x, y);
  }
  popMatrix();
}

void drawDetectedObject() {
  if (objectDetected) {
    pushMatrix();
    translate(width/2, height - 80);
    
    float rad = radians(objectAngle);
    float displayDist = map(objectDistance, 0, maxDistance, 0, radarRadius);
    
    float x = cos(PI + rad) * displayDist;
    float y = sin(PI + rad) * displayDist;
    
    // Draw Red Dot
    fill(255, 0, 0);
    noStroke();
    ellipse(x, y, 14, 14);
    
    // Distance text tag next to the object
    fill(255, 255, 255);
    textSize(13);
    textAlign(LEFT, CENTER);
    text(" " + int(objectDistance) + " cm", x + 10, y);
    
    popMatrix();
  }
}

void drawSystemInfo() {
  int x = 40; // Pin tightly relative to the left margin wall
  int y = 100;
  int w = 210;
  int h = 170;
  
  noFill();
  stroke(0, 100, 0);
  rect(x, y, w, h, 8);
  
  fill(0, 200, 0);
  textSize(14);
  textAlign(LEFT, TOP);
  text("SYSTEM INFO", x + 15, y + 15);
  stroke(0, 100, 0);
  line(x + 15, y + 35, x + w - 15, y + 35);
  
  text("Status     :", x + 15, y + 60);
  fill(0, 255, 0); 
  text("CONNECTED", x + 95, y + 60);
  
  fill(0, 200, 0);
  text("Port         : COM8", x + 15, y + 85);
  text("Baud Rate : 9600", x + 15, y + 110);
  text("Scan Range: 0° - 180°", x + 15, y + 135);
}

void drawLegend() {
  int x = 40; 
  int y = 300; 
  int w = 210;
  int h = 130;
  
  noFill();
  stroke(0, 100, 0);
  rect(x, y, w, h, 8);
  
  fill(0, 200, 0);
  textSize(14);
  textAlign(LEFT, TOP);
  text("LEGEND", x + 15, y + 15);
  stroke(0, 100, 0);
  line(x + 15, y + 35, x + w - 15, y + 35);
  
  fill(0, 255, 0);
  ellipse(x + 25, y + 62, 12, 12);
  fill(200);
  text("Object Detected", x + 45, y + 54);
  
  fill(255, 0, 0);
  ellipse(x + 25, y + 92, 12, 12);
  fill(200);
  text("Strong Object", x + 45, y + 84);
}

void drawObjectData() {
  int x = width - 250; // Dynamic tracking relative to the true hardware right margin edge
  int y = 100;
  int w = 210;
  int h = 170;
  
  noFill();
  stroke(0, 100, 0);
  rect(x, y, w, h, 8);
  
  fill(0, 200, 0);
  textSize(14);
  textAlign(LEFT, TOP);
  text("OBJECT DATA", x + 15, y + 15);
  stroke(0, 100, 0);
  line(x + 15, y + 35, x + w - 15, y + 35);
  
  fill(200);
  if (objectDetected) {
    text("Angle       : " + int(objectAngle) + "°", x + 15, y + 60);
    text("Distance  : " + int(objectDistance) + " cm", x + 15, y + 90);
    fill(255, 0, 0); 
    text("OBJECT DETECTED", x + 15, y + 130);
  } else {
    text("Angle       : --", x + 15, y + 60);
    text("Distance  : --", x + 15, y + 90);
    fill(0, 255, 0); 
    text("CLEAR", x + 15, y + 130);
  }
}

void drawMaxRange() {
  int x = width - 250; 
  int y = 300; 
  int w = 210;
  int h = 130;
  
  noFill();
  stroke(0, 100, 0);
  rect(x, y, w, h, 8);
  
  fill(0, 200, 0);
  textSize(14);
  textAlign(LEFT, TOP);
  text("MAX RANGE", x + 15, y + 15);
  stroke(0, 100, 0);
  line(x + 15, y + 35, x + w - 15, y + 35);
  
  fill(0, 255, 0);
  textSize(28);
  textAlign(CENTER, CENTER);
  text(maxDistance + " cm", x + (w / 2), y + 80);
}

// --- SIMULATION LOOP ---
float sweepDirection = 1;
void simulateRadarSweep() {
  iAngle += (1.5 * sweepDirection);
  if (iAngle >= 180 || iAngle <= 0) {
    sweepDirection *= -1; 
  }
  
  if (abs(iAngle - 157) < 2) {
    objectAngle = 157;
    objectDistance = 27;
    objectDetected = true;
  } else {
    objectDetected = false; 
  }
}
