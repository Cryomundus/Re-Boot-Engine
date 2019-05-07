///scr_DrawHUD_Alt

var vX = camera_get_view_x(view_camera[0]),
	vY = camera_get_view_y(view_camera[0]);

var col = c_black, alpha = 0.4;

var selecting = (cHSelect && !global.roomTrans && !obj_PauseMenu.pause);

if(global.hudDisplay || selecting)
{

    var itemNum = (global.item[0]+global.item[1]+global.item[2]+global.item[3]+global.item[4]);
    
    if(selecting)
    {
        draw_set_color(c_black);
        draw_set_alpha(0.5);
        draw_rectangle(vX,vY,vX+global.resWidth,vY+global.resHeight,false);
        draw_set_alpha(0.75);
        draw_rectangle(vX,vY,vX+global.resWidth,vY+48,false);
        draw_set_alpha(1);
    }
    
    draw_set_color(col);
    draw_set_alpha(alpha);
    
    var xx = 52,
        yy = 0,
        ww = 26,
        hh = 18;
    draw_roundrect_ext(vX+xx,vY+yy,vX+ww+xx,vY+hh+yy,8,8,false);
    
    if(itemNum > 0)
    {
        var xx = 80,
            yy = 0,
            ww = 26,
            hh = 18;
        draw_roundrect_ext(vX+xx,vY+yy,vX+ww+xx,vY+hh+yy,8,8,false);
    }
    
    if(global.item[0])
    {
        var xx = 108,
            yy = 2,
            ww = 38,
            hh = 10;
        draw_roundrect_ext(vX+xx,vY+yy,vX+ww+xx,vY+hh+yy,4,4,false);
    }
    if(global.item[1])
    {
        var xx = 148,
            yy = 2,
            ww = 32,
            hh = 10;
        draw_roundrect_ext(vX+xx,vY+yy,vX+ww+xx,vY+hh+yy,4,4,false);
    }
    if(global.item[2])
    {
        var xx = 182,
            yy = 2,
            ww = 26,
            hh = 10;
        draw_roundrect_ext(vX+xx,vY+yy,vX+ww+xx,vY+hh+yy,4,4,false);
    }
    draw_set_color(c_white);
    draw_set_alpha(1);
    
    draw_sprite_ext(sprt_HWepSlot,(itemSelected == 0),floor(vX+66),floor(vY+10),1,1,0,c_white,1);
    draw_sprite_ext(sprt_HBeamIcon,beamIconIndex,floor(vX+66),floor(vY+10),1,1,0,c_white,1);
    
    if(itemNum > 0)
    {
        draw_sprite_ext(sprt_HWepSlot,(itemSelected == 1),floor(vX+94),floor(vY+10),1,1,0,c_white,1);
        var iconIndex = itemHighlighted[1];
        if(stateFrame == State.Morph && item[2])
        {
            iconIndex = 2;
        }
        draw_sprite_ext(sprt_HItemIcon,iconIndex,floor(vX+94),floor(vY+10),1,1,0,c_white,1);
    }
    
    if(selecting)
    {
        draw_set_color(c_white);
        draw_set_font(MenuFont);
        var tX = 0,
            tY = 21;
        if(itemSelected == 0)
        {
            strg = beamName[itemHighlighted[0]];
            tX = scr_round(95 - (string_width(strg) / 2));
            draw_text_transformed(vX+tX,vY+tY,beamName[itemHighlighted[0]],1,1,0);
            
            var xBPos = 94 + hudBOffsetX,
                xBOffset = 28,
                yBPos = 38;
            for(i = 0; i < 5; i += 1)
            {
                var j = i;
                if(global.beam[j] || i == 0)
                {
                    comboNum = 10*(beam[j] && i != 0);
                    if(i == itemHighlighted[0])
                    {
                        draw_sprite_ext(sprt_HItemBeam,i+5+(5*(beam[j] && i != 0)),vX+xBPos,vY+yBPos,1,1,0,c_white,1);
                    }
                    if(i == scr_wrap(itemHighlighted[0]-1, 0, 4))
                    {
                        draw_sprite_ext(sprt_HItemBeam,i+comboNum,vX+(xBPos-xBOffset),vY+yBPos,1,1,0,c_white,1);
                    }
                    if(i == scr_wrap(itemHighlighted[0]-2, 0, 4))
                    {
                        var a = 1;
                        if(hudBOffsetX < 0)
                        {
                            a = clamp(1-(abs(hudBOffsetX)/xBOffset),0,1);
                        }
                        draw_sprite_ext(sprt_HItemBeam,i+comboNum,vX+(xBPos-xBOffset*2),vY+yBPos,1,1,0,c_white,a);
                    }
                    if(i == scr_wrap(itemHighlighted[0]-3, 0, 4) && hudBOffsetX > 0)
                    {
                        var a = clamp(abs(hudBOffsetX)/xBOffset,0,1);
                        draw_sprite_ext(sprt_HItemBeam,i+comboNum,vX+(xBPos-xBOffset*3),vY+yBPos,1,1,0,c_white,a);
                    }
                    if(i == scr_wrap(itemHighlighted[0]+1, 0, 4))
                    {
                        draw_sprite_ext(sprt_HItemBeam,i+comboNum,vX+(xBPos+xBOffset),vY+yBPos,1,1,0,c_white,1);
                    }
                    if(i == scr_wrap(itemHighlighted[0]+2, 0, 4))
                    {
                        var a = 1;
                        if(hudBOffsetX > 0)
                        {
                            a = clamp(1-(abs(hudBOffsetX)/xBOffset),0,1);
                        }
                        draw_sprite_ext(sprt_HItemBeam,i+comboNum,vX+(xBPos+xBOffset*2),vY+yBPos,1,1,0,c_white,a);
                    }
                    if(i == scr_wrap(itemHighlighted[0]+3, 0, 4) && hudBOffsetX < 0)
                    {
                        var a = clamp(abs(hudBOffsetX)/xBOffset,0,1);
                        draw_sprite_ext(sprt_HItemBeam,i+comboNum,vX+(xBPos+xBOffset*3),vY+yBPos,1,1,0,c_white,a);
                    }
                }
            }
            if(hudBOffsetX > 0)
            {
                hudBOffsetX = max(hudBOffsetX - (3.5 + (abs(hudBOffsetX) > 28)),0);
            }
            if(hudBOffsetX < 0)
            {
                hudBOffsetX = min(hudBOffsetX + (3.5 + (abs(hudBOffsetX) > 28)),0);
            }
            hudIOffsetX = 0;
        }
        if(itemSelected == 1)
        {
            strg = itemName[itemHighlighted[1]];
            tX = scr_round(95 - (string_width(strg) / 2));
            draw_text_transformed(vX+tX,vY+tY,itemName[itemHighlighted[1]],1,1,0);
            
            var xIPos = 94 + hudIOffsetX,
                xIOffset = 28,
                yIPos = 38;
            for(i = 0; i < 5; i += 1)
            {
                if(global.item[i])
                {
                    if(i == itemHighlighted[1])
                    {
                        draw_sprite_ext(sprt_HItemMisc,i+5,vX+xIPos,vY+yIPos,1,1,0,c_white,1);
                    }
                    if(i == scr_wrap(itemHighlighted[1]-1, 0, 4))
                    {
                        draw_sprite_ext(sprt_HItemMisc,i,vX+(xIPos-xIOffset),vY+yIPos,1,1,0,c_white,1);
                    }
                    if(i == scr_wrap(itemHighlighted[1]-2, 0, 4))
                    {
                        var a = 1;
                        if(hudIOffsetX < 0)
                        {
                            a = clamp(1-(abs(hudIOffsetX)/xIOffset),0,1);
                        }
                        draw_sprite_ext(sprt_HItemMisc,i,vX+(xIPos-xIOffset*2),vY+yIPos,1,1,0,c_white,a);
                    }
                    if(i == scr_wrap(itemHighlighted[1]-3, 0, 4) && hudIOffsetX > 0)
                    {
                        var a = clamp(abs(hudIOffsetX)/xIOffset,0,1);
                        draw_sprite_ext(sprt_HItemMisc,i,vX+(xIPos-xIOffset*3),vY+yIPos,1,1,0,c_white,a);
                    }
                    if(i == scr_wrap(itemHighlighted[1]+1, 0, 4))
                    {
                        draw_sprite_ext(sprt_HItemMisc,i,vX+(xIPos+xIOffset),vY+yIPos,1,1,0,c_white,1);
                    }
                    if(i == scr_wrap(itemHighlighted[1]+2, 0, 4))
                    {
                        var a = 1;
                        if(hudIOffsetX > 0)
                        {
                            a = clamp(1-(abs(hudIOffsetX)/xIOffset),0,1);
                        }
                        draw_sprite_ext(sprt_HItemMisc,i,vX+(xIPos+xIOffset*2),vY+yIPos,1,1,0,c_white,a);
                    }
                    if(i == scr_wrap(itemHighlighted[1]+3, 0, 4) && hudIOffsetX < 0)
                    {
                        var a = clamp(abs(hudIOffsetX)/xIOffset,0,1);
                        draw_sprite_ext(sprt_HItemMisc,i,vX+(xIPos+xIOffset*3),vY+yIPos,1,1,0,c_white,a);
                    }
                }
            }
            hudBOffsetX = 0;
            if(hudIOffsetX > 0)
            {
                hudIOffsetX = max(hudIOffsetX - (3.5 + (abs(hudBOffsetX) > 28)),0);
            }
            if(hudIOffsetX < 0)
            {
                hudIOffsetX = min(hudIOffsetX + (3.5 + (abs(hudBOffsetX) > 28)),0);
            }
        }
    }
    else
    {
        hudBOffsetX = 0;
        hudIOffsetX = 0;
    }
    
    if(global.item[0])
    {
        draw_sprite_ext(sprt_HAmmoIcon,(itemSelected == 1 && itemHighlighted[1] == 0 && stateFrame != State.Morph),floor(vX+110),floor(vY+4),1,1,0,c_white,1);
    
        draw_sprite_ext(sprt_HNumFont2,missileStat,floor(vX+137),floor(vY+5),1,1,0,c_white,1);
        var missileNum = floor(missileStat/10);
        draw_sprite_ext(sprt_HNumFont2,missileNum,floor(vX+131),floor(vY+5),1,1,0,c_white,1);
        var missileNum2 = floor(missileStat/100);
        draw_sprite_ext(sprt_HNumFont2,missileNum2,floor(vX+125),floor(vY+5),1,1,0,c_white,1);
    }
    if(global.item[1])
    {
        draw_sprite_ext(sprt_HAmmoIcon,2+(itemSelected == 1 && itemHighlighted[1] == 1 && stateFrame != State.Morph),floor(vX+150),floor(vY+4),1,1,0,c_white,1);
    
        draw_sprite_ext(sprt_HNumFont2,superMissileStat,floor(vX+171),floor(vY+5),1,1,0,c_white,1);
        var superMissileNum = floor(superMissileStat/10);
        draw_sprite_ext(sprt_HNumFont2,superMissileNum,floor(vX+165),floor(vY+5),1,1,0,c_white,1);
    }
    if(global.item[2])
    {
        draw_sprite_ext(sprt_HAmmoIcon,4+(itemSelected == 1 && (itemHighlighted[1] == 2 || stateFrame == State.Morph)),floor(vX+184),floor(vY+4),1,1,0,c_white,1);
    
        draw_sprite_ext(sprt_HNumFont2,powerBombStat,floor(vX+199),floor(vY+5),1,1,0,c_white,1);
        var powerBombNum = floor(powerBombStat/10);
        draw_sprite_ext(sprt_HNumFont2,powerBombNum,floor(vX+193),floor(vY+5),1,1,0,c_white,1);
    }
}