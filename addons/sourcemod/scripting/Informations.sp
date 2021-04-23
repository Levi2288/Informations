#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Levi2288"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>
#include <sdktools>
#include <multicolors>

Handle donatorsfile;
Handle sm_steamgroup_enable = INVALID_HANDLE;
Handle sm_discord_enable = INVALID_HANDLE;
Handle sm_owner_enable = INVALID_HANDLE;
Handle sm_ts3_enable = INVALID_HANDLE;
Handle sm_donate_enable = INVALID_HANDLE;

#pragma newdecls required

public Plugin myinfo = 
{
	name = "Informations",
	author = PLUGIN_AUTHOR,
	description = "Customazable informations.",
	version = PLUGIN_VERSION,
	url = "https://github.com/Bufika2288"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_steamgroup", Steam);
	RegConsoleCmd("sm_group", Steam);
	RegConsoleCmd("sm_steam", Steam);
	
	RegConsoleCmd("sm_discord", Discord);
	RegConsoleCmd("sm_dc", Discord);
	
	RegConsoleCmd("sm_donate", Donate);
	RegConsoleCmd("sm_support", Donate);
	RegConsoleCmd("sm_don", Donate);
	
	RegConsoleCmd("sm_steamprofile", Owner);
	RegConsoleCmd("sm_profile", Owner);
	RegConsoleCmd("sm_owner", Owner);
	
	RegConsoleCmd("sm_ts3", TS);
	RegConsoleCmd("sm_teamspeak", TS);
	RegConsoleCmd("sm_ts", TS);
	
	LoadTranslations("Informations.phrases");
	LoadTranslations("common.phrases");
	
	AutoExecConfig(true, "Informations");
	sm_steamgroup_enable = CreateConVar("sm_steamgroup_enable","1", "Enable steam info ");
	sm_discord_enable = CreateConVar("sm_discord_enable", "1","Enable discord info");
	sm_owner_enable = CreateConVar("sm_owner_enable", "1","Enable Owner info ");
	sm_ts3_enable = CreateConVar("sm_ts3_enable", "1","Enable discord info");
	sm_donate_enable = CreateConVar("sm_donate_enable", "1","Enable Donate info ");
	
	CreateConVar("sm_informations_version", PLUGIN_VERSION, "Plugin Version", FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);
}

//Steam
public Action Steam(int client, int args)
{
	if (GetConVarBool(sm_steamgroup_enable))
	{
		if(IsClientInGame(client))
		{
			CPrintToChat(client, "%t", "Steam");
	
		}
	}

	return Plugin_Handled;
}

//Discord
public Action Discord(int client, int args)
{
	if (GetConVarBool(sm_discord_enable))
	{
		if(IsClientInGame(client))
		{
			CPrintToChat(client, "%t", "Discord");
	
		}
	}
	
	return Plugin_Handled;
}

//Owner
public Action Owner(int client, int args)
{
	if (GetConVarBool(sm_owner_enable))
	{
		if(IsClientInGame(client))
		{
			CPrintToChat(client, "%t", "Owner");
	
		}
	}
	
	return Plugin_Handled;
}

//TS3
public Action TS(int client, int args)
{
	if (GetConVarBool(sm_ts3_enable))
	{
		if(IsClientInGame(client))
		{
			CPrintToChat(client, "%t", "Ts3");
	
		}
	}
	
	return Plugin_Handled;
}
//Donate
public Action Donate(int client, int args)
{
	if (GetConVarBool(sm_donate_enable))
	{
		
		if(IsClientInGame(client))
		{
			DonatorsMenu(client);
		}
	}
	
	return Plugin_Handled;
}



public bool DonatorsMenu(int client)
{
	char buffer[128];
	Format(buffer, sizeof(buffer), "%T \n \n", "DonatorMenu", client);
	Menu DMenu = new Menu(MenuHandlerDonators, MenuAction_Display);
	DMenu.SetTitle(buffer);
	DMenu.AddItem("Donators", "Donators");
	DMenu.Pagination = 7;
	DMenu.ExitButton = true;
	
	DMenu.Display(client, MENU_TIME_FOREVER);

	return true;



}

public bool DonatorList(int client)
{
	donatorsfile = OpenFile("addons/sourcemod/configs/donator_list.ini", "rt");
	if (donatorsfile == INVALID_HANDLE)
	{
		return true;
	}
	
	Menu ListMenu = new Menu(MenuHandlerDonatorList, MenuAction_Display);
	char DonatorL[256];
	while (!IsEndOfFile(donatorsfile) && ReadFileLine(donatorsfile, DonatorL, sizeof(DonatorL)))
	{
		ListMenu.AddItem("DonatorList", DonatorL);
	}
	
	CloseHandle(donatorsfile);
	
	ListMenu.SetTitle("Donators List:");
	ListMenu.Pagination = 7;
	ListMenu.ExitBackButton = true;
	ListMenu.Display(client, MENU_TIME_FOREVER);
	return true;

}

//Donator MenuHandler
public int MenuHandlerDonators(Menu DMenu, MenuAction action, int client, int param2)
{
	switch(action){
		
		case MenuAction_Select:
		{	
			char item[32];
			DMenu.GetItem(param2, item, sizeof(item));
			
			if (StrEqual(item, "Donators")) 
			{
			
				DonatorList(client);
			
			}
		}
		case MenuAction_End:
		{
			delete DMenu;
		}
	}
}

//DonatorList MenuHandler
public int MenuHandlerDonatorList(Menu ListMenu, MenuAction action, int client, int param2)
{
	switch(action){
		
		case MenuAction_Select:
		{	
			char item[32];
			ListMenu.GetItem(param2, item, sizeof(item));
			
		}
		case MenuAction_End:
		{
			delete ListMenu;
		}
	}
}