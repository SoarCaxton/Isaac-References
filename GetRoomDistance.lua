local RoomShape_Slot2IndexOffset = {
    [RoomShape.ROOMSHAPE_1x1]={
        [DoorSlot.LEFT0] = {x=-1, y=0},
        [DoorSlot.UP0] = {x=0, y=-1},
        [DoorSlot.RIGHT0] = {x=1, y=0},
        [DoorSlot.DOWN0] = {x=0, y=1},
    },
    [RoomShape.ROOMSHAPE_IH]={
        [DoorSlot.LEFT0] = {x=-1, y=0},
        [DoorSlot.RIGHT0] = {x=1, y=0},
    },
    [RoomShape.ROOMSHAPE_IV]={
        [DoorSlot.UP0] = {x=0, y=-1},
        [DoorSlot.DOWN0] = {x=0, y=1},
    },
    [RoomShape.ROOMSHAPE_1x2]={
        [DoorSlot.LEFT0] = {x=-1, y=0},
        [DoorSlot.UP0] = {x=0, y=-1},
        [DoorSlot.RIGHT0] = {x=1, y=0},
        [DoorSlot.DOWN0] = {x=0, y=2},
        [DoorSlot.LEFT1] = {x=-1, y=1},
        [DoorSlot.RIGHT1] = {x=1, y=1},
    },
    [RoomShape.ROOMSHAPE_IIV]={
        [DoorSlot.UP0] = {x=0, y=-1},
        [DoorSlot.DOWN0] = {x=0, y=2},
    },
    [RoomShape.ROOMSHAPE_2x1]={
        [DoorSlot.LEFT0] = {x=-1, y=0},
        [DoorSlot.UP0] = {x=0, y=-1},
        [DoorSlot.RIGHT0] = {x=2, y=0},
        [DoorSlot.DOWN0] = {x=0, y=1},
        [DoorSlot.UP1] = {x=1, y=-1},
        [DoorSlot.DOWN1] = {x=1, y=1}
    },
    [RoomShape.ROOMSHAPE_IIH]={
        [DoorSlot.LEFT0] = {x=-1, y=0},
        [DoorSlot.RIGHT0] = {x=2, y=0},
    },
    [RoomShape.ROOMSHAPE_2x2]={
        [DoorSlot.LEFT0] = {x=-1, y=0},
        [DoorSlot.UP0] = {x=0, y=-1},
        [DoorSlot.RIGHT0] = {x=2, y=0},
        [DoorSlot.DOWN0] = {x=0, y=2},
        [DoorSlot.LEFT1] = {x=-1, y=1},
        [DoorSlot.UP1] = {x=1, y=-1},
        [DoorSlot.RIGHT1] = {x=2, y=1},
        [DoorSlot.DOWN1] = {x=1, y=2}
    },
    [RoomShape.ROOMSHAPE_LTL]={
        [DoorSlot.LEFT0] = {x=-1, y=0},
        [DoorSlot.UP0] = {x=-1, y=0},
        [DoorSlot.RIGHT0] = {x=1, y=0},
        [DoorSlot.DOWN0] = {x=-1, y=2},
        [DoorSlot.LEFT1] = {x=-2, y=1},
        [DoorSlot.UP1] = {x=0, y=-1},
        [DoorSlot.RIGHT1] = {x=1, y=1},
        [DoorSlot.DOWN1] = {x=0, y=2}
    },
    [RoomShape.ROOMSHAPE_LTR]={
        [DoorSlot.LEFT0] = {x=-1, y=0},
        [DoorSlot.UP0] = {x=0, y=-1},
        [DoorSlot.RIGHT0] = {x=1, y=0},
        [DoorSlot.DOWN0] = {x=0, y=2},
        [DoorSlot.LEFT1] = {x=-1, y=1},
        [DoorSlot.UP1] = {x=1, y=0},
        [DoorSlot.RIGHT1] = {x=2, y=1},
        [DoorSlot.DOWN1] = {x=1, y=2}
    },
    [RoomShape.ROOMSHAPE_LBL]={
        [DoorSlot.LEFT0] = {x=-1, y=0},
        [DoorSlot.UP0] = {x=0, y=-1},
        [DoorSlot.RIGHT0] = {x=2, y=0},
        [DoorSlot.DOWN0] = {x=0, y=1},
        [DoorSlot.LEFT1] = {x=0, y=1},
        [DoorSlot.UP1] = {x=1, y=-1},
        [DoorSlot.RIGHT1] = {x=2, y=1},
        [DoorSlot.DOWN1] = {x=1, y=2}
    },
    [RoomShape.ROOMSHAPE_LBR]={
        [DoorSlot.LEFT0] = {x=-1, y=0},
        [DoorSlot.UP0] = {x=0, y=-1},
        [DoorSlot.RIGHT0] = {x=2, y=0},
        [DoorSlot.DOWN0] = {x=0, y=2},
        [DoorSlot.LEFT1] = {x=-1, y=1},
        [DoorSlot.UP1] = {x=1, y=-1},
        [DoorSlot.RIGHT1] = {x=1, y=1},
        [DoorSlot.DOWN1] = {x=1, y=1}
    }
}

Room_Slot2SafeGridIndex = function(room, doorSlot)
    local safeGridIndex, roomShape = room.SafeGridIndex, room.Data.Shape
    local x,y = safeGridIndex % 13, safeGridIndex // 13
    local offset = RoomShape_Slot2IndexOffset[roomShape][doorSlot]
    if offset then
        x, y = x + offset.x, y + offset.y
        if x >= 0 and x < 13 and y >= 0 and y < 13 then
            local targetIndex = y * 13 + x
            local targetRoom = Game():GetLevel():GetRoomByIdx(targetIndex)
            return targetRoom and targetRoom.SafeGridIndex
        end
    end
end