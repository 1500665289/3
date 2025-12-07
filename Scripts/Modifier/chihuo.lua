--吃货丹
local tbTable = GameMain:GetMod("_ModifierScript")
local tbModifier = tbTable:GetModifier("modifier_chihuo")
local ZhiYaoZhuo = GameMain:GetMod("ZhiYaoZhuo")

--注意：自定义modidifer要注意离开的时候将自定义效果移除
--进入modifier
function tbModifier:Enter(modifier, npc)
  local long = GameUlt.CallBoss("Boss_Long", nil, nil, false)
  if CS.XiaWorld.FightMapMgr.MainMap and CS.XiaWorld.FightMapMgr.Instance.MapSchool > 0 then
    self.long = long
    long:SetCamp(g_emFightCamp.Friend)
    CS.XiaWorld.FightMapMgr.Instance:BeginSchoolAttack(long)
  end
  if modifier.Scale > 1 then
    long:AddModifier("Boss_Qianghua", modifier.Scale)
    long:AddLing(long.MaxLing - long.LingV)
    for k,v in pairs(long.FightParts) do
      local npc = ThingMgr:FindThingByID(v.ID)
      if npc then
        npc:AddModifier("Boss_Qianghua_Part", modifier.Scale)
        npc:AddLing(npc.MaxLing - npc.LingV)
      end
    end
  end
  if modifier.Scale > 10 then --强化超过10倍（12淬以上），则添加额外掉落品。掉落率跟强化次数有关。
    ZhiYaoZhuo.AddDrop(npc.Key, "Item_CangLongHanXing", "苍龙寒星衫", 1, 12, math.max(0.001 * modifier.Scale, 1))
  end
end

--modifier step
function tbModifier:Step(modifier, npc, dt)
  if CS.XiaWorld.FightMapMgr.Instance.MapSchool == 0 then --在自己家或者野外，则正常删除这个modifier，因为可以自己杀。
    npc:RemoveModifier("Dan_ChiHuo")
  end
  --如果对方门派投降，则为了防止人物不能离开，我们自动杀死龙。
  if CS.XiaWorld.FightMapMgr.MainMap and CS.XiaWorld.FightMapMgr.Instance.MapSchool > 0 and CS.XiaWorld.FightMapMgr.MainMap.Submission then
    npc:RemoveModifier("Dan_ChiHuo")
    self.long:DoDeath()
  end
end

--层数更新
function tbModifier:UpdateStack(modifier, npc, add)
	
end

--离开modifier
function tbModifier:Leave(modifier, npc)

end

--获取存档数据
function tbModifier:OnGetSaveData()
	return nil
end

--载入存档数据
function tbModifier:OnLoadData(modifier, npc, tbData)

end

