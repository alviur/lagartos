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
//** OpenGM
#include <opengm/opengm.hxx>
#include <opengm/graphicalmodel/graphicalmodel.hxx>
#include <opengm/operations/adder.hxx>
#include <opengm/functions/squared_difference.hxx>
#include <opengm/inference/messagepassing/messagepassing.hxx>
#include <opengm/inference/gibbs.hxx>
#include <opengm/inference/dualdecomposition/dualdecomposition_subgradient.hxx>
#include <opengm/inference/dualdecomposition/dualdecomposition_bundle.hxx>
#include <opengm/operations/minimizer.hxx>




using namespace cv;
using namespace std;
using namespace opengm;

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
   typedef double                                                                 ValueType;// type used for values
   typedef size_t                                                                 IndexType;// type used for indexing nodes and factors (default : size_t)
   typedef size_t                                                                 LabelType;// type used for labels (default : size_t)
   typedef opengm::Adder                                                          OpType; // operation used to combine terms
   typedef opengm::ExplicitFunction<ValueType,IndexType,LabelType>                ExplicitFunction;// shortcut for explicite function 
   typedef opengm::SquaredDifferenceFunction<LabelType,LabelType,ValueType>       SquaredDifferenceFunction;      // shortcut for Potts function
  
   typedef opengm::meta::TypeListGenerator<ExplicitFunction,SquaredDifferenceFunctionn>::type  FunctionTypeList;   // list of all function the model cal use (this trick avoids virtual methods) - here only one

   typedef opengm::DiscreteSpace<IndexType, LabelType>                            SpaceType;// type used to define the feasible statespace
   typedef opengm::GraphicalModel<ValueType,OpType,FunctionTypeList,SpaceType>    Model;// type of the model
   typedef Model::FunctionIdentifier                                              FunctionIdentifier;// type of the function identifier



///------ dual decomposition definitions
	typedef opengm::Minimizer AccType;
	//typedef opengm::GraphicalModel<>
	typedef opengm::DDDualVariableBlock<marray::Marray<ValueType> > DualBlockType;
	typedef opengm::DualDecompositionBase<Model , DualBlockType>::SubGmType SubGmType;
	typedef opengm::BeliefPropagationUpdateRules<SubGmType,AccType> UpdateRuleType;
	typedef opengm::MessagePassing<SubGmType,AccType,UpdateRuleType,opengm::MaxDistance> InfType;
	//typedef opengm::DualDecompositionBundle<Model,InfType,DualBlockType> DualDecompositionBundle;
	typedef opengm::DualDecompositionSubGradient<Model,InfType,DualBlockType> DualDecompositionSubGradient;
///------ end dual decomposition definitions

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

    cv::namedWindow("In",0);	   
    cv::namedWindow("Color mask",0); 

    cv::imshow("In",img_src);//show image   
    cv::imshow("Color mask",img_src_posterizada);//show image
cv::waitKey(0);

	cv::resize(img_src,img_src,cv::Size(500,500));
	cv::resize(Resultado,Resultado,cv::Size(500,500));
	cv::resize(img_srcGray,img_srcGray,cv::Size(500,500));
	cv::resize(img_src_posterizada,img_src_posterizada,cv::Size(500,500));



   //********************************
   //** Visualizacion de las imagenes
   //****************** *************


 
   //***********************
   //** Estructura para MRF
   //***********************
   IndexType N =img_src.cols;
   IndexType M = img_src.rows;  
   int countData=0;	


    //cv::imshow("Color_mask",img_srcBinary);//show image
   // imwrite("Color_mask.jpg",img_srcBinary); 	
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

   //** Basado en intensidad
		if(funcion==0)
		{
			f(1) =(img_srcGray.at<uchar>(i,j));
			f(0) =(250-img_srcGray.at<uchar>(i,j));
		
		}

   //** Basado en Posterizacion
		if(funcion==1)
		{
			f(1) =(img_srcGray.at<uchar>(i,j)+ img_src_posterizada.at<uchar>(i,j));
			f(0) =(250-img_srcGray.at<uchar>(i,j));
		}

   //** Basado en color
		if(funcion==2)
		{
			f(1) =(img_srcGray.at<uchar>(i,j)+img_src.at<cv::Vec3b>(i,j)[1]+img_src.at<cv::Vec3b>(i,j)[2]);
			f(0) =(250-img_srcGray.at<uchar>(i,j)+255+img_src.at<cv::Vec3b>(i,j)[0]);
		}

   //** Basado en color

		FunctionIdentifier id = gm.addFunction(f);
      // add factor
        IndexType variableIndex[] = {variable};
        gm.addFactor(id, variableIndex, variableIndex + 1);
 		//std::cout <<data[countData];
		variable++;	
		}

	}	


	
    //*********************************************
   //** Definicion de Funcion de Smooth
   //**********************************************

   

	//AbsoluteDifferenceFunction Absolute(numLabel, numLabel,0.5);
      // add a potts function to the model
     
	SquaredDifferenceFunction square(numLabel,numLabel,peso);
      FunctionIdentifier pottsid = gm.addFunction(square);

      IndexType vars[]  = {0,1}; 
      for(IndexType n=0; n<N;++n){
         for(IndexType m=0; m<M;++m){
            vars[0] = n + m*N;
            if(n+1<N){ //check for right neighbor
               vars[1] =  (n+1) + (m  )*N;
               OPENGM_ASSERT(vars[0] < vars[1]); // variables need to be ordered!
               gm.addFactor(pottsid, vars, vars + 2);
            } 
            if(m+1<M){ //check for lower neighbor
               vars[1] =  (n  ) + (m+1)*N; 
               OPENGM_ASSERT(vars[0] < vars[1]); // variables need to be ordered!
               gm.addFactor(pottsid, vars, vars + 2);
            }
         }
      }

	


   //*****************************************
   //** Inferencia 
   //****************** **********************

   size_t variableIndex = 0;
	//**- 1.Loopy belief propagation



	if(inferencia==0)
{

   typedef BeliefPropagationUpdateRules<Model, opengm::Minimizer> UpdateRules;
   typedef MessagePassing<Model, opengm::Minimizer, UpdateRules, opengm::MaxDistance> BeliefPropagation;
   const size_t maxNumberOfIterations = iteraciones;
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



   
   // output the (approximate) argmin

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


}

//**- 2.Dual Descomposition


    DualDecompositionSubGradient ddsg(gm);
	ddsg.infer();
	// obtain the (approximate) argmin
	vector<size_t> labeling(N * M);
	ddsg.arg(labeling);

   
   // output the (approximate) argmin

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
//**- 3.Graph Cuts





/*	cv::namedWindow("out",0);
        cv::imshow("out",Resultado);//show image

	imwrite(outfilenameResultadoMRF,Resultado);

    cv::waitKey(0);
*/

    imwrite(outfilenameResultadoMRF,Resultado);
    std::cout <<"Acabe"<<endl;



	return 0;

}
