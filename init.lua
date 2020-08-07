-------------------------------------
-- Namespaces
-------------------------------------

local _, core = ...;

-------------------------------------
-- Custom Slash Commands
-------------------------------------

core.commands = {
    ["config"] = core.Config.Toggle,

    ["aide"] = function()
        print(" ");
        core:Print("Liste de commandes:");
        core:Print("|cff00cc66/ast config|r - Ouvre le menu de configuration");
        core:Print("|cff00cc66/ast aide|r - Montre l'aide");
    end
};

local function HandleSlashCommands(str)
    if (#str == 0) then
        -- No args
        core.commands.aide();
        return;
    end

    local args = {}; -- args for looping
    for _, arg in pairs({ string.split(' ', str) }) do
        if (#arg > 0) then
            table.insert(args, arg)
        end
    end

    local path = core.commands; -- required for updating found table.

    for id, arg in ipairs(args) do
        arg = string.lower(arg);

        if (path[arg]) then
            if (type(path[arg]) == "function") then
                -- all remaining args passed to our function
                path[arg] (select(id + 1, unpack(args)));
                return;
            elseif (type(path[arg]) == "table") then
                path = path[arg]; -- sub table found
            else
                -- does not exist
                core.commands.help();
                return;
            end
        end
    end
end

function core:Print(...)
    local hex = select(4, self.Config:GetThemeColor());
    DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", ...));
end

function core:PrintWithPrefix(...)
    local hex = select(4, self.Config:GetThemeColor());
    local prefix = string.format("|cff%s%s|r", hex:upper(), "Anathem System Tools:");	
    DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", prefix, ...));
end

function core:init(event, name)
    if (name ~= "AnathemSystemTools") then return end

    -- allows using left and right arrows to move through chat while writing
    for i = 1, NUM_CHAT_WINDOWS do
        _G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode(false);
    end

    -------------------------------------
    -- Register slash commands
    -------------------------------------

    SLASH_RELOADUI1 = "/rl";
    SlashCmdList.RELOADUI = ReloadUI;

    SLASH_FRAMESTK1 = "/fs"; -- new slash command for showing framestack tool
	SlashCmdList.FRAMESTK = function()
		LoadAddOn("Blizzard_DebugTools");
		FrameStackTooltip_Toggle();
	end

    SLASH_AnathemSystemTools1 = "/ast";
    SlashCmdList.AnathemSystemTools = HandleSlashCommands;


    local ldb = LibStub:GetLibrary("LibDataBroker-1.1");
    local dataobj = ldb:NewDataObject("AnathemSystemTools", {
        type = "data source",
        icon = "",
        text = "Anathem System Tools",
        OnClick = function() print("BUNNIES ARE TAKING OVER THE WORLD") end,
    });

    local icon = LibStub("LibDBIcon-1.0");
    icon:Register("AnathemSystemTools", dataobj, minimapicondb);

    core:PrintWithPrefix("Anathem system tools initialisés, bienvenue", UnitName("player").." !");
    core:PrintWithPrefix("From Droogz, with love |cffe82113<3|r. Add-on pour l'univers RP Anathem.")
end

local events = CreateFrame("Frame");
events:RegisterEvent("ADDON_LOADED");
events:SetScript("OnEvent", core.init);