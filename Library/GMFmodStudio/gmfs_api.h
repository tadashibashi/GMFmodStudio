#pragma once

class GM_DsMap;

const int GM_EVENT_OTHER_SOCIAL = 70;

class GM_API
{
    friend GM_DsMap;
public:
    GM_API() = delete;
    static void Init(char *arg1, char *arg2, char *arg3, char *arg4);
private:
    
    static void (*CreateAsyncEventWithDsMap)(int, int);
    static int (*CreateDsMap)(int _num, ...);
    static bool (*DsMapAddDouble)(int _index, const char *_pKey, double value);
    static bool (*DsMapAddString)(int _index, const char *_pKey, const char *pVal);
};

class GM_DsMap
{
    friend class GM_API;
public:
    GM_DsMap();
    bool AddDouble(const char *key, double value);
    bool AddString(const char *key, const char *value);
    bool IsValid() { return index != -1; }

    // This invalidates the ds map since it is consumed by GameMaker Studio.
    void SendAsyncEvent(int eventType = GM_EVENT_OTHER_SOCIAL);
private:
    int index;
};
