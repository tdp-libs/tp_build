QT += opengl

android{
LIBS += -lEGL
LIBS += -lGLESv3
}

else:iphoneos{
DEFINES += GL_SILENCE_DEPRECATION
}
