-------------------->> Execution Check <<--------------------
local scriptHttp = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/teteRoar/FaithIncremental/refs/heads/main/v3.0.1.lua", true))()'

if game.PlaceId ~= 94264573845314 then
    warn("Please execute this script in the correct game, 'Faith Incremental'! | PlaceId: 94264573845314")
    return
end
pcall(function () getgenv().Destroy() end)

-------------------->> Loading Starts <<--------------------

local LoadingTime = DateTime.now().UnixTimestamp
print("-------------------->> Loading GigaHub: Faith Incremental <<--------------------")
print("Loading Start Time: 0")
repeat task.wait() until game:IsLoaded()

local function PrintTable(table, indent)
    if typeof(table) == "table" then
        task.wait()
        indent = indent or 0
        local spacing = string.rep("    ", indent)

        print(spacing .. "{")

        for key, value in pairs(table) do
            task.wait()
            if type(value) == "table" then
                task.wait()
                print(spacing .. "    " .. tostring(key) .. " = ")
                PrintTable(value, indent + 1)
            else
                task.wait()
                print(spacing .. "    " .. tostring(key) .. " = " .. tostring(value) .. ";")
            end
        end

        print(spacing .. "}")
    else
        print(table)
    end
end

-------------------->> Services <<--------------------

local cloneref = cloneref or function (...)
	return ...
end

local Services = setmetatable({}, {
	__index = function(self, service)
		return cloneref(game:FindService(service)) or cloneref(game:GetService(service)) or cloneref(game:service(service))
	end
})

local gethui = gethui or function ()
    return Services.CoreGui
end

local Players             = Services.Players
local Work                = Services.Workspace
local CoreGui             = Services.CoreGui
local RunService          = Services.RunService
local TweenService        = Services.TweenService
local UserInputService    = Services.UserInputService
local ReplicatedStorage   = Services.ReplicatedStorage

-------------------->> Variables <<--------------------

local Player    = Players.LocalPlayer

local Boards  = Work.Boards
local Temples = Work.Temples
local Trees   = Work.Trees

local DPBoards = Temples.DivineUpgrades
local EliteSpawnBoard = Boards.Zone4.EliteSpawner.EliteSpawnBoard
local SpawnButton     = EliteSpawnBoard.Container.UnlockedContent.SpawnButton

-- local RebirthBoard  = Boards.Zone1.Rebirth.UpgradeBoardUI
-- local RebirthButton = RebirthBoard.Frame.Content.ButtonContainer.RebirthButton

local BossPlatforms = Work.Trials.BossFight.Charges

-- local Underworld   = Work.Underworld
-- local Underworld_1 = Underworld.Underworld_1
-- local Tower        = Underworld_1.Tower
-- local Radiances    = Tower.Radiances

local gameServices             = ReplicatedStorage.Services
local serviceTable             =
{   EmberServiceClient         = require(gameServices.EmberService.EmberServiceClient);
    ReincarnationServiceClient = require(gameServices.ReincarnationService.ReincarnationServiceClient);
    RelicServiceClient         = require(gameServices.RelicService.RelicServiceClient);
    AscensionServiceClient     = require(gameServices.AscensionService.AscensionServiceClient);
    PopupServiceClient         = require(gameServices.PopupService.PopupServiceClient);
    StatServiceClient          = require(gameServices.StatService.StatServiceClient);
    TrialShopServiceClient     = require(gameServices.TrialShopService.TrialShopServiceClient);
    TempleServiceClient        = require(gameServices.TempleService.TempleServiceClient);
    TempleBoardServiceClient   = require(gameServices.TempleBoardService.TempleBoardServiceClient);
    UpgradeBoardServiceClient  = require(gameServices.UpgradeBoardService.UpgradeBoardServiceClient);
    UpgradeTreeServiceClient   = require(gameServices.UpgradeTreeService.UpgradeTreeServiceClient);   }
local StatServiceClient        = serviceTable.StatServiceClient

local modules   = ReplicatedStorage.modules
local constants = modules.constants
local schemas   = modules.schemas
local net       = modules.net
local Packets   = require(net.Packets)

local GameEnum  = require(constants.GameEnum)
local ZoneId    = GameEnum["ZoneId"]
local TempleId  = GameEnum["TempleId"]
local BoardId   = GameEnum["BoardId"]
--local UpgradeId = GameEnum["UpgradeId"]

local UpgradeBoards = require(schemas.UpgradeBoards)

local ui = ReplicatedStorage.ui
local styles = ui.styles

local theme = require(styles.Theme)

local Normal = {
    FarmSpirits = false;
    autoSpawnEliteSpirit = false;
    FarmBossSpirit = false;
    FarmSurge = false;
    autoReincarnate = false;
    autoClickRelic = false;

    autoZone1 = false;
    autoZone2 = false;
    autoZone3NoEliteSouls = false;
    autoZone3EliteSouls = false;

    autoSoulTemple = false;
    autoRelicTemple = false;
    autoBibleTemple = false;
    autoSoulDPBoard = false;
    autoRelicDPBoard = false;
    autoBibleDPBoard = false;
    autoDepositMainTemple = false;
    
    autoHellStairsNodes = false;
    autoStairwayNodes = false;

    autoUnderworld = false;
    autoUnderworld2 = false;

    autoBuyTrialShop = false;
    autoRadianceBoostWhenMax = false;
    autoAscend = false;
    rebirthIfUnAff = false;
    spiritsPaused = false;
    surgePaused = false;

    Connections = {};
}

-------------------->> Settings <<--------------------

do
    getgenv().Settings = Normal
    getgenv().Debugger = true

    getgenv().Destroy = function ()
        local DisconnectCounter = 0

        print("-------------------->> Destroying Old Gui <<--------------------")
        for i, v in pairs(CoreGui:GetDescendants()) do
            if v.Name == "Incremental-Farm-Toggle" then
                v:Destroy()
                print("Destroying Old Gui: {"..v:GetFullName().."}")
            end
        end

        print("-------------------->> Disconnecting Functions <<--------------------")
        for i, v in pairs(getgenv().Settings.Connections) do
            if typeof(v) == 'RBXScriptConnection' then
                v:Disconnect()
                DisconnectCounter += 1
                print("Disconnected ", i)
            else
                pcall(function()
                    v:Disconnect()
                    DisconnectCounter += 1
                    print("Disconnected ", i)
                end)
            end
        end

        table.clear(getgenv().Settings.Connections)
        print("Disconnected ", DisconnectCounter, " Function (s)")
        
        print("-------------------->> Setting back to Normal <<--------------------")
        getgenv().Settings = Normal
        getgenv().Settings.autoBuyTrialShop         = false;
        getgenv().Settings.autoRadianceBoostWhenMax = false;
        getgenv().Settings.autoAscend               = false;
        getgenv().Settings.FarmSpirits              = false
        getgenv().Settings.autoSpawnEliteSpirit     = false
        getgenv().Settings.FarmBossSpirit           = false
        getgenv().Settings.FarmSurge                = false
        getgenv().Settings.autoReincarnate          = false;
        getgenv().Settings.autoClickRelic           = false;
        getgenv().Settings.autoZone1                = false;
        getgenv().Settings.autoZone2                = false;
        getgenv().Settings.autoZone3NoEliteSouls    = false;
        getgenv().Settings.autoZone3EliteSouls      = false;
        getgenv().Settings.autoSoulTemple           = false;
        getgenv().Settings.autoRelicTemple          = false;
        getgenv().Settings.autoBibleTemple          = false;
        getgenv().Settings.autoSoulDPBoard          = false;
        getgenv().Settings.autoRelicDPBoard         = false;
        getgenv().Settings.autoBibleDPBoard         = false;
        getgenv().Settings.autoDepositMainTemple    = false;
        getgenv().Settings.autoHellStairsNodes      = false;
        getgenv().Settings.autoStairwayNodes        = false;
        getgenv().Settings.autoUnderworld           = false;
        getgenv().Settings.autoUnderworld2          = false;
        PrintTable(getgenv().Settings)
    end
end

-------------------->> Functions <<--------------------

local functions = {}

do
    function functions.CreateTW(Object, Info, Properties)
        local Success, result = pcall(function ()
            return TweenService:Create(Object, Info, Properties)
        end)

        if Success == true then
            return result
        end
    end

    function functions.DebugPrint(...)
        if getgenv().Debugger ~= true then return end

        print(...)
    end

    function functions.DebugAssert(...)
        if getgenv().Debugger ~= true then return end

        assert(...)
    end

    function functions.Validate(defaults, options)
        if typeof(options) == typeof(defaults) then
            for i,v in pairs(defaults) do
                if options[i] == nil then -- removed or typeof(options[i]) ~= typeof(v)
                    options[i] = v
                end
            end
        else
            options = defaults
        end
        return options
    end

    function functions.getAttribute(checkObject:Instance, attribute: string, lowerString: boolean?)
        if typeof(checkObject) ~= "Instance" or typeof(attribute) ~= "string" then return end
        local value = checkObject:GetAttribute(attribute)

        if typeof(value) == "string" and lowerString == true then
            return string.lower(value)
        end

        return value
    end

    function functions.NewConnection(Identifier, Connection)
        functions.DebugAssert(typeof(Identifier) == 'string', ("Expected 'string' got '%s'!"):format(typeof(Identifier)))
        functions.DebugAssert(getgenv().Settings.Connections[Identifier] == nil, ("Connection with Identifier, '%s' was already made!"):format(Identifier))
        functions.DebugAssert(typeof(Connection) == 'RBXScriptConnection' or typeof(Connection) == 'table', ("Expected 'RBXScriptConnection' or 'table' got '%s'!"):format(typeof(Connection)))

        getgenv().Settings.Connections[Identifier] = Connection
        functions.DebugPrint("Made a new connection for "..Identifier)
    end

    function functions.ConnectionExists(Identifier)
        functions.DebugAssert(typeof(Identifier) == 'string', ("Expected 'string' got '%s'!"):format(typeof(Identifier)))

        return getgenv().Settings.Connections[Identifier] ~= nil
    end

    function functions.DestroyConnection(Identifier)
        functions.DebugAssert(typeof(Identifier) == 'string', ("Expected 'string' got '%s'!"):format(typeof(Identifier)))
        functions.DebugAssert(getgenv().Settings.Connections[Identifier] ~= nil, ("'%s' was not found in the Connections table!"):format(Identifier))

        getgenv().Settings.Connections[Identifier]:Disconnect()
        getgenv().Settings.Connections[Identifier] = nil
        functions.DebugPrint("Destroyed connection for "..Identifier)
    end

    function functions.GetHumanoid()
        local Character = Player.Character
        local Humanoid = Character:FindFirstChild("Humanoid")

        if Humanoid ~= nil and Humanoid.Health > 0 then
            return Character.Humanoid
        end
    end

    function functions.GetHumanoidRootPart()
        local Character = Player.Character
        local Humanoid = functions.GetHumanoid()

        if Humanoid ~= nil and Humanoid.Health > 0 then
            return Character.HumanoidRootPart
        end
    end

    function functions.GetLastCFrame()
        local Character = Player.Character
        local Humanoid = functions.GetHumanoid()

        if Humanoid ~= nil and Humanoid.Health > 0 then
            return Character.HumanoidRootPart.CFrame
        end
    end
end

-------------------->> game functions <<--------------------

local gameFunctions = {}

do
    function gameFunctions.getBoss()
        return if Work:FindFirstChild("BossSpiritBoss") then Work.BossSpiritBoss else nil
    end

    function gameFunctions.getBossPlatform()
        if gameFunctions.getBoss() == nil then return nil end

        for i, v in pairs(BossPlatforms:GetChildren()) do
            if v:IsA("Part") and v:FindFirstChild("TouchInterest") ~= nil then
                return v
            end
        end

        return nil
    end

    function gameFunctions.getSpirit()
        for i, v in pairs(Work:GetChildren()) do
            if v:IsA("Model") and string.lower(v.Name):match("spirit") ~= nil and (v:FindFirstChild("HealthBar") ~= nil or v:FindFirstChild("EliteAura") ~= nil) then
                return v
            end
        end

        return nil
    end
end

-------------------->> get ids <<--------------------

local idFunctions = {}

do
    function idFunctions.getZoneId(object)
        return functions.getAttribute(object, "ZoneId")
    end 

    function idFunctions.getTempleId(object)
        return functions.getAttribute(object, "TempleId")
    end

    function idFunctions.getBoardId(object)
        return functions.getAttribute(object, "BoardId")
    end

    function idFunctions.getTreeId(object)
        return functions.getAttribute(object, "TreeId")
    end

    function idFunctions.getNodeId(object)
        return functions.getAttribute(object, "NodeId")
    end
end

-------------------->> Theme <<--------------------

local themeFunctions = {}

do
    function themeFunctions.getCurrencyColor(currency: string)
        return theme.getCurrencyColor(currency)
    end

    function themeFunctions.getNodeColor(nodeId: string)
        return theme.getNodeColor(nodeId)
    end
end

-------------------->> EmberServiceClient <<--------------------

local EmberServiceClient = serviceTable.EmberServiceClient
local emberServiceFunctions = {}

