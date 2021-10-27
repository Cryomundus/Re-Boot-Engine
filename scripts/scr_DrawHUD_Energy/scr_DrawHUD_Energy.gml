///scr_DrawHUD_Energy
function scr_DrawHUD_Energy() {

	var vX = camera_get_view_x(view_camera[0]),
		vY = camera_get_view_y(view_camera[0]);

	var col = c_black, alpha = 0.4;

	var xx = vX+2,
		yy = vY+2,
		ww = 49,
		hh = 8,
		yDiff = 0;

	var energyTanks = floor(energyMax / 100);

	if(energyTanks > 0)
	{
		yDiff = 7;
		if(energyTanks > 7)
		{
			yDiff = 14;
		}
	}

	draw_set_color(col);
	draw_set_alpha(alpha);

	var x2 = xx-1,
		y2 = yy-1;

	draw_rectangle(x2,y2,x2+ww,y2+hh+yDiff,false);

	draw_set_color(c_white);
	draw_set_alpha(1);

	statEnergyTanks = floor(energy / 100);

	draw_sprite_ext(sprt_HEnergyText,0,floor(xx),floor(yy+yDiff),1,1,0,c_white,1);

	draw_sprite_ext(sprt_HNumFont1,energy,floor(xx+41),floor(yy+yDiff),1,1,0,c_white,1);
	var energyNum = floor(energy/10);
	draw_sprite_ext(sprt_HNumFont1,energyNum,floor(xx+35),floor(yy+yDiff),1,1,0,c_white,1);

	if(energyTanks > 0)
	{
		for(var i = 0; i < energyTanks; i++)
		{
			var eX = xx + (7*i),
			eY = yy;
			if(energyTanks > 7)
			{
				eY = yy+7;
			}
			if(i >= 7)
			{
				eX = xx + (7*(i-7));
				eY = yy;
			}
			draw_sprite_ext(sprt_HETank,(statEnergyTanks > i),floor(eX),floor(eY),1,1,0,c_white,1);
		}
	}
	
	if(boots[Boots.Dodge])
	{
		for(var i = 0; i < 2; i += 1)
		{
			draw_sprite_ext(sprt_DodgeMeter,0,xx+14*i,yy+22,1,1,0,c_white,1);
		
			var recharge = clamp((dodgeRecharge / (dodgeRechargeMax/2)) - i,0,1);
			var width = sprite_get_width(sprt_DodgeMeter)*recharge;
			var height = sprite_get_height(sprt_DodgeMeter);
			var imgInd = 1 + (canDodge && recharge >= 1);
			for(var j = 0; j < height; j++)
			{
				var rw = min(width-j+1,width);
				if(rw > 0)
				{
					draw_sprite_part_ext(sprt_DodgeMeter,imgInd,0,j,rw,1,xx+14*i,yy+22+j,1,1,c_white,1);
				}
			}
		}
	}
}
