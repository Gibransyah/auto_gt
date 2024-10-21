UseToken = false
LoginType = Platform.windows

BotList = [[
adasatu140@gmail.com:adaenamini
darrylpittman6227@gmail.com:fyq2ebRxV7gs:vx5q4p@f3ts5.shop

]]

-- Dont Touch!

bots = {}
indexBot = 1 
if UseToken then
    tokens = {}
    local file = io.open("tokenbot.txt", "r")
    for line in file:lines() do
        table.insert(tokens, line)
    end
    file:close()
end
for line in BotList:gmatch("[^\r\n]+") do
    local name, password, otp = line:match("([^:]+):([^:]+)")
    if name and password then
        local bot = {
            ["name"] = name,
            ["password"] = password,
            ["platform"] = LoginType,
            ["connect"] = false
        }
        if otp and otp ~= "" then
            bot["secret"] = otp
            bot["platform"] = Platform.ubiconnect -- Use ubiconnect if 3 columns
        end
        table.insert(bots, bot)
    end
end
for _, information in ipairs(bots) do
    addBot(information)
    sleep(100)
    if UseToken then
        botr = getBot(indexBot)
        botr:updateTokenBot(tokens[indexBot])
        sleep(100)
        botr:connect()
        sleep(10000)
        indexBot = indexBot + 1
    else
        sleep(10000)
    end
end