do
    function emberServiceFunctions.isSurgeActive()
        return EmberServiceClient.IsSurgeActive()
    end

    function emberServiceFunctions.getSurgePosition()
        return EmberServiceClient.GetSurgePosition()
    end

    function emberServiceFunctions.IsPlayerInSurge()
        return EmberServiceClient.IsPlayerInSurge()
    end

    function emberServiceFunctions.getSurgeTimeRemaining()
        return EmberServiceClient.GetSurgeTimeRemaining()
    end

    function emberServiceFunctions.RequestActivateRadiance()
        EmberServiceClient.RequestActivateRadiance()
    end

    function emberServiceFunctions.GetRadianceCharges()
        return EmberServiceClient.GetRadianceCharges()
    end

    function emberServiceFunctions.GetRadianceMaxCharges()
        return EmberServiceClient.GetRadianceMaxCharges()
    end
end

-------------------->> ReincarnationServiceClient <<--------------------

local ReincarnationServiceClient = serviceTable.ReincarnationServiceClient
local reincarnationServiceFunctions = {}

do
    function reincarnationServiceFunctions.reincarnationIsMaxed()
        return ReincarnationServiceClient.IsMaxed()
    end

    function reincarnationServiceFunctions.RequestReincarnation()
        ReincarnationServiceClient.RequestReincarnation()
    end
end

-------------------->> AscensionServiceClient <<--------------------

local AscensionServiceClient = serviceTable.AscensionServiceClient
local ascensionServiceFunctions = {}

do
    function ascensionServiceFunctions.RequestAscension()
        AscensionServiceClient.RequestAscension()
    end

    function ascensionServiceFunctions.GetAPPreview()
        return AscensionServiceClient.GetAPPreview()
    end
end

-------------------->> RelicServiceClient <<--------------------

local RelicServiceClient = serviceTable.RelicServiceClient
local relicServiceFunctions = {}

do
    function relicServiceFunctions.relicClick()
        RelicServiceClient.Click()
        --Packets.RelicClick:Fire({})
    end
end

-------------------->> PopupServiceClient <<--------------------

local PopupServiceClient = serviceTable.PopupServiceClient
local popupServiceFunctions = {}

do
    function popupServiceFunctions.show(options)
        options = functions.Validate({
            Text = "This is a test popup!";
            Duration = 5;
            ButtonText = "";
            ButtonAction = nil;
        }, options)
        
        PopupServiceClient.Show(options)
    end
end

-------------------->> TrialShopServiceClient <<--------------------

local TrialShopServiceClient = serviceTable.TrialShopServiceClient
local trialShopServiceFunctions = {}

do
    function trialShopServiceFunctions.getAllStock()
        return TrialShopServiceClient.GetAllStock()
    end

    function trialShopServiceFunctions.isMaxLevel(id)
        return TrialShopServiceClient.IsMaxLevel(id)
    end

    function trialShopServiceFunctions.RequestPurchase(id)
        TrialShopServiceClient.RequestPurchase(id)
        --[[
        Packets.RequestTrialShopPurchase:Fire({
            ["ItemId"] = id
        })
        ]]
    end

    function trialShopServiceFunctions.buyOutTrialShop()
        local stock = trialShopServiceFunctions.getAllStock()

        for id, amount in pairs(stock) do
            if trialShopServiceFunctions.isMaxLevel(id) == false then
                for i = 1, amount do
                    trialShopServiceFunctions.RequestPurchase(id)
                end
            end
        end
    end
end

-------------------->> TempleServiceClient <<--------------------

local TempleServiceClient = serviceTable.TempleServiceClient
local templeServiceFunctions = {}

do
    function templeServiceFunctions.getTempleLevel(id)
        return TempleServiceClient.GetTempleLevel(id)
    end

    function templeServiceFunctions.getDivinePowerBoardLevel(id)
        return TempleServiceClient.GetDivinePowerBoardLevel(id)
    end

    function templeServiceFunctions.isTempleBuilt(id)
        return TempleServiceClient.IsTempleBuilt(id)
    end

    function templeServiceFunctions.getTempleConfig(id)
        return TempleServiceClient.GetTempleConfig(id)
    end

    function templeServiceFunctions.getDivinePowerBoardConfig(id)
        return TempleServiceClient.GetDivinePowerBoardConfig(id)
    end

    function templeServiceFunctions.areAllCurrencyTemplesCompleted()
        return TempleServiceClient.AreAllCurrencyTemplesCompleted()
    end

    function templeServiceFunctions.requestBuildTemple(id)
        TempleServiceClient.RequestBuildTemple(id)
        --[[
        Packets.RequestBuildTemple:Fire({
            ["TempleId"] = id
        })
        ]]
    end

    function templeServiceFunctions.requestUpgradeTemple(id, amount)
        TempleServiceClient.RequestUpgradeTemple(id, amount)
        --[[
        Packets.RequestUpgradeTemple:Fire({
            ["TempleId"] = id,
            ["Amount"] = amount == nil and 1 or amount
        })
        ]]
    end

    function templeServiceFunctions.requestUpgradeDPBoard(id, amount)
        TempleServiceClient.RequestUpgradeDPBoard(id, amount)
        --[[
        Packets.RequestUpgradeDivinePowerBoard:Fire({
            ["BoardId"] = id,
            ["Amount"] = amount == nil and 1 or amount
        })
        ]]
    end

    function templeServiceFunctions.requestDeposit(currency, percentage)
        TempleServiceClient.RequestDeposit(currency, percentage)
        --[[
        Packets.RequestDepositToMainTemple:Fire({
            ["Currency"] = currency,
            ["Percentage"] = percentage
        })
        ]]
    end

    function templeServiceFunctions.purchaseMaxTemple(mod: Model)
        local templeId = idFunctions.getTempleId(mod)

        if templeId ~= nil then
            local BuyMaxButton = (function()
                for _, but in ipairs(mod:GetDescendants()) do
                    if but:IsA("TextButton") and but.Name:lower() == "buymaxbutton" then
                        return but
                    end
                end

                return nil
            end)()

            if BuyMaxButton ~= nil then
                if typeof(firesignal) == "function" then
                    firesignal(BuyMaxButton.Activated)
                end
            else
                templeServiceFunctions.requestUpgradeTemple(templeId, 1)
            end
        end
    end

    function templeServiceFunctions.purchaseMaxDPBoard(part: Part)
        local boardId = idFunctions.getBoardId(part)

        if boardId ~= nil then
            local BuyMaxButton = (function()
                for _, but in ipairs(part:GetDescendants()) do
                    if but:IsA("TextButton") and but.Name:lower() == "buymaxbutton" then
                        return but
                    end
                end

                return nil
            end)()

            if BuyMaxButton ~= nil then
                if typeof(firesignal) == "function" then
                    firesignal(BuyMaxButton.Activated)
                end
            else
                templeServiceFunctions.requestUpgradeDPBoard(boardId, 1)
            end
        end
    end

    function templeServiceFunctions.depositAll()
        local currencies = {
            "Faith",
            "Rebirths",
            "Bible",
            "Relics",
            "Souls",
            "EliteSouls",
            "Sigils"
        }

        for _, v in ipairs(currencies) do
            templeServiceFunctions.requestDeposit(v, 100)
        end
    end
end

-------------------->> UpgradeBoardServiceClient <<--------------------

local UpgradeBoardServiceClient = serviceTable.UpgradeBoardServiceClient
local upgradeBoardServiceFunctions = {}

do
    function upgradeBoardServiceFunctions.boardRequestPurchase(zone, id, amount)
        UpgradeBoardServiceClient.RequestPurchase(zone, id, amount)
        --[[
        Packets.PurchaseUpgrade:Fire({
            ["ZoneId"] = zone,
            ["BoardId"] = id,
            ["UpgradeId"] = id,
            ["Amount"] = amount
        })
        ]]
    end

    function upgradeBoardServiceFunctions.isBoardTypeValid(boardType)
        return boardType ~= "Rebirth" and boardType ~= "Reincarnation" and boardType ~= "Clicker"
    end

    function upgradeBoardServiceFunctions.purchaseBoards(t: {Part})
        if typeof(t) ~= "table" then return end

        for _, v in pairs(t) do
            local zoneId = idFunctions.getZoneId(v)
            local boardId = idFunctions.getBoardId(v)

            if zoneId ~= nil and boardId ~= nil then
                if v:FindFirstChild("UpgradeBoardUI") then
                    pcall(function()
                        -- local boardUI = v:FindFirstChild("UpgradeBoardUI")
                        -- local fr = boardUI.Frame
                        -- local content = fr.Content
                        -- local title = (function()
                        --     for _, v in ipairs(content:GetDescendants()) do
                        --         if v:IsA("TextLabel") and v.Name:lower() == "title" then
                        --             return v
                        --         end
                        --     end
                        -- end)()

                        -- if title == nil then return 0 end
                        -- local text = title.TextRow["1"].Text

                        --local text = "Upgrades: 62/250"
                        -- local splitOne = text:split("Upgrades: ")
                        -- local splitTwo = splitOne[2]:split("/")
                        -- local currentLevel = tonumber(splitTwo[1])
                        --local maxLevel = tonumber(splitTwo[2])

                        local BuyMaxButton = (function()
                            for _, but in ipairs(v:GetDescendants()) do
                                if but:IsA("TextButton") and but.Name:lower() == "buymaxbutton" then
                                    return but
                                end
                            end

                            return nil
                        end)()

                        if BuyMaxButton ~= nil then
                            if typeof(firesignal) == "function" then
                                firesignal(BuyMaxButton.Activated)
                            end
                        else
                            boardRequestPurchase(zoneId, boardId, 1)
                        end
                    end)
                end
            end
        end
    end
end

-------------------->> UpgradeTreeServiceClient <<--------------------

local UpgradeTreeServiceClient = serviceTable.UpgradeTreeServiceClient
local upgradeTreeServiceFunctions = {}

do
    function upgradeTreeServiceFunctions.treeRequestPurchase(zone, tree, node)
        UpgradeTreeServiceClient.RequestPurchase(zone, tree, node)
        --[[
        Packets.PurchaseTreeNode:Fire({
            ["ZoneId"] = zone,
            ["TreeId"] = tree,
            ["NodeId"] = node
        })
        ]]
    end

    function upgradeTreeServiceFunctions.isNodeVisible(zone, tree, node)
        return UpgradeTreeServiceClient.IsNodeVisible(zone, tree, node)
    end

    function upgradeTreeServiceFunctions.isNodePurchased(zone, tree, node)
        return UpgradeTreeServiceClient.IsNodePurchased(zone, tree, node)
    end

    function upgradeTreeServiceFunctions.isNodeHidden(zone, tree, node)
        return UpgradeTreeServiceClient.IsNodeHidden(zone, tree, node)
    end

    function upgradeTreeServiceFunctions.purchaseUnderworldNode(node)
        upgradeTreeServiceFunctions.treeRequestPurchase(ZoneId.Underworld, "CorruptionTree", node)
    end

    function upgradeTreeServiceFunctions.canPurchaseNode(zoneId, treeId, nodeId)
        if upgradeTreeServiceFunctions.isNodePurchased(zoneId, treeId, nodeId) == true or upgradeTreeServiceFunctions.isNodeHidden(zoneId, treeId, nodeId) == true or upgradeTreeServiceFunctions.isNodeVisible(zoneId, treeId, nodeId) == false then
            return false
        end

        return true
    end

    function upgradeTreeServiceFunctions.isNodeColorCurrency(object: BasePart, currency: string)
        if themeFunctions.getNodeColor(currency) == object.Color then
            return true
        end

        if currency == GameEnum.Currency.Embers then
            if object.Color == Color3.fromRGB(180, 50, 50) then
                return true
            end
        end

        return false
    end

    function upgradeTreeServiceFunctions.checkNodeAvailable(object: Model, underworld: boolean?)
        local zoneId = idFunctions.getZoneId(object)
        local treeId = idFunctions.getTreeId(object)
        local nodeId = idFunctions.getNodeId(object)

        if underworld == true then
            zoneId = ZoneId.Underworld
            treeId = "CorruptionTree"
        end

        if zoneId == nil or treeId == nil or nodeId == nil then
            return false
        end

        if upgradeTreeServiceFunctions.canPurchaseNode(zoneId, treeId, nodeId) == true then
            return true
        end

        return false
    end

    function upgradeTreeServiceFunctions.purchaseNodes(t: {Model}, underworld: boolean?)
        if typeof(t) ~= "table" then return end

        for _, v in ipairs(t) do
            local zoneId = idFunctions.getZoneId(v)
            local treeId = idFunctions.getTreeId(v)
            local nodeId = idFunctions.getNodeId(v)

            if underworld == true then
                upgradeTreeServiceFunctions.purchaseUnderworldNode(nodeId)
            else
                upgradeTreeServiceFunctions.treeRequestPurchase(zoneId, treeId, nodeId)
            end
        end
    end
end

-------------------->> Functions continued <<--------------------

