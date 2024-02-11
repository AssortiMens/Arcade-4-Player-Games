class Node {
  LinkedList<Node> edges = new LinkedList<Node>(); // all the nodes this node is connected to 
  float x;
  float y;
  float smallestDistToPoint = 10000000; // the distance of smallest path from the start to this node 
  int degree;
  int value;  
  boolean checked = false;
  //-------------------------------------------------------------------------------------------------------------------------------------------------
  //constructor
  Node(float x1, float y1) {
    x = x1;
    y = y1;
  }
  //-------------------------------------------------------------------------------------------------------------------------------------------------
  //draw a little circle
  void show() {
    fill(0, 100, 100);
    ellipse(x*floor(width/(2*28)) + floor(width/112), y*floor(height/31) + floor(height/62), 10, 10 );
  }

  //-------------------------------------------------------------------------------------------------------------------------------------------------
  //add all the nodes this node is adjacent to 
  void addEdges(ArrayList<Node> nodes) {
    for (int i = 0; i < nodes.size(); i++) {//for all the nodes
      if ((nodes.get(i).y == y) ^ (nodes.get(i).x == x)) {
        if (nodes.get(i).y == y) {//if the node is on the same line horizontally
          float mostLeft = min(nodes.get(i).x, x);
          float max = max(nodes.get(i).x, x);
          boolean edge = true;
          while (mostLeft < max) {//look from the one node to the other looking for a wall
            if (tiles[(int)y][(int)mostLeft].wall) {
              edge = false;//not an edge since there is a wall in the way
              break;
            }
            mostLeft ++;//move 1 step closer to the other node
          }
          if (edge) {
            edges.add(nodes.get(i));//add the node as an edge
          }
        } else if (nodes.get(i).x == x) {//same line vertically
          float mostUp = min(nodes.get(i).y, y);
          float max = max(nodes.get(i).y, y);
          boolean edge = true;
          while (mostUp < max) {
            if (tiles[(int)mostUp][(int)x].wall) {
              edge = false;
              break;
            }
            mostUp ++;
          }
          if (edge) {
            edges.add(nodes.get(i));
          }
        }
      }
    }
  }
}
