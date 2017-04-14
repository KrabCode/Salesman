abstract class Solution{
  abstract float getFitness();
  abstract Solution mutate(int magnitude);
  abstract Solution crossover(Solution mate);
  abstract void generateRandomNew();
  public ArrayList<Path> sortPaths(ArrayList<Path> toSort)
  {
    float[] lengths = new float[toSort.size()];
    for(int i = 0; i < toSort.size(); i++)
    {
      Path p = toSort.get(i);
      lengths[i] =  p.getFitness();
    }
    lengths = sort(lengths);
    ArrayList<Path> sorted = new ArrayList<Path>();
    for(int j = 0; j < lengths.length; j++){
      Path pathOfJLength = new Path();
      for(int k = 0; k < toSort.size(); k++)
      {
        Path test = (Path)toSort.get(k);
        if(test.getFitness() == lengths[j])
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