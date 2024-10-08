StartBotFrom = 1
WebhookLink = "https://discord.com/api/webhooks/1291304588225413171/t4WKK644RMOa9gApIeGvs61zjg63mlH86J8YX8EGD9204ga3wNYYbyTcu-xAcjnVr_72"
UseToken = false

--[ Farm Setting ]--
ItemIDSeed = 4585
ItemIDBlock = ItemIDSeed - 1

WorldFarmList = {
    "DA822NGUK9|TEAMPICK25",
    "4YNPM7VVVI|TEAMPICK25",
    "KS3CRLBP6U|TEAMPICK25",
    "G4VMCJH0PI|TEAMPICK25",
    "K2GVSF7T0D|TEAMPICK25",
    "RI3TJXJZJU|TEAMPICK25",
    "4CPJUKHSV8|TEAMPICK25",
    "HHZNX9QRC1|TEAMPICK25",

    "35TR7FJ288|TEAMPICK25",
    "8HDYSD7010|TEAMPICK25",
    "93V5F012O1|TEAMPICK25",
    "HECTKE7DYW|TEAMPICK25",
    "FT1ZLZ4NC9|TEAMPICK25",
    "WV2EYQD8GJ|TEAMPICK25",
    "W4VRR45JY0|TEAMPICK25",
    "ZGRTHNGHN1|TEAMPICK25",

    "BKAJEDDXOA|TEAMPICK25",
    "ZZG347SSNF|TEAMPICK25",
    "W1W4FIPA24|TEAMPICK25",
    "S8NULLRVOR|TEAMPICK25",
    "UWWV93TQ98|TEAMPICK25",
    "U520CFJ988|TEAMPICK25",
    "E8AJV37IJK|TEAMPICK25",
    "2COI0OPNPD|TEAMPICK25",

    "352GTZBO3B|TEAMPICK25",
    "50U1DVODJI|TEAMPICK25",
    "EO5V32EVBP|TEAMPICK25",
    "GTCP2KYXV6|TEAMPICK25",
    "3AS9Y0R1TR|TEAMPICK25",
    "WWTL9Z084X|TEAMPICK25",
    "Y2D2OR7FJA|TEAMPICK25",
    "IE8V1NBTNN|TEAMPICK25",

    "9J5EK2L0LB|TEAMPICK25",
    "YDXED3Z7IF|TEAMPICK25",
    "XJN4QWMR6O|TEAMPICK25",
    "6O0QXO71MG|TEAMPICK25",
    "QPZ0QVM2IS|TEAMPICK25",
    "EXRQHUUVFZ|TEAMPICK25",
    "Y3SQV2XAPT|TEAMPICK25",
    "GWVWNE7NSC|TEAMPICK25",

    "80A48C43FL|TEAMPICK25",
    "5XB6N7KHT8|TEAMPICK25",
    "4VU6YSDSGZ|TEAMPICK25",
    "8ZUXFQD47L|TEAMPICK25",
    "HFL7I38MOK|TEAMPICK25",
    "7CK40WFDD5|TEAMPICK25",
    "R4B3DDT68M|TEAMPICK25",
    "W86MN005IF|TEAMPICK25",
    

}
MaxFarmPerBot = 8

--[ Storage Setting ]--
WorldSeedList = {
    "DAFFABUCKSD01|TEAMPICK25",
    "DAFFABUCKSD02|TEAMPICK25",
}
MaxBotPerWorldSeed = 3

WorldPackList = {
    "DAFFABUCKPC01|TEAMPICK25",
    "DAFFABUCKPC02|TEAMPICK25",
}
MaxBotPerWorldPack = 3

WorldPickaxe = {
    "BENJOLPICK01|TEAMPICK25",
}
MaxBotPerWorldPick = 6

WorldVial = {
    "DAFFABUCKVL01|TEAMPICK25",
}
MaxBotPerWorldVial = 6

--[ Other Setting ]--
AutoCheckLG = false

-- Dont Touch!

