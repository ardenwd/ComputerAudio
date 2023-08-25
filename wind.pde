class Wind{
  //this should be value from 1-10
  float speed = 0;
  float direction = 0;
  float relDirection = 0;
  float normalizedDirection = 0;
  float xPos= 0;
  float yPos= 0;
  float maxAngle = TWO_PI;
  float distance = 0;
  

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
    //calculate the angle based on x and y position
    computeAngle(xPos, yPos, b);
  }
  
  
  public void calculateBoatSpeed(Boat b){
    //if the boat is pointed directly into the wind, it will not move
   //the direction must be at least 30 degrees off at either side
   //float rel = (direction - direction) % maxAngle;
   float rel = relDirection;
  // System.out.println("the relative direction is " + rel + " and the wind speed is " + this.speed);
    if((rel > (PI /6.0)) && (rel < (11.0/6.0 * PI))){
      
     // System.out.println("enter loop" );
      b.speed = this.speed;
    }
    else{
      b.speed = 0;
    }
    //System.out.println("setting the boat's speed to " + this.speed );
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
    
 System.out.println("1  wind: " + this.direction + "   relative wind: " + this.relDirection);
 
   this.direction = angle;
   // this.normalizedDirection = nAngle;
     if(direction>maxAngle){
    this.direction = angle % maxAngle;
     }
    relDirection = (direction - b.direction) % maxAngle;
    if(relDirection < 0){
      relDirection += maxAngle;
    }
     System.out.println("2  wind: " + this.direction + "   relative wind: " + this.relDirection);
    
        if (relDirection < PI){
      this.normalizedDirection = (relDirection * (-2.0/(PI))) + 1.0;
    }
    
    if (relDirection >= PI){
      this.normalizedDirection = (relDirection * (2.0/(PI))) - 3.0;
    }
    
     System.out.println("3  wind: " + this.direction + "   relative wind: " + this.relDirection);
     
    this.distance = hypotenuse(x,y,b.xPos, b.yPos);
    
   // this.direction -= direction;
  // System.out.println("relDirection: " + relDirection);
  //  System.out.println("you are pointed: " + this.direction + "   and the wind is at: " + this.direction + " so you should hear it at " + (this.normalizedDirection));
    System.out.println("4  wind: " + this.direction + "   relative wind: " + this.relDirection);
  //}
 
  }
}
