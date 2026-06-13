-- script.lua

--------------------------------------------------
-- CONFIG
--------------------------------------------------

tile_size = 8

-- leave room for PicoWeb address bar
playfield_y = 24

playfield_w = 500
playfield_h = 200

grid_w = flr(playfield_w / tile_size)
grid_h = flr((playfield_h - playfield_y) / tile_size)

--------------------------------------------------
-- GAME STATE
--------------------------------------------------

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

--------------------------------------------------
-- HELPERS
--------------------------------------------------

function snake_contains(x,y)

    for s in all(snake) do

        if s.x == x and s.y == y then
            return true
        end

    end

    return false

end

--------------------------------------------------
-- FOOD
--------------------------------------------------

function spawn_food()

    repeat

        food.x =
            flr(rnd(grid_w))

        food.y =
            flr(rnd(grid_h))

    until not snake_contains(
        food.x,
        food.y
    )

end

--------------------------------------------------
-- INIT
--------------------------------------------------

function _init_site()

    local cx =
        flr(grid_w / 2)

    local cy =
        flr(grid_h / 2)

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

    score = 0

    game_over = false

    spawn_food()

end

--------------------------------------------------
-- INPUT
--------------------------------------------------

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

--------------------------------------------------
-- MOVE
--------------------------------------------------

function move_snake()

    dir_x = next_dir_x
    dir_y = next_dir_y

    local head = snake[1]

    local nx =
        head.x + dir_x

    local ny =
        head.y + dir_y

    --------------------------------------------------
    -- WALLS
    --------------------------------------------------

    if nx < 0
    or nx >= grid_w
    or ny < 0
    or ny >= grid_h then

        game_over = true
        return

    end

    --------------------------------------------------
    -- SELF COLLISION
    --------------------------------------------------

    for seg in all(snake) do

        if seg.x == nx
        and seg.y == ny then

            game_over = true
            return

        end

    end

    --------------------------------------------------
    -- ADD NEW HEAD
    --------------------------------------------------

    add(
        snake,
        {
            x = nx,
            y = ny
        },
        1
    )

    --------------------------------------------------
    -- FOOD
    --------------------------------------------------

    if nx == food.x
    and ny == food.y then

        score += 1

        spawn_food()

        -- tiny speed increase
        move_delay =
            max(
                0.05,
                move_delay - 0.005
            )

    else

        deli(
            snake,
            #snake
        )

    end

end

--------------------------------------------------
-- UPDATE
--------------------------------------------------

function _update_site()

    if game_over then

        if btnp(4) then

            move_delay = 0.15

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

--------------------------------------------------
-- DRAW TILE
--------------------------------------------------

function draw_tile(
    gx,
    gy,
    col
)

    local px =
        gx * tile_size

    local py =
        playfield_y +
        gy * tile_size

    rectfill(
        px,
        py,
        px + tile_size - 1,
        py + tile_size - 1,
        col
    )

end

--------------------------------------------------
-- DRAW
--------------------------------------------------

function _draw_site()

    cls(1)

    --------------------------------------------------
    -- UI
    --------------------------------------------------

    print(
        "PicoSnake",
        4,
        playfield_y,
        11
    )

    print(
        "Score: "..score,
        90,
        playfield_y,
        7
    )
    --------------------------------------------------
-- WELCOME PANEL
--------------------------------------------------

print(
    "Welcome to PicoWeb",
    320,
    30,
    11
)

print(
    "Type a website",
    320,
    50,
    7
)

print(
    "into the address",
    320,
    60,
    7
)

print(
    "bar above to",
    320,
    70,
    7
)

print(
    "begin browsing.",
    320,
    80,
    7
)

print(
    "This Snake game",
    320,
    110,
    6
)

print(
    "is hosted as a",
    320,
    120,
    6
)

print(
    "PicoWeb website.",
    320,
    130,
    6
)

    --------------------------------------------------
    -- FOOD
    --------------------------------------------------

    draw_tile(
        food.x,
        food.y,
        8
    )

    --------------------------------------------------
    -- SNAKE
    --------------------------------------------------

    for i=1,#snake do

        local seg =
            snake[i]

        if i == 1 then

            draw_tile(
                seg.x,
                seg.y,
                11
            )

        else

            draw_tile(
                seg.x,
                seg.y,
                10
            )

        end

    end

    --------------------------------------------------
    -- GAME OVER
    --------------------------------------------------

    if game_over then

        rectfill(
            120,
            70,
            370,
            120,
            0
        )

        rect(
            120,
            70,
            370,
            120,
            8
        )

        print(
            "GAME OVER",
            200,
            85,
            8
        )

        print(
            "PRESS X TO RESTART",
            170,
            100,
            7
        )

    end

end

--------------------------------------------------
-- START
--------------------------------------------------

_init_site()
