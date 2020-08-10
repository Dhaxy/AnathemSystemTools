-------------------------------------
-- Namespaces
-------------------------------------
local _, core = ...;
core.Config = {};

local Config = core.Config;
local UiCharacterSheet;


-------------------------------------
-- Defaults
-------------------------------------

local defaults = {
    theme = {
        r = 0,
        g = 0.8,
        b = 1,
        hex = "00ccff"
    }
}

-------------------------------------
-- Config functions
-------------------------------------

function Config:Toggle()
    local menu = UiCharacterSheet or Config:CreateMenu();
    menu:SetShown(not menu:IsShown());
end

function Config:GetThemeColor()
	local c = defaults.theme;
	return c.r, c.g, c.b, c.hex;
end

function Config:CreateButton(point, relativeFrame, relativePoint, yOffset, text)
    local button = CreateFrame("Button", nil, relativeFrame, "GameMenuButtonTemplate");
    button:SetPoint(point, relativeFrame, relativePoint, 0, yOffset);
    button:SetSize(80, 40);
    button:SetText(text);
    button:SetNormalFontObject("GameFontNormalLarge");
    button:SetHighlightFontObject("GameFontHighlightLarge");
    return button; 
end

local function ScrollFrame_OnMouseWheel(self, delta)
	local newValue = self:GetVerticalScroll() - (delta * 20);
	
	if (newValue < 0) then
		newValue = 0;
	elseif (newValue > self:GetVerticalScrollRange()) then
		newValue = self:GetVerticalScrollRange();
	end
	
	self:SetVerticalScroll(newValue);
end

local function Tab_OnClick(self)
    PanelTemplates_SetTab(self:GetParent(), self:GetID());

    local scrollChild = UiCharacterSheet.ScrollFrame:GetScrollChild();
    if (scrollChild) then
        scrollChild:Hide();
    end

    UiCharacterSheet.ScrollFrame:SetScrollChild(self.content);
    self.content:Show();
end

local function SetTabs(frame, numTabs, ...)
    frame.numTabs = numTabs;
    local contents = {};
    local frameName = frame:GetName();

    for i = 1, numTabs do
        local tab = CreateFrame("Button", frameName.."Tab"..i, frame, "CharacterFrameTabButtonTemplate");
        tab:SetID(i);
        tab:SetText(select(i, ...));
        tab:SetScript("OnClick", Tab_OnClick);

        tab.content = CreateFrame("Frame", nil, UiCharacterSheet.ScrollFrame);
        tab.content:SetSize(520, 540);
        tab.content:Hide();

        table.insert(contents, tab.content);

        if (i == 1) then
            tab:SetPoint("TOPLEFT", UiCharacterSheet, "BOTTOMLEFT", 5, 2);
        else
            tab:SetPoint("TOPLEFT", _G[frameName.."Tab"..(i - 1)], "TOPRIGHT", -14, 0);
        end
    end

    Tab_OnClick(_G[frameName.."Tab1"]);

    return unpack(contents);
end

function Config:CreateMenu()

    ----------------------------------
    -- Main Frame
    ----------------------------------

    UiCharacterSheet = CreateFrame("Frame", "AnathemCharacterSheet", UIParent, "BasicFrameTemplate");
    UiCharacterSheet:SetSize(550, 600);
    UiCharacterSheet:SetPoint("CENTER");
    UiCharacterSheet:SetMovable(true);
    UiCharacterSheet:EnableMouse(true);
    UiCharacterSheet:RegisterForDrag("LeftButton");
    UiCharacterSheet:SetScript("OnDragStart", UiCharacterSheet.StartMoving);
    UiCharacterSheet:SetScript("OnDragStop", UiCharacterSheet.StopMovingOrSizing);
    UiCharacterSheet.title = UiCharacterSheet:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    UiCharacterSheet.title:SetPoint("CENTER", UiCharacterSheet.TitleBg, "CENTER", 6, 1);
    UiCharacterSheet.title:SetText("Anathem Character Sheet");
    
    ----------------------------------
    -- Scroll Frame
    ----------------------------------

    UiCharacterSheet.ScrollFrame = CreateFrame("ScrollFrame", nil, UiCharacterSheet, "UIPanelScrollFrameTemplate");
    UiCharacterSheet.ScrollFrame:SetPoint("TOPLEFT", UiCharacterSheet.Bg, "TOPLEFT", 4, -8);
    UiCharacterSheet.ScrollFrame:SetPoint("BOTTOMRIGHT", UiCharacterSheet.Bg, "BOTTOMRIGHT", -3, 4);
    UiCharacterSheet.ScrollFrame:SetClipsChildren(true);
    UiCharacterSheet.ScrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel);

    UiCharacterSheet.ScrollFrame.ScrollBar:ClearAllPoints();
    UiCharacterSheet.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", UiCharacterSheet.ScrollFrame, "TOPRIGHT", -12, -18);
    UiCharacterSheet.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", UiCharacterSheet.ScrollFrame, "BOTTOMRIGHT", -7, 18);

    local content1, content2, content3 = SetTabs(UiCharacterSheet, 3, "Statistiques", "Compétences", "Configuration");
    
    
    ----------------------------------
    -- content 1
    ----------------------------------

    ----------------------------------
	-- Buttons
    ----------------------------------
    
    content1.saveButton = self:CreateButton("CENTER", content1, "BOTTOM", 0, "Save");


    ----------------------------------
    -- content 2
    ----------------------------------


    ----------------------------------
    -- content 3
    ----------------------------------

    UiCharacterSheet:Hide();
    return UiCharacterSheet;
end