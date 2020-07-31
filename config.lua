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
    local button = CreateFrame("Button", nil, UICharacterSheet.ScrollFrame, "GameMenuButtonTemplate");
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

function Config:CreateMenu()

    ----------------------------------
	-- Main Frame
	----------------------------------

	UICharacterSheet = CreateFrame("Frame", "AnathemCharacterSheet", UIParent, "BasicFrameTemplate");
	UICharacterSheet:SetSize(550, 600);
	UICharacterSheet:SetPoint("CENTER");
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

    local child = CreateFrame("Frame", nil, UICharacterSheet.ScrollFrame);
    child:SetSize(520, 540);
    UICharacterSheet.ScrollFrame:SetScrollChild(child);
    
    
    ----------------------------------
	-- Buttons
    ----------------------------------
    
    UICharacterSheet.saveButton = self:CreateButton("CENTER", child, "BOTTOM", 0, "Save");


	UICharacterSheet:Hide();
	return UICharacterSheet;
end