-------------------->> Execution Check <<--------------------

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

local EliteSpawnBoard = Boards.Zone4.EliteSpawner.EliteSpawnBoard
local SpawnButton     = EliteSpawnBoard.Container.UnlockedContent.SpawnButton

local RebirthBoard  = Boards.Zone1.Rebirth.UpgradeBoardUI
local RebirthButton = RebirthBoard.Frame.Content.ButtonContainer.RebirthButton

local BossPlatforms = Work.Trials.BossFight.Charges

local Underworld   = Work.Underworld
local Underworld_1 = Underworld.Underworld_1
local Tower        = Underworld_1.Tower
local Radiances    = Tower.Radiances

local gameServices               = ReplicatedStorage.Services
local EmberServiceClient         = require(gameServices.EmberService.EmberServiceClient)
local ReincarnationServiceClient = require(gameServices.ReincarnationService.ReincarnationServiceClient)
local RelicServiceClient         = require(gameServices.RelicService.RelicServiceClient)
local AscensionServiceClient     = require(gameServices.AscensionService.AscensionServiceClient)
local PopupServiceClient         = require(gameServices.PopupService.PopupServiceClient)
local StatServiceClient          = require(gameServices.StatService.StatServiceClient)
local TrialShopServiceClient     = require(gameServices.TrialShopService.TrialShopServiceClient)
local TempleServiceClient        = require(gameServices.TempleService.TempleServiceClient)
local TempleBoardServiceClient   = require(gameServices.TempleBoardService.TempleBoardServiceClient)
local UpgradeBoardServiceClient  = require(gameServices.UpgradeBoardService.UpgradeBoardServiceClient)
local UpgradeTreeServiceClient   = require(gameServices.UpgradeTreeService.UpgradeTreeServiceClient)

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
    autoBuyTrialShop = false;
    FarmSpirits = false;
    autoSpawnEliteSpirit = false;
    FarmBossSpirit = false;
    FarmSurge = false;
    autoRadianceBoostWhenMax = false;
    autoReincarnate = false;
    autoClickRelic = false;

    autoZone1 = false;
    autoZone2 = false;
    autoZone3NoEliteSouls = false;
    autoZone3EliteSouls = false;
    autoUnderworld = false;

    autoSoulTemple = false;
    autoRelicTemple = false;
    autoBibleTemple = false;
    autoSoulDPBoard = false;
    autoRelicDPBoard = false;
    autoBibleDPBoard = false;
    autoDepositMainTemple = false;
    
    autoHellStairsNodes = false;
    autoStairwayNodes = false;

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
        getgenv().Settings.FarmSpirits              = false
        getgenv().Settings.autoSpawnEliteSpirit     = false
        getgenv().Settings.FarmBossSpirit           = false
        getgenv().Settings.FarmSurge                = false
        getgenv().Settings.autoRadianceBoostWhenMax = false;
        getgenv().Settings.autoReincarnate          = false;
        getgenv().Settings.autoClickRelic           = false;
        getgenv().Settings.autoZone1                = false;
        getgenv().Settings.autoZone2                = false;
        getgenv().Settings.autoZone3NoEliteSouls    = false;
        getgenv().Settings.autoZone3EliteSouls      = false;
        getgenv().Settings.autoUnderworld           = false;
        getgenv().Settings.autoSoulTemple           = false;
        getgenv().Settings.autoRelicTemple          = false;
        getgenv().Settings.autoBibleTemple          = false;
        getgenv().Settings.autoSoulDPBoard          = false;
        getgenv().Settings.autoRelicDPBoard         = false;
        getgenv().Settings.autoBibleDPBoard         = false;
        getgenv().Settings.autoDepositMainTemple    = false;
        getgenv().Settings.autoHellStairsNodes      = false;
        getgenv().Settings.autoStairwayNodes        = false;
        PrintTable(getgenv().Settings)
    end
end

-------------------->> Functions <<--------------------

local function CreateTW(Object, Info, Properties)
	local Success, result = pcall(function ()
		return TweenService:Create(Object, Info, Properties)
	end)

	if Success == true then
		return result
	end
end

local function DebugPrint(...)
    if getgenv().Debugger ~= true then return end

    print(...)
end

local function DebugAssert(...)
    if getgenv().Debugger ~= true then return end

    assert(...)
end

local function Validate(defaults, options)
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

local function getAttribute(checkObject:Instance, attribute: string, lowerString: boolean)
	if typeof(checkObject) ~= "Instance" or typeof(attribute) ~= "string" then return end
	local value = checkObject:GetAttribute(attribute)

	if typeof(value) == "string" and lowerString == true then
		return string.lower(value)
	end

	return value
end

local function NewConnection(Identifier, Connection)
    DebugAssert(typeof(Identifier) == 'string', ("Expected 'string' got '%s'!"):format(typeof(Identifier)))
    DebugAssert(getgenv().Settings.Connections[Identifier] == nil, ("Connection with Identifier, '%s' was already made!"):format(Identifier))
    DebugAssert(typeof(Connection) == 'RBXScriptConnection' or typeof(Connection) == 'table', ("Expected 'RBXScriptConnection' or 'table' got '%s'!"):format(typeof(Connection)))

    getgenv().Settings.Connections[Identifier] = Connection
    DebugPrint("Made a new connection for "..Identifier)
end

local function DestroyConnection(Identifier)
    DebugAssert(typeof(Identifier) == 'string', ("Expected 'string' got '%s'!"):format(typeof(Identifier)))
    DebugAssert(getgenv().Settings.Connections[Identifier] ~= nil, ("'%s' was not found in the Connections table!"):format(Identifier))

    getgenv().Settings.Connections[Identifier]:Disconnect()
    getgenv().Settings.Connections[Identifier] = nil
    DebugPrint("Destroyed connection for "..Identifier)
end

local function GetHumanoid()
	local Character = Player.Character
	local Humanoid = Character:FindFirstChild("Humanoid")

	if Humanoid ~= nil and Humanoid.Health > 0 then
		return Character.Humanoid
	end
end

local function GetHumanoidRootPart()
	local Character = Player.Character
	local Humanoid = GetHumanoid()

	if Humanoid ~= nil and Humanoid.Health > 0 then
		return Character.HumanoidRootPart
	end
end

local function GetLastCFrame()
    local Character = Player.Character
    local Humanoid = GetHumanoid()

    if Humanoid ~= nil and Humanoid.Health > 0 then
        return Character.HumanoidRootPart.CFrame
    end
end

-------------------->> game functions <<--------------------

local function getBoss()
    return if Work:FindFirstChild("BossSpiritBoss") then Work.BossSpiritBoss else nil
end

local function getBossPlatForm()
    if getBoss() == nil then return nil end

    for i, v in pairs(BossPlatforms:GetChildren()) do
        if v:IsA("Part") and v:FindFirstChild("TouchInterest") ~= nil then
            return v
        end
    end

    return nil
end

local function getSpirit()
    for i, v in pairs(Work:GetChildren()) do
        if v:IsA("Model") and string.lower(v.Name):match("spirit") ~= nil and (v:FindFirstChild("HealthBar") ~= nil or v:FindFirstChild("EliteAura") ~= nil) then
            return v
        end
    end

    return nil
