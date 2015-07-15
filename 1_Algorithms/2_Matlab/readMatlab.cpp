#include <iostream>
#include <string>

#include <opencv2/opencv.hpp>

using namespace cv;
using namespace std;

int main (int argc, char * const argv[])
{   
    Mat var1;
    Mat var2;

    string demoFile  = "variableA.yml";

    FileStorage fsDemo( demoFile, FileStorage::READ);
    fsDemo["a"] >> var1;

namedWindow("a",0);
imshow("a",var1);
waitKey(0);    
    cout << "Print the contents of var1:" << endl;
    cout << var1 << endl << endl;


    fsDemo.release();
    return 0;
}
