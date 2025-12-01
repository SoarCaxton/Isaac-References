-- 辅助数组
-- nil表示对应槽位不存在门
local RoomShape={
    {0,1,2,28},
    {0,nil,2,nil},
    {nil,1,nil,28},
    {0,1,2,55,27,nil,29,nil},
    {nil,1,nil,55},
    {0,1,4,28,nil,3,nil,30},
    {0,nil,4,nil},
    {0,1,4,55,27,3,31,57},
    {2,28,4,55,27,3,31,57},
    {0,1,2,55,27,30,31,57},
    {0,1,4,28,29,3,31,57},
    {0,1,4,55,27,3,29,30}
}

-- 函数功能：根据房间Index、Shape、DoorSlot、Dimension，确定该门在当前层的唯一编号
-- 参数说明：
-- CurrentRoomIndex取SafeGridIndex
-- CurrentRoomShape取值范围1~12(参考Enum "RoomShape")
-- DoorSlot取值范围0~7(参考Enum "DoorSlot")
-- Dimension取值范围0~2，分别代表主维度0、第二维度（镜像世界、矿洞逃亡）1、死亡证明维度2
function GetDoorId(CurrentRoomIndex,CurrentRoomShape,DoorSlot,Dimension)    -- Dimension=0,1,2
    if not Dimension or Dimension<0 then Dimension=0 end    -- 默认为主维度
    return 2*(CurrentRoomIndex%13) + 27*(CurrentRoomIndex//13) + RoomShape[CurrentRoomShape][DoorSlot+1] + Dimension*1e3
end
