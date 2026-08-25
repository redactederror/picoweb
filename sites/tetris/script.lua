board={}
piece=nil
timer=0

cell=8
cols=10
rows=21
speed=0.35

shapes={
    {
        {1,1,1,1}
    },
    {
        {1,1},
        {1,1}
    },
    {
        {1,1,1},
        {0,1,0}
    },
    {
        {1,1,0},
        {0,1,1}
    },
    {
        {0,1,1},
        {1,1,0}
    },
    {
        {1,0,0},
        {1,1,1}
    },
    {
        {0,0,1},
        {1,1,1}
    }
}

colors={11,10,9,8,12,14,13}

function copy_shape(shape)

    local result={}

    for y=1,#shape do

        result[y]={}

        for x=1,#shape[y] do
            result[y][x]=shape[y][x]
        end

    end

    return result

end

function rotate(shape)

    local result={}
    local h=#shape
    local w=#shape[1]

    for x=1,w do

        result[x]={}

        for y=h,1,-1 do
            result[x][h-y+1]=shape[y][x]
        end

    end

    return result

end

function valid(p,nx,ny,shape)

    shape=shape or p.shape
    nx=nx or p.x
    ny=ny or p.y

    for y=1,#shape do

        for x=1,#shape[y] do

            if shape[y][x]==1 then

                local bx=nx+x-1
                local by=ny+y-1

                if bx<1
                or bx>cols
                or by>rows then
                    return false
                end

                if by>=1
                and board[by]
                and board[by][bx] then
                    return false
                end

            end

        end

    end

    return true

end

function clear_lines()

    for y=rows,1,-1 do

        local full=true

        for x=1,cols do

            if not board[y][x] then
                full=false
                break
            end

        end

        if full then

            deli(board,y)

            add(
                board,
                {},
                1
            )

            for x=1,cols do
                board[1][x]=nil
            end

            y+=1

        end

    end

end

function lock()

    for y=1,#piece.shape do

        for x=1,#piece.shape[y] do

            if piece.shape[y][x]==1 then

                local bx=piece.x+x-1
                local by=piece.y+y-1

                if by>=1
                and by<=rows then
                    board[by][bx]=piece.color
                end

            end

        end

    end

    clear_lines()
    spawn()

end

function move(dx,dy)

    if valid(
        piece,
        piece.x+dx,
        piece.y+dy
    ) then

        piece.x+=dx
        piece.y+=dy

        return true

    end

    return false

end

function spawn()

    local id=flr(rnd(#shapes))+1
    local shape=copy_shape(shapes[id])

    piece={
        shape=shape,
        color=colors[id],
        x=flr((cols-#shape[1])/2)+1,
        y=1
    }

    if not valid(piece) then
        reset()
    end

end

function reset()

    board={}

    for y=1,rows do
        board[y]={}
    end

    timer=0

    spawn()

end

function rotate_piece()

    local shape=rotate(piece.shape)

    if valid(
        piece,
        piece.x,
        piece.y,
        shape
    ) then

        piece.shape=shape

    elseif valid(
        piece,
        piece.x-1,
        piece.y,
        shape
    ) then

        piece.x-=1
        piece.shape=shape

    elseif valid(
        piece,
        piece.x+1,
        piece.y,
        shape
    ) then

        piece.x+=1
        piece.shape=shape

    end

end

function _init_site()

    reset()

end

function _update_site()

    if btnp(0) then
        move(-1,0)
    end

    if btnp(1) then
        move(1,0)
    end

    if btnp(2) then
        rotate_piece()
    end

    if btnp(3) then

        if not move(0,1) then
            lock()
        end

    end

    timer+=1/60

    if timer>=speed then

        timer-=speed

        if not move(0,1) then
            lock()
        end

    end

end

function block(x,y,color)

    x*=cell
    y*=cell

    rectfill(
        x+1,
        y+1,
        x+6,
        y+6,
        color
    )

    rect(
        x+1,
        y+1,
        x+6,
        y+6,
        color
    )

end

function _draw_site()

    cls(0)

    local ox=flr((400-cols*cell)/2)
    local oy=2

    for y=1,rows do

        for x=1,cols do

            if board[y][x] then

                local px=ox+(x-1)*cell
                local py=oy+(y-1)*cell

                rectfill(
                    px+1,
                    py+1,
                    px+6,
                    py+6,
                    board[y][x]
                )

            end

        end

    end

    for y=1,#piece.shape do

        for x=1,#piece.shape[y] do

            if piece.shape[y][x]==1 then

                local px=
                    ox
                    +
                    (piece.x+x-2)*cell

                local py=
                    oy
                    +
                    (piece.y+y-2)*cell

                rectfill(
                    px+1,
                    py+1,
                    px+6,
                    py+6,
                    piece.color
                )

            end

        end

    end

end
