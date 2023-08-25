enum IDType { Boat, IncomingBoat, Wind, Puff, Crew, Warning, Message};

class Notification {
  
  float xPos;
  float yPos;
  int timestamp;
  float speed;
  boolean hasRightOfWay;
  IDType ID;
  String message;
  
  
  public Notification(JSONObject json) {
    this.timestamp = json.getInt("timestamp");
    //time in milliseconds for playback from sketch start
    
    if (json.isNull("xPos")) {
      this.xPos = 0;
    }
    else {
      this.xPos = json.getFloat("xPos");
    }
    
    if (json.isNull("yPos")) {
      this.yPos = 0;
    }
    else {
      this.yPos = json.getFloat("yPos");
    }
    
    if (json.isNull("speed")) {
      this.speed = 0;
    }
    else {
      this.speed = json.getFloat("speed");
      if(this.speed > 10) {this.speed = 10;}
    }
    
    if (json.isNull("hasRightOfWay")) {
      this.hasRightOfWay = false;
    }
    else {
      this.hasRightOfWay = json.getBoolean("hasRightOfWay");
    }
    
    String IDString = json.getString("ID");
    
    try {
      this.ID = IDType.valueOf(IDString);
    }
    catch (IllegalArgumentException e) {
      throw new RuntimeException(ID + " is not a valid value for enum ID.");
    }
    
    if (json.isNull("message")) {
      this.message = "";
    }
    else {
      this.message = json.getString("message");
    }
  }

  public float getXPos() { return xPos;}
  public float getYPos() { return yPos;}
  public int getTimestamp() { return timestamp; }
  public float getSpeed() { return speed; }
  public boolean getHasRightOfWay() { return hasRightOfWay; }
  public IDType getID() { return ID; }
  public String getMessage() { return message; }
  

    public String toString() {
      String output = getID().toString() + ": ";
      output += "(xPos: " + getXPos() + ") ";
      output += "(yPos: " + getYPos() + ") ";
      output += "(speed: " + getSpeed() + ") ";
      output += "(hasRightOfWay: " + getHasRightOfWay() + ") ";
      output += "(message: " + getMessage() + ") ";
      return output;
    }
}