do
    function functions.rebirth()
        -- if typeof(firesignal) == "function" then
        --     firesignal(RebirthButton.Activated)
        -- end
        upgradeBoardServiceFunctions.boardRequestPurchase(ZoneId.Zone1_Church, "Rebirth", 1)
    end

    function functions.spawnElite()
        if typeof(firesignal) == "function" then
            firesignal(SpawnButton.MouseButton1Click)
        end
    end

    function functions.GetTextFromSetting(Setting)
        functions.DebugAssert(typeof(Setting) == 'string', ("Expected 'string' got '%s'!"):format(typeof(Setting)))

        if getgenv().Settings[Setting] ~= nil then
            return tostring(getgenv().Settings[Setting])
        end

        return ""
    end

    function functions.SetSetting(Setting, Value)
        functions.DebugAssert(typeof(Setting) == 'string', ("Expected 'string' got '%s'!"):format(typeof(Setting)))
        functions.DebugAssert(Value ~= nil, "Value cannot be 'nil'!")

        if getgenv().Settings[Setting] ~= nil then
            getgenv().Settings[Setting] = Value
        end
    end

    function functions.GetSetting(Setting)
        functions.DebugAssert(typeof(Setting) == 'string', ("Expected 'string' got '%s'!"):format(typeof(Setting)))

        if getgenv().Settings[Setting] ~= nil then
            return getgenv().Settings[Setting]
        end

        return nil
    end

    function functions.Draggable(DragFrame, DragBoundary, dragDuration)
        if DragBoundary == nil or DragFrame == nil then return end

        local dragToggle = nil
        local dragSpeed = dragDuration or 0.25
        local dragStart = nil
        local startPos = nil

        local leadFrame = Instance.new('Frame')
        leadFrame.AnchorPoint = DragFrame.AnchorPoint
        leadFrame.Position = DragFrame.Position
        leadFrame.Size = DragFrame.Size
        leadFrame.Name = ""
        leadFrame.Visible = false
        leadFrame.Parent = DragFrame.Parent

        local function getBoundsRelations(guiObject)
            local bounds = DragBoundary.AbsoluteSize
            local topLeft = guiObject.AbsolutePosition
            local bottomRight = topLeft + guiObject.AbsoluteSize

            local boundRelations = {
                Top = topLeft.Y < 0 and math.abs(topLeft.Y) or nil,
                Left = topLeft.X < 0 and math.abs(topLeft.X) or nil,
                Right = bottomRight.X > bounds.X and math.abs(bottomRight.X - bounds.X) or nil,
                Bottom = bottomRight.Y > bounds.Y and math.abs(bottomRight.Y - bounds.Y) or nil,
            }

            return (not boundRelations.Top
                and not boundRelations.Bottom
                and not boundRelations.Left
                and not boundRelations.Right), boundRelations
        end

        local function updateInput(input, object)
            pcall(function ()
                local delta = input.Position - dragStart
                local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y)

                leadFrame.Position = position

                local isInBounds, relations = getBoundsRelations(leadFrame)
                if not isInBounds then
                    local x = (relations.Left or 0) - (relations.Right or 0)
                    local y = (relations.Top or 0) - (relations.Bottom or 0)

                    position += UDim2.fromOffset(x, y)
                end

                functions.CreateTW(object, TweenInfo.new(dragSpeed), {Position = position}):Play()
            end)
        end

        functions.NewConnection(DragFrame:GetFullName().."InputBegan", DragFrame.InputBegan:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
                dragToggle = true
                dragStart = input.Position
                startPos = DragFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragToggle = false
                    end
                end)
            end
        end))

        functions.NewConnection("UserInputServiceInputChanged", UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                if dragToggle then
                    updateInput(input, DragFrame)
                end
            end
        end))
    end
end

-------------------->> UI Creation <<--------------------

local gradients = {
    red = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 2, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 39, 125))
    });

    green = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(92, 239, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(163, 253, 28))
    });

    gray = ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(147, 149, 168)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(208, 212, 238)),
	});

    cyan = ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(87, 216, 255)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(135, 255, 249)),
	});
}

local uiCreationFunctions = {}

-------------------->> construction <<--------------------
popupServiceFunctions.show({Text = "Loading, please wait..."; Duration = 2;})

do
    -- function uiCreationFunctions.validateProperty(validateVal, defaultVal)
    --     return if validateVal ~= nil then validateVal else defaultVal
    -- end

    function uiCreationFunctions.getGradient(Setting)
        if Setting == true then
            return gradients.green
        else
            return gradients.red
        end
    end

    function uiCreationFunctions.constructGradient(options)
        options = functions.Validate({
            Gradient = gradients.red;
            Rotation = -90;
            Parent = nil;
        }, options)

        local Gradient = Instance.new("UIGradient")
        Gradient.Color = options["Gradient"]
        Gradient.Rotation = options["Rotation"]
        Gradient.Parent = options["Parent"]

        return Gradient
    end

    function uiCreationFunctions.constructUiAspect(options)
        options = functions.Validate({
            AspectRatio = 1;
            Parent = nil;
        }, options)

        local uiAspect = Instance.new("UIAspectRatioConstraint")
        uiAspect.AspectRatio = options["AspectRatio"]
        uiAspect.Parent = options["Parent"]

        return uiAspect
    end

    function uiCreationFunctions.constructUIStroke(options)
        options = functions.Validate({
            ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
            Color = Color3.fromRGB(0, 0, 0);
            LineJoinMode = Enum.LineJoinMode.Bevel;
            StrokeSizingMode = Enum.StrokeSizingMode.FixedSize;
            Thickness = 2.333;
            Transparency = 0;
            Parent = nil;
        }, options)

        local UIStroke = Instance.new("UIStroke")
        UIStroke.ApplyStrokeMode = options["ApplyStrokeMode"]
        UIStroke.Color = options["Color"]
        UIStroke.LineJoinMode = options["LineJoinMode"]
        UIStroke.StrokeSizingMode = options["StrokeSizingMode"]
        UIStroke.Thickness = options["Thickness"]
        UIStroke.Transparency = options["Transparency"]
        UIStroke.Parent = options["Parent"]

        return UIStroke
    end

    function uiCreationFunctions.constructTextLabel(options)
        options = functions.Validate({
            AnchorPoint = Vector2.new(0.5, 0.5);
            BackgroundTransparency = 1;
            Parent = nil;
            Position = UDim2.fromScale(0.5, 0.5);
            Size = UDim2.fromScale(0.9, 0.6);
            Font = Enum.Font.FredokaOne;
            TextScaled = true;
            TextColor3 = Color3.fromRGB(255, 255, 255);
            Text = "";
            TextXAlignment = Enum.TextXAlignment.Center;
            TextYAlignment = Enum.TextYAlignment.Center;
        }, options)

        local textLabel = Instance.new("TextLabel")
        textLabel.AnchorPoint = options["AnchorPoint"]
        textLabel.BackgroundTransparency = options["BackgroundTransparency"]
        textLabel.Parent = options["Parent"]
        textLabel.Position = options["Position"]
        textLabel.Size = options["Size"]
        textLabel.Font = options["Font"]
        textLabel.TextScaled = options["TextScaled"]
        textLabel.TextColor3 = options["TextColor3"]
        textLabel.Text = options["Text"]
        textLabel.TextXAlignment = options["TextXAlignment"]
        textLabel.TextYAlignment = options["TextYAlignment"]

        uiCreationFunctions.constructUIStroke({Parent = textLabel;})

        return textLabel
    end

    function uiCreationFunctions.constructImageButton(options)
        options = functions.Validate({
            AnchorPoint = Vector2.new(0.5, 0.5);
            BackgroundTransparency = 1;
            LayoutOrder = 0;
            Name = "";
            Parent = nil;
            Position = UDim2.fromScale(0, 0);
            Size = UDim2.fromScale(0.8, 0.45);
            Image = "rbxassetid://14423621163";
            ImageColor3 = Color3.fromRGB(255, 255, 255);
            ImageTransparency = 0;
            PressedImage = "rbxassetid://14423621349";
            ScaleType = Enum.ScaleType.Slice;
            SliceCenter = Rect.new(20, 20, 80, 80);
            SliceScale = 0.778;

            -- From other Construct functions
            Text = "";
            Gradient = gradients.red;
        }, options)

        local imageButton = Instance.new("ImageButton")
        imageButton.AnchorPoint = options["AnchorPoint"]
        imageButton.BackgroundTransparency = options["BackgroundTransparency"]
        imageButton.LayoutOrder = options["LayoutOrder"]
        imageButton.Name = options["Name"]
        imageButton.Parent = options["Parent"]
        imageButton.Position = options["Position"]
        imageButton.Size = options["Size"]
        imageButton.Image = options["Image"]
        imageButton.ImageColor3 = options["ImageColor3"]
        imageButton.ImageTransparency = options["ImageTransparency"]
        imageButton.PressedImage = options["PressedImage"]
        imageButton.ScaleType = options["ScaleType"]
        imageButton.SliceCenter = options["SliceCenter"]
        imageButton.SliceScale = options["SliceScale"]

        local UIScale = Instance.new("UIScale", imageButton)
        UIScale.Scale = 1;

        local grad = uiCreationFunctions.constructGradient({Parent = imageButton; Gradient = options["Gradient"]})
        local textL = uiCreationFunctions.constructTextLabel({Parent = imageButton; Text = options["Text"];})

        local functionsT = {}

        function functionsT:updateText(text)
            textL.Text = text
        end

        function functionsT:updateGradient(gradient)
            grad.Color = gradient
        end

        function functionsT:updateLayoutOrder(order)
            imageButton.LayoutOrder = order
        end

        return imageButton, functionsT
    end

    function uiCreationFunctions.constructImageButton2(options)
        options = functions.Validate({
            Size = UDim2.new(0.235, 0, 0.04, 45);
            Gradient = gradients.gray;
        }, options)

        local button, functionsT = uiCreationFunctions.constructImageButton(options)

        if button:FindFirstChildOfClass("TextLabel") then
            button:FindFirstChildOfClass("TextLabel"):Destroy()
        end

        return button, functionsT
    end

    function uiCreationFunctions.constructImageLabel(options)
        options = functions.Validate({
            AnchorPoint = Vector2.new(0.5, 0.5);
            BackgroundTransparency = 1;
            Parent = nil;
            Position = UDim2.fromScale(0.5, 0.5);
            Size = UDim2.fromScale(0.9, 0.6);
            Image = "";
            ImageColor3 = Color3.fromRGB(255, 255, 255);
            ImageTransparency = 0;
            ScaleType = Enum.ScaleType.Fit;
        }, options)

        local imageLabel = Instance.new("ImageLabel")
        imageLabel.AnchorPoint = options["AnchorPoint"]
        imageLabel.BackgroundTransparency = options["BackgroundTransparency"]
        imageLabel.Parent = options["Parent"]
        imageLabel.Position = options["Position"]
        imageLabel.Size = options["Size"]
        imageLabel.Image = options["Image"]
        imageLabel.ImageColor3 = options["ImageColor3"]
        imageLabel.ImageTransparency = options["ImageTransparency"]
        imageLabel.ScaleType = options["ScaleType"]

        return imageLabel
    end
end

-------------------->> Main Creation <<--------------------

local ScreenGui = Instance.new("ScreenGui", gethui())
ScreenGui.Name = "Incremental-Farm-Toggle"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 99999999999

-------------------->> Main Frame <<--------------------

local backFrame = Instance.new("Frame", ScreenGui)
backFrame.Name = "Frame"
backFrame.AnchorPoint = Vector2.new(0.5, 0.5)
backFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
backFrame.BackgroundTransparency = 0.6
backFrame.Position = UDim2.fromScale(0.5, 0.5)
backFrame.Size = UDim2.fromScale(0.235, 0.4)
functions.Draggable(backFrame, ScreenGui)
uiCreationFunctions.constructUIStroke({
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    LineJoinMode = Enum.LineJoinMode.Miter;
    StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    Thickness = 0.023;
    Parent = backFrame;
})

local Frame = Instance.new("ScrollingFrame", backFrame)
Frame.Name = "Container"
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundTransparency = 1
Frame.Position = UDim2.fromScale(0.5, 0.5)
Frame.Size = UDim2.fromScale(0.9, 0.9)
Frame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
Frame.ScrollBarThickness = 6
Frame.CanvasSize = UDim2.fromScale(0, 5)

local uiCornerFrame = Instance.new("UICorner", backFrame)
uiCornerFrame.CornerRadius = UDim.new(0.05, 0)

local uiListLayoutFrame = Instance.new("UIListLayout", Frame)
uiListLayoutFrame.Padding = UDim.new(0.005, 0)
uiListLayoutFrame.FillDirection = Enum.FillDirection.Vertical
uiListLayoutFrame.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayoutFrame.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayoutFrame.VerticalAlignment = Enum.VerticalAlignment.Top

local Folder = Instance.new("Folder", backFrame)
Folder.Name = "Ignore"

local TitleFrame = uiCreationFunctions.constructTextLabel({
    Parent = backFrame;
    AnchorPoint = Vector2.new(0, 1);
    Position = UDim2.fromScale(0, -0.05);
    Size = UDim2.fromScale(0.9, 0.1);
    Text = "Faith Incremental";
    TextXAlignment = Enum.TextXAlignment.Left;
})

uiCreationFunctions.constructUiAspect({Parent = TitleFrame; AspectRatio = 9.933})
uiCreationFunctions.constructUiAspect({Parent = backFrame; AspectRatio = 1.104})

-------------------->> Settings Frame <<--------------------

local backSettingsFrame = Instance.new("Frame", backFrame)
backSettingsFrame.Name = "settings"
backSettingsFrame.AnchorPoint = Vector2.new(1, 0.5)
backSettingsFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
backSettingsFrame.BackgroundTransparency = 0.6
backSettingsFrame.Position = UDim2.fromScale(-0.185, 0.5)
backSettingsFrame.Size = UDim2.fromScale(0.9, 0.9)
backSettingsFrame.Visible = false
uiCreationFunctions.constructUIStroke({
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    LineJoinMode = Enum.LineJoinMode.Miter;
    StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    Thickness = 0.023;
    Parent = backSettingsFrame;
})

