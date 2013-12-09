project(spharmpdm)

if( EXTENSION_SUPERBUILD_BINARY_DIR )
  if(APPLE) # On mac, Ext/cli_modules/DTIAtlasBuilder so Ext/ExternalBin is ../ExternalBin
    set(RELATIVE_EXTENSION_PATH ..)
  else() # On Windows : idem Linux : Ext/lib/Slicer4.2/cli_modules/DTIAtlasBuilder so Ext/ExternalBin is ../../../ExternalBin
    set(RELATIVE_EXTENSION_PATH ../../..)
  endif()
  set(NOCLI_INSTALL_DIR ${${LOCAL_PROJECT_NAME}_CLI_INSTALL_RUNTIME_DESTINATION}/${RELATIVE_EXTENSION_PATH})
  #-----------------------------------------------------------------------------
  # Program definitions for C++ interfacing
  #-----------------------------------------------------------------------------
  ADD_DEFINITIONS(-DSLICER_EXTENSION_PATH=${RELATIVE_EXTENSION_PATH})
endif()

include(${CMAKE_CURRENT_SOURCE_DIR}/Common.cmake)
#-----------------------------------------------------------------------------
set(expected_ITK_VERSION_MAJOR ${ITK_VERSION_MAJOR})
find_package(ITK NO_MODULE REQUIRED)
if(${ITK_VERSION_MAJOR} VERSION_LESS ${expected_ITK_VERSION_MAJOR})
  # Note: Since ITKv3 doesn't include a ITKConfigVersion.cmake file, let's check the version
  #       explicitly instead of passing the version as an argument to find_package() command.
  message(FATAL_ERROR "Could not find a configuration file for package \"ITK\" that is compatible "
                      "with requested version \"${expected_ITK_VERSION_MAJOR}\".\n"
                      "The following configuration files were considered but not accepted:\n"
                      "  ${ITK_CONFIG}, version: ${ITK_VERSION_MAJOR}.${ITK_VERSION_MINOR}.${ITK_VERSION_PATCH}\n")
endif()
include(${ITK_USE_FILE})

#-----------------------------------------------------------------------------
find_package(VTK REQUIRED)
include(${USE_VTK_FILE})

#-----------------------------------------------------------------------------
find_package(SlicerExecutionModel REQUIRED GenerateCLP)
include(${GenerateCLP_USE_FILE})
include(${SlicerExecutionModel_USE_FILE})
include(${SlicerExecutionModel_CMAKE_DIR}/SEMMacroBuildCLI.cmake)

#-----------------------------------------------------------------------------
find_package(BatchMake REQUIRED)
include(${BatchMake_USE_FILE})

#-----------------------------------------------------------------------------

set(CLAPACK_LIBRARY_DIRECTORIES
  ${CLAPACK_DIR}/F2CLIBS/libf2c)
if(WIN32)
  set(CLAPACK_LIBRARIES lapack blas libf2c)
else()
  set(CLAPACK_LIBRARIES lapack blas f2c)
endif()

link_directories( ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY} ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} )
link_directories(${CLAPACK_LIBRARY_DIRECTORIES})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/Libraries/Shape/IO)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/Libraries/Shape/SpatialObject)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/Libraries/Shape/Algorithms)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/Libraries/Shape/Numerics)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/Libraries/Shape/Statistics)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/Libraries/SparseLibMVIml)
include_directories(${Boost_DIR}/include)
include_directories(${Boost_DIR}/include)

link_directories(${Boost_DIR}/lib)
add_subdirectory(Libraries)
add_subdirectory(Applications)

FILE( GLOB list_files ${CMAKE_CURRENT_SOURCE_DIR}/bmm/*.* )
FILE( COPY ${list_files} DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY} )

if( EXTENSION_SUPERBUILD_BINARY_DIR )
  unsetForSlicer(NAMES CMAKE_C_COMPILER CMAKE_CXX_COMPILER ITK_DIR SlicerExecutionModel_DIR VTK_DIR CMAKE_CXX_FLAGS CMAKE_C_FLAGS ITK_LIBRARIES )
  find_package(Slicer REQUIRED)
  include(${Slicer_USE_FILE})
 #unsetAllForSlicerBut( NAMES VTK_DIR Slicer_HOME )
  resetForSlicer(NAMES CMAKE_C_COMPILER CMAKE_CXX_COMPILER CMAKE_CXX_FLAGS CMAKE_C_FLAGS  ITK_DIR SlicerExecutionModel_DIR ITK_LIBRARIES )
endif()

#-----------------------------------------------------------------------------
# Testing
#-----------------------------------------------------------------------------
option(BUILD_TESTING "Build testing" OFF)
IF(BUILD_TESTING)
  include(CTest)
  ADD_SUBDIRECTORY(Testing)
ENDIF(BUILD_TESTING)

macro(INSTALL_EXECUTABLE)
  set(options )
  set( oneValueArgs OUTPUT_DIR )
  set(multiValueArgs LIST_EXEC )
  CMAKE_PARSE_ARGUMENTS(LOCAL
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
    )
  foreach( tool ${LOCAL_LIST_EXEC})
    install(PROGRAMS ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${tool} DESTINATION ${LOCAL_OUTPUT_DIR} )
  endforeach()
endmacro()


if( EXTENSION_SUPERBUILD_BINARY_DIR )
  set( CLIToolsList
    GenParaMeshCLP SegPostProcessCLP ParaToSPHARMMeshCLP ShapeAnalysisModule
     )
  set( NotCLIToolsList
    MeshMath RadiusToMesh STL2Meta Meta2STL Meta2VTK VTK2Meta asc2vtk asc2meta BYU2VTK
     )
  INSTALL_EXECUTABLE( OUTPUT_DIR ${${LOCAL_PROJECT_NAME}_CLI_INSTALL_RUNTIME_DESTINATION} LIST_EXEC ${CLIToolsList} )
  INSTALL_EXECUTABLE( OUTPUT_DIR ${NOCLI_INSTALL_DIR}/ExternalBin LIST_EXEC ${NotCLIToolsList} )
  install( DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/bmm DESTINATION ${NOCLI_INSTALL_DIR} )
  set(CPACK_INSTALL_CMAKE_PROJECTS "${CPACK_INSTALL_CMAKE_PROJECTS};${CMAKE_BINARY_DIR};${EXTENSION_NAME};ALL;/")
  include(${Slicer_EXTENSION_CPACK})
endif()

