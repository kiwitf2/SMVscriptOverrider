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

// public void OnPluginStart()
// {
// }

public void OnMapInit()
{
	char buffer[PLATFORM_MAX_PATH];
	char buffer2[512] = "scripts/vscripts/";
	int length = EntityLump.Length();
	for(int i; i < length; i++)
	{
		EntityLumpEntry entry = EntityLump.Get(i);

		int index = entry.FindKey("vscripts");
		if(index != -1)
		{
			entry.Get(index, _, _, buffer, sizeof(buffer));
			PrintToServer("%s", buffer);
			StrCat(buffer2, buffer);
			PrintToServer("%s", buffer2);
			if(StrEqual(buffer, "freakscript.nut", false))
			{
				// Replace with the server's version of the script
				if(FileExists("scripts/vscripts/propkill.nut", false))
				{
					DeleteFile("scripts/vscripts/_temppropkill.nut");
					if(RenameFile("scripts/vscripts/_temppropkill.nut", "scripts/vscripts/propkill.nut"))
					{
						entry.Update(index, NULL_STRING, "_temppropkill.nut");
						i = length;
					}
					else
					{
						LogError("Could not access scripts/vscripts/propkill.nut");
					}
				}
			}
		}

		delete entry;
	}
}

// public void OnConfigsExecuted()
// {

// }

public void OnMapEnd()
{
	if(FileExists("scripts/vscripts/_temppropkill.nut", false))
	{
		RenameFile("scripts/vscripts/propkill.nut", "scripts/vscripts/_temppropkill.nut");
	}
}

void CallScriptFunction(const char[] name)
{
	char buffer[64];

	int entity = -1;
	while((entity=FindEntityByClassname(entity, "*")) != -1)
	{
		GetEntPropString(entity, Prop_Data, "m_iszVScripts", buffer, sizeof(buffer));
		if(StrEqual(buffer, "propkill.nut") || StrEqual(buffer, "_temppropkill.nut"))
		{
			SetVariantString(name);
			AcceptEntityInput(entity, "CallScriptFunction", entity, entity);
			return;
		}
	}

	LogError("Could not find VScript hosted entity");
}