local snake = {}
local food = {}

local direction = 1
local next_direction = 1

local timer = 0
local speed = 0.09

local cell = 8
local cols = 50
local rows = 21

local alive = true
local restart_timer = 0

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

                break

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

end

local function move_snake()

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
        new_head
    )

    if new_head.x == food.x
    and new_head.y == food.y then

        place_food()

    else

        deli(
            snake,
            1
        )

    end

end

function _init_site()

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

local function draw_food(x,y)

    rectfill(
        x + 2,
        y,
        x + 5,
        y + 1,
        8
    )

    rectfill(
        x + 1,
        y + 2,
        x + 6,
        y + 5,
        8
    )

    rectfill(
        x + 2,
        y + 6,
        x + 5,
        y + 7,
        8
    )

    pset(x + 3,y + 3,10)
    pset(x + 4,y + 3,10)

end

local function draw_head(x,y)

    rectfill(
        x + 1,
        y + 1,
        x + 6,
        y + 6,
        11
    )

    rect(
        x + 1,
        y + 1,
        x + 6,
        y + 6,
        3
    )

    pset(x + 2,y + 2,7)
    pset(x + 5,y + 2,7)

end

local function draw_body(x,y)

    rectfill(
        x + 1,
        y + 1,
        x + 6,
        y + 6,
        11
    )

    rect(
        x + 1,
        y + 1,
        x + 6,
        y + 6,
        3
    )

end

function _draw_site()

    cls(0)

    local food_x = food.x * cell
    local food_y = food.y * cell

    draw_food(
        food_x,
        food_y
    )

    for i = #snake,2,-1 do

        local part = snake[i]

        draw_body(
            part.x * cell,
            part.y * cell
        )

    end

    if snake[1] then

        draw_head(
            snake[1].x * cell,
            snake[1].y * cell
        )

    end

end
