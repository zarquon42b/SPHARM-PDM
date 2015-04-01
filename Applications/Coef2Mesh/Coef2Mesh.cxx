#include <iostream>
#include <fstream>
#include <vector>
#include <itkPoint.h>
#include "argio.hh"
#include "SphericalHarmonicPolynomial.h"

#include "itkMeshSpatialObject.h"
#include "itkSpatialObjectWriter.h"
#include "itkSpatialObjectReader.h"
#include "itkMesh.h"

#include "SphericalHarmonicSpatialObject.h"
#include "SphericalHarmonicCoefficientFileReader.h"
#include "SphericalHarmonicMeshSource.h"
#include "itkMeshTovtkPolyData.h"
#include "vtkPolyDataWriter.h"
#include <vtkVersion.h>
using namespace std ;
using namespace neurolib ;


static int degree, level ;
static bool firstDer, secondDer, unit, normal, first, second, kappa, c, s, princDirs, princCurve, h, k, gradKappa, caustic ;
static bool parFile ;
static bool phiThetaFile ;
static char* baseName ;

// takes in a spharm coefficient file, and generates the evaluations of the first and second derivatives
int main(int argc, const char **argv)
{
  // get the arguments
  char *coefFileName;
  
  coefFileName = ipGetStringArgument(argv, "-coef", NULL);  
  baseName = ipGetStringArgument(argv, "-output", NULL);  
  firstDer = ipExistsArgument (argv, "-d");
  secondDer = ipExistsArgument (argv, "-dd");
  degree = ipGetIntArgument (argv, "-deg", 12) ;
  level = ipGetIntArgument (argv, "-level", -1) ;
  unit = ipExistsArgument ( argv, "-unit") ;
  normal = ipExistsArgument (argv, "-norm") ;
  first = ipExistsArgument (argv, "-I") ;
  second = ipExistsArgument (argv, "-II") ;
  kappa = ipExistsArgument (argv, "-kappa") ;
  gradKappa = ipExistsArgument (argv, "-gradKappa") ;
  caustic = ipExistsArgument (argv, "-caustic") ;
  c = ipExistsArgument (argv, "-c") ;
  s = ipExistsArgument (argv, "-s") ;
  h = ipExistsArgument (argv, "-h") ;
  k = ipExistsArgument (argv, "-k") ;

  princDirs = ipExistsArgument (argv, "-princ") ;
  princCurve = ipExistsArgument (argv, "-prinCurve") ;  
  parFile = ipExistsArgument (argv, "-parFile") ;
  phiThetaFile = ipExistsArgument (argv, "-phiTheta") ;
  // make sure the arguments are valid
  if ( !coefFileName || !baseName || ipExistsArgument(argv, "-help") )
  {
    cout << "Usage:" << endl ;
    cout << "SPHARMTool -coef CoefficientFileName -output OutputFileBaseName [-level subdivisionLevel] [-deg spharmDegree] [-d] [-dd] [-normal] [-unit] [-I] [-II] [-kappa] [-c] [-s] [-h] [-k] [-princ] [-prinCurve] [-parFile] [-phiThetaFile]" << endl ;
    return 0 ;
  }
  
  // read the coefficients in
  SphericalHarmonicSpatialObject::CoefListType coeflist;
  SphericalHarmonicCoefficientFileReader::Pointer reader = SphericalHarmonicCoefficientFileReader::New();
  reader->SetFileName(coefFileName);
  reader->Update();
  reader->GetOutput(coeflist);
  // Create an itkMesh
  SphericalHarmonicMeshSource::Pointer meshsrc = SphericalHarmonicMeshSource::New();
  meshsrc->SetCoefs(coeflist);
  meshsrc->SetDegree(degree);
  if ( level > 0 )
  {
    meshsrc->SetLevel (level) ;
  }
  meshsrc->Update();
  typedef SphericalHarmonicMeshSource::OutputMeshType MeshType;
  MeshType* mesh;
  mesh = meshsrc->GetOutput();
  vtkPolyDataWriter *writer1;
  writer1 = vtkPolyDataWriter::New();
  itkMeshTovtkPolyData * ITKVTKConverter = new itkMeshTovtkPolyData;
  ITKVTKConverter->SetInput( mesh);
  vtkPolyData *SurfMesh;
  SurfMesh = ITKVTKConverter->GetOutput();
  char meshName1[350] ;
  sprintf (meshName1, "%s.vtk", baseName) ;
  // Writing the file
#if VTK_MAJOR_VERSION > 5
  writer1->SetInputData(SurfMesh);
#else
  writer1->SetInput(SurfMesh);
#endif
  writer1->SetFileName(meshName1 );
  
  writer1->Write();
  return 0 ;
}



