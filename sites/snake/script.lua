local snake = {}
local food = {}

local direction = 1
local next_direction = 1

local timer = 0
local speed = 0.09

local board_x = 8
local board_y = 36
local board_w = 384
local board_h = 156

local cell = 8
local cols = flr(board_w / cell)
local rows = flr(board_h / cell)

local alive = true
local restart_timer = 0

local function make_sprites()

    for y = 0,7 do
        for x = 0,7 do
            sset(0 * 8 + x,16 * 8 + y,0)
            sset(1 * 8 + x,16 * 8 + y,0)
            sset(2 * 8 + x,16 * 8 + y,0)
        end
    end

    for y = 1,6 do
        for x = 1,6 do
            sset(x,128 + y,11)
        end
    end

    for y = 2,5 do
        for x = 2,5 do
            sset(x,128 + y,12)
        end
    end

    sset(1,129,7)
    sset(6,129,7)

    for y = 1,6 do
        for x = 1,6 do
            sset(8 + x,128 + y,11)
        end
    end

    for y = 2,5 do
        for x = 2,5 do
            sset(8 + x,128 + y,3)
        end
    end

    for y = 1,6 do
        for x = 1,6 do
            sset(16 + x,128 + y,8)
        end
    end

    for y = 2,5 do
        for x = 2,5 do
            sset(16 + x,128 + y,9)
        end
    end

    sset(18,130,10)
    sset(21,130,10)
    sset(19,129,10)
    sset(20,129,10)
    sset(19,132,10)
    sset(20,132,10)

end

local function opposite(a,b)

    if a == 0 and b == 2 then
        return true
    end

    if a == 2 and b == 0 then
        return true
    end

    if a == 1 and b == 3 then
        return true
    end

    if a == 3 and b == 1 then
        return true
    end

    return false

end

local function place_food()

    local valid = false

    while not valid do

        food.x = flr(rnd(cols))
        food.y = flr(rnd(rows))

        valid = true

        for part in all(snake) do

            if part.x == food.x
            and part.y == food.y then

                valid = false

            end

        end

    end

end

local function reset_game()

    snake = {}

    local start_x = flr(cols / 2)
    local start_y = flr(rows / 2)

    add(
        snake,
        {
            x = start_x,
            y = start_y
        }
    )

    add(
        snake,
        {
            x = start_x - 1,
            y = start_y
        }
    )

    add(
        snake,
        {
            x = start_x - 2,
            y = start_y
        }
    )

    direction = 1
    next_direction = 1

    timer = 0
    alive = true

    place_food()

end

local function die()

    alive = false
    restart_timer = 0.35

    sfx(1)

end

local function move_snake()

    if opposite(
        direction,
        next_direction
    ) then

        next_direction = direction

    end

    direction = next_direction

    local head = snake[1]

    local new_head = {
        x = head.x,
        y = head.y
    }

    if direction == 0 then
        new_head.y -= 1
    elseif direction == 1 then
        new_head.x += 1
    elseif direction == 2 then
        new_head.y += 1
    elseif direction == 3 then
        new_head.x -= 1
    end

    if new_head.x < 0
    or new_head.x >= cols
    or new_head.y < 0
    or new_head.y >= rows then

        die()

        return

    end

    for part in all(snake) do

        if new_head.x == part.x
        and new_head.y == part.y then

            die()

            return

        end

    end

    add(
        snake,
        new_head,
        1
    )

    if new_head.x == food.x
    and new_head.y == food.y then

        sfx(0)

        place_food()

    else

        deli(
            snake,
            #snake
        )

    end

end

function _init_site()

    make_sprites()

    reset_game()

end

function _update_site()

    if btnp(0)
    and direction ~= 1 then

        next_direction = 3

    end

    if btnp(1)
    and direction ~= 3 then

        next_direction = 1

    end

    if btnp(2)
    and direction ~= 2 then

        next_direction = 0

    end

    if btnp(3)
    and direction ~= 0 then

        next_direction = 2

    end

    if not alive then

        restart_timer -= 1 / 60

        if restart_timer <= 0 then
            reset_game()
        end

        return

    end

    timer += 1 / 60

    if timer >= speed then

        timer -= speed

        move_snake()

    end

end

function _draw_site()

    rectfill(
        0,
        28,
        399,
        199,
        0
    )

    rect(
        board_x - 1,
        board_y - 1,
        board_x + board_w,
        board_y + board_h,
        5
    )

    local food_x =
        board_x
        +
        food.x * cell

    local food_y =
        board_y
        +
        food.y * cell

    spr(
        130,
        food_x,
        food_y
    )

    for i = #snake,1,-1 do

        local part = snake[i]

        local x =
            board_x
            +
            part.x * cell

        local y =
            board_y
            +
            part.y * cell

        if i == 1 then

            spr(
                128,
                x,
                y
            )

        else

            spr(
                129,
                x,
                y
            )

        end

    end

end
