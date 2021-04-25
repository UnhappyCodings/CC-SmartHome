
--
--      SmartHome System by UnhappyWithoutU
--                  v1.0 - 2021
--

-- Get Monitor
local monitor = peripheral.wrap("monitor_2")
local Reactormonitor = peripheral.wrap("monitor_3")
local memonitor = peripheral.wrap("monitor_4")

local outComputer = peripheral.wrap("computer_12")
local modem = peripheral.find("modem")

local button = require("button")
local graphic = require("graphic")
-- I like trains
-- Reset Monitor Function
local function clearReactor()
    Reactormonitor.clear()
    Reactormonitor.setBackgroundColor(colors.black)
    Reactormonitor.setTextScale(0.5)
    local oldReactorterm = term.redirect(Reactormonitor)
    graphic.drawBox(1,1,143,52,colors.gray,Reactormonitor)
    Reactorimage = paintutils.loadImage("Reactor.nfp")
    paintutils.drawImage(Reactorimage,math.floor(((143 / 2)) - (114 / 2)), 6)
    Reactormonitor.setBackgroundColor(colors.black)
    term.redirect(oldReactorterm)
end

local function clearMe()
    memonitor.clear()
    memonitor.setBackgroundColor(colors.black)
    memonitor.setTextScale(0.5)
    local oldmeterm = term.redirect(memonitor)
    graphic.drawBox(1,1,143,52,colors.gray,memonitor)
    meimage = paintutils.loadImage("Me.nfp")
    paintutils.drawImage(meimage,math.floor(((143 / 2)) - (42 / 2)), 6)
    memonitor.setBackgroundColor(colors.black)
    term.redirect(oldmeterm)
end

local function clearMonitor()
    monitor.clear()
    monitor.setBackgroundColor(colors.black)
    monitor.setTextScale(0.5)
    graphic.drawBox(1,1,164,52,colors.gray)
    image = paintutils.loadImage("Logo.nfp")
    paintutils.drawImage(image,math.floor(((164 / 2)) - (106 / 2)), 6)
    monitor.setBackgroundColor(colors.black)
    -- left
    graphic.drawBox(19,24,49,29,colors.white)
    graphic.drawBox(19,32,49,37,colors.white)
    graphic.drawBox(19,40,49,45,colors.white)
    -- right
    graphic.drawBox(54,24,84,29,colors.white)
    graphic.drawBox(54,32,84,37,colors.white)
end

local function setMonitorData(monitor)
    monitor.setPaletteColour(colors.lime, 0xbf5f06)         -- button on
    monitor.setPaletteColour(colors.red, 0x522700)          -- button off
    monitor.setPaletteColour(colors.orange, 0xff891f)       -- logo
    monitor.setPaletteColour(colors.gray, 0xff891f)         -- frame
    monitor.setPaletteColour(colors.black, 0x18191a)        -- background
end

-- Dynamic Functions

local function updateColor(state,x,y,x2,y2,text)
    if state then
        graphic.drawFilledBox(x,y,x2,y2,colors.lime)
        monitor.setBackgroundColor(colors.lime)
    else
        graphic.drawFilledBox(x,y,x2,y2,colors.red)
        monitor.setBackgroundColor(colors.red)
    end
    monitor.setCursorPos(math.floor((x + (30 / 2)) - (text:len() / 2)), y2-2)
    monitor.setTextColor(colors.white)
    monitor.write(text)
    monitor.setBackgroundColor(colors.black)
end

local function updateButtons()
    -- links
    updateColor(redstone.getOutput("right"),20,25,48,28,"1 | Haupttür")
    updateColor(redstone.getOutput("left"),20,33,48,36,"2 | Licht")
    updateColor(redstone.getOutput("bottom"),20,41,48,44,"3 | Unknown")
    -- rechts
    updateColor(redstone.getOutput("front"),55,25,83,28,"4 | Reactor")
    updateColor(redstone.getOutput("top"),55,33,83,36,"5 | Unknown")
end

-- Button Functions
local function toggle1()
    redstone.setOutput("right", not redstone.getOutput("right"))
    updateButtons()
end

local function toggle2()
    redstone.setOutput("left", not redstone.getOutput("left"))
    updateButtons()
end

local function toggle3()
    redstone.setOutput("bottom", not redstone.getOutput("bottom"))
    updateButtons()
end

local function toggle4()
    redstone.setOutput("front", not redstone.getOutput("front"))
    updateButtons()
end

local function toggle5()
    redstone.setOutput("top", not redstone.getOutput("top"))
    updateButtons()
end

local oldTerm = term.redirect(monitor)         -- Monitor Output Start

clearMonitor()
clearReactor()
clearMe()

-- links 1
local button1 = button.newButton(20,25,28,5,toggle1)    -- light
local button2 = button.newButton(20,33,28,5,toggle2)     -- door
local button3 = button.newButton(20,41,28,5,toggle3)    -- unknown
-- links 2
local button4 = button.newButton(55,25,28,5,toggle4)    -- reactor
local button5 = button.newButton(55,33,28,5,toggle5)    -- unknown

setMonitorData(monitor)
setMonitorData(Reactormonitor)
setMonitorData(memonitor)

updateButtons()

while true do
    local event = {os.pullEvent()}
    local newEvent = event
    if event[1] == "monitor_touch" then
        newEvent[1] = "mouse_click"
        newEvent[2] = 1
    end
    button.executeButtons(newEvent)
end

term.redirect(oldTerm)                         -- Monitor Output End