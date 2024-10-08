StartBotFrom = 1

ItemIDSeed = 4585

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
MaxFarmPerBot = 9

WorldSeed = "DINWM21|KMXKRM69"

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
plant:setStorage(WorldSeed)
for i = StartFarm, StopFarm do
    plant:add(WorldFarmList[i]:match("([^|]+)")..":"..WorldFarmList[i]:match("|([^|]+)")..":"..ItemIDSeed)
    sleep(100)
end
sleep(1000 * IndexBot)
plant.enabled = true