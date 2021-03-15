// ============================================================================
// #region Instances
// ============================================================================

function fmod_studio_evdesc_create_instance(
    desc: FMOD.EventDescription): FMOD.EventInstance
{
    check = desc.createInstance(out);
    return out.val;
}

function fmod_studio_evdesc_get_instance_count(desc: FMOD.EventDescription)
{
    check = desc.getInstanceCount(out);
    return out.val;
}

function fmod_studio_evdesc_get_event_list(desc: FMOD.EventDescription,
    capacity: number, arr: FMOD.Bank[]): number
{
    if (desc.isValid())
    {
        check = desc.getInstanceCount(out);
        let count: number = out.val;
        if (check != FMOD.RESULT.OK) return 0;

        if (count > capacity) count = capacity;

        check = desc.getInstanceList(out, count, null);
        arr.length = count;
        if (check == FMOD.RESULT.OK)
        {
            for (let i = 0; i < count; ++i)
            {
                arr[i] = out.val[i];
            }
        }

        return count;
    }
    else
    {
        check = FMOD.RESULT.ERR_INVALID_HANDLE;
    }

    return 0;
}

function fmod_studio_evdesc_release_all_instances(
    desc: FMOD.EventDescription): void
{
    check = desc.releaseAllInstances();
}
// #endregion

// ============================================================================
// #region Sample Data
// ============================================================================

function fmod_studio_evdesc_load_sample_data(desc: FMOD.EventDescription): void
{
    check = desc.loadSampleData();
}

function fmod_studio_evdesc_unload_sample_data(
    desc: FMOD.EventDescription): void
{
    check = desc.unloadSampleData();
}

function fmod_studio_evdesc_get_sample_loading_state(
    desc: FMOD.EventDescription): number
{
    check = desc.getSampleLoadingState(out);
    return out.val;
}

// #endregion

// ============================================================================
// #region Attributes
// ============================================================================

function fmod_studio_evdesc_is_3D(desc: FMOD.EventDescription): boolean
{
    check = desc.is3D(out);
    return out.val as boolean;
}

function fmod_studio_evdesc_is_oneshot(desc: FMOD.EventDescription): boolean
{
    check = desc.isOneshot(out);
    return out.val as boolean;
}

function fmod_studio_evdesc_is_snapshot(desc: FMOD.EventDescription): boolean
{
    check = desc.isSnapshot(out);
    return out.val as boolean;
}

function fmod_studio_evdesc_is_stream(desc: FMOD.EventDescription): boolean
{
    check = desc.isStream(out);
    return out.val as boolean;
}

function fmod_studio_evdesc_has_cue(desc: FMOD.EventDescription): boolean
{
    check = desc.hasCue(out);
    return out.val as boolean;
}

function fmod_studio_evdesc_get_max_distance(desc: FMOD.EventDescription): number
{
    check = desc.getMaximumDistance(out);
    return out.val as number;
}

function fmod_studio_evdesc_get_min_distance(desc: FMOD.EventDescription): number
{
    check = desc.getMinimumDistance(out);
    return out.val as number;
}

function fmod_studio_evdesc_get_sound_size(desc: FMOD.EventDescription): number
{
    check = desc.getSoundSize(out);
    return out.val as number;
}

// #endregion

// ============================================================================
// #region Parameters
// ============================================================================
function fmod_studio_evdesc_get_paramdesc_count(desc: FMOD.EventDescription): number
{
    check = desc.getParameterDescriptionCount(out);
    return out.val as number;
}

function fmod_studio_evdesc_get_paramdesc_by_name(
    desc: FMOD.EventDescription, name: string, gmbuf: ArrayBuffer): void
{
    let pdesc = fmod.STUDIO_PARAMETER_DESCRIPTION();
    check = desc.getParameterDescriptionByName(name, pdesc);
    
    if (check === FMOD.RESULT.OK)
    {
        let buf = new GMBuffer(gmbuf);
        buf.writeCharStar(pdesc["name"]);
        buf.writeUint32(pdesc["id.data1"]);
        buf.writeUint32(pdesc["id.data2"]);
        buf.writeFloat32(pdesc["minimum"]);
        buf.writeFloat32(pdesc["maximum"]);
        buf.writeFloat32(pdesc["defaultvalue"]);
        buf.writeUint32(pdesc["type"]);
        buf.writeUint32(pdesc["flags"]);
    }
}


function fmod_studio_evdesc_get_paramdesc_by_index(
    desc: FMOD.EventDescription, index: number, gmbuf: ArrayBuffer): void
{
    let pdesc = fmod.STUDIO_PARAMETER_DESCRIPTION();
    check = desc.getParameterDescriptionByIndex(index, pdesc);
    
    if (check === FMOD.RESULT.OK)
    {
        let buf = new GMBuffer(gmbuf);
        buf.writeCharStar(pdesc["name"]);
        buf.writeUint32(pdesc["id.data1"]);
        buf.writeUint32(pdesc["id.data2"]);
        buf.writeFloat32(pdesc["minimum"]);
        buf.writeFloat32(pdesc["maximum"]);
        buf.writeFloat32(pdesc["defaultvalue"]);
        buf.writeUint32(pdesc["type"]);
        buf.writeUint32(pdesc["flags"]);
    }
}


