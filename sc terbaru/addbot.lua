UseToken = false
LoginType = Platform.windows
Param = "|"
indexBot = 1
Bypass = true

BotList = [[
stacyleonard87391@gmail.com|Tartelstore@2|ddkL7VAtr7fRjqiylmGM@knightz.id
anuvad9323@gmail.com|@iqiju8857
davionatesa@gmail.com|fafa_4490
shailafrida2@gmail.com|fafa_4490
keyafitria@gmail.com|fafa_4490
abiyansaifa50@gmail.com|fafa_4490
yoghifebrian412@gmail.com|fafa_4490

]]

-- Dont Touch!

bots = {}
if UseToken then
    tokens = {}
    local file = io.open("tokenbot.txt", "r")
    for line in file:lines() do
        table.insert(tokens, line)
    end
    file:close()
end
for line in BotList:gmatch("[^\r\n]+") do
    local name, password, otp = line:match("([^"..Param.."]+)"..Param.."([^"..Param.."]+)")
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
        if Bypass then
            botr.bypass_logon = true
            sleep(2000)
        end
        botr:connect()
        sleep(20000)
    end
    indexBot = indexBot + 1
end