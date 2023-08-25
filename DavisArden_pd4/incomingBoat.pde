class IncomingBoat{
  //this should be value from 1-10
  float speed = 0;
  float direction = 0;
  float relDirection = 0;
  float normalizedDirection = 0;
  float xPos= 0;
  float yPos= 0;
  float distance = 0;
  float maxAngle = TWO_PI;
  boolean active = false;
  
  
  public float getXPos() { return xPos;}
  public float getYPos() { return yPos;}
  public float getSpeed() { return speed; }
  public float getDirection() { return direction; }
  public float getNormalizedDirection() { return normalizedDirection; }
  public float getRelDirection() { return relDirection; }
  
  public void setData(float xPos, float yPos, float speed, Boat b){
    this.speed = speed;
    this.xPos = xPos;
    this.yPos = yPos;
    this.active = true;
    //calculate the angle based on x and y position
    computeAngle(xPos, yPos, b);
  }
  
    public void move(Boat b){
      System.out.println("the old position is of the incoming boat is(" + xPos + ", " + yPos + ") and the speed was " + speed);
     computeAngle(this.xPos, this.yPos, b);
     this.xPos = xPos + (speed * cos(direction));
     this.yPos = yPos + (speed * sin(direction));
      this.distance = hypotenuse(xPos,yPos,b.xPos, b.yPos);
      if(distance > 50){ this.active = false; }
     System.out.println("the new position is of the incoming boat is(" + xPos + ", " + yPos + ") and the speed was " + speed);
  }
  
  public void computeAngle( float x, float y, Boat b){
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
    

  System.out.println("the incoming boat's direction is *******" + relDirection + " and the norm is " + normalizedDirection);
   // this.normalizedDirection = nAngle;
     if(direction>maxAngle){
    this.direction = angle % maxAngle;
     }
    System.out.println("the incoming boat's direction is *******" + relDirection + " and the norm is " + normalizedDirection);
    this.relDirection = (direction - b.direction) % maxAngle;
    if(relDirection < 0){
      this.relDirection += maxAngle;
    }
    
        if (relDirection < PI){
      this.normalizedDirection = (relDirection * (-2.0/(PI))) + 1.0;
    }
    
    if (relDirection >= PI){
      this.normalizedDirection = (relDirection * (2.0/(PI))) - 3.0;
    }
    this.distance = hypotenuse(xPos,yPos,b.xPos, b.yPos);
      if(distance > 50){ this.active = false; }
    
    
    System.out.println("the incoming boat's direction is *******" + relDirection + " and the norm is " + normalizedDirection + " and the distance is " + distance);
  }
  
}
