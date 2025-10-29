#include <sourcemod>
#include <tf2_stocks>

#pragma semicolon 1
#pragma newdecls required

#define PLUGIN_VERSION			"1"
// #define PLUGIN_VERSION_REVISION	"custom"
// #define PLUGIN_VERSION_FULL		PLUGIN_VERSION ... "." ... PLUGIN_VERSION_REVISION

// #define CONFIG_FILE	"configs/propkill/specials.cfg"

#define FAR_FUTURE		100000000.0

public Plugin myinfo =
{
	name		=	"Vscript Gutter",
	author		=	"kiwi",
	description	=	"Guts vscript from maps, forked from 'Propkill plugin by Batfoxkid'",
	version		=	PLUGIN_VERSION
}

public void OnPluginStart()
{
	if (DirExists("scripts/vscripts/sm_vs_overrides/", false) == false)
	{
		CreateDirectory("scripts/vscripts/sm_vs_overrides/", 511);
	}
}

public void OnMapInit()
{
	char scriptfile[PLATFORM_MAX_PATH];
	char fullpath_buffer[512] = "scripts/vscripts/sm_vs_overrides/";
	char replacefile_buffer[512] = "sm_vs_overrides/";
	int length = EntityLump.Length();
	for(int i; i < length; i++)
	{
		EntityLumpEntry entry = EntityLump.Get(i);

		int index = entry.FindKey("vscripts");
		if(index != -1)
		{
			entry.Get(index, _, _, scriptfile, sizeof(scriptfile));
			PrintToServer("%s", scriptfile);
			StrCat(fullpath_buffer,PLATFORM_MAX_PATH,scriptfile);
			StrCat(replacefile_buffer,PLATFORM_MAX_PATH,scriptfile);
			PrintToServer("%s", fullpath_buffer);
			// Replace with the server's version of the script
			if(FileExists(fullpath_buffer, false))
			{
					entry.Update(index, NULL_STRING, replacefile_buffer);
					i = length;
			}
			else
			{
				LogMessage("File %s was not found, not overriding", fullpath_buffer);
			}
		}

		delete entry;
	}
}

// public void OnConfigsExecuted()
// {

// }

// void CallScriptFunction(const char[] name)
// {
// 	char buffer[64];

// 	int entity = -1;
// 	while((entity=FindEntityByClassname(entity, "*")) != -1)
// 	{
// 		GetEntPropString(entity, Prop_Data, "m_iszVScripts", buffer, sizeof(buffer));
// 		if(StrEqual(buffer, "propkill.nut") || StrEqual(buffer, "_temppropkill.nut"))
// 		{
// 			SetVariantString(name);
// 			AcceptEntityInput(entity, "CallScriptFunction", entity, entity);
// 			return;
// 		}
// 	}

// 	LogError("Could not find VScript hosted entity");
// }