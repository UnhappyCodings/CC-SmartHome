
--
--      SmartHome System by UnhappyWithoutU
--                  v1.0 - 2021
--

-- Get Monitor
local Monitor = peripheral.wrap("Monitor_2")
local ReactorMonitor = peripheral.wrap("Monitor_3")
local meMonitor = peripheral.wrap("Monitor_4")

local button = require("button")
local graphic = require("graphic")

-- Reset Monitor Function
local function clearReactor()
    ReactorMonitor.clear()
    ReactorMonitor.setBackgroundColor(colors.black)
    ReactorMonitor.setTextScale(0.5)
    local oldReactorterm = term.redirect(ReactorMonitor)
    graphic.drawBox(1,1,143,52,colors.gray,ReactorMonitor)
    Reactorimage = paintutils.loadImage("Reactor.nfp")
    paintutils.drawImage(Reactorimage,math.floor(((143 / 2)) - (114 / 2)), 6)
    ReactorMonitor.setBackgroundColor(colors.black)
    term.redirect(oldReactorterm)
end

local function clearMe()
    meMonitor.clear()
    meMonitor.setBackgroundColor(colors.black)
    meMonitor.setTextScale(0.5)
    local oldmeterm = term.redirect(meMonitor)
    graphic.drawBox(1,1,143,52,colors.gray,meMonitor)
    meimage = paintutils.loadImage("Me.nfp")
    paintutils.drawImage(meimage,math.floor(((143 / 2)) - (42 / 2)), 6)
    meMonitor.setBackgroundColor(colors.black)
    term.redirect(oldmeterm)
end

local function clearMonitor()
    Monitor.clear()
    Monitor.setBackgroundColor(colors.black)
    Monitor.setTextScale(0.5)
    graphic.drawBox(1,1,164,52,colors.gray)
    image = paintutils.loadImage("Logo.nfp")
    paintutils.drawImage(image,math.floor(((164 / 2)) - (106 / 2)), 6)
    Monitor.setBackgroundColor(colors.black)
    -- left
    graphic.drawBox(19,24,49,29,colors.white)
    graphic.drawBox(19,32,49,37,colors.white)
    graphic.drawBox(19,40,49,45,colors.white)
    -- right
    graphic.drawBox(54,24,84,29,colors.white)
    graphic.drawBox(54,32,84,37,colors.white)
end

local function setMonitorData(Monitorarg)
    Monitorarg.setPaletteColour(colors.lime, 0xbf5f06)         -- button on
    Monitorarg.setPaletteColour(colors.red, 0x522700)          -- button off
    Monitorarg.setPaletteColour(colors.orange, 0xff891f)       -- logo
    Monitorarg.setPaletteColour(colors.gray, 0xff891f)         -- frame
    Monitorarg.setPaletteColour(colors.black, 0x18191a)        -- background
end

-- Dynamic Functions

local function updateColor(Monitorarg,state,x,y,x2,y2,text)
    if state then
        graphic.drawFilledBox(x,y,x2,y2,colors.lime)
        Monitorarg.setBackgroundColor(colors.lime)
    else
        graphic.drawFilledBox(x,y,x2,y2,colors.red)
        Monitorarg.setBackgroundColor(colors.red)
    end
    Monitorarg.setCursorPos(math.floor((x + (30 / 2)) - (text:len() / 2)), y2-2)
    Monitorarg.setTextColor(colors.white)
    Monitorarg.write(text)
    Monitorarg.setBackgroundColor(colors.black)
end

local function updateButtons()
    -- links
    updateColor(Monitor,redstone.getOutput("right"),20,25,48,28,"1 | Haupttür")
    updateColor(Monitor,redstone.getOutput("left"),20,33,48,36,"2 | Licht")
    updateColor(Monitor,redstone.getOutput("bottom"),20,41,48,44,"3 | Unknown")
    -- rechts
    updateColor(Monitor,redstone.getOutput("front"),55,25,83,28,"4 | Reactor")
    updateColor(Monitor,redstone.getOutput("top"),55,33,83,36,"5 | Unknown")
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

local oldTerm = term.redirect(Monitor)         -- Monitor Output Start

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

setMonitorData(Monitor)
setMonitorData(ReactorMonitor)
setMonitorData(meMonitor)

updateButtons()

while true do
    local event = {os.pullEvent()}
    local newEvent = event
    if event[1] == "Monitor_touch" then
        newEvent[1] = "mouse_click"
        newEvent[2] = 1
    end
    button.executeButtons(newEvent)
end

term.redirect(oldTerm)                         -- Monitor Output End