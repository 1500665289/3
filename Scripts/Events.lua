local ZhiYaoZhuo = GameMain:NewMod("ZhiYaoZhuo")
ZhiYaoZhuo.Events = ZhiYaoZhuo.Events or {}
local Events = ZhiYaoZhuo.Events

function Events.HandleAddEnemies(data, thing, objs)
  local npcs = objs[0]
  local powerlevel = objs[1]
  local basescore = CS.XiaWorld.SchoolMgr.Instance.BaseScore
  for _,npc in pairs(npcs) do
    --如果来犯敌人强度超过8，则开始来真仙，并且我们根据声望来对敌人直接增强，无视游戏原规则。
    if basescore >= 8000 and npc.PropertyMgr and npc.PropertyMgr.Practice then
      --首先，相比8000来说，每多1000声望，我们增加一次真仙劫。8000的渡劫数为1。
      local god_count = math.floor((basescore - 7000) / 1000)
      print("the enemy power is: ", god_count)
      npc.PropertyMgr.Practice:AddGodCount(god_count)
      npc:AddModifier("Gong_Thunder3", god_count)
      
      --其次，如果声望超过1W，则每多1000声望，我们提升10+10%的法宝威力，以及10%的击退抵抗和击退值。
      if basescore >= 100000 then
        local add_count = math.floor((basescore - 10000) / 1000)
        local fabaos = npc.Equip:FindFabao()
        for _,fabao in pairs(fabaos) do
          local cur_atk = fabao.Fabao:GetProperty(CS.XiaWorld.Fight.g_emFaBaoP.AttackPower)
          local cur_kb = fabao.Fabao:GetProperty(CS.XiaWorld.Fight.g_emFaBaoP.KnockBackAddition)
          local cur_kbr = fabao.Fabao:GetProperty(CS.XiaWorld.Fight.g_emFaBaoP.KnockBackResistance)
          
          fabao.Fabao:SetProperty(CS.XiaWorld.Fight.g_emFaBaoP.AttackPower, (cur_atk + 10 * add_count) * (1 + 0.1 * add_count))
          fabao.Fabao:SetProperty(CS.XiaWorld.Fight.g_emFaBaoP.KnockBackAddition, cur_kb + 0.1 * add_count)
          fabao.Fabao:SetProperty(CS.XiaWorld.Fight.g_emFaBaoP.KnockBackResistance, cur_kbr + 0.1 * add_count)
        end
      end
    end
    
    --最后我们把灵气和法宝灵气全部补满。
    npc:AddLing(npc.MaxLing)
    local fabaos = npc.Equip:FindFabao()
    for _,fabao in pairs(fabaos) do
      fabao:AddLing(fabao.MaxLing)
    end
  end
end