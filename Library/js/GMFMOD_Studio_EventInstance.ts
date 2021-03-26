// ============================================================================
// Playback Control
// ============================================================================

function fmod_studio_evinst_start(inst: FMOD.EventInstance): void
{
    check = inst.start();
}

function fmod_studio_evinst_stop(inst: FMOD.EventInstance,
    mode: FMOD.STUDIO_STOP_MODE = FMOD.STUDIO_STOP_MODE.ALLOWFADEOUT): void
{
    check = inst.stop(mode);
}

function fmod_studio_evinst_get_playback_state(inst: FMOD.EventInstance): number
{
    check = inst.getPlaybackState(out);
    return out.val;
}

function fmod_studio_evinst_set_paused(inst: FMOD.EventInstance, paused: boolean): void
{
    check = inst.setPaused(paused);
}

function fmod_studio_evinst_get_paused(inst: FMOD.EventInstance): boolean
{
    check = inst.getPaused(out);
    return out.val;
}

function fmod_studio_evinst_trigger_cue(inst: FMOD.EventInstance): void
{
    check = inst.triggerCue();
}

// ============================================================================
// Playback Properties
// ============================================================================

function fmod_studio_evinst_set_pitch(inst: FMOD.EventInstance, pitch: number): void
{
    check = inst.setPitch(pitch);
}

function fmod_studio_evinst_get_pitch(inst: FMOD.EventInstance): number
{
    check = inst.getPitch(out, null);
    return out.val;
}

function fmod_studio_evinst_get_pitch_final(inst: FMOD.EventInstance): number
{
    check = inst.getPitch(null, out);
    return out.val;
}

function fmod_studio_evinst_set_property(inst: FMOD.EventInstance, 
    index: FMOD.STUDIO_USER_PROPERTY_TYPE, value: number): void
{
    check = inst.setProperty(index, value);
}

function fmod_studio_evinst_get_property(inst: FMOD.EventInstance,
    index: FMOD.STUDIO_USER_PROPERTY_TYPE): number
{
    check = inst.getProperty(index, out);
    return out.val;
}

function fmod_studio_evinst_set_timeline_position(inst: FMOD.EventInstance,
    position: number): void
{
    check = inst.setTimelinePosition(position);
}

function fmod_studio_evinst_get_timeline_position(inst: FMOD.EventInstance): number
{
    check = inst.getTimelinePosition(out);
    return out.val;
}

function fmod_studio_evinst_set_volume(inst: FMOD.EventInstance, volume: number): void
{
    check = inst.setVolume(volume);
}

function fmod_studio_evinst_get_volume(inst: FMOD.EventInstance): number
{
    check = inst.getVolume(out, null);
    return out.val;
}

function fmod_studio_evinst_get_volume_final(inst: FMOD.EventInstance): number
{
    check = inst.getVolume(null, out);
    return out.val;
}

function fmod_studio_evinst_is_virtual(inst: FMOD.EventInstance): boolean
{
    check = inst.isVirtual(out);
    return out.val;
}

// ============================================================================
// 3D Attributes
// ============================================================================
function fmod_studio_evinst_set_3D_attributes(inst: FMOD.EventInstance, 
    gmbuf: ArrayBuffer): void
{
    let attr = fmod._3D_ATTRIBUTES();

    let buf = new GMBuffer(gmbuf);
    attr.position.x = buf.readFloat32();
    attr.position.y = buf.readFloat32();
    attr.position.z = buf.readFloat32();
    attr.velocity.x = buf.readFloat32();
    attr.velocity.y = buf.readFloat32();
    attr.velocity.z = buf.readFloat32();
    attr.forward.x = buf.readFloat32();
    attr.forward.y = buf.readFloat32();
    attr.forward.z = buf.readFloat32();
    attr.up.x = buf.readFloat32();
    attr.up.y = buf.readFloat32();
    attr.up.z = buf.readFloat32();

    check = inst.set3DAttributes(attr);
}

