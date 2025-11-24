local Windows = GameMain:GetMod("Windows");--先注册一个新的MOD模块
local OrphanageWindow = Windows:CreateWindow("OrphanageWindow");

function OrphanageWindow:OnInit()
    -- 修复：使用self.window而不是OrphanageWindow.window
    self.window.contentPane = UIPackage.CreateObject("Orphanage", "OrphanageWindow");--载入UI包里的窗口
    self.window.closeButton = self:GetChild("frame"):GetChild("n5");
    
    -- 修复：使用self.List而不是OrphanageWindow.List
    self.List = self:GetChild("n2");
    self.List.onClickItem:Add(self.onClickItem);
    
    -- 修复：使用self.Refresh而不是OrphanageWindow.Refresh
    self:GetChild("n3").onClick:Add(self.Refresh);
    self.window:Center();
end

function OrphanageWindow:OnEnter()
end

function OrphanageWindow:OnShowUpdate()
    self.isShowing = true;  -- 修复：使用self.isShowing
    --self:UpdateData();
end

function OrphanageWindow:OnShown()
    self.isShowing = true;  -- 修复：使用self.isShowing
    self:Refresh();  -- 修复：使用self:Refresh()
end

function OrphanageWindow:OnUpdate()
end

function OrphanageWindow:OnHide()
    self.isShowing = false;  -- 修复：使用self.isShowing
end

function OrphanageWindow:onClickItem(Context)  -- 修复：改为成员函数
    local Infant = Context.data;
    if XChat then
        XChat:SendMsg2("GetAdopter", Infant.name);
    end
end

function OrphanageWindow:Refresh()  -- 修复：改为成员函数
    if not self.List then return end  -- 修复：添加安全检查
    
    self.List:RemoveChildrenToPool();
    self.List:AddItemFromPool("ui://t11thi1orw7u4");
    
    if XChat then
        XChat:SendMsg2("GetAdopterList", "{}");
    end
end

function OrphanageWindow:UpdateAdopterList(RawData)
    -- 修复：添加参数验证和安全检查
    if not self.List or not RawData or RawData == "" then
        return
    end
    
    --RawData示例：[[{{ID="81130", From="我是院长", InfantName="申盼夏凤", tooltips="<font color='#f00f17'>来自【鸽子洞】的门派弃婴...</font>"}}]]
    
    self.List:RemoveChildrenToPool();
    self.List:AddItemFromPool("ui://t11thi1orw7u4");
    
    -- 修复：更安全的JSON解析方式
    local success, AdopterList = pcall(function()
        -- 假设RawData是Lua表格式的字符串
        local func, err = load("return "..RawData)
        if not func then
            error("JSON解析错误: "..tostring(err))
        end
        return func()
    end)
    
    if not success or type(AdopterList) ~= "table" then
        print("孤儿院数据解析失败:", RawData)
        return
    end
    
    for i = 1, #AdopterList do
        local item = self.List:AddItemFromPool();
        if item and AdopterList[i] then
            item.name = tostring(AdopterList[i].ID or "")
            
            -- 修复：添加空值检查
            local fromText = self:GetChild("From")
            local nameText = self:GetChild("InfantName")
            
            if fromText then
                fromText.text = tostring(AdopterList[i].From or "未知来源")
            end
            if nameText then
                nameText.text = tostring(AdopterList[i].InfantName or "未知婴儿")
            end
            
            -- 直接使用tooltips文本
            item.tooltips = tostring(AdopterList[i].tooltips or "")
        end
    end
end

-- 修复：添加XChat消息处理函数
function OrphanageWindow:OnReceiveMsg(msgType, data)
    if msgType == "AdopterList" then
        self:UpdateAdopterList(data)
    end
end