function HookLifeGoals(variant, netid)
    if variant:get(0):getString() == "OnDialogRequest" then
        local DataLG = {}
        for line in variant:get(1):getString():gmatch("[^\r\n]+") do
            if line:find("Seed Goal") and not line:find("Deliver") then
                table.insert(DataLG, line)
            end
            if line:find("Gem Goal") and not line:find("Deliver") then
                table.insert(DataLG, line)
            end
            if line:find("Experience Goal") and not line:find("Deliver") then
                table.insert(DataLG, line)
            end
        end
        if DataLG[1]:find("COMPLETE") and DataLG[2]:find("COMPLETE") then
            AutoCheckLG = false
        elseif DataLG[1]:find("OK") and DataLG[2]:find("OK") then
            IsLG = true
        end
    end
end

function HookPlayerCount(variant, netid)
    if variant:get(0):getString() == "OnConsoleMessage" and variant:get(1):getString():find("online") then 
        for line in variant:get(1):getString():gmatch("[^\r\n]+") do
            if line:find("online") then
                str = line:match("`w(%d[%d,]*)`` online"):gsub(",", "")
            end
        end
        PlayerCount = tonumber(str)
    end
end

function InfoBot(info) 
    local webhook = Webhook.new(WebhookLink)
    webhook.content = "`[Slot-"..SlotBot.."] "..info.."` `("..GetStatus()..")`"
    webhook:send()
end

function Reconnect()
    if GetStatus() ~= "Online" then
        sleep(10000)
        local tryRecon = 0
        local totalRecon = 0
        while GetStatus() ~= "Online" do
            if UseToken then
                botr:updateToken(tokens[IndexBot])
                sleep(100)
            end
            botr:connect()
            addEvent(Event.varianlist, HookPlayerCount)
            listenEvents(20)
            removeEvents()
            if tryRecon >= 10 then
                sleep(60000)
                tryRecon = 0
            else
                tryRecon = tryRecon + 1
            end
            if GetStatus() == "Account Banned" then
                InfoBot("Banned!")
                sleep(100)
                error()
            end
            if GetStatus() == "Captcha" then
                InfoBot("Captcha!")
                sleep(100)
                error()
            end
            if GetStatus() == "Online" and PlayerCount then
                if PlayerCount < 25000 then
                    botr:disconnect()
                    sleep(100)
                    InfoBot("Resting 5 mins because low player!")
                    sleep(300000)
                    InfoBot("Run rotasi again!")
                end
            end
        end 
    end
end

function TakePickaxe()
    botr.auto_collect = false
    JoinToWorld(WorldPickaxe[math.ceil(SlotBot / MaxBotPerWorldPick)])
    sleep(100)
    while botr:getInventory():findItem(98) == 0 do
        for _,obj in pairs(botr:getWorld():getObjects()) do
            if obj.id == 98 then
                botr:findPath(math.floor(obj.x / 32),math.floor(obj.y / 32))
                sleep(1000)
                botr:collect(2)
                sleep(500)
            end
            if botr:getInventory():findItem(98) > 0 then
                break
            end
        end
    end
    botr:findPath(math.floor(botr:getWorld():getLocal().posx / 32),math.floor(botr:getWorld():getLocal().posy / 32) + 1)
    sleep(1000)
    while botr:getInventory():findItem(98) > 1 do
        botr:findPath(math.floor(botr:getWorld():getLocal().posx / 32) + 1,math.floor(botr:getWorld():getLocal().posy / 32))
        sleep(1000)
        FaceLeft()
        sleep(500)
        botr:drop(98,botr:getInventory():findItem(98) - 1)
        sleep(4000)
    end
    while not botr:getInventory():getItem(98).isActive do
        botr:wear(98)
        sleep(1000)
    end
end

