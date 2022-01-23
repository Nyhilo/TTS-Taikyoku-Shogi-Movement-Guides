-------------
-- Globals --
-------------

local ScriptingContainer = nil
local PlayingPieceTag = 'Piece'
local TileTag = 'Tile'
local Pieces = nil

local Colors = {
    Reset = {r=1, g=1, b=1, a=0},
    Line = {r=1, g=0, b=0, a=0.5},
    JumpLine = {r=1, g=0.5, b=0, a=0.5},
    Slide = {r=0, g=0, b=1, a=0.5},
    Jump = {r=1, g=1, b=0, a=0.5},
    Jump2 = {r=0, g=1, b=0.5, a=0.5},
    Fly = {r=1, g=0, b=1, a=0.5},
    Eat = {r=0, g=1, b=1, a=0.5}
}

local UNIT = 1.34

---------------------
-- Util Extensions --
---------------------

-- Returns true if the table contains the given element
function table.contains(tbl, elem)
    for _, v in ipairs(tbl) do
        if v == elem then return true end
    end

    return false
end


-- From https://stackoverflow.com/a/15278426/3245249 with changes
function table.concat(tbl, t)
    for i=1,#t do
        tbl[#tbl + i] = t[i]
    end
    return tbl
end


-- Single character splitting function
-- From https://stackoverflow.com/a/7615129/3245249 with changes
function string:split(sep)
    if sep == nil then
            sep = "%s"
    end
    local t = {}
    for str in string.gmatch(self, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end


-- Single character trimming.
-- Splits and then trims the whitespace off the ends of the results
function string:splitTrim(sep)
    local t = {}
    local parts = self:split(sep)
    for _, p in ipairs(parts) do
        table.insert(t, (p:gsub('^%s+', ''):gsub('%s+$', '')))
    end

    return t
end


-----------
-- Setup --
-----------

--[[ The onLoad event is called after the game save finishes loading. --]]
function onLoad()
    ScriptingContainer = spawnObject({
        position = {0,0,0}
      , scale = { 50, 20, 50 }
      , type = 'ScriptingTrigger'
    })
end


--------------------
-- Event Handlers --
--------------------

function onObjectEnterScriptingZone(zone, object)
    if zone.guid == ScriptingContainer.guid and object.hasTag(PlayingPieceTag) then
        RegisterPiece(object)
    end
end


function onObjectPickUp(player_color, object)
    if object.hasTag(PlayingPieceTag) then
        handlePieceMovement(object, true)
    end
end


function onObjectDrop(player_color, object)
    if object.hasTag(PlayingPieceTag) then
        handlePieceMovement(object, false)
    end
end


------------------------
-- Piece Registration --
------------------------

function RegisterPiece(piece)
    if not isPieceRegistered(piece) then
        if Pieces == nil then
            Pieces = {piece}
        else
            table.insert(Pieces, piece)
        end
    end
end


function isPieceRegistered(piece)
    if Pieces == nil then return false end
    for _, p in ipairs(Pieces) do
        if p['guid'] ~= nil and piece['guid'] ~= nil and p.guid == piece.guid then
            return true
        end
    end

    return false
end


-------------------
-- Movement Sets --
-------------------

local GetMovement = {
    AncientDragon = function(piece, pickup)

    end,
    
    AngryBoar = function(piece, pickup)

    end,
    
    BearSoldier = function(piece, pickup)

    end,
    
    BearsEyes = function(piece, pickup)

    end,
    
    BeastBird = function(piece, pickup)

    end,
    
    BeastCadet = function(piece, pickup)

    end,
    
    BeastOfficer = function(piece, pickup)

    end,
    
    BirdOfParadise = function(piece, pickup)

    end,
    
    Bishop = function(piece, pickup)
        local tiles = GetDiagonalHits(piece)

        local color = Colors.Line
        if not pickup then color = Colors.Reset end

        for _, tile in ipairs(tiles) do
            tile.setColorTint(color)
        end
    end,
    
    BishopGeneral = function(piece, pickup)

    end,
    
    BlindBear = function(piece, pickup)

    end,
    
    BlindDog = function(piece, pickup)

    end,
    
    BlindMonkey = function(piece, pickup)

    end,
    
    BlindTiger = function(piece, pickup)

    end,
    
    BlueDragon = function(piece, pickup)

    end,
    
    BoarSoldier = function(piece, pickup)

    end,
    
    BuddhistDevil = function(piece, pickup)

    end,
    
    BuddhistSpirit = function(piece, pickup)

    end,
    
    BurningChariot = function(piece, pickup)

    end,
    
    BurningGeneral = function(piece, pickup)

    end,
    
    BurningSoldier = function(piece, pickup)

    end,
    
    Capricorn = function(piece, pickup)

    end,
    
    CaptiveBird = function(piece, pickup)

    end,
    
    CaptiveCadet = function(piece, pickup)

    end,
    
    CaptiveOfficer = function(piece, pickup)

    end,
    
    CatSword = function(piece, pickup)

    end,
    
    Cavalier = function(piece, pickup)

    end,
    
    CenterMaster = function(piece, pickup)

    end,
    
    CenterStandard = function(piece, pickup)

    end,
    
    CeramicDove = function(piece, pickup)

    end,
    
    ChariotSoldier = function(piece, pickup)

    end,
    
    ChickenGeneral = function(piece, pickup)

    end,
    
    ChineseCock = function(piece, pickup)

    end,
    
    ChineseRiver = function(piece, pickup)

    end,
    
    ClimbingMonkey = function(piece, pickup)

    end,
    
    CloudDragon = function(piece, pickup)

    end,
    
    CloudEagle = function(piece, pickup)

    end,
    
    CoiledDragon = function(piece, pickup)

    end,
    
    CoiledSerpent = function(piece, pickup)

    end,
    
    CopperChariot = function(piece, pickup)

    end,
    
    CopperElephant = function(piece, pickup)

    end,
    
    CopperGeneral = function(piece, pickup)

    end,
    
    CrossbowGeneral = function(piece, pickup)

    end,
    
    CrossbowSoldier = function(piece, pickup)

    end,
    
    DarkSpirit = function(piece, pickup)

    end,
    
    Deva = function(piece, pickup)

    end,
    
    DivineDragon = function(piece, pickup)

    end,
    
    DivineSparrow = function(piece, pickup)

    end,
    
    DivineTiger = function(piece, pickup)

    end,
    
    DivineTurtle = function(piece, pickup)

    end,
    
    Dog = function(piece, pickup)

    end,
    
    Donkey = function(piece, pickup)

    end,
    
    DragonHorse = function(piece, pickup)

    end,
    
    DragonKing = function(piece, pickup)

    end,
    
    DrunkenElephant = function(piece, pickup)

    end,
    
    EarthChariot = function(piece, pickup)

    end,
    
    EarthDragon = function(piece, pickup)

    end,
    
    EarthGeneral = function(piece, pickup)

    end,
    
    EasternBarbarian = function(piece, pickup)

    end,
    
    ElephantKing = function(piece, pickup)

    end,
    
    EnchantedBadger = function(piece, pickup)

    end,
    
    EvilWolf = function(piece, pickup)

    end,
    
    FerociousLeopard = function(piece, pickup)

    end,
    
    FierceEagle = function(piece, pickup)

    end,
    
    FireDemon = function(piece, pickup)

    end,
    
    FireDragon = function(piece, pickup)

    end,
    
    FireGeneral = function(piece, pickup)

    end,
    
    FireOx = function(piece, pickup)

    end,
    
    FlyingCat = function(piece, pickup)

    end,
    
    FlyingCock = function(piece, pickup)

    end,
    
    FlyingCrocodile = function(piece, pickup)

    end,
    
    FlyingDragon = function(piece, pickup)

    end,
    
    FlyingFalcon = function(piece, pickup)

    end,
    
    FlyingGoose = function(piece, pickup)

    end,
    
    FlyingHorse = function(piece, pickup)

    end,
    
    FlyingOx = function(piece, pickup)

    end,
    
    FlyingStag = function(piece, pickup)

    end,
    
    FlyingSwallow = function(piece, pickup)

    end,
    
    ForestDemon = function(piece, pickup)

    end,
    
    FragrantElephant = function(piece, pickup)

    end,
    
    FreeBaku = function(piece, pickup)

    end,
    
    FreeBear = function(piece, pickup)

    end,
    
    FreeBird = function(piece, pickup)

    end,
    
    FreeBoar = function(piece, pickup)

    end,
    
    FreeChicken = function(piece, pickup)

    end,
    
    FreeDemon = function(piece, pickup)

    end,
    
    FreeDog = function(piece, pickup)

    end,
    
    FreeDragon = function(piece, pickup)

    end,
    
    FreeEagle = function(piece, pickup)

    end,
    
    FreeFire = function(piece, pickup)

    end,
    
    FreeHorse = function(piece, pickup)

    end,
    
    FreeKing = function(piece, pickup)

    end,
    
    FreeLeopard = function(piece, pickup)

    end,
    
    FreeOx = function(piece, pickup)

    end,
    
    FreePig = function(piece, pickup)

    end,
    
    FreePup = function(piece, pickup)

    end,
    
    FreeSerpe = function(piece, pickup)

    end,
    
    FreeSerpent = function(piece, pickup)

    end,
    
    FreeStag = function(piece, pickup)

    end,
    
    FreeTiger = function(piece, pickup)

    end,
    
    FreeWolf = function(piece, pickup)

    end,
    
    FrontStandard = function(piece, pickup)

    end,
    
    FuriousFiend = function(piece, pickup)
    end
,
    GlidingSwallow = function(piece, pickup)

    end,
    
    GoBetween = function(piece, pickup)

    end,
    
    GoldChariot = function(piece, pickup)

    end,
    
    GoldGeneral = function(piece, pickup)

    end,
    
    GoldenBird = function(piece, pickup)

    end,
    
    GoldenDeer = function(piece, pickup)

    end,
    
    GooseWing = function(piece, pickup)

    end,
    
    GreatBear = function(piece, pickup)

    end,
    
    GreatDove = function(piece, pickup)

    end,
    
    GreatDragon = function(piece, pickup)

    end,
    
    GreatDreamEater = function(piece, pickup)

    end,
    
    GreatEagle = function(piece, pickup)

    end,
    
    GreatElephant = function(piece, pickup)

    end,
    
    GreatFalcon = function(piece, pickup)

    end,
    
    GreatGeneral = function(piece, pickup)

    end,
    
    GreatHorse = function(piece, pickup)

    end,
    
    GreatLeopard = function(piece, pickup)

    end,
    
    GreatMaster = function(piece, pickup)

    end,
    
    GreatShark = function(piece, pickup)

    end,
    
    GreatStag = function(piece, pickup)

    end,
    
    GreatStandard = function(piece, pickup)

    end,
    
    GreatTiger = function(piece, pickup)

    end,
    
    GreatTurtle = function(piece, pickup)

    end,
    
    GreatWhale = function(piece, pickup)

    end,
    
    GuardianoftheGods = function(piece, pickup)

    end,
    
    HeavenlyHorse = function(piece, pickup)

    end,
    
    HeavenlyTetrarch = function(piece, pickup)

    end,
    
    HeavenlyTetrarchKing = function(piece, pickup)

    end,
    
    HookMover = function(piece, pickup)

    end,
    
    HornedFalcon = function(piece, pickup)

    end,
    
    HorseGeneral = function(piece, pickup)

    end,
    
    HorseSoldier = function(piece, pickup)

    end,
    
    Horseman = function(piece, pickup)

    end,
    
    HowlingDog = function(piece, pickup)

    end,
    
    IronGeneral = function(piece, pickup)

    end,
    
    King = function(piece, pickup)

    end,
    
    KingKing = function(piece, pickup)

    end,
    
    Kirin = function(piece, pickup)

    end,
    
    KirinMaster = function(piece, pickup)

    end,
    
    Knight = function(piece, pickup)

    end,
    
    Lance = function(piece, pickup)

    end,
    
    LeftArmy = function(piece, pickup)

    end,
    
    LeftChariot = function(piece, pickup)

    end,
    
    LeftDog = function(piece, pickup)

    end,
    
    LeftDragon = function(piece, pickup)

    end,
    
    LeftGeneral = function(piece, pickup)

    end,
    
    LeftIronChariot = function(piece, pickup)

    end,
    
    LeftMountainEagle = function(piece, pickup)

    end,
    
    LeftTiger = function(piece, pickup)

    end,
    
    LeopardKing = function(piece, pickup)

    end,
    
    LeopardSoldier = function(piece, pickup)

    end,
    
    LiberatedHorse = function(piece, pickup)

    end,
    
    Lion = function(piece, pickup)

    end,
    
    LionDog = function(piece, pickup)

    end,
    
    LionHawk = function(piece, pickup)

    end,
    
    LittleStandard = function(piece, pickup)

    end,
    
    LittleTurtle = function(piece, pickup)

    end,
    
    LongbowGeneral = function(piece, pickup)

    end,
    
    LongbowSoldier = function(piece, pickup)

    end,
    
    MountainCrane = function(piece, pickup)

    end,
    
    MountainFalcon = function(piece, pickup)

    end,
    
    MountainGeneral = function(piece, pickup)

    end,
    
    MountainStag = function(piece, pickup)

    end,
    
    MountainWitch = function(piece, pickup)

    end,
    
    MultiGeneral = function(piece, pickup)

    end,
    
    NeighboringKing = function(piece, pickup)

    end,
    
    NorthernBarbarian = function(piece, pickup)

    end,
    
    OldKite = function(piece, pickup)

    end,
    
    OldMonkey = function(piece, pickup)

    end,
    
    OldRat = function(piece, pickup)

    end,
    
    OxGeneral = function(piece, pickup)

    end,
    
    OxSoldier = function(piece, pickup)

    end,
    
    Oxcart = function(piece, pickup)

    end,
    
    Pawn = function(piece, pickup)
        local tile = GetForwardTile(piece)

        if tile == nil then return end

        local color = Colors.Slide
        if not pickup then color = Colors.Reset end

        tile.setColorTint(color)
    end,
    
    PeacefulMountain = function(piece, pickup)

    end,
    
    Peacock = function(piece, pickup)

    end,
    
    Phoenix = function(piece, pickup)

    end,
    
    PhoenixMaster = function(piece, pickup)

    end,
    
    PigGeneral = function(piece, pickup)

    end,
    
    PlayfulCockatoo = function(piece, pickup)

    end,
    
    PloddingOx = function(piece, pickup)

    end,
    
    PoisonousSnake = function(piece, pickup)

    end,
    
    PrancingStag = function(piece, pickup)

    end,
    
    Prince = function(piece, pickup)

    end,
    
    PupGeneral = function(piece, pickup)

    end,
    
    Queen = function(piece, pickup)

    end,
    
    RaidingFalcon = function(piece, pickup)

    end,
    
    RainDemon = function(piece, pickup)

    end,
    
    RainDragon = function(piece, pickup)

    end,
    
    RamsHeadSoldier = function(piece, pickup)

    end,
    
    RearStandard = function(piece, pickup)

    end,
    
    RecliningDragon = function(piece, pickup)

    end,
    
    ReverseChariot = function(piece, pickup)

    end,
    
    RightArmy = function(piece, pickup)

    end,
    
    RightChariot = function(piece, pickup)

    end,
    
    RightDog = function(piece, pickup)

    end,
    
    RightDragon = function(piece, pickup)

    end,
    
    RightGeneral = function(piece, pickup)

    end,
    
    RightIronChariot = function(piece, pickup)

    end,
    
    RightMountainEagle = function(piece, pickup)

    end,
    
    RightPhoenix = function(piece, pickup)

    end,
    
    RightTiger = function(piece, pickup)

    end,
    
    RiverGeneral = function(piece, pickup)

    end,
    
    RoaringDog = function(piece, pickup)

    end,
    
    RocMaster = function(piece, pickup)

    end,
    
    Rook = function(piece, pickup)
        print('-----')
        print(piece.getTransformForward())
        print(piece.getRotation())
        local vtiles = GetVerticalHits(piece)
        local htiles = GetHorizontalHits(piece)

        local color = Colors.Line
        if not pickup then color = Colors.Reset end

        for _, tile in ipairs(vtiles) do
            tile.setColorTint(color)
        end

        for _, tile in ipairs(htiles) do
            tile.setColorTint(color)
        end
    end,
    
    RookGeneral = function(piece, pickup)

    end,
    
    RunningBear = function(piece, pickup)

    end,
    
    RunningBoar = function(piece, pickup)

    end,
    
    RunningChariot = function(piece, pickup)

    end,
    
    RunningDragon = function(piece, pickup)

    end,
    
    RunningHorse = function(piece, pickup)

    end,
    
    RunningLeopard = function(piece, pickup)

    end,
    
    RunningOx = function(piece, pickup)

    end,
    
    RunningPup = function(piece, pickup)

    end,
    
    RunningRabbit = function(piece, pickup)

    end,
    
    RunningSerpent = function(piece, pickup)

    end,
    
    RunningStag = function(piece, pickup)

    end,
    
    RunningTiger = function(piece, pickup)

    end,
    
    RunningTile = function(piece, pickup)

    end,
    
    RunningWolf = function(piece, pickup)

    end,
    
    RushingBird = function(piece, pickup)

    end,
    
    RushingBoa = function(piece, pickup)

    end,
    
    SavageTiger = function(piece, pickup)

    end,
    
    SideBoar = function(piece, pickup)

    end,
    
    SideDragon = function(piece, pickup)

    end,
    
    SideMonkey = function(piece, pickup)

    end,
    
    SideMover = function(piece, pickup)

    end,
    
    SideOx = function(piece, pickup)

    end,
    
    SideSerpent = function(piece, pickup)

    end,
    
    SideSoldier = function(piece, pickup)

    end,
    
    SideWolf = function(piece, pickup)

    end,
    
    SideFlyer = function(piece, pickup)

    end,
    
    SilverChariot = function(piece, pickup)

    end,
    
    SilverGeneral = function(piece, pickup)

    end,
    
    SilverRabbit = function(piece, pickup)

    end,
    
    SoaringEagle = function(piece, pickup)

    end,
    
    Soldier = function(piece, pickup)

    end,
    
    SouthernBarbarian = function(piece, pickup)

    end,
    
    SpearGeneral = function(piece, pickup)

    end,
    
    SpearSoldier = function(piece, pickup)

    end,
    
    SpiritTurtle = function(piece, pickup)

    end,
    
    SquareMover = function(piece, pickup)

    end,
    
    StoneChariot = function(piece, pickup)

    end,
    
    StoneGeneral = function(piece, pickup)

    end,
    
    StrongChariot = function(piece, pickup)

    end,
    
    StrongEagle = function(piece, pickup)

    end,
    
    StrongSoldier = function(piece, pickup)

    end,
    
    StruttingCrow = function(piece, pickup)

    end,
    
    SwallowsWings = function(piece, pickup)

    end,
    
    SwoopingOwl = function(piece, pickup)

    end,
    
    SwordGenera = function(piece, pickup)

    end,
    
    SwordSoldier = function(piece, pickup)

    end,
    
    TeachingKing = function(piece, pickup)

    end,
    
    Tengu = function(piece, pickup)

    end,
    
    ThunderRunner = function(piece, pickup)

    end,
    
    ThunderRunner = function(piece, pickup)

    end,
    
    TigerSoldier = function(piece, pickup)

    end,
    
    TileChariot = function(piece, pickup)

    end,
    
    TileGeneral = function(piece, pickup)

    end,
    
    TreacherousFox = function(piece, pickup)

    end,
    
    TreasureTurtle = function(piece, pickup)

    end,
    
    TurtleDove = function(piece, pickup)

    end,
    
    TurtleSnake = function(piece, pickup)

    end,
    
    TurtleSnake = function(piece, pickup)

    end,
    
    VenomousWolf = function(piece, pickup)

    end,
    
    VermillionSparrow = function(piece, pickup)

    end,
    
    VerticalBear = function(piece, pickup)

    end,
    
    VerticalHorse = function(piece, pickup)

    end,
    
    VerticalLeopard = function(piece, pickup)

    end,
    
    VerticalMover = function(piece, pickup)

    end,
    
    VerticalPup = function(piece, pickup)

    end,
    
    VerticalSoldier = function(piece, pickup)

    end,
    
    VerticalTiger = function(piece, pickup)

    end,
    
    VerticalWolf = function(piece, pickup)

    end,
    
    ViceGeneral = function(piece, pickup)

    end,
    
    ViolentBear = function(piece, pickup)

    end,
    
    ViolentDragon = function(piece, pickup)

    end,
    
    ViolentOx = function(piece, pickup)

    end,
    
    ViolentStag = function(piece, pickup)

    end,
    
    ViolentWind = function(piece, pickup)

    end,
    
    ViolentWolf = function(piece, pickup)

    end,
    
    WalkingHeron = function(piece, pickup)

    end,
    
    WaterBuffalo = function(piece, pickup)

    end,
    
    WaterDragon = function(piece, pickup)

    end,
    
    WaterGeneral = function(piece, pickup)

    end,
    
    WesternBarbarian = function(piece, pickup)

    end,
    
    Whale = function(piece, pickup)

    end,
    
    WhiteElephant = function(piece, pickup)

    end,
    
    WhiteHorse = function(piece, pickup)

    end,
    
    WhiteTiger = function(piece, pickup)

    end,
    
    WindDragon = function(piece, pickup)

    end,
    
    WindGeneral = function(piece, pickup)

    end,
    
    WindSnappingTurtle = function(piece, pickup)

    end,
    
    WizardStork = function(piece, pickup)

    end,
    
    WoodChariot = function(piece, pickup)

    end,
    
    WoodGeneral = function(piece, pickup)

    end,
    
    WoodenDove = function(piece, pickup)

    end,
    
    WoodlandDemon = function(piece, pickup)

    end,
    
    Wrestler = function(piece, pickup)

    end,
    
    Yaksha = function(piece, pickup)

    end,
    
    YoungBird = function(piece, pickup)

    end
}


local MovementTable = {
    ['Ancient Dragon'] = GetMovement.AncientDragon,
    ['Angry Boar'] = GetMovement.AngryBoar,
    ['Bear Soldier'] = GetMovement.BearSoldier,
    ['Bear\'s Eyes'] = GetMovement.BearsEyes,
    ['Beast Bird'] = GetMovement.BeastBird,
    ['Beast Cadet'] = GetMovement.BeastCadet,
    ['Beast Officer'] = GetMovement.BeastOfficer,
    ['Bird Of Paradise'] = GetMovement.BirdOfParadise,
    ['Bishop'] = GetMovement.Bishop,
    ['Bishop General'] = GetMovement.BishopGeneral,
    ['Blind Bear'] = GetMovement.BlindBear,
    ['Blind Dog'] = GetMovement.BlindDog,
    ['Blind Monkey'] = GetMovement.BlindMonkey,
    ['Blind Tiger'] = GetMovement.BlindTiger,
    ['Blue Dragon'] = GetMovement.BlueDragon,
    ['Boar Soldier'] = GetMovement.BoarSoldier,
    ['Buddhist Devil'] = GetMovement.BuddhistDevil,
    ['Buddhist Spirit'] = GetMovement.BuddhistSpirit,
    ['Burning Chariot'] = GetMovement.BurningChariot,
    ['Burning General'] = GetMovement.BurningGeneral,
    ['Burning Soldier'] = GetMovement.BurningSoldier,
    ['Capricorn'] = GetMovement.Capricorn,
    ['Captive Bird'] = GetMovement.CaptiveBird,
    ['Captive Cadet'] = GetMovement.CaptiveCadet,
    ['Captive Officer'] = GetMovement.CaptiveOfficer,
    ['Cat Sword'] = GetMovement.CatSword,
    ['Cavalier'] = GetMovement.Cavalier,
    ['Center Master'] = GetMovement.CenterMaster,
    ['Center Standard'] = GetMovement.CenterStandard,
    ['Ceramic Dove'] = GetMovement.CeramicDove,
    ['Chariot Soldier'] = GetMovement.ChariotSoldier,
    ['Chicken General'] = GetMovement.ChickenGeneral,
    ['Chinese Cock'] = GetMovement.ChineseCock,
    ['Chinese River'] = GetMovement.ChineseRiver,
    ['Climbing Monkey'] = GetMovement.ClimbingMonkey,
    ['Cloud Dragon'] = GetMovement.CloudDragon,
    ['Cloud Eagle'] = GetMovement.CloudEagle,
    ['Coiled Dragon'] = GetMovement.CoiledDragon,
    ['Coiled Serpent'] = GetMovement.CoiledSerpent,
    ['Copper Chariot'] = GetMovement.CopperChariot,
    ['Copper Elephant'] = GetMovement.CopperElephant,
    ['Copper General'] = GetMovement.CopperGeneral,
    ['Crossbow General'] = GetMovement.CrossbowGeneral,
    ['Crossbow Soldier'] = GetMovement.CrossbowSoldier,
    ['Dark Spirit'] = GetMovement.DarkSpirit,
    ['Deva'] = GetMovement.Deva,
    ['Divine Dragon'] = GetMovement.DivineDragon,
    ['Divine Sparrow'] = GetMovement.DivineSparrow,
    ['Divine Tiger'] = GetMovement.DivineTiger,
    ['Divine Turtle'] = GetMovement.DivineTurtle,
    ['Dog'] = GetMovement.Dog,
    ['Donkey'] = GetMovement.Donkey,
    ['Dragon Horse'] = GetMovement.DragonHorse,
    ['Dragon King'] = GetMovement.DragonKing,
    ['Drunken Elephant'] = GetMovement.DrunkenElephant,
    ['Earth Chariot'] = GetMovement.EarthChariot,
    ['Earth Dragon'] = GetMovement.EarthDragon,
    ['Earth General'] = GetMovement.EarthGeneral,
    ['Eastern Barbarian'] = GetMovement.EasternBarbarian,
    ['Elephant King'] = GetMovement.ElephantKing,
    ['Enchanted Badger'] = GetMovement.EnchantedBadger,
    ['Evil Wolf'] = GetMovement.EvilWolf,
    ['Ferocious Leopard'] = GetMovement.FerociousLeopard,
    ['Fierce Eagle'] = GetMovement.FierceEagle,
    ['Fire Demon'] = GetMovement.FireDemon,
    ['Fire Dragon'] = GetMovement.FireDragon,
    ['Fire General'] = GetMovement.FireGeneral,
    ['Fire Ox'] = GetMovement.FireOx,
    ['Flying Cat'] = GetMovement.FlyingCat,
    ['Flying Cock'] = GetMovement.FlyingCock,
    ['Flying Crocodile'] = GetMovement.FlyingCrocodile,
    ['Flying Dragon'] = GetMovement.FlyingDragon,
    ['Flying Falcon'] = GetMovement.FlyingFalcon,
    ['Flying Goose'] = GetMovement.FlyingGoose,
    ['Flying Horse'] = GetMovement.FlyingHorse,
    ['Flying Ox'] = GetMovement.FlyingOx,
    ['Flying Stag'] = GetMovement.FlyingStag,
    ['Flying Swallow'] = GetMovement.FlyingSwallow,
    ['Forest Demon'] = GetMovement.ForestDemon,
    ['Fragrant Elephant'] = GetMovement.FragrantElephant,
    ['Free Baku'] = GetMovement.FreeBaku,
    ['Free Bear'] = GetMovement.FreeBear,
    ['Free Bird'] = GetMovement.FreeBird,
    ['Free Boar'] = GetMovement.FreeBoar,
    ['Free Chicken'] = GetMovement.FreeChicken,
    ['Free Demon'] = GetMovement.FreeDemon,
    ['Free Dog'] = GetMovement.FreeDog,
    ['Free Dragon'] = GetMovement.FreeDragon,
    ['Free Eagle'] = GetMovement.FreeEagle,
    ['Free Fire'] = GetMovement.FreeFire,
    ['Free Horse'] = GetMovement.FreeHorse,
    ['Free King'] = GetMovement.FreeKing,
    ['Free Leopard'] = GetMovement.FreeLeopard,
    ['Free Ox'] = GetMovement.FreeOx,
    ['Free Pig'] = GetMovement.FreePig,
    ['Free Pup'] = GetMovement.FreePup,
    ['Free Serpe'] = GetMovement.FreeSerpe,
    ['Free Serpent'] = GetMovement.FreeSerpent,
    ['Free Stag'] = GetMovement.FreeStag,
    ['Free Tiger'] = GetMovement.FreeTiger,
    ['Free Wolf'] = GetMovement.FreeWolf,
    ['Front Standard'] = GetMovement.FrontStandard,
    ['Furious Fiend'] = GetMovement.FuriousFiend,
    ['Gliding Swallow'] = GetMovement.GlidingSwallow,
    ['Go Between'] = GetMovement.GoBetween,
    ['Gold Chariot'] = GetMovement.GoldChariot,
    ['Gold General'] = GetMovement.GoldGeneral,
    ['Golden Bird'] = GetMovement.GoldenBird,
    ['Golden Deer'] = GetMovement.GoldenDeer,
    ['Goose Wing'] = GetMovement.GooseWing,
    ['Great Bear'] = GetMovement.GreatBear,
    ['Great Dove'] = GetMovement.GreatDove,
    ['Great Dragon'] = GetMovement.GreatDragon,
    ['Great Dream Eater'] = GetMovement.GreatDreamEater,
    ['Great Eagle'] = GetMovement.GreatEagle,
    ['Great Elephant'] = GetMovement.GreatElephant,
    ['Great Falcon'] = GetMovement.GreatFalcon,
    ['Great General'] = GetMovement.GreatGeneral,
    ['Great Horse'] = GetMovement.GreatHorse,
    ['Great Leopard'] = GetMovement.GreatLeopard,
    ['Great Master'] = GetMovement.GreatMaster,
    ['Great Shark'] = GetMovement.GreatShark,
    ['Great Stag'] = GetMovement.GreatStag,
    ['Great Standard'] = GetMovement.GreatStandard,
    ['Great Tiger'] = GetMovement.GreatTiger,
    ['Great Turtle'] = GetMovement.GreatTurtle,
    ['Great Whale'] = GetMovement.GreatWhale,
    ['Guardian of the Gods'] = GetMovement.GuardianoftheGods,
    ['Heavenly Horse'] = GetMovement.HeavenlyHorse,
    ['Heavenly Tetrarch'] = GetMovement.HeavenlyTetrarch,
    ['Heavenly Tetrarch King'] = GetMovement.HeavenlyTetrarchKing,
    ['Hook-Mover'] = GetMovement.HookMover,
    ['Horned Falcon'] = GetMovement.HornedFalcon,
    ['Horse General'] = GetMovement.HorseGeneral,
    ['Horse Soldier'] = GetMovement.HorseSoldier,
    ['Horseman'] = GetMovement.Horseman,
    ['Howling Dog'] = GetMovement.HowlingDog,
    ['Iron General'] = GetMovement.IronGeneral,
    ['King'] = GetMovement.King,
    ['KingKing'] = GetMovement.KingKing,
    ['Kirin'] = GetMovement.Kirin,
    ['Kirin-Master'] = GetMovement.KirinMaster,
    ['Knight'] = GetMovement.Knight,
    ['Lance'] = GetMovement.Lance,
    ['Left Army'] = GetMovement.LeftArmy,
    ['Left Chariot'] = GetMovement.LeftChariot,
    ['Left Dog'] = GetMovement.LeftDog,
    ['Left Dragon'] = GetMovement.LeftDragon,
    ['Left General'] = GetMovement.LeftGeneral,
    ['Left Iron Chariot'] = GetMovement.LeftIronChariot,
    ['Left Mountain Eagle'] = GetMovement.LeftMountainEagle,
    ['Left Tiger'] = GetMovement.LeftTiger,
    ['Leopard King'] = GetMovement.LeopardKing,
    ['Leopard Soldier'] = GetMovement.LeopardSoldier,
    ['Liberated Horse'] = GetMovement.LiberatedHorse,
    ['Lion'] = GetMovement.Lion,
    ['Lion Dog'] = GetMovement.LionDog,
    ['Lion Hawk'] = GetMovement.LionHawk,
    ['Little Standard'] = GetMovement.LittleStandard,
    ['Little Turtle'] = GetMovement.LittleTurtle,
    ['Longbow General'] = GetMovement.LongbowGeneral,
    ['Longbow Soldier'] = GetMovement.LongbowSoldier,
    ['Mountain Crane'] = GetMovement.MountainCrane,
    ['Mountain Falcon'] = GetMovement.MountainFalcon,
    ['Mountain General'] = GetMovement.MountainGeneral,
    ['Mountain Stag'] = GetMovement.MountainStag,
    ['Mountain Witch'] = GetMovement.MountainWitch,
    ['Multi-General'] = GetMovement.MultiGeneral,
    ['Neighboring King'] = GetMovement.NeighboringKing,
    ['Northern Barbarian'] = GetMovement.NorthernBarbarian,
    ['Old Kite'] = GetMovement.OldKite,
    ['Old Monkey'] = GetMovement.OldMonkey,
    ['Old Rat'] = GetMovement.OldRat,
    ['Ox General'] = GetMovement.OxGeneral,
    ['Ox Soldier'] = GetMovement.OxSoldier,
    ['Oxcart'] = GetMovement.Oxcart,
    ['Pawn'] = GetMovement.Pawn,
    ['Peaceful Mountain'] = GetMovement.PeacefulMountain,
    ['Peacock'] = GetMovement.Peacock,
    ['Phoenix'] = GetMovement.Phoenix,
    ['Phoenix Master'] = GetMovement.PhoenixMaster,
    ['Pig General'] = GetMovement.PigGeneral,
    ['Playful Cockatoo'] = GetMovement.PlayfulCockatoo,
    ['Plodding Ox'] = GetMovement.PloddingOx,
    ['Poisonous Snake'] = GetMovement.PoisonousSnake,
    ['Prancing Stag'] = GetMovement.PrancingStag,
    ['Prince'] = GetMovement.Prince,
    ['Pup General'] = GetMovement.PupGeneral,
    ['Queen'] = GetMovement.Queen,
    ['Raiding Falcon'] = GetMovement.RaidingFalcon,
    ['Rain Demon'] = GetMovement.RainDemon,
    ['Rain Dragon'] = GetMovement.RainDragon,
    ['Ram\'s-Head Soldier'] = GetMovement.RamsHeadSoldier,
    ['Rear Standard'] = GetMovement.RearStandard,
    ['Reclining Dragon'] = GetMovement.RecliningDragon,
    ['Reverse Chariot'] = GetMovement.ReverseChariot,
    ['Right Army'] = GetMovement.RightArmy,
    ['Right Chariot'] = GetMovement.RightChariot,
    ['Right Dog'] = GetMovement.RightDog,
    ['Right Dragon'] = GetMovement.RightDragon,
    ['Right General'] = GetMovement.RightGeneral,
    ['Right Iron Chariot'] = GetMovement.RightIronChariot,
    ['Right Mountain Eagle'] = GetMovement.RightMountainEagle,
    ['Right Phoenix'] = GetMovement.RightPhoenix,
    ['Right Tiger'] = GetMovement.RightTiger,
    ['River General'] = GetMovement.RiverGeneral,
    ['Roaring Dog'] = GetMovement.RoaringDog,
    ['Roc Master'] = GetMovement.RocMaster,
    ['Rook'] = GetMovement.Rook,
    ['Rook General'] = GetMovement.RookGeneral,
    ['Running Bear'] = GetMovement.RunningBear,
    ['Running Boar'] = GetMovement.RunningBoar,
    ['Running Chariot'] = GetMovement.RunningChariot,
    ['Running Dragon'] = GetMovement.RunningDragon,
    ['Running Horse'] = GetMovement.RunningHorse,
    ['Running Leopard'] = GetMovement.RunningLeopard,
    ['Running Ox'] = GetMovement.RunningOx,
    ['Running Pup'] = GetMovement.RunningPup,
    ['Running Rabbit'] = GetMovement.RunningRabbit,
    ['Running Serpent'] = GetMovement.RunningSerpent,
    ['Running Stag'] = GetMovement.RunningStag,
    ['Running Tiger'] = GetMovement.RunningTiger,
    ['Running Tile'] = GetMovement.RunningTile,
    ['Running Wolf'] = GetMovement.RunningWolf,
    ['Rushing Bird'] = GetMovement.RushingBird,
    ['Rushing Boa'] = GetMovement.RushingBoa,
    ['Savage Tiger'] = GetMovement.SavageTiger,
    ['Side Boar'] = GetMovement.SideBoar,
    ['Side Dragon'] = GetMovement.SideDragon,
    ['Side Monkey'] = GetMovement.SideMonkey,
    ['Side Mover'] = GetMovement.SideMover,
    ['Side Ox'] = GetMovement.SideOx,
    ['Side Serpent'] = GetMovement.SideSerpent,
    ['Side Soldier'] = GetMovement.SideSoldier,
    ['Side Wolf'] = GetMovement.SideWolf,
    ['Side-Flyer'] = GetMovement.SideFlyer,
    ['Silver Chariot'] = GetMovement.SilverChariot,
    ['Silver General'] = GetMovement.SilverGeneral,
    ['Silver Rabbit'] = GetMovement.SilverRabbit,
    ['Soaring Eagle'] = GetMovement.SoaringEagle,
    ['Soldier'] = GetMovement.Soldier,
    ['Southern Barbarian'] = GetMovement.SouthernBarbarian,
    ['Spear General'] = GetMovement.SpearGeneral,
    ['Spear Soldier'] = GetMovement.SpearSoldier,
    ['Spirit Turtle'] = GetMovement.SpiritTurtle,
    ['Square Mover'] = GetMovement.SquareMover,
    ['Stone Chariot'] = GetMovement.StoneChariot,
    ['Stone General'] = GetMovement.StoneGeneral,
    ['Strong Chariot'] = GetMovement.StrongChariot,
    ['Strong Eagle'] = GetMovement.StrongEagle,
    ['Strong Soldier'] = GetMovement.StrongSoldier,
    ['Strutting Crow'] = GetMovement.StruttingCrow,
    ['Swallow\'s Wings'] = GetMovement.SwallowsWings,
    ['Swooping Owl'] = GetMovement.SwoopingOwl,
    ['Sword Genera'] = GetMovement.SwordGenera,
    ['Sword Soldier'] = GetMovement.SwordSoldier,
    ['Teaching King'] = GetMovement.TeachingKing,
    ['Tengu'] = GetMovement.Tengu,
    ['Thunder Runner'] = GetMovement.ThunderRunner,
    ['Thunder Runner '] = GetMovement.ThunderRunner,
    ['Tiger Soldier'] = GetMovement.TigerSoldier,
    ['Tile Chariot'] = GetMovement.TileChariot,
    ['Tile General'] = GetMovement.TileGeneral,
    ['Treacherous Fox'] = GetMovement.TreacherousFox,
    ['Treasure Turtle'] = GetMovement.TreasureTurtle,
    ['Turtle Dove'] = GetMovement.TurtleDove,
    ['Turtle Snake'] = GetMovement.TurtleSnake,
    ['Turtle-Snake'] = GetMovement.TurtleSnake,
    ['Venomous Wolf'] = GetMovement.VenomousWolf,
    ['Vermillion Sparrow'] = GetMovement.VermillionSparrow,
    ['Vertical Bear'] = GetMovement.VerticalBear,
    ['Vertical Horse'] = GetMovement.VerticalHorse,
    ['Vertical Leopard'] = GetMovement.VerticalLeopard,
    ['Vertical Mover'] = GetMovement.VerticalMover,
    ['Vertical Pup'] = GetMovement.VerticalPup,
    ['Vertical Soldier'] = GetMovement.VerticalSoldier,
    ['Vertical Tiger'] = GetMovement.VerticalTiger,
    ['Vertical Wolf'] = GetMovement.VerticalWolf,
    ['Vice General'] = GetMovement.ViceGeneral,
    ['Violent Bear'] = GetMovement.ViolentBear,
    ['Violent Dragon'] = GetMovement.ViolentDragon,
    ['Violent Ox'] = GetMovement.ViolentOx,
    ['Violent Stag'] = GetMovement.ViolentStag,
    ['Violent Wind'] = GetMovement.ViolentWind,
    ['Violent Wolf'] = GetMovement.ViolentWolf,
    ['Walking Heron'] = GetMovement.WalkingHeron,
    ['Water Buffalo'] = GetMovement.WaterBuffalo,
    ['Water Dragon'] = GetMovement.WaterDragon,
    ['Water General'] = GetMovement.WaterGeneral,
    ['Western Barbarian'] = GetMovement.WesternBarbarian,
    ['Whale'] = GetMovement.Whale,
    ['White Elephant'] = GetMovement.WhiteElephant,
    ['White Horse'] = GetMovement.WhiteHorse,
    ['White Tiger'] = GetMovement.WhiteTiger,
    ['Wind Dragon'] = GetMovement.WindDragon,
    ['Wind General'] = GetMovement.WindGeneral,
    ['Wind Snapping Turtle'] = GetMovement.WindSnappingTurtle,
    ['Wizard Stork'] = GetMovement.WizardStork,
    ['Wood Chariot'] = GetMovement.WoodChariot,
    ['Wood General'] = GetMovement.WoodGeneral,
    ['Wooden Dove'] = GetMovement.WoodenDove,
    ['Woodland Demon'] = GetMovement.WoodlandDemon,
    ['Wrestler'] = GetMovement.Wrestler,
    ['Yaksha'] = GetMovement.Yaksha,
    ['Young Bird'] = GetMovement.YoungBird
}


function handlePieceMovement(piece, pickup)
    local parts = piece.getGMNotes():splitTrim('/')
    local name = parts[1]
    if piece.is_face_down and parts[2] ~= nil then name = parts[2] end

    local movementFunction = MovementTable[name]
    if movementFunction == nil then return end

    movementFunction(piece, pickup)
end

--------------------
-- Movement Logic --
--------------------

function GetTile(x, z)
    local hits = Physics.cast({
          origin = {x, 2.5, z}
        , direction = {0, 1, 0}
        , size = {0.5, 0.5, 0.5}
        , type = 2
        , max_distance = 0
        -- , debug = true
    })

    for _, hit in ipairs(hits) do
        local obj = hit.hit_object
        if obj.getGMNotes() == TileTag then
            return obj
        end
    end

    return nil
end


function GetTilesFromHits(hits)
    local tiles = {}
    for _, hit in ipairs(hits) do
        if hit.hit_object.getGMNotes() == TileTag then
            table.insert(tiles, hit.hit_object)
        end
    end

    return tiles
end


function GetDiagonalHits(piece)
    local pos = piece.pick_up_position

    local tiles = {}
    
    for i = 0, 50, UNIT do
        local ne = GetTile(pos.x+i, pos.z+i)
        local nw = GetTile(pos.x-i, pos.z+i)
        local se = GetTile(pos.x+i, pos.z-i)
        local sw = GetTile(pos.x-i, pos.z-i)

        if nw ~= nil then
            table.insert(tiles, (nw))
        end

        if ne ~= nil then
            table.insert(tiles, (ne))
        end

        if se ~= nil then
            table.insert(tiles, (se))
        end

        if sw ~= nil then
            table.insert(tiles, (sw))
        end
    end

     return tiles
end


function GetVerticalHits(piece)
    local hits = Physics.cast({
        origin = piece.pick_up_position,
        direction = {0,1,0},
        size = {0.1,10,100},
        type = 3,
        max_distance = 0
        -- ,debug = true
    })

    return GetTilesFromHits(hits)
end


function GetHorizontalHits(piece)
    local hits = Physics.cast({
        origin = piece.pick_up_position,
        direction = {0,1,0},
        size = {100,10,0.1},
        type = 3,
        max_distance = 0
        -- ,debug = true
    })

    return GetTilesFromHits(hits)
end


function GetForwardTile(piece)
    if piece == nil then return end
    
    local pos = piece.pick_up_position
    local rotation = piece.pick_up_rotation.y
    local direction = GetXZDirection(rotation)
    
    local x = pos.x + (UNIT * direction.x) 
    local z = pos.z + (UNIT * direction.z) 

    local tile = GetTile(x, z)

    return tile
end


function GetXZDirection(deg)
    if deg >= 135 and deg < 225 then return { x =  0, z =  1 } end -- North
    if deg >= 225 and deg < 315 then return { x =  1, z =  0 } end -- East
    if deg >= 315 or  deg < 45  then return { x =  0, z = -1 } end -- South
    if deg >= 45  and deg < 135 then return { x = -1, z =  0 } end -- West
end
