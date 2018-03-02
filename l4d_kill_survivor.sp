#include <sourcemod>
#include <sdktools>
#include <colors>
#define PLUGIN_VERSION "1.0"
new g_BeamSprite        = -1;
new g_HaloSprite        = -1;
new String:SpriteBeam[]="sprites/laserbeam.vmt"
new String:SpriteHalo[]="sprites/glow01.vmt"
new String:Sound[]="weapons/hegrenade/explode5.wav"
// Basic color arrays for temp entities
new redColor[4]		= {255, 75, 75, 255};
new orangeColor[4]	= {255, 128, 0, 255};
new greenColor[4]	= {75, 255, 75, 255};
new blueColor[4]	= {75, 75, 255, 255};
new whiteColor[4]	= {255, 255, 255, 255};
new greyColor[4]	= {128, 128, 128, 255};
public Plugin:myinfo = 
{
	name = "自杀插件By HUANG",
	author = "HUANG",
	description = "use the !zs command in chat",
	version = PLUGIN_VERSION,
	url =  "http://www.evilback.cn/"
}
 
public OnPluginStart() 
{
	g_BeamSprite = PrecacheModel(SpriteBeam,true);
	g_HaloSprite = PrecacheModel(SpriteHalo,true);
	PrecacheSound(Sound, true);
	RegConsoleCmd("sm_zs", Kill_Me);
}

public OnMapStart()
{
	g_BeamSprite = PrecacheModel(SpriteBeam,true);
	g_HaloSprite = PrecacheModel(SpriteHalo,true);
	PrecacheSound(Sound, true);	

}
// kill
public Action:Kill_Me(client, args)
{
	if (GetClientTeam(client) == 2 && IsPlayerAlive(client))
	{
		Create_Beacon(client);
		ForcePlayerSuicide(client);
		CPrintToChatAll("{red} %N {green} 失去了梦想，变成了一条闲鱼QAQ",client);
	}
	else
	{
		CPrintToChat(client, "{red}【错误】:你必须成为一个生还者");
	}
}
public Create_Beacon(client)
{
	float vec[3];
	GetClientAbsOrigin(client, vec);
	vec[2] += 10;
	if (g_BeamSprite > -1 && g_HaloSprite > -1)
	{
		TE_SetupBeamRingPoint(vec, 10.0, 375.0, g_BeamSprite, g_HaloSprite, 0, 15, 0.5, 5.0, 0.0, blueColor, 10, 0);
		TE_SendToAll();
		TE_SetupBeamRingPoint(vec, 10.0, 375.0, g_BeamSprite, g_HaloSprite, 0, 10, 0.6, 10.0, 0.5, redColor, 10, 0);
		TE_SendToAll();
	}
	GetClientEyePosition(client, vec);
	EmitAmbientSound(Sound, vec, client, SNDLEVEL_RAIDSIREN);
}