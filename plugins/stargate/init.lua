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

local function get_dev_info(tag)
    local dev = get_device(tag)
    if dev == nil then
        return nil
    else
        local sym_tab = emu.symbol_table(dev)
        local mem = manager.machine.memory.regions[tag]
        local debug = manager.machine.devices[tag].debug

        return {
            debug = debug,
            mem = mem,
            sym_tab = sym_tab,
        }
    end
end

local function init_symbols()
    local dev_info = get_dev_info(":soundcpu")

    if dev_info then
        -- local mem = dev_info.mem
        -- local dbg = dev_info.debug

        for sym, val in pairs(sym_6800) do
            dev_info.sym_tab:add(sym, val)
        end

        -- dump_info(dev_info.mem)
    end
end

local function process_frame() end
local function process_frame_done() end
local function on_reset()
end

local function init()
    emu.print_info("Reset " .. emu.gamename())

    local dev_info = get_dev_info(":soundcpu")

    if dev_info then
        local mem = dev_info.mem
        local dbg = dev_info.debug
        local irq = mem:read_u16(0xfff8)
        print(hex(irq))
    end
end

local function on_stop()
    emu.print_info("Exiting " .. emu.gamename())
end

local function pre_start()
    local gamename = emu.gamename()

    if gamename == "Stargate" then
        emu.print_info("Starting stargate plugin")

        init_symbols()
        init()

        emu.add_machine_reset_notifier(on_reset)
        emu.add_machine_stop_notifier(on_stop)
        emu.add_machine_frame_notifier(process_frame)
        emu.register_frame_done(process_frame_done)
        manager.machine:load("menu")
    else
        emu.print_info("Not starting plugin for " .. gamename)
    end
end

function exports.startplugin()
    emu.register_prestart(pre_start)
end

return exports
