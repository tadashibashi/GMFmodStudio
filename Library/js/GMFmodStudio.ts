declare var fmodFiles: Array<string>;
declare var gameRootDir: string;
declare namespace GMS_API {
    export function send_async_event_social(obj: any): void;
}
declare var fmod: FMOD;

let out: Out<any> = {val: 0};
let check: FMOD.RESULT = 0;
    
let gStudio: FMOD.StudioSystem = null;

function handleVisibilityChange()
{
    if (gStudio && gStudio.isValid())
    {
        gStudio.getCoreSystem(out);
        var core: FMOD.System = out.val;
        if (document.visibilityState === 'visible')
        {
            core.mixerResume();
        }
        else
        {
            core.mixerSuspend();
        }
    }
}
document.addEventListener("visibilitychange", handleVisibilityChange);

function GMFMOD_CHECK(result: FMOD.RESULT): void
{
    if (result != FMOD.RESULT.OK)
    {
        console.error('FMOD Error: ' + fmod.ErrorString(result));
    }
}

// iOS workaround callback
function resumeAudio() 
{
    if (gStudio && gStudio.isValid())
    {
        gStudio.getCoreSystem(out);
        var gSystem: FMOD.System = out.val;
        check = gSystem.mixerSuspend();
        GMFMOD_CHECK(check);
        check = gSystem.mixerResume();
        GMFMOD_CHECK(check);
        
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


// Called on extension connection for cross-platform portability
function RegisterCallbacks(arg1, arg2, arg3, arg4): void
{

}

function gmfms_get_error()
{
    return check;
}

function gmfms_get_error_string()
{
    return fmod.ErrorString(check);
}
