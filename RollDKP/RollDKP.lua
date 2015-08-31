rolldkp_version = '2014.12.19'

-- handler functions can be placed before others
  local function dkp_master_input_text_changed(self, items)
    local new_name = self:GetText()
    if (new_name ~= '') then
      for _, v in ipairs(items) do v:Enable() end
    else
      for _, v in ipairs(items) do v:Disable() end
    end
  end

-- Main function

  local function get_my_dkp(msg, editbox)
    SendChatMessage('!dkp', 'WHISPER', nil, current_dkp_master)
  end

  local function set_dkp_master(msg, editbox)
    dkp_master = msg
    print('DKP master is set to ' .. msg)
  end

  local rolldkp_frame = CreateFrame('Frame')
  rolldkp_frame:RegisterEvent('CHAT_MSG_WHISPER')
  rolldkp_frame:SetScript('OnEvent',
    function(self, event, ...)
      local wmessage = ...
      if (string.find(wmessage, 'Current DKP') ~= nil) then
        a = string.match(wmessage, '%d+')
        RandomRoll(tonumber(a) * 5, tonumber(a) * 10)
      end
    end)

-- Slash commands

  SLASH_ROLLDKP1 = '/rolldkp'
  SLASH_SETDKPMASTER1 = '/dkpmaster'
  SlashCmdList['ROLLDKP'] = get_my_dkp
  SlashCmdList['SETDKPMASTER'] = set_dkp_master

-- Option frame: Root
  local rolldkp = CreateFrame( 'Frame', 'RollDKPOptions',
    InterfaceOptionsFramePanelContainer )
  rolldkp:Hide()
  rolldkp.name = 'RollDKP'
  InterfaceOptions_AddCategory( rolldkp )

  -- title
  local title = rolldkp:CreateFontString( nil, 'ARTWORK', 'GameFontNormalLarge' )
  title:SetPoint( 'TOPLEFT', 16, -16 )
  title:SetText( 'RollDKP ' .. rolldkp_version )

  -- DKP master name
  local dkp_master_label = rolldkp:CreateFontString( nil,
    'ARTWORK', 'GameFontDisableSmall' )
  dkp_master_label:SetPoint( 'TOPLEFT', title, 'BOTTOMLEFT', 0, -20 )
  dkp_master_label:SetText( 'Current DKP master: ' )
  dkp_master_label:SetTextColor(0.9, 0.9, 0.9)

  local dkp_master_big_name = rolldkp:CreateFontString( nil,
    'ARTWORK', 'GameFontNormalHuge' )
  dkp_master_big_name:SetPoint( 'LEFT', dkp_master_label, 'RIGHT', 16, 0 )
  dkp_master_big_name:SetText( current_dkp_master )

-- Option frame: DKP master name
  -- root frame
    local dkp_master = CreateFrame( 'Frame', 'RollDKPOptionsDKPMasterPanel',
      rolldkp,'OptionsBoxTemplate' )
    dkp_master:SetPoint( 'TOPLEFT', dkp_master_label, 'BOTTOMLEFT', 0, -20 )
    dkp_master:SetSize( 512, 68 )

  -- label: change DKP master name
    local change_dkp_master_label = dkp_master:CreateFontString( nil,
      'ARTWORK', 'GameFontDisableSmall' )
    change_dkp_master_label:SetPoint( 'TOPLEFT', 16, -16 )
    change_dkp_master_label:SetText( 'Change DKP master to: ' )
    change_dkp_master_label:SetTextColor(0.9, 0.9, 0.9)

  -- input box
    local dkp_master_input = CreateFrame( 'EditBox', 'DKPMasterNameInput',
      dkp_master, 'InputBoxTemplate' )
    dkp_master_input:SetPoint( 'TOPLEFT', change_dkp_master_label, 'TOPRIGHT', 16, 8 )
    dkp_master_input:SetSize( 256, 24 )
    dkp_master_input:SetAutoFocus(false)
    dkp_master_input:SetScript('OnEscapePressed', function(self)
      -- local Parent = frame:GetParent()
      self:ClearFocus()
      end)

  -- confirm button
    local confirm_button = CreateFrame( 'Button', nil,
      dkp_master, 'UIPanelButtonTemplate')
    confirm_button:SetText( 'Confirm' )
    confirm_button:SetSize( 64, 26 )
    confirm_button:SetPoint( 'TOPLEFT', dkp_master_input, 'TOPRIGHT', 16, 0 )
    confirm_button:Disable()

  -- status
    local change_dkp_master_status = dkp_master:CreateFontString( nil,
      'ARTWORK', 'GameFontDisableSmall' )
    change_dkp_master_status:SetPoint( 'TOPLEFT', change_dkp_master_label, 'BOTTOMLEFT', 0, -16 )

  -- play with the buttons
    local function renew_dkp_master()
      current_dkp_master = dkp_master_input:GetText()
      change_dkp_master_status:SetText('Current DKP master set to '
        .. current_dkp_master)
      dkp_master_big_name:SetText(current_dkp_master)
      dkp_master_input:SetText('')
      dkp_master_input:ClearFocus()
    end

    local function renew_dkp_master_check(item)
      if item:IsEnabled() then renew_dkp_master() end
      item:Disable()
    end

    confirm_button:SetScript('OnClick', function(self)
      renew_dkp_master_check(confirm_button) end)

    dkp_master_input:SetScript('OnEnterPressed', function(self)
      renew_dkp_master_check(confirm_button) end)

    dkp_master_input:SetScript('OnTextChanged', function(self)
      dkp_master_input_text_changed(self, {confirm_button})
    end)

-- Load current DKP master
  local frame = CreateFrame('FRAME')
  frame:RegisterEvent('ADDON_LOADED')
  frame:SetScript('OnEvent', function (self, event, name)
    if event == 'ADDON_LOADED' and name == 'Rolldkp' then
      if current_dkp_master == nil then
        current_dkp_master = 'viita'
        print('RollDKP: current dkp master is set to default:' .. 'viita')
      end
      dkp_master_big_name:SetText( current_dkp_master )
    end
  end)
