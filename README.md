# GMFmodStudio
FMOD Studio 2.1 Integration for GameMaker: Studio 2.3

## In Development
- Close implementation of FMOD Studio API
- GameMaker: Studio 2.3 struct helper objects for ease of use
### Future
FMOD Core API may be supported

## Platforms
### Supported
- Windows
### Future
- Ubuntu
- Mac
- HTML5

## Build (Currently Windows Only)
1. Build Extension DLL in Visual Studio 2019
  * Download FMOD Studio API for Windows
  * Copy the contents of the api/core/lib (both x86 and x64 folders) into GMFmodStudio/Library/fmod/lib
  * Copy the contents of the api/studio/lib (both x86 and x64 folders) into GMFmodStudio/Library/fmod/lib
  * Build Visual Studio project for both Win32 and x64 platforms.
  * Check that the dll files have successfully built in the directory GMFmodStudio/GameMakerStudio2/extensions/GMFmodStudio/
2. (Optional) Build FMOD Studio test banks (Studio version 2.01.04)
  * In FMOD Studio, click F7 or Menu: File->Build
  * Check that the banks have built in GMFmodStudio/GameMakerStudio2/datafiles/
  * If you decide to not use the test banks, you may also want to delete the objects in the GMFMS_Tests group folder in the GameMaker Studio 2 IDE.
3. At this point the GameMaker Studio 2 project and GMFmodStudio extension should be ready to go.
