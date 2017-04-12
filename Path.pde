class Path{
 public ArrayList<PVector> orderedPoints;

 public void generateRandomPath(ArrayList<PVector> map)
 {
   orderedPoints = new ArrayList<PVector>();
   for(int i = 0; i < map.size(); i++)
   {
     PVector point = new PVector();
     do{ point = map.get((int)random(map.size()));
     }while(orderedPoints.contains(point));     
     orderedPoints.add(point);
   }
 }
 
 public float getLength(){
   float total = 0;
   for(PVector pointA : orderedPoints)
   {
     PVector pointB;
     if(orderedPoints.indexOf(pointA) != orderedPoints.size() - 1){ 
       pointB = orderedPoints.get(orderedPoints.indexOf(pointA)+1);
     }else{
       pointB = orderedPoints.get(0); 
     }
     total += PVector.dist(pointA, pointB);
   }
   return total;
 }
 
 public void display()
 {
   stroke(255);
   for(PVector pointA : orderedPoints)
   {
     PVector pointB;
     if(orderedPoints.indexOf(pointA) != orderedPoints.size() -1){
       pointB = orderedPoints.get(orderedPoints.indexOf(pointA)+1);
     }else{
       pointB = orderedPoints.get(0);
     }
     text(pointA.toString(),pointA.x, pointA.y);
     line(pointA.x, pointA.y, pointB.x, pointB.y);
   }
 }
 
 public Path mutate(int magnitude)
 {
   Path mutatedPath = new Path();
   mutatedPath.orderedPoints = (ArrayList<PVector>)orderedPoints.clone();
   for(int i = 0; i < magnitude; i++)
   {
     //Pick first point at random
     int indexA = (int)random(orderedPoints.size());
     int indexB = 0;
     //Find a different point
     if(indexA != orderedPoints.size() -1){
       indexB = indexA + 1;
     }else{
       indexB = 0;
     }
     PVector pointA = mutatedPath.orderedPoints.get(indexA);
     PVector pointB = mutatedPath.orderedPoints.get(indexB);
     //Swap the two
     mutatedPath.orderedPoints.set(indexA, pointB);
     mutatedPath.orderedPoints.set(indexB, pointA);
   }
   return mutatedPath;
 }
 
}