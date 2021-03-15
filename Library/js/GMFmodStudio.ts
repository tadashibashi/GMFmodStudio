declare var fmodFiles: Array<string>;
declare var gameRootDir: string;
declare namespace GMS_API {
    export function send_async_event_social(obj: any): void;
}


let out: Out<any> = {val: 0};
let check: FMOD.RESULT = 0;
var fmodInitialized = false;

const fmod: FMOD = {};

fmod['preRun'] = preRun;
fmod['onRuntimeInitialized'] = main;
FMODModule(fmod);

var fmodFiles = fmodFiles || [];
var gameRootDir = gameRootDir || "html5game";
    
let gStudio: FMOD.StudioSystem = null;

function GMFMOD_IntegrationInitialized(): boolean
{
    return fmodInitialized;
}

function preRun()
{
    if (fmodFiles != undefined)
    {
        var map = new Set<string>();
        map.add("/");

        fmodFiles.forEach(path => {
            let toks = path.split("/");
            toks.unshift(gameRootDir);

            let parentFolder = "";
            for (let i = 0; i < toks.length; ++i)
            {
                let tok = toks[i];
                if (i < toks.length - 1) // make folder
                {
                    let newfolder = parentFolder + "/" + tok;
                    if (!map.has(newfolder))
                    {
                        fmod.FS_createFolder(parentFolder + "/", tok, true, true);
                        map.add(newfolder);
                    }

                    parentFolder = newfolder;
                }
                else                     // create file
                {
                    fmod.FS_createPreloadedFile(parentFolder + "/", tok, 
                        gameRootDir + "/" + path, true, false);
                }
            }
        });
    }
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
    fmodInitialized = true;
    console.log("fmod main function");
}


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
    if (gStudio)
    {
        gStudio.getCoreSystem(out);
        var gSystem: FMOD.System = out.val;
        console.log("Resetting audio driver based on user input.");
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
    GMFMOD_CHECK(check);
}

function gmfms_get_error()
{
    return check;
}

function gmfms_get_error_string()
{
    return fmod.ErrorString(check);
}
