cmake_minimum_required(VERSION 3.14)
project(GMFmodStudio)

add_library(GMFmodStudio SHARED
	GMFmodStudio/gmfs_api.cpp
	GMFmodStudio/gmfs_common.cpp
	GMFmodStudio/gmfs_sound.cpp
	GMFmodStudio/gmfs_studio_bank.cpp
	GMFmodStudio/gmfs_studio_bus.cpp
	GMFmodStudio/gmfs_studio_command_replay.cpp
	GMFmodStudio/gmfs_studio_event_description.cpp
	GMFmodStudio/gmfs_studio_event_instance.cpp
	GMFmodStudio/gmfs_studio_system.cpp
	GMFmodStudio/gmfs_studio_vca.cpp
	GMFmodStudio/gmfs_system.cpp
)

target_include_directories(GMFmodStudio PUBLIC
	fmod/include
)
target_link_directories(GMFmodStudio PUBLIC 
	fmod/lib	
)

target_link_libraries(GMFmodStudio PUBLIC 
	fmod fmodstudio)

set_property(TARGET GMFmodStudio PROPERTY CXX_STANDARD 11)

add_custom_command(TARGET GMFmodStudio POST_BUILD 
  COMMAND "${CMAKE_COMMAND}" -E copy 
     "$<TARGET_FILE:GMFmodStudio>"
     "../../GameMakerStudio2/extensions/GMFmodStudio/$<TARGET_FILE_NAME:GMFmodStudio>" 
  COMMENT "Copying to output directory")
