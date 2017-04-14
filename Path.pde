class Path extends Solution{
 public ArrayList<PVector> orderedPoints;
 private int stagnantGenerations; 
private float lastBestLength;
 public void generateRandomNew(){
   generateRandomPath();
 }
 private void generateRandomPath()
 {
   orderedPoints = new ArrayList<PVector>();
   for(int i = 0; i < map.getNodes().size(); i++)
   {
     PVector point = new PVector();
     do{ point = map.getNodes().get((int)random(map.getNodes().size()));
     }while(orderedPoints.contains(point));     
     orderedPoints.add(point);
   }
 }
 
 public float getFitness(){
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
 
 
 
 public void display(PVector location, int alpha, float xscale, float yscale)
 {
   if(map != null)
   {
      for(PVector node : map.getNodes())
      {
       fill(150);
       ellipse(location.x + node.x * xscale, location.y + node.y * yscale, map.nodeRadius * xscale, map.nodeRadius * yscale); 
      }
   }

   stroke(50+2*alpha,50+2*alpha,50+alpha*3);
   for(PVector pointA : orderedPoints)
   {
     PVector pointB;
     if(orderedPoints.indexOf(pointA) != orderedPoints.size() -1){
       pointB = orderedPoints.get(orderedPoints.indexOf(pointA)+1);
     }else{
       pointB = orderedPoints.get(0);
     }
     line(
       location.x + pointA.x * xscale,
       location.y + pointA.y * yscale,
       location.x + pointB.x * xscale,
       location.y + pointB.y * yscale
     );
   }
 }
 
 public Path mutate(int magnitude)
 {
   ArrayList<Path> paths = new ArrayList<Path>();
   //for(int i = 0; i < map.getNodes().size();i++)
   {
     
     Path mutatedPath = new Path();
     mutatedPath.orderedPoints = (ArrayList<PVector>)orderedPoints.clone();     
     
     for(int m = 0; m < magnitude; m++)
     {
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
         
     
     paths.add(mutatedPath);
   }   
   paths = sortPaths(paths);
   return paths.get(0);
 }
 
 public Path crossover(Solution _mate)
 {
   Path child = new Path();
   Path mate = (Path)_mate; 
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
   if(child.getFitness() < this.getFitness())
   {
     return child;
   }else{
     return this;
   }
  }
  
  
}