local settingsFrame = Instance.new("ScrollingFrame", backSettingsFrame)
settingsFrame.Name = "Container"
settingsFrame.AnchorPoint = Vector2.new(0.5, 0.5)
settingsFrame.BackgroundTransparency = 1
settingsFrame.Position = UDim2.fromScale(0.5, 0.5)
settingsFrame.Size = UDim2.fromScale(1, 1)
settingsFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
settingsFrame.ScrollBarThickness = 6
settingsFrame.CanvasSize = UDim2.fromScale(0, 4)

local uiCornerSettings = Instance.new("UICorner", backSettingsFrame)
uiCornerSettings.CornerRadius = UDim.new(0.05, 0)

local uiListLayoutSettings = Instance.new("UIListLayout", settingsFrame)
uiListLayoutSettings.Padding = UDim.new(0.005, 0)
uiListLayoutSettings.FillDirection = Enum.FillDirection.Vertical
uiListLayoutSettings.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayoutSettings.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayoutSettings.VerticalAlignment = Enum.VerticalAlignment.Top

local FolderSettings = Instance.new("Folder", backSettingsFrame)
FolderSettings.Name = "Ignore"

local TitleSettings = uiCreationFunctions.constructTextLabel({
    Parent = backSettingsFrame;
    AnchorPoint = Vector2.new(0, 1);
    Position = UDim2.fromScale(0, -0.05);
    Size = UDim2.fromScale(0.9, 0.1);
    Text = "Settings";
    TextXAlignment = Enum.TextXAlignment.Left;
})

uiCreationFunctions.constructUiAspect({Parent = TitleSettings; AspectRatio = 9.933})
uiCreationFunctions.constructUiAspect({Parent = backSettingsFrame; AspectRatio = 1.104})

-------------------->> Upgrades Frame <<--------------------

local backUpgradesFrame = Instance.new("Frame", backFrame)
backUpgradesFrame.Name = "upgrades"
backUpgradesFrame.AnchorPoint = Vector2.new(1, 0.5)
backUpgradesFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
backUpgradesFrame.BackgroundTransparency = 0.6
backUpgradesFrame.Position = UDim2.fromScale(-0.185, 0.5)
backUpgradesFrame.Size = UDim2.fromScale(0.9, 0.9)
backUpgradesFrame.Visible = false
uiCreationFunctions.constructUIStroke({
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    LineJoinMode = Enum.LineJoinMode.Miter;
    StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    Thickness = 0.023;
    Parent = backUpgradesFrame;
})

local upgradesFrame = Instance.new("ScrollingFrame", backUpgradesFrame)
upgradesFrame.Name = "Container"
upgradesFrame.AnchorPoint = Vector2.new(0.5, 0.5)
upgradesFrame.BackgroundTransparency = 1
upgradesFrame.Position = UDim2.fromScale(0.5, 0.5)
upgradesFrame.Size = UDim2.fromScale(1, 1)
upgradesFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
upgradesFrame.ScrollBarThickness = 6
upgradesFrame.CanvasSize = UDim2.fromScale(0, 5)

local uiCornerUpgrades = Instance.new("UICorner", backUpgradesFrame)
uiCornerUpgrades.CornerRadius = UDim.new(0.05, 0)

local uiListLayoutUpgrades = Instance.new("UIListLayout", upgradesFrame)
uiListLayoutUpgrades.Padding = UDim.new(0.005, 0)
uiListLayoutUpgrades.FillDirection = Enum.FillDirection.Vertical
uiListLayoutUpgrades.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayoutUpgrades.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayoutUpgrades.VerticalAlignment = Enum.VerticalAlignment.Top

local FolderUpgrades = Instance.new("Folder", backUpgradesFrame)
FolderUpgrades.Name = "Ignore"

local TitleUpgrades = uiCreationFunctions.constructTextLabel({
    Parent = backUpgradesFrame;
    AnchorPoint = Vector2.new(0, 1);
    Position = UDim2.fromScale(0, -0.05);
    Size = UDim2.fromScale(0.9, 0.1);
    Text = "Upgrades";
    TextXAlignment = Enum.TextXAlignment.Left;
})

uiCreationFunctions.constructUiAspect({Parent = TitleUpgrades; AspectRatio = 9.933})
uiCreationFunctions.constructUiAspect({Parent = backUpgradesFrame; AspectRatio = 1.104})

-------------------->> Close Buttons <<--------------------

local closeButton = uiCreationFunctions.constructImageButton({
    Parent = backFrame;
    Position = UDim2.fromScale(1.012, 0);
    Size = UDim2.new(1, 0, 0.06, 45);
    Text = "X";
    Gradient = gradients.red;
})
uiCreationFunctions.constructUiAspect({Parent = closeButton})

local closeButtonSettings = uiCreationFunctions.constructImageButton({
    Parent = backSettingsFrame;
    Position = UDim2.fromScale(1.012, 0);
    Size = UDim2.new(1, 0, 0.06, 45);
    Text = "X";
    Gradient = gradients.red;
})
uiCreationFunctions.constructUiAspect({Parent = closeButtonSettings})

local closeButtonUpgrades = uiCreationFunctions.constructImageButton({
    Parent = backUpgradesFrame;
    Position = UDim2.fromScale(1.012, 0);
    Size = UDim2.new(1, 0, 0.06, 45);
    Text = "X";
    Gradient = gradients.red;
})
uiCreationFunctions.constructUiAspect({Parent = closeButtonUpgrades})

-------------------->> Side Buttons <<--------------------

local settingsButton = uiCreationFunctions.constructImageButton2({
    Parent = backFrame;
    Position = UDim2.fromScale(1.012, 0.27);
    Gradient = gradients.gray;
})
uiCreationFunctions.constructImageLabel({Parent = settingsButton; Image = "rbxassetid://74669737175882";})
uiCreationFunctions.constructUiAspect({Parent = settingsButton})

local rebirthButton = uiCreationFunctions.constructImageButton2({
    Parent = backFrame;
    Position = UDim2.fromScale(1.012, 0.52);
    Gradient = gradients.gray;
})
uiCreationFunctions.constructImageLabel({Parent = rebirthButton; Image = "rbxassetid://129348613616339";})
uiCreationFunctions.constructUiAspect({Parent = rebirthButton})

local upgradesButton = uiCreationFunctions.constructImageButton2({
    Parent = backFrame;
    Position = UDim2.fromScale(1.012, 0.77);
    Gradient = gradients.gray;
})
uiCreationFunctions.constructImageLabel({Parent = upgradesButton; Image = "rbxassetid://126864380733796";})
uiCreationFunctions.constructUiAspect({Parent = upgradesButton})

-------------------->> Settings Frame <<--------------------

local rebirthIfUnAffButton, rebirthIfUnAffFunctions = uiCreationFunctions.constructImageButton({
    Parent = settingsFrame;
    Text = "Auto Rebirth for Elite Spirts: "..functions.GetTextFromSetting("rebirthIfUnAff");
    Gradient = uiCreationFunctions.getGradient(functions.GetSetting("rebirthIfUnAff"));
    LayoutOrder = 1;
})
uiCreationFunctions.constructUiAspect({Parent = rebirthIfUnAffButton; AspectRatio = 2.854})

local autoBuyTrialShopButton, autoBuyTrialShopFunctions = uiCreationFunctions.constructImageButton({
    Parent = settingsFrame;
    Text = "Auto Buy Trial Shop: "..functions.GetTextFromSetting("autoBuyTrialShop");
    Gradient = uiCreationFunctions.getGradient(functions.GetSetting("autoBuyTrialShop"));
    LayoutOrder = 2;
})
uiCreationFunctions.constructUiAspect({Parent = autoBuyTrialShopButton; AspectRatio = 2.854})

local autoRadianceBoostButton, autoRadianceBoostFunctions = uiCreationFunctions.constructImageButton({
    Parent = settingsFrame;
    Text = "Auto Radiance Boost When Max: "..functions.GetTextFromSetting("autoRadianceBoostWhenMax");
    Gradient = uiCreationFunctions.getGradient(functions.GetSetting("autoRadianceBoostWhenMax"));
    LayoutOrder = 3;
})
uiCreationFunctions.constructUiAspect({Parent = autoRadianceBoostButton; AspectRatio = 2.854})

local autoAscendButton, autoAscendFunctions = uiCreationFunctions.constructImageButton({
    Parent = settingsFrame;
    Text = "Auto Ascend: "..functions.GetTextFromSetting("autoAscend");
    Gradient = uiCreationFunctions.getGradient(functions.GetSetting("autoAscend"));
    LayoutOrder = 4;
})
uiCreationFunctions.constructUiAspect({Parent = autoAscendButton; AspectRatio = 2.854})

local ascendButton = uiCreationFunctions.constructImageButton({
    Parent = settingsFrame;
    Text = "Ascend";
    Gradient = gradients.cyan;
    LayoutOrder = 998;
})
uiCreationFunctions.constructUiAspect({Parent = ascendButton; AspectRatio = 2.854})

local copyScriptButton = uiCreationFunctions.constructImageButton({
    Parent = settingsFrame;
    Text = "Copy Script";
    Gradient = gradients.cyan;
    LayoutOrder = 999;
})
uiCreationFunctions.constructUiAspect({Parent = copyScriptButton; AspectRatio = 2.854})

local queueOnTeleportButton = uiCreationFunctions.constructImageButton({
    Parent = settingsFrame;
    Text = "Queue on Teleport";
    Gradient = gradients.cyan;
    LayoutOrder = 1000;
})
uiCreationFunctions.constructUiAspect({Parent = queueOnTeleportButton; AspectRatio = 2.854})

-------------------->> Upgrades Frame <<--------------------

local autoZone1Button, autoZone1Functions = uiCreationFunctions.constructImageButton({
    Parent = upgradesFrame;
    Text = "Auto Zone 1: "..functions.GetTextFromSetting("autoZone1");
    Gradient = uiCreationFunctions.getGradient(functions.GetSetting("autoZone1"));
    LayoutOrder = 0;
})
uiCreationFunctions.constructUiAspect({Parent = autoZone1Button; AspectRatio = 2.854})

local autoZone2Button, autoZone2Functions = uiCreationFunctions.constructImageButton({
    Parent = upgradesFrame;
    Text = "Auto Zone 2: "..functions.GetTextFromSetting("autoZone2");
    Gradient = uiCreationFunctions.getGradient(functions.GetSetting("autoZone2"));
    LayoutOrder = 1;
})
uiCreationFunctions.constructUiAspect({Parent = autoZone2Button; AspectRatio = 2.854})

local autoZone3NoEliteSoulsButton, autoZone3NoEliteSoulsFunctions = uiCreationFunctions.constructImageButton({
    Parent = upgradesFrame;
    Text = "Auto Zone 3 No Elite Souls: "..functions.GetTextFromSetting("autoZone3NoEliteSouls");
    Gradient = uiCreationFunctions.getGradient(functions.GetSetting("autoZone3NoEliteSouls"));
    LayoutOrder = 2;
})
uiCreationFunctions.constructUiAspect({Parent = autoZone3NoEliteSoulsButton; AspectRatio = 2.854})

local autoZone3EliteSoulsButton, autoZone3EliteSoulsFunctions = uiCreationFunctions.constructImageButton({
    Parent = upgradesFrame;
    Text = "Auto Zone 3 Elite Souls: "..functions.GetTextFromSetting("autoZone3EliteSouls");
    Gradient = uiCreationFunctions.getGradient(functions.GetSetting("autoZone3EliteSouls"));
    LayoutOrder = 3;
})
uiCreationFunctions.constructUiAspect({Parent = autoZone3EliteSoulsButton; AspectRatio = 2.854})

local autoSoulTempleButton, autoSoulTempleFunctions = uiCreationFunctions.constructImageButton({
    Parent = upgradesFrame;
    Text = "Auto Soul Temple: "..functions.GetTextFromSetting("autoSoulTemple");
    Gradient = uiCreationFunctions.getGradient(functions.GetSetting("autoSoulTemple"));
    LayoutOrder = 4;
})
uiCreationFunctions.constructUiAspect({Parent = autoSoulTempleButton; AspectRatio = 2.854})

local autoRelicTempleButton, autoRelicTempleFunctions = uiCreationFunctions.constructImageButton({
    Parent = upgradesFrame;
    Text = "Auto Relic Temple: "..functions.GetTextFromSetting("autoRelicTemple");
    Gradient = uiCreationFunctions.getGradient(functions.GetSetting("autoRelicTemple"));
    LayoutOrder = 5;
})
uiCreationFunctions.constructUiAspect({Parent = autoRelicTempleButton; AspectRatio = 2.854})

local autoBibleTempleButton, autoBibleTempleFunctions = uiCreationFunctions.constructImageButton({
    Parent = upgradesFrame;
    Text = "Auto Bible Temple: "..functions.GetTextFromSetting("autoBibleTemple");
    Gradient = uiCreationFunctions.getGradient(functions.GetSetting("autoBibleTemple"));
    LayoutOrder = 6;
})
uiCreationFunctions.constructUiAspect({Parent = autoBibleTempleButton; AspectRatio = 2.854})

local autoSoulDPBoardButton, autoSoulDPBoardFunctions = uiCreationFunctions.constructImageButton({
    Parent = upgradesFrame;
    Text = "Auto Soul DP Board: "..functions.GetTextFromSetting("autoSoulDPBoard");
    Gradient = uiCreationFunctions.getGradient(functions.GetSetting("autoSoulDPBoard"));
    LayoutOrder = 7;
})
uiCreationFunctions.constructUiAspect({Parent = autoSoulDPBoardButton; AspectRatio = 2.854})

local autoRelicDPBoardButton, autoRelicDPBoardFunctions = uiCreationFunctions.constructImageButton({
    Parent = upgradesFrame;
    Text = "Auto Relic DP Board: "..functions.GetTextFromSetting("autoRelicDPBoard");
    Gradient = uiCreationFunctions.getGradient(functions.GetSetting("autoRelicDPBoard"));
    LayoutOrder = 8;
})
uiCreationFunctions.constructUiAspect({Parent = autoRelicDPBoardButton; AspectRatio = 2.854})

local autoBibleDPBoardButton, autoBibleDPBoardFunctions = uiCreationFunctions.constructImageButton({
    Parent = upgradesFrame;
    Text = "Auto Bible DP Board: "..functions.GetTextFromSetting("autoBibleDPBoard");
    Gradient = uiCreationFunctions.getGradient(functions.GetSetting("autoBibleDPBoard"));
    LayoutOrder = 9;
})
uiCreationFunctions.constructUiAspect({Parent = autoBibleDPBoardButton; AspectRatio = 2.854})

local autoDepositMainTempleButton, autoDepositMainTempleFunctions = uiCreationFunctions.constructImageButton({
    Parent = upgradesFrame;
    Text = "Auto Deposit Main Temple: "..functions.GetTextFromSetting("autoDepositMainTemple");
    Gradient = uiCreationFunctions.getGradient(functions.GetSetting("autoDepositMainTemple"));
    LayoutOrder = 10;
})
uiCreationFunctions.constructUiAspect({Parent = autoDepositMainTempleButton; AspectRatio = 2.854})

local autoHellStairsNodesButton, autoHellStairsNodesFunctions = uiCreationFunctions.constructImageButton({
    Parent = upgradesFrame;
    Text = "Auto Hell Stairs Nodes: "..functions.GetTextFromSetting("autoHellStairsNodes");
    Gradient = uiCreationFunctions.getGradient(functions.GetSetting("autoHellStairsNodes"));
    LayoutOrder = 11;
})
uiCreationFunctions.constructUiAspect({Parent = autoHellStairsNodesButton; AspectRatio = 2.854})

local autoStairwayNodesButton, autoStairwayNodesFunctions = uiCreationFunctions.constructImageButton({
    Parent = upgradesFrame;
    Text = "Auto Stairway Nodes: "..functions.GetTextFromSetting("autoStairwayNodes");
    Gradient = uiCreationFunctions.getGradient(functions.GetSetting("autoStairwayNodes"));
    LayoutOrder = 12;
})
uiCreationFunctions.constructUiAspect({Parent = autoStairwayNodesButton; AspectRatio = 2.854})

local autoUnderworldButton, autoUnderworldFunctions = uiCreationFunctions.constructImageButton({
    Parent = upgradesFrame;
    Text = "Auto Underworld: "..functions.GetTextFromSetting("autoUnderworld");
    Gradient = uiCreationFunctions.getGradient(functions.GetSetting("autoUnderworld"));
    LayoutOrder = 13;
})
uiCreationFunctions.constructUiAspect({Parent = autoUnderworldButton; AspectRatio = 2.854})

-------------------->> Main Frame <<--------------------

local farmSpiritsButton, farmSpiritsFunctions = uiCreationFunctions.constructImageButton({
    Parent = Frame;
    Text = "Farm Spirits: "..functions.GetTextFromSetting("FarmSpirits");
    Gradient = uiCreationFunctions.getGradient(functions.GetSetting("FarmSpirits"));
    LayoutOrder = 0;
})
uiCreationFunctions.constructUiAspect({Parent = farmSpiritsButton; AspectRatio = 2.854})

local spawnEliteSpiritButton, spawnEliteSpiritFunctions = uiCreationFunctions.constructImageButton({
    Parent = Frame;
    Text = "Auto Spawn Elite: "..functions.GetTextFromSetting("autoSpawnEliteSpirit");
    Gradient = uiCreationFunctions.getGradient(functions.GetSetting("autoSpawnEliteSpirit"));
    LayoutOrder = 1;
})
uiCreationFunctions.constructUiAspect({Parent = spawnEliteSpiritButton; AspectRatio = 2.854})

local farmBossSpiritButton, farmBossSpiritFunctions = uiCreationFunctions.constructImageButton({
    Parent = Frame;
    Text = "Farm Trial: "..functions.GetTextFromSetting("FarmBossSpirit");
    Gradient = uiCreationFunctions.getGradient(functions.GetSetting("FarmBossSpirit"));
    LayoutOrder = 2;
})
uiCreationFunctions.constructUiAspect({Parent = farmBossSpiritButton, AspectRatio = 2.854})

local farmSurgeButton, farmSurgeFunctions = uiCreationFunctions.constructImageButton({
    Parent = Frame;
    Text = "Farm Surge: "..functions.GetTextFromSetting("FarmSurge");
    Gradient = uiCreationFunctions.getGradient(functions.GetSetting("FarmSurge"));
    LayoutOrder = 3;
})
uiCreationFunctions.constructUiAspect({Parent = farmSurgeButton; AspectRatio = 2.854})

local autoReincarnateButton, autoReincarnateFunctions = uiCreationFunctions.constructImageButton({
    Parent = Frame;
    Text = "Auto Reincarnate: "..functions.GetTextFromSetting("autoReincarnate");
    Gradient = uiCreationFunctions.getGradient(functions.GetSetting("autoReincarnate"));
    LayoutOrder = 4;
})
uiCreationFunctions.constructUiAspect({Parent = autoReincarnateButton; AspectRatio = 2.854})

local autoClickRelicButton, autoClickRelicFunctions = uiCreationFunctions.constructImageButton({
    Parent = Frame;
    Text = "Auto Click Relic: "..functions.GetTextFromSetting("autoClickRelic");
    Gradient = uiCreationFunctions.getGradient(functions.GetSetting("autoClickRelic"));
    LayoutOrder = 5;
})
uiCreationFunctions.constructUiAspect({Parent = autoClickRelicButton; AspectRatio = 2.854})

-------------------->> UI Protection <<--------------------

local protectGui = false

if protectGui == true then
    do
        popupServiceFunctions.show({Text = "Protecting GUI..."; Duration = 3;})
        print("\n\n\n-------------------->> ProtectGui <<--------------------\n")
        local startTime = DateTime.now().UnixTimestamp

        for _, Object in pairs(ScreenGui:GetDescendants()) do
            local oldName = Object.Name
            Object.Name = ""

            print(("\t'%s' --> '%s'"):format(oldName, Object.Name))
            task.wait()
        end

        print(("\n-------------------->> ProtectGui Completed! | Took %d second (s)! <<--------------------\n\n\n"):format(DateTime.now().UnixTimestamp-startTime))
    end
end

-------------------->> Main <<--------------------
popupServiceFunctions.show({Text = "Loading functions..."; Duration = 2;})
local mainFunctions = {}

do
    function mainFunctions.autoFarmSpirits()
        functions.SetSetting("FarmSpirits", not functions.GetSetting("FarmSpirits"))
        farmSpiritsFunctions:updateText("Farm Spirits: "..functions.GetTextFromSetting("FarmSpirits"))
        farmSpiritsFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("FarmSpirits")))

        local function fightSpirit()
            if gameFunctions.getSpirit() ~= nil and functions.GetSetting("FarmSpirits") == true then
                pcall(function()
                    if functions.GetSetting("spiritsPaused") ~= true and functions.GetHumanoidRootPart() ~= nil then
                        local mag = (functions.GetHumanoidRootPart().Position - gameFunctions.getSpirit().HumanoidRootPart.Position).Magnitude
                        if mag > 12.5 then
                            functions.GetHumanoidRootPart().CFrame = gameFunctions.getSpirit().HumanoidRootPart.CFrame
                        end
                    end
                    if functions.GetHumanoid().Sit == true or functions.GetHumanoid().SeatPart ~= nil then
                        --functions.GetHumanoid().Sit = false
                        functions.GetHumanoid():ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                end)

                if functions.GetSetting("spiritsPaused") == true then
                    repeat task.wait() until functions.GetSetting("spiritsPaused") ~= true or functions.GetSetting("FarmSpirits") ~= true
                end
            end
        end

        if functions.GetSetting("FarmSpirits") == true then
            fightSpirit()

            while task.wait(1) do
                if functions.GetSetting("FarmSpirits") ~= true then break end
                fightSpirit()
            end
        end
    end

    function mainFunctions.autoSpawnEliteSpirit()
        functions.SetSetting("autoSpawnEliteSpirit", not functions.GetSetting("autoSpawnEliteSpirit"))
        spawnEliteSpiritFunctions:updateText("Auto Spawn Elite: "..functions.GetTextFromSetting("autoSpawnEliteSpirit"))
        spawnEliteSpiritFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoSpawnEliteSpirit")))

        if functions.GetSetting("autoSpawnEliteSpirit") == true and typeof(firesignal) == "function" then
            functions.spawnElite()

            while task.wait(5) do
                if functions.GetSetting("autoSpawnEliteSpirit") ~= true then break end
                if string.lower(SpawnButton.Text) == "can't afford" and functions.GetSetting("rebirthIfUnAff") == true then
                    functions.rebirth()
                end
                if string.lower(SpawnButton.Text) == "spawn" then
                    functions.spawnElite()
                end
            end
        end
    end

    function mainFunctions.autoFarmBossSpirit()
        functions.SetSetting("FarmBossSpirit", not functions.GetSetting("FarmBossSpirit"))
        farmBossSpiritFunctions:updateText("Farm Trial: "..functions.GetTextFromSetting("FarmBossSpirit"))
        farmBossSpiritFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("FarmBossSpirit")))

        local function fightBoss()
            if gameFunctions.getBoss() ~= nil then
                local lastCFrame = functions.GetLastCFrame()

                repeat
                    task.wait()
                    functions.SetSetting("spiritsPaused", true)
                    functions.SetSetting("surgePaused", true)

                    for i, v in pairs(Work:GetChildren()) do
                        if v:IsA("Model") and string.lower(v.Name):match("bosshealer") ~= nil then
                            repeat
                                task.wait()
                                pcall(function()
                                    functions.GetHumanoidRootPart().CFrame = v.HumanoidRootPart.CFrame
                                    functions.GetHumanoid():ChangeState(Enum.HumanoidStateType.GettingUp)
                                end)
                            until v.Parent == nil or gameFunctions.getBoss() == nil or functions.GetSetting("FarmBossSpirit") ~= true
                        end
                    end

                    pcall(function()
                        functions.GetHumanoidRootPart().CFrame = gameFunctions.getBossPlatform().CFrame * CFrame.Angles(0, 0, math.rad(90)) + Vector3.new(0, 2.5, 0)
                        functions.GetHumanoid():ChangeState(Enum.HumanoidStateType.GettingUp)
                    end)
                until gameFunctions.getBoss() == nil or functions.GetSetting("FarmBossSpirit") ~= true
                
                functions.SetSetting("spiritsPaused", false)
                functions.SetSetting("surgePaused", false)
                pcall(function() functions.GetHumanoidRootPart().CFrame = lastCFrame end)
            end
        end

        if functions.GetSetting("FarmBossSpirit") == true then
            fightBoss()

            functions.NewConnection("workspace.ChildAdded", Work.ChildAdded:Connect(function()
                fightBoss()
            end))
        else
            -- pcall(function() functions.DestroyConnection("Humanoid.Changed")  end)
            functions.DestroyConnection("workspace.ChildAdded")
        end
    end

    function mainFunctions.autoFarmSurge()
        functions.SetSetting("FarmSurge", not functions.GetSetting("FarmSurge"))
        farmSurgeFunctions:updateText("Farm Surge: "..functions.GetTextFromSetting("FarmSurge"))
        farmSurgeFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("FarmSurge")))

        local function farmSurge()
            if (emberServiceFunctions.isSurgeActive() == true and emberServiceFunctions.getSurgePosition() ~= nil) and functions.GetSetting("FarmSurge") == true then
                pcall(function()
                    if functions.GetSetting("surgePaused") ~= true and functions.GetHumanoidRootPart() ~= nil then
                        local lastCFrame = functions.GetLastCFrame()
                        repeat
                            task.wait()
                            functions.SetSetting("spiritsPaused", true)
                            functions.GetHumanoidRootPart().CFrame = CFrame.new(emberServiceFunctions.getSurgePosition() + Vector3.new(0, 2.75, 0))
                            functions.GetHumanoid():ChangeState(Enum.HumanoidStateType.GettingUp)
                        until emberServiceFunctions.isSurgeActive() == false or emberServiceFunctions.getSurgePosition() == nil or functions.GetSetting("FarmSurge") ~= true or functions.GetSetting("surgePaused") == true
                        functions.GetHumanoidRootPart().CFrame = lastCFrame
                    end
                end)

                if functions.GetSetting("surgePaused") == true then
                    repeat task.wait() until functions.GetSetting("surgePaused") ~= true or functions.GetSetting("FarmSurge") ~= true
                end
            else
                if functions.GetSetting("surgePaused") ~= true then
                    functions.SetSetting("spiritsPaused", false)
                end
            end
        end

        if functions.GetSetting("FarmSurge") == true then
            farmSurge()

            while task.wait(0.1) do
                if functions.GetSetting("FarmSurge") ~= true then break end
                farmSurge()
            end
        end
    end

    function mainFunctions.autoReincarnate()
        functions.SetSetting("autoReincarnate", not functions.GetSetting("autoReincarnate"))
        autoReincarnateFunctions:updateText("Auto Reincarnate: "..functions.GetTextFromSetting("autoReincarnate"))
        autoReincarnateFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoReincarnate")))

        local function reincarnate()
            if reincarnationServiceFunctions.reincarnationIsMaxed() ~= true then
                reincarnationServiceFunctions.RequestReincarnation()
            end
        end

        if functions.GetSetting("autoReincarnate") == true then
            reincarnate()

            while task.wait(1) do
                if functions.GetSetting("autoReincarnate") ~= true then break end
                reincarnate()
            end
        end
    end

    function mainFunctions.autoClickRelic()
        functions.SetSetting("autoClickRelic", not functions.GetSetting("autoClickRelic"))
        autoClickRelicFunctions:updateText("Auto Click Relic: "..functions.GetTextFromSetting("autoClickRelic"))
        autoClickRelicFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoClickRelic")))

        if functions.GetSetting("autoClickRelic") == true then
            relicServiceFunctions.relicClick()

            while task.wait() do
                if functions.GetSetting("autoClickRelic") ~= true then break end
                relicServiceFunctions.relicClick()
            end
        end
    end
end

-------------------->> Settings <<--------------------

local settingsFunctions = {}

do
    function settingsFunctions.autoRebirthIfUnAff()
        functions.SetSetting("rebirthIfUnAff", not functions.GetSetting("rebirthIfUnAff"))
        rebirthIfUnAffFunctions:updateText("Auto Rebirth for Elite Spirts: "..functions.GetTextFromSetting("rebirthIfUnAff"))
        rebirthIfUnAffFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("rebirthIfUnAff")))
    end

    function settingsFunctions.autoBuyTrialShop()
        functions.SetSetting("autoBuyTrialShop", not functions.GetSetting("autoBuyTrialShop"))
        autoBuyTrialShopFunctions:updateText("Auto Buy Trial Shop: "..functions.GetTextFromSetting("autoBuyTrialShop"))
        autoBuyTrialShopFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoBuyTrialShop")))

        if functions.GetSetting("autoBuyTrialShop") == true then
            trialShopServiceFunctions.buyOutTrialShop()

            while task.wait(10) do
                if functions.GetSetting("autoBuyTrialShop") ~= true then break end
                trialShopServiceFunctions.buyOutTrialShop()
            end
        end
    end

    function settingsFunctions.autoRadianceBoostWhenMax()
        functions.SetSetting("autoRadianceBoostWhenMax", not functions.GetSetting("autoRadianceBoostWhenMax"))
        autoRadianceBoostFunctions:updateText("Auto Radiance Boost When Max: "..functions.GetTextFromSetting("autoRadianceBoostWhenMax"))
        autoRadianceBoostFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoRadianceBoostWhenMax")))

        local waitingTrue = false

        local function boost()
            if EmberServiceClient.GetRadianceCharges() == EmberServiceClient.GetRadianceMaxCharges() then
            if functions.GetSetting("FarmSurge") == true then
                    repeat
                        task.wait()
                        waitingTrue = true
                    until 
                        (EmberServiceClient.IsPlayerInSurge() == true and EmberServiceClient.GetSurgeTimeRemaining()>6.5) or
                        functions.GetSetting("FarmSurge") ~= true or
                        functions.GetSetting("autoRadianceBoostWhenMax") ~= true or
                        EmberServiceClient.GetRadianceCharges() ~= EmberServiceClient.GetRadianceMaxCharges()
                    
                    waitingTrue = false
                    if functions.GetSetting("autoRadianceBoostWhenMax") == true and EmberServiceClient.GetRadianceCharges() == EmberServiceClient.GetRadianceMaxCharges() then
                        EmberServiceClient.RequestActivateRadiance()
                    end
            else
                    EmberServiceClient.RequestActivateRadiance()
            end
            end
        end

        if functions.GetSetting("autoRadianceBoostWhenMax") == true then
            boost()

            functions.NewConnection("StatServiceClient.StatChanged", StatServiceClient.StatChanged:Connect(function(stat, value)
                if waitingTrue == false then
                    boost()
                end
            end))
        else
            functions.DestroyConnection("StatServiceClient.StatChanged")
        end
    end

    function settingsFunctions.autoAscend()
        functions.SetSetting("autoAscend", not functions.GetSetting("autoAscend"))
        autoAscendFunctions:updateText("Auto Ascend: "..functions.GetTextFromSetting("autoAscend"))
        autoAscendFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoAscend")))

        local db = false

        local function ascend()
            if db == true then return end
            db = true

            if AscensionServiceClient.getAPPreview() >= 12 then
                AscensionServiceClient.RequestAscension()
            end

            task.wait(0.5)
            db = false
        end

        if functions.GetSetting("autoRadianceBoostWhenMax") == true then
            ascend()

            functions.NewConnection("StatServiceClient.StatChanged(SettingFrame)", StatServiceClient.StatChanged:Connect(function(stat, value)
                ascend()
            end))
        else
            functions.DestroyConnection("StatServiceClient.StatChanged(SettingFrame)")
        end
    end
end

-------------------->> Upgrades <<--------------------

local upgradeFunctions = {}

