/*
object_showPlotRadius.sqf
Modfied by Piggd
Email: dayzpiggd@gmail.com
Website: http://dayzpiggd.enjin.com
Donations Accepted via paypal to danpigg@yahoo.com

Part or standard Epoch ver 1.5.0.1
Build preview adopted from Axe Cop (@vos) Base Destruction Script
*/

private ["_location","_object","_objects","_i","_dir","_BD_center","_BD_radius","_nearPlotPole","_getPlotPoles","_distance","_preview","_playerPos","_cnt"];

// Place in Variable file to effect behavior
//PDZE_PlotPreviewTimmer = 120;
//PDZE_ShowPlotPreviewCountDown = true;
_objects = [];
_BD_radius = DZE_PlotPole select 0;
_getPlotPoles = [];
_getPlotPoles = nearestObjects [(vehicle player), ["Plastic_Pole_EP1_DZ"], _BD_radius];
if (isNil "PDZE_PlotPreviewTimmer" ) then {PDZE_PlotPreviewTimmer=120;};
if (isNil "PDZE_ShowPlotPreviewCountDown" ) then {PDZE_ShowPlotPreviewCountDown=false;};
if (count(_getPlotPoles) < 1) then {
	_object = createVehicle ["Plastic_Pole_EP1", (getPosATL (vehicle player)), [], 0, "CAN_COLLIDE"];
 	sleep 0.1;
	_objects set [(count _objects),_object];
	_nearPlotPole = nearestObject [player, "Plastic_Pole_EP1"];
} else {
	_nearPlotPole = nearestObject [player, "Plastic_Pole_EP1_DZ"];
};

_BD_center = [_nearPlotPole] call FNC_getPos;
 
// circle
for "_i" from 0 to 360 step (270 / _BD_radius) do {
	_location = [(_BD_center select 0) + ((cos _i) * _BD_radius), (_BD_center select 1) + ((sin _i) * _BD_radius), _BD_center select 2];
	_object = createVehicle ["Plastic_Pole_EP1", _location, [], 0, "CAN_COLLIDE"];
	_object setpos _location;
	_objects set [(count _objects),_object];
};
_preview = true;
cutText [format["Show Plot Radius for %1 seconds",PDZE_PlotPreviewTimmer], "PLAIN DOWN"];

sleep 2;
_distance = (DZE_PlotPole select 0) + 10;
cutText [format["Show Plot Radius will end if you move > %1 meters away from plot pole",_distance], "PLAIN DOWN"];
// Amount of seconds in preview
_cnt = PDZE_PlotPreviewTimmer;
while {_preview} do 
{
	_playerPos = getPosATL (vehicle player);
	if ((_playerPos distance _BD_center) > _distance) then {
		_preview = false;
		cutText [format["%1 moved  > %2 meters away from plot pole",dayz_playerName,_distance], "PLAIN DOWN"];
	};
	_cnt = _cnt - 1;
// Coounts Every Second down and displays it.
	if (PDZE_ShowPlotPreviewCountDown && _preview ) then {
		if (_cnt <= PDZE_PlotPreviewTimmer) then {
			cutText [format["Show Plot Radius will end in %1 seconds",(_cnt)], "PLAIN DOWN",1];
		};	
	};
// 60 Second Warning if not conting down all seconds
	if (_cnt <= 0) then {
		_preview = false;
		cutText ["Show Plot Radius has Ended!", "PLAIN DOWN"];
	};
	sleep 1;
};
{
	deleteVehicle _x;
} count _objects;
