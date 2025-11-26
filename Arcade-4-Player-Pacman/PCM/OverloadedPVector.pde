
class PVector {
  float x = 0;
  float y = 0;
  PVector PVectorOld = null;

  PVector()
  {
    x = 1;
    y = 1;
    PVectorOld = null;
  }

  PVector(float tx,float ty)
   {
     x=tx;
     y=ty;
     PVectorOld = null;
   }

  PVector(float tx,float ty,PVector tPVectorOld)
   {
    x = (tx);
    y = (ty);
    PVectorOld = tPVectorOld;
    if (PVectorOld != null)
     {
      PVectorOld.x = x;
      PVectorOld.y = y;
      delete(PVectorOld);
     }
  }

 float mag() {
   return sqrt((x*x) + (y*y));
 }

 void limit(float modulo) {
   float length = sqrt((x*x)+(y*y));
   
   x=x/length; // eenheidsvector
   y=y/length; // eenheidsvector
   x=x*modulo;
   y=y*modulo;
 }

 PVector add(PVector tPVector)
 {
   x += tPVector.x;
   y += tPVector.y;
   return this;
 }

void delete(PVector tPVOld)
 {
   if (tPVOld != null)
     delete(tPVOld); // Test.remove((int)tPVOld->getInstance(this)); // delete(tPVOld);
 }

}
