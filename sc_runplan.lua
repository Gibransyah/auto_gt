    StartBotFrom = 1

    ItemIDSeed = 4585

    WorldFarmList = {
        "FOTT6EOPO5|TEAMPICK25",
        "WI8BTLJZET|TEAMPICK25"
    }
    MaxFarmPerBot = 8

    WorldSeed = {
        "DAFFABUCKSD01|TEAMPICK25",
        "DAFFABUCKSD02|TEAMPICK25",
        "CUPLIZSD02|CUPLIS990",
        "EJJJWLTKTVA|CUPLIS990",
        "CUPLIZZZ99|CUPLIS990"
    }
    IndexWorldSeed = 1
    -- Dont Touch!

    botr = getBot()

    for k,v in pairs(getBots()) do
        if v.name:upper() == botr.name:upper() then
            SlotBot = k + (StartBotFrom - 1)
            IndexBot = k
            break
        end
    end

    StartFarm = (SlotBot * MaxFarmPerBot) - (MaxFarmPerBot - 1)
    StopFarm = SlotBot * MaxFarmPerBot

    plant = botr.auto_plant -- Accessing AutoPlant from bot struct.
    plant:setStorage(WorldSeed[IndexWorldSeed])
    for i = StartFarm, StopFarm do
        plant:add(WorldFarmList[i]:match("([^|]+)")..":"..WorldFarmList[i]:match("|([^|]+)")..":"..ItemIDSeed)
        sleep(100)
    end
    sleep(1000 * IndexBot)
    plant.enabled = true

    function scanSeed()
        local count = 0
        for _, obj in pairs(botr:getWorld():getObjects()) do
            if obj.id == ItemIDSeed then
                count = count + obj.count
            end
        end
        return count
    end

    while true do
        if botr:getWorld().name:upper() == WorldSeed[IndexWorldSeed] then
            if scanSeed() == 0 then
                IndexWorldSeed = IndexWorldSeed + 1
                plant:setStorage(WorldSeed[IndexWorldSeed])
            end
        end
        sleep(5000)
    end

