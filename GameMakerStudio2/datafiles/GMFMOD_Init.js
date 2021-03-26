var fmod = {};

fmod['preRun'] = preRun;
fmod['onRuntimeInitialized'] = main;

//var fmodFiles = fmodFiles || [];
//var gameFolder = gameFolder || "html5game";

var fmodFiles = [
	"soundbanks/Desktop/Master_ENG.bank",
	"soundbanks/Desktop/Master_ENG.strings.bank",
	"Fury.dls",
	"disney.mid"
	];

var gameFolder = "game";

function main()
{
		GameMaker_Init();
}

function preRun()
{
    if (fmodFiles != undefined)
    {
        var map = new Set();
        map.add("/");

        fmodFiles.forEach(path => {
            let toks = path.split("/");
            toks.unshift(gameFolder);

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
                        gameFolder + "/" + path, true, false);
                }
            }
        });
    }
}


var gStudio = null;

function handleVisibilityChange()
{
    if (gStudio && gStudio.isValid())
    {
        var outval = {};
        gStudio.getCoreSystem(outval);
        var core = outval.val;
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


// iOS workaround callback
function resumeAudio() 
{
    if (gStudio && gStudio.isValid())
    {
        gStudio.getCoreSystem(out);
        var gSystem = out.val;

        check = gSystem.mixerSuspend();
        if (check != fmod.OK)
        {
            console.error('FMOD Error: ' + fmod.ErrorString(check));
            return;
        }

        check = gSystem.mixerResume();
        if (check != fmod.OK)
        {
            console.error('FMOD Error: ' + fmod.ErrorString(check));
            return;
        }
        
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

window.onload = function() { FMODModule(fmod); };
