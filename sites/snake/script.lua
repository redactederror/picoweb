-- script.lua

tile_size = 8
playfield_y = 24

snake = {}
food = {}

dir_x = 1
dir_y = 0

next_dir_x = 1
next_dir_y = 0

move_timer = 0
move_delay = 0.15

score = 0
game_over = false

grid_w = 38
grid_h = 20

function snake_contains(x,y)
    for s in all(snake) do
        if s.x == x and s.y == y then
            return true
        end
    end
    return false
end

function spawn_food()
    repeat
        food.x = flr(rnd(grid_w))
        food.y = flr(rnd(grid_h))
    until not snake_contains(food.x,food.y)
end

function _init_site()

    local cx = flr(grid_w/2)
    local cy = flr(grid_h/2)

    snake = {
        {x=cx,y=cy},
        {x=cx-1,y=cy},
        {x=cx-2,y=cy}
    }

    dir_x = 1
    dir_y = 0

    next_dir_x = 1
    next_dir_y = 0

    move_timer = 0
    move_delay = 0.15

    score = 0
    game_over = false

    spawn_food()
end

function handle_input()

    if btnp(0) and dir_x ~= 1 then
        next_dir_x = -1
        next_dir_y = 0

    elseif btnp(1) and dir_x ~= -1 then
        next_dir_x = 1
        next_dir_y = 0

    elseif btnp(2) and dir_y ~= 1 then
        next_dir_x = 0
        next_dir_y = -1

    elseif btnp(3) and dir_y ~= -1 then
        next_dir_x = 0
        next_dir_y = 1
    end
end

function move_snake()

    dir_x = next_dir_x
    dir_y = next_dir_y

    local head = snake[1]

    local nx = head.x + dir_x
    local ny = head.y + dir_y

    if nx < 0 or nx >= grid_w
    or ny < 0 or ny >= grid_h then
        game_over = true
        return
    end

    for seg in all(snake) do
        if seg.x == nx and seg.y == ny then
            game_over = true
            return
        end
    end

    add(snake,{x=nx,y=ny},1)

    if nx == food.x and ny == food.y then
        score += 1
        spawn_food()
        move_delay = max(0.05,move_delay-0.005)
    else
        deli(snake,#snake)
    end
end

function _update_site()

    if game_over then
        if btnp(4) then
            _init_site()
        end
        return
    end

    handle_input()

    move_timer += 1/60

    if move_timer >= move_delay then
        move_timer = 0
        move_snake()
    end
end

function draw_tile(gx,gy,col)

    local px = gx * tile_size
    local py = playfield_y + gy * tile_size

    rectfill(
        px,
        py,
        px+tile_size-1,
        py+tile_size-1,
        col
    )
end

function _draw_site()

    cls(1)

    print("PicoSnake",4,4,11)
    print("Score: "..score,90,4,7)

    print("Click the address bar above",320,20,10)
    print("to visit other PicoWeb sites.",320,32,7)
    print("This page is a playable",320,56,6)
    print("PicoWeb website demo.",320,68,6)

    draw_tile(food.x,food.y,8)

    for i=1,#snake do
        local seg = snake[i]

        if i == 1 then
            draw_tile(seg.x,seg.y,11)
        else
            draw_tile(seg.x,seg.y,10)
        end
    end

    if game_over then

        rectfill(120,70,280,120,0)
        rect(120,70,280,120,8)

        print("GAME OVER",165,85,8)
        print("PRESS X TO RESTART",130,100,7)
    end
end

_init_site()
