/***********************************************************************
*
*
 ************************************************************************/

//***************************
//** Declaracion de librerias
//*************************** 
//** Estandar
#include <stdio.h>
#include <iostream>
#include <cstdlib>
//** OpenCV
#include "opencv2/opencv.hpp"
//**Maxflow-lib
#include "graph.h"


using namespace cv;
using namespace std;


int main(int argc, char** argv)
{

   
    //*******************
    //**Images
    //*******************	
    cv::Mat img_src;//source image
    cv::Mat img_src_posterizada;//source image
    cv::Mat img_out;//output image
    cv::Mat img_srcGray;//source image gray scaled
    cv::Mat img_srcBinary;//source image binary	
    cv::Mat Resultado;//resultado del MRF

	


   //*******************
   //** Typedefs
   //*******************
	typedef Graph<int,int,int> GraphType;
	GraphType *g = new GraphType(/*estimated # of nodes*/ 2, /*estimated # of edges*/ 1); 
	int numberNodes;



    //**********************
    //**image preprocessing
    //**********************

   char *infilename   = argv[1];//primer argumento despues del nombre del programa sera la imagen
   char *infilenamePosterizada  = argv[2];//Segundo argumento despues del nombre del programa sera nombre para mascara de color
   char *outfilenameResultadoMRF  = argv[3];//Tercer argumento despues del nombre del programa sera el nombre del resultado del MRF

   int inferencia = atoi(argv[4]);
   int funcion = atoi(argv[5]);
   int umbral = atoi(argv[6]);
   int peso = atoi(argv[7]);
   int iteraciones = atoi(argv[8]);//Solo loopy belief propagation

    img_src=cv::imread(infilename);
	img_src_posterizada=cv::imread(infilenamePosterizada,0);
    img_srcGray=cv::imread(infilename,0);
	img_srcGray.copyTo(Resultado);
 
   //*****************
   //** HELP
   //*****************
   /* if (argc != 3){
       std::cerr << "Uso: "<<argv[0]<<" Imagen de entrada al algoritmo" << std::endl;
       exit(-1);
    }*/


   //********************************
   //** Escalamiento de las imagenes
   //****************** *************


	cv::resize(img_src,img_src,cv::Size(500,500));
	cv::resize(Resultado,Resultado,cv::Size(500,500));
	cv::resize(img_srcGray,img_srcGray,cv::Size(500,500));
	cv::resize(img_src_posterizada,img_src_posterizada,cv::Size(500,500));



   //********************************
   //** Visualizacion de las imagenes
   //****************** *************

/*
    cv::namedWindow("In",0);	   
    cv::namedWindow("Color mask",0); 

    cv::imshow("In",img_src);//show image   
    cv::imshow("Color mask",img_src_posterizada);//show image
	cv::waitKey(0);*/
 
   //***********************
   //** Estructura para MRF
   //***********************

	numberNodes=img_src.cols*img_src.rows; 
	for(int i=0;i<numberNodes;i++)g -> add_node(); //Añade nodos a la red

   //** Añade Capacidades

	int sourceCapacitie=0;
	int sinkCapacitie=0;

	for(int i=0;i<img_src.rows;i++)
	{	
		for(int j=0;j<img_src.cols;j++)
		{
			g -> add_tweights( sourceCapacitie,250-img_srcGray.at<uchar>(i,j),  1, sinkCapacitie );
		}

	}
	





    //cv::imshow("Color_mask",img_srcBinary);//show image
   // imwrite("Color_mask.jpg",img_srcBinary); 	
  //  cv::waitKey(0);

   //***************************
   //** Construccion del modelo
   //***************************

   //** Añade Edge

	for(int i=0;i<img_src.rows;i++)
	{	

		for(int j=0;j<img_src.cols;j++)
		{
			g -> add_edge( 0, 1,    /* capacities */  3, 4 );
		}

	}
	



