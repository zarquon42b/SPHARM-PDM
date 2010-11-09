NeuroLib_USE_VTK()
NeuroLib_USE_ITK()
NeuroLib_USE_SHAPE()


# Shorthand to source and binary directories
SET(MY_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
SET(MY_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR})

# Include directories
INCLUDE_DIRECTORIES( ${MY_SOURCE_DIR} ${MY_BINARY_DIR})

LINK_DIRECTORIES( ${CMAKE_BINARY_SOURCE_DIR})
LINK_LIBRARIES( 
  vtkRendering
  vtkGraphics
  vtkImaging
  vtkIO
  vtkCommon
  vtkHybrid
  vtkFiltering 
)

SET(SRC_STL2META_CXX STL2Meta.cxx vtkPolyDataToitkMesh.cxx)
ADD_EXECUTABLE(STL2Meta ${SRC_STL2META_CXX})
TARGET_LINK_LIBRARIES(STL2Meta ${ITK_LIBRARIES})

SET(SRC_STL2VTK_CXX STL2VTK.cxx)
ADD_EXECUTABLE(STL2VTK ${SRC_STL2VTK_CXX})
TARGET_LINK_LIBRARIES(STL2VTK ${ITK_LIBRARIES})

SET(SRC_ROIMESH_CXX ROIMesh.cxx itkMeshTovtkPolyData.cxx vtkPolyDataToitkMesh.cxx)
ADD_EXECUTABLE(ROIMesh ${SRC_ROIMESH_CXX})
TARGET_LINK_LIBRARIES(ROIMesh ${ITK_LIBRARIES})

#SET(SRC_ALIGNMESHVOL_CXX alignMeshVol.cxx itkMeshTovtkPolyData.cxx vtkPolyDataToitkMesh.cxx)
#ADD_EXECUTABLE(alignMeshVol ${SRC_ALIGNMESHVOL_CXX})
#TARGET_LINK_LIBRARIES(alignMeshVol ${ITK_LIBRARIES})

SET(SRC_META2STL_CXX Meta2STL.cxx itkMeshTovtkPolyData.cxx)
ADD_EXECUTABLE(Meta2STL ${SRC_META2STL_CXX})
TARGET_LINK_LIBRARIES(Meta2STL ${ITK_LIBRARIES})

SET(SRC_MESHMATH_CXX MeshMath.cxx itkMeshTovtkPolyData.cxx vtkPolyDataToitkMesh.cxx)
ADD_EXECUTABLE(MeshMath ${SRC_MESHMATH_CXX})
TARGET_LINK_LIBRARIES(MeshMath ${ITK_LIBRARIES})

#SET(SRC_MESHASYMMETRY_CXX MeshAsymmetry.cxx itkMeshTovtkPolyData.cxx vtkPolyDataToitkMesh.cxx)
#ADD_EXECUTABLE(MeshAsymmetry ${SRC_MESHASYMMETRY_CXX})
#TARGET_LINK_LIBRARIES(MeshAsymmetry ${ITK_LIBRARIES})

ADD_EXECUTABLE( MetaToIV  MetaToIV.cxx)
TARGET_LINK_LIBRARIES(MetaToIV ${ITK_LIBRARIES})

ADD_EXECUTABLE( IVToMeta  IVToMeta.cxx)
TARGET_LINK_LIBRARIES(IVToMeta ${ITK_LIBRARIES})

ADD_EXECUTABLE(MetaMeshJoiner MetaMeshJoiner.cxx )
TARGET_LINK_LIBRARIES(MetaMeshJoiner ${ITK_LIBRARIES})

ADD_EXECUTABLE(Meta2VTK Meta2VTK.cxx itkMeshTovtkPolyData.cxx)
TARGET_LINK_LIBRARIES(Meta2VTK ${ITK_LIBRARIES})

ADD_EXECUTABLE(VTK2Meta VTK2Meta.cxx vtkPolyDataToitkMesh.cxx)
TARGET_LINK_LIBRARIES(VTK2Meta ${ITK_LIBRARIES} )

ADD_EXECUTABLE(MetaStats MetaStats.cxx itkMeshToVTKPolyDataFilter.cxx)
TARGET_LINK_LIBRARIES(MetaStats ${ITK_LIBRARIES} )

ADD_EXECUTABLE(MeshStat MeshStat.cxx itkMeshToVTKPolyDataFilter.cxx)
TARGET_LINK_LIBRARIES(MeshStat ${ITK_LIBRARIES} )

ADD_EXECUTABLE(asc2vtk asc2vtk.cxx)
ADD_EXECUTABLE(asc2meta asc2meta.cxx)
ADD_EXECUTABLE(BYU2VTK BYU2VTK.cxx)
