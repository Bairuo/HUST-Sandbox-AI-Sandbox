
require "AgentUtilities";

local leader;

function Agent_Cleanup(agent)
end

function Agent_HandleEvent(agent, event)
end

function Agent_Initialize(agent)
    AgentUtilities_CreateAgentRepresentation(
        agent, agent:GetHeight(), agent:GetRadius());

    -- Randomly assign a position to the agent.
    agent:SetPosition(
        Vector.new(math.random(10, 50), 0, math.random(-55, 8)));

    -- Assign the first valid agent as the leader to follow.
    local agents = Sandbox.GetAgents(agent:GetSandbox());
    for index = 1, #agents do
        if (agents[index] ~= agent) then
            leader = agents[index];
            break;
        end
    end
end

function Agent_Update(agent, deltaTimeInMillis)
    local deltaTimeInSeconds = deltaTimeInMillis / 1000;
    local sandboxAgents = Sandbox.GetAgents(agent:GetSandbox());

    -- Calculate a combining force so long as the leader stays
    -- within a 100 meter range from the agent, and has less than
    -- 180 degree difference in forward direction.
    local forceToCombine =
        Agent.ForceToCombine(agent, 100, 180, { leader } );

    -- Force to stay away from other agents that are closer than
    -- 2 meters and have less than 180 degree difference in forward
    -- direction.
    local forceToSeparate =
        Agent.ForceToSeparate(agent, 2, 180, sandboxAgents );

    -- Force to stay away from getting too close to the leader if
    -- within 5 meters of the leader and having a maximum forward
    -- degree difference of less than 45 degrees.
    local forceToAlign =
        Agent.ForceToSeparate(agent, 5, 45, { leader } );

    -- Summation of all separation and cohension forces.
    local totalForces =
        forceToCombine + forceToSeparate * 1.15 + forceToAlign;
    
    -- Apply all steering forces.
    AgentUtilities_ApplyPhysicsSteeringForce(
        agent, totalForces, deltaTimeInSeconds);
    AgentUtilities_ClampHorizontalSpeed(agent);
    
    local targetRadius = agent:GetTargetRadius();
    local position = agent:GetPosition();
    local destination = leader:GetPosition();
    
    -- Draw debug information for target and target radius.
    Core.DrawCircle(
        position, 1, Vector.new(1, 1, 0));
    Core.DrawCircle(
        destination, targetRadius, Vector.new(1, 0, 0));
    Core.DrawLine(position, destination, Vector.new(0, 1, 0));
end
