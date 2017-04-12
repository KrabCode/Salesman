//MAP
Map map;
private int xMax;
private int yMax;
private int nodeCount = 15;

//PATHS
private ArrayList<Path> paths;
private int pathCount = 100;

//MUTATIONS
private int childCount = 1000;
private int magnitude = 2;
private float lastWin = 0;

public void setup()
{
  fullScreen();
  background(0);
  frameRate(30);
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
  lastWin = paths.get(0).getLength();
}

public void draw()
{
  nextGen();
  background(0);
  map.display();
  paths.get(0).display();
  println(paths.get(0).getLength());
}

private void nextGen()
{
  while(lastWin < paths.get(0).getLength())
  {
     replaceSuckers();
     mutateEveryone();
     paths = sortPaths(paths);
  }
}


private ArrayList<Path> sortPaths(ArrayList<Path> toSort)
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

private void replaceSuckers()
{
  for(int i = paths.size() / 2; i < paths.size(); i++)
  {
    Path p = new Path();
    p.generateRandomPath(map.getNodes());
    paths.set(i, p);
  }
}

private void mutateEveryone()
{
  for(int i = 0; i < paths.size(); i++)
  {
     Path parent = paths.get(i);
     ArrayList<Path> children = new ArrayList<Path>();     
     for(int j = 0; j < childCount; j++) children.add(parent.mutate(magnitude));
     children = sortPaths(children);     
     if(children.get(0).getLength() < parent.getLength())
     {
       paths.set(i,children.get(0));
     }
  }
}