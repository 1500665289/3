--真凰炽焰
local tbTable = GameMain:GetMod("_ModifierScript")
local tbModifier = tbTable:GetModifier("Modifier_ZhenHuangChiYan")


local RATE = 0.02 --每次攻击敌人造成固定的灵气百分比伤害。

--注意：自定义modidifer要注意离开的时候将自定义效果移除
--进入modifier
function tbModifier:Enter(modifier, npc)
  self:Register(modifier, npc)
end

--modifier step
function tbModifier:Step(modifier, npc, dt)
  if npc.IsDisciple then --仅外门弟子装备有效。
    npc:RemoveModifier("Modifier_ZhenHuangChiYan")
  end
end

--层数更新
function tbModifier:UpdateStack(modifier, npc, add)
	
end

--离开modifier
function tbModifier:Leave(modifier, npc)
  self:Unregister(modifier, npc)
end

--获取存档数据
function tbModifier:OnGetSaveData()
	return nil
end

--载入存档数据
function tbModifier:OnLoadData(modifier, npc, tbData)

end

--注册事件。
function tbModifier:Register(modifier, npc)
  GameMain:GetMod("_Event"):RegisterEvent(g_emEvent.WillFightBodyBeHit, self.CallBack, {name = "Modifier_ZhenHuangChiYan", ID = npc.ID})
end

--反注册事件。
function tbModifier:Unregister(modifier, npc)
  GameMain:GetMod("_Event"):UnRegisterEvent(g_emEvent.WillFightBodyBeHit, {name = "Modifier_ZhenHuangChiYan", ID = npc.ID})
end

function tbModifier.CallBack(data, thing, objs)
  local from = objs[2]
  local target = thing
  if from and target and from.ID == data.ID then
    local target_ling = target.MaxLing * RATE
    target:AddLing(-target_ling)
  end
end