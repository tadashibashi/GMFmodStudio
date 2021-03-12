const fmod: FMOD = {};
fmod['preRun'] = preRun;
fmod['onRuntimeInitialized'] = main;
FMODModule(fmod);
let out: Out<any> = {val: 0};
let check: FMOD.RESULT = 0;

let gStudio: FMOD.StudioSystem = null;

declare var fmodFiles: Array<string>;

function preRun()
{
    var map = new Set<string>();
    fmodFiles.forEach(path => {
        var lastslash = path.lastIndexOf("/");
        if (lastslash !== -1)
        {
            var folder = path.substr(0, lastslash + 1);
            var filename = path.substr(lastslash + 1);
            console.log("folder:   " + folder);
            console.log("filename: " + filename);
            if (!map.has(folder))
            {
                fmod.FS_createFolder("/", folder, true, true);
                map.add(folder);
            }

            fmod.FS_createPreloadedFile(folder, filename, path, true, false);
        }
        else
        {
            fmod.FS_createPreloadedFile("/", path, path, true, false);
        }
    });
    //fmod.FS_createPreloadedFile("/", "Master.bank", "html5game/soundbanks/Mobile/Master.bank", true, false);
    //fmod.FS_createPreloadedFile("/", "Master.strings.bank", "html5game/soundbanks/Mobile/Master.strings.bank", true, false);
}

function handleVisibilityChange()
{
    if (!gStudio) return;

    gStudio.getCoreSystem(out);
    var core: FMOD.System = out.val;
    console.log(document.visibilityState);
    if (document.visibilityState === 'visible')
    {
        core.mixerResume();
        
        
    }
    else
    {
        core.mixerSuspend();
    }
}
document.addEventListener("visibilitychange", handleVisibilityChange);

function main()
{
    console.log("fmod main function");
}


function CHECK_RESULT(result: FMOD.RESULT): void
{
    if (result != FMOD.RESULT.OK)
    {
        console.error('FMOD Error: ' + fmod.ErrorString(result));
    }
}

// iOS workaround callback
function resumeAudio() 
{
    if (gStudio)
    {
        gStudio.getCoreSystem(out);
        var gSystem = out.val;
        console.log("Resetting audio driver based on user input.");
        check = gSystem.mixerSuspend();
        CHECK_RESULT(check);
        check = gSystem.mixerResume();
        CHECK_RESULT(check);
        
        // Remove event listener
        if (iOS)
        {
            window.removeEventListener('touchend', resumeAudio, false);
        }
        else
        {
            document.removeEventListener('click', resumeAudio);
        }
    }
}

// Set the ios/chrome workaround callback
var iOS = /iPad|iPhone|iPod/.test(navigator.userAgent) && !window.MSStream;
if (iOS)
{
    window.addEventListener('touchend', resumeAudio, false);
}
else
{
    document.addEventListener('click', resumeAudio);
}

// Called on extension connection
function RegisterCallbacks(arg1, arg2, arg3, arg4): void
{

}

function GMFMOD_ShutdownIntegration(): void
{
    console.log("GMfmod_ShutdownIntegration not implemented");
}

function emfs_create_preloaded_file(
    foldername:string, filename:string, actualpath:string, 
    canread:boolean, canwrite:boolean)
{
    check = fmod.FS_createPreloadedFile(foldername, filename, actualpath, canread, canwrite);
    CHECK_RESULT(check);
}