function fmod_studio_evinst_get_3D_attributes(inst: FMOD.EventInstance,
    gmbuf: ArrayBuffer): void
{
    let attr = fmod._3D_ATTRIBUTES();
    check = inst.get3DAttributes(attr);
    if (check === FMOD.RESULT.OK)
    {
        let buf = new GMBuffer(gmbuf);
        buf.writeFloat32(attr["position.x"]);
        buf.writeFloat32(attr["position.y"]);
        buf.writeFloat32(attr["position.z"]);
        buf.writeFloat32(attr["velocity.x"]);
        buf.writeFloat32(attr["velocity.y"]);
        buf.writeFloat32(attr["velocity.z"]);
        buf.writeFloat32(attr["forward.x"]);
        buf.writeFloat32(attr["forward.y"]);
        buf.writeFloat32(attr["forward.z"]);
        buf.writeFloat32(attr["up.x"]);
        buf.writeFloat32(attr["up.y"]);
        buf.writeFloat32(attr["up.z"]);
    }
}

function fmod_studio_evinst_set_listener_mask(inst: FMOD.EventInstance, 
    mask: number): void
{
    check = inst.setListenerMask(mask);
}

function fmod_studio_evinst_get_listener_mask(inst: FMOD.EventInstance): number
{
    check = inst.getListenerMask(out);
    return out.val;
}

// ============================================================================
// Parameters
// ============================================================================
function fmod_studio_evinst_set_parameter_by_name(inst: FMOD.EventInstance,
    name: string, value: number, ignoreseekspeed: boolean): void
{
    check = inst.setParameterByName(name, value, ignoreseekspeed);
}

function fmod_studio_evinst_get_parameter_by_name(inst: FMOD.EventInstance,
    name: string): void
{
    check = inst.getParameterByName(name, out, null);
    return out.val;
}

function fmod_studio_evinst_get_parameter_by_name_final(inst: FMOD.EventInstance,
    name: string): void
{
    check = inst.getParameterByName(name, null, out);
    return out.val;
}

function fmod_studio_evinst_set_parameter_by_id(inst: FMOD.EventInstance,
    gmbuf: ArrayBuffer, value: number, ignoreseekspeed: boolean): void
{
    let buf = new GMBuffer(gmbuf);
    let pid = fmod.STUDIO_PARAMETER_ID();
    pid.data1 = buf.readUint32();
    pid.data2 = buf.readUint32();

    check = inst.setParameterByID(pid, value, ignoreseekspeed);
}

function fmod_studio_evinst_get_parameter_by_id(inst: FMOD.EventInstance,
    gmbuf: ArrayBuffer): number
{
    let buf = new GMBuffer(gmbuf);
    let pid = fmod.STUDIO_PARAMETER_ID();
    pid.data1 = buf.readUint32();
    pid.data2 = buf.readUint32();

    check = inst.getParameterByID(pid, out, null);

    return out.val;
}

function fmod_studio_evinst_get_parameter_by_id_final(inst: FMOD.EventInstance,
    gmbuf: ArrayBuffer): number
{
    let buf = new GMBuffer(gmbuf);
    let pid = fmod.STUDIO_PARAMETER_ID();
    pid.data1 = buf.readUint32();
    pid.data2 = buf.readUint32();

    check = inst.getParameterByID(pid, null, out);

    return out.val;
}

function fmod_studio_evinst_set_parameters_by_ids(inst: FMOD.EventInstance,
    gmbuf: ArrayBuffer, count: number, ignoreseekspeed: boolean): void
{
    let buf = new GMBuffer(gmbuf);
    let ids = new Array<FMOD.STUDIO_PARAMETER_ID>(count);
    let values = new Array<number>(count);

    for (let i = 0; i < count; ++i)
    {
        let currentid = fmod.STUDIO_PARAMETER_ID();
        currentid.data1 = buf.readUint32();
        currentid.data2 = buf.readUint32();

        ids[i] = currentid;
        values[i] = buf.readFloat32();
    }

    check = inst.setParametersByIDs(ids, values, count, ignoreseekspeed);
}

