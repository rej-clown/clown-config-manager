#pragma newdecls required

#include <clown-core>
#include <clown-core/config-manager>

public Plugin myinfo = 
{
	name = "[Clown] Config Manager",
	author = "rej.chev",
	description = "...",
	version = "1.1.0",
	url = "discord.gg/ChTyPUG"
};

public void OnMapStart()
{
    ClownCore.SendData(ClownCM_EVENT_ALIVE, null);   
}

public DataAction clown_OnDataSent(const char[] path, Json data)
{
    if(!strcmp(path, ClownCM_EVENT_ALIVE))
        return kReject;

    if(!strcmp(path, ClownCM_PING))
        return kReceive;

    if(!data)
        return kContinue;
    
    JsonObject jsonBuffer =
        asJSONO(data);

    Json cfg;
    
    char buffer[PLATFORM_MAX_PATH];

    if(!strcmp(ClownCM_GET, path, true) || !strcmp(ClownCM_SET, path, true))
    {
        ClownBuildPath(jsonBuffer, buffer, sizeof(buffer));

        // TODO: ClownCore notifiers
        if(!FileExists(buffer))
        {
            return kReject_Immedently;
        }

    }

    if(!strcmp(ClownCM_GET, path, true))
    {
        // data: Json Object
        // data.path: Json String
        // data.build: Json Int (PathType or -1)
        // data.response: Json or Json null
        
        jsonBuffer.Set("response", (cfg = Json.JsonF(buffer, 0)));

        delete cfg;
        return kReceive;
    }

    if(!strcmp(ClownCM_SET, path, true))
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