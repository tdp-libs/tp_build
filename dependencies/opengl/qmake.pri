QT += opengl

android{
#In Projects->Build->Build Environment
#Set ANDROID_NDK_PLATFORM to android-24 or what ever you need.
LIBS += -lEGL
LIBS += -lGLESv3
}

else:iphoneos{
DEFINES += GL_SILENCE_DEPRECATION
DEFINES += GLES_SILENCE_DEPRECATION
}

else:win32{
LIBS += -lglu32
LIBS += -lglew32
LIBS += -lopengl32
}
