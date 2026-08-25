snake={}
food={}
dir=1
nextdir=1
timer=0

cell=8
cols=50
rows=21
speed=0.08

dx={0,1,0,-1}
dy={-1,0,1,0}

function spawn_food()

    repeat
        food={
            x=flr(rnd(cols)),
            y=flr(rnd(rows))
        }

        valid=true

        for part in all(snake) do
            if part.x==food.x and part.y==food.y then
                valid=false
            end
        end
    until valid

end

function reset()

    snake={
        {x=26,y=10},
        {x=25,y=10},
        {x=24,y=10},
        {x=23,y=10}
    }

    dir=1
    nextdir=1
    timer=0

    spawn_food()

end

function hit(head)

    if head.x<0
    or head.x>=cols
    or head.y<0
    or head.y>=rows then
        return true
    end

    for part in all(snake) do
        if head.x==part.x and head.y==part.y then
            return true
        end
    end

    return false

end

function move()

    dir=nextdir

    local head=snake[1]

    local new={
        x=head.x+dx[dir+1],
        y=head.y+dy[dir+1]
    }

    if hit(new) then
        reset()
        return
    end

    add(snake,new,1)

    if new.x==food.x
    and new.y==food.y then

        spawn_food()

    else

        deli(snake,#snake)

    end

end

function _init_site()

    reset()

end

function _update_site()

    if btnp(0) and dir~=1 then
        nextdir=3
    elseif btnp(1) and dir~=3 then
        nextdir=1
    elseif btnp(2) and dir~=2 then
        nextdir=0
    elseif btnp(3) and dir~=0 then
        nextdir=2
    end

    timer+=1/60

    if timer>=speed then
        timer-=speed
        move()
    end

end

function _draw_site()

    cls(0)

    local fx=food.x*cell
    local fy=food.y*cell

    rectfill(
        fx+1,
        fy+1,
        fx+6,
        fy+6,
        8
    )

    for i=#snake,1,-1 do

        local part=snake[i]

        local x=part.x*cell
        local y=part.y*cell

        rectfill(
            x+1,
            y+1,
            x+6,
            y+6,
            11
        )

        rect(
            x+1,
            y+1,
            x+6,
            y+6,
            3
        )

        if i==1 then

            if dir==0 then
                pset(x+2,y+2,7)
                pset(x+5,y+2,7)
            elseif dir==1 then
                pset(x+5,y+2,7)
                pset(x+5,y+5,7)
            elseif dir==2 then
                pset(x+2,y+5,7)
                pset(x+5,y+5,7)
            else
                pset(x+2,y+2,7)
                pset(x+2,y+5,7)
            end

        end

    end

end
