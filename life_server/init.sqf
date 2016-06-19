/*
	Connect to the sql with the ini
	- Panda

*/

#include "script_macros.hpp"

if (isNil {uiNamespace getVariable "life_sql_id"}) then 
{
	_result = "extDB3" callExtension "9:VERSION";
	
	diag_log format ["extDB3: Version: %1", _result];
	if(_result == "") exitWith {systemChat "extDB3: Failed to Load"; false};

	_result = call compile ("extDB3" callExtension format["9:ADD_DATABASE:AltisLife"]);
	if (_result select 0 isEqualTo 0) exitWith {systemChat format ["extDB3: Error Database: %1", _result]; false};
	systemChat "extDB3: Connected to Database";

	life_sql_id = round(random(9999));
    CONSTVAR(life_sql_id);
	
	_result = call compile ("extDB3" callExtension format["9:ADD_DATABASE_PROTOCOL:AltisLife:SQL_CUSTOM:%1:altis-life-custom.ini",(call life_sql_id)]);
	if ((_result select 0) isEqualTo 0) exitWith {systemChat format ["extDB3: Error Database Setup: %1", _result]; false};

	systemChat format ["extDB3: Initalized Protocol"];

	"extDB3" callExtension "9:LOCK";
	systemChat "extDB3: Locked";
    uiNamespace setVariable ["life_sql_id",life_sql_id];
} 
else 
{
    life_sql_id = uiNamespace getVariable "life_sql_id";
    CONSTVAR(life_sql_id);
    diag_log "extDB2: Still Connected to Database";
};

_query = format["playerInsert:%1:%2:%3:%4:%5:%6:%7:%8:9:%10:%11",60,"Yo",78,34,[],[],[],[],[],[],[]];
[_query,1] call compile preprocessFileLineNumbers "\life_server\asyncCall.sqf";