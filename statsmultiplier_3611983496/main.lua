local StatsMult = RegisterMod("Damage Multiplier", 1)
StatsMult.Version = '1.0.5'
StatsMult.Name_StatName_CacheFlag_Trinket_Value_CalcFun = {
    ['speed'] = {
        StatName='MoveSpeed',
        Flag=CacheFlag.CACHE_SPEED,
        Trinket=TrinketType.TRINKET_GOAT_HOOF,
        Value=0.15,
        CalcFun=function(baseVal,newVal,trinketVal,trinketNum)
            return (newVal - baseVal) / (trinketVal * trinketNum)
        end},
    ['damage'] = {
        StatName='Damage',
        Flag=CacheFlag.CACHE_DAMAGE,
        Trinket=TrinketType.TRINKET_CURVED_HORN,
        Value=2.00,
        CalcFun=function(baseVal,newVal,trinketVal,trinketNum)
            return (newVal - baseVal) / (trinketVal * trinketNum)
        end},
    ['tears'] = {
        StatName='MaxFireDelay',
        Flag=CacheFlag.CACHE_FIREDELAY,
        Trinket=TrinketType.TRINKET_CANCER,
        Value=1.00,
        CalcFun=function(baseVal,newVal,trinketVal,trinketNum)
            return 30/(trinketVal * trinketNum)*(1/(newVal+1) - 1/(baseVal+1))
        end},
    ['range'] = {
        StatName='TearRange',
        Flag=CacheFlag.CACHE_RANGE,
        Trinket=TrinketType.TRINKET_TAPE_WORM,
        Value=3.00,
        CalcFun=function(baseVal,newVal,trinketVal,trinketNum)
            return (newVal - baseVal) / (40 * trinketVal * trinketNum)
        end},
    ['shotspeed'] = {
        StatName='ShotSpeed',
        Flag=CacheFlag.CACHE_SHOTSPEED,
        Trinket=TrinketType.TRINKET_WHIP_WORM,
        Value=0.50,
        CalcFun=function(baseVal,newVal,trinketVal,trinketNum)
            return (newVal - baseVal) / (trinketVal * trinketNum)
        end},
    ['luck'] = {
        StatName='Luck',
        Flag=CacheFlag.CACHE_LUCK,
        Trinket=TrinketType.TRINKET_LUCKY_TOE,
        Value=1.00,
        CalcFun=function(baseVal,newVal,trinketVal,trinketNum)
            return (newVal - baseVal) / (trinketVal * trinketNum)
        end},
}
function StatsMult:GetTrinketData(statStr)
    statStr = string.lower(tostring(statStr))
    statStr = string.gsub(statStr,' ','')
    local data = self.Name_StatName_CacheFlag_Trinket_Value_CalcFun[statStr]
    assert(data, "Stat '"..statStr.."' is not defined.")
    return data
end

function StatsMult:GetStatMult(player, statStr)
    assert(player,'Player is required.')
    assert(not player:HasCurseMistEffect(), 'Cannot get multiplier with Curse Mist.')

    local trinketData = self:GetTrinketData(statStr)
    local statName = trinketData.StatName
    local flag = trinketData.Flag
    local trinket = trinketData.Trinket
    local value = trinketData.Value
    local calcFun = trinketData.CalcFun
    
    local trinket1 = player:GetTrinket(0)
    local trinket2 = player:GetTrinket(1)
    local trinketNull = TrinketType.TRINKET_NULL
    if trinket1 ~= trinketNull or trinket2 ~= trinketNull then
        player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER,
        UseFlag.USE_NOANIM
        |UseFlag.USE_NOCOSTUME
        |UseFlag.USE_ALLOWNONMAIN
        |UseFlag.USE_NOANNOUNCER
        |UseFlag.USE_CUSTOMVARDATA
        |UseFlag.USE_NOHUD
    )
    end

    local parent = player.Parent
    player.Parent = nil

    local baseStat
    local trinketNum = player:GetTrinketMultiplier(trinket)
    local function getBaseStat(mod, eplayer, cacheFlag)
        if GetPtrHash(eplayer) == GetPtrHash(player) and cacheFlag==flag then
            baseStat = eplayer[statName]
            mod:RemoveCallback(ModCallbacks.MC_EVALUATE_CACHE, getBaseStat)
        end
    end
    self:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, getBaseStat, flag)
    player:AddCacheFlags(flag)
    player:EvaluateItems()

    local newStat
    local trinketNumAfter
    local function getNewStat(mod, eplayer, cacheFlag)
        if GetPtrHash(eplayer) == GetPtrHash(player) and cacheFlag==flag then
            newStat = eplayer[statName]
            trinketNumAfter = eplayer:GetTrinketMultiplier(trinket)
            eplayer:TryRemoveTrinket(trinket)
            mod:RemoveCallback(ModCallbacks.MC_EVALUATE_CACHE, getNewStat)
            eplayer[statName] = baseStat
        end
    end
    self:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, getNewStat, flag)
    player:AddTrinket(trinket, false)
    player:AddCacheFlags(flag)
    player:EvaluateItems()
    
    if trinket1 ~= TrinketType.TRINKET_NULL then
        player:TryRemoveTrinket(trinket1)
        player:AddTrinket(trinket1, false)
    end
    if trinket2 ~= TrinketType.TRINKET_NULL then
        player:TryRemoveTrinket(trinket2)
        player:AddTrinket(trinket2, false)
    end
    player.Parent = parent
    player:AddCacheFlags(flag)
    player:EvaluateItems()

    local statMult = calcFun(baseStat, newStat, value, trinketNumAfter - trinketNum)

    return statMult
end

-----------------------------------------------------------------------------------------
StatsMultiplier = {}
setmetatable(StatsMultiplier, {
    __index = function(t,k)return StatsMult[k]end,
    __newindex = function(t, k, v)
        error("Attempt to modify read-only table", 2)
    end,
    __tostring = function()return 'StatsMultiplier v'..StatsMult.Version..' - Keye3Tuido\n' end,
    __metatable = "This metatable is locked"
})
Isaac.ConsoleOutput(tostring(StatsMultiplier))


-- -- Debug: Render stat multipliers under player
-- StatsMultiplier:AddPriorityCallback(ModCallbacks.MC_POST_PLAYER_RENDER,CallbackPriority.LATE, function(self, player, offset)
--     local pos=offset+Isaac.WorldToRenderPosition(player.Position+player.PositionOffset)
--     local i=0
--     for k,v in pairs(self.Name_StatName_CacheFlag_Trinket_Value_CalcFun) do
--         local mult = self:GetStatMult(player, k)
--         local text = string.format("%s:%.2f", k, mult)
--         local textWidth = Isaac.GetTextWidth(text)
--         Isaac.RenderText(text, pos.X-textWidth/2, pos.Y+10*i, 1, 1, 1, 1)
--         i = i + 1
--     end
-- end)