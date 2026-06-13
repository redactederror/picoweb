-- script.lua

snake = {}
food = {}

dir_x = 1
dir_y = 0

move_timer = 0
move_delay = 0.12

game_over = false

--------------------------------------------------
-- FOOD
--------------------------------------------------

function spawn_food()

    food.x = flr(rnd(50)) + 5
    food.y = flr(rnd(25)) + 15

end

--------------------------------------------------
-- SITE INIT
--------------------------------------------------

function _init_site()

    snake = {
        {x=30,y=30},
        {x=29,y=30},
        {x=28,y=30}
    }

    dir_x = 1
    dir_y = 0

    move_timer = 0

    game_over = false

    spawn_food()

end

--------------------------------------------------
-- INPUT
--------------------------------------------------

function handle_input()

    if btnp(0) and dir_x ~= 1 then
        dir_x = -1
        dir_y = 0
    end

    if btnp(1) and dir_x ~= -1 then
        dir_x = 1
        dir_y = 0
    end

    if btnp(2) and dir_y ~= 1 then
        dir_x = 0
        dir_y = -1
    end

    if btnp(3) and dir_y ~= -1 then
        dir_x = 0
        dir_y = 1
    end

end

--------------------------------------------------
-- MOVE SNAKE
--------------------------------------------------

function move_snake()

    local head = snake[1]

    local nx = head.x + dir_x
    local ny = head.y + dir_y

    -- walls

    if nx < 0 or nx > 63
    or ny < 12 or ny > 63 then

        game_over = true
        return

    end

    -- self collision

    for seg in all(snake) do

        if seg.x == nx
        and seg.y == ny then

            game_over = true
            return

        end

    end

    add(
        snake,
        {
            x=nx,
            y=ny
        },
        1
    )

    -- food

    if nx == food.x
    and ny == food.y then

        spawn_food()

    else

        deli(
            snake,
            #snake
        )

    end

end

--------------------------------------------------
-- SITE UPDATE
--------------------------------------------------

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

--------------------------------------------------
-- SITE DRAW
--------------------------------------------------

function _draw_site()

    cls(1)

    print(
        "PicoSnake",
        2,
        2,
        11
    )

    print(
        "Length: "..#snake,
        2,
        9,
        7
    )

    -- food

    pset(
        food.x,
        food.y,
        8
    )

    -- snake

    for seg in all(snake) do

        pset(
            seg.x,
            seg.y,
            11
        )

    end

    if game_over then

        print(
            "GAME OVER",
            20,
            30,
            8
        )

        print(
            "PRESS X",
            20,
            40,
            7
        )

    end

end
