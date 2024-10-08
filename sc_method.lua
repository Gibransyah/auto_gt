WorldMag = "HKHDJ"
PathMagX = 0
PathMagY = -1

botr = getBot()

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

for k,v in pairs(getBots()) do
    if v.name:upper() == botr.name:upper() then
        IndexBot = k
        break
    end
    sleep(4000)
end

tutor = botr.auto_tutorial
local tutorial = botr.auto_tutorial 
tutorial.enabled = false 
tutorial.auto_quest = false
tutorial.detect_tutorial = false 

if tutorial.step > 0 then 
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

JoinToWorld(WorldMag)
sleep(100)
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
botr:sendPacket(3, "action|quit_to_exit")