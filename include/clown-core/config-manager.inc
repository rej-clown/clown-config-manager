#if defined _clown_config_manager_included
 #endinput
#endif
#define _clown_config_manager_included

// @desc 
stock const char ClownCM_GET[] =
    "clown.cfg.get";

// @desc
stock const char ClownCM_SET[] =
    "clown.cfg.set";

// @desc
stock const char ClownCM_PING[] =
    "clown.cfg.ping";

// can not be called from another plugins :/
// TODO: call policy
stock const char ClownCM_EVENT_ALIVE[] =
    "clown.cfg.event.alive";

stock JsonObject ClownCM_ObjectGetRequest(const char[] path, int build = view_as<int>(Path_SM))
{
    return asJSONO((new JsonBuilder("{}"))
        .SetString("path", path)
        .SetInt("build", build)
        .Build());
}

stock JsonObject ClownCM_ObjectSetRequest(
    const char[] path, 
    Json data, 
    int build = 0, 
    int flags = 0)
{
    return asJSONO((new JsonBuilder("{}"))
        .SetString("path", path)
        .SetInt("flags", flags)
        .SetInt("build", build)
        .Set("data", data)
        .Build());
}

stock Json ClownCM_ConfigGetRequest(JsonObject request, bool deleteRequestObject = true)
{
    // we think that :request: != null

    if(ClownCore.SendData(ClownCM_GET, request) != kReceive)
        return null;

    // we think that :response: key exist then kRecieve is returned

    if(request.GetType("response") == JSON_NULL)
        return null;

    Json buffer = request.Get("response");
    
    if(deleteRequestObject)
        delete request;

    return buffer;
}

stock DataAction ClownCM_ConfigSetRequest(JsonObject request, bool deleteRequestObject = true)
{
    // we think that :request: != null
    DataAction action = ClownCore.SendData(ClownCM_SET, request);

    if(deleteRequestObject)
        delete request;

    return action;
}

stock bool ClownCM_IsAlive()
{
    return ClownCore.SendData(ClownCM_PING, null) == kReceive;
}