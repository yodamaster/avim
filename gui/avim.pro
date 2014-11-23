# ----------------------------------------------------
# This file is generated by the Qt Visual Studio Add-in.
# ------------------------------------------------------

TEMPLATE = app
TARGET = gavim
DESTDIR = ../Win32/Debug
QT += core widgets gui
CONFIG += debug
DEFINES += WIN64 QT_DLL QT_WIDGETS_LIB
INCLUDEPATH += ./GeneratedFiles \
    . \
    ./GeneratedFiles/Debug \
    $(SolutionDir)3rd_party/openssl_vs2013_32/inc32 \
    $(SolutionDir)protocol \
    $(SolutionDir)3rd_party/libavproto/include \
    $(SolutionDir)3rd_party/protobuf-2.6.1/src \
    /usr/local/include
LIBS += -L"$(SolutionDir)3rd_party" \
    -L"$(SolutionDir)3rd_party/openssl_vs2013_32/out32" \
    -llibeay32 \
    -lssleay32 \
    -llibavproto \
    -llibprotobuf
DEPENDPATH += .
MOC_DIR += ./GeneratedFiles/debug
OBJECTS_DIR += debug
UI_DIR += ./GeneratedFiles
RCC_DIR += ./GeneratedFiles
include(gavim.pri)

# Icon on Mac OS X
ICON = gavim.icns