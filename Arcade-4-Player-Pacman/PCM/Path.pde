class Path {
  LinkedList<Node> path = new LinkedList<Node>(); //a list of nodes 
  float distance = 0; //length of path
  float distToFinish = 0; //the distance between the final node and the paths goal
  PVector velAtLast; //the direction the ghost is going at the last point on the path

  //--------------------------------------------------------------------------------------------------------------------------------------------
  //constructor
  Path() {
  }
  //--------------------------------------------------------------------------------------------------------------------------------------------
  //adds a node to the end of the path
  void addToTail(Node n, Node endNode)
  {
    if (!path.isEmpty()) //if path is empty then this is the first node and thus the distance is still 0
    {
      distance += dist(path.getLast().x, path.getLast().y, n.x, n.y); //add the distance from the current last element in the path to the new node to the overall distance
    }

    path.add(n); //add the node
    distToFinish = dist(path.getLast().x, path.getLast().y, endNode.x, endNode.y); //recalculate the distance to the finish
  }
  //--------------------------------------------------------------------------------------------------------------------------------------------
  //return a clone of this 
  Path clone()
  {
    Path temp = new Path();
    temp.path = (LinkedList)path.clone();
    temp.distance = distance;
    temp.distToFinish = distToFinish;
    temp.velAtLast = new PVector(velAtLast.x, velAtLast.y , null);
    return temp;
  }
  //--------------------------------------------------------------------------------------------------------------------------------------------
  //removes all nodes in the path
  void clear()
  {
    distance = 0;
    distToFinish = 0;
    path.clear();
  }
  //--------------------------------------------------------------------------------------------------------------------------------------------
  //draw lines representing the path
  void show() {
    if (path.size() > 0) {
      strokeWeight(2);
      for (int i = 1; i < (path.size()); i++) {
        line((path.get(i-1).x * floor(width/(56))) + (floor(width/112)), (path.get(i-1).y * floor(height/31)) + (floor(height/62)), (path.get(i).x * floor(width/(56))) + (floor(width/112)), (path.get(i).y * floor(height/31)) + (floor(height/62)));
//        path.get(i-1).show(); // Node.show()
      }
      ellipse((path.get(path.size() - 1).x * floor(width/(56))) + (floor(width/112)), (path.get(path.size() - 1).y * floor(height/31)) + (floor(height/62)), 5, 5);
    }
  }
}
