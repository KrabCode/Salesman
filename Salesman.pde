//MAP
Map map;
private int xMax;
private int yMax;
private int nodeCount = 30;

//PATHS
private ArrayList<Path> paths;
private int pathCount = nodeCount;

//MUTATIONS
private int childCount = pathCount * 3;
private int magnitude = 1;
private int generationsWithoutImprovement = 0;
private int generations;
private float lastBestLength = 0;

public void setup()
{ 
  size(1000, 800);
  background(0);
  frameRate(3);
  xMax = width;
  yMax = height;
  
  map = new Map();
  map.generate(xMax,yMax,nodeCount);
  
  paths = new ArrayList<Path>();
  for(int i = 0; i < pathCount; i++)
  {
    Path path = new Path();
    path.generateRandomPath(map.getNodes());
    paths.add(path);
  }
  map.display();
  paths = sortPaths(paths);
  lastBestLength = paths.get(0).getLength();
}

 

public void draw()
{
  //if(generationsWithoutImprovement < 20)
  {
    nextGen();
    background(0);
    map.display();
    paths.get(0).display();
    displayStats();
  }
}



private void nextGen()
{
   replaceSuckers();
   mutateWinners();
   paths = sortPaths(paths);
   generations++;
   
   // Count the generations that failed to improve upon their parent paths
   if(lastBestLength > paths.get(0).getLength())
   {
    lastBestLength = paths.get(0).getLength();
    generationsWithoutImprovement = 0;
   }else{
     generationsWithoutImprovement++;
   }
}

private void replaceSuckers()
{
  for(int i = paths.size() / 2; i < paths.size(); i++)
  {
    Path p = new Path();
    p.generateRandomPath(map.getNodes());
    paths.set(i, p);
  }
}

private void mutateWinners()
{
  for(int i = paths.size() / 2; i > 0 ; i--)
  {
      if(randomBool())
      {
         Path parent = paths.get(i);
         ArrayList<Path> children = new ArrayList<Path>();     
         for(int j = 0; j < childCount; j++) children.add(parent.mutate(magnitude));
         children = sortPaths(children);     
         if(children.get(0).getLength() < parent.getLength())
         {
           paths.set(i,children.get(0));
         }
      }else{
        
         Path parent = paths.get(i);
         Path mate = paths.get(i + 1);
         paths.set(i, parent.crossover(mate, map.getNodes().size()));
      }
  }  
  /* Crank up the heat in response to generations that failed to improve upon their parent paths
  childCount += generationsWithoutImprovement;
  if(generationsWithoutImprovement > 0)
  {
    for(int i = 0; i < generationsWithoutImprovement; i++)
    {
      Path p = new Path();
      p.generateRandomPath(map.getNodes());
      paths.add(p);
      pathCount++;
    }     
  }*/
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

private void displayStats()
{
    fill(0);
    stroke(255);
    rect(25, 20, 120, 30);
    fill(255);
    text("gen " + generations +": " + paths.get(0).getLength(), 30, 40);
    fill(0);
    stroke(255);
    rect(25, 60, 120, 30);
    fill(255);
    text("no improvement: " + generationsWithoutImprovement, 30, 80);
    fill(0);
    stroke(255);
    rect(25, 100, 80, 30);
    fill(255);
    text("nodes: " + nodeCount, 30, 120);     
    fill(0);
    stroke(255);
    rect(25, 140, 80, 30);
    fill(255);
    text("paths: " + paths.size(), 30, 160);     
    fill(0);
    stroke(255);
    rect(25, 180, 80, 30);
    fill(255);
    text("children: " + childCount, 30, 200);    
    
}

boolean randomBool() {
  return random(1) > .5;
}