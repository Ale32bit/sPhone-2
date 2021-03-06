--[[
-- sPhone 2.0 for ComputerCraft
-- Copyright (c) 2018 Ale32bit & Rph
-- LICENSE: GNU GPLv3 (https://github.com/Ale32bit/sPhone-2/blob/master/LICENSE)
]]--

if fs.exists("/.sPhone/config/sPhone") then
    return
end

local oldp = os.pullEvent
os.pullEvent = os.pullEventRaw
local sha256 = sPhone.require("sha256").sha256

local w,h = term.getSize()
local pw

local center = function(txt)
    local _,y = term.getCursorPos()
    term.setCursorPos(math.ceil(w/2)-math.ceil(#txt/2)+1,y)
    write(txt)
end

local function slow(y,...)
    local args = {...}
    term.setBackgroundColor(colors.blue)
    for i = 1,#args do
        term.setCursorPos(1,y-1+i)
        term.setTextColor(colors.lightBlue)
        center(args[i])
    end
    sleep(0.07)
    for i = 1,#args do
        term.setCursorPos(1,y-1+i)
        term.setTextColor(colors.white)
        center(args[i])
    end
end

local f = fs.open("/.sPhone/config/setupMode","w")
f.write("true")
f.close()

term.setBackgroundColor(colors.black)
term.clear()
sleep(0.59)
term.setBackgroundColor(colors.gray)
term.clear()
sleep(0.09)
term.setBackgroundColor(colors.blue)
term.clear()

sleep(0.7)
slow(5,"Welcome to sPhone setup!")

sleep(1.5)

slow(8,"What's your username?")
local current = term.current()
local usernameInput = window.create(term.current(),3,10,w-3,1,true)
usernameInput.setBackgroundColor(colors.blue)
usernameInput.setTextColor(colors.white)
usernameInput.clear()
usernameInput.setCursorPos(1,1)
term.redirect(usernameInput)
local username = read()
term.redirect(current)
term.setCursorPos(3,10)
print(username)
slow(13,"Insert a password","(Leave blank for none)")
local passwordInput = window.create(term.current(),3,16,w-3,1,true)
passwordInput.setBackgroundColor(colors.blue)
passwordInput.setTextColor(colors.white)
passwordInput.clear()
passwordInput.setCursorPos(1,1)
term.redirect(passwordInput)
local password = read("*")
term.redirect(current)
term.setCursorPos(3,16)
if password == "" then
    term.setTextColor(colors.lightGray)
    print("None")
    term.setTextColor(colors.white)
    pw = false
else
    print(string.rep("*",#password))
    pw = sha256(password)
end

local f = fs.open("/.sPhone/config/sPhone","w")
f.write(textutils.serialize({
    username = username,
    password = pw,
}))
f.close()
fs.delete("/.sPhone/config/setupMode")

slow(h-1,"sPhone is now ready!")

sleep(2)

os.pullEvent = oldp