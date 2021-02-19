#include "gmfs_api.h"

void (*GM_API::CreateAsyncEventWithDsMap)(int, int) = nullptr;
int (*GM_API::CreateDsMap)(int _num, ...) = nullptr;
bool (*GM_API::DsMapAddDouble)(int _index, const char *_pKey, double value) = nullptr;
bool (*GM_API::DsMapAddString)(int _index, const char *_pKey, const char *pVal) = nullptr;

void GM_API::Init(char *arg1, char *arg2, char *arg3, char *arg4)
{
    void (*CreateAsynEventWithDSMapPtr)(int, int) = (void (*)(int, int))(arg1);
    int(*CreateDsMapPtr)(int _num, ...) = (int(*)(int _num, ...)) (arg2);
    CreateAsyncEventWithDsMap = CreateAsynEventWithDSMapPtr;
    CreateDsMap = CreateDsMapPtr;

    bool (*DsMapAddDoublePtr)(int _index, const char *_pKey, double value) = (bool(*)(int, const char *, double))(arg3);
    bool (*DsMapAddStringPtr)(int _index, const char *_pKey, const char *pVal) = (bool(*)(int, const char *, const char *))(arg4);

    DsMapAddDouble = DsMapAddDoublePtr;
    DsMapAddString = DsMapAddStringPtr;
}

GM_DsMap::GM_DsMap(): index(GM_API::CreateDsMap(0))
{
}

bool GM_DsMap::AddDouble(const char *key, double value)
{
    return GM_API::DsMapAddDouble(index, key, value);
}

bool GM_DsMap::AddString(const char *key, const char *value)
{
    return GM_API::DsMapAddString(index, key, value);
}

void GM_DsMap::SendAsyncEvent(int eventType)
{
    GM_API::CreateAsyncEventWithDsMap(index, eventType);
    index = -1;
}
