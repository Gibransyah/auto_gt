FirstString = "DAFFABUCKSD"
StartNumber = 1
StopNumber = 2
IDDoor = "TEAMPICK25"

WorldStorage = "NGAWURBEBAS|TEAMPICK25"

-- Dont Touch!

botr = getBot()
Supply = {
    {id = 202, count = StopNumber - StartNumber + 1},
    {id = 226, count = StopNumber - StartNumber + 1},
    {id = 12, count = StopNumber - StartNumber + 1},
    {id = 2810, count = (StopNumber - StartNumber + 1) * 2},
}

function WriteFile(path, content)
    local file = io.open(path .. '.txt', "a+")
    if file then
        file:write(content .. '\n')
        file:close()
    else
    end
end

function EditDoor(x,y,id)
    botr:wrench(math.floor(botr:getWorld():getLocal().posx / 32) + x,math.floor(botr:getWorld():getLocal().posy / 32) + y)
    sleep(3000)
    botr:sendPacket(2,"action|dialog_return\ndialog_name|door_edit\ntilex|"..(math.floor(botr:getWorld():getLocal().posx / 32) + x).."|\ntiley|"..(math.floor(botr:getWorld():getLocal().posy / 32) + y).."|\ndoor_name|\ndoor_target|\ndoor_id|"..id.."\ncheckbox_locked|1")
    sleep(2000)
end

function PnchItm(x,y)
    if botr:isInWorld() then
        packet = GameUpdatePacket.new()
        packet.type = 3
        packet.int_data = 18
        packet.int_x = math.floor(botr:getWorld():getLocal().posx / 32) + x
        packet.int_y = math.floor(botr:getWorld():getLocal().posy / 32) + y
        packet.pos_x = botr:getWorld():getLocal().posx
        packet.pos_y = botr:getWorld():getLocal().posy
        botr:sendRaw(packet)
    end
end

function PlceItm(x,y,id)
    packet = GameUpdatePacket.new()
    packet.type = 3
    packet.int_data = id
    packet.int_x = math.floor(botr:getWorld():getLocal().posx / 32) + x
    packet.int_y = math.floor(botr:getWorld():getLocal().posy / 32) + y
    packet.pos_x = botr:getWorld():getLocal().posx
    packet.pos_y = botr:getWorld():getLocal().posy
    botr:sendRaw(packet)
end

function BuildWorld(w)
    local x = math.floor(botr:getWorld():getLocal().posx / 32)
    local y = math.floor(botr:getWorld():getLocal().posy / 32)
    while botr:getWorld():getTile(x, y - 1).fg ~= 202 do
        PlceItm(0, -1, 202)
        sleep(500)
    end
    while botr:getWorld():getTile(x + 1, y).fg ~= 2810 do
        PlceItm(1, 0, 2810)
        sleep(500)
    end
    while botr:getWorld():getTile(x - 1, y).fg ~= 2810 do
        PlceItm(-1, 0, 2810)
        sleep(500)
    end
    while botr:getWorld():getTile(x - 1, y - 1).fg ~= 226 do
        PlceItm(-1, -1, 226)
        sleep(500)
    end
    while botr:getWorld():getTile(x - 1, y - 2).fg ~= 12 do
        PlceItm(-1, -2, 12)
        sleep(500)
    end
    PnchItm(-1, -1)
    sleep(1000)
    EditDoor(-1, -2, IDDoor)
    sleep(100)
    while botr:getWorld():getTile(math.floor(botr:getWorld():getLocal().posx / 32), math.floor(botr:getWorld():getLocal().posy / 32)).fg == 6 do
        botr:warp(w.."|"..IDDoor)
        sleep(5000)
        if botr:getWorld():getTile(math.floor(botr:getWorld():getLocal().posx / 32), math.floor(botr:getWorld():getLocal().posy / 32)).fg == 6 then
            EditDoor(-1, -2, IDDoor)
            sleep(100)
        end
    end
    WriteFile("worldstorage", w.."|"..IDDoor)
    sleep(100)
end

function FaceLeft()
    packet = GameUpdatePacket.new()
    packet.type = 0
    packet.pos_x = botr:getWorld():getLocal().posx
    packet.pos_y = botr:getWorld():getLocal().posy
    packet.flags = 48
    botr:sendRaw(packet)
end

function JoinToWorld(w)
    while not botr:isInWorld(w:match("([^|]+)"):upper()) do
        botr:warp(w)
        sleep(10000)
    end
    if w:find("|") then
        while botr:getWorld():getTile(math.floor(botr:getWorld():getLocal().posx / 32),math.floor(botr:getWorld():getLocal().posy / 32)).fg == 6 do
            botr:warp(w)
            sleep(10000)
        end
    end
end

function TakeSupply()
    JoinToWorld(WorldStorage)
    sleep(100)
    for _, itm in pairs(Supply) do
        while botr:getInventory():findItem(itm.id) < itm.count do
            for _,obj in pairs(botr:getWorld():getObjects()) do
                if obj.id == itm.id then
                    botr:findPath(math.floor(obj.x / 32), math.floor(obj.y / 32))
                    sleep(1000)
                    botr:collect(2)
                    sleep(500)
                end
                if botr:getInventory():findItem(itm.id) >= itm.count then
                    break
                end
            end
        end
    end
    botr:findPath(math.floor(botr:getWorld():getLocal().posx / 32),math.floor(botr:getWorld():getLocal().posy / 32) + 1)
    sleep(1000)
    botr:findPath(math.floor(botr:getWorld():getLocal().posx / 32) + 1,math.floor(botr:getWorld():getLocal().posy / 32))
    sleep(1000)
    for _, itm in pairs(Supply) do
        while botr:getInventory():findItem(itm.id) > itm.count do
            FaceLeft()
            sleep(500)
            botr:drop(itm.id,botr:getInventory():findItem(itm.id) - itm.count)
            sleep(4000)
        end
    end
end

TakeSupply()
sleep(100)
for i = StartNumber, StopNumber do
    JoinToWorld(FirstString.."0"..i)
    sleep(100)
    BuildWorld(FirstString.."0"..i)
    sleep(100)
end
