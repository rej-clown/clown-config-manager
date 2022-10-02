#pragma newdecls required

#define CLOWN_USE_JANSSON

#include <clown-core>
#include <clown-config-manager>

public Plugin myinfo = 
{
	name = "[Clown] Config Manager",
	author = "rej.chev",
	description = "...",
	version = "1.0.0",
	url = "discord.gg/ChTyPUG"
};

public DataAction clown_OnDataSent(const char[] path, Handle data)
{
    if(!data)
        return kContinue;
    
    JsonObject jsonBuffer =
        asJSONO(data);

    Json cfg;
    
    char buffer[PLATFORM_MAX_PATH];

    if(!strcmp(config_manager_get, path, true) || !strcmp(config_manager_set, path, true))
    {
        ClownBuildPath(jsonBuffer, buffer, sizeof(buffer));

        // TODO: ClownCore notifiers
        if(!FileExists(buffer))
        {
            return kReject_Immedently;
        }

    }

    if(!strcmp(config_manager_get, path, true))
    {
        // data: Json Object
        // data.path: Json String
        // data.build: Json Int (PathType or -1)
        // data.response: Json or Json null
        
        jsonBuffer.Set("response", cfg = Json.JsonF(buffer, 0));

        delete cfg;
        return kReceive;
    }

    if(!strcmp(config_manager_set, path, true))
    {
        // data: Json Object
        // data.path: Json String
        // data.build: Json int
        // data.data: Json
        // data.flags: Json Int

        (cfg = jsonBuffer.Get("data")).ToFile(buffer, jsonBuffer.GetInt("flags"));

        delete cfg;
        return kReceive;
    }

    return kContinue;
}

void ClownBuildPath(JsonObject json, char[] buffer, int size)
{
    json.GetString("path", buffer, size);

    if(json.GetInt("build") != -1)
        BuildPath(view_as<PathType>(json.GetInt("build")), buffer, size, buffer);
}