// ============================================================================
// Core
// ============================================================================
function fmod_studio_evinst_get_channel_group(
    inst: FMOD.EventInstance): FMOD.ChannelGroup
{
    check = inst.getChannelGroup(out);
    return out.val;
}

function fmod_studio_evinst_set_reverb_level(inst: FMOD.EventInstance,
    index: number, level: number): void
{
    check = inst.setReverbLevel(index, level);
}

function fmod_studio_evinst_get_reverb_level(inst: FMOD.EventInstance,
    index: number): void
{
    check = inst.getReverbLevel(index, out);
    return out.val;
}

function fmod_studio_evinst_get_cpu_usage_exclusive(inst: FMOD.EventInstance): number
{
    console.warn("FMOD::Studio::EventInstance::getCPUUsage not supported in HTML5");
    // check = inst.getCPUUsage(out, null);
    // return out.val;
    return -1;
}

function fmod_studio_evinst_get_cpu_usage_inclusive(inst: FMOD.EventInstance): number
{
    console.warn("FMOD::Studio::EventInstance::getCPUUsage not supported in HTML5");
    return -1;
}

function fmod_studio_evinst_get_memory_usage(inst: FMOD.EventInstance,
    gmbuf: ArrayBuffer): void
{
    console.warn("FMOD::Studio::EventInstance::getMemoryUsage not supported in HTML5");
    // let usage = fmod.STUDIO_MEMORY_USAGE();
    // check = inst.getMemoryUsage(usage);
    
    // if (check == FMOD.RESULT.OK)
    // {
    //     let buf = new GMBuffer(gmbuf);
    //     buf.writeInt32(usage.exclusive);
    //     buf.writeInt32(usage.inclusive);
    //     buf.writeInt32(usage.sampledata);
    // }
}

// ============================================================================
// General
// ============================================================================

function fmod_studio_evinst_callback(type: FMOD.STUDIO_EVENT_CALLBACK_TYPE, 
    event: FMOD.EventInstance, parameters: any): FMOD.RESULT
{
    let map: any = {};
    
    map["fmodCallbackType"] = "EventInstance";
    map["event"] = event;
    map["type"] = type;
    
    let result = FMOD.RESULT.OK;

    switch(type)
    {
        case FMOD.STUDIO_EVENT_CALLBACK_TYPE.CREATE_PROGRAMMER_SOUND:
            console.log(parameters);
            map["name"] = parameters["name"];
            map["sound"] = parameters["sound"];
            map["subsoundIndex"] = parameters["subsoundIndex"];

            if (evinstUserData.has(event.$$.ptr))
            {
                let data = evinstUserData.get(event.$$.ptr);
                console.log(data);
                console.log(data.key.indexOf('.'));
                if (data.key.indexOf('.') == -1) // audio table
                {
                    let core: FMOD.System;
                    result = gStudio.getCoreSystem(out);
                    if (result != FMOD.RESULT.OK)
                        return result;
                    
                    core = out.val;
                    
                    let info: FMOD.STUDIO_SOUND_INFO = fmod.STUDIO_SOUND_INFO();
                    if (data.key === "__NAME__")
                    {
                        result = gStudio.getSoundInfo(parameters.name, info);
                    }
                    else
                    {
                        result = gStudio.getSoundInfo(data.key, info);
                    }
                    console.log(info);

                    if (result != FMOD.RESULT.OK)
                        return result;
                    result = core.createSound(info.name_or_data, info.mode | FMOD.MODE.LOOP_NORMAL, info.exinfo, out);
                    if (result != FMOD.RESULT.OK)
                        return result;
                    console.log(out.val);

                    parameters.sound = out.val;
                    parameters.subsoundIndex = info.subsoundindex;
                    console.log(parameters);
                }
                else                             // sound file
                {
                    result = gStudio.getCoreSystem(out);
                    if (result != FMOD.RESULT.OK) return result;

                    let core: FMOD.System = out.val;
                    let exinfo: FMOD.CREATESOUNDEXINFO = fmod.CREATESOUNDEXINFO();
                    exinfo.dlsname = gDlsname;

                    result = core.createStream(data.key, FMOD.MODE.CREATESTREAM | FMOD.MODE.LOOP_NORMAL, exinfo, out);
                    if (result != FMOD.RESULT.OK) return result;

                    parameters.sound = out.val;
                    parameters.subsoundIndex = -1;
                }
            }

        break;

        case FMOD.STUDIO_EVENT_CALLBACK_TYPE.DESTROY_PROGRAMMER_SOUND:
            map["name"] = parameters["name"];
            map["sound"] = parameters["sound"];
            map["subsoundIndex"] = parameters["subsoundIndex"];
            console.log("Destroyed programmer sound!");
            console.log(parameters);
            result = parameters.sound.release();
        break;

        case FMOD.STUDIO_EVENT_CALLBACK_TYPE.PLUGIN_CREATED:
        case FMOD.STUDIO_EVENT_CALLBACK_TYPE.PLUGIN_DESTROYED:
            map["name"] = parameters["name"];
            map["dsp"] = parameters["dsp"];
        break;

        case FMOD.STUDIO_EVENT_CALLBACK_TYPE.TIMELINE_MARKER:
            map["name"] = parameters["name"];
            map["position"] = parameters["position"];
        break;

        case FMOD.STUDIO_EVENT_CALLBACK_TYPE.TIMELINE_BEAT:
            map["bar"] = parameters["bar"];
            map["beat"] = parameters["beat"];
            map["position"] = parameters["position"];
            map["tempo"] = parameters["tempo"];
            map["timesignatureupper"] = parameters["timesignatureupper"];
            map["timesignaturelower"] = parameters["timesignaturelower"];
        break;

        case FMOD.STUDIO_EVENT_CALLBACK_TYPE.SOUND_PLAYED:
        case FMOD.STUDIO_EVENT_CALLBACK_TYPE.SOUND_STOPPED:
            map["sound"] = parameters;
        break;
    }

    GMS_API.send_async_event_social(map);
   
    return result;
}


function fmod_studio_evinst_set_callback(inst: FMOD.EventInstance, 
    mask: number): void
{
    if (mask === 0) // way to null callback
    {
        check = inst.setCallback(null, 0);
    }
    else
    {
        // Must convert to BigInt to prevent bitwise bug on large numbers / precision loss
        let maskval = BigInt(mask);
        check = inst.setCallback(fmod_studio_evinst_callback, Number(maskval));
    }
}

class EvInstUserData
{
    public system: FMOD.StudioSystem;
    public key: string;

    public constructor(system: FMOD.StudioSystem, key: string)
    {
        this.system = system;
        this.key = key;
    }
}

let gDlsname: string = "";

function fmod_studio_set_dlsname(name: string): void
{
    gDlsname = name;
}

function fmod_studio_get_dlsname(): string
{
    return gDlsname;
}

const evinstUserData = new Map<number, EvInstUserData>();

function fmod_studio_evinst_set_user_data(inst: FMOD.EventInstance, datastr: string, studio: FMOD.StudioSystem)
{
    evinstUserData.set(inst.$$.ptr, new EvInstUserData(studio, datastr));
}

function fmod_studio_evdesc_set_callback(desc: FMOD.EventDescription, 
    mask: number): void
{
    console.warn("FMOD Studio JS/HTML5 does not currently support setting callbacks with EventDescription. " +
        "There is a binding error. Please set each Event Instance's callback directly");
    let maskval = BigInt(mask);
    check = desc.setCallback(fmod_studio_evinst_callback, Number(maskval));
}

function fmod_studio_evinst_get_description(inst: FMOD.EventInstance): FMOD.EventDescription
{
    check = inst.getDescription(out);
    return out.val;
}

function fmod_studio_evinst_release(inst: FMOD.EventInstance)
{
    check = inst.release();
}

function fmod_studio_evinst_is_valid(inst: FMOD.EventInstance): boolean
{
    return inst.isValid();
}
