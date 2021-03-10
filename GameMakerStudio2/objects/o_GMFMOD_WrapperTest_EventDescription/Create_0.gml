// Inherit the parent event
event_inherited();

timer = 0;

studio.loadBankFile("soundbanks/Desktop/Master_ENG.bank",
    FMOD_STUDIO_LOAD_BANK_NORMAL);
GMFMOD_Check("Loading master bank file");
studio.loadBankFile("soundbanks/Desktop/Master_ENG.strings.bank",
    FMOD_STUDIO_LOAD_BANK_NORMAL);
GMFMOD_Check("Loading strings bank file");

edmusic = studio.getEvent("event:/Music"); /// @is {GMFMOD_Studio_EventDescription}
GMFMOD_Check("Getting music event");
edblip = studio.getEvent("event:/UIBlip"); /// @is {GMFMOD_Studio_EventDescription}
GMFMOD_Check("Getting blip event");

GMFMOD_Assert(edmusic.isValid(), true, "Retrieved event is valid: music");
GMFMOD_Assert(edblip.isValid(), true, "Retrieved event is valid: blip");

// ===== Create Instance =========
var eimusic = edmusic.createInstance();
GMFMOD_Check("Creating instance");
var eimusicByRef = new GMFMOD_Studio_EventInstance();
edmusic.createInstance(eimusicByRef);
GMFMOD_Check("Creating instance, assign by ref");

GMFMOD_Assert(eimusic.isValid(), true, "Created music instance is valid");
GMFMOD_Assert(eimusicByRef.isValid(), true, "Created music instance is valid");

// Note: Please make sure to stop (if playing) and release instances before deleting
eimusic.release();
GMFMOD_Check("Releasing music instance");
eimusicByRef.release();
GMFMOD_Check("Releasing music instance");
studio.flushCommands(); // commands must be flushed to process now
GMFMOD_Check("Flushing commands");
delete eimusic;
delete eimusicByRef;

// ====== Get Instance Count/ Release all instances ======
var eimusic = edmusic.createInstance();
GMFMOD_Check("Creating music instance");
GMFMOD_Assert(edmusic.getInstanceCount(), 1, "Get Instance Count matches");
GMFMOD_Check("Getting instance count");
edmusic.createInstance();
GMFMOD_Assert(edmusic.getInstanceCount(), 2, "Get Instance Count matches");
GMFMOD_Check("Getting instance count");

eimusic.release();
GMFMOD_Check("Releasing music instance");

studio.flushCommands(); // needed to process release now
GMFMOD_Check("Flushing commands");

GMFMOD_Assert(edmusic.getInstanceCount(), 1, "Get Instance Count matches");
GMFMOD_Check("Getting instance count");

edmusic.releaseAllInstances();
GMFMOD_Check("Releasing all music instances");
studio.flushCommands();
GMFMOD_Check("Flushing commands");

GMFMOD_Assert(edmusic.getInstanceCount(), 0, "All instances released");
GMFMOD_Check("Getting instance count");

// ===== Get Instance List =====
var eimusic1 = edmusic.createInstance();
var eimusic2 = edmusic.createInstance();

GMFMOD_Assert(eimusic1.isValid() && eimusic2.isValid(), true, 
    "Get Instance List: Retrieved valid instances");

var instlist = edmusic.getInstanceList();
GMFMOD_Check("Getting instance list");

var instlistByRef = [];
edmusic.getInstanceList(instlistByRef);
GMFMOD_Check("Getting instance list by ref");

GMFMOD_Assert(array_length(instlist) == array_length(instlistByRef),
    true, "Arrays are equal in length");

var arraysEqual = true;
var allAreValid = true;
for (var i = 0; i < array_length(instlist); ++i)
{
    if (instlist[i].inst_ != instlistByRef[i].inst_)
    {
        arraysEqual = false;
    }
    
    if (!instlist[i].isValid() || !instlistByRef[i].isValid())
    {
        allAreValid = false;
    }
}

GMFMOD_Assert(arraysEqual, true, 
    "Arrays retrieved from getInstanceList are equal");
GMFMOD_Assert(arraysEqual, true, 
    "Instances retrieved from getInstanceList are all valid instances");


// ====== Load/Unload Sample Data ==============

// ====== Is 3D ================================

// ====== Is Oneshot ===========================

// ====== Is Snapshot ==========================

// ====== Is Stream ============================

// ====== Has Cue ==============================

// ====== Get Max Distance/Min Distance ========

// ====== Get Param Description Count ==========

// ====== Get Param Description by Index =======

// ====== Get Param Description by ID ==========

// ====== Get User Property ====================

// ====== Get User Property by Index ===========

// ====== Get User Property Count ==============

// ====== Get ID ===============================

// ====== Get Length ===========================

// ====== Get Path =============================

// ====== Set Callback =========================