/***********************************************************************
*
*
 ************************************************************************/

   //***************************
   //** Declaracion de librerias
   //*************************** 
#include <stdio.h>
#include <iostream>
#include "opencv2/opencv.hpp"
#include <opengm/opengm.hxx>
#include <opengm/graphicalmodel/graphicalmodel.hxx>
#include <opengm/operations/adder.hxx>
#include <opengm/functions/potts.hxx>
#include <opengm/functions/absolute_difference.hxx>
#include <opengm/functions/squared_difference.hxx>
#include <opengm/functions/truncated_squared_difference.hxx>
#include <opengm/inference/messagepassing/messagepassing.hxx>
#include <opengm/inference/gibbs.hxx>


using namespace cv;
using namespace std;
using namespace opengm;

int main(int argc, char** argv)
{

   
    //*******************
    //**Images
    //*******************	
    cv::Mat img_src;//source image
    cv::Mat img_out;//output image
    cv::Mat img_srcGray;//source image gray scaled
    cv::Mat img_srcBinary;//source image binary	


   //*******************
   //** Typedefs
   //*******************
   typedef double                                                                 ValueType;          // type used for values
   typedef size_t                                                                 IndexType;          // type used for indexing nodes and factors (default : size_t)
   typedef size_t                                                                 LabelType;          // type used for labels (default : size_t)
   typedef opengm::Adder                                                          OpType;             // operation used to combine terms
typedef opengm::ExplicitFunction<ValueType,IndexType,LabelType>                ExplicitFunction;   // shortcut for explicite function 
   typedef opengm::TruncatedSquaredDifferenceFunction<ValueType,IndexType,LabelType>                   TruncatedSquaredDifferenceFunction;      // shortcut for Potts function
  
typedef opengm::meta::TypeListGenerator<ExplicitFunction,TruncatedSquaredDifferenceFunction>::type  FunctionTypeList;   // list of all function the mo
//typedef opengm::meta::TypeListGenerator<ExplicitFunction,PottsFunction>::type  FunctionTypeList;   // list of all function the model cal use (this trick avoids virtual methods) - here only one
   typedef opengm::meta::TypeListGenerator<ExplicitFunction,TruncatedSquaredDifferenceFunction>::type  FunctionTypeList;   // list of all function the model cal use
   typedef opengm::DiscreteSpace<IndexType, LabelType>                            SpaceType;          // type used to define the feasible statespace
   typedef opengm::GraphicalModel<ValueType,OpType,FunctionTypeList,SpaceType>    Model;              // type of the model
   typedef Model::FunctionIdentifier                                              FunctionIdentifier; // type of the function identifier

    //**********************
    //**image preprocessing
    //**********************

   char *infilename   = argv[1];//primer argumento despues del nombre del programa sera la imagen
   char *infilenameColorMask  = argv[2];//Segundo argumento despues del nombre del programa sera nombre para mascara de color
   char *outfilenameResultadoMRF  = argv[3];//Tercer argumento despues del nombre del programa sera el nombre del resultado del MRF


    img_src=cv::imread(infilename);
    img_srcGray=cv::imread(infilename,0);
    img_srcBinary=cv::imread(infilenameColorMask);

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
	cv::resize(img_srcGray,img_srcGray,cv::Size(500,500));
	cv::resize(img_srcBinary,img_srcBinary,cv::Size(500,500));



//erode(img_srcBinary,img_srcBinary,element);
/*
   //********************************
   //** Visualizacion de las imagenes
   //****************** *************
    cv::namedWindow("In",0);	   
    cv::namedWindow("Color mask",0); 

    cv::imshow("In",img_src);//show image   
    cv::imshow("Color mask",img_srcBinary);//show image
cv::waitKey(0);*/

 
   //***********************
   //** Estructura para MRF
   //***********************
   IndexType N =img_srcBinary.cols;
   IndexType M = img_srcBinary.rows;  
   int data[N*M];
   int dataEM[N*M];
   int dataYUV[N*M];	
   int countData=0;	

	for(int i=0;i<N;i++)
	{
		for(int j=0;j<M;j++)
		{
		

//PARAMETRO BASADO EN MASCARA DE COLOR


			if(img_srcBinary.at<cv::Vec3b>(i,j)[1]>img_srcBinary.at<cv::Vec3b>(i,j)[0] && img_srcBinary.at<cv::Vec3b>(i,j)[2]>img_srcBinary.at<cv::Vec3b>(i,j)[0])
			{
			img_srcBinary.at<cv::Vec3b>(i,j)[1]=1;
			img_srcBinary.at<cv::Vec3b>(i,j)[2]=0;
			img_srcBinary.at<cv::Vec3b>(i,j)[0]=0;
			}	
			else{
			img_srcBinary.at<cv::Vec3b>(i,j)[1]=0;
			img_srcBinary.at<cv::Vec3b>(i,j)[2]=0;
			img_srcBinary.at<cv::Vec3b>(i,j)[0]=0;

			}
 		
		countData++;	
		}	

	}

    //cv::imshow("Color mask",img_srcBinary);//show image
 //  cv::waitKey(0);

   //***************************
   //** Construccion del modelo
   //***************************

   std::cout << "Start building the model ... "<<std::endl;
   // Build empty Model
   LabelType numLabel = 2;
   std::vector<LabelType> numbersOfLabels(N*M,numLabel);
   Model gm(SpaceType(numbersOfLabels.begin(), numbersOfLabels.end()));


	int variable=0;
	for(int i=0;i<N;i++)
	{
		for(int j=0;j<M;j++)
		{


		const LabelType shape[] = {gm.numberOfLabels(variable)};
        ExplicitFunction f(shape, shape + 1);

   //***************************
   //** Definicion de Data term
   //***************************
		
		f(1) =(img_srcGray.at<uchar>(i,j))*img_srcBinary.at<cv::Vec3b>(i,j)[1];
		f(0) =(250-img_srcGray.at<uchar>(i,j));

		FunctionIdentifier id = gm.addFunction(f);
      // add factor
        IndexType variableIndex[] = {variable};
        gm.addFactor(id, variableIndex, variableIndex + 1);
 		//std::cout <<data[countData];
		variable++;	
		}

	}	


	
    //**********************************
   //** Definicion de Funcion de Smooth
   //***********************************

       //opengm::AbsoluteDifferenceFunction<float> Absolute(numLabel, numLabel,1.5);
	//AbsoluteDifferenceFunction Absolute(numLabel, numLabel,0.5);
      // add a potts function to the model
//opengm::SquaredDifferenceFunction<float> L(numLabel,numLabel, 0.5); 
     // PottsFunction potts(numLabel, numLabel,9,9);
   TruncatedSquaredDifferenceFunction  L(numLabel,numLabel,20,0.2);//(numero label1,numero label2, umbral, peso)
FunctionIdentifier pottsid1 = gm.addFunction(L);

      //FunctionIdentifier pottsid = gm.addFunction(potts);
     // FunctionIdentifier squared = gm.addFunction(f);

      IndexType vars[]  = {0,1}; 
      for(IndexType n=0; n<N;++n){
         for(IndexType m=0; m<M;++m){
            vars[0] = n + m*N;
            if(n+1<N){ //check for right neighbor
               vars[1] =  (n+1) + (m  )*N;
               OPENGM_ASSERT(vars[0] < vars[1]); // variables need to be ordered!
               gm.addFactor(pottsid1, vars, vars + 2);
            } 
            if(m+1<M){ //check for lower neighbor
               vars[1] =  (n  ) + (m+1)*N; 
               OPENGM_ASSERT(vars[0] < vars[1]); // variables need to be ordered!
               gm.addFactor(pottsid1, vars, vars + 2);
            }
         }
      }


   //*****************************************
   //** Inferencia - Loopy belief propagation
   //****************** **********************


   typedef BeliefPropagationUpdateRules<Model, opengm::Minimizer> UpdateRules;
   typedef MessagePassing<Model, opengm::Minimizer, UpdateRules, opengm::MaxDistance> BeliefPropagation;
   const size_t maxNumberOfIterations = 30;
   const double convergenceBound = 1e-7;
   const double damping = 0.0;
   BeliefPropagation::Parameter parameter(maxNumberOfIterations, convergenceBound, damping);
   BeliefPropagation bp(gm, parameter);
   
   // optimize (approximately)
   BeliefPropagation::VerboseVisitorType visitor;
   bp.infer(visitor);

   // obtain the (approximate) argmin
   vector<size_t> labeling(N * M);
   bp.arg(labeling);


   cv::Mat Resultado;
img_srcGray.copyTo(Resultado);
	
   
   // output the (approximate) argmin
   size_t variableIndex = 0;
int i=0;int j=0;
   for(size_t y = 0; y < M; ++y) {

      for(size_t x = 0; x < N; ++x) {



	if(labeling[variableIndex]>0)Resultado.at<uchar>(i,j)=255;
	if((int)(labeling[variableIndex])<1)Resultado.at<uchar>(y,x)=0;



         ++variableIndex;
	
		j++;
      }
		j=0;
		i++;         
   }

/*	cv::namedWindow("out",0);
        cv::imshow("out",Resultado);//show image

	imwrite(outfilenameResultadoMRF,Resultado);

    cv::waitKey(0);
*/

    imwrite(outfilenameResultadoMRF,Resultado);
    std::cout <<"Acabe"<<endl;



	return 0;

}
