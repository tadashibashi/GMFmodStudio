declare var fmodFiles: Array<string>;
declare var gameRootDir: string;
declare namespace GMS_API {
    export function send_async_event_social(obj: any): void;
}
declare var fmod: FMOD;
declare var gStudio: FMOD.StudioSystem;

let out: Out<any> = {val: 0};
let check: FMOD.RESULT = 0;

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

function GMFMOD_RefsEqual(obj1: any, obj2: any): boolean
{
    console.log(obj1);
    console.log(obj2);
    return obj1.$$.ptr === obj2.$$.ptr;
}