cmake_minimum_required(VERSION 3.0)

project(avim)

include(CheckCCompilerFlag)
check_c_compiler_flag(-fvisibility=hidden HAS_VISIVILITY)
if (HAS_VISIVILITY)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden ")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fvisibility=hidden ")
endif()

include(CheckCXXCompilerFlag)
check_cxx_compiler_flag(-std=c++11 HAS_CXX11)
if (HAS_CXX11)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 ")
endif()

if(WIN32)
	add_definitions(-DBOOST_ALL_STATIC_LINK)
	add_definitions(-DBOOST_THREAD_USE_LIB)
	add_definitions(-DBOOST_FILESYSTEM_STATIC_LINK)
	add_definitions(-DBOOST_ALL_STATIC_LINK)
	add_definitions(-DWIN32_LEAN_AND_MEAN)
	add_definitions(-DNOMINMAX)
	add_definitions(-D_CRT_SECURE_NO_WARNINGS)
	add_definitions(-D_WIN32_WINNT=0x0501)
endif()

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

if(MSVC)
	add_definitions(-DNOMINMAX)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd4819")
	set(Boost_USE_MULTITHREADED TRUE)
	set(Boost_USE_STATIC_LIBS TRUE)

	if(NOT PROTOBUF_SRC_ROOT_FOLDER AND NOT PROTOBUF_LIBRARY)
		if(DEFINED ENV{PROTOBUF_SRC_ROOT_FOLDER})
			set(PROTOBUF_SRC_ROOT_FOLDER $ENV{PROTOBUF_SRC_ROOT_FOLDER})
		else()
			set(PROTOBUF_SRC_ROOT_FOLDER ${CMAKE_CURRENT_SOURCE_DIR}/third_party/protobuf-2.6.1/)

			if( NOT EXISTS ${PROTOBUF_SRC_ROOT_FOLDER}/Debug)
				message(FATAL_ERROR "please compile protobuf in VC -- open and press F7")
			endif()
		endif()
	endif()
endif()

option(RUN_PROTOC "run protoc to generate protobuf protocol parser" ON)
option(ENABLE_QT_STATIC "static link to qt" ON)
option(USE_BOOST_THREAD "prefer boost::thread instead of std::thread" OFF)

set(BUILD_STATIC ${ENABLE_QT_STATIC})

include(tweakvcflasgs.cmake)

if (USE_BOOST_THREAD)
	add_definitions(-DUSE_BOOST_THREAD)
endif()

find_package(Threads REQUIRED)
find_package(Boost 1.54 REQUIRED COMPONENTS thread system program_options coroutine context regex date_time chrono filesystem )
find_package(Protobuf REQUIRED)

if(WIN32)
add_subdirectory(third_party/openssl)
else()
find_package(OpenSSL REQUIRED)
endif()
#find_package(PkgConfig REQUIRED)

#pkg_check_modules(PKCS11 REQUIRED libpkcs11-helper-1 )

include_directories(
	${Boost_INCLUDE_DIRS}
	${OPENSSL_INCLUDE_DIR}
)

link_directories(${Boost_LIBRARY_DIR})
if(MSVC)
	set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /LIBPATH:${Boost_LIBRARY_DIR}")
endif()
link_libraries(${OPENSSL_LIBRARIES} ${PKCS11_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT})

if(NOT MSVC)
link_libraries(${Boost_LIBRARIES})
endif()

check_library_exists(rt clock_gettime "" HAVE_CLOCK_GETTIME)
if(HAVE_CLOCK_GETTIME)
        link_libraries(-lrt)
endif(HAVE_CLOCK_GETTIME)

if(EXISTS ${PROJECT_SOURCE_DIR}/libavim/CMakeLists.txt )
	add_subdirectory(libavim)
	link_libraries(avim++)
else()
	message( FATAL_ERROR "please run 'git submodule update --init' to get libavim")
endif()

if(MSVC)
	set(CMAKE_EXE_LINKER_FLAGS ${CMAKE_EXE_LINKER_FLAGS} "/MANIFESTINPUT:${CMAKE_CURRENT_SOURCE_DIR}/dpi.manifest")
endif()

add_subdirectory(src)