function Rotasi()
    if botr:getInventory():findItem(98) == 0 or not botr:getInventory():getItem(98).isActive then
        TakePickaxe()
        sleep(100)
    end
    botr.auto_reconnect = false
    rotasi.harvest_until_level = true
    rotasi.enabled = true

    TimeStartFarming = os.time()

    while true do
        sleep(30000)
        Reconnect()
        sleep(100)
        TotalRunning = os.time() - StartRunning
        if TotalRunning >= (TimeMalady - 120) then
            rotasi.enabled = false
            botr:disconnect()
            sleep(100)
            InfoBot("Resting to get malady!")
            sleep(100000)
            Reconnect()
            sleep(100)
            botr.auto_reconnect = true
            GetMalady()
            sleep(100)
            InfoBot("Run rotasi again!")
            sleep(100)
            botr.auto_reconnect = false
            rotasi.enabled = true
        end
        TotalFarming = os.time() - TimeStartFarming
        if TotalFarming >= 10800 and TotalRunning < (TimeMalady - 120) then
            botr:disconnect()
            sleep(100)
            CustomStatus("Resting 5 mins!")
            sleep(100)
            InfoBot("Resting 5 mins!")
            sleep(300000)
            Reconnect()
            sleep(100)
            InfoBot("Run rotasi again!")
            sleep(100)
            TimeStartFarming = os.time()
            CustomStatus(Malady.."!")
            sleep(100)
        end
        sleep(30000)
    end
end

function TotalSecond(h, m, s)
    return (h * 3600) + (m * 60) + s
end

function FaceLeft()
    packet = GameUpdatePacket.new()
    packet.type = 0
    packet.pos_x = botr:getWorld():getLocal().posx
    packet.pos_y = botr:getWorld():getLocal().posy
    packet.flags = 48
    botr:sendRaw(packet)
end

function TakeVial()
    botr.auto_collect = false
    JoinToWorld(WorldVial[math.ceil(SlotBot / MaxBotPerWorldVial)])
    sleep(100)
    while botr:getInventory():findItem(8542) == 0 do
        for _,obj in pairs(botr:getWorld():getObjects()) do
            if obj.id == 8542 then
                botr:findPath(math.floor(obj.x / 32),math.floor(obj.y / 32))
                sleep(1000)
                botr:collect(2)
                sleep(500)
            end
            if botr:getInventory():findItem(8542) > 0 then
                break
            end
        end
    end
    botr:findPath(math.floor(botr:getWorld():getLocal().posx / 32),math.floor(botr:getWorld():getLocal().posy / 32) + 1)
    sleep(1000)
    while botr:getInventory():findItem(8542) > 1 do
        botr:findPath(math.floor(botr:getWorld():getLocal().posx / 32) + 1,math.floor(botr:getWorld():getLocal().posy / 32))
        sleep(1000)
        FaceLeft()
        sleep(500)
        botr:drop(8542,botr:getInventory():findItem(8542) - 1)
        sleep(4000)
    end
    while not IsMalady do
        botr:use(8542)
        sleep(1000)
        botr:wrenchPlayer(botr:getWorld():getLocal().netid)
        addEvent(Event.variantlist, HookMalady)
        listenEvents(5)
        removeEvents()
        botr:sendPacket(2,"action|dialog_return\ndialog_name|popup\nnetID|"..botr:getWorld():getLocal().netid.."|")
        sleep(5000)
    end
end

function GetStatus()
    local state = botr.status
    local status_Naming = {
        [BotStatus.offline] = "Offline",
        [BotStatus.online] = "Online",
        [BotStatus.account_banned] = "Account Banned",
        [BotStatus.location_banned] = "Location Banned",
        [BotStatus.server_overload] = "Login Failed",
        [BotStatus.too_many_login] = "Login Failed",
        [BotStatus.maintenance] = "Maintenance",
        [BotStatus.version_update] = "Version Update",
        [BotStatus.server_busy] = "Server Busy",
        [BotStatus.error_connecting] = "Error Connecting",
        [BotStatus.logon_fail] = "Login Failed",
        [BotStatus.http_block] = "HTTP Blocked",
        [BotStatus.wrong_password] = "Wrong Password",
        [BotStatus.advanced_account_protection] = "Advanced Account Protection",
        [BotStatus.bad_name_length] = "Bad Name Length",
        [BotStatus.invalid_account] = "Invalid Account",
        [BotStatus.guest_limit] = "Guest Limit",
        [BotStatus.changing_subserver] = "Changing Subserver",
        [BotStatus.captcha_requested] = "Captcha",
        [BotStatus.mod_entered] = "Mod Entered",
        [BotStatus.high_load] = "High Load",
        [BotStatus.could_not_warp] = "Couldn't Warp"
    }
    return status_Naming[state] or status_Naming[BotStatus.offline]