end

-------------------->> get ids <<--------------------

local function getZoneId(object)
    return getAttribute(object, "ZoneId")
end 

local function getTempleId(object)
    return getAttribute(object, "TempleId")
end

local function getBoardId(object)
    return getAttribute(object, "BoardId")
end

local function getTreeId(object)
    return getAttribute(object, "TreeId")
end

local function getNodeId(object)
    return getAttribute(object, "NodeId")
end

-------------------->> Theme <<--------------------

local function getCurrencyColor(currency: string)
    return theme.getCurrencyColor(currency)
end

local function getNodeColor(nodeId: string)
    return theme.getNodeColor(nodeId)
end

-------------------->> EmberServiceClient <<--------------------

local function isSurgeActive()
    return EmberServiceClient.IsSurgeActive()
end

local function getSurgePosition()
    return EmberServiceClient.GetSurgePosition()
end

local function IsPlayerInSurge()
    return EmberServiceClient.IsPlayerInSurge()
end

local function getSurgeTimeRemaining()
    return EmberServiceClient.GetSurgeTimeRemaining()
end

local function RequestActivateRadiance()
    EmberServiceClient.RequestActivateRadiance()
end

local function GetRadianceCharges()
    return EmberServiceClient.GetRadianceCharges()
end

local function GetRadianceMaxCharges()
    return EmberServiceClient.GetRadianceMaxCharges()
end

-------------------->> ReincarnationServiceClient <<--------------------

local function reincarnationIsMaxed()
    return ReincarnationServiceClient.IsMaxed()
end

local function RequestReincarnation()
    ReincarnationServiceClient.RequestReincarnation()
end

-------------------->> AscensionServiceClient <<--------------------

local function RequestAcension()
    AscensionServiceClient.RequestAscension()
end

-------------------->> RelicServiceClient <<--------------------

local function relicClick()
    RelicServiceClient.Click()
    --Packets.RelicClick:Fire({})
end

-------------------->> PopupServiceClient <<--------------------

local function show(options)
    options = Validate({
        Text = "This is a test popup!";
        Duration = 5;
        ButtonText = "";
        ButtonAction = nil;
    }, options)
    
    PopupServiceClient.Show(options)
end

-------------------->> TrialShopServiceClient <<--------------------

local function getAllStock()
    return TrialShopServiceClient.GetAllStock()
end

local function isMaxLevel(id)
    return TrialShopServiceClient.IsMaxLevel(id)
end

local function trialShopRequestPurchase(id)
    TrialShopServiceClient.RequestPurchase(id)
    --[[
    Packets.RequestTrialShopPurchase:Fire({
        ["ItemId"] = id
    })
    ]]
end

local function buyOutTrialShop()
    local stock = getAllStock()

    for id, amount in pairs(stock) do
        if isMaxLevel(id) == false then
            for i = 1, amount do
                trialShopRequestPurchase(id)
            end
        end
    end
end

-------------------->> TempleServiceClient <<--------------------

local function getTempleLevel(id)
    return TempleServiceClient.GetTempleLevel(id)
end

local function isTempleBuilt(id)
    return TempleServiceClient.IsTempleBuilt(id)
end

local function getDivinePowerBoardLevel(id)
    return TempleServiceClient.GetDivinePowerBoardLevel(id)
end

local function areAllCurrencyTemplesCompleted()
    return TempleBoardServiceClient.AreAllCurrencyTemplesCompleted()
end

local function RequestBuildTemple(id)
    TempleServiceClient.RequestBuildTemple(id)
    --[[
    Packets.RequestBuildTemple:Fire({
		["TempleId"] = id
	})
    ]]
end

local function RequestUpgradeTemple(id, amount)
    TempleServiceClient.RequestUpgradeTemple(id, amount)
    --[[
    Packets.RequestUpgradeTemple:Fire({
        ["TempleId"] = id,
        ["Amount"] = amount == nil and 1 or amount
    })
    ]]
end

local function RequestUpgradeDPBoard(id, amount)
    TempleServiceClient.RequestUpgradeDPBoard(id, amount)
    --[[
    Packets.RequestUpgradeDivinePowerBoard:Fire({
        ["BoardId"] = id,
        ["Amount"] = amount == nil and 1 or amount
    })
    ]]
end

local function RequestDeposit(currency, percentage)
    TempleServiceClient.RequestDeposit(currency, percentage)
    --[[
    Packets.RequestDepositToMainTemple:Fire({
        ["Currency"] = currency,
        ["Percentage"] = percentage
    })
    ]]
end

local function depositAll()
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
        RequestDeposit(v, 100)
    end
end

-------------------->> UpgradeBoardServiceClient <<--------------------

local function boardRequestPurchase(zone, id, amount)
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

local function isBoardTypeValid(boardType)
    return boardType ~= "Rebirth" and boardType ~= "Reincarnation" and boardType ~= "Clicker"
end

