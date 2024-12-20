local input_text = [[
rogejiwece1@gmail.com|happytr31eeo|jakaxiwe@jupiter.site|snxfbu2uxj7x36twtfeheb3n72bd66f7
sexarukomu75@gmail.com|starmountain|xeyelike@venus.online|mx3noq4giju763njzyeqdkjxwxzav4vi
sizubepivi9@gmail.com|77drea(mblue|kaledili@bbird.site|d7jram7lkhahos2veevkh6uakf75nomp
gemuqujuya11@gmail.com|16fire(tree#|jogayiwe@venus.shop|raycfewc5enl4t4w7kevxmx5upghmdbi
wulezaxicu50@gmail.com|fire!drea38m|kixicelu@bimasakti.xyz|fd7waeooghl33sopeopkyktvwkr3ed7m
pilicateyi95@gmail.com|sunli@ght533|cujehuto@mars.site|5xtpnkr3nxtmdklzbdkvwb7256tqu4uh
jibowovedu10@gmail.com|46d(reammoun|cuqofiru@bbird.shop|6dxw2blaypxomzytbdb4g6argdfj4exi
riwogirase23@gmail.com|cloudm17o^un|jaqowoba@airbus.site|d6febpftfabyiyunie7tsybi4he5zuwk
wajogimime44@gmail.com|^moonstone78|kaxiyuko@bbird.site|6cxubvczsrk3x3tze3pmzdacr6k3bkjl
tuyuceqosa74@gmail.com|win*dleaf16@|dupiqura@bbird.org|xb2fkzf6qafmjzzoa3kn3pisserqg3ju
davasojeho53@gmail.com|ston33ewin!d|bugiwijo@bbird.org|ugjka7tskrvukezunba2lklzna536nbf
]]

function generate_random_mac_address()
    local mac = {}
    for i = 1, 6 do
        mac[i] = string.format("%02X", math.random(0, 255))
    end
    return table.concat(mac, ":")
end

for line in string.gmatch(input_text, "([^\r\n]+)") do
    math.randomseed(os.time())
    local email, password, recovery, secret = line:match("([^|]+)|([^|]+)|([^|]+)|?(.*)")
    if email and password and recovery then
        -- Hilangkan spasi dari secret jika ada
        if secret then
            secret = secret:gsub("%s+", "")
        end

        local information = {
            ["name"] = email,
            ["password"] = password,
            ["mac"] = generate_random_mac_address(),
            ["rid"] = "",
            ["hash"] = "",
            ["recovery"] = recovery,
            ["secret"] = secret or "",
            ["platform"] = "Platform.windows",
            ["connect"] = false,
        }
        addBot(information)
        print("Information processed for:", email)
    else
        print("Error parsing line:", line)
    end
end