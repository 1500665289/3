--以下内容请不要修改。
local ZhiYaoZhuo = GameMain:NewMod("ZhiYaoZhuo")


function ZhiYaoZhuo:OnInit()
  --将NPC的灵气上限、法宝强度、术法强度全部改为100倍。
  local maxling = CS.XiaWorld.PropertyMgr.Instance:GetDef("NpcLingMaxValue")
  local fabaopower = CS.XiaWorld.PropertyMgr.Instance:GetDef("NpcFight_FabaoPowerAddP")
  local spellpower = CS.XiaWorld.PropertyMgr.Instance:GetDef("NpcFight_SpellPowerAddP")
  maxling.MaxValue = maxling.MaxValue * 100
  fabaopower.MaxValue = maxling.MaxValue * 100
  spellpower.MaxValue = maxling.MaxValue * 100
end

function ZhiYaoZhuo:OnEnter()  
  --注册敌人增强事件。
  GameMain:GetMod("_Event"):RegisterEvent(CS.XiaWorld.g_emEvent.AddEnemies, self.Events.HandleAddEnemies, "ZhiYaoZhuo_HandleAddEnemies")
  
  --由于游戏不会在读档的时候重新运行modifier的Enter方法，因此我们需要遍历地图上所有有真凰炽焰BUFF的NPC，并且重新帮他们注册相应事件。
  local npcs = Map.Things:GetActiveNpcs()
  for _, npc in pairs(npcs) do
    local modif = npc.PropertyMgr:FindModifier("Modifier_ZhenHuangChiYan")
    if modif and modif.helper then
      modif.helper:GetTable():Register(modif, npc)
    end
  end
end

function ZhiYaoZhuo:OnSetHotKey()

end

function ZhiYaoZhuo:OnHotKey(ID,state)

end

function ZhiYaoZhuo:OnStep(dt)

end

function ZhiYaoZhuo:OnLeave()

end

function ZhiYaoZhuo:OnSave()

end

function ZhiYaoZhuo:OnLoad(tbLoad)

end

function ZhiYaoZhuo.AddDrop(key, itemname, name, count, rate, chance)
  if CS.XiaWorld.World.RandomRate(chance) then
    item = ItemRandomMachine.RandomItem(itemname, nil, 0, 12, 1, count)
    item.Rate = rate
    if name then
      item:SetName(name)
    end
    ThingMgr:AddThing(item)
    Map:DropItem(item, key)
  end
end

function ZhiYaoZhuo.deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[ZhiYaoZhuo.deepcopy(orig_key)] = ZhiYaoZhuo.deepcopy(orig_value)
        end
        setmetatable(copy, ZhiYaoZhuo.deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end