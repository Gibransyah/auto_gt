UseToken = false
LoginType = Platform.windows

BotList = [[
agafez6792@gmail.com:@inupe0386
ikakoy7637@gmail.com:@aseci3075
ofekow4046@gmail.com:@axeci6659
uzekeb4979@gmail.com:@ufiyu1970
emuxox3163@gmail.com:@ohuwo3065
atokoh5378@gmail.com:@agatu8577
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
    botr = getBot(indexBot)
    if UseToken then
        botr:updateTokenBot(tokens[indexBot])
        sleep(100)
        botr:connect()
        sleep(10000)
        indexBot = indexBot + 1
    else
        botr:connect()
        sleep(25000)
    end
    indexBot = indexBot + 1
end