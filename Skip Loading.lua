-- ⚠️ CAUTION! BAN RISK!
-- This script can possibly be detected due to the game having a secret key / offset passed to the "whitney" remote.
-- In the past, Philly has changed this secret key before to try and detect "Instant Respawn".
-- They have also changed the remotes name and created a decoy remote with the old name, meaning if you tried to fire the remote by it's old name, you got detected.
-- At the time of writing (2025/2/12), the script is currently undetected.

-- HERE'S A BETTER, AND FULLY UNDETECTED METHOD INSTEAD:
-- Their loadHandler script has an "Is Roblox Studio" check inside of it, so that way the game developers can skip the loading screen while coding.
-- This is a much better and undetected way - simply hook "IsStudio" function from RunService, check if "loadHandler" has called it, and return true.



local RF = cloneref(game:GetService("ReplicatedFirst"))
local Players = cloneref(game:GetService("Players"))
local SharedStorage = cloneref(game:GetService("ReplicatedStorage"))
local StarterGui = cloneref(game:GetService("StarterGui"))

local REMOTE_NAME = "whitney";
local REMOTE_OFFSET = 543439;

local LoadHandler = RF:WaitForChild("loadHandler")
LoadHandler:Destroy()

local LocalClient = Players.LocalPlayer;
while not LocalClient do
	Players.PlayerAdded:Wait()
	LocalClient = Players.LocalPlayer;
end

local PlayerGui = LocalClient:WaitForChild("PlayerGui")
local LoaderGui = PlayerGui:FindFirstChild("LoadingGUI")

if LoaderGui then
	LoaderGui:Destroy()
end

local SpawnRemote = SharedStorage:WaitForChild(REMOTE_NAME)
SpawnRemote:FireServer(REMOTE_OFFSET)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
