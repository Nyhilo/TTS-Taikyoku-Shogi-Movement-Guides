-------------
-- Globals --
-------------

local ScriptingContainer = nil
local PlayingPieceTag = 'Piece'
local TileTag = 'Tile'
local Pieces = nil

local Colors = {
    Reset = { r = 1, g = 1, b = 1, a = 0 }
    , Place = { r = 0.5, g = 0.5, b = 0.5, a = 0.5 }
    , Line = { r = 1, g = 0, b = 0, a = 0.5 }
    , JumpLine = { r = 1, g = 0.5, b = 0, a = 0.5 }
    , Slide = { r = 0, g = 0, b = 1, a = 0.5 }
    , Jump = { r = 1, g = 1, b = 0, a = 0.5 }
    , Jump2 = { r = 0, g = 1, b = 0.5, a = 0.5 }
    , Fly = { r = 1, g = 0, b = 1, a = 0.5 }
    , Eat = { r = 0, g = 1, b = 0.5, a = 0.5 }
}

local UNIT = 1.34
local BOARD_LEN = 50
local BOARD_HEIGHT = 2.5 -- Height of the surface of the board
local CAST_HEIGHT = 10
local POINT_LEN = 0.5
local POINT_SIZE = { POINT_LEN, POINT_LEN, POINT_LEN }
local CAST_DIR = { 0, 1, 0 }

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
    for i = 1, #t do
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
    for str in string.gmatch(self, "([^" .. sep .. "]+)") do
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
        position = { 0, 0, 0 }
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
        HandlePieceMovement(object, true)
    end
end

function onObjectDrop(player_color, object)
    if object.hasTag(PlayingPieceTag) then
        HandlePieceMovement(object, false)
    end
end

------------------------
-- Piece Registration --
------------------------

