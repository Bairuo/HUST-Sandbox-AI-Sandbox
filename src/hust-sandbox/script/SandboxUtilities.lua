
function SandboxUtilities_CreateBox(sandbox, size, position)
    local box = Sandbox.CreateBox(sandbox, size, size, size, 0.5 * size, 0.5 * size);
    Core.SetPosition(box, position);
    Core.SetMaterial(box, "Ground2");
    Core.SetMass(box, 0);
    
    return box;
end


function SandboxUtilities_CreateLevel(sandbox)
    local level = {
        { 4, Vector.new(24, 2, -8), Vector.new(0, 0, 0) },
        { 4, Vector.new(24, 2, -4), Vector.new(0, 0, 0) },
        { 4, Vector.new(24, 2, 0), Vector.new(0, 0, 0) },
        { 4, Vector.new(24, 2, 4), Vector.new(0, 0, 0) },
        { 4, Vector.new(24, 2, 8), Vector.new(0, 0, 0) },
        { 2, Vector.new(20, 1, 15), Vector.new(0, 0, 0) },
        { 2, Vector.new(17, 1, 15), Vector.new(0, 0, 0) },
        { 2, Vector.new(15, 1, 15), Vector.new(0, 0, 0) },
        { 2, Vector.new(19, 3, 15), Vector.new(0, 0, 0) },
        { 2, Vector.new(17, 3, 15), Vector.new(0, 0, 0) },
        { 2, Vector.new(15, 3, 15), Vector.new(0, 0, 0) },
    }
    
    for index = 1, #level do
        local block = level[index];
        local box = SandboxUtilities_CreateBox(sandbox, block[1], block[2]);
        Core.SetRotation(box, block[3]);
    end
    
end
