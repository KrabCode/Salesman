class Map{
 private ArrayList<PVector> nodes;
 private int nodeRadius = 10;
 
 public void generate(int xMax, int yMax, int nodeCount)
 {
   nodes = new ArrayList<PVector>();
   for(int i = 0; i < nodeCount; i++)
   {
     int x = (int)random(xMax);
     int y = (int)random(yMax);
     nodes.add(new PVector(x, y));
   }
 }
 
 public ArrayList<PVector> getNodes()
 {
   return nodes;
 }
 
 public void display()
 {
  for(PVector node : nodes)
  {
   fill(150);
   ellipse(node.x, node.y, nodeRadius, nodeRadius); 
  }
 }
}