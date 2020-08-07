-------------------------------------
-- Namespaces
-------------------------------------
local _, core = ...;
core.Config = {};

local Config = core.Config;
local UICharacterSheet;


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
    local menu = UICharacterSheet or Config:CreateMenu();
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

    local scrollChild = UICharacterSheet.ScrollFrame:GetScrollChild();
    if (scrollChild) then
        scrollChild:Hide();
    end

    UICharacterSheet.ScrollFrame:SetScrollChild(self.content);
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

        tab.content = CreateFrame("Frame", nil, UICharacterSheet.ScrollFrame);
        tab.content:SetSize(520, 540);
        tab.content:Hide();

        table.insert(contents, tab.content);

        if (i == 1) then
            tab:SetPoint("TOPLEFT", UICharacterSheet, "BOTTOMLEFT", 5, 2);
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

    UICharacterSheet = CreateFrame("Frame", "AnathemCharacterSheet", UIParent, "BasicFrameTemplate");
    UICharacterSheet:SetSize(550, 600);
    UICharacterSheet:SetPoint("CENTER");
    UICharacterSheet:SetMovable(true);
    UICharacterSheet:EnableMouse(true);
    UICharacterSheet:RegisterForDrag("LeftButton");
    UICharacterSheet:SetScript("OnDragStart", UICharacterSheet.StartMoving);
    UICharacterSheet:SetScript("OnDragStop", UICharacterSheet.StopMovingOrSizing);
    UICharacterSheet.title = UICharacterSheet:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    UICharacterSheet.title:SetPoint("CENTER", UICharacterSheet.TitleBg, "CENTER", 6, 1);
    UICharacterSheet.title:SetText("Anathem Character Sheet");
    
    ----------------------------------
    -- Scroll Frame
    ----------------------------------

    UICharacterSheet.ScrollFrame = CreateFrame("ScrollFrame", nil, UICharacterSheet, "UIPanelScrollFrameTemplate");
    UICharacterSheet.ScrollFrame:SetPoint("TOPLEFT", UICharacterSheet.Bg, "TOPLEFT", 4, -8);
    UICharacterSheet.ScrollFrame:SetPoint("BOTTOMRIGHT", UICharacterSheet.Bg, "BOTTOMRIGHT", -3, 4);
    UICharacterSheet.ScrollFrame:SetClipsChildren(true);
    UICharacterSheet.ScrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel);

    UICharacterSheet.ScrollFrame.ScrollBar:ClearAllPoints();
    UICharacterSheet.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", UICharacterSheet.ScrollFrame, "TOPRIGHT", -12, -18);
    UICharacterSheet.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", UICharacterSheet.ScrollFrame, "BOTTOMRIGHT", -7, 18);

    local content1, content2, content3 = SetTabs(UICharacterSheet, 3, "Statistiques", "Compétences", "Configuration");
    
    
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

    UICharacterSheet:Hide();
    return UICharacterSheet;
end