do
    function upgradeFunctions.autoZone1()
        functions.SetSetting("autoZone1", not functions.GetSetting("autoZone1"))
        autoZone1Functions:updateText("Auto Zone 1: "..functions.GetTextFromSetting("autoZone1"))
        autoZone1Functions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoZone1")))

        local db = false

        local function auto()
            if db == true then return end
            db = true

            local treeT = {}
            local boardt = {}

            local function addToBoardT(z)
                for _, v in pairs(z:GetChildren()) do
                    if v:IsA("Part") then
                        local zoneId = idFunctions.getZoneId(v)
                        local boardId = idFunctions.getBoardId(v)
                        local zone = UpgradeBoards.Zones[zoneId]
                        local board = zone and zone.Boards[boardId]

                        if zone ~= nil and board ~= nil then
                            if upgradeBoardServiceFunctions.isBoardTypeValid(board.BoardType) == true then
                                table.insert(boardt, v)
                            end
                        end
                    end 
                end
            end

            local function addToTreeT(z, currency)
                for _, v in pairs(z:GetChildren()) do
                    if v:IsA("Model") and v:FindFirstChild("Node") then
                        if upgradeTreeServiceFunctions.isNodeColorCurrency(v.Node, currency) == true and upgradeTreeServiceFunctions.checkNodeAvailable(v) == true then
                            table.insert(treeT, v)
                        end
                    end 
                end
            end

            addToTreeT(Trees.Zone1, GameEnum.Currency.Faith)
            addToTreeT(Trees.Zone1, GameEnum.Currency.Rebirths)
            addToTreeT(Trees.Zone1, GameEnum.Currency.Bible)
            addToBoardT(Boards.Zone1)

            functions.DebugPrint("Zone 1 Nodes: "..tostring(#treeT))
            functions.DebugPrint("Zone 1 Boards: "..tostring(#boardt))
            upgradeTreeServiceFunctions.purchaseNodes(treeT)
            upgradeBoardServiceFunctions.purchaseBoards(boardt)
            task.wait(0.5)
            db = false
        end

        if functions.GetSetting("autoZone1") == true then
            auto()

            functions.NewConnection("StatServiceClient.StatChanged(0)", StatServiceClient.StatChanged:Connect(function(stat, value)
                auto()
            end))
        else
            functions.DestroyConnection("StatServiceClient.StatChanged(0)")
        end
    end

    function upgradeFunctions.autoZone2()
        functions.SetSetting("autoZone2", not functions.GetSetting("autoZone2"))
        autoZone2Functions:updateText("Auto Zone 2: "..functions.GetTextFromSetting("autoZone2"))
        autoZone2Functions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoZone2")))

        local db = false

        local function auto()
            if db == true then return end
            db = true

            local treeT = {}
            local boardt = {}

            local function addToBoardT(z)
                for _, v in pairs(z:GetChildren()) do
                    if v:IsA("Part") then
                        local zoneId = idFunctions.getZoneId(v)
                        local boardId = idFunctions.getBoardId(v)
                        local zone = UpgradeBoards.Zones[zoneId]
                        local board = zone and zone.Boards[boardId]

                        if zone ~= nil and board ~= nil then
                            if upgradeBoardServiceFunctions.isBoardTypeValid(board.BoardType) == true then
                                table.insert(boardt, v)
                            end
                        end
                    end 
                end
            end

            local function addToTreeT(z, currency)
                for _, v in pairs(z:GetChildren()) do
                    if v:IsA("Model") and v:FindFirstChild("Node") then
                        if upgradeTreeServiceFunctions.isNodeColorCurrency(v.Node, currency) == true and upgradeTreeServiceFunctions.checkNodeAvailable(v) == true then
                            table.insert(treeT, v)
                        end
                    end 
                end
            end

            addToTreeT(Trees.Zone2, GameEnum.Currency.Faith)
            addToTreeT(Trees.Zone2, GameEnum.Currency.Rebirths)
            addToTreeT(Trees.Zone2, GameEnum.Currency.Bible)
            addToTreeT(Trees.Zone2, GameEnum.Currency.Relics)
            addToBoardT(Boards.Zone2)
            addToBoardT(Boards.Zone3)

            functions.DebugPrint("Zone 2 Nodes: "..tostring(#treeT))
            functions.DebugPrint("Zone 2 Boards: "..tostring(#boardt))
            upgradeTreeServiceFunctions.purchaseNodes(treeT)
            upgradeBoardServiceFunctions.purchaseBoards(boardt)
            task.wait(0.5)
            db = false
        end

        if functions.GetSetting("autoZone2") == true then
            auto()

            functions.NewConnection("StatServiceClient.StatChanged(1)", StatServiceClient.StatChanged:Connect(function(stat, value)
                auto()
            end))
        else
            functions.DestroyConnection("StatServiceClient.StatChanged(1)")
        end
    end

    function upgradeFunctions.autoZone3NoEliteSouls()
        functions.SetSetting("autoZone3NoEliteSouls", not functions.GetSetting("autoZone3NoEliteSouls"))
        autoZone3NoEliteSoulsFunctions:updateText("Auto Zone 3 No Elite Souls: "..functions.GetTextFromSetting("autoZone3NoEliteSouls"))
        autoZone3NoEliteSoulsFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoZone3NoEliteSouls")))

        local db = false

        local function auto()
            if db == true then return end
            db = true

            local treeT = {}
            local boardt = {}

            local function addToBoardT(z)
                for _, v in pairs(z:GetChildren()) do
                    if v:IsA("Part") then
                        local zoneId = idFunctions.getZoneId(v)
                        local boardId = idFunctions.getBoardId(v)
                        local zone = UpgradeBoards.Zones[zoneId]
                        local board = zone and zone.Boards[boardId]

                        if zone ~= nil and board ~= nil then
                            if board.Currency == GameEnum.Currency.EliteSouls then continue end
                            if upgradeBoardServiceFunctions.isBoardTypeValid(board.BoardType) == true then
                                table.insert(boardt, v)
                            end
                        end
                    end 
                end
            end

            local function addToTreeT(z, currency)
                for _, v in pairs(z:GetChildren()) do
                    if v:IsA("Model") and v:FindFirstChild("Node") then
                        if upgradeTreeServiceFunctions.isNodeColorCurrency(v.Node, currency) == true and upgradeTreeServiceFunctions.checkNodeAvailable(v) == true then
                            table.insert(treeT, v)
                        end
                    end 
                end
            end

            addToTreeT(Trees.Zone3, GameEnum.Currency.Faith)
            addToTreeT(Trees.Zone3, GameEnum.Currency.Relics)
            addToTreeT(Trees.Zone3, GameEnum.Currency.Souls)
            addToBoardT(Boards.Zone4)

            functions.DebugPrint("Zone 3 Nodes: "..tostring(#treeT))
            functions.DebugPrint("Zone 3 Boards: "..tostring(#boardt))
            upgradeTreeServiceFunctions.purchaseNodes(treeT)
            upgradeBoardServiceFunctions.purchaseBoards(boardt)
            task.wait(0.5)
            db = false
        end

        if functions.GetSetting("autoZone3NoEliteSouls") == true then
            auto()

            functions.NewConnection("StatServiceClient.StatChanged(2)", StatServiceClient.StatChanged:Connect(function(stat, value)
                auto()
            end))
        else
            functions.DestroyConnection("StatServiceClient.StatChanged(2)")
        end
    end

    function upgradeFunctions.autoZone3EliteSouls()
        functions.SetSetting("autoZone3EliteSouls", not functions.GetSetting("autoZone3EliteSouls"))
        autoZone3EliteSoulsFunctions:updateText("Auto Zone 3 Elite Souls: "..functions.GetTextFromSetting("autoZone3EliteSouls"))
        autoZone3EliteSoulsFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoZone3EliteSouls")))

        local db = false

        local function auto()
            if db == true then return end
            db = true

            local treeT = {}
            local boardt = {}

            for _, v in pairs(Trees.Zone3:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("Node") then
                    if upgradeTreeServiceFunctions.isNodeColorCurrency(v.Node, GameEnum.Currency.EliteSouls) == true and upgradeTreeServiceFunctions.checkNodeAvailable(v) == true then
                        table.insert(treeT, v)
                    end
                end 
            end

            for _, v in pairs(Boards.Zone4:GetChildren()) do
                if v:IsA("Part") then
                    local zoneId = idFunctions.getZoneId(v)
                    local boardId = idFunctions.getBoardId(v)
                    local zone = UpgradeBoards.Zones[zoneId]
                    local board = zone and zone.Boards[boardId]

                    if zone ~= nil and board ~= nil then
                        if board.Currency ~= GameEnum.Currency.EliteSouls then continue end
                        if upgradeBoardServiceFunctions.isBoardTypeValid(board.BoardType) == true then
                            table.insert(boardt, v)
                        end
                    end
                end 
            end

            functions.DebugPrint("Zone 3 Elite Soul Nodes: "..tostring(#treeT))
            functions.DebugPrint("Zone 3 Elite Soul Boards: "..tostring(#boardt))
            upgradeTreeServiceFunctions.purchaseNodes(treeT)
            upgradeBoardServiceFunctions.purchaseBoards(boardt)
            task.wait(0.5)
            db = false
        end

        if functions.GetSetting("autoZone3EliteSouls") == true then
            auto()

            functions.NewConnection("StatServiceClient.StatChanged(3)", StatServiceClient.StatChanged:Connect(function(stat, value)
                auto()
            end))
        else
            functions.DestroyConnection("StatServiceClient.StatChanged(3)")
        end
    end

    function upgradeFunctions.autoSoulTemple()
        functions.SetSetting("autoSoulTemple", not functions.GetSetting("autoSoulTemple"))
        autoSoulTempleFunctions:updateText("Auto Soul Temple: "..functions.GetTextFromSetting("autoSoulTemple"))
        autoSoulTempleFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoSoulTemple")))

        local db = false

        local function auto()
            if db == true then return end
            db = true

            if templeServiceFunctions.isTempleBuilt(TempleId.SoulsTemple) ~= true then
                templeServiceFunctions.requestBuildTemple(TempleId.SoulsTemple)
            end

            if templeServiceFunctions.getTempleLevel(TempleId.SoulsTemple) == templeServiceFunctions.getTempleConfig(TempleId.SoulsTemple).MaxLevel then
                db = false
                functions.SetSetting("autoSoulTemple", false)
                if functions.ConnectionExists("StatServiceClient.StatChanged(4)") == true then
                    functions.DestroyConnection("StatServiceClient.StatChanged(4)")
                end
                autoSoulTempleFunctions:updateText("Auto Soul Temple: "..functions.GetTextFromSetting("autoSoulTemple"))
                autoSoulTempleFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoSoulTemple")))
                popupServiceFunctions.show({Text = "Soul Temple is Maxed! Auto Soul Temple disabled.", Duration = 5})
                return
            end

            if templeServiceFunctions.isTempleBuilt(TempleId.SoulsTemple) == true then
                templeServiceFunctions.purchaseMaxTemple(Temples.Souls)
            end
            task.wait(0.5)
            db = false
        end

        if functions.GetSetting("autoSoulTemple") == true then
            auto()

            functions.NewConnection("StatServiceClient.StatChanged(4)", StatServiceClient.StatChanged:Connect(function(stat, value)
                auto()
            end))
        else
            functions.DestroyConnection("StatServiceClient.StatChanged(4)")
        end
    end

    function upgradeFunctions.autoRelicTemple()
        functions.SetSetting("autoRelicTemple", not functions.GetSetting("autoRelicTemple"))
        autoRelicTempleFunctions:updateText("Auto Relic Temple: "..functions.GetTextFromSetting("autoRelicTemple"))
        autoRelicTempleFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoRelicTemple")))

        local db = false

        local function auto()
            if db == true then return end
            db = true

            if templeServiceFunctions.isTempleBuilt(TempleId.RelicsTemple) ~= true then
                templeServiceFunctions.requestBuildTemple(TempleId.RelicsTemple)
            end

            if templeServiceFunctions.getTempleLevel(TempleId.RelicsTemple) == templeServiceFunctions.getTempleConfig(TempleId.RelicsTemple).MaxLevel then
                db = false
                functions.SetSetting("autoRelicTemple", false)
                if functions.ConnectionExists("StatServiceClient.StatChanged(5)") == true then
                    functions.DestroyConnection("StatServiceClient.StatChanged(5)")
                end
                autoRelicTempleFunctions:updateText("Auto Relic Temple: "..functions.GetTextFromSetting("autoRelicTemple"))
                autoRelicTempleFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoRelicTemple")))
                popupServiceFunctions.show({Text = "Relic Temple is Maxed! Auto Relic Temple disabled.", Duration = 5})
                return
            end

            if templeServiceFunctions.isTempleBuilt(TempleId.RelicsTemple) == true then
                templeServiceFunctions.purchaseMaxTemple(Temples.Relics)
            end
            task.wait(0.5)
            db = false
        end

        if functions.GetSetting("autoRelicTemple") == true then
            auto()

            functions.NewConnection("StatServiceClient.StatChanged(5)", StatServiceClient.StatChanged:Connect(function(stat, value)
                auto()
            end))
        else
            functions.DestroyConnection("StatServiceClient.StatChanged(5)")
        end
    end

    function upgradeFunctions.autoBibleTemple()
        functions.SetSetting("autoBibleTemple", not functions.GetSetting("autoBibleTemple"))
        autoBibleTempleFunctions:updateText("Auto Bible Temple: "..functions.GetTextFromSetting("autoBibleTemple"))
        autoBibleTempleFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoBibleTemple")))

        local db = false

        local function auto()
            if db == true then return end
            db = true

            if templeServiceFunctions.isTempleBuilt(TempleId.BibleTemple) ~= true then
                templeServiceFunctions.requestBuildTemple(TempleId.BibleTemple)
            end

            if templeServiceFunctions.getTempleLevel(TempleId.BibleTemple) == templeServiceFunctions.getTempleConfig(TempleId.BibleTemple).MaxLevel then
                db = false
                functions.SetSetting("autoBibleTemple", false)
                if functions.ConnectionExists("StatServiceClient.StatChanged(6)") == true then
                    functions.DestroyConnection("StatServiceClient.StatChanged(6)")
                end
                autoBibleTempleFunctions:updateText("Auto Bible Temple: "..functions.GetTextFromSetting("autoBibleTemple"))
                autoBibleTempleFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoBibleTemple")))
                popupServiceFunctions.show({Text = "Bible Temple is Maxed! Auto Bible Temple disabled.", Duration = 5})
                return
            end

            if templeServiceFunctions.isTempleBuilt(TempleId.BibleTemple) == true then
                templeServiceFunctions.purchaseMaxTemple(Temples.Bible)
            end
            task.wait(0.5)
            db = false
        end

        if functions.GetSetting("autoBibleTemple") == true then
            auto()

            functions.NewConnection("StatServiceClient.StatChanged(6)", StatServiceClient.StatChanged:Connect(function(stat, value)
                auto()
            end))
        else
            functions.DestroyConnection("StatServiceClient.StatChanged(6)")
        end
    end

    function upgradeFunctions.autoSoulDPBoard()
        functions.SetSetting("autoSoulDPBoard", not functions.GetSetting("autoSoulDPBoard"))
        autoSoulDPBoardFunctions:updateText("Auto Soul DP Board: "..functions.GetTextFromSetting("autoSoulDPBoard"))
        autoSoulDPBoardFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoSoulDPBoard")))

        local db = false

        local function auto()
            if db == true then return end
            db = true

            if templeServiceFunctions.getDivinePowerBoardLevel(TempleId.SoulsTemple) == templeServiceFunctions.getDivinePowerBoardConfig(BoardId.SoulsDivineBoost).MaxLevel then
                db = false
                functions.SetSetting("autoSoulDPBoard", false)
                if functions.ConnectionExists("StatServiceClient.StatChanged(7)") == true then
                    functions.DestroyConnection("StatServiceClient.StatChanged(7)")
                end
                autoSoulDPBoardFunctions:updateText("Auto Soul DP Board: "..functions.GetTextFromSetting("autoSoulDPBoard"))
                autoSoulDPBoardFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoSoulDPBoard")))
                popupServiceFunctions.show({Text = "Soul DP Board is Maxed! Auto Soul DP Board disabled.", Duration = 5})
                return
            end

            local board = (function()
                for _, v in pairs(DPBoards:GetChildren()) do
                    local boardId = idFunctions.getBoardId(v)

                    if boardId == BoardId.SoulsDivineBoost then
                        return v
                    end
                end

                return nil
            end)()

            if board ~= nil then
                templeServiceFunctions.purchaseMaxDPBoard(board)
            end
            task.wait(0.5)
            db = false
        end

        if functions.GetSetting("autoSoulDPBoard") == true then
            auto()

            functions.NewConnection("StatServiceClient.StatChanged(7)", StatServiceClient.StatChanged:Connect(function(stat, value)
                auto()
            end))
        else
            functions.DestroyConnection("StatServiceClient.StatChanged(7)")
        end
    end

    function upgradeFunctions.autoRelicDPBoard()
        functions.SetSetting("autoRelicDPBoard", not functions.GetSetting("autoRelicDPBoard"))
        autoRelicDPBoardFunctions:updateText("Auto Relic DP Board: "..functions.GetTextFromSetting("autoRelicDPBoard"))
        autoRelicDPBoardFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoRelicDPBoard")))

        local db = false

        local function auto()
            if db == true then return end
            db = true

            if templeServiceFunctions.getDivinePowerBoardLevel(TempleId.RelicsTemple) == templeServiceFunctions.getDivinePowerBoardConfig(BoardId.RelicsDivineBoost).MaxLevel then
                db = false
                functions.SetSetting("autoRelicDPBoard", false)
                if functions.ConnectionExists("StatServiceClient.StatChanged(8)") == true then
                    functions.DestroyConnection("StatServiceClient.StatChanged(8)")
                end
                autoRelicDPBoardFunctions:updateText("Auto Relic DP Board: "..functions.GetTextFromSetting("autoRelicDPBoard"))
                autoRelicDPBoardFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoRelicDPBoard")))
                popupServiceFunctions.show({Text = "Relic DP Board is Maxed! Auto Relic DP Board disabled.", Duration = 5})
                return
            end

            local board = (function()
                for _, v in pairs(DPBoards:GetChildren()) do
                    local boardId = idFunctions.getBoardId(v)

                    if boardId == BoardId.RelicsDivineBoost then
                        return v
                    end
                end

                return nil
            end)()

            if board ~= nil then
                templeServiceFunctions.purchaseMaxDPBoard(board)
            end
            task.wait(0.5)
            db = false
        end

        if functions.GetSetting("autoRelicDPBoard") == true then
            auto()

            functions.NewConnection("StatServiceClient.StatChanged(8)", StatServiceClient.StatChanged:Connect(function(stat, value)
                auto()
            end))
        else
            functions.DestroyConnection("StatServiceClient.StatChanged(8)")
        end
    end

    function upgradeFunctions.autoBibleDPBoard()
        functions.SetSetting("autoBibleDPBoard", not functions.GetSetting("autoBibleDPBoard"))
        autoBibleDPBoardFunctions:updateText("Auto Bible DP Board: "..functions.GetTextFromSetting("autoBibleDPBoard"))
        autoBibleDPBoardFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoBibleDPBoard")))

        local db = false

        local function auto()
            if db == true then return end
            db = true

            if templeServiceFunctions.getDivinePowerBoardLevel(TempleId.BibleTemple) == templeServiceFunctions.getDivinePowerBoardConfig(BoardId.BibleDivineBoost).MaxLevel then
                db = false
                functions.SetSetting("autoBibleDPBoard", false)
                if functions.ConnectionExists("StatServiceClient.StatChanged(9)") == true then
                    functions.DestroyConnection("StatServiceClient.StatChanged(9)")
                end
                autoBibleDPBoardFunctions:updateText("Auto Bible DP Board: "..functions.GetTextFromSetting("autoBibleDPBoard"))
                autoBibleDPBoardFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoBibleDPBoard")))
                popupServiceFunctions.show({Text = "Bible DP Board is Maxed! Auto Bible DP Board disabled.", Duration = 5})
                return
            end

            local board = (function()
                for _, v in pairs(DPBoards:GetChildren()) do
                    local boardId = idFunctions.getBoardId(v)

                    if boardId == BoardId.BibleDivineBoost then
                        return v
                    end
                end

                return nil
            end)()

            if board ~= nil then
                templeServiceFunctions.purchaseMaxDPBoard(board)
            end
            task.wait(0.5)
            db = false
        end

        if functions.GetSetting("autoBibleDPBoard") == true then
            auto()

            functions.NewConnection("StatServiceClient.StatChanged(9)", StatServiceClient.StatChanged:Connect(function(stat, value)
                auto()
            end))
        else
            functions.DestroyConnection("StatServiceClient.StatChanged(9)")
        end
    end

    function upgradeFunctions.autoDepositMainTemple()
        functions.SetSetting("autoDepositMainTemple", not functions.GetSetting("autoDepositMainTemple"))
        autoDepositMainTempleFunctions:updateText("Auto Deposit Main Temple: "..functions.GetTextFromSetting("autoDepositMainTemple"))
        autoDepositMainTempleFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoDepositMainTemple")))

        local db = false

        local function auto()
            if db == true then return end
            db = true

            if templeServiceFunctions.isTempleBuilt(TempleId.MainTemple) ~= true then
                if templeServiceFunctions.areAllCurrencyTemplesCompleted() == true then
                    templeServiceFunctions.requestBuildTemple(TempleId.MainTemple)
                end
            end

            if templeServiceFunctions.getTempleLevel(TempleId.MainTemple) == templeServiceFunctions.getTempleConfig(TempleId.MainTemple).MaxLevel then
                db = false
                functions.SetSetting("autoDepositMainTemple", false)
                if functions.ConnectionExists("StatServiceClient.StatChanged(10)") == true then
                    functions.DestroyConnection("StatServiceClient.StatChanged(10)")
                end
                autoDepositMainTempleFunctions:updateText("Auto Deposit Main Temple: "..functions.GetTextFromSetting("autoDepositMainTemple"))
                autoDepositMainTempleFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoDepositMainTemple")))
                popupServiceFunctions.show({Text = "Main Temple is Maxed! Auto Deposit Main Temple disabled.", Duration = 5})
                return
            end

            if templeServiceFunctions.isTempleBuilt(TempleId.MainTemple) == true then
                templeServiceFunctions.depositAll()
                templeServiceFunctions.requestUpgradeTemple(TempleId.MainTemple)
            end
            task.wait(0.5)
            db = false
        end

        if functions.GetSetting("autoDepositMainTemple") == true then
            auto()

            functions.NewConnection("StatServiceClient.StatChanged(10)", StatServiceClient.StatChanged:Connect(function(stat, value)
                auto()
            end))
        else
            functions.DestroyConnection("StatServiceClient.StatChanged(10)")
        end
    end

    function upgradeFunctions.autoHellStairsNodes()
        functions.SetSetting("autoHellStairsNodes", not functions.GetSetting("autoHellStairsNodes"))
        autoHellStairsNodesFunctions:updateText("Auto Hell Stairs Nodes: "..functions.GetTextFromSetting("autoHellStairsNodes"))
        autoHellStairsNodesFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoHellStairsNodes")))

        local db = false

        local function auto()
            if db == true then return end
            db = true

            local t = {}

            for _, v in pairs(Trees.HellStairs:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("Node") then
                    if upgradeTreeServiceFunctions.checkNodeAvailable(v) == true then
                        table.insert(t, v)
                    end
                end 
            end

            functions.DebugPrint("Hell Stairs Nodes: "..tostring(#t))
            upgradeTreeServiceFunctions.purchaseNodes(t)
            task.wait(0.5)
            db = false
        end

        if functions.GetSetting("autoHellStairsNodes") == true then
            auto()

            functions.NewConnection("StatServiceClient.StatChanged(11)", StatServiceClient.StatChanged:Connect(function(stat, value)
                auto()
            end))
        else
            functions.DestroyConnection("StatServiceClient.StatChanged(11)")
        end
    end

    function upgradeFunctions.autoStairwayNodes()
        functions.SetSetting("autoStairwayNodes", not functions.GetSetting("autoStairwayNodes"))
        autoStairwayNodesFunctions:updateText("Auto Stairway Nodes: "..functions.GetTextFromSetting("autoStairwayNodes"))
        autoStairwayNodesFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoStairwayNodes")))

        local db = false

        local function auto()
            if db == true then return end
            db = true

            local t = {}

            for _, v in pairs(Trees.Stairway:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("Node") then
                    if upgradeTreeServiceFunctions.checkNodeAvailable(v) == true then
                        table.insert(t, v)
                    end
                end 
            end

            functions.DebugPrint("Stairway Nodes: "..tostring(#t))
            upgradeTreeServiceFunctions.purchaseNodes(t)
            task.wait(0.5)
            db = false
        end

        if functions.GetSetting("autoStairwayNodes") == true then
            auto()

            functions.NewConnection("StatServiceClient.StatChanged(12)", StatServiceClient.StatChanged:Connect(function(stat, value)
                auto()
            end))
        else
            functions.DestroyConnection("StatServiceClient.StatChanged(12)")
        end
    end

    function upgradeFunctions.autoUnderworld()
        functions.SetSetting("autoUnderworld", not functions.GetSetting("autoUnderworld"))
        autoUnderworldFunctions:updateText("Auto Underworld: "..functions.GetTextFromSetting("autoUnderworld"))
        autoUnderworldFunctions:updateGradient(uiCreationFunctions.getGradient(functions.GetSetting("autoUnderworld")))

        local db = false

        local function auto()
            if db == true then return end
            db = true

            local treeT = {}
            local boardt = {}

            for _, v in pairs(Trees["Zone_5(Underworld)"].Nodes:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("Node") then
                    if upgradeTreeServiceFunctions.isNodeColorCurrency(v.Node.Node, GameEnum.Currency.Embers) == true and upgradeTreeServiceFunctions.checkNodeAvailable(v, true) == true then
                        table.insert(treeT, v)
                    end
                end 
            end

            for _, v in pairs(Boards.Zone5:GetChildren()) do
                if v:IsA("Part") then
                    local zoneId = idFunctions.getZoneId(v)
                    local boardId = idFunctions.getBoardId(v)
                    local zone = UpgradeBoards.Zones[zoneId]
                    local board = zone and zone.Boards[boardId]

                    if zone ~= nil and board ~= nil then
                        if upgradeBoardServiceFunctions.isBoardTypeValid(board.BoardType) == true then
                            table.insert(boardt, v)
                        end
                    end
                end 
            end

            functions.DebugPrint("Underworld Nodes: "..tostring(#treeT))
            functions.DebugPrint("Underworld Boards: "..tostring(#boardt))
            upgradeTreeServiceFunctions.purchaseNodes(treeT, true)
            upgradeBoardServiceFunctions.purchaseBoards(boardt)
            task.wait(0.5)
            db = false
        end

        if functions.GetSetting("autoUnderworld") == true then
            auto()

            functions.NewConnection("StatServiceClient.StatChanged(4)", StatServiceClient.StatChanged:Connect(function(stat, value)
                auto()
            end))
        else
            functions.DestroyConnection("StatServiceClient.StatChanged(4)")
        end
    end
end

-------------------->> Close Buttons <<--------------------
popupServiceFunctions.show({Text = "Loading connections..."; Duration = 2;})

do
    functions.NewConnection("closeButton.MouseButton1Click", closeButton.MouseButton1Click:Connect(function()
        getgenv().Destroy()
    end))

    functions.NewConnection("closeButtonSettings.MouseButton1Click", closeButtonSettings.MouseButton1Click:Connect(function()
        backSettingsFrame.Visible = false
    end))

    functions.NewConnection("closeButtonUpgrades.MouseButton1Click", closeButtonUpgrades.MouseButton1Click:Connect(function()
        backUpgradesFrame.Visible = false
    end))
end

-------------------->> Main Buttons <<--------------------

do
    functions.NewConnection("farmSpirits.MouseButton1Click", farmSpiritsButton.MouseButton1Click:Connect(function()
        mainFunctions.autoFarmSpirits()
    end))

    functions.NewConnection("spawnEliteSpirit.MouseButton1Click", spawnEliteSpiritButton.MouseButton1Click:Connect(function()
        mainFunctions.autoSpawnEliteSpirit()
    end))

    functions.NewConnection("farmBossSpirit.MouseButton1Click", farmBossSpiritButton.MouseButton1Click:Connect(function()
        mainFunctions.autoFarmBossSpirit()
    end))

    functions.NewConnection("farmSurgeButton.MouseButton1Click", farmSurgeButton.MouseButton1Click:Connect(function()
        mainFunctions.autoFarmSurge()
    end))

    functions.NewConnection("autoReincarnateButton.MouseButton1Click", autoReincarnateButton.MouseButton1Click:Connect(function()
        mainFunctions.autoReincarnate()
    end))

    functions.NewConnection("autoClickRelicButton.MouseButton1Click", autoClickRelicButton.MouseButton1Click:Connect(function()
        mainFunctions.autoClickRelic()
    end))
end

-------------------->> Settings Buttons <<--------------------

do
    functions.NewConnection("rebirthIfUnAffButton.MouseButton1Click", rebirthIfUnAffButton.MouseButton1Click:Connect(function()
        settingsFunctions.autoRebirthIfUnAff()
    end))

    functions.NewConnection("autoBuyTrialShopButton.MouseButton1Click", autoBuyTrialShopButton.MouseButton1Click:Connect(function()
        settingsFunctions.autoBuyTrialShop()
    end))

    functions.NewConnection("autoRadianceBoostButton.MouseButton1Click", autoRadianceBoostButton.MouseButton1Click:Connect(function()
        settingsFunctions.autoRadianceBoostWhenMax()
    end))

    functions.NewConnection("autoAscendButton.MouseButton1Click", autoAscendButton.MouseButton1Click:Connect(function()
        settingsFunctions.autoAscend()
    end))

    functions.NewConnection("ascendButton.MouseButton1Click", ascendButton.MouseButton1Click:Connect(function()
        ascensionServiceFunctions.RequestAscension()
        popupServiceFunctions.show({Text = "Requesting Ascension...", Duration = 3})
    end))

    functions.NewConnection("copyScriptButton.MouseButton1Click", copyScriptButton.MouseButton1Click:Connect(function()
        setclipboard(scriptHttp)
        popupServiceFunctions.show({Text = "Script Copied to Clipboard!", Duration = 3})
    end))

    functions.NewConnection("queueOnTeleportButton.MouseButton1Click", queueOnTeleportButton.MouseButton1Click:Connect(function()
        queue_on_teleport(scriptHttp)
        popupServiceFunctions.show({Text = "Script Queued on Teleport! Can't be disabled until teleportation is complete.", Duration = 3})
    end))
end

-------------------->> Upgrades Buttons <<--------------------

do
    functions.NewConnection("autoZone1Button.MouseButton1Click", autoZone1Button.MouseButton1Click:Connect(function()
        upgradeFunctions.autoZone1()
    end))

    functions.NewConnection("autoZone2Button.MouseButton1Click", autoZone2Button.MouseButton1Click:Connect(function()
        upgradeFunctions.autoZone2()
    end))

    functions.NewConnection("autoZone3NoEliteSoulsButton.MouseButton1Click", autoZone3NoEliteSoulsButton.MouseButton1Click:Connect(function()
        upgradeFunctions.autoZone3NoEliteSouls()
    end))

    functions.NewConnection("autoZone3EliteSoulsButton.MouseButton1Click", autoZone3EliteSoulsButton.MouseButton1Click:Connect(function()
        upgradeFunctions.autoZone3EliteSouls()
    end))

    functions.NewConnection("autoSoulTempleButton.MouseButton1Click", autoSoulTempleButton.MouseButton1Click:Connect(function()
        upgradeFunctions.autoSoulTemple()
    end))

    functions.NewConnection("autoRelicTempleButton.MouseButton1Click", autoRelicTempleButton.MouseButton1Click:Connect(function()
        upgradeFunctions.autoRelicTemple()
    end))

    functions.NewConnection("autoBibleTempleButton.MouseButton1Click", autoBibleTempleButton.MouseButton1Click:Connect(function()
        upgradeFunctions.autoBibleTemple()
    end))

    functions.NewConnection("autoSoulDPBoardButton.MouseButton1Click", autoSoulDPBoardButton.MouseButton1Click:Connect(function()
        upgradeFunctions.autoSoulDPBoard()
    end))

    functions.NewConnection("autoRelicDPBoardButton.MouseButton1Click", autoRelicDPBoardButton.MouseButton1Click:Connect(function()
        upgradeFunctions.autoRelicDPBoard()
    end))

    functions.NewConnection("autoBibleDPBoardButton.MouseButton1Click", autoBibleDPBoardButton.MouseButton1Click:Connect(function()
        upgradeFunctions.autoBibleDPBoard()
    end))

    functions.NewConnection("autoDepositMainTempleButton.MouseButton1Click", autoDepositMainTempleButton.MouseButton1Click:Connect(function()
        upgradeFunctions.autoDepositMainTemple()
    end))

    functions.NewConnection("autoHellStairsNodesButton.MouseButton1Click", autoHellStairsNodesButton.MouseButton1Click:Connect(function()
        upgradeFunctions.autoHellStairsNodes()
    end))

    functions.NewConnection("autoStairwayNodesButton.MouseButton1Click", autoStairwayNodesButton.MouseButton1Click:Connect(function()
        upgradeFunctions.autoStairwayNodes()
    end))

    functions.NewConnection("autoUnderworldButton.MouseButton1Click", autoUnderworldButton.MouseButton1Click:Connect(function()
        upgradeFunctions.autoUnderworld()
    end))
end

-------------------->> Side Buttons <<--------------------

do
    functions.NewConnection("rebirthButton.MouseButton1Click", rebirthButton.MouseButton1Click:Connect(function()
        functions.rebirth()
    end))

    functions.NewConnection("settingsButton.MouseButton1Click", settingsButton.MouseButton1Click:Connect(function()
        backUpgradesFrame.Visible = false
        backSettingsFrame.Visible = not backSettingsFrame.Visible
    end))

    functions.NewConnection("upgradesButton.MouseButton1Click", upgradesButton.MouseButton1Click:Connect(function()
        backSettingsFrame.Visible = false
        backUpgradesFrame.Visible = not backUpgradesFrame.Visible
    end))
end

-------------------->> Loading Ended <<--------------------

print("Loading End Time: "..tostring(DateTime.now().UnixTimestamp - LoadingTime))
popupServiceFunctions.show({Text = "GigaHub took "..tostring(DateTime.now().UnixTimestamp - LoadingTime).." seconds to load."})