function fmod_studio_evdesc_get_paramdesc_by_id(
    desc: FMOD.EventDescription, gmbuf: ArrayBuffer): void
{
    let pdesc = fmod.STUDIO_PARAMETER_DESCRIPTION();
    let buf = new GMBuffer(gmbuf);
    let pid = fmod.STUDIO_PARAMETER_ID();
    pid.data1 = buf.readUint32();
    pid.data2 = buf.readUint32();
    buf.rewind();

    check = desc.getParameterDescriptionByID(pid, pdesc);
    
    if (check === FMOD.RESULT.OK)
    {
        buf.writeCharStar(pdesc["name"]);
        buf.writeUint32(pdesc["id.data1"]);
        buf.writeUint32(pdesc["id.data2"]);
        buf.writeFloat32(pdesc["minimum"]);
        buf.writeFloat32(pdesc["maximum"]);
        buf.writeFloat32(pdesc["defaultvalue"]);
        buf.writeUint32(pdesc["type"]);
        buf.writeUint32(pdesc["flags"]);
    }
}

// #endregion

// ============================================================================
// #region User Properties
// ============================================================================
function fmod_studio_evdesc_get_user_property(desc: FMOD.EventDescription,
    name: string, gmbuf: ArrayBuffer): void
{
    let prop = fmod.STUDIO_USER_PROPERTY();
    check = desc.getUserProperty(name, prop);
    if (check === FMOD.RESULT.OK)
    {
        let buf = new GMBuffer(gmbuf);
        buf.writeCharStar(prop["name"]);
        buf.writeUint32(prop["type"]);
        switch(prop["type"])
        {
            case FMOD.STUDIO_USER_PROPERTY_TYPE.BOOLEAN:
                buf.writeUint8(prop["boolvalue"]);
            break;

            case FMOD.STUDIO_USER_PROPERTY_TYPE.FLOAT:
                buf.writeFloat32(prop["floatvalue"]);
            break;
            
            case FMOD.STUDIO_USER_PROPERTY_TYPE.INTEGER:
                buf.writeInt32(prop["intvalue"]);
            break;

            case FMOD.STUDIO_USER_PROPERTY_TYPE.STRING:
                buf.writeCharStar(prop["stringvalue"]);
            break;
            default:
                console.error("GMFMOD Error! Tried to get the value of user " +
                    "property " + prop["name"] + ", but the type of property " +
                    "is not supported.");
            break;
        }
    }
}

function fmod_studio_evdesc_get_user_property_by_index(desc: FMOD.EventDescription,
    index: number, gmbuf: ArrayBuffer): void
{
    let prop = fmod.STUDIO_USER_PROPERTY();
    check = desc.getUserPropertyByIndex(index, prop);
    if (check === FMOD.RESULT.OK)
    {
        let buf = new GMBuffer(gmbuf);
        buf.writeCharStar(prop["name"]);
        buf.writeUint32(prop["type"]);
        switch(prop["type"])
        {
            case FMOD.STUDIO_USER_PROPERTY_TYPE.BOOLEAN:
                buf.writeUint8(prop["boolvalue"]);
            break;

            case FMOD.STUDIO_USER_PROPERTY_TYPE.FLOAT:
                buf.writeFloat32(prop["floatvalue"]);
            break;
            
            case FMOD.STUDIO_USER_PROPERTY_TYPE.INTEGER:
                buf.writeInt32(prop["intvalue"]);
            break;

            case FMOD.STUDIO_USER_PROPERTY_TYPE.STRING:
                buf.writeCharStar(prop["stringvalue"]);
            break;
            default:
                console.error("GMFMOD Error! Tried to get the value of user " +
                    "property " + prop["name"] + ", but the type of property " +
                    "is not supported.");
            break;
        }
    }
}

function fmod_studio_evdesc_get_user_property_count(desc: FMOD.EventDescription)
{
    check = desc.getUserPropertyCount(out);
    return out.val;
}

// #endregion

// ============================================================================
// #region General
// ============================================================================
function fmod_studio_evdesc_get_id(desc: FMOD.EventDescription, 
    gmbuf: ArrayBuffer): void
{
    let guid = fmod.GUID();
    check = desc.getID(guid);
    if (check == FMOD.RESULT.OK)
    {
        let buf = new GMBuffer(gmbuf);
        buf.writeUint32(guid.Data1);
        buf.writeUint16(guid.Data2);
        buf.writeUint16(guid.Data3);
        
        for (let i = 0; i < 8; ++i)
        {
            buf.writeUint8(guid.Data4[i]);
        }
    }
}

function fmod_studio_evdesc_get_length(desc: FMOD.EventDescription): number
{
    check = desc.getLength(out);
    return out.val;
}

function fmod_studio_evdesc_get_path(desc: FMOD.EventDescription): string
{
    check = desc.getPath(out, 256, null);
    return out.val;
}

function fmod_studio_evdesc_is_valid(desc: FMOD.EventDescription): boolean
{
    return desc.isValid();
}

// #endregion