function RegisterPiece(piece)
    if not isPieceRegistered(piece) then
        if Pieces == nil then
            Pieces = { piece }
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
        local tiles = GetTileSet(piece, {
            { 2, -2 },
            { 1, -1 },
            { 0, -1 },
            { 1, 0 },
            { 1, 1 },
            { 0, 1 },
            { 2, 2 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    BearSoldier = function(piece, pickup)

    end,

    BearsEyes = function(piece, pickup)
        local tiles = GetAreaTiles(piece, 1)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    BeastBird = function(piece, pickup)

    end,

    BeastCadet = function(piece, pickup)
        local dtiles = GetDiagonalTiles(piece, 2)
        local ctiles = GetTileSet(piece, {
            { 0, -1 },
            { 0, -2 },
            { 1, 0 },
            { 2, 0 },
            { 0, 1 },
            { 0, 2 },
        })

        SetColors(dtiles, Colors.Slide, pickup)
        SetColors(ctiles, Colors.Slide, pickup)
    end,

    BeastOfficer = function(piece, pickup)
        local tiles = GetKingTiles(piece, 3)
        local maskTiles = GetTileSet(piece, {
            { 0, -3 },
            { 0, 3 },

            { -1, 0 },
            { -2, 0 },
            { -3, 0 },
        })

        SetColors(tiles, Colors.Slide, pickup)

        -- Mask out tiles
        SetColors(maskTiles, Colors.Reset, pickup)
    end,

    BirdOfParadise = function(piece, pickup)
        local tiles = GetMultiGeneralTiles(piece)

        SetColors(tiles, Colors.Line, pickup)
    end,

    Bishop = function(piece, pickup)
        local tiles = GetDiagonalLines(piece)

        SetColors(tiles, Colors.Line, pickup)
    end,

    BishopGeneral = function(piece, pickup)

    end,

    BlindBear = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { -1, -1 },
            { 0, -1 },
            { 1, -1 },
            { -1, 1 },
            { 0, 1 },
            { 1, 1 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    BlindDog = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { 0, -1 },
            { 1, -1 },
            { 0, 1 },
            { 1, 1 },
            { -1, 0 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    BlindMonkey = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { -1, -1 },
            { 0, -1 },
            { 1, -1 },
            { -1, 1 },
            { 0, 1 },
            { 1, 1 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    BlindTiger = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { 1, -1 },
            { 0, -1 },
            { -1, -1 },
            { -1, 0 },
            { -1, 1 },
            { 0, 1 },
            { 1, 1 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    BlueDragon = function(piece, pickup)
        local line = GetTileListSet({
            GetTileLine_Top(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_Bottom(piece),
        })
        local tiles = GetTileSet(piece, {
            { 0, -1 },
            { 0, 1 },
            { 0, -2 },
            { 0, 2 },
        })

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    BoarSoldier = function(piece, pickup)

    end,

    BuddhistDevil = function(piece, pickup)
        local tiles = GetTileListSet({
            GetUpLeftDiagonalTiles(piece, 3),
            GetUpRightDiagonalTiles(piece, 3),
            GetTileSet(piece, {
                { 0, -1 },
                { 0, 1 },
                { -1, 0 },
            })
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    BuddhistSpirit = function(piece, pickup)

    end,

    BurningChariot = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_Top(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_Bottom(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 0, -1),
            GetRelativeTile(piece, 0, 1),
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    BurningGeneral = function(piece, pickup)

    end,

    BurningSoldier = function(piece, pickup)
        local tiles = GetTileListSet({
            GetUpLeftDiagonalTiles(piece, 5),
            GetUpRightDiagonalTiles(piece, 5),
            GetUpTiles(piece, 7),
            GetLeftTiles(piece, 3),
            GetRightTiles(piece, 3),
            GetDownTiles(piece, 1),
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    Capricorn = function(piece, pickup)

    end,

    CaptiveBird = function(piece, pickup)

    end,

    CaptiveCadet = function(piece, pickup)
        local tiles = GetKingTiles(piece, 3)
        local maskTiles = GetTileSet(piece, {
            { -1, 0 },
            { -2, 0 },
            { -3, 0 },
        })

        SetColors(tiles, Colors.Slide, pickup)

        -- Is this cheating?
        -- nah.
        SetColors(maskTiles, Colors.Reset, pickup)
    end,

    CaptiveOfficer = function(piece, pickup)
        local tiles = GetKingTiles(piece, 3)
        local maskTiles = GetTileSet(piece, {
            { 3, 0 },
            { 0, -3 },
            { 0, 3 },

            { -1, 0 },
            { -2, 0 },
            { -3, 0 },
        })

        SetColors(tiles, Colors.Slide, pickup)

        -- Mask out tiles
        SetColors(maskTiles, Colors.Reset, pickup)
    end,

    CatSword = function(piece, pickup)
        local tiles = GetDiagonalTiles(piece, 1)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    Cavalier = function(piece, pickup)
        local tiles = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_Top(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_Left(piece),
            GetTileLine_Right(piece),
            GetTileLine_Bottom(piece),
        })

        SetColors(tiles, Colors.Line, pickup)
    end,

    CenterMaster = function(piece, pickup)

    end,

    CenterStandard = function(piece, pickup)

    end,

    CeramicDove = function(piece, pickup)
        local line = GetDiagonalLines(piece)
        local tiles = GetCrossTiles(piece, 2)

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    ChariotSoldier = function(piece, pickup)

    end,

    ChickenGeneral = function(piece, pickup)
        local ftiles = GetUpTiles(piece, 4)
        local tiles = GetTileSet(piece, {
            { -1, -1 },
            { -1, 1 },
        })

        SetColors(ftiles, Colors.Slide, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    ChineseCock = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { 0, -1 },
            { 1, -1 },
            { 0, 1 },
            { 1, 1 },
            { -1, 0 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    ChineseRiver = function(piece, pickup)
        local tiles = {
            GetRelativeTile(piece, 1, 0),
            GetRelativeTile(piece, -1, 0),
        }
        local lines = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_Left(piece),
            GetTileLine_Right(piece),
            GetTileLine_BottomLeft(piece),
            GetTileLine_BottomRight(piece),
        })

        SetColors(tiles, Colors.Slide, pickup)
        SetColors(lines, Colors.Line, pickup)
    end,

    ClimbingMonkey = function(piece, pickup)
        local tiles = GetCopperGeneralTiles(piece)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    CloudDragon = function(piece, pickup)
        local tiles = GetAreaTiles(piece, 1)
        local lines = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_BottomLeft(piece),
            GetTileLine_Bottom(piece),
            GetTileLine_BottomRight(piece),
        })

        SetColors(tiles, Colors.Slide, pickup)
        SetColors(lines, Colors.Line, pickup)
    end,

    CloudEagle = function(piece, pickup)

    end,

    CoiledDragon = function(piece, pickup)
        local tiles = GetTileListSet({
            GetTileLine_Top(piece),
            GetTileLine_BottomLeft(piece),
            GetTileLine_Bottom(piece),
            GetTileLine_BottomRight(piece),
        })

        SetColors(tiles, Colors.Line, pickup)
    end,

    CoiledSerpent = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { 1, 0 },
            { -1, -1 },
            { -1, 0 },
            { -1, 1 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    CopperChariot = function(piece, pickup)

    end,

    CopperElephant = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_Top(piece),
            GetTileLine_Bottom(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 1, -1),
            GetRelativeTile(piece, 1, 1),
            GetRelativeTile(piece, 0, -1),
            GetRelativeTile(piece, 0, 1),
            GetRelativeTile(piece, -1, -1),
            GetRelativeTile(piece, -1, 1)
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    CopperGeneral = function(piece, pickup)
        local tiles = GetCopperGeneralTiles(piece)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    CrossbowGeneral = function(piece, pickup)

    end,

    CrossbowSoldier = function(piece, pickup)
        local tiles = GetTileListSet({
            GetUpLeftDiagonalTiles(piece, 3),
            GetUpRightDiagonalTiles(piece, 3),
            GetUpTiles(piece, 5),
            GetLeftTiles(piece, 3),
            GetRightTiles(piece, 3),
            GetDownTiles(piece, 1),
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    DarkSpirit = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { -1, -1 },
            { 0, -1 },
            { 1, 0 },
            { -1, 0 },
            { -1, 1 },
            { 0, 1 },
            { 1, 1 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    Deva = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { -1, -1 },
            { 0, -1 },
            { 1, -1 },
            { 1, 0 },
            { -1, 0 },
            { -1, 1 },
            { 0, 1 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    DivineDragon = function(piece, pickup)
        local line = GetTileListSet({
            GetTileLine_Top(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_Right(piece),
            GetTileLine_Bottom(piece),
        })
        local tiles = GetTileSet(piece, {
            { 0, -1 },
            { 0, -2 },
        })

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    DivineSparrow = function(piece, pickup)
        local tiles = GetAreaTiles(piece)
        local lines = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_BottomRight(piece),
            GetTileLine_BottomLeft(piece)
        })

        SetColors(tiles, Colors.Slide, pickup)
        SetColors(lines, Colors.Line, pickup)
    end,

    DivineTiger = function(piece, pickup)
        local line = GetTileListSet({
            GetTileLine_Left(piece),
            GetTileLine_TopLeft(piece),
            GetTileLine_Top(piece),
            GetTileLine_Right(piece),
        })
        local tiles = GetTileSet(piece, {
            { -1, 0 },
            { -2, 0 },
        })

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    DivineTurtle = function(piece, pickup)
        local tiles = GetAreaTiles(piece)
        local lines = GetTileListSet({
            GetTileLine_TopRight(piece),
            GetTileLine_BottomRight(piece),
            GetTileLine_BottomLeft(piece)
        })

        SetColors(tiles, Colors.Slide, pickup)
        SetColors(lines, Colors.Line, pickup)
    end,

    Dog = function(piece, pickup)
        local tiles = GetIronGeneralTiles(piece)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    Donkey = function(piece, pickup)
        local tiles = GetCrossTiles(piece, 2)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    DragonHorse = function(piece, pickup)
        local cardinalTiles = GetAreaTiles(piece, 1)
        local diagonalTiles = GetDiagonalLines(piece)

        SetColors(cardinalTiles, Colors.Slide, pickup)
        SetColors(diagonalTiles, Colors.Line, pickup)
    end,

    DragonKing = function(piece, pickup)
        local cardinalTiles = GetAreaTiles(piece, 1)
        local tiles = GetCrossLines(piece)

        SetColors(cardinalTiles, Colors.Slide, pickup)
        SetColors(tiles, Colors.Line, pickup)
    end,

    DrunkenElephant = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { -1, -1 },
            { 0, -1 },
            { 1, -1 },
            { 1, 0 },
            { -1, 1 },
            { 0, 1 },
            { 1, 1 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    EarthChariot = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_Top(piece),
            GetTileLine_Bottom(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 0, -1),
            GetRelativeTile(piece, 0, 1)
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    EarthDragon = function(piece, pickup)

    end,

    EarthGeneral = function(piece, pickup)
        local tiles = GetEarthGeneralTiles(piece)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    EasternBarbarian = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { 1, -1 },
            { 0, -1 },
            { 2, 0 },
            { 1, 0 },
            { -1, 0 },
            { -2, 0 },
            { 1, 1 },
            { 0, 1 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    ElephantKing = function(piece, pickup)
        local line = GetDiagonalLines(piece)
        local tiles = GetCrossTiles(piece, 2)

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    EnchantedBadger = function(piece, pickup)
        local tiles = GetCrossTiles(piece, 2)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    EvilWolf = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { 0, -1 },
            { 1, -1 },
            { 1, 0 },
            { 1, 1 },
            { 0, 1 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    FerociousLeopard = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { 1, -1 },
            { 1, 0 },
            { 1, 1 },
            { -1, -1 },
            { -1, 0 },
            { -1, 1 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    FierceEagle = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { 2, -2 },
            { 2, 2 },
            { 1, -1 },
            { 1, 0 },
            { 1, 1 },
            { 0, -1 },
            { 0, 1 },
            { -1, -1 },
            { -1, 1 },
            { -2, -2 },
            { -2, 2 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    FireDemon = function(piece, pickup)

    end,

    FireDragon = function(piece, pickup)

    end,

    FireGeneral = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { 3, 0 },
            { 2, 0 },
            { 1, 0 },
            { 1, -1 },
            { 1, 1 },
            { -1, 0 },
            { -2, 0 },
            { -3, 0 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    FireOx = function(piece, pickup)
        local tiles = {
            GetRelativeTile(piece, 0, -1),
            GetRelativeTile(piece, 0, 1),
        }
        local lines = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_Top(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_BottomLeft(piece),
            GetTileLine_Bottom(piece),
            GetTileLine_BottomRight(piece),
        })

        SetColors(tiles, Colors.Slide, pickup)
        SetColors(lines, Colors.Line, pickup)
    end,

    FlyingCat = function(piece, pickup)

    end,

    FlyingCock = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { 0, -1 },
            { 1, -1 },
            { 0, 1 },
            { 1, 1 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    FlyingCrocodile = function(piece, pickup)

    end,

    FlyingDragon = function(piece, pickup)

    end,

    FlyingFalcon = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_BottomLeft(piece),
            GetTileLine_BottomRight(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 1, 0),
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    FlyingGoose = function(piece, pickup)
        local tiles = GetCopperGeneralTiles(piece)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    FlyingHorse = function(piece, pickup)
        local tiles = GetDiagonalTiles(piece, 2)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    FlyingOx = function(piece, pickup)
        local tiles = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_Top(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_BottomLeft(piece),
            GetTileLine_Bottom(piece),
            GetTileLine_BottomRight(piece),
        })

        SetColors(tiles, Colors.Line, pickup)
    end,

    FlyingStag = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_Top(piece),
            GetTileLine_Bottom(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 1, -1),
            GetRelativeTile(piece, 1, 1),
            GetRelativeTile(piece, 0, -1),
            GetRelativeTile(piece, 0, 1),
            GetRelativeTile(piece, -1, -1),
            GetRelativeTile(piece, -1, 1)
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    FlyingSwallow = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_TopRight(piece)
        })
        local tile = GetRelativeTile(piece, -1, 0)

        SetColors(lines, Colors.Line, pickup)
        SetColor(tile, Colors.Slide, pickup)
    end,

    ForestDemon = function(piece, pickup)

    end,

    FragrantElephant = function(piece, pickup)
        local tiles = GetKingTiles(piece, 2)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    FreeBaku = function(piece, pickup)

    end,

    FreeBear = function(piece, pickup)
        local tiles = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_Top(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_BottomLeft(piece),
            GetTileLine_Bottom(piece),
            GetTileLine_BottomRight(piece),
        })

        SetColors(tiles, Colors.Line, pickup)
    end,

    FreeBird = function(piece, pickup)

    end,

    FreeBoar = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_Left(piece),
            GetTileLine_TopLeft(piece),
            GetTileLine_Top(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_Right(piece)
        })
        local tiles = {
            GetRelativeTile(piece, -1, 0),
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    FreeChicken = function(piece, pickup)
        local line = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_Top(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_Bottom(piece)
        })
        local tiles = GetTileSet(piece, {
            { 0, -1 },
            { 0, -2 },
            { 0, 1 },
            { 0, 2 },
        })

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    FreeDemon = function(piece, pickup)

    end,

    FreeDog = function(piece, pickup)
        local tiles = GetKingTiles(piece, 2)
        local line = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_Top(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_Bottom(piece)
        })

        SetColors(tiles, Colors.Slide, pickup)
        SetColors(line, Colors.Line, pickup)
    end,

    FreeDragon = function(piece, pickup)
        local tiles = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_Left(piece),
            GetTileLine_Right(piece),
            GetTileLine_BottomLeft(piece),
            GetTileLine_Bottom(piece),
            GetTileLine_BottomRight(piece),
        })

        SetColors(tiles, Colors.Line, pickup)
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
        local tiles = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_Top(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_BottomLeft(piece),
            GetTileLine_Bottom(piece),
            GetTileLine_BottomRight(piece),
        })

        SetColors(tiles, Colors.Line, pickup)
    end,

    FreeOx = function(piece, pickup)

    end,

    FreePig = function(piece, pickup)

    end,

    FreePup = function(piece, pickup)

    end,

    FreeSerpent = function(piece, pickup)
        local tiles = GetTileListSet({
            GetTileLine_Top(piece),
            GetTileLine_BottomLeft(piece),
            GetTileLine_Bottom(piece),
            GetTileLine_BottomRight(piece),
        })

        SetColors(tiles, Colors.Line, pickup)
    end,

    FreeStag = function(piece, pickup)
        local tiles = GetTileListSet({
            GetCrossLines(piece),
            GetDiagonalLines(piece)
        })

        SetColors(tiles, Colors.Line, pickup)
    end,

    FreeTiger = function(piece, pickup)
        local tiles = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_Left(piece),
            GetTileLine_Right(piece),
            GetTileLine_BottomLeft(piece),
            GetTileLine_Bottom(piece),
            GetTileLine_BottomRight(piece),
        })

        SetColors(tiles, Colors.Line, pickup)
    end,

    FreeWolf = function(piece, pickup)
        local tiles = GetTileListSet({
            GetTileLine_Left(piece),
            GetTileLine_TopLeft(piece),
            GetTileLine_Top(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_Right(piece),
        })

        SetColors(tiles, Colors.Line, pickup)
    end,

    FrontStandard = function(piece, pickup)

    end,

    FuriousFiend = function(piece, pickup)
        local leafTiles = GetTileSet(piece, {
            { 3, 3 },
            { 0, 3 },
            { -3, 3 },
            { -3, 0 },
            { -3, -3 },
            { 0, -3 },
            { 3, -3 },
            { 3, 0 },
        })

        local outerTiles = GetAreaTiles(piece, 2)
        local innerTiles = GetAreaTiles(piece, 1)

        SetColors(leafTiles, Colors.Slide, pickup)
        SetColors(outerTiles, Colors.Jump, pickup)
        SetColors(innerTiles, Colors.Eat, pickup)
    end,

    GlidingSwallow = function(piece, pickup)
        local tiles = GetCrossLines(piece)

        SetColors(tiles, Colors.Line, pickup)
    end,

    GoBetween = function(piece, pickup)
        local tiles = GetEarthGeneralTiles(piece)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    GoldChariot = function(piece, pickup)

    end,

    GoldGeneral = function(piece, pickup)
        local tiles = GetGoldGeneralTiles(piece)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    GoldenBird = function(piece, pickup)

    end,

    GoldenDeer = function(piece, pickup)
        local line = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_TopRight(piece),
        })
        local tiles = {
            GetRelativeTile(piece, -1, -1),
            GetRelativeTile(piece, -1, 1),
            GetRelativeTile(piece, -2, -2),
            GetRelativeTile(piece, -2, 2),
        }

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    GooseWing = function(piece, pickup)

    end,

    GreatBear = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_Top(piece),
            GetTileLine_TopRight(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 0, -1),
            GetRelativeTile(piece, -1, 0),
            GetRelativeTile(piece, 0, 1)
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
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
        local line = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_Top(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_Bottom(piece)
        })
        local tiles = GetTileSet(piece, {
            { 0, -1 },
            { 0, -2 },
            { 0, 1 },
            { 0, 2 },
        })

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
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
        local lines = GetTileListSet({
            GetTileLine_Left(piece),
            GetTileLine_Bottom(piece),
            GetTileLine_Right(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 1, 0)
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    GreatTurtle = function(piece, pickup)

    end,

    GreatWhale = function(piece, pickup)
        local tiles = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_Top(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_BottomLeft(piece),
            GetTileLine_Bottom(piece),
            GetTileLine_BottomRight(piece),
        })

        SetColors(tiles, Colors.Line, pickup)
    end,

    GuardianoftheGods = function(piece, pickup)
        local tiles = GetCrossTiles(piece, 3)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    HeavenlyHorse = function(piece, pickup)

    end,

    HeavenlyTetrarch = function(piece, pickup)
        local tiles = GetKingTiles(piece, 4)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    HeavenlyTetrarchKing = function(piece, pickup)

    end,

    HookMover = function(piece, pickup)

    end,

    HornedFalcon = function(piece, pickup)

    end,

    HorseGeneral = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { 3, 0 },
            { 2, 0 },
            { 1, 0 },
            { -1, 0 },
            { 1, -1 },
            { 1, 1 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    HorseSoldier = function(piece, pickup)

    end,

    Horseman = function(piece, pickup)
        local line = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_Top(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_Bottom(piece)
        })
        local tiles = GetTileSet(piece, {
            { 0, -1 },
            { 0, -2 },
            { 0, 1 },
            { 0, 2 },
        })

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    HowlingDog = function(piece, pickup)
        local line = GetTileLine_Top(piece)
        local backTile = GetRelativeTile(piece, -1, 0)

        SetColors(line, Colors.Line, pickup)
        SetColor(backTile, Colors.Slide, pickup)
    end,

    IronGeneral = function(piece, pickup)
        local tiles = GetIronGeneralTiles(piece)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    King = function(piece, pickup)
        local tiles = GetKingTiles(piece, 2)

        SetColors(tiles, Colors.Slide, pickup)
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
        local tiles = GetTileLine_Top(piece)

        SetColors(tiles, Colors.Line, pickup)
    end,

    LeftArmy = function(piece, pickup)
        local tiles = GetAreaTiles(piece, 1)
        local lines = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_Left(piece),
            GetTileLine_BottomLeft(piece)
        })

        SetColors(tiles, Colors.Slide, pickup)
        SetColors(lines, Colors.Line, pickup)
    end,

    LeftChariot = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_Top(piece),
            GetTileLine_BottomRight(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 0, -1)
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    LeftDog = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_Top(piece),
            GetTileLine_BottomRight(piece)
        })
        local tile = GetRelativeTile(piece, -1, 0)

        SetColors(lines, Colors.Line, pickup)
        SetColor(tile, Colors.Slide, pickup)
    end,

    LeftDragon = function(piece, pickup)
        local line = GetTileListSet({
            GetTileLine_TopRight(piece),
            GetTileLine_Right(piece),
            GetTileLine_BottomRight(piece),
        })
        local tiles = GetTileSet(piece, {
            { 0, -1 },
            { 0, -2 },
        })

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    LeftGeneral = function(piece, pickup)
        local tiles = GetAreaTiles(piece, 1)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    LeftIronChariot = function(piece, pickup)
        local line = GetTileLine_BottomRight(piece)
        local tiles = {
            GetRelativeTile(piece, 0, -1),
            GetRelativeTile(piece, 0, 1),
            GetRelativeTile(piece, 1, 0),
            GetRelativeTile(piece, -1, 0),
        }

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    LeftMountainEagle = function(piece, pickup)

    end,

    LeftTiger = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_TopRight(piece),
            GetTileLine_Right(piece),
            GetTileLine_BottomRight(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 1, -1),
            GetRelativeTile(piece, -1, -1)
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    LeopardKing = function(piece, pickup)
        local tiles = GetKingTiles(piece, 5)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    LeopardSoldier = function(piece, pickup)

    end,

    LiberatedHorse = function(piece, pickup)

    end,

    Lion = function(piece, pickup)
        local outerTiles = GetAreaTiles(piece, 2)
        local innerTiles = GetAreaTiles(piece, 1)

        SetColors(outerTiles, Colors.Jump, pickup)
        SetColors(innerTiles, Colors.Eat, pickup)
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
        local tiles = GetTileListSet({
            GetUpLeftDiagonalTiles(piece, 3),
            GetUpRightDiagonalTiles(piece, 3),
            GetTileSet(piece, {
                { 1, 0 },
                { -1, 0 },
            })
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    MountainStag = function(piece, pickup)
        local tiles = GetTileListSet({
            GetUpLeftDiagonalTiles(piece, 3),
            GetUpRightDiagonalTiles(piece, 3),
            GetTileSet(piece, {
                { 1, 0 },
                { 0, -2 },
                { 0, -1 },
                { 0, 1 },
                { 0, 2 },
                { -1, 0 },
                { -2, 0 },
                { -3, 0 },
                { -4, 0 },
            })
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    MountainWitch = function(piece, pickup)
        local tiles = GetTileListSet({
            GetTileLine_BottomLeft(piece),
            GetTileLine_Bottom(piece),
            GetTileLine_BottomRight(piece),
        })

        SetColors(tiles, Colors.Line, pickup)
    end,

    MultiGeneral = function(piece, pickup)
        local tiles = GetMultiGeneralTiles(piece)

        SetColors(tiles, Colors.Line, pickup)
    end,

    NeighboringKing = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { -1, -1 },
            { 0, -1 },
            { 1, -1 },
            { 1, 0 },
            { -1, 1 },
            { 0, 1 },
            { 1, 1 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    NorthernBarbarian = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { 1, -1 },
            { 1, 0 },
            { 1, 1 },
            { 0, -2 },
            { 0, -1 },
            { 0, 1 },
            { 0, 2 },
            { -1, 0 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    OldKite = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { 2, -2 },
            { 2, 2 },
            { 1, -1 },
            { 1, 1 },
            { 0, -1 },
            { 0, 1 },
            { -1, -1 },
            { -1, 1 },
            { -2, -2 },
            { -2, 2 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    OldMonkey = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { 1, -1 },
            { 1, 1 },
            { -1, -1 },
            { -1, 0 },
            { -1, 1 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    OldRat = function(piece, pickup)
        local tiles = GetSwoopingOwlTiles(piece)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    OxGeneral = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { 3, 0 },
            { 2, 0 },
            { 1, 0 },
            { -1, 0 },
            { 1, -1 },
            { 1, 1 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    OxSoldier = function(piece, pickup)

    end,

    Oxcart = function(piece, pickup)
        local tiles = GetTileLine_Top(piece)

        SetColors(tiles, Colors.Line, pickup)
    end,

    Pawn = function(piece, pickup)
        local tile = GetRelativeTile(piece, 1, 0)

        SetColor(tile, Colors.Slide, pickup)
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
        local tiles = GetTileListSet({
            GetUpLeftDiagonalTiles(piece, 4),
            GetUpRightDiagonalTiles(piece, 4),
            GetTileSet(piece, {
                { -1, 0 },
                { -2, 0 },
            })
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    PlayfulCockatoo = function(piece, pickup)

    end,

    PloddingOx = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_Top(piece),
            GetTileLine_Bottom(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 1, -1),
            GetRelativeTile(piece, 1, 1),
            GetRelativeTile(piece, -1, -1),
            GetRelativeTile(piece, -1, 1)
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    PoisonousSnake = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { 2, 0 },
            { 1, -1 },
            { 1, 0 },
            { 1, 1 },
            { 0, -2 },
            { 0, -1 },
            { 0, 1 },
            { 0, 2 },
            { -1, 0 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    PrancingStag = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { 1, -1 },
            { 1, 0 },
            { 1, 1 },
            { 0, -2 },
            { 0, -1 },
            { 0, 1 },
            { 0, 2 },
            { -1, 0 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    Prince = function(piece, pickup)
        local tiles = GetAreaTiles(piece, 1)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    PupGeneral = function(piece, pickup)

    end,

    Queen = function(piece, pickup)
        local tiles = GetTileListSet({
            GetCrossLines(piece),
            GetDiagonalLines(piece)
        })

        SetColors(tiles, Colors.Line, pickup)
    end,

    RaidingFalcon = function(piece, pickup)
        local line = GetTileLine_Top(piece)
        local tiles = {
            GetRelativeTile(piece, 0, -1),
            GetRelativeTile(piece, 0, 1),
            GetRelativeTile(piece, 1, -1),
            GetRelativeTile(piece, 1, 1),
        }

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    RainDemon = function(piece, pickup)

    end,

    RainDragon = function(piece, pickup)
        local tiles = GetAreaTiles(piece, 1)
        local lines = GetTileListSet({
            GetTileLine_Left(piece),
            GetTileLine_Right(piece),
            GetTileLine_BottomLeft(piece),
            GetTileLine_Bottom(piece),
            GetTileLine_BottomRight(piece),
        })

        SetColors(tiles, Colors.Slide, pickup)
        SetColors(lines, Colors.Line, pickup)
    end,

    RamsHeadSoldier = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_TopRight(piece)
        })
        local tile = GetRelativeTile(piece, -1, 0)

        SetColors(lines, Colors.Line, pickup)
        SetColor(tile, Colors.Slide, pickup)
    end,

    RearStandard = function(piece, pickup)
        local line = GetCrossLines(piece)
        local tiles = GetDiagonalTiles(piece, 2)

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    RecliningDragon = function(piece, pickup)
        local tiles = GetCrossTiles(piece, 1)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    ReverseChariot = function(piece, pickup)
        local utiles = GetTileLine_Top(piece)
        local dtiles = GetTileLine_Bottom(piece)

        SetColors(utiles, Colors.Line, pickup)
        SetColors(dtiles, Colors.Line, pickup)
    end,

    RightArmy = function(piece, pickup)
        local tiles = GetAreaTiles(piece, 1)
        local lines = GetTileListSet({
            GetTileLine_TopRight(piece),
            GetTileLine_Right(piece),
            GetTileLine_BottomRight(piece)
        })

        SetColors(tiles, Colors.Slide, pickup)
        SetColors(lines, Colors.Line, pickup)
    end,

    RightChariot = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_TopRight(piece),
            GetTileLine_Top(piece),
            GetTileLine_BottomLeft(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 0, 1)
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    RightDog = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_Top(piece),
            GetTileLine_BottomLeft(piece)
        })
        local tile = GetRelativeTile(piece, -1, 0)

        SetColors(lines, Colors.Line, pickup)
        SetColor(tile, Colors.Slide, pickup)
    end,

    RightDragon = function(piece, pickup)
        local line = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_Left(piece),
            GetTileLine_BottomLeft(piece),
        })
        local tiles = GetTileSet(piece, {
            { 0, 1 },
            { 0, 2 },
        })

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    RightGeneral = function(piece, pickup)
        local tiles = GetAreaTiles(piece, 1)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    RightIronChariot = function(piece, pickup)
        local line = GetTileLine_BottomLeft(piece)
        local tiles = {
            GetRelativeTile(piece, 0, -1),
            GetRelativeTile(piece, 0, 1),
            GetRelativeTile(piece, 1, 0),
            GetRelativeTile(piece, -1, 0),
        }

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    RightMountainEagle = function(piece, pickup)

    end,

    RightPhoenix = function(piece, pickup)

    end,

    RightTiger = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_Left(piece),
            GetTileLine_BottomLeft(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 1, 1),
            GetRelativeTile(piece, -1, 1)
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    RiverGeneral = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { 3, 0 },
            { 2, 0 },
            { 1, 0 },
            { 1, -1 },
            { 1, 1 },
            { -1, 0 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    RoaringDog = function(piece, pickup)

    end,

    RocMaster = function(piece, pickup)

    end,

    Rook = function(piece, pickup)
        local tiles = GetCrossLines(piece)

        SetColors(tiles, Colors.Line, pickup)
    end,

    RookGeneral = function(piece, pickup)

    end,

    RunningBear = function(piece, pickup)
        local line = GetTileListSet({
            GetTileLine_Top(piece),
            GetTileLine_Bottom(piece),
        })
        local tiles = {
            GetRelativeTile(piece, 0, -1),
            GetRelativeTile(piece, 0, 1),
            GetRelativeTile(piece, 0, -2),
            GetRelativeTile(piece, 0, 2),
        }

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    RunningBoar = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_Top(piece),
            GetTileLine_Bottom(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 0, -1),
            GetRelativeTile(piece, 0, 1)
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    RunningChariot = function(piece, pickup)
        local tiles = GetCrossLines(piece)

        SetColors(tiles, Colors.Line, pickup)
    end,

    RunningDragon = function(piece, pickup)

    end,

    RunningHorse = function(piece, pickup)

    end,

    RunningLeopard = function(piece, pickup)
        local tiles = GetTileListSet({
            GetTileLine_Left(piece),
            GetTileLine_TopLeft(piece),
            GetTileLine_Top(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_Right(piece),
        })

        SetColors(tiles, Colors.Line, pickup)
    end,

    RunningOx = function(piece, pickup)

    end,

    RunningPup = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_Top(piece),
            GetTileLine_Bottom(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 0, -1),
            GetRelativeTile(piece, 0, 1)
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    RunningRabbit = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_Top(piece),
            GetTileLine_TopRight(piece)
        })
        local tiles = {
            GetRelativeTile(piece, -1, -1),
            GetRelativeTile(piece, -1, 0),
            GetRelativeTile(piece, -1, 1)
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    RunningSerpent = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_Top(piece),
            GetTileLine_Bottom(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 0, -1),
            GetRelativeTile(piece, 0, 1)
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    RunningStag = function(piece, pickup)
        local line = GetTileListSet({
            GetTileLine_Top(piece),
            GetTileLine_TopLeft(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_Right(piece),
        })
        local tiles = GetTileSet(piece, {
            { -1, 0 },
            { -2, 0 },
        })

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    RunningTiger = function(piece, pickup)
        local line = GetTileListSet({
            GetTileLine_Top(piece),
            GetTileLine_Bottom(piece),
        })
        local tiles = GetTileSet(piece, {
            { 0, -1 },
            { 0, 1 },
            { 0, -2 },
            { 0, 2 },
        })

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    RunningTile = function(piece, pickup)
        local line = GetTileListSet({
            GetTileLine_Top(piece),
            GetTileLine_Bottom(piece),
        })
        local tiles = GetTileSet(piece, {
            { 0, -1 },
            { 0, 1 },
            { 0, -2 },
            { 0, 2 },
        })

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    RunningWolf = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_Left(piece),
            GetTileLine_Right(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 1, 0),
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    RushingBird = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { 1, -1 },
            { 0, -1 },
            { -1, -1 },
            { 1, 0 },
            { 2, 0 },
            { 1, 1 },
            { 0, 1 },
            { -1, 1 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    RushingBoa = function(piece, pickup)

    end,

    SavageTiger = function(piece, pickup)
        local tiles = GetTileLine_Top(piece)

        SetColors(tiles, Colors.Line, pickup)
    end,

    SideBoar = function(piece, pickup)
        local tiles = GetAreaTiles(piece, 1)
        local lines = GetTileListSet({
            GetTileLine_Left(piece),
            GetTileLine_Right(piece)
        })

        SetColors(tiles, Colors.Slide, pickup)
        SetColors(lines, Colors.Line, pickup)
    end,

    SideDragon = function(piece, pickup)
        local tiles = GetTileListSet({
            GetTileLine_Top(piece),
            GetTileLine_Left(piece),
            GetTileLine_Right(piece),
        })

        SetColors(tiles, Colors.Line, pickup)
    end,

    SideMonkey = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_Left(piece),
            GetTileLine_Right(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 1, -1),
            GetRelativeTile(piece, 1, 1),
            GetRelativeTile(piece, -1, 0)
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    SideMover = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_Left(piece),
            GetTileLine_Right(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 1, 0),
            GetRelativeTile(piece, -1, 0)
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    SideOx = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_Left(piece),
            GetTileLine_Right(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 1, 1),
            GetRelativeTile(piece, -1, -1)
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    SideSerpent = function(piece, pickup)

    end,

    SideSoldier = function(piece, pickup)

    end,

    SideWolf = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_Left(piece),
            GetTileLine_Right(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 1, -1),
            GetRelativeTile(piece, -1, 1)
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    SideFlyer = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_Left(piece),
            GetTileLine_Right(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 1, -1),
            GetRelativeTile(piece, 1, 1),
            GetRelativeTile(piece, -1, -1),
            GetRelativeTile(piece, -1, 1)
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    SilverChariot = function(piece, pickup)

    end,

    SilverGeneral = function(piece, pickup)
        local tiles = GetSilverGeneralTiles(piece)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    SilverRabbit = function(piece, pickup)
        local line = GetTileListSet({
            GetTileLine_BottomLeft(piece),
            GetTileLine_BottomRight(piece),
        })
        local tiles = {
            GetRelativeTile(piece, 1, -1),
            GetRelativeTile(piece, 1, 1),
            GetRelativeTile(piece, 2, -2),
            GetRelativeTile(piece, 2, 2),
        }

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    SoaringEagle = function(piece, pickup)

    end,

    Soldier = function(piece, pickup)
        local tiles = GetCrossLines(piece)

        SetColors(tiles, Colors.Line, pickup)
    end,

    SouthernBarbarian = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { 1, -1 },
            { 1, 0 },
            { 1, 1 },
            { 0, -2 },
            { 0, -1 },
            { 0, 1 },
            { 0, 2 },
            { -1, 0 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    SpearGeneral = function(piece, pickup)

    end,

    SpearSoldier = function(piece, pickup)
        local line = GetTileLine_Top(piece)
        local tiles = {
            GetRelativeTile(piece, -1, 0),
            GetRelativeTile(piece, 0, -1),
            GetRelativeTile(piece, 0, 1),
        }

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    SpiritTurtle = function(piece, pickup)

    end,

    SquareMover = function(piece, pickup)
        local tiles = GetCrossLines(piece)

        SetColors(tiles, Colors.Line, pickup)
    end,

    StoneChariot = function(piece, pickup)

    end,

    StoneGeneral = function(piece, pickup)
        local tiles = GetStoneGeneralTiles(piece)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    StrongChariot = function(piece, pickup)
        local tiles = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_Top(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_Left(piece),
            GetTileLine_Right(piece),
            GetTileLine_Bottom(piece),
        })

        SetColors(tiles, Colors.Line, pickup)
    end,

    StrongEagle = function(piece, pickup)
        local tiles = GetTileListSet({
            GetCrossLines(piece),
            GetDiagonalLines(piece)
        })

        SetColors(tiles, Colors.Line, pickup)
    end,

    StrongSoldier = function(piece, pickup)

    end,

    StruttingCrow = function(piece, pickup)
        local tiles = GetSwoopingOwlTiles(piece)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    SwallowsWings = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_Left(piece),
            GetTileLine_Right(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 1, -1),
            GetRelativeTile(piece, 1, 0),
            GetRelativeTile(piece, 1, 1),
            GetRelativeTile(piece, -1, 0)
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    SwoopingOwl = function(piece, pickup)
        local tiles = GetSwoopingOwlTiles(piece)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    SwordGeneral = function(piece, pickup)
        local tiles = GetTileListSet({
            GetUpLeftDiagonalTiles(piece, 3),
            GetUpRightDiagonalTiles(piece, 3),
            GetTileSet(piece, {
                { 3, 0 },
                { 2, 0 },
                { 1, 0 },
                { -1, 0 },
            })
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    SwordSoldier = function(piece, pickup)
        local tiles = GetTileGeneralTiles(piece)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    TeachingKing = function(piece, pickup)

    end,

    Tengu = function(piece, pickup)

    end,

    ThunderRunner = function(piece, pickup)

    end,

    TigerSoldier = function(piece, pickup)

    end,

    TileChariot = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_Top(piece),
            GetTileLine_Bottom(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 1, 1),
            GetRelativeTile(piece, -1, -1)
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    TileGeneral = function(piece, pickup)
        local tiles = GetTileGeneralTiles(piece)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    TreacherousFox = function(piece, pickup)
        local tiles = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_Top(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_BottomLeft(piece),
            GetTileLine_Bottom(piece),
            GetTileLine_BottomRight(piece),
        })

        SetColors(tiles, Colors.Line, pickup)
    end,

    TreasureTurtle = function(piece, pickup)

    end,

    TurtleDove = function(piece, pickup)
        local tiles = GetTileListSet({
            GetUpLeftDiagonalTiles(piece, 5),
            GetUpRightDiagonalTiles(piece, 5),
            GetTileSet(piece, {
                { 0, -1 },
                { -1, 0 },
                { 0, 1 },
            })
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    TurtleSnake = function(piece, pickup)
        local tiles = GetAreaTiles(piece, 1)
        local lines = GetTileListSet({
            GetTileLine_TopRight(piece),
            GetTileLine_BottomLeft(piece)
        })

        SetColors(tiles, Colors.Slide, pickup)
        SetColors(lines, Colors.Line, pickup)
    end,

    VenomousWolf = function(piece, pickup)
        local tiles = GetAreaTiles(piece, 1)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    VermillionSparrow = function(piece, pickup)
        local tiles = GetAreaTiles(piece, 1)
        local lines = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_BottomRight(piece)
        })

        SetColors(tiles, Colors.Slide, pickup)
        SetColors(lines, Colors.Line, pickup)
    end,

    VerticalBear = function(piece, pickup)

    end,

    VerticalHorse = function(piece, pickup)
        local line = GetTileLine_Top(piece)
        local tiles = {
            GetRelativeTile(piece, -1, 0),
            GetRelativeTile(piece, 1, -1),
            GetRelativeTile(piece, 1, 1),
        }

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    VerticalLeopard = function(piece, pickup)
        local line = GetTileLine_Top(piece)
        local tiles = {
            GetRelativeTile(piece, 1, -1),
            GetRelativeTile(piece, 1, 1),
            GetRelativeTile(piece, 0, -1),
            GetRelativeTile(piece, 0, 1),
            GetRelativeTile(piece, -1, 0),
        }

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    VerticalMover = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_Top(piece),
            GetTileLine_Bottom(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 0, -1),
            GetRelativeTile(piece, 0, 1)
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    VerticalPup = function(piece, pickup)
        local line = GetTileLine_Top(piece)
        local tiles = {
            GetRelativeTile(piece, -1, 0),
            GetRelativeTile(piece, -1, -1),
            GetRelativeTile(piece, -1, 1),
        }

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    VerticalSoldier = function(piece, pickup)

    end,

    VerticalTiger = function(piece, pickup)
        local line = GetTileLine_Top(piece)
        local tiles = {
            GetRelativeTile(piece, -1, 0),
            GetRelativeTile(piece, -2, 0),
        }

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    VerticalWolf = function(piece, pickup)

    end,

    ViceGeneral = function(piece, pickup)

    end,

    ViolentBear = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { 2, -2 },
            { 1, -1 },
            { 0, -1 },
            { 1, 0 },
            { 1, 1 },
            { 0, 1 },
            { 2, 2 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    ViolentDragon = function(piece, pickup)

    end,

    ViolentOx = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_TopRight(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 1, 0),
            GetRelativeTile(piece, -1, 0)
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    ViolentStag = function(piece, pickup)
        local tiles = GetSilverGeneralTiles(piece)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    ViolentWind = function(piece, pickup)

    end,

    ViolentWolf = function(piece, pickup)
        local tiles = GetGoldGeneralTiles(piece)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    WalkingHeron = function(piece, pickup)
        local line = GetTileListSet({
            GetTileLine_Top(piece),
            GetTileLine_Bottom(piece),
        })
        local tiles = GetTileSet(piece, {
            { 0, -1 },
            { 0, 1 },
            { 0, -2 },
            { 0, 2 },
            { 1, -1 },
            { 1, 1 },
            { 2, -2 },
            { 2, 2 },
        })

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    WaterBuffalo = function(piece, pickup)

    end,

    WaterDragon = function(piece, pickup)

    end,

    WaterGeneral = function(piece, pickup)
        local tiles = GetTileListSet({
            GetUpLeftDiagonalTiles(piece, 3),
            GetUpRightDiagonalTiles(piece, 3),
            GetTileSet(piece, {
                { 1, 0 },
                { -1, 0 },
            })
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    WesternBarbarian = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { 1, -1 },
            { 0, -1 },
            { 2, 0 },
            { 1, 0 },
            { -1, 0 },
            { -2, 0 },
            { 1, 1 },
            { 0, 1 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    Whale = function(piece, pickup)
        local tiles = GetTileListSet({
            GetTileLine_Top(piece),
            GetTileLine_BottomLeft(piece),
            GetTileLine_Bottom(piece),
            GetTileLine_BottomRight(piece),
        })

        SetColors(tiles, Colors.Line, pickup)
    end,

    WhiteElephant = function(piece, pickup)
        local tiles = GetKingTiles(piece, 2)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    WhiteHorse = function(piece, pickup)
        local tiles = GetMultiGeneralTiles(piece)

        SetColors(tiles, Colors.Line, pickup)
    end,

    WhiteTiger = function(piece, pickup)
        local line = GetTileListSet({
            GetTileLine_Left(piece),
            GetTileLine_TopLeft(piece),
            GetTileLine_Right(piece),
        })
        local tiles = GetTileSet(piece, {
            { -1, 0 },
            { 1, 0 },
            { -2, 0 },
            { 2, 0 },
        })

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    WindDragon = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_Left(piece),
            GetTileLine_TopLeft(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_Right(piece),
            GetTileLine_BottomRight(piece),
        })
        local tiles = {
            GetRelativeTile(piece, -1, -1),
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    WindGeneral = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { 3, 0 },
            { 2, 0 },
            { 1, 0 },
            { 1, -1 },
            { 1, 1 },
            { -1, 0 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    WindSnappingTurtle = function(piece, pickup)
        local line = GetTileListSet({
            GetTileLine_Top(piece),
            GetTileLine_Bottom(piece),
        })
        local tiles = {
            GetRelativeTile(piece, 1, -1),
            GetRelativeTile(piece, 1, 1),
            GetRelativeTile(piece, 2, -2),
            GetRelativeTile(piece, 2, 2),
        }

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    WizardStork = function(piece, pickup)
        local tiles = GetTileListSet({
            GetTileLine_Left(piece),
            GetTileLine_TopLeft(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_Right(piece),
            GetTileLine_Bottom(piece)
        })

        SetColors(tiles, Colors.Line, pickup)
    end,

    WoodChariot = function(piece, pickup)
        local lines = GetTileListSet({
            GetTileLine_Top(piece),
            GetTileLine_Bottom(piece)
        })
        local tiles = {
            GetRelativeTile(piece, 1, -1),
            GetRelativeTile(piece, -1, 1)
        }

        SetColors(lines, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    WoodGeneral = function(piece, pickup)
        local tiles = GetTileSet(piece, {
            { 2, -2 },
            { 1, -1 },
            { 2, 2 },
            { 1, 1 },
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    WoodenDove = function(piece, pickup)

    end,

    WoodlandDemon = function(piece, pickup)
        local line = GetTileListSet({
            GetTileLine_TopLeft(piece),
            GetTileLine_Top(piece),
            GetTileLine_TopRight(piece),
            GetTileLine_Bottom(piece)
        })
        local tiles = GetTileSet(piece, {
            { 0, -1 },
            { 0, -2 },
            { 0, 1 },
            { 0, 2 },
        })

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
    end,

    Wrestler = function(piece, pickup)
        local tiles = GetDiagonalTiles(piece, 3)

        SetColors(tiles, Colors.Slide, pickup)
    end,

    Yaksha = function(piece, pickup)
        local tiles = GetTileListSet({
            GetRightTiles(piece, 3),
            GetRightTiles(piece, 3),
            GetTileSet(piece, {
                { 1, -1 },
                { 1, 1 },
                { -1, 0 },
            })
        })

        SetColors(tiles, Colors.Slide, pickup)
    end,

    YoungBird = function(piece, pickup)
        local line = GetTileListSet({
            GetTileLine_Top(piece),
            GetTileLine_Bottom(piece),
        })
        local tiles = GetTileSet(piece, {
            { 0, -1 },
            { 0, 1 },
            { 0, -2 },
            { 0, 2 },
            { -1, -1 },
            { -1, 1 },
            { -2, -2 },
            { -2, 2 },
        })

        SetColors(line, Colors.Line, pickup)
        SetColors(tiles, Colors.Slide, pickup)
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
    ['Sword General'] = GetMovement.SwordGeneral,
    ['Sword Soldier'] = GetMovement.SwordSoldier,
    ['Teaching King'] = GetMovement.TeachingKing,
    ['Tengu'] = GetMovement.Tengu,
    ['Thunder Runner'] = GetMovement.ThunderRunner,
    ['Tiger Soldier'] = GetMovement.TigerSoldier,
    ['Tile Chariot'] = GetMovement.TileChariot,
    ['Tile General'] = GetMovement.TileGeneral,
    ['Treacherous Fox'] = GetMovement.TreacherousFox,
    ['Treasure Turtle'] = GetMovement.TreasureTurtle,
    ['Turtle Dove'] = GetMovement.TurtleDove,
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


function HandlePieceMovement(piece, pickup)
    local parts = piece.getGMNotes():splitTrim('/')
    local name = parts[1]
    if piece.is_face_down and parts[2] ~= nil then name = parts[2] end

    local movementFunction = MovementTable[name]
    if movementFunction == nil then return end

    -- Tint the relevant movement tiles
    movementFunction(piece, pickup)

    -- Tint the tile under the picked up piece
    local pos = piece.pick_up_position
    local tile = GetTile(pos.x, pos.z)

    if tile == nil then return end

    SetColor(tile, Colors.Place, pickup)
end

function SetColors(tiles, color, pickup)
    if not pickup then color = Colors.Reset end

    for _, tile in ipairs(tiles) do
        if tile ~= nil then
            tile.setColorTint(color)
        end
    end
end

function SetColor(tile, color, pickup)
    if tile == nil then return end

    if not pickup then color = Colors.Reset end

    tile.setColorTint(color)
end

--------------------
-- Movement Logic --
--------------------

function GetTile(x, z)
    local hits = Physics.cast({
        origin = { x, BOARD_HEIGHT, z }
        , direction = CAST_DIR
        , size = POINT_SIZE
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

function GetRelativeTile(piece, up, right)
    if piece == nil then return end

    local pos = piece.pick_up_position
    local direction = GetXZDirection(piece)

    local x = pos.x + (UNIT * (direction.x * up)) + (UNIT * (direction.z * right))
    local z = pos.z + (UNIT * (direction.x * right)) + (UNIT * (direction.z * up))

    local tile = GetTile(x, z)

    return tile
end

--------------------------------

--[[
    coordinates is a table expected in the form of:
    {
        { z1, x1 }
        { z2, x2 }
        { etc... }
    }
]]
--
function GetTileSet(piece, coordinates)
    local tiles = {}

    for _, coord in ipairs(coordinates) do
        local z = coord[1]
        local x = coord[2]

        table.insert(tiles, (GetRelativeTile(piece, z, x)))
    end

    return tiles
end

-- Expects a list of lists of tiles
function GetTileListSet(tilesets)
    local tiles = {}

    for _, set in ipairs(tilesets) do
        for _, tile in ipairs(set) do
            table.insert(tiles, (tile))
        end
    end

    return tiles
end

function GetAreaTiles(piece, radius)
    radius = radius or 1
    local tiles = {}

    for i = -radius, radius do
        for j = -radius, radius do
            table.insert(tiles, (GetRelativeTile(piece, i, j)))
        end
    end

    return tiles
end

function GetCrossTiles(piece, rank)
    rank = rank or 1
    local tiles = {}

    for i = -rank, rank do
        -- Vertical part of the cross
        table.insert(tiles, (GetRelativeTile(piece, i, 0)))

        -- Horizontal part of the cross
        table.insert(tiles, (GetRelativeTile(piece, 0, i)))
    end

    return tiles
end

function GetDiagonalTiles(piece, rank)
    rank = rank or 1
    local tiles = {}

    for i = 1, rank do
        table.insert(tiles, (GetRelativeTile(piece, i, i)))
        table.insert(tiles, (GetRelativeTile(piece, -i, i)))
        table.insert(tiles, (GetRelativeTile(piece, i, -i)))
        table.insert(tiles, (GetRelativeTile(piece, -i, -i)))
    end

    return tiles
end

function GetUpTiles(piece, rank)
    rank = rank or 1
    local tiles = {}

    for i = 1, rank do
        table.insert(tiles, (GetRelativeTile(piece, i, 0)))
    end

    return tiles
end

function GetDownTiles(piece, rank)
    rank = rank or 1
    local tiles = {}

    for i = 1, rank do
        table.insert(tiles, (GetRelativeTile(piece, -i, 0)))
    end

    return tiles
end

function GetLeftTiles(piece, rank)
    rank = rank or 1
    local tiles = {}

    for i = 1, rank do
        table.insert(tiles, (GetRelativeTile(piece, 0, -i)))
    end

    return tiles
end

function GetRightTiles(piece, rank)
    rank = rank or 1
    local tiles = {}

    for i = 1, rank do
        table.insert(tiles, (GetRelativeTile(piece, 0, i)))
    end

    return tiles
end

function GetUpLeftDiagonalTiles(piece, rank)
    rank = rank or 1
    local tiles = {}

    for i = 1, rank do
        table.insert(tiles, (GetRelativeTile(piece, i, -i)))
    end

    return tiles
end

function GetUpRightDiagonalTiles(piece, rank)
    rank = rank or 1
    local tiles = {}

    for i = 1, rank do
        table.insert(tiles, (GetRelativeTile(piece, i, i)))
    end

    return tiles
end

function GetDownLeftDiagonalTiles(piece, rank)
    rank = rank or 1
    local tiles = {}

    for i = 1, rank do
        table.insert(tiles, (GetRelativeTile(piece, -i, -i)))
    end

    return tiles
end

function GetDownRightDiagonalTiles(piece, rank)
    rank = rank or 1
    local tiles = {}

    for i = 1, rank do
        table.insert(tiles, (GetRelativeTile(piece, -i, i)))
    end

    return tiles
end

function GetKingTiles(piece, rank)
    local tiles = GetCrossTiles(piece, rank)
    local dtiles = GetDiagonalTiles(piece, rank)

    for _, tile in ipairs(dtiles) do
        table.insert(tiles, (tile))
    end

    return tiles
end

--------------------------------

function GetDiagonalLines(piece)
    local totalTiles = {}

    local tl_tiles = GetTileLine_TopLeft(piece)
    local tr_tiles = GetTileLine_TopRight(piece)
    local bl_tiles = GetTileLine_BottomLeft(piece)
    local br_tiles = GetTileLine_BottomRight(piece)

    for _, t in ipairs({ tl_tiles, tr_tiles, bl_tiles, br_tiles }) do
        for _, v in ipairs(t) do
            table.insert(totalTiles, v)
        end
    end

    return totalTiles
end

function GetCrossLines(piece)
    local totalTiles = {}

    local topTiles = GetTileLine_Top(piece)
    local bottomTiles = GetTileLine_Bottom(piece)
    local leftTiles = GetTileLine_Left(piece)
    local rightTiles = GetTileLine_Right(piece)

    for _, t in ipairs({ topTiles, bottomTiles, leftTiles, rightTiles }) do
        for _, v in ipairs(t) do
            table.insert(totalTiles, v)
        end
    end

    return totalTiles
end

--------------------------------

--  ⇑
-- -·-
--  |
function GetTileLine_Top(piece)
    local pos = piece.pick_up_position
    local direction = GetXZDirection(piece)

    local origin = {
        pos.x + ((1 + BOARD_LEN / 2) * direction.x)
        , pos.y
        , pos.z + ((1 + BOARD_LEN / 2) * direction.z)
    }

    local size = { POINT_LEN, CAST_HEIGHT, BOARD_LEN } -- Aligned north-south
    if direction.z == 0 then
        size = { BOARD_LEN, CAST_HEIGHT, POINT_LEN } -- Aligned east-west
    end

    local hits = Physics.cast({
        origin = origin
        , direction = CAST_DIR
        , size = size
        , type = 3
        , max_distance = 0
        -- ,debug = true
    })

    return GetTilesFromHits(hits)
end

--  |
-- -+-
--  ⇓
function GetTileLine_Bottom(piece)
    local pos = piece.pick_up_position
    local direction = GetXZDirection(piece)

    local origin = {
        pos.x - ((1 + BOARD_LEN / 2) * direction.x)
        , pos.y
        , pos.z - ((1 + BOARD_LEN / 2) * direction.z)
    }

    local size = { POINT_LEN, CAST_HEIGHT, BOARD_LEN } -- Aligned north-south
    if direction.z == 0 then
        size = { BOARD_LEN, CAST_HEIGHT, POINT_LEN } -- Aligned east-west
    end

    local hits = Physics.cast({
        origin = origin
        , direction = CAST_DIR
        , size = size
        , type = 3
        , max_distance = 0
        -- ,debug = true
    })

    return GetTilesFromHits(hits)
end

--  ⎹
-- ⇐+-
--  ⎹
function GetTileLine_Left(piece)
    local pos = piece.pick_up_position
    local direction = GetXZDirection(piece)

    local origin = {
        pos.x - ((1 + BOARD_LEN / 2) * direction.z)
        , pos.y
        , pos.z + ((1 + BOARD_LEN / 2) * direction.x)
    }

    local size = { BOARD_LEN, CAST_HEIGHT, POINT_LEN } -- Aligned north-south
    if direction.z == 0 then
        size = { POINT_LEN, CAST_HEIGHT, BOARD_LEN } -- Aligned east-west
    end

    local hits = Physics.cast({
        origin = origin
        , direction = CAST_DIR
        , size = size
        , type = 3
        , max_distance = 0
        -- ,debug = true
    })

    return GetTilesFromHits(hits)
end

--  |
-- -+⇒
--  |
function GetTileLine_Right(piece)
    local pos = piece.pick_up_position
    local direction = GetXZDirection(piece)

    local origin = {
        pos.x + ((1 + BOARD_LEN / 2) * direction.z)
        , pos.y
        , pos.z - ((1 + BOARD_LEN / 2) * direction.x)
    }

    local size = { BOARD_LEN, CAST_HEIGHT, POINT_LEN } -- Aligned north-south
    if direction.z == 0 then
        size = { POINT_LEN, CAST_HEIGHT, BOARD_LEN } -- Aligned east-west
    end

    local hits = Physics.cast({
        origin = origin
        , direction = CAST_DIR
        , size = size
        , type = 3
        , max_distance = 0
        -- , debug = true
    })

    return GetTilesFromHits(hits)
end

-- ⇖ |
--  -+-
--   |
function GetTileLine_TopLeft(piece)
    local pos = piece.pick_up_position
    local direction = GetXZDirection(piece)

    local x = direction.x - direction.z
    local z = direction.x + direction.z

    local tiles = {}

    for i = 1, BOARD_LEN, UNIT do
        local tile = GetTile(pos.x + (i * x), pos.z + (i * z))

        if tile ~= nil then
            table.insert(tiles, (tile))
        end
    end

    return tiles
end

--  | ⇗
-- -+-
--  |
function GetTileLine_TopRight(piece)
    local pos = piece.pick_up_position
    local direction = GetXZDirection(piece)

    local x = direction.x + direction.z
    local z = direction.x - direction.z

    local tiles = {}

    for i = 1, BOARD_LEN, UNIT do
        local tile = GetTile(pos.x + (i * x), pos.z - (i * z))

        if tile ~= nil then
            table.insert(tiles, (tile))
        end
    end

    return tiles
end

--   |
--  -+-
-- ⇙ |
function GetTileLine_BottomLeft(piece)
    local pos = piece.pick_up_position
    local direction = GetXZDirection(piece)

    local x = direction.x + direction.z
    local z = direction.x - direction.z

    local tiles = {}

    for i = 1, BOARD_LEN, UNIT do
        local tile = GetTile(pos.x - (i * x), pos.z + (i * z))

        if tile ~= nil then
            table.insert(tiles, (tile))
        end
    end

    return tiles
end

--  |
-- -+-
--  | ⇘
function GetTileLine_BottomRight(piece)
    local pos = piece.pick_up_position
    local direction = GetXZDirection(piece)

    local x = direction.x - direction.z
    local z = direction.x + direction.z

    local tiles = {}

    for i = 1, BOARD_LEN, UNIT do
        local tile = GetTile(pos.x - (i * x), pos.z - (i * z))

        if tile ~= nil then
            table.insert(tiles, (tile))
        end
    end

    return tiles
end

--------------------------------

function GetTileGeneralTiles(piece)
    return GetTileSet(piece, {
        { 1, -1 },
        { 1, 1 },
        { -1, 0 },
    })
end

function GetEarthGeneralTiles(piece)
    return GetTileSet(piece, {
        { 1, 0 },
        { -1, 0 },
    })
end

function GetStoneGeneralTiles(piece)
    return GetTileSet(piece, {
        { 1, -1 },
        { 1, 1 },
    })
end

function GetCopperGeneralTiles(piece)
    return GetTileSet(piece, {
        { 1, -1 },
        { 1, 0 },
        { 1, 1 },
        { -1, 0 },
    })
end

function GetIronGeneralTiles(piece)
    return GetTileSet(piece, {
        { 1, -1 },
        { 1, 0 },
        { 1, 1 },
    })
end

function GetSilverGeneralTiles(piece)
    return GetTileSet(piece, {
        { 1, -1 },
        { 1, 0 },
        { 1, 1 },
        { -1, -1 },
        { -1, 1 },
    })
end

function GetGoldGeneralTiles(piece)
    return GetTileSet(piece, {
        { 1, -1 },
        { 1, 0 },
        { 1, 1 },
        { 0, -1 },
        { 0, 1 },
        { -1, 0 },
    })
end

function GetSwoopingOwlTiles(piece)
    return GetTileSet(piece, {
        { 1, 0 },
        { -1, -1 },
        { -1, 1 },
    })
end

function GetMultiGeneralTiles(piece)
    local totalTiles = {}

    local tl_tiles = GetTileLine_TopLeft(piece)
    local topTiles = GetTileLine_Top(piece)
    local tr_tiles = GetTileLine_TopRight(piece)
    local bottomTiles = GetTileLine_Bottom(piece)

    for _, t in ipairs({ tl_tiles, topTiles, tr_tiles, bottomTiles }) do
        for _, v in ipairs(t) do
            table.insert(totalTiles, v)
        end
    end

    return totalTiles
end

--------------------------------

function GetXZDirection(piece)
    local deg = piece.pick_up_rotation.y

    -- North
    if deg >= 135 and deg < 225 then return { x = 0, z = 1 } end
    -- East
    if deg >= 225 and deg < 315 then return { x = 1, z = 0 } end
    -- South
    if deg >= 315 or deg < 45 then return { x = 0, z = -1 } end
    -- West
    if deg >= 45 and deg < 135 then return { x = -1, z = 0 } end
end
