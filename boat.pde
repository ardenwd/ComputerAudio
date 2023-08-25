class Boat{
  float xPos = 0;
  float yPos = 0;
  float speed = 0;
  float direction = 0;
  float maxAngle = TWO_PI; 
  boolean crewReadiness = false;
  
  public float getXPos() { return xPos;}
  public float getYPos() { return yPos;}
  public float getSpeed() { return speed; }
  public float getDirection() { return direction; }
 // public float getNormalizedWindDirection() { return normalizedWindDirection; }
  Boat(){};
  
  Boat( float xPos, float yPos, float speed){
    this.speed = speed;
    this.xPos = xPos;
    this.yPos = yPos;
  }
  
  public void setCrewReadiness(float x, float y){
    //use the positions of the people on the boat the decide if the crew is ready at the first call
     this.crewReadiness = (x + y) % 2 == 1;
  }
  
  
  
  public void turn(float turnAmount, Wind w){
   this.direction = (this.direction + turnAmount) % maxAngle;
   System.out.println("The direction is " + this.direction);
   this.direction %= maxAngle;
   w.computeAngle(w.xPos, w.yPos, this);
   w.calculateBoatSpeed(this);
  // p.setPos(boat.getNormalizedWindDirection());
   System.out.println("turned " + turnAmount + " radians. The direction is " + this.direction);
  }
  
  public void move(Wind w){
   float distance = speed;
   w.calculateBoatSpeed(this);
   this.xPos = xPos + (distance * cos(direction));
   this.yPos = yPos + (distance * sin(direction));
   System.out.println("the new position is (" + xPos + ", " + yPos + ") and the speed was " + speed + " and the angle is " + direction);
   //if(xPos > 100 || xPos < -100 || yPos > 100 || yPos < -100){
   //  this.xPos = 0;
   //  this.yPos = 0;
   //  System.out.println("the new position is reset to zero");
   //}
  }
  
  public void computeAngle( float x, float y){
    float angle= 0.0;    
    float nAngle = 0.0;
    float hp = PI * 0.5;
    
    
    if( x>0 && y>0 ){ angle = atan( y/x);  nAngle = ((hp - atan(y/x))/ hp);}
    else if( x<0 && y>0 ){ angle = atan(y/x) + PI; nAngle = -1.0 * ((hp + atan(y/x))/ hp);}
    else if( x<0 && y<0 ){ angle = atan(y/x) + PI; nAngle = -1.0 * ((atan(y/x))/ hp);}
    else if( x>0 && y<0 ){angle = maxAngle + atan(y/x); nAngle = ((hp + atan(y/x))/ hp);}
    else if( x>0 && y==0 ){ angle = 0; nAngle = 1.0;}
    else if( x==0 && y>0 ){angle = 0.5 * PI; nAngle = 0;}
    else if( x<0 && y== 0){ angle = PI; nAngle = -1.0;}
    else if( x==0 && y<0 ){ angle = 1.5 * PI; nAngle = 0;}
    
    this.direction = angle;
  
  }
 
}
