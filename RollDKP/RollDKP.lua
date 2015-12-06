roll_dkp = false

-- register event for receive DKP from DKP master
  local rolldkp_frame = CreateFrame('Frame')
  rolldkp_frame:RegisterEvent('CHAT_MSG_WHISPER')

-- roll DKP when my current DKP is received
  rolldkp_frame:SetScript('OnEvent',
    function(self, event, ...)
      if roll_dkp then
        local wmessage = ...
        if string.find(wmessage, 'WebDKP') then
          if string.find(wmessage, 'Current DKP') then
            my_current_DKP = string.match(wmessage, '%d+')
            RandomRoll(tonumber(my_current_DKP) * rolldkp_scale_factor_min,
                       tonumber(my_current_DKP) * rolldkp_scale_factor_max)
          end
        else
          print('Cannot get my current DKP from DKP master.')
        end
        roll_dkp = false
      end
    end)

-- slash command handler
  local function rolldkp_slash_cmd_handler(msg, editbox)

    local dkp_master, min, max = msg:match("^(%S+)%s+(%d+)%s*-%s*(%d+)")

    -- set min
    if min then
      rolldkp_scale_factor_min = tonumber(min)
    else
      rolldkp_scale_factor_min = 7
    end

    -- set max
    if max then
      rolldkp_scale_factor_max = tonumber(max)
    else
      rolldkp_scale_factor_max = 10
    end

    print('I will roll DKP * ' .. rolldkp_scale_factor_min .. ' to DKP * ' .. rolldkp_scale_factor_max .. '.')

    -- whisper dkp master
    if dkp_master then
      local whisper_target = Ambiguate(dkp_master, 'all')
      if whisper_target then
        roll_dkp = true
        SendChatMessage('!dkp', 'WHISPER', nil, whisper_target)
      else
        print('Cannot find DKP master: ' .. dkp_master .. '.')
      end
    else
      print('DKP master is not provided. Example: /rolldkp dkpmaster 7-10')
    end
  end

-- Slash command
  SLASH_ROLLDKP1 = '/rolldkp'
  SlashCmdList['ROLLDKP'] = rolldkp_slash_cmd_handler