end

function HookMalady(variant, netid)
    if variant:get(0):getString() == "OnDialogRequest" then
        for line in variant:get(1):getString():gmatch("[^\r\n]+") do
            if line:find("Malady:") then
                IsMalady = true
                Malady = line:match("`wMalady: (.-)!")
                if line:find("hour") then
                    Hour = tonumber(line:match("(%d+) hour"))
                else
                    Hour = 0
                end
                if line:find("mins") then
                    Mins = tonumber(line:match("(%d+) mins"))
                else
                    Mins = 0
                end
                if line:find("secs") then
                    Secs = tonumber(line:match("(%d+) secs"))
                else
                    Secs = 0
                end
            end 
        end
    end
end

function HookWorldTutorial(variant, netid)
    if variant:get(0):getString() == "OnRequestWorldSelectMenu" and variant:get(1):getString():find("add_heading|Your Worlds") then
        local data = {}
        for line in variant:get(1):getString():gmatch("[^\r\n]+") do
            table.insert(data, line)
        end
        WorldTutorial = data[3]:match("|([^|]+)")
    end
end

function CheckWorldTutorial()
    if botr:isInWorld() then
        botr:sendPacket(3, "action|quit_to_exit")
        sleep(5000)
    end
    if not botr:isInWorld() then
        botr:sendPacket(3,"action|world_button\nname|_catselect_")
        sleep(2000)
        botr:sendPacket(3,"action|world_button\nname|_16")
        addEvent(Event.variantlist, HookWorldTutorial)
        listenEvents(5)
        removeEvents()
    end
end

