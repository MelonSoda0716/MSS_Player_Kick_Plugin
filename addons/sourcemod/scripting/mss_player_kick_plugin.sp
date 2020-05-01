#include <sourcemod>

public Plugin:myinfo = 
{
	name = "MSS Player Kick Plugin",
	author = "MelonSoda",
	description = "MSS Player Kick Plugin",
	version = "1.0.0",
	url = "www.melonsoda.tokyo"
}

public OnPluginStart(){

	/* mss_kick の部分を変更すれば好きなコマンドでメニューが出せるよ */
	RegConsoleCmd("mss_kick" , Command_mss_kick);
	
}

/*Exception reported 回避用 */
stock bool IsValidClient(int client){
  return client > 0 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client);
}

/* Console Command mss_kick */
public Action Command_mss_kick(int client, int args){
	
	PlayerKickMenu(client);
	return Plugin_Handled;
	
}

/* Console Command mss_kick Menu*/
public PlayerKickMenu(int client){

	Menu menu = new Menu(PlayerKickMenuHandler);
	
	new String:name[128], String:playernumber[4];

	for(int i = 1; i <= MaxClients ; i++){
		/* プレイヤーが有効か */
		if(IsClientInGame(i) && GetClientTeam(i) >= 1){
			/* プレイヤーの名前取得 */
			GetClientName(i, name, sizeof(name));
			/* プレイヤーの番号をintからStringに変換 */
			IntToString(i, playernumber, sizeof(playernumber));
			menu.AddItem(playernumber, name);
		}
	}
	
	menu.SetTitle("Player Kick Menu:");
	menu.ExitButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
	
}

/* Console Command mss_kick follow*/
public PlayerKickMenuHandler(Menu menu, MenuAction action, int param1, int param2){

	if(action == MenuAction_Select){

		char arg[16];
		menu.GetItem(param2, arg, sizeof(arg));
		/* プレイヤーの番号をStringからintに変換 */
		int player_num = StringToInt(arg);

		new String:kicker[128], String:target[128], String:authid[32];

		/* プレイヤーが有効ならば */
		if(IsClientInGame(player_num)){

			GetClientName(param1, kicker, sizeof(kicker));
			GetClientName(player_num, target, sizeof(target));
			GetClientAuthId(param1, AuthId_Steam2, authid, sizeof(authid));
			
			LogToGame("[MSS] %s <%s - Kick>",kicker, authid);
			KickClient(player_num,"%s によりサーバからキックされました",kicker);

		}
		else{
			PrintToChat(param1,"\07 [MSS] キックに失敗しました。");
		}

	}
}