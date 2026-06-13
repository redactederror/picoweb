local links = {
    {
        title = "Snake Demo",
        url = "pww.snake"
    },
    {
        title = "About PicoWeb",
        url = "pww.about"
    }
}

function _draw_site()

    print("PicoWeb", 10, 20, 7)
    print("A web for Picotron.", 10, 32, 6)

    print("Featured Sites:", 10, 55, 11)

    for i,link in ipairs(links) do
        print(
            i .. ". " .. link.title,
            20,
            55 + i * 12,
            7
        )
    end

    print(
        "Click address bar above",
        220,
        20,
        10
    )

    print(
        "and type a PWW address.",
        220,
        32,
        10
    )
end
