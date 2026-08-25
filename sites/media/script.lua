frames={}
fps=10
video_width=480
video_height=270
current_frame=1
frame_timer=0
frame_delay=6
playing=false
current_note=nil
frames_left=0
filename=""

local function n(s,a,b)
 return tonumber(sub(s,a,b)) or 0
end

function audio_play(v,d)
 current_note=v
 frames_left=d
 note(v,0,64,0,0,0)
end

function audio_update()
 if frames_left<=0 then return end
 frames_left-=1
 if frames_left<=0 then
  note(current_note,0,0,0,0,0)
 end
end

function audio_stop()
 frames_left=0
 if current_note then
  note(current_note,0,0,0,0,0)
 end
end

function video_load(f)
 local m=fetch(f)
 if type(m)~="table" or type(m.frames)~="table" then
  return false
 end
 frames=m.frames
 fps=m.fps or 10
 video_width=m.width or 480
 video_height=m.height or 270
 if fps<1 then fps=1 end
 frame_delay=max(1,flr(60/fps))
 current_frame=1
 frame_timer=0
 playing=#frames>0
 return playing
end

function video_restart()
 current_frame=1
 frame_timer=0
 playing=#frames>0
end

function video_stop()
 playing=false
 audio_stop()
end

function video_update()
 if not playing then return end
 frame_timer+=1
 if frame_timer<frame_delay then return end
 frame_timer=0
 local f=frames[current_frame]
 if f and f.note then
  audio_play(f.note,f.duration or 1)
 end
 current_frame+=1
 if current_frame>#frames then
  playing=false
 end
end

function video_draw(px,py,pw,ph)
 clip(px,py,pw,ph)
 rectfill(px,py,px+pw-1,py+ph-1,0)

 if playing then
  local f=frames[current_frame]

  if f and f.draw then
   local sx=pw/video_width
   local sy=ph/video_height

   for _,o in ipairs(f.draw) do
    local t=tonumber(sub(o,1,1))

    if t==0 then
     local x=n(o,2,4)
     local y=n(o,5,7)
     local c=n(o,8,9)
     local w=n(o,10,12)
     local h=n(o,13,15)

     rectfill(
      px+x*sx,
      py+y*sy,
      px+(x+w)*sx,
      py+(y+h)*sy,
      c
     )

    elseif t==1 then
     print(
      sub(o,10),
      px+n(o,2,4)*sx,
      py+n(o,5,7)*sy,
      n(o,8,9)
     )

    elseif t==2 then
     line(
      px+n(o,2,4)*sx,
      py+n(o,5,7)*sy,
      px+n(o,8,10)*sx,
      py+n(o,11,13)*sy,
      n(o,14,15)
     )

    elseif t==3 then
     circfill(
      px+n(o,2,4)*sx,
      py+n(o,5,7)*sy,
      max(
       1,
       n(o,8,10)*((sx+sy)/2)
      ),
      n(o,11,12)
     )

    elseif t==4 then
     local x=n(o,2,4)
     local y=n(o,5,7)
     local w=n(o,8,10)
     local h=n(o,11,13)
     local c1=n(o,14,15)
     local c2=n(o,16,17)

     if n(o,18,18)==0 then
      for yy=0,h-1 do
       line(
        px+x*sx,
        py+(y+yy)*sy,
        px+(x+w)*sx,
        py+(y+yy)*sy,
        yy<h/2 and c1 or c2
       )
      end
     else
      for xx=0,w-1 do
       line(
        px+(x+xx)*sx,
        py+y*sy,
        px+(x+xx)*sx,
        py+(y+h)*sy,
        xx<w/2 and c1 or c2
       )
      end
     end
    end
   end
  end
 end

 clip()
end

function import_video()
 chooser(
  {
   path="/desktop",
   title="Load Video",
   intention="select_file"
  },
  function(m)
   if not m or not m.filename then return end
   filename=m.filename
   video_load(filename)
  end
 )
end

function _init_site()
end

function _update_site()
 local x,y,b=mouse()

 if (b&1)~=0
 and x>=384
 and x<400
 and y>=0
 and y<185 then
  if not import_down then
   import_video()
  end
  import_down=true
 else
  import_down=false
 end

 video_update()
 audio_update()
end

function _draw_site()
 cls(0)

 video_draw(
  0,
  0,
  384,
  185
 )

 rectfill(
  384,
  0,
  399,
  184,
  1
 )

 print(
  "+",
  389,
  88,
  7
 )
end
