local exports = {
    name = "stargate",
    version = "0.0.1",
    description = "Stargate hacking plugin",
    license = "BSD-3-Clause",
    author = { name = "Gaz Liddon" },
}

local sym_6800 = {
    IRQ_V = 0xfff8,
    SWI_V = 0xfffa,
    NMI_V = 0xfffc,
    RESET_V = 0xfffe,
}

local function get_device(tag)
    return manager.machine.devices[tag]
end

local function dump_info(mr)
    print("tag:  " .. mr.tag)
    print("size: " .. mr.size)
    print("len:  " .. mr.length)
end

local function hex(val)
    return string.format("%04x", val)
end

local function init_symbols()
    local snd_device = get_device(":soundcpu")

    emu.print_info("Got sound device")
    if snd_device == nil then
        emu.print_info("Mother fucker is nil!")
    end

    local sym_tab = emu.symbol_table(snd_device)

    for sym, val in pairs(sym_6800) do
        sym_tab:add(sym, val)
    end

    local mm = manager.machine.memory

    local snd_mem = mm.regions[":soundcpu"]

    dump_info(snd_mem)

    local irq = snd_mem:read_u16(0xfff8)
    print("IRQ routine => " .. hex(irq))

    for k, v in pairs(sym_6800) do
        local vec = snd_mem:read_u16(v)
        print(k .. " routine => " .. hex(vec))
    end

end

local function process_frame() end

local function subscribe()
    emu.add_machine_reset_notifier(function()
        emu.print_info("Reset " .. emu.gamename())
    end)

    emu.add_machine_stop_notifier(function()
        emu.print_info("Exiting " .. emu.gamename())
    end)
end

local function pre_start()
    local gamename = emu.gamename()

    if gamename == "Stargate" then
        emu.print_info("Starting stargate plugin")

        init_symbols()
        subscribe()
        emu.add_machine_frame_notifier(process_frame)
        manager.machine:load("menu")
    else
        emu.print_info("Not starting plugin for " .. gamename)
    end
end

function exports.startplugin()
    emu.register_prestart(pre_start)
end

return exports
