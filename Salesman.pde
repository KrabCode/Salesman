
//MAP
Map map;
private int xMax;
private int yMax;
private int nodeCount = 16;

//PATHS
private ArrayList<Path> paths;
private int pathCount =  nodeCount;

//MUTATIONS
private int childCount = pathCount*3;
private int magnitude = 3;

private int generations;

public void setup()
{ 
  fullScreen();
  frameRate(30);
  xMax = width;
  yMax = height;
  runNewMap();
}

public void draw()
{
  if(paths.get(0).stagnantGenerations > 200)
  {
    runNewMap();
  }else{
    nextGen();
    noStroke();
    fill( 0, 0, 0,80);
    rect(0, 0, width, height);
    displayBestPath();
    displaySuckers(5);
    displayStats();
  }
}

void runNewMap()
{
  background(0);
  generations = 0;

  map = new Map();
  map.generate(xMax,yMax,nodeCount);
  
  paths = new ArrayList<Path>();
  for(int i = 0; i < pathCount; i++)
  {
    Path path = new Path();
    path.generateRandomPath();
    paths.add(path);
    path.stagnantGenerations = 0;
    path.lastBestLength = path.getFitness();
  }
  paths = sortPaths(paths);
   
}

private void displayBestPath()
{
  paths.get(0).display(
    /*location:*/   new PVector(50,200),    
    /*opacity: */   paths.get(0).stagnantGenerations,
    /*Xscale: */    0.7,
    /*Yscale: */    0.6
    );
}

private void displaySuckers(int count)
{
  for(int i = 1; i < count + 1; i++)
  {
    int x = width - width / 5;
    int y = 0 + (i - 1) * height/count;
    paths.get(i).display(
    /*location:*/   new PVector(x,y),    
    /*opacity: */   paths.get(i).stagnantGenerations * 2,
    /*Xscale: */    0.2,
    /*Yscale: */    0.2
    );
    
    fill(10);
    stroke(25);
    rect (x, y, 30 , 25);
    fill(255);
    text((i+1)+".",  x+5, y + 20);
  }
      
}

private void nextGen()
{
   replaceSuckers();
   mutateWinners();
   paths = sortPaths(paths);
   generations++;
   
   for(Path p : paths)
   {
     // Count the generations that failed to improve upon their parent paths
     if(p.lastBestLength > p.getFitness() || p.lastBestLength == 0)
     {
        p.lastBestLength = p.getFitness();
        p.stagnantGenerations = 0;
     }else{
        p.stagnantGenerations++;
     }
   }
}

private void replaceSuckers()
{
  for(int i = paths.size() - paths.size() / 6; i < paths.size(); i++)
  {
    Path p = new Path();
    p.generateRandomPath();
    paths.set(i, p);
  }
}

private void mutateWinners()
{
  for(int i = paths.size() / 6; i > 0 ; i--)
  {
    Path parent = paths.get(i);
    ArrayList<Path> children = new ArrayList<Path>(); 
    if(randomBool())
    {  
       for(int j = 0; j < childCount; j++) children.add(parent.mutate(magnitude));
       
    }else{        
       for(int j = paths.size() / 2; j > 0 ; j--)
        {
           Path mate = paths.get(i + 1);
           children.add(parent.crossover(mate));
        }
    }
    children = sortPaths(children);     
    if(children.get(0).getFitness() < parent.getFitness())
    {
     paths.set(i,children.get(0));
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

private float getAverageFitness()
{
  float total = 0;
  int count = 0;
  for(Path p : paths)
  {
    total += p.getFitness();
    count++;
  }
  return total/count;
}

private ArrayList<Path> sortPaths(ArrayList<Path> toSort)
{
  float[] lengths = new float[toSort.size()];
  for(int i = 0; i < toSort.size(); i++)
  {
    lengths[i] =  toSort.get(i).getFitness();
  }
  lengths = sort(lengths);
  ArrayList<Path> sorted = new ArrayList<Path>();
  for(int j = 0; j < lengths.length; j++){
    Path pathOfJLength = new Path();
    for(int k = 0; k < toSort.size(); k++)
    {
      if(toSort.get(k).getFitness() == lengths[j])
      {
        pathOfJLength = toSort.get(k);
        break;
      }
    }
    sorted.add(pathOfJLength);
  }
  return sorted;
} 

private void displayStats()
{
    String[] statsText = new String[]{
    /*0*/    "length",       
    /*1*/    "average",
    /*2*/    "generation",   
    /*3*/    "stagnant",
    };   
    
    PFont mono;
    mono = loadFont("LiberationMono-20.vlw");
    textFont(mono);
    
    for(int i = 0; i < statsText.length; i++)
    {
      fill(10);
      stroke(25);
      rect (25, 20 + i * 40, 270 , 30);
      Object value = 0;
      switch(i)
      {
       case 0: value = paths.get(0).lastBestLength;       break;
       case 1: value = getAverageFitness();               break;
       case 2: value = generations;                       break;
       case 3: value = paths.get(0).stagnantGenerations;  break;
      }
      fill(255);
      stroke(255);
      text(statsText[i] + ": ", 35, 43 + i * 40);
      text(value + "", 180, 43 + i * 40);
    }    
}
public void mousePressed()
{
  if(mouseX < width/2 && mouseY < height/2) runNewMap();
}

boolean randomBool() {
  return random(1) > .5;
}