#if defined _clown_config_manager_included
 #endinput
#endif
#define _clown_config_manager_included

// @desc 
stock const char config_manager_get[] =
    "clown.cfg.get";

// @desc
stock const char config_manager_set[] =
    "clown.cfg.set";


stock Json Clown_CreateConfigGetObject(const char[] path, int build = view_as<int>(Path_SM))
{
    return (new JsonBuilder("{}"))
        .SetString("path", path)
        .SetInt("build", build)
        .Build();
}

stock Json Clown_CreateConfigSetObject
(const char[] path, Json data, int build = view_as<int>(Path_SM), int flags = JSON_INDENT(4))
{
    return (new JsonBuilder("{}"))
        .SetString("path", path)
        .SetInt("flags", flags)
        .SetInt("build", build)
        .Set("data", data)
        .Build();
}

stock Json Clown_GetMyConfig(JsonObject req)
{
    ClownCore.SendData(config_manager_get, req);
    return (req.GetType("response") != JSON_NULL)
        ? req.Get("response")
        : null;
}

stock Json Clown_GetMyConfigEx(JsonObject req)
{
    // :/
    if(!req || ClownCore.SendData(config_manager_get, req) != kReceive || !req)
    {
        delete req;
        return null;
    }

    Json response = (req.GetType("response") != JSON_NULL)
        ? req.Get("response")
        : null;

    delete req;
    return response;
}

stock DataAction Clown_SetMyConfig(JsonObject req)
{
    return ClownCore.SendData(config_manager_set, req);
}

stock DataAction Clown_SetMyConfigEx(JsonObject req)
{
    if(!req)
        return kReject_Immedently;
        
    DataAction action = 
        ClownCore.SendData(config_manager_set, req);

    delete req;
    return action;
}