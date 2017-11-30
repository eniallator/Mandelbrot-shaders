function love.load()
    zoomFactor = 240
    maxI = 200
    screenDim = {}
    screenDim.x, screenDim.y = love.graphics.getDimensions()
    offset = {
        x = 0,
        y = 0
    }
    mandelbrotShader = love.graphics.newShader[[
        extern number maxX;
        extern number maxY;
        extern number zoomFactor;
        extern number maxI;
        extern number offsetX;
        extern number offsetY;

        vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords ) {
            number x = screen_coords.x + offsetX - maxX / 2;
            number y = screen_coords.y + offsetY - maxY / 2;

            number a = x / zoomFactor;
            number b = y / zoomFactor;
            number brightness = 0;
            number ca = a;
            number cb = b;

            while (brightness < maxI) {
                number aa = a * a - b * b;
                number bb = 2 * a * b;

                a = aa + ca;
                b = bb + cb;

                if (abs(a + b) > 16)
                    break;
                
                brightness ++;
            }

            brightness = sqrt(brightness / maxI);

            return vec4(1.0 - brightness, 1.0 - brightness, 1.0 - brightness, 1.0);
        }
    ]]
end

function love.resize(w, h)
    screenDim.x = w
    screenDim.y = h
end

function love.update()
    mandelbrotShader:send('zoomFactor', zoomFactor)
    mandelbrotShader:send('maxI', maxI)
    mandelbrotShader:send('offsetX', offset.x)
    mandelbrotShader:send('offsetY', offset.y)
    mandelbrotShader:send('maxX', screenDim.x)
    mandelbrotShader:send('maxY', screenDim.y)

    if love.keyboard.isDown("right") then
        offset.x = offset.x + zoomFactor * 0.01
    end

    if love.keyboard.isDown("left") then
        offset.x = offset.x - zoomFactor * 0.01
    end

    if love.keyboard.isDown("down") then
        offset.y = offset.y + zoomFactor * 0.01
    end

    if love.keyboard.isDown("up") then
        offset.y = offset.y - zoomFactor * 0.01
    end

    if love.keyboard.isDown("=") then
        zoomFactor = zoomFactor + zoomFactor * 0.01
    end

    if love.keyboard.isDown("-") then
        zoomFactor = zoomFactor - zoomFactor * 0.01
    end
end

function love.draw()
    love.graphics.setShader(mandelbrotShader)
    local w = {love.graphics.getDimensions()}
    love.graphics.rectangle('fill', 0, 0, w[1], w[2])
end