local function purchaseBoards(t: {Part})
    if typeof(t) ~= "table" then return end

    for _, v in pairs(t) do
        local zoneId = getZoneId(v)
        local boardId = getBoardId(v)

        if zoneId ~= nil and boardId ~= nil then
            if v:FindFirstChild("UpgradeBoardUI") then
                pcall(function()
                    local boardUI = v:FindFirstChild("UpgradeBoardUI")
                    local fr = boardUI.Frame
                    local content = fr.Content
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
                        for _, but in ipairs(content:GetDescendants()) do
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

-------------------->> UpgradeTreeServiceClient <<--------------------

local function treeRequestPurchase(zone, tree, node)
    UpgradeTreeServiceClient.RequestPurchase(zone, tree, node)
    --[[
    Packets.PurchaseTreeNode:Fire({
        ["ZoneId"] = zone,
        ["TreeId"] = tree,
        ["NodeId"] = node
    })
    ]]
end

local function isNodeVisible(zone, tree, node)
    return UpgradeTreeServiceClient.IsNodeVisible(zone, tree, node)
end

local function isNodePurchased(zone, tree, node)
    return UpgradeTreeServiceClient.IsNodePurchased(zone, tree, node)
end

local function isNodeHidden(zone, tree, node)
    return UpgradeTreeServiceClient.IsNodeHidden(zone, tree, node)
end

local function purchaseUnderworldNode(node)
    treeRequestPurchase(ZoneId.Underworld, "CorruptionTree", node)
end

local function canPurchaseNode(zoneId, treeId, nodeId)
    if isNodePurchased(zoneId, treeId, nodeId) == true or isNodeHidden(zoneId, treeId, nodeId) == true or isNodeVisible(zoneId, treeId, nodeId) == false then
        return false
    end

    return true
end

local function isNodeColorCurrency(object: BasePart, currency: string)
    if getNodeColor(currency) == object.Color then
        return true
    end

    if currency == GameEnum.Currency.Embers then
        if object.Color == Color3.fromRGB(180, 50, 50) then
            return true
        end
    end

    return false
end

local function checkNodeAvailable(object: Model, underworld: boolean?)
    local zoneId = getZoneId(object)
    local treeId = getTreeId(object)
    local nodeId = getNodeId(object)

    if underworld == true then
        zoneId = ZoneId.Underworld
        treeId = "CorruptionTree"
    end

    if zoneId == nil or treeId == nil or nodeId == nil then
        return false
    end

    if canPurchaseNode(zoneId, treeId, nodeId) == true then
        return true
    end

    return false
end

local function purchaseNodes(t: {Model}, underworld: boolean?)
    if typeof(t) ~= "table" then return end

    for _, v in ipairs(t) do
        local zoneId = getZoneId(v)
        local treeId = getTreeId(v)
        local nodeId = getNodeId(v)

        if underworld == true then
            purchaseUnderworldNode(nodeId)
        else
            treeRequestPurchase(zoneId, treeId, nodeId)
        end
    end
end

-------------------->> Functions continued <<--------------------

local function rebirth()
    -- if typeof(firesignal) == "function" then
    --     firesignal(RebirthButton.Activated)
    -- end
    boardRequestPurchase(ZoneId.Zone1_Church, "Rebirth", 1)
end

local function spawnElite()
    if typeof(firesignal) == "function" then
        firesignal(SpawnButton.MouseButton1Click)
    end
end

local function GetTextFromSetting(Setting)
    DebugAssert(typeof(Setting) == 'string', ("Expected 'string' got '%s'!"):format(typeof(Setting)))

    if getgenv().Settings[Setting] ~= nil then
        return tostring(getgenv().Settings[Setting])
    end

    return ""
end

local function SetSetting(Setting, Value)
    DebugAssert(typeof(Setting) == 'string', ("Expected 'string' got '%s'!"):format(typeof(Setting)))
    DebugAssert(Value ~= nil, "Value cannot be 'nil'!")

    if getgenv().Settings[Setting] ~= nil then
        getgenv().Settings[Setting] = Value
    end
end

local function GetSetting(Setting)
    DebugAssert(typeof(Setting) == 'string', ("Expected 'string' got '%s'!"):format(typeof(Setting)))

    if getgenv().Settings[Setting] ~= nil then
        return getgenv().Settings[Setting]
    end

    return nil
end

local function Draggable(DragFrame, DragBoundary, dragDuration)
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

            CreateTW(object, TweenInfo.new(dragSpeed), {Position = position}):Play()
        end)
    end

    NewConnection(DragFrame:GetFullName().."InputBegan", DragFrame.InputBegan:Connect(function(input)
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

    NewConnection("UserInputServiceInputChanged", UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragToggle then
                updateInput(input, DragFrame)
            end
        end
    end))
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

local function validateProperty(validateVal, defaultVal)
    return if validateVal ~= nil then validateVal else defaultVal
end

local function getGradient(Setting)
    if Setting == true then
        return gradients.green
    else
        return gradients.red
    end
end

-------------------->> construction <<--------------------
show({Text = "Loading, please wait..."; Duration = 3;})

local function constructGradient(options)
    options = Validate({
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

local function constructUiAspect(options)
    options = Validate({
        AspectRatio = 1;
        Parent = nil;
    }, options)

    local uiAspect = Instance.new("UIAspectRatioConstraint")
    uiAspect.AspectRatio = options["AspectRatio"]
    uiAspect.Parent = options["Parent"]

    return uiAspect
end

local function constructUIStroke(options)
    options = Validate({
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

local function constructTextLabel(options)
    options = Validate({
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

    constructUIStroke({Parent = textLabel;})

    return textLabel
end

local function constructImageButton(options)
    options = Validate({
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

    local grad = constructGradient({Parent = imageButton; Gradient = options["Gradient"]})
    local textL = constructTextLabel({Parent = imageButton; Text = options["Text"];})

    local functions = {}

    function functions:updateText(text)
        textL.Text = text
    end

    function functions:updateGradient(gradient)
        grad.Color = gradient
    end

    function functions:updateLayoutOrder(order)
        imageButton.LayoutOrder = order
    end

    return imageButton, functions
end

local function constructImageButton2(options)
    options = Validate({
        Size = UDim2.new(0.235, 0, 0.04, 45);
        Gradient = gradients.gray;
    }, options)

    local button, functions = constructImageButton(options)

    if button:FindFirstChildOfClass("TextLabel") then
        button:FindFirstChildOfClass("TextLabel"):Destroy()
    end

    return button, functions
end

local function constructImageLabel(options)
    options = Validate({
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
Draggable(backFrame, ScreenGui)
constructUIStroke({
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

local TitleFrame = constructTextLabel({
    Parent = backFrame;
    AnchorPoint = Vector2.new(0, 1);
    Position = UDim2.fromScale(0, -0.05);
    Size = UDim2.fromScale(0.9, 0.1);
    Text = "Faith Incremental";
    TextXAlignment = Enum.TextXAlignment.Left;
})

constructUiAspect({Parent = TitleFrame; AspectRatio = 9.933})
constructUiAspect({Parent = backFrame; AspectRatio = 1.104})

-------------------->> Settings Frame <<--------------------

local backSettingsFrame = Instance.new("Frame", backFrame)
backSettingsFrame.Name = "settings"
backSettingsFrame.AnchorPoint = Vector2.new(1, 0.5)
backSettingsFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
backSettingsFrame.BackgroundTransparency = 0.6
backSettingsFrame.Position = UDim2.fromScale(-0.185, 0.5)
backSettingsFrame.Size = UDim2.fromScale(0.9, 0.9)
backSettingsFrame.Visible = false
constructUIStroke({
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

local TitleSettings = constructTextLabel({
    Parent = backSettingsFrame;
    AnchorPoint = Vector2.new(0, 1);
    Position = UDim2.fromScale(0, -0.05);
    Size = UDim2.fromScale(0.9, 0.1);
    Text = "Settings";
    TextXAlignment = Enum.TextXAlignment.Left;
})

constructUiAspect({Parent = TitleSettings; AspectRatio = 9.933})
constructUiAspect({Parent = backSettingsFrame; AspectRatio = 1.104})

-------------------->> Upgrades Frame <<--------------------

local backUpgradesFrame = Instance.new("Frame", backFrame)
backUpgradesFrame.Name = "upgrades"
backUpgradesFrame.AnchorPoint = Vector2.new(1, 0.5)
backUpgradesFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
backUpgradesFrame.BackgroundTransparency = 0.6
backUpgradesFrame.Position = UDim2.fromScale(-0.185, 0.5)
backUpgradesFrame.Size = UDim2.fromScale(0.9, 0.9)
backUpgradesFrame.Visible = false
constructUIStroke({
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

local TitleUpgrades = constructTextLabel({
    Parent = backUpgradesFrame;
    AnchorPoint = Vector2.new(0, 1);
    Position = UDim2.fromScale(0, -0.05);
    Size = UDim2.fromScale(0.9, 0.1);
    Text = "Upgrades";
    TextXAlignment = Enum.TextXAlignment.Left;
})

constructUiAspect({Parent = TitleUpgrades; AspectRatio = 9.933})
constructUiAspect({Parent = backUpgradesFrame; AspectRatio = 1.104})

-------------------->> Close Buttons <<--------------------

local closeButton = constructImageButton({
    Parent = backFrame;
    Position = UDim2.fromScale(1.012, 0);
    Size = UDim2.new(1, 0, 0.06, 45);
    Text = "X";
    Gradient = gradients.red;
})
constructUiAspect({Parent = closeButton})

local closeButtonSettings = constructImageButton({
    Parent = backSettingsFrame;
    Position = UDim2.fromScale(1.012, 0);
    Size = UDim2.new(1, 0, 0.06, 45);
    Text = "X";
    Gradient = gradients.red;
})
constructUiAspect({Parent = closeButtonSettings})

local closeButtonUpgrades = constructImageButton({
    Parent = backUpgradesFrame;
    Position = UDim2.fromScale(1.012, 0);
    Size = UDim2.new(1, 0, 0.06, 45);
    Text = "X";
    Gradient = gradients.red;
})
constructUiAspect({Parent = closeButtonUpgrades})

-------------------->> Side Buttons <<--------------------

local settingsButton = constructImageButton2({
    Parent = backFrame;
    Position = UDim2.fromScale(1.012, 0.27);
    Gradient = gradients.gray;
})
constructImageLabel({Parent = settingsButton; Image = "rbxassetid://74669737175882";})
constructUiAspect({Parent = settingsButton})

local rebirthButton = constructImageButton2({
    Parent = backFrame;
    Position = UDim2.fromScale(1.012, 0.52);
    Gradient = gradients.gray;
})
constructImageLabel({Parent = rebirthButton; Image = "rbxassetid://129348613616339";})
constructUiAspect({Parent = rebirthButton})

local upgradesButton = constructImageButton2({
    Parent = backFrame;
    Position = UDim2.fromScale(1.012, 0.77);
    Gradient = gradients.gray;
})
constructImageLabel({Parent = upgradesButton; Image = "rbxassetid://126864380733796";})
constructUiAspect({Parent = upgradesButton})

-------------------->> Settings Frame <<--------------------

local rebirthIfUnAffButton, rebirthIfUnAffFunctions = constructImageButton({
    Parent = settingsFrame;
    Text = "Auto Rebirth for Elite Spirts: "..GetTextFromSetting("rebirthIfUnAff");
    Gradient = getGradient(GetSetting("rebirthIfUnAff"));
    LayoutOrder = 0;
})
constructUiAspect({Parent = rebirthIfUnAffButton; AspectRatio = 2.854})

local autoBuyTrialShopButton, autoBuyTrialShopFunctions = constructImageButton({
    Parent = settingsFrame;
    Text = "Auto Buy Trial Shop: "..GetTextFromSetting("autoBuyTrialShop");
    Gradient = getGradient(GetSetting("autoBuyTrialShop"));
    LayoutOrder = 1;
})
constructUiAspect({Parent = autoBuyTrialShopButton; AspectRatio = 2.854})

local autoRadianceBoostButton, autoRadianceBoostFunctions = constructImageButton({
    Parent = settingsFrame;
    Text = "Auto Radiance Boost When Max: "..GetTextFromSetting("autoRadianceBoostWhenMax");
    Gradient = getGradient(GetSetting("autoRadianceBoostWhenMax"));
    LayoutOrder = 2;
})
constructUiAspect({Parent = autoRadianceBoostButton; AspectRatio = 2.854})

local acsendButton = constructImageButton({
    Parent = settingsFrame;
    Text = "Ascend";
    Gradient = gradients.cyan;
    LayoutOrder = 999;
})
constructUiAspect({Parent = acsendButton; AspectRatio = 2.854})

-------------------->> Upgrades Frame <<--------------------

local autoZone1Button, autoZone1Functions = constructImageButton({
    Parent = upgradesFrame;
    Text = "Auto Zone 1: "..GetTextFromSetting("autoZone1");
    Gradient = getGradient(GetSetting("autoZone1"));
    LayoutOrder = 0;
})
constructUiAspect({Parent = autoZone1Button; AspectRatio = 2.854})

local autoZone2Button, autoZone2Functions = constructImageButton({
    Parent = upgradesFrame;
    Text = "Auto Zone 2: "..GetTextFromSetting("autoZone2");
    Gradient = getGradient(GetSetting("autoZone2"));
    LayoutOrder = 1;
})
constructUiAspect({Parent = autoZone2Button; AspectRatio = 2.854})

local autoZone3NoEliteSoulsButton, autoZone3NoEliteSoulsFunctions = constructImageButton({
    Parent = upgradesFrame;
    Text = "Auto Zone 3 No Elite Souls: "..GetTextFromSetting("autoZone3NoEliteSouls");
    Gradient = getGradient(GetSetting("autoZone3NoEliteSouls"));
    LayoutOrder = 2;
})
constructUiAspect({Parent = autoZone3NoEliteSoulsButton; AspectRatio = 2.854})

local autoZone3EliteSoulsButton, autoZone3EliteSoulsFunctions = constructImageButton({
    Parent = upgradesFrame;
    Text = "Auto Zone 3 Elite Souls: "..GetTextFromSetting("autoZone3EliteSouls");
    Gradient = getGradient(GetSetting("autoZone3EliteSouls"));
    LayoutOrder = 3;
})
constructUiAspect({Parent = autoZone3EliteSoulsButton; AspectRatio = 2.854})

local autoUnderworldButton, autoUnderworldFunctions = constructImageButton({
    Parent = upgradesFrame;
    Text = "Auto Underworld: "..GetTextFromSetting("autoUnderworld");
    Gradient = getGradient(GetSetting("autoUnderworld"));
    LayoutOrder = 4;
})
constructUiAspect({Parent = autoUnderworldButton; AspectRatio = 2.854})

local autoHellStairsNodesButton, autoHellStairsNodesFunctions = constructImageButton({
    Parent = upgradesFrame;
    Text = "Auto Hell Stairs Nodes: "..GetTextFromSetting("autoHellStairsNodes");
    Gradient = getGradient(GetSetting("autoHellStairsNodes"));
    LayoutOrder = 12;
})
constructUiAspect({Parent = autoHellStairsNodesButton; AspectRatio = 2.854})

local autoStairwayNodesButton, autoStairwayNodesFunctions = constructImageButton({
    Parent = upgradesFrame;
    Text = "Auto Stairway Nodes: "..GetTextFromSetting("autoStairwayNodes");
    Gradient = getGradient(GetSetting("autoStairwayNodes"));
    LayoutOrder = 13;
})
constructUiAspect({Parent = autoStairwayNodesButton; AspectRatio = 2.854})

-------------------->> Main Frame <<--------------------

local farmSpiritsButton, farmSpiritsFunctions = constructImageButton({
    Parent = Frame;
    Text = "Farm Spirits: "..GetTextFromSetting("FarmSpirits");
    Gradient = getGradient(GetSetting("FarmSpirits"));
    LayoutOrder = 0;
})
constructUiAspect({Parent = farmSpiritsButton; AspectRatio = 2.854})

local spawnEliteSpiritButton, spawnEliteSpiritFunctions = constructImageButton({
    Parent = Frame;
    Text = "Auto Spawn Elite: "..GetTextFromSetting("autoSpawnEliteSpirit");
    Gradient = getGradient(GetSetting("autoSpawnEliteSpirit"));
    LayoutOrder = 1;
})
constructUiAspect({Parent = spawnEliteSpiritButton; AspectRatio = 2.854})

local farmBossSpiritButton, farmBossSpiritFunctions = constructImageButton({
    Parent = Frame;
    Text = "Farm Trial: "..GetTextFromSetting("FarmBossSpirit");
    Gradient = getGradient(GetSetting("FarmBossSpirit"));
    LayoutOrder = 2;
})
constructUiAspect({Parent = farmBossSpiritButton, AspectRatio = 2.854})

local farmSurgeButton, farmSurgeFunctions = constructImageButton({
    Parent = Frame;
    Text = "Farm Surge: "..GetTextFromSetting("FarmSurge");
    Gradient = getGradient(GetSetting("FarmSurge"));
    LayoutOrder = 3;
})
constructUiAspect({Parent = farmSurgeButton; AspectRatio = 2.854})

local autoReincarnateButton, autoReincarnateFunctions = constructImageButton({
    Parent = Frame;
    Text = "Auto Reincarnate: "..GetTextFromSetting("autoReincarnate");
    Gradient = getGradient(GetSetting("autoReincarnate"));
    LayoutOrder = 4;
})
constructUiAspect({Parent = autoReincarnateButton; AspectRatio = 2.854})

local autoClickRelicButton, autoClickRelicFunctions = constructImageButton({
    Parent = Frame;
    Text = "Auto Click Relic: "..GetTextFromSetting("autoClickRelic");
    Gradient = getGradient(GetSetting("autoClickRelic"));
    LayoutOrder = 5;
})
constructUiAspect({Parent = autoClickRelicButton; AspectRatio = 2.854})

-------------------->> UI Protection <<--------------------

local protectGui = false

if protectGui == true then
    do
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

-------------------->> Gui Functions <<--------------------

local function AutoFarmSpirits()
    SetSetting("FarmSpirits", not GetSetting("FarmSpirits"))
    farmSpiritsFunctions:updateText("Farm Spirits: "..GetTextFromSetting("FarmSpirits"))
    farmSpiritsFunctions:updateGradient(getGradient(GetSetting("FarmSpirits")))

    local function fightSpirit()
        if getSpirit() ~= nil and GetSetting("FarmSpirits") == true then
            pcall(function()
                if GetSetting("spiritsPaused") ~= true and GetHumanoidRootPart() ~= nil then
                    local mag = (GetHumanoidRootPart().Position - getSpirit().HumanoidRootPart.Position).Magnitude
                    if mag > 12.5 then
                        GetHumanoidRootPart().CFrame = getSpirit().HumanoidRootPart.CFrame
                    end
                end
                if GetHumanoid().Sit == true or GetHumanoid().SeatPart ~= nil then
                    --GetHumanoid().Sit = false
                    GetHumanoid():ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end)

            if GetSetting("spiritsPaused") == true then
                repeat task.wait() until GetSetting("spiritsPaused") ~= true or GetSetting("FarmSpirits") ~= true
            end
        end
    end

    if GetSetting("FarmSpirits") == true then
        fightSpirit()

        while task.wait(1) do
             if GetSetting("FarmSpirits") ~= true then break end
            fightSpirit()
        end
    end
end

local function AutoFarmSurge()
    SetSetting("FarmSurge", not GetSetting("FarmSurge"))
    farmSurgeFunctions:updateText("Farm Surge: "..GetTextFromSetting("FarmSurge"))
    farmSurgeFunctions:updateGradient(getGradient(GetSetting("FarmSurge")))

    local function farmSurge()
        if (isSurgeActive() == true and getSurgePosition() ~= nil) and GetSetting("FarmSurge") == true then
            pcall(function()
                if GetSetting("surgePaused") ~= true and GetHumanoidRootPart() ~= nil then
                    local lastCFrame = GetLastCFrame()
                    repeat
                        task.wait()
                        SetSetting("spiritsPaused", true)
                        GetHumanoidRootPart().CFrame = CFrame.new(getSurgePosition() + Vector3.new(0, 2.75, 0))
                        GetHumanoid():ChangeState(Enum.HumanoidStateType.GettingUp)
                    until isSurgeActive() == false or getSurgePosition() == nil or GetSetting("FarmSurge") ~= true or GetSetting("surgePaused") == true
                    GetHumanoidRootPart().CFrame = lastCFrame
                end
            end)

            if GetSetting("surgePaused") == true then
                repeat task.wait() until GetSetting("surgePaused") ~= true or GetSetting("FarmSurge") ~= true
            end
        else
            if GetSetting("surgePaused") ~= true then
                SetSetting("spiritsPaused", false)
            end
        end
    end

    if GetSetting("FarmSurge") == true then
        farmSurge()

        while task.wait(0.1) do
             if GetSetting("FarmSurge") ~= true then break end
            farmSurge()
        end
    end
end

local function AutoRebirthIfUnAff()
    SetSetting("rebirthIfUnAff", not GetSetting("rebirthIfUnAff"))
    rebirthIfUnAffFunctions:updateText("Auto Rebirth for Elite Spirts: "..GetTextFromSetting("rebirthIfUnAff"))
    rebirthIfUnAffFunctions:updateGradient(getGradient(GetSetting("rebirthIfUnAff")))
end

local function AutoSpawnEliteSpirit()
    SetSetting("autoSpawnEliteSpirit", not GetSetting("autoSpawnEliteSpirit"))
    spawnEliteSpiritFunctions:updateText("Auto Spawn Elite: "..GetTextFromSetting("autoSpawnEliteSpirit"))
    spawnEliteSpiritFunctions:updateGradient(getGradient(GetSetting("autoSpawnEliteSpirit")))

    if GetSetting("autoSpawnEliteSpirit") == true and typeof(firesignal) == "function" then
        spawnElite()

        while task.wait(5) do
             if GetSetting("autoSpawnEliteSpirit") ~= true then break end
             if string.lower(SpawnButton.Text) == "can't afford" and GetSetting("rebirthIfUnAff") == true then
                rebirth()
            end
            if string.lower(SpawnButton.Text) == "spawn" then
                spawnElite()
            end
        end
    end
end

local function AutoFarmBossSpirit()
    SetSetting("FarmBossSpirit", not GetSetting("FarmBossSpirit"))
    farmBossSpiritFunctions:updateText("Farm Trial: "..GetTextFromSetting("FarmBossSpirit"))
    farmBossSpiritFunctions:updateGradient(getGradient(GetSetting("FarmBossSpirit")))

    local function fightBoss()
        if getBoss() ~= nil then
            local lastCFrame = GetLastCFrame()

            repeat
                task.wait()
                SetSetting("spiritsPaused", true)
                SetSetting("surgePaused", true)

                for i, v in pairs(Work:GetChildren()) do
                    if v:IsA("Model") and string.lower(v.Name):match("bosshealer") ~= nil then
                        repeat
                            task.wait()
                            pcall(function()
                                GetHumanoidRootPart().CFrame = v.HumanoidRootPart.CFrame
                                GetHumanoid():ChangeState(Enum.HumanoidStateType.GettingUp)
                            end)
                        until v.Parent == nil or getBoss() == nil or GetSetting("FarmBossSpirit") ~= true
                    end
                end

                pcall(function()
                    GetHumanoidRootPart().CFrame = getBossPlatForm().CFrame * CFrame.Angles(0, 0, math.rad(90)) + Vector3.new(0, 2.5, 0)
                    GetHumanoid():ChangeState(Enum.HumanoidStateType.GettingUp)
                end)
            until getBoss() == nil or GetSetting("FarmBossSpirit") ~= true
            SetSetting("spiritsPaused", false)
            SetSetting("surgePaused", false)
            pcall(function() GetHumanoidRootPart().CFrame = lastCFrame end)
            --pcall(function() DestroyConnection("Humanoid.Changed")  end)
        end
    end

    if GetSetting("FarmBossSpirit") == true then
        fightBoss()

        -- pcall(function()
        --     NewConnection("Humanoid.Changed", GetHumanoid().Changed:Connect(function()
        --         if getBoss() ~= nil and getBossPlatForm() ~= nil then
        --             --GetHumanoid().Sit = false
        --             pcall(function()
        --                 repeat
        --                 task.wait()
        --                 GetHumanoid():ChangeState(Enum.HumanoidStateType.GettingUp)
        --                 until GetHumanoid().Sit == false and GetHumanoid().SeatPart == nil
        --             end)
        --         end
        --     end))
        -- end)

        NewConnection("workspace.ChildAdded", Work.ChildAdded:Connect(function()
            fightBoss()
        end))
    else
        -- pcall(function() DestroyConnection("Humanoid.Changed")  end)
        DestroyConnection("workspace.ChildAdded")
    end
end

local function AutoBuyTrialShop()
    SetSetting("autoBuyTrialShop", not GetSetting("autoBuyTrialShop"))
    autoBuyTrialShopFunctions:updateText("Auto Buy Trial Shop: "..GetTextFromSetting("autoBuyTrialShop"))
    autoBuyTrialShopFunctions:updateGradient(getGradient(GetSetting("autoBuyTrialShop")))

    if GetSetting("autoBuyTrialShop") == true then
        buyOutTrialShop()

        while task.wait(10) do
             if GetSetting("autoBuyTrialShop") ~= true then break end
             buyOutTrialShop()
        end
    end
end

local function AutoRadianceBoostWhenMax()
    SetSetting("autoRadianceBoostWhenMax", not GetSetting("autoRadianceBoostWhenMax"))
    autoRadianceBoostFunctions:updateText("Auto Radiance Boost When Max: "..GetTextFromSetting("autoRadianceBoostWhenMax"))
    autoRadianceBoostFunctions:updateGradient(getGradient(GetSetting("autoRadianceBoostWhenMax")))

    local waitingTrue = false

    local function boost()
        if GetRadianceCharges() == GetRadianceMaxCharges() then
           if GetSetting("FarmSurge") == true then
                repeat
                    task.wait()
                    waitingTrue = true
                until 
                    (IsPlayerInSurge() == true and getSurgeTimeRemaining()>6.5) or
                    GetSetting("FarmSurge") ~= true or
                    GetSetting("autoRadianceBoostWhenMax") ~= true or
                    GetRadianceCharges() ~= GetRadianceMaxCharges()
                
                waitingTrue = false
                if GetSetting("autoRadianceBoostWhenMax") == true and GetRadianceCharges() == GetRadianceMaxCharges() then
                    RequestActivateRadiance()
                end
           else
                RequestActivateRadiance()
           end
        end
    end

    if GetSetting("autoRadianceBoostWhenMax") == true then
        boost()

        NewConnection("StatServiceClient.StatChanged", StatServiceClient.StatChanged:Connect(function(stat, value)
            if waitingTrue == false then
                 boost()
            end
        end))
    else
        DestroyConnection("StatServiceClient.StatChanged")
    end
end

local function autoReincarnate()
    SetSetting("autoReincarnate", not GetSetting("autoReincarnate"))
    autoReincarnateFunctions:updateText("Auto Reincarnate: "..GetTextFromSetting("autoReincarnate"))
    autoReincarnateFunctions:updateGradient(getGradient(GetSetting("autoReincarnate")))

    local function reincarnate()
        if reincarnationIsMaxed() ~= true then
            RequestReincarnation()
        end
    end

    if GetSetting("autoReincarnate") == true then
        reincarnate()

        while task.wait(1) do
            if GetSetting("autoReincarnate") ~= true then break end
            reincarnate()
        end
    end
end

local function autoClickRelic()
    SetSetting("autoClickRelic", not GetSetting("autoClickRelic"))
    autoClickRelicFunctions:updateText("Auto Click Relic: "..GetTextFromSetting("autoClickRelic"))
    autoClickRelicFunctions:updateGradient(getGradient(GetSetting("autoClickRelic")))

    if GetSetting("autoClickRelic") == true then
        relicClick()

        while task.wait() do
            if GetSetting("autoClickRelic") ~= true then break end
            relicClick()
        end
    end
end

local function autoZone1()
    SetSetting("autoZone1", not GetSetting("autoZone1"))
    autoZone1Functions:updateText("Auto Zone 1: "..GetTextFromSetting("autoZone1"))
    autoZone1Functions:updateGradient(getGradient(GetSetting("autoZone1")))

    local db = false

    local function auto()
        if db == true then return end
        db = true

        local treeT = {}
        local boardt = {}

        local function addToBoardT(z)
            for _, v in pairs(z:GetChildren()) do
                if v:IsA("Part") then
                    local zoneId = getZoneId(v)
                    local boardId = getBoardId(v)
                    local zone = UpgradeBoards.Zones[zoneId]
                    local board = zone and zone.Boards[boardId]

                    if zone ~= nil and board ~= nil then
                        if isBoardTypeValid(board.BoardType) == true then
                            table.insert(boardt, v)
                        end
                    end
                end 
            end
        end

        local function addToTreeT(z, currency)
            for _, v in pairs(z:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("Node") then
                    if isNodeColorCurrency(v.Node, currency) == true and checkNodeAvailable(v) == true then
                        table.insert(treeT, v)
                    end
                end 
            end
        end

        addToTreeT(Trees.Zone1, GameEnum.Currency.Faith)
        addToTreeT(Trees.Zone1, GameEnum.Currency.Rebirths)
        addToTreeT(Trees.Zone1, GameEnum.Currency.Bible)
        addToBoardT(Boards.Zone1)

        DebugPrint("Zone 1 Nodes: "..tostring(#treeT))
        DebugPrint("Zone 1 Boards: "..tostring(#boardt))
        purchaseNodes(treeT)
        purchaseBoards(boardt)
        task.wait(0.5)
        db = false
    end

    if GetSetting("autoZone1") == true then
        auto()

        NewConnection("StatServiceClient.StatChanged(0)", StatServiceClient.StatChanged:Connect(function(stat, value)
            auto()
        end))
    else
        DestroyConnection("StatServiceClient.StatChanged(0)")
    end
end

local function autoZone2()
    SetSetting("autoZone2", not GetSetting("autoZone2"))
    autoZone2Functions:updateText("Auto Zone 2: "..GetTextFromSetting("autoZone2"))
    autoZone2Functions:updateGradient(getGradient(GetSetting("autoZone2")))

    local db = false

    local function auto()
        if db == true then return end
        db = true

        local treeT = {}
        local boardt = {}

        local function addToBoardT(z)
            for _, v in pairs(z:GetChildren()) do
                if v:IsA("Part") then
                    local zoneId = getZoneId(v)
                    local boardId = getBoardId(v)
                    local zone = UpgradeBoards.Zones[zoneId]
                    local board = zone and zone.Boards[boardId]

                    if zone ~= nil and board ~= nil then
                        if isBoardTypeValid(board.BoardType) == true then
                            table.insert(boardt, v)
                        end
                    end
                end 
            end
        end

        local function addToTreeT(z, currency)
            for _, v in pairs(z:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("Node") then
                    if isNodeColorCurrency(v.Node, currency) == true and checkNodeAvailable(v) == true then
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

        DebugPrint("Zone 2 Nodes: "..tostring(#treeT))
        DebugPrint("Zone 2 Boards: "..tostring(#boardt))
        purchaseNodes(treeT)
        purchaseBoards(boardt)
        task.wait(0.5)
        db = false
    end

    if GetSetting("autoZone2") == true then
        auto()

        NewConnection("StatServiceClient.StatChanged(1)", StatServiceClient.StatChanged:Connect(function(stat, value)
            auto()
        end))
    else
        DestroyConnection("StatServiceClient.StatChanged(1)")
    end
end

local function autoZone3NoEliteSouls()
    SetSetting("autoZone3NoEliteSouls", not GetSetting("autoZone3NoEliteSouls"))
    autoZone3NoEliteSoulsFunctions:updateText("Auto Zone 3 No Elite Souls: "..GetTextFromSetting("autoZone3NoEliteSouls"))
    autoZone3NoEliteSoulsFunctions:updateGradient(getGradient(GetSetting("autoZone3NoEliteSouls")))

    local db = false

    local function auto()
        if db == true then return end
        db = true

        local treeT = {}
        local boardt = {}

        local function addToBoardT(z)
            for _, v in pairs(z:GetChildren()) do
                if v:IsA("Part") then
                    local zoneId = getZoneId(v)
                    local boardId = getBoardId(v)
                    local zone = UpgradeBoards.Zones[zoneId]
                    local board = zone and zone.Boards[boardId]

                    if zone ~= nil and board ~= nil then
                        if board.Currency == GameEnum.Currency.EliteSouls then continue end
                        if isBoardTypeValid(board.BoardType) == true then
                            table.insert(boardt, v)
                        end
                    end
                end 
            end
        end

        local function addToTreeT(z, currency)
            for _, v in pairs(z:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("Node") then
                    if isNodeColorCurrency(v.Node, currency) == true and checkNodeAvailable(v) == true then
                        table.insert(treeT, v)
                    end
                end 
            end
        end

        addToTreeT(Trees.Zone3, GameEnum.Currency.Faith)
        addToTreeT(Trees.Zone3, GameEnum.Currency.Relics)
        addToTreeT(Trees.Zone3, GameEnum.Currency.Souls)
        addToBoardT(Boards.Zone4)

        DebugPrint("Zone 3 Nodes: "..tostring(#treeT))
        DebugPrint("Zone 3 Boards: "..tostring(#boardt))
        purchaseNodes(treeT)
        purchaseBoards(boardt)
        task.wait(0.5)
        db = false
    end

    if GetSetting("autoZone3") == true then
        auto()

        NewConnection("StatServiceClient.StatChanged(2)", StatServiceClient.StatChanged:Connect(function(stat, value)
            auto()
        end))
    else
        DestroyConnection("StatServiceClient.StatChanged(2)")
    end
end

local function autoZone3EliteSouls()
    SetSetting("autoZone3EliteSouls", not GetSetting("autoZone3EliteSouls"))
    autoZone3EliteSoulsFunctions:updateText("Auto Zone 3 Elite Souls: "..GetTextFromSetting("autoZone3EliteSouls"))
    autoZone3EliteSoulsFunctions:updateGradient(getGradient(GetSetting("autoZone3EliteSouls")))

    local db = false

    local function auto()
        if db == true then return end
        db = true

        local treeT = {}
        local boardt = {}

        for _, v in pairs(Trees.Zone3:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Node") then
                if isNodeColorCurrency(v.Node, GameEnum.Currency.EliteSouls) == true and checkNodeAvailable(v) == true then
                    table.insert(treeT, v)
                end
            end 
        end

        for _, v in pairs(Boards.Zone4:GetChildren()) do
            if v:IsA("Part") then
                local zoneId = getZoneId(v)
                local boardId = getBoardId(v)
                local zone = UpgradeBoards.Zones[zoneId]
                local board = zone and zone.Boards[boardId]

                if zone ~= nil and board ~= nil then
                    if board.Currency ~= GameEnum.Currency.EliteSouls then continue end
                    if isBoardTypeValid(board.BoardType) == true then
                        table.insert(boardt, v)
                    end
                end
            end 
        end

        DebugPrint("Zone 3 Elite Soul Nodes: "..tostring(#treeT))
        DebugPrint("Zone 3 Elite Soul Boards: "..tostring(#boardt))
        purchaseNodes(treeT)
        purchaseBoards(boardt)
        task.wait(0.5)
        db = false
    end

    if GetSetting("autoZone3EliteSouls") == true then
        auto()

        NewConnection("StatServiceClient.StatChanged(3)", StatServiceClient.StatChanged:Connect(function(stat, value)
            auto()
        end))
    else
        DestroyConnection("StatServiceClient.StatChanged(3)")
    end
end

local function autoUnderworld()
    SetSetting("autoUnderworld", not GetSetting("autoUnderworld"))
    autoUnderworldFunctions:updateText("Auto Underworld: "..GetTextFromSetting("autoUnderworld"))
    autoUnderworldFunctions:updateGradient(getGradient(GetSetting("autoUnderworld")))

    local db = false

    local function auto()
        if db == true then return end
        db = true

        local treeT = {}
        local boardt = {}

        for _, v in pairs(Trees["Zone_5(Underworld)"].Nodes:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Node") then
                if isNodeColorCurrency(v.Node.Node, GameEnum.Currency.Embers) == true and checkNodeAvailable(v, true) == true then
                    table.insert(treeT, v)
                end
            end 
        end

        for _, v in pairs(Boards.Zone5:GetChildren()) do
            if v:IsA("Part") then
                local zoneId = getZoneId(v)
                local boardId = getBoardId(v)
                local zone = UpgradeBoards.Zones[zoneId]
                local board = zone and zone.Boards[boardId]

                if zone ~= nil and board ~= nil then
                    if isBoardTypeValid(board.BoardType) == true then
                        table.insert(boardt, v)
                    end
                end
            end 
        end

        DebugPrint("Underworld Nodes: "..tostring(#treeT))
        DebugPrint("Underworld Boards: "..tostring(#boardt))
        purchaseNodes(treeT, true)
        purchaseBoards(boardt)
        task.wait(0.5)
        db = false
    end

    if GetSetting("autoUnderworld") == true then
        auto()

        NewConnection("StatServiceClient.StatChanged(4)", StatServiceClient.StatChanged:Connect(function(stat, value)
            auto()
        end))
    else
        DestroyConnection("StatServiceClient.StatChanged(4)")
    end
end


local function autoHellStairsNodes()
    SetSetting("autoHellStairsNodes", not GetSetting("autoHellStairsNodes"))
    autoHellStairsNodesFunctions:updateText("Auto Hell Stairs Nodes: "..GetTextFromSetting("autoHellStairsNodes"))
    autoHellStairsNodesFunctions:updateGradient(getGradient(GetSetting("autoHellStairsNodes")))

    local db = false

    local function auto()
        if db == true then return end
        db = true

        local t = {}

        for _, v in pairs(Trees.HellStairs:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Node") then
                if checkNodeAvailable(v) == true then
                    table.insert(t, v)
                end
            end 
        end

        DebugPrint("Hell Stairs Nodes: "..tostring(#t))
        purchaseNodes(t)
        task.wait(0.5)
        db = false
    end

    if GetSetting("autoHellStairsNodes") == true then
        auto()

        NewConnection("StatServiceClient.StatChanged(12)", StatServiceClient.StatChanged:Connect(function(stat, value)
            auto()
        end))
    else
        DestroyConnection("StatServiceClient.StatChanged(12)")
    end
end

local function autoStairwayNodes()
    SetSetting("autoStairwayNodes", not GetSetting("autoStairwayNodes"))
    autoStairwayNodesFunctions:updateText("Auto Stairway Nodes: "..GetTextFromSetting("autoStairwayNodes"))
    autoStairwayNodesFunctions:updateGradient(getGradient(GetSetting("autoStairwayNodes")))

    local db = false

    local function auto()
        if db == true then return end
        db = true

        local t = {}

        for _, v in pairs(Trees.Stairway:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Node") then
                if checkNodeAvailable(v) == true then
                    table.insert(t, v)
                end
            end 
        end

        DebugPrint("Stairway Nodes: "..tostring(#t))
        purchaseNodes(t)
        task.wait(0.5)
        db = false
    end

    if GetSetting("autoStairwayNodes") == true then
        auto()

        NewConnection("StatServiceClient.StatChanged(13)", StatServiceClient.StatChanged:Connect(function(stat, value)
            auto()
        end))
    else
        DestroyConnection("StatServiceClient.StatChanged(13)")
    end
end

-------------------->> Main Frame Buttons <<--------------------
show({Text = "Loading connections..."; Duration = 3;})

do
    NewConnection("farmSpirits.MouseButton1Click", farmSpiritsButton.MouseButton1Click:Connect(function()
        AutoFarmSpirits()
    end))

    NewConnection("spawnEliteSpirit.MouseButton1Click", spawnEliteSpiritButton.MouseButton1Click:Connect(function()
        AutoSpawnEliteSpirit()
    end))

    NewConnection("farmBossSpirit.MouseButton1Click", farmBossSpiritButton.MouseButton1Click:Connect(function()
        AutoFarmBossSpirit()
    end))

    NewConnection("farmSurgeButton.MouseButton1Click", farmSurgeButton.MouseButton1Click:Connect(function()
        AutoFarmSurge()
    end))

    NewConnection("autoReincarnateButton.MouseButton1Click", autoReincarnateButton.MouseButton1Click:Connect(function()
        autoReincarnate()
    end))

    NewConnection("autoClickRelicButton.MouseButton1Click", autoClickRelicButton.MouseButton1Click:Connect(function()
        autoClickRelic()
    end))
end

-------------------->> Close Buttons <<--------------------

do
    NewConnection("closeButton.MouseButton1Click", closeButton.MouseButton1Click:Connect(function()
        getgenv().Destroy()
    end))

    NewConnection("closeButtonSettings.MouseButton1Click", closeButtonSettings.MouseButton1Click:Connect(function()
        backSettingsFrame.Visible = false
    end))

    NewConnection("closeButtonUpgrades.MouseButton1Click", closeButtonUpgrades.MouseButton1Click:Connect(function()
        backUpgradesFrame.Visible = false
    end))
end

-------------------->> Settings Buttons <<--------------------

do
    NewConnection("rebirthIfUnAffButton.MouseButton1Click", rebirthIfUnAffButton.MouseButton1Click:Connect(function()
        AutoRebirthIfUnAff()
    end))

    NewConnection("autoBuyTrialShopButton.MouseButton1Click", autoBuyTrialShopButton.MouseButton1Click:Connect(function()
        AutoBuyTrialShop()
    end))

    NewConnection("autoRadianceBoostButton.MouseButton1Click", autoRadianceBoostButton.MouseButton1Click:Connect(function()
        AutoRadianceBoostWhenMax()
    end))

    NewConnection("acsendButton.MouseButton1Click", acsendButton.MouseButton1Click:Connect(function()
        RequestAcension()
    end))
end

-------------------->> Upgrades Buttons <<--------------------

do
    NewConnection("autoZone1Button.MouseButton1Click", autoZone1Button.MouseButton1Click:Connect(function()
        autoZone1()
    end))

    NewConnection("autoZone2Button.MouseButton1Click", autoZone2Button.MouseButton1Click:Connect(function()
        autoZone2()
    end))

    NewConnection("autoZone3NoEliteSoulsButton.MouseButton1Click", autoZone3NoEliteSoulsButton.MouseButton1Click:Connect(function()
        autoZone3NoEliteSouls()
    end))

    NewConnection("autoZone3EliteSoulsButton.MouseButton1Click", autoZone3EliteSoulsButton.MouseButton1Click:Connect(function()
        autoZone3EliteSouls()
    end))

    NewConnection("autoUnderworldButton.MouseButton1Click", autoUnderworldButton.MouseButton1Click:Connect(function()
        autoUnderworld()
    end))

    NewConnection("autoHellStairsNodesButton.MouseButton1Click", autoHellStairsNodesButton.MouseButton1Click:Connect(function()
        autoHellStairsNodes()
    end))

    NewConnection("autoStairwayNodesButton.MouseButton1Click", autoStairwayNodesButton.MouseButton1Click:Connect(function()
        autoStairwayNodes()
    end))
end

-------------------->> Side Buttons <<--------------------

do
    NewConnection("rebirthButton.MouseButton1Click", rebirthButton.MouseButton1Click:Connect(function()
        rebirth()
    end))

    NewConnection("settingsButton.MouseButton1Click", settingsButton.MouseButton1Click:Connect(function()
        backUpgradesFrame.Visible = false
        backSettingsFrame.Visible = not backSettingsFrame.Visible
    end))

    NewConnection("upgradesButton.MouseButton1Click", upgradesButton.MouseButton1Click:Connect(function()
        backSettingsFrame.Visible = false
        backUpgradesFrame.Visible = not backUpgradesFrame.Visible
    end))
end

-------------------->> Loading Ended <<--------------------

print("Loading End Time: "..tostring(DateTime.now().UnixTimestamp - LoadingTime))
show({Text = "GigaHub took "..tostring(DateTime.now().UnixTimestamp - LoadingTime).." seconds to load."})
