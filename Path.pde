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
     //Find a random different point
     do{ indexB = (int)random(orderedPoints.size());
     }while(indexA == indexB);
     
     //Swap the two
     PVector pointA = mutatedPath.orderedPoints.get(indexA);
     PVector pointB = mutatedPath.orderedPoints.get(indexB);
     mutatedPath.orderedPoints.set(indexA, pointB);
     mutatedPath.orderedPoints.set(indexB, pointA);
   }
   return mutatedPath;
 }
 
 public Path crossover(Path mate, int nodeCount)
 {
   Path child = new Path();
   child.orderedPoints = new ArrayList<PVector>();
   for(int j = 0; j < nodeCount; j++)
   {
     if(j < nodeCount / 2)
     {
       child.orderedPoints.add(mate.orderedPoints.get(j));
     }else{
       int k = 0;
       PVector candidate = new PVector();
       do{ candidate = orderedPoints.get(k); k++;}
         while(child.orderedPoints.contains(candidate));
       child.orderedPoints.add(candidate);
     }
   }
   if(child.getLength() < this.getLength())
   {
     return child;
   }else{
     return this;
   }
  }
  
  public ArrayList<Path> sortPaths(ArrayList<Path> toSort)
  {
    float[] lengths = new float[toSort.size()];
    for(int i = 0; i < toSort.size(); i++)
    {
      Path p = toSort.get(i);
      lengths[i] =  p.getLength();
    }
    lengths = sort(lengths);
    ArrayList<Path> sorted = new ArrayList<Path>();
    for(int j = 0; j < lengths.length; j++){
      Path pathOfJLength = new Path();
      for(int k = 0; k < toSort.size(); k++)
      {
        Path test = (Path)toSort.get(k);
        if(test.getLength() == lengths[j])
        {
          pathOfJLength = test;
          break;
        }
      }
      sorted.add(pathOfJLength);
    }
    return sorted;
  } 
}