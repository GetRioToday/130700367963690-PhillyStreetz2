-- Aliases: "Glitch Account", "Data Freeze"
-- Purpose: Permanently applies a "bug" to your characters data, causing interferance with the experiences ability to save & load your data, causing a "rollback" to happen when you leave the experience, resulting in "infinite money".

-- Why it worked:
-- It is hard to say with absolute **100% certainty** without seeing:
-- 1. The script responsible for the logic of listening, validating, and storing the input from the sendData remote.
-- 2. The script responsible for the logic of loading the previously mentioned input data.

-- However, a reasonable assumption can be made:
-- 1. The "FirstName" is expected to exist and be valid. When the remote does not have it's data properly validated, it's possible for us to make it not exist (be null).
-- 2. The property not existing likely causes an error with the script responsible for loading all of your data. It is likely done in a protected call, or in a new thread (through a signal connection most likely), which prevents the script from being unable to process other players.
-- 3. Data that has been loaded (such as your money) will be unaffected, while anything that hasn't been loaded yet will never be loaded.
-- 4. The same process of #2 will likely be repeated on disconnection in reverse (attempting to save, instead of load).
-- While this is likely, it's not a fact, since the logic responsible for handling this data and the input of sendData is unknown.

-- Steps for Usage:
-- 1. Acquire an amount of money you are satisfied with.
-- 2. Enter the character creator through the Teleport service (or other means, such as setting the PlaceID in Roblox Account Manager)
-- 3. Execute the rollback script & finish the character creation process.
-- 4. Get escorted back to the primary game, where your username is now shown as "Loading name..."
-- You may now transfer money to other accounts using the experiences ATM system. Doing things like transferring funds, purchasing vehicles, or storing weapons in storage containers will no longer save once you disconnect.

-- Exploit history:
-- This exploit/vulnerability had a patch attempt on September 2nd, 2025 that failed due to the "patch" being done on the client using a "secret key", with zero server validation. It could be bypassed by obtaining the secret key through decompilation or with a metamethod hook, intercepting the call and replacing it with a bad payload instead of making the call yourself. Fortunately, we we're already doing it this way to preserve the users character creation choices.
-- A server semi-validation patch was released on September 6th, 2025 that fixed the "rollback" behavior. Despite this, the server still happily accepts bad input and will save it, causing your characters first name to still show as "Loading name..."
-- With this information in mind, the feature may be repurposed as a "Hide Username" feature: which can help prevent other clients from identifying the user as a cheater and reporting them.

-- Globals required:
-- 1. Features: A module responsible for tracking features, unexpected errors, managing their states, and other things.
-- 2. Thread: A wrapper library with self-explained behavior
-- 3. Teleporter: The "TeleportService"
-- 4. OFFLINE: Equivalent to the Luraph obfuscation macro "LPH_OBFUSCATED".
-- 5. Remotes: A module responsible for the security, management, and usage of Remote events & functions.
-- 6. Cache: A simple library to temporarily hold values in memory until they are no longer needed. Used as a permanent "debounce" here.
-- 7. Notify (optional): A function that shows the user a notification message.

Features.Create("Rollback", function(self)
	if game.PlaceId ~= 101606818845121 then
		self:Print("PlaceID mismatch detected; transferring server.")
		Notify("information", "You will be teleported shortly. Please re-activate this feature after teleporting.", 15)
		Thread.Sleep(not OFFLINE and 10000 or 1000)
		return Teleporter:Teleport(101606818845121)
	end

	local Remote = Remotes:Get("sendData")
	if not Cache.Get("Perm Rollback") then
		local Old;
		local Hook = newcclosure(function(...)
			local Args = {...}
			if Args[1] == Remote and not checkcaller() and getnamecallmethod() == "FireServer" then
				local Data = Args[2];
				Data["appearanceData"]["FirstName"] = null;

				self:Print("Successfully applied rollback to character, returning to main game")
				return Old(table.unpack(Args))
			end

			return Old(...)
		end)

		Cache.Set("Perm RollbackPerm", true)
    Remote:MarkHooked(Hook)
		Old = hookmetamethod(Remote, "__namecall", Hook)
	end

	Notify("success", "Please create a new character appearance to proceed.", 15)
end)
