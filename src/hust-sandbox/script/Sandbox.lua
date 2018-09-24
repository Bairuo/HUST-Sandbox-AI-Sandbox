require "DebugUtilities";
require "GUI";

local ui;

local path = {
    Vector.new(-117.93, 0, -61),
    Vector.new(-9.77, 0, -65.78),
    Vector.new(-7.04, 0, -107.44),
    Vector.new(57.71, 0, -112.18),
    Vector.new(57.50, 0, -73.20),
    Vector.new(126.38, 0, -71.84),
    Vector.new(126.20, 0, -12.73),
    Vector.new(55.49, 0, 16.61),
    Vector.new(16.89, 0, 66.88),
    Vector.new(-36.64, 0, 63.38),
    Vector.new(-39.03, 0, 9.50),
    Vector.new(-38.38, 0, -61.06)
};

local function CreateSandboxText(sandbox)
    -- Create a UI component to display text on.
    ui = Sandbox.CreateUIComponent(sandbox, 1);
    local width = Sandbox.GetScreenWidth(sandbox);
    local height = Sandbox.GetScreenHeight(sandbox);
    local uiWidth = 300;
    local uiHeight = 180;
    
    UI.SetPosition(ui, width - uiWidth - 20, height - uiHeight - 35);
    UI.SetDimensions(ui, uiWidth, uiHeight);
    UI.SetTextMargin(ui, 10, 10);
    GUI_SetGradientColor(ui);

    UI.SetMarkupText(
        ui,
        GUI.MarkupColor.White .. GUI.Markup.SmallMono ..
        "W/A/S/D: to move" .. GUI.MarkupNewline ..
        "Hold Shift: to accelerate movement" .. GUI.MarkupNewline ..
        GUI.MarkupNewline ..
        GUI.MarkupNewline ..
        "F1: to reset the camera" .. GUI.MarkupNewline ..
        "F2: toggle the menu" .. GUI.MarkupNewline ..
        "F5: toggle performance information" .. GUI.MarkupNewline ..
        "F6: toggle camera information" .. GUI.MarkupNewline ..
        "F7: toggle physics debug");
end

function Sandbox_Cleanup(sandbox)
end

function Sandbox_HandleEvent(sandbox, event)
    -- Pass events into the UI system.
    GUI_HandleEvent(sandbox, event);

    if (event.source == "keyboard" and event.pressed) then
        if (event.key == "f1_key") then
            Sandbox.SetCameraPosition(sandbox, Vector.new(34.15, 96.88, 132.72));
            Sandbox.SetCameraOrientation(sandbox, Vector.new(-35.49, 7.18, 5.27));
        elseif (event.key == "f2_key") then
            UI.SetVisible(ui, not UI.IsVisible(ui));
        end
    end
end

function Sandbox_Initialize(sandbox)
    -- Caching a resource prevents a slowdown when the mesh/material/etc is
    -- first encountered.
    Core.CacheResource("models/nobiax_modular/modular_block.mesh");

    GUI_CreateUI(sandbox);
    CreateSandboxText(sandbox);
    
    Sandbox.SetCameraPosition(sandbox, Vector.new(34.15, 96.88, 132.72));
    Sandbox.SetCameraOrientation(sandbox, Vector.new(-35.49, 7.18, 5.27));

    Sandbox.CreateSkyBox(
        sandbox, "ThickCloudsWaterSkyBox", Vector.new(0, 180, 0));

    local plane = Sandbox.CreatePlane(sandbox, 240, 280);
    Core.SetMaterial(plane, "Ground2");


    Sandbox.SetAmbientLight(sandbox, Vector.new(0.3));
    local directional = Core.CreateDirectionalLight(sandbox, Vector.new(1, -1, 1));

    -- Color is represented by a red, green, and blue vector.
    Core.SetLightDiffuse(directional, Vector.new(1.8, 1.4, 0.9));
    Core.SetLightSpecular(directional, Vector.new(1.8, 1.4, 0.9));


    Sandbox.CreateAgent(sandbox, "SeekingAgent.lua");
    Sandbox.CreateAgent(sandbox, "SeekingAgent1.lua");

    for i=1, 7 do
        Sandbox.CreateAgent(sandbox, "FollowerAgent.lua");
    end

    for i=1, 7 do
        Sandbox.CreateAgent(sandbox, "FollowerAgent1.lua");
    end

    for i=1, 26 do
        local agent = Sandbox.CreateAgent(sandbox, "PathingAgent.lua");
        
        agent:SetPath(path, true);

        local randomSpeed = math.random(
            agent:GetMaxSpeed() * 0.85,
            agent:GetMaxSpeed() * 1.15);

        agent:SetMaxSpeed(randomSpeed);
    end
    
    Core.CreateMesh(sandbox, "models/hust.mesh");

end

function Sandbox_Update(sandbox, deltaTimeInMillis)
    GUI_UpdateUI(sandbox);

    local objects = Sandbox.GetObjects(sandbox);
    DebugUtilities_DrawDynamicBoundingSpheres(objects);
end
