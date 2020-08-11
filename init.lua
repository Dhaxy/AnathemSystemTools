-------------------------------------
-- Namespaces
-------------------------------------

local _, core = ...;

-------------------------------------
-- Libs
-------------------------------------

local ldb = LibStub:GetLibrary("LibDataBroker-1.1");
local icon = LibStub("LibDBIcon-1.0");

-------------------------------------
-- Global variables
-------------------------------------

AnathemUiVariablesPerCharacter = {
    minimapIconDb = {}
}

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

-------------------------------------
-- Handle Slash Commands
-------------------------------------

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


-------------------------------------
-- Simple Print
-------------------------------------

function core:Print(...)
    DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", ...));
end


-------------------------------------
-- Print with prefix
-------------------------------------

function core:PrintWithPrefix(...)
    local hex = select(4, self.Config:GetThemeColor());
    local prefix = string.format("|cff%s%s|r", hex:upper(), "Anathem System Tools:");	
    DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", prefix, ...));
end

-------------------------------------
-- Minimap button init
-------------------------------------

function core:InitMinimapButton(...)
    local dataobj = ldb:NewDataObject("AnathemSystemTools", {
        type = "data source",
        icon = "Interface\\AddOns\\AnathemSystemTools\\Icons\\Ability_Warrior_Revenge",
        text = "Anathem System Tools",
        OnClick = function(_, button)
            if button == "LeftButton" then
                core.Config.Toggle()
            end
        end,
        OnTooltipShow = function(tooltip) 
            tooltip:SetText("|cff00ccffAnathemSystemTools v.0.0.1|r");
            tooltip:AddLine("Cliquez pour ouvrir la fiche de personnage")
            tooltip:Show()
        end,
        OnMouseUp = function()
            if ldb and icon then
                icon:Refresh("AnathemSystemTools", AnathemUiVariablesPerCharacter.minimapIconDb);
            end
        end
    });

    if not AnathemUiVariablesPerCharacter.minimapIconDb then
        AnathemUiVariablesPerCharacter.minimapIconDb = {
            hide = false,
            minimapPos = 220,
            radius = 80
        }
    end

    icon:Register("AnathemSystemTools", dataobj, AnathemUiVariablesPerCharacter.minimapIconDb);
end

-------------------------------------
-- Addon init
-------------------------------------

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

    SLASH_AnathemSystemTools1 = "/ast";
    SlashCmdList.AnathemSystemTools = HandleSlashCommands;

    -------------------------------------
    -- Initialize minimap button
    -------------------------------------

    core:InitMinimapButton();

    -------------------------------------
    -- Print welcome text
    -------------------------------------

    core:PrintWithPrefix("Anathem system tools initialisés, bienvenue", UnitName("player").." !");
    core:PrintWithPrefix("From Droogz, with love |cffe82113<3|r. Add-on pour l'univers RP Anathem.")
end

local events = CreateFrame("Frame");
events:SetScript("OnEvent", core.init);
events:RegisterEvent("ADDON_LOADED");