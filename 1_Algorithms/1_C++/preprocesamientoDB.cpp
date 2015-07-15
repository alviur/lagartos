#include <opencv2/opencv.hpp>
#include <vector>       // std::vector

#include <stdio.h>
#include <stdlib.h>

using namespace std;
using namespace cv;

/***************************************************************************************************
Posterizacion
***************************************************************************************************/

void colorReduceEfficient(cv::Mat &image, int div)//para imagenes que no estan rellenas del todo
{
    int nl=image.rows;
    int nc=image.cols;

    if(image.isContinuous())
    {
        //then no padded pixels
        nc=nc*nl;
        nl=1;//it is now a 1D array
    }
    //this loop is executed only once in case of a continuous image
    for(int j=0; j<nl; j++)
    {
        uchar* data= image.ptr<uchar>(j);
        for(int i=0; i<nc; i++)
        {
            //process each pixel
            data[i]=data[i]/div*div +div/2;
            //end pixel processing
        }//end for
    }//end for

}

/***************************************************************************************************
MAIN
***************************************************************************************************/

int main(int argc, char** argv)
{

   //******************
   //** DATA
   //****************** 
   char *infilename   = argv[1];//primer argumento despues del nombre del programa sera la imagen
   char *outfilenameCLAHE  = argv[2];//Segundo argumento despues del nombre del programa sera nombre para guardar la imagen con CLAHE
   char *outfilenamePOST  = argv[3];//Tercer argumento despues del nombre del programa sera nombre para guardar la imagen posterizada
   char *outfilenameCOLOR  = argv[4];//Cuarto argumento despues del nombre del programa sera nombre para guardar la mascara de color de HSL




    // READ RGB color image and convert it to Lab
    cv::Mat bgr_image = cv::imread(infilename);
//cv::Mat bgr_image = cv::imread("/home/lex/2_SISTEMIC/3_MRF/1_Lagartos/3_images/1.png");
    cv::Mat lab_image;//imagen en el espacion LAB
    cv::Mat posterized_image;//imagen posterizada
    cv::Mat HSL_image;//imagen posterizada
    cv::Mat mask_color;//mascara de color usando espacio HLS	


   //******************
   //** CLAHE
   //****************** 

    cv::cvtColor(bgr_image, lab_image,cv::COLOR_BGR2Lab);

    // Extract the L channel
    std::vector<cv::Mat> lab_planes(3),lab_planes2(3);
    cv::split(lab_image, lab_planes);  // now we have the L image in lab_planes[0]


    // apply the CLAHE algorithm to the L channel
    cv::Ptr<cv::CLAHE> clahe = cv::createCLAHE();
    clahe->setClipLimit(7);
    cv::Mat dst;
    clahe->apply(lab_planes[0], dst);

    // Merge the the color planes back into an Lab image
    dst.copyTo(lab_planes[0]);
    cv::merge(lab_planes, lab_image);


   // convert back to RGB
   cv::Mat image_clahe;
   cv::cvtColor(lab_image, image_clahe,cv::COLOR_Lab2BGR);



   //******************
   //** POSTERIZACION
   //****************** 

   cv::cvtColor(bgr_image,posterized_image,cv::COLOR_BGR2GRAY);	
   
   colorReduceEfficient(posterized_image,85);
    cv::imwrite(outfilenamePOST,posterized_image);

   //******************
   //** CORRECCION HSL
   //****************** 

   cv::cvtColor(bgr_image,HSL_image,cv::COLOR_BGR2HLS);	
    // Extract the L and S channels
    std::vector<cv::Mat> HSL_planes(3);
    cv::split(HSL_image, HSL_planes);  // now we have the L image in lab_planes[0]


threshold(HSL_planes[0],mask_color,80,255,cv::THRESH_OTSU);
threshold(mask_color,mask_color,80,255,1);

   cv::imwrite(outfilenameCOLOR,mask_color);


/*

   //******************
   //** VISUALIZACION--solo descomentar para debuggear
   //****************** 
 cv::namedWindow("Mean shift",0);//crea ventana para mostrar la imagen
   cv::imshow("Mean shift",bgr_image);

 cv::namedWindow("image HSL",0);//crea ventana para mostrar la imagen
   cv::imshow("image HSL",mask_color);

 cv::namedWindow("image POST",0);//crea ventana para mostrar la imagen
   cv::imshow("image POST",posterized_image);

	 cv::namedWindow("image original",0);//crea ventana para mostrar la imagen
	 cv::namedWindow("image CLAHE",0);//crea ventana para mostrar la imagen
   cv::imshow("image original", bgr_image);
   cv::imshow("image CLAHE", image_clahe);
   cv::imwrite(outfilenameCLAHE,image_clahe);

   cv::waitKey();
*/


}