function GetMalady()
    CheckWorldTutorial()
    sleep(100)
    JoinToWorld(WorldTutorial)
    sleep(100)
    CustomStatus("Getting Malady!")
    sleep(100)
    IsMalady = false
    SpamCount1 = 0
    SpamCount2 = 0
    WorldRandom = {
        "S7PVVSPO9C",
        "BFGBMBSG86",
        "PLLODGBMBF",
        "NXJ7CDIKTW",
        "J97AZKC6BF",
        "QHV1L1EGLP",
        "M094NTOEMI",
        "3HRHIUBYGV",
        "Y1WVY818ZP",
        "74VCZLH205",
        "INZFGL133P",
        "WIL9LCVRLI",
        "REF5PLTIFP",
        "6TPK8XPV9N",
        "01H9ZFF9OR",
        "QG3CT292ZD",
        "424FGN76TY",
        "KVIF0X7LC6",
        "A82X7MOO5V",
        "EYME58V69O",
        "IERH8NZXAM",
        "ZNLBWVYP5K",
        "KOWH41JER4",
        "V501X7CWXP",
        "HG0MRT4P55",
        "TP0C05U950",
        "47J5WIORZ3",
        "GLXI33DTCC",
        "HAXDLR0J7N",
        "YE7Z31MR4I",
        "3XZ55PA81Z",
        "AIX7FCTWQR",
        "DCTWI3IAXG",
        "G4P2VHWTQ2",
        "PFD3ZL34HH",
        "Q3209727XB",
        "7S60VAY5NP",
        "RGSOH1OJZW",
        "FW0P30VWRG",
        "OHUVCP140K",
        "1Z2DE03NT5",
        "JA6ZQBEZUQ",
        "UTIJADP8ZF",
        "AWJQXDGZX3",
        "ZEO50LSN43",
        "J31AQOVFZ0",
        "QDXM5U0YIS",
        "95029JURPW",
        "3VVD8KLMDE",
        "EZCSV8HP71",
        "HD26W8QKLZ",
        "WOUZG6UK09",
        "MLIP2OTLFA",
        "JX20AJPM16",
        "DYYPNUR44A",
        "FIK8I45BLD",
        "LKRE2F1YPB",
        "WZ0QIP5GIU",
        "IOBAK0J6ZK",
        "7FS8XL6S1G",
        "59S2Y1MPE0",
        "7PG337CUCP",
        "YWE7QLW44J",
        "HGRLZJ72EL",
        "3X7B1TA8LX",
        "PF4A5AN819",
        "WQ33NPUL81",
        "RZTGMB54V7",
        "MAD5L8CNVV",
        "BEOQKHYZDH",
        "G7Y0FOC5TL",
        "KHK294T7K7",
        "1N0Z1ASAXE",
        "TOK5E7HSX8",
        "KQH3F2TVA6",
        "YCPNRF5ZP7",
        "OD5OJIIDDW",
        "1UH0JYIDO9",
        "31C674BP4T",
        "JYKWRE7YKV",
        "Z4HAJZJGHZ",
        "LOO1H8DPRS",
        "H1INM9EMM0",
        "1MUW7MZRTJ",
        "A1NJ81NP8W",
        "CD9Q9OOD7J",
        "EQOJM8RKB8",
        "LCJ0MOFHIA",
        "U9YPE46H73",
        "YWWFXIAB6J",
        "SLXVPSA084",
        "WHGG1UN2HC",
        "TBHV6ULWN6",
        "A08U0LMXMD",
        "G3OPK200K6",
        "PAHZ6947FF",
        "INK8EOQ65M",
        "LME38I4CJ4",
        "PQEV8DOCFR",
        "NPWSZM1Q1U",
    }
    while true do 
        if botr:isInWorld() then
            botr:wrenchPlayer(botr:getWorld():getLocal().netid)
            addEvent(Event.variantlist, HookMalady)
            listenEvents(5)
            removeEvents()
            botr:sendPacket(2,"action|dialog_return\ndialog_name|popup\nnetID|"..botr:getWorld():getLocal().netid.."|")
            sleep(5000)
        end
        if IsMalady then
            break
        else
            local Text = {'halo aku adalah newbie ya', 'aku pandai membuat makan tapi', 'semua berhak keadilan dan di adili','garden elysium hampir mati', ' tempat ku bukan disini', 'loremp ipsum jagonya', 'mmfrt mmfg mm', 'gerrrrr gerahh sampai'}
            for i = 1, 5 do
                if botr:isInWorld() then
                    botr:say(Text[math.random(#Text)])
                    sleep(math.random(5000, 8000))
                else
                    JoinToWorld(WorldRandom[math.random(#WorldRandom)])
                    sleep(100)
                end
            end
        end
        if SpamCount1 >= 10 then
            JoinToWorld(WorldRandom[math.random(#WorldRandom)])
            sleep(100)
            SpamCount1 = 0
        else
            SpamCount1 = SpamCount1 + 1
        end
        if SpamCount2 >= 100 then
            break
        else
            SpamCount2 = SpamCount2 + 1
        end
    end
    if not IsMalady then
        TakeVial()
        sleep(100)
    end
    if IsMalady then
        CustomStatus(Malady.."!")
        sleep(100)
        TimeMalady = TotalSecond(Hour, Mins, Secs)
        StartRunning = os.time()
    end
end 

function HookWorldNuked(variant, netid)
    if variant:get(0):getString() == "OnConsoleMessage" and variant:get(1):getString():match("inaccessible") then
        WorldNuked = true
    elseif variant:get(0):getString() == "OnConsoleMessage" and variant:get(1):getString():match("Failed") then
        WorldNuked = true
    end
end

function JoinToWorld(w)
    WorldNuked = false
    while not WorldNuked and not botr:isInWorld(w:match("([^|]+)"):upper()) do
        botr:warp(w)
        addEvent(Event.variantlist, HookWorldNuked)
        listenEvents(5)
        removeEvents()
        sleep(5000)
    end
    if not WorldNuked and w:find("|") then
        while botr:getWorld():getTile(math.floor(botr:getWorld():getLocal().posx / 32),math.floor(botr:getWorld():getLocal().posy / 32)).fg == 6 do
            botr:warp(w)
            addEvent(Event.variantlist, HookWorldNuked)
            listenEvents(5)
            removeEvents()
            sleep(5000)
        end
    end
end

function MagPlant()
    CustomStatus("Getting Remote!")
    sleep(100)
    WorldMag = "HKHDJ"
    PathMagX = 0
    PathMagY = -1
    JoinToWorld(WorldMag)
    sleep(100)
    local text = {"aku butuh gems njir", "cara ambil remote gimana cok?", "mau bfg bang", "kasih akses bang"}
    botr:say(text[math.random(#text)])
    sleep(math.random(2000,5000))
    botr:say(text[math.random(#text)])
    sleep(math.random(2000,5000))
    for _,tile in pairs(getWorld():getTiles()) do
        if tile.fg == 5638 then
            botr:findPath(tile.x + PathMagX,tile.y + PathMagY)
            sleep(1000)
            botr:wrench(tile.x, tile.y)
            sleep(2000)
            botr:sendPacket(2,"action|dialog_return\ndialog_name|itemsucker\ntilex|"..tile.x.."|\ntiley|"..tile.y.."|\nbuttonClicked|getplantationdevice")
            sleep(5000)
            break
        end
    end
end

function CustomStatus(txt)
    botr.custom_status = txt
end

function Tutorial()
    tutorial = botr.auto_tutorial 
    tutorial.enabled = false 
    tutorial.auto_quest = false
    tutorial.detect_tutorial = false 
    if botr.level < 6 and tutorial.step > 0 then
        CustomStatus("Clearing Task!")
        sleep(100) 
        local step = tutorial.step
        tutorial.auto_quest = true 
        tutorial.detect_tutorial = true 
        tutorial.enabled = true
        while step ~= 0 do 
            sleep(1000)
            step = tutorial.step
        end
        tutorial.enabled = false
    end
end

function Setup()
    botr = getBot()

    botr.auto_reconnect = true
    rotasi = botr.rotation 
    rotasi.enabled = false

    if UseToken then
        tokens = {}
        local file = io.open("tokenbot.txt", "r")
        for line in file:lines() do
            table.insert(tokens, line)
        end
        file:close()
    end

    for k,v in pairs(getBots()) do
        if v.name:upper() == botr.name:upper() then
            SlotBot = k + (StartBotFrom - 1)
            IndexBot = k
            break
        end
        sleep(10000)
    end

    StartFarm = (SlotBot * MaxFarmPerBot) - (MaxFarmPerBot - 1)
    StopFarm = SlotBot * MaxFarmPerBot

    world_manager = getWorldManager()
    for i = StartFarm, StopFarm do
        world_manager:addFarm(WorldFarmList[i]:match("([^|]+)")..":"..WorldFarmList[i]:match("|([^|]+)"), ItemIDBlock)
    end
    world_manager:addStorage(WorldSeedList[math.ceil(SlotBot / MaxBotPerWorldSeed)]:match("([^|]+)")..":"..WorldSeedList[math.ceil(SlotBot / MaxBotPerWorldSeed)]:match("|([^|]+)"), StorageType.seed, ItemIDSeed)
    world_manager:addStorage(WorldPackList[math.ceil(SlotBot / MaxBotPerWorldPack)]:match("([^|]+)")..":"..WorldPackList[math.ceil(SlotBot / MaxBotPerWorldPack)]:match("|([^|]+)"), StorageType.pack, 0)
    
end

Setup()
sleep(100)
Tutorial()
sleep(100)
MagPlant()
sleep(100)
GetMalady()
sleep(100)
Rotasi()
sleep(100)