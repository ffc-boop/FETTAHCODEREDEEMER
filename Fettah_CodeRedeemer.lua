--[[
    Fettah - Roblox Code Redeemer
    ---------------------------------------------------------------
    Automatically captures, extracts and redeems in-game codes.
    Features: live feed, spam mode, auto-buy, anti-ragdoll, duo
    support and an in-game settings panel.

    Clean, readable rewrite. No third-party advertising.
]]
local ReplicatedStorage, UserInputService, localPlayer, playerGui, net, RunService, player, hud, keyboardEnabled, isTouch
local computeUiScale, uiScale, map, max, wordMode, retryDelay, isListening, autoRedeem, autoType, manual
local isSpamming, thread, attemptCount, wordLimit, listenKey, redeemKey, pendingBind, map2, lastCode, notifyRemote, codeSpaces
local autoStarted, autoListen, spamOnListen, ignoreSystem, handleAnnouncement, startAutoBuy, stopAutoBuy, stripTags, trimText, copyText
local splitWords, extractCode, extractCodeFromMessage, findNotifyRemote, setCodeBoxText, submitCode, map3, map4, gothamMedium, gothamBold
local gothamBlack, create, addCorner, addStroke, tween, makeLabel, makeWindow, makeButton, makeAccentButton, ScreenGui
local Main, Frame, Rag, testButton, feedButton, windowHeight, statusLabel, setStatus, TextBox, copyButton
local clear, redeem, addToggle, listen, Frame2, Frame3, TextButton, listenKeyButton, clearListenButton, redeemKeyButton
local clearRedeemButton, spamRowStroke, spamLabel, start, spamDot, openSettings
local theme, lang, themePresets, themeKey, themeStroke, themeGradient, themeAccent, themeColor, applyTheme
local applyLang, LANG, EN2KEY, t, translate, registerLang, langRef
do  
	local visible, showKeybinds, setWordsRowVisible, Settings, Frame4, Frame5, words
	do
		local speeds, Frame6
		do
			do
				local value3
				do
					do
						local getupvalues_, getconnections_, setupvalue_  
						do
							do
								local writeClipboard
								do
									do
										local safeRef = cloneref or function(arg)
											return arg
										end
										local value4 = safeRef(game:GetService("Players"))
										ReplicatedStorage = safeRef(game:GetService("ReplicatedStorage"))  
										UserInputService = safeRef(game:GetService("UserInputService"))
										value3 = safeRef(game:GetService("TweenService"))
										localPlayer = value4.LocalPlayer
										playerGui = localPlayer:WaitForChild("PlayerGui")
										net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")
										RunService = safeRef(game:GetService("RunService"))
									end
									do
										player = localPlayer
										hud = playerGui  
										getupvalues_ = debug and debug.getupvalues or getupvalues
										do
											local value4 = getconnections
											if value4 then
												getconnections_ = value4
											else
												getconnections_ = debug and debug.getconnections
											end
										end  
									end
									setupvalue_ = debug and debug.setupvalue or setupvalue
									do
										local value4 = setclipboard or toclipboard
										if value4 then
											writeClipboard = value4
										else
											writeClipboard = syn and syn.write_clipboard
										end
									end  
								end
								do
									keyboardEnabled = UserInputService.KeyboardEnabled
									isTouch = UserInputService.TouchEnabled and not keyboardEnabled
									computeUiScale = function()
										if not isTouch then
											return 1
										end
										local currentCamera = workspace.CurrentCamera  
										currentCamera = currentCamera and currentCamera.ViewportSize.Y or 600
										local uiSize = _G.__RdmCfgStr and _G.__RdmCfgStr("uiSize", "MEDIUM") or "MEDIUM"
										local text2 = uiSize == "BIG" and 1.15 or uiSize == "SMALL" and 0.8 or 1
										return math.clamp(currentCamera * 0.88 / 548, 0.5, 1.3) * text2
									end
									uiScale = computeUiScale()
									do
										local map5 = {}
										if readfile and isfile then
											local ok, result = pcall(function()  
												if isfile("fettah_settings.txt") then
													return readfile("fettah_settings.txt")
												end
											end)
											if ok and type(result) == "string" then
												for match in result:gmatch("[^\n]+") do
													local match2, value4 = match:match("^(%w+)=(.*)$")
													if match2 then
														map5[match2] = value4  
													end
												end
											end
										end
										_G.__RdmCfgBool = function(arg, arg2)
											local value4 = map5[arg]
											if value4 == "1" then
												return true
											end
											if value4 == "0" then  
												return false
											end
											return arg2
										end
										_G.__RdmCfgStr = function(arg, arg2)
											local value4 = map5[arg]
											local text2 = "string"
											return type(value4) == text2 and value4 ~= "" and value4 or arg2
										end
										_G.__RdmCfgSet = function(arg, arg2)  
											map5[arg] = type(arg2) == "boolean" and (arg2 and "1" or "0") or tostring(arg2)
											if not writefile then
												return
											end
											local settingsLines = {}
											for k, value4 in pairs(map5) do
												settingsLines[#settingsLines + 1] = k .. "=" .. tostring(value4)
											end
											table.sort(settingsLines)  
											pcall(writefile, "fettah_settings.txt", table.concat(settingsLines, "\n"))
										end
									end
								end
								do
									map = {
										listenKey = Enum.KeyCode.F,
										maxFeed = 36,
									}
									speeds = { MAX = 0.15 }  
									max = speeds[_G.__RdmCfgStr("speed", "MAX")] or speeds.MAX
									wordMode = _G.__RdmCfgBool("wordMode", false)
									retryDelay = 0.25
									isListening = false
									autoRedeem = _G.__RdmCfgBool("autoRedeem", true)
									autoType = _G.__RdmCfgBool("autoType", true)
									manual = _G.__RdmCfgBool("manual", false)
									isSpamming = false
									thread = nil  
									attemptCount = 0
									wordLimit = 1
									codeSpaces = _G.__RdmCfgBool("codeSpaces", false)
									listenKey = map.listenKey
									redeemKey = Enum.KeyCode.G
									pendingBind = nil
									map2 = {}
									lastCode = nil
									notifyRemote = nil
									autoStarted = false
									autoListen = _G.__RdmCfgBool("autoListen", true)  
									spamOnListen = _G.__RdmCfgBool("spamOnListen", true)
									showKeybinds = _G.__RdmCfgBool("showKeybinds", keyboardEnabled)
									ignoreSystem = _G.__RdmCfgBool("ignoreSystem", true)
									_G.__RdmDuo = _G.__RdmCfgBool("duo", false)
									theme = _G.__RdmCfgStr("theme", "TEAL")
									lang = _G.__RdmCfgStr("lang", "EN")
									LANG = {
										EN = {
											LISTEN = "LISTEN",
											LISTEN_KEY = "LISTEN KEY",
											REDEEM_KEY = "REDEEM KEY",
											CODE = "CODE",
											COPY = "COPY",
											CLEAR = "CLEAR",
											REDEEM = "REDEEM",
											WORDS = "WORDS",
											SPEED = "SPEED",
											SPAM = "SPAM",
											AUTO_REDEEM = "AUTO REDEEM",
											AUTO_TYPE = "AUTO TYPE",
											MANUAL = "MANUAL",
											AUTO_LISTEN = "AUTO LISTEN",
											SPAM_ON_LISTEN = "SPAM ON LISTEN",
											SHOW_KEYBINDS = "SHOW KEYBINDS",
											IGNORE_SYSTEM = "IGNORE SYSTEM PHRASES",
											DUO = "DUO MODE (WITH RIDDLER)",
											SETTINGS = "SETTINGS",
											LIVE_FEED = "LIVE FEED",
											AUTO_BUY = "AUTO BUY",
											ANTI_RAGDOLL = "ANTI RAGDOLL",
											FAKE_NOTIFY = "FAKE NOTIFY",
											UI_SIZE = "UI SIZE",
											MESSAGE = "MESSAGE",
											TEST_CODE = "TEST CODE",
											SEND = "SEND",
											THEME = "THEME",
											LANGUAGE = "LANGUAGE",
											SOUND = "UI SOUND",
											SPACES = "CODE SPACES",
										},
										TR = {
											LISTEN = "DİNLE",
											LISTEN_KEY = "DİNLE TUŞU",
											REDEEM_KEY = "REDEEM TUŞU",
											CODE = "KOD",
											COPY = "KOPYALA",
											CLEAR = "TEMİZLE",
											REDEEM = "REDEEM",
											WORDS = "KELİME",
											SPEED = "HIZ",
											SPAM = "SPAM",
											AUTO_REDEEM = "OTO REDEEM",
											AUTO_TYPE = "OTO YAZ",
											MANUAL = "MANUEL",
											AUTO_LISTEN = "OTO DİNLE",
											SPAM_ON_LISTEN = "DİNLEYİNCE SPAM",
											SHOW_KEYBINDS = "TUŞLARI GÖSTER",
											IGNORE_SYSTEM = "SİSTEM MESAJINI YOK SAY",
											DUO = "DUO (RIDDLER İLE)",
											SETTINGS = "AYARLAR",
											LIVE_FEED = "CANLI AKIŞ",
											AUTO_BUY = "OTO AL",
											ANTI_RAGDOLL = "ANTI RAGDOLL",
											FAKE_NOTIFY = "SAHTE BİLDİRİM",
											UI_SIZE = "ARAYÜZ BOYUTU",
											MESSAGE = "MESAJ",
											TEST_CODE = "TEST KOD",
											SEND = "GÖNDER",
											SOUND = "SES",
											SPACES = "KOD BOŞLUK",
											THEME = "TEMA",
											LANGUAGE = "DİL",
										},
									}
									EN2KEY = {}
									for k, v in pairs(LANG.EN) do
										EN2KEY[v] = k
									end
									t = function(key)
										local pack = LANG[lang] or LANG.EN
										return pack[key] or LANG.EN[key] or key
									end
									translate = function(text)
										local key = EN2KEY[text]
										if key then
											return t(key)
										end
										return text
									end
									langRef = {}
									registerLang = function(obj, text)
										if EN2KEY[text] then
											langRef[#langRef + 1] = { obj = obj, en = text }
										end
									end
									applyLang = function()
										for _, entry in ipairs(langRef) do
											local key = EN2KEY[entry.en]
											if key and entry.obj and entry.obj.Parent ~= nil then
												entry.obj.Text = t(key)
											end
										end
									end
									_G.__SabClassifyDrop = function(arg)
										local text2 = tostring(arg or "")
										local text3 = text2:lower()
										local map5 = {}
										for match in text2:gmatch("[%w']+") do  
											map5[#map5 + 1] = match
										end
										local value5 = #map5
										if value5 == 0 then
											return nil
										end
										local padded = " " .. text3:gsub("[^%w]", " ") .. " "
										if text3:find("?", 1, true) then
											return "riddle"
										end  
										for _, value4 in ipairs({
											" what ",
											" how ",
											" which ",
											" whose ",
											" when ",
											" who ",
											" whats ",
											" where ",  
											" why ",
											" guess ",
											" riddle ",
											" answer ",
										}) do
											if padded:find(value4, 1, true) then
												return "riddle"
											end
										end
										if padded:find(" my ", 1, true) then  
											return "riddle"
										end
										local cond = value5 >= 2
										local pos
										if cond then
											pos = padded:find(" plus ", 1, true) or text3:find("+", 1, true)
										else
											pos = cond
										end
										if pos then  
											return "riddle"
										end
										if value5 >= 4 and padded:find(" and ", 1, true) then
											return "riddle"
										end
										if text3:find("code", 1, true) then
											return "code"
										end
										for _, value4 in ipairs({ " redeem ", " type ", " enter ", " claim " }) do  
											if padded:find(value4, 1, true) then
												return "code"
											end
										end
										if value5 >= 7 then
											return "riddle"
										end
										if value5 == 1 then
											return "code"  
										end
										if value5 <= 3 then
											local num2 = 0
											for _, value6 in ipairs(map5) do
												if #value6 >= 3 and (value6 == value6:upper() and value6:match("%a") or value6:match("%d")) then
													num2 += 1
												end
											end
											if num2 == value5 then
												return "code"  
											end
										end
										return nil
									end
									handleAnnouncement = nil
									setWordsRowVisible = nil
									startAutoBuy = nil
									stopAutoBuy = nil
									stripTags = function(arg)  
										if type(arg) ~= "string" then
											return tostring(arg)
										end
										return (arg:gsub("<[^>]->", ""))
									end
									trimText = function(arg)
										return (arg or ""):gsub("^%s+", ""):gsub("%s+$", "")
									end
									copyText = function(arg)  
										if not writeClipboard then
											return false
										end
										return (pcall(writeClipboard, arg))
									end
									splitWords = function(arg)
										local map5 = {}
										for match in arg:gmatch("[%w_]+") do
											map5[#map5 + 1] = match
										end  
										return map5
									end
									extractCode = function(arg)
										local temp = nil
										for match in arg:gmatch("[%w_]+") do
											if #match >= 4 and match:match("%a") and (match:match("%u") or match:match("%d")) then
												temp = match
											end
										end  
										if temp then
											return temp
										end
										for match in arg:gmatch("[%w_]+") do
											if #match >= 4 then
												return match
											end
										end
									end
									do
										local map5 = {
											leads = {
												"use",
												"using",
												"redeem",
												"type",
												"enter",
												"claim",
												"with",  
												"grab",
												"got",
												"here is",
												"heres",
												"here's",
												"there is",
												"theres",
												"there's",
											},
											articles = {  
												"",
												"the%s+",
												"a%s+",
												"an%s+",
												"this%s+",
												"your%s+",
												"new%s+",
											},
											patterns = {
												"code%s+is",  
												"codes?%s+are",
												"code%s+for",
												"code%s+to%s+use",
												"code%s*[:%-]",
												"new%s+code",
												"free%s+code",
												"secret%s+code",
												"working%s+code",
												"another%s+code",
											},  
										}
										for _, lead in ipairs(map5.leads) do
											local text2 = lead:gsub("%s+", "%%s+")
											for _, article in ipairs(map5.articles) do
												map5.patterns[#map5.patterns + 1] = text2 .. "%s+" .. article .. "code"
											end
										end
										map5.names = { "sammy" }
										local function firstWord(arg)  
											for match, match2 in arg:gmatch("()([%w_]+)") do
												if #match2 >= 4 and match2:match("%a") and (match2:match("%u") or match2:match("%d")) then
													return arg:sub(match)
												end
											end
										end
										extractCodeFromMessage = function(arg)
											local text2 = arg:lower()
											local temp = nil  
											local temp2 = nil
											local function findMatchPos(arg2, arg3, arg4)
												local num2 = 1
												while true do
													local ok, result, result2 = pcall(string.find, text2, arg2, num2, arg3)
													if not (not ok or not result) then
														if not temp or result2 > temp then
															temp = result2
															temp2 = arg4
														end  
														num2 = result2 + 1
														continue
													end
													break
												end
											end
											for _, pattern in ipairs(map5.patterns) do
												findMatchPos(pattern, false, false)
											end  
											if text2:find("code") then
												for _, name in ipairs(map5.names) do
													local cond = true
													findMatchPos(name:lower(), cond, true)
												end
											end
											if not temp then
												return nil
											end
											local text3 = arg:sub(temp + 1)  
											local value5 = firstWord(text3)
											if temp2 then
												return value5
											end
											return value5 or ""
										end
									end
								end
							end  
							do
								local function collectRemotes(arg)
									if not getupvalues_ then
										return {}
									end
									local ok, result = pcall(getupvalues_, arg)
									local map5 = {}
									if ok and result then
										for _, value4 in pairs(result) do
											if typeof(value4) == "Instance" and (value4:IsA("RemoteEvent") or value4:IsA("RemoteFunction") or value4:IsA("UnreliableRemoteEvent")) and value4.Parent == net then  
												table.insert(map5, value4)
											end
										end
									end
									return map5
								end
								findNotifyRemote = function()
									local ok, result = pcall(function()
										return require(ReplicatedStorage.Controllers:FindFirstChild("NotificationController", true))  
									end)
									if ok then
										local text2 = "table"
										ok = type(result) == text2
									end
									if ok then
										local text2 = "function"
										ok = type(result.Start) == text2
									end
									if ok then
										return collectRemotes(result.Start)[1]
									end
								end
							end
						end
						do
							local findCodeBox, submitText, findConfirmButton, looksLikeConfirm
							do
								findCodeBox = function()  
									local codes = playerGui:FindFirstChild("Codes")
									if not codes then
										return nil
									end
									local value4 = (codes:FindFirstChild("Codes") or codes):FindFirstChild("Main")
									value4 = value4 and value4:FindFirstChild("TextBox")
									if value4 and value4:IsA("TextBox") then
										return value4
									end  
									for _, descendant in ipairs(codes:GetDescendants()) do
										if descendant:IsA("TextBox") then
											return descendant
										end
									end
								end
								do
									findConfirmButton = function()
										local codes = playerGui:FindFirstChild("Codes")
										if not codes then  
											return nil
										end
										local codes2 = codes:FindFirstChild("Codes") or codes
										local confirm = (codes2:FindFirstChild("Main") or codes2):FindFirstChild("Confirm")
										if confirm and (confirm:IsA("ImageButton") or confirm:IsA("TextButton")) then
											return confirm
										end
										local temp = nil
										for _, descendant in ipairs(codes:GetDescendants()) do  
											if descendant:IsA("ImageButton") or descendant:IsA("TextButton") then
												local text2 = descendant.Name:lower()
												if text2:find("confirm") or text2:find("submit") or text2:find("redeem") or text2:find("enter") then
													return descendant
												end
												temp = temp or descendant
											end
										end
										return temp
									end  
									local resetBoolUpvalues = nil
									resetBoolUpvalues = function(arg, arg2)
										if not (arg and setupvalue_ and getupvalues_) then
											return
										end
										arg2 = arg2 or 1
										local ok, result = pcall(getupvalues_, arg)
										if ok and type(result) == "table" then
											for k, value4 in pairs(result) do  
												local text2 = "boolean"
												if type(value4) == text2 then
													pcall(setupvalue_, arg, k, false)
												else
													local text3 = "function"
													if type(value4) == text3 and arg2 > 0 then
														resetBoolUpvalues(value4, arg2 - 1)
													end
												end
											end  
										end
									end
									local function hasConnection(arg, ...)
										if not getconnections_ then
											return false
										end
										local ok, result = pcall(getconnections_, arg)
										local cond = not ok
										if not cond then  
											local text2 = "table"
											cond = type(result) ~= text2
										end
										if cond or #result == 0 then
											return false
										end
										local args = table.pack(...)
										local value5, value6, value7 = ipairs(result)
										local cond2 = false  
										for _, value8 in value5, value6, value7 do
											if value8.Enabled ~= false then
												local function_ = nil
												pcall(function()
													function_ = value8.Function
												end)
												resetBoolUpvalues(function_)
												local ok2
												if function_ then
													ok2 = pcall(task.spawn, function_, table.unpack(args, 1, args.n))  
												else
													ok2 = pcall(function()
														value8:Fire(table.unpack(args, 1, args.n))
													end)
												end
												cond2 = cond2 or ok2
											end
										end
										return cond2  
									end
									setCodeBoxText = function(text)
										if type(text) ~= "string" or text == "" then
											return
										end
										local value4 = findCodeBox()
										if not value4 then
											return
										end  
										pcall(function()
											if value4.Text ~= text then
												value4.Text = text
											end
										end)
									end
									looksLikeConfirm = function(btn)
										if not btn then
											return false
										end
										local name = btn.Name:lower()
										return name:find("confirm", 1, true) ~= nil or name:find("submit", 1, true) ~= nil or name:find("redeem", 1, true) ~= nil or name:find("enter", 1, true) ~= nil
									end
									submitText = function(text)
										if not getconnections_ then
											return false, "no getconnections"
										end  
										local value4 = findCodeBox()
										if not value4 then
											return false, "code box not found"
										end
										pcall(function()
											value4.Text = text
											value4.Active = true
											value4.Selectable = true
										end)
										local value5 = findConfirmButton()
										local cond = false
										if looksLikeConfirm(value5) then
											cond = hasConnection(value5.MouseButton1Click)
											if not cond then
												cond = hasConnection(value5.Activated)
											end
										end
										if not cond then
											cond = hasConnection(value4.FocusLost, true)
										end
										return cond, cond and "submitted" or "no submit control"
									end
								end
							end
							do
								local function submitViaFocus(text)
									local value4 = findCodeBox()
									if not value4 then
										return false, "code box not found"
									end  
									if not pcall(function()
										value4.Text = text
										value4:CaptureFocus()
									end) then
										return false, "focus failed"
									end
									task.wait(0.05)
									local ok = pcall(function()
										value4:ReleaseFocus(true)
									end)  
									return ok, ok and "submitted" or "release failed"
								end
								local vim = nil
								pcall(function()
									vim = game:GetService("VirtualInputManager")
								end)
								local function boxConsumed(code)
									local box = findCodeBox()
									if not box then
										return false
									end
									local now = trimText(tostring(box.Text or ""))
									return now ~= trimText(code or "")
								end
								local function revealBox(box)
									if not box then
										return
									end
									pcall(function()
										local node = box
										while node and node ~= playerGui do
											if node:IsA("LayerCollector") then
												node.Enabled = true
											elseif node:IsA("GuiObject") then
												node.Visible = true
											end
											node = node.Parent
										end
									end)
								end
								local function sendEnterKey()
									if vim then
										local ok = pcall(function()
											vim:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
											task.wait(0.02)
											vim:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
										end)
										if not ok then
											ok = pcall(function()
												vim:SendKeyEvent(true, Enum.KeyCode.Return, false)
												task.wait(0.02)
												vim:SendKeyEvent(false, Enum.KeyCode.Return, false)
											end)
										end
										if ok then
											return true
										end
									end
									return (pcall(function()
										keypress(0x0D)
										task.wait(0.02)
										keyrelease(0x0D)
									end))
								end
								local function clickButton(btn)
									if not btn then
										return false
									end
									local absPos, absSize = btn.AbsolutePosition, btn.AbsoluteSize
									if absSize.X <= 0 or absSize.Y <= 0 then
										return false
									end
									local mx = absPos.X + absSize.X / 2
									local my = absPos.Y + absSize.Y / 2
									if vim then
										local ok = pcall(function()
											vim:SendMouseButtonEvent(mx, my, 0, true, game, 0)
											task.wait(0.02)
											vim:SendMouseButtonEvent(mx, my, 0, false, game, 0)
										end)
										if not ok then
											ok = pcall(function()
												vim:SendMouseButtonEvent(mx, my, 0, true, false, 0)
												task.wait(0.02)
												vim:SendMouseButtonEvent(mx, my, 0, false, false, 0)
											end)
										end
										if ok then
											return true
										end
									end
									return (pcall(function()
										if typeof(mousemoveabs) == "function" then
											mousemoveabs(mx, my)
										elseif typeof(mousemoverel) == "function" then
											local m = UserInputService:GetMouseLocation()
											mousemoverel(mx - m.X, my - m.Y)
										end
										task.wait(0.02)
										mouse1click()
									end))
								end
								local function typeIntoBox(box, code)
									if not box then
										return
									end
									pcall(function()
										box.Text = ""
									end)
									local n = #code
									if n <= 2 then
										pcall(function()
											box.Text = code
										end)
										return
									end
									local steps = n <= 5 and 2 or (n <= 12 and 3 or 4)
									for i = 1, steps do
										local upto = math.floor(n * i / steps)
										pcall(function()
											box.Text = code:sub(1, upto)
										end)
										task.wait(0.005)
									end
								end
								submitCode = function(arg)
									local box = findCodeBox()
									local okEnter, okClick, okFire = false, false, false
									if box then
										revealBox(box)
										task.wait(0.08)
									end
									local function doEnter()
										if not box then
											return false
										end
										pcall(function()
											box:CaptureFocus()
										end)
										task.wait(0.05)
										typeIntoBox(box, arg)
										task.wait(0.05)
										local ok = sendEnterKey()
										task.wait(0.05)
										pcall(function()
											box:ReleaseFocus(true)
										end)
										task.wait(0.04)
										return ok
									end
									local function doClick()
										local btn = findConfirmButton()
										if not looksLikeConfirm(btn) then
											return false
										end
										if box and box.Text ~= arg then
											pcall(function()
												box.Text = arg
											end)
										end
										return clickButton(btn)
									end
									if isTouch then
										pcall(function()
											if box and box.Text ~= arg then
												box.Text = arg
											end
										end)
										okFire = submitText(arg)
										if not (okFire and boxConsumed(arg)) then
											okClick = doClick()
											if not (okClick and boxConsumed(arg)) then
												okEnter = doEnter()
											end
										end
									else
										okEnter = doEnter()
										if not (okEnter and boxConsumed(arg)) then
											okClick = doClick()
											if not (okClick and boxConsumed(arg)) then
												okFire = submitText(arg)
											end
										end
									end
									if not (okEnter or okClick or okFire) then
										local okFocus = submitViaFocus(arg)
										okFire = okFocus and true or false
									end
									local sent = okEnter or okClick or okFire
									local parts = {}
									if okEnter then
										parts[#parts + 1] = "enter"
									end
									if okClick then
										parts[#parts + 1] = "click"
									end
									if okFire then
										parts[#parts + 1] = "fire"
									end
									local why = #parts > 0 and table.concat(parts, "+") or "no submit control"
									return sent, why, boxConsumed(arg)
								end
							end
						end
					end
					map3 = {
						ready = false,
						why = "EventController unavailable",
						IsBlocked = function()  
							return false
						end,
					}
					do
						local function requireController(arg)
							local value4 = ReplicatedStorage:FindFirstChild("Controllers")
							value4 = value4 and value4:FindFirstChild(arg, true)
							if not (value4 and value4:IsA("ModuleScript")) then
								return nil
							end  
							local ok, result = pcall(require, value4)
							if ok and type(result) == "table" then
								return result
							end
						end
						local EventController = requireController("EventController")
						local EffectController = requireController("EffectController")
						local cond = EventController and type(EventController.Events) == "table"
						if cond then  
							local text2 = "function"
							cond = type(EventController.Execute) == text2
						end
						if not cond then
							map3.why = "EventController missing Events/Execute"
						else
							local brainrotEventTool, value4, refreshControllers, isVisualEffect, countActiveEffects, refreshEffectSet, stashEffects
							do
								do  
									brainrotEventTool = _G.__BrainrotEventTool
									if not brainrotEventTool then
										brainrotEventTool = {}
										_G.__BrainrotEventTool = brainrotEventTool
									end
									brainrotEventTool.origExecute = brainrotEventTool.origExecute or EventController.Execute
									brainrotEventTool.origGetActive = brainrotEventTool.origGetActive or EventController.GetActiveEvents
									if EffectController then
										brainrotEventTool.origRun = brainrotEventTool.origRun or EffectController.Run
									end  
									brainrotEventTool.fakes = brainrotEventTool.fakes or {}
									brainrotEventTool.capture = brainrotEventTool.capture or {}
									brainrotEventTool.spawned = brainrotEventTool.spawned or {}
									brainrotEventTool.clearedAttrs = brainrotEventTool.clearedAttrs or {}
									brainrotEventTool.stashed = brainrotEventTool.stashed or {}
									if brainrotEventTool.blocked == nil then
										brainrotEventTool.blocked = false
									end
									map3.S = brainrotEventTool  
									map3.IsBlocked = function()
										return brainrotEventTool.blocked and true or false
									end
									value4 = nil
									do
										local getupvalue_ = debug and debug.getupvalue
										if getupvalue_ then
											local ok, result = pcall(getupvalue_, brainrotEventTool.origExecute, 5)
											if ok and type(result) == "table" then  
												value4 = result
											end
										end
									end
								end
								if not brainrotEventTool.shimmed then
									EventController.GetActiveEvents = function(arg)
										local map5 = {}
										if not brainrotEventTool.blocked then
											local ok, result = pcall(brainrotEventTool.origGetActive, arg)  
											if ok and type(result) == "table" then
												for _, value5 in pairs(result) do
													map5[#map5 + 1] = value5
												end
											end
										end
										for _, fake in pairs(brainrotEventTool.fakes) do
											map5[#map5 + 1] = fake
										end  
										return map5
									end
									brainrotEventTool.shimmed = true
								end
								refreshControllers = function()
									local value5 = requireController("LightingController")
									if value5 and type(value5.Update) == "function" then
										pcall(function()
											value5:Update()  
										end)
									end
									local SoundController = requireController("SoundController")
									local cond2
									if SoundController then
										local text2 = "function"
										cond2 = type(SoundController.UpdateOST) == text2
									else
										cond2 = SoundController
									end  
									if cond2 then
										pcall(function()
											SoundController:UpdateOST()
										end)
									end
								end
								isVisualEffect = function(arg)
									return arg:IsA("Sky") or arg:IsA("Atmosphere") or arg:IsA("Clouds") or arg:IsA("PostEffect")
								end
								countActiveEffects = function()  
									local cond2 = EffectController
									if EffectController then
										local text2 = "table"
										cond2 = type(EffectController.ActiveEffects) == text2
									end
									if not cond2 then
										return 0
									end
									local map5 = {}
									for k in pairs(EffectController.ActiveEffects) do  
										map5[#map5 + 1] = k
									end
									for _, value5 in ipairs(map5) do
										local text2 = "table"
										local effect = type(EffectController.Effects) == text2 and EffectController.Effects[value5] or nil
										EffectController.ActiveEffects[value5] = nil
										if type(effect) == "table" then
											local text3 = "function"
											if type(effect.OnUpdate) == text3 then  
												pcall(function()
													effect:OnUpdate()
												end)
											end
											if type(effect.OnStop) == "function" then
												pcall(function()
													effect:OnStop()
												end)
											end
										end
									end
									return #map5
								end
								do
									local map5 = {
										EventsLoaded = true,
										NextCrystalEvent = true,
										CrystalEventLastTime = true,
										SantaMerchantStockId = true,  
										SantaMerchantNextStockId = true,
										FuseMachineLuck = true,
										FuseMachineLuckTimer = true,
									}
									local map6 = {
										"AyMiGatitoEvent",
										"ChicleteiraBicicleteiraEvent",
										"EasterEvent",
										"ExtinctEvent",
										"IndonesiaEvent",  
										"MeowlEvent",
										"MexicoEvent",
										"RipMyGrannyEvent",
										"SkibidiEvent",
										"StPatricksEvent",
										"StrawberryEvent",
										"TrickOrTreatEvent",
										"ValentinesEvent",
										"YinYangEvent",
										"WitchingHourEvent",  
									}
									local blockedEffects = {
										"Lighting",
										"WallRecolor",
										"Atmosphere",
									}
									refreshEffectSet = function()
										if not (EffectController and type(EffectController.Effects) == "table") then
											return
										end  
										for _, value5 in ipairs(blockedEffects) do
											local value6 = EffectController.Effects[value5]
											local cond2
											if value6 then
												local text2 = "function"
												cond2 = type(value6.OnUpdate) == text2
											else
												cond2 = value6
											end
											if cond2 then
												pcall(function()
													value6:OnUpdate()
												end)
											end
										end
									end
									stashEffects = function()
										local effectNames = {}
										for _, value5 in ipairs(map6) do  
											effectNames[value5] = true
										end
										local num2 = 0
										for k, value5 in pairs(ReplicatedStorage:GetAttributes()) do
											local text2 = "string"
											local cond2 = type(k) == text2 and value5 == true and not map5[k]
											local pos
											if cond2 then
												pos = effectNames[k] or k:find("Event") or k:find("Phase") or k:find("Hour")  
											else
												pos = cond2
											end
											if pos then
												pcall(function()
													ReplicatedStorage:SetAttribute(k, nil)
												end)
												brainrotEventTool.clearedAttrs[k] = true
												num2 += 1
											end  
										end
										refreshEffectSet()
										return num2
									end
								end
							end
							do
								local function helper()
									local num2 = 0
									for k in pairs(brainrotEventTool.clearedAttrs) do  
										pcall(function()
											ReplicatedStorage:SetAttribute(k, true)
										end)
										num2 += 1
									end
									table.clear(brainrotEventTool.clearedAttrs)
									refreshEffectSet()
									return num2
								end  
								local function helper2()
									local num2 = 0
									for _, descendant in ipairs(workspace:GetDescendants()) do
										if descendant:IsA("Sound") and descendant.Playing and descendant.Looped then
											pcall(function()
												descendant:Stop()
											end)
											num2 += 1
										end
									end  
									return num2
								end
								local function helper3()
									local num2 = 0
									for k, value5 in pairs(brainrotEventTool.stashed) do
										if typeof(k) == "Instance" then
											pcall(function()
												k.Parent = value5
											end)  
											num2 += 1
										end
										brainrotEventTool.stashed[k] = nil
									end
									return num2
								end
								local function helper4()
									local effects = _G.Effects
									if type(effects) == "table" and type(effects.Block) == "function" and type(effects.Unblock) == "function" then
										return effects  
									end
								end
								map3.Block = function()
									local value5 = helper4()
									if value5 then
										value5.Block()
										brainrotEventTool.blocked = true
										return true, "blocked (effects panel)"
									end  
									local num2 = 0
									for k, event in pairs(EventController.Events) do
										if type(event) == "table" and rawget(event, "Active") then
											if not (type(EventController.Cancel) == "function" and pcall(function()
												return EventController:Cancel(k)
											end)) then
												rawset(event, "Active", false)
												rawset(event, "__started", false)
											end  
											num2 += 1
										end
									end
									local value6 = countActiveEffects()
									for k, value7 in pairs(brainrotEventTool.capture) do
										local cond2 = type(value7) == "table"
										if cond2 then
											local text2 = "table"
											cond2 = type(value7.caught) == text2
										end  
										if cond2 then
											for k2 in pairs(value7.caught) do
												local text2 = "Instance"
												if typeof(k2) == text2 and k2.Parent and not isVisualEffect(k2) then
													pcall(function()
														k2:Destroy()
													end)
												end
											end  
										end
										brainrotEventTool.capture[k] = nil
									end
									table.clear(brainrotEventTool.spawned)
									table.clear(brainrotEventTool.fakes)
									if value4 then
										for k, value7 in pairs(value4) do
											local text2 = "table"
											if type(value7) == text2 then
												for _, value8 in ipairs(value7) do  
													if typeof(value8) == "Instance" and not isVisualEffect(value8) then
														pcall(function()
															value8:Destroy()
														end)
													end
												end
											end
											value4[k] = nil
										end  
									end
									EventController.Execute = function()
										return false
									end
									if EffectController then
										EffectController.Run = function()
											return false, false
										end
									end
									brainrotEventTool.blocked = true  
									refreshControllers()
									stashEffects()
									local value7 = helper2()
									return true, ("blocked %d event(s), %d fx, %d sound(s)"):format(num2, value6, value7)
								end
								map3.Unblock = function()
									local value5 = helper4()
									if value5 then
										value5.Unblock()  
										brainrotEventTool.blocked = false
										return true, "unblocked (effects panel)"
									end
									EventController.Execute = brainrotEventTool.origExecute
									if EffectController and brainrotEventTool.origRun then
										EffectController.Run = brainrotEventTool.origRun
									end
									brainrotEventTool.blocked = false
									local value6 = helper()  
									local value7 = helper3()
									refreshControllers()
									return true, ("unblocked - %d flag(s), %d model(s) restored"):format(value6, value7)
								end
							end
							map3.ready = true
							map3.why = nil
						end
					end
				end  
				local value4
				do
					do
						map4 = {
							bg = Color3.fromRGB(13, 15, 20),
							panel = Color3.fromRGB(22, 25, 33),
							panel2 = Color3.fromRGB(33, 38, 49),
							line = Color3.fromRGB(55, 62, 78),
							acc = Color3.fromRGB(0, 210, 190),
							acc2 = Color3.fromRGB(0, 120, 112),  
							accHi = Color3.fromRGB(70, 245, 225),
							txt = Color3.fromRGB(238, 242, 250),
							sub = Color3.fromRGB(150, 160, 180),
							ok = Color3.fromRGB(80, 220, 140),
							err = Color3.fromRGB(230, 80, 80),
							warn = Color3.fromRGB(255, 205, 80),
							input = Color3.fromRGB(16, 18, 24),
							dark = Color3.fromRGB(9, 10, 14),
						}
						basePalette = {
							bg = Color3.fromRGB(13, 15, 20),
							panel = Color3.fromRGB(22, 25, 33),
							panel2 = Color3.fromRGB(33, 38, 49),
							line = Color3.fromRGB(55, 62, 78),
							input = Color3.fromRGB(16, 18, 24),
							dark = Color3.fromRGB(9, 10, 14),
							txt = Color3.fromRGB(238, 242, 250),
							sub = Color3.fromRGB(150, 160, 180),
						}
						themePresets = {
							TEAL = { acc = Color3.fromRGB(0, 210, 190), acc2 = Color3.fromRGB(0, 120, 112), accHi = Color3.fromRGB(70, 245, 225) },
							BLUE = { acc = Color3.fromRGB(70, 140, 255), acc2 = Color3.fromRGB(40, 80, 170), accHi = Color3.fromRGB(130, 180, 255) },
							PURPLE = { acc = Color3.fromRGB(150, 100, 235), acc2 = Color3.fromRGB(90, 55, 160), accHi = Color3.fromRGB(190, 150, 255) },
							LIME = { acc = Color3.fromRGB(150, 220, 60), acc2 = Color3.fromRGB(85, 140, 30), accHi = Color3.fromRGB(185, 245, 120) },
							RED = { acc = Color3.fromRGB(230, 70, 70), acc2 = Color3.fromRGB(150, 40, 40), accHi = Color3.fromRGB(255, 120, 120) },
							PINK = { acc = Color3.fromRGB(235, 90, 175), acc2 = Color3.fromRGB(160, 50, 110), accHi = Color3.fromRGB(255, 130, 210) },
							LIGHT = {
								acc = Color3.fromRGB(0, 150, 136),
								acc2 = Color3.fromRGB(0, 105, 96),
								accHi = Color3.fromRGB(0, 184, 168),
								surface = {
									bg = Color3.fromRGB(240, 243, 248),
									panel = Color3.fromRGB(255, 255, 255),
									panel2 = Color3.fromRGB(234, 238, 245),
									line = Color3.fromRGB(205, 212, 225),
									input = Color3.fromRGB(246, 248, 252),
									dark = Color3.fromRGB(222, 227, 236),
									txt = Color3.fromRGB(26, 30, 40),
									sub = Color3.fromRGB(108, 118, 136),
								},
							},
						}
						themeStroke = {}
						themeGradient = {}
						themeAccent = {}
						themeColor = {}
						themeKey = function(color)
							for k, v in pairs(map4) do
								if typeof(v) == "Color3" and v == color then
									return k
								end
							end
						end
						applyTheme = function(name)
							local preset = themePresets[name] or themePresets.PINK
							for k, v in pairs(basePalette) do
								map4[k] = v
							end
							if preset.surface then
								for k, v in pairs(preset.surface) do
									map4[k] = v
								end
							end
							map4.acc = preset.acc
							map4.acc2 = preset.acc2
							map4.accHi = preset.accHi
							for _, entry in ipairs(themeStroke) do
								if entry.key and entry.obj then
									entry.obj.Color = map4[entry.key]
								end
							end
							for _, entry in ipairs(themeAccent) do
								if entry.key and entry.obj then
									entry.obj.BackgroundColor3 = map4[entry.key]
								end
							end
							for _, entry in ipairs(themeColor) do
								if entry.key and entry.obj then
									entry.obj[entry.prop] = map4[entry.key]
								end
							end
							for _, entry in ipairs(themeGradient) do
								if entry.obj then
									local a = entry.k1 and map4[entry.k1] or entry.c1
									local b = entry.k2 and map4[entry.k2] or entry.c2
									entry.obj.Color = ColorSequence.new(a, b)
								end
							end
							theme = name
							_G.__RdmCfgSet("theme", name)
						end
						applyTheme(theme)
						ICONS = {
							settings = "rbxassetid://7734053495",
							feed = "rbxassetid://7733993049",
							bell = "rbxassetid://7733911828",
							shield = "rbxassetid://7734056608",
							minus = "rbxassetid://7734000129",
							plus = "rbxassetid://7734042071",
							copy = "rbxassetid://7733764083",
							send = "rbxassetid://7734053039",
							check = "rbxassetid://7733715400",
							x = "rbxassetid://7743878857",
							palette = "rbxassetid://7734021595",
							languages = "rbxassetid://7733965249",
							monitor = "rbxassetid://7734002839",
						}
						uiSounds = {}
						uiSoundOn = _G.__RdmCfgBool("uiSound", true)
						local function playSound(id, volume, speed)
							if not uiSoundOn then
								return
							end
							local s = uiSounds[id]
							if not s then
								s = create("Sound", { SoundId = id, Volume = volume or 0.3, PlaybackSpeed = speed or 1, }, game:GetService("SoundService"))
								uiSounds[id] = s
							end
							s.TimePosition = 0
							s:Play()
						end
						local function buzz()
							if not uiSoundOn then
								return
							end
							pcall(function()
								local us = game:GetService("UserInputService")
								if us.GamepadEnabled then
									local hs = game:GetService("HapticService")
									hs:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0.4)
									task.delay(0.1, function()
										pcall(function()
											hs:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0)
										end)
									end)
								end
							end)
						end
						playClick = function()
							playSound("rbxasset://sounds/electronicpingshort.wav", 0.28, 1.9)
							buzz()
						end
						playToggle = function()
							playSound("rbxasset://sounds/electronicpingshort.wav", 0.24, 1.2)
							buzz()
						end
						gothamMedium = Enum.Font.GothamMedium
						gothamBold = Enum.Font.GothamBold
						gothamBlack = Enum.Font.GothamBlack
						create = function(arg, arg2, parent)
							local instance = Instance.new(arg)
							local value5 = pairs
							local map5 = arg2 or {}
							for k, value6 in value5(map5) do
								instance[k] = value6
							end  
							for _, prop in ipairs({ "BackgroundColor3", "TextColor3", "ImageColor3", "BorderColor3", "PlaceholderColor3" }) do
								local col = map5[prop]
								if typeof(col) == "Color3" then
									local key = themeKey(col)
									if key then
										themeColor[#themeColor + 1] = { obj = instance, prop = prop, key = key }
									end
								end
							end
							if parent then
								instance.Parent = parent
							end
							return instance
						end
						addCorner = function(arg, arg2)
							local radius = arg2 or 8
							if radius > 3 then
								radius = 3
							end
							create("UICorner", { CornerRadius = UDim.new(0, radius) }, arg)
						end
						addStroke = function(arg, arg2, arg3, arg4)  
							local stroke = create("UIStroke", { Color = arg2 or map4.line, Thickness = arg3 or 1, Transparency = arg4 or 0 }, arg)
							themeStroke[#themeStroke + 1] = { obj = stroke, key = themeKey(stroke.Color) }
							return stroke
						end
						tween = function(arg, arg2, arg3, arg4)
							value3:Create(arg, TweenInfo.new(arg2, arg4 or Enum.EasingStyle.Quad), arg3):Play()
						end
						do
							local function addGradient(arg, arg2, arg3, arg4)
								local gradient = create("UIGradient", { Color = ColorSequence.new(arg2, arg3), Rotation = arg4 or 90 }, arg)
								themeGradient[#themeGradient + 1] = { obj = gradient, k1 = themeKey(arg2), k2 = themeKey(arg3), c1 = arg2, c2 = arg3 }
								return gradient
							end
							makeLabel = function(arg, arg2, arg3, arg4, arg5, arg6)  
								local label = create("TextLabel", {
									BackgroundTransparency = 1,
									Text = translate(arg),
									Font = arg4 or gothamMedium,
									TextSize = arg2 or 12,
									TextColor3 = arg3 or map4.txt,
									TextXAlignment = arg5 or Enum.TextXAlignment.Left,
									}, arg6)
								registerLang(label, arg)
								return label
							end  
							local function enableDrag(arg, arg2)
								local cond = nil
								local temp = nil
								local temp2 = nil
								arg.InputBegan:Connect(function(input)
									if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
										local position = input.Position
										local position2 = arg2.Position
										cond = true
										temp = position  
										temp2 = position2
										input.Changed:Connect(function()
											if input.UserInputState == Enum.UserInputState.End then
												cond = false
											end
										end)
									end
								end)
								UserInputService.InputChanged:Connect(function(input)  
									if cond and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
										local value5 = input.Position - temp
										arg2.Position = UDim2.new(temp2.X.Scale, temp2.X.Offset + value5.X, temp2.Y.Scale, temp2.Y.Offset + value5.Y)
									end
								end)
							end
							makeWindow = function(arg, arg2, arg3, arg4)
								local uiFrame = create("Frame", {
									Name = arg,
									Size = UDim2.fromOffset(arg2, arg3),  
									BackgroundColor3 = map4.bg,
									BorderSizePixel = 0,
									Active = true,
									ClipsDescendants = true,
								})
								addCorner(uiFrame, 14)
								addGradient(uiFrame, map4.panel, map4.bg, 90)
								local winStroke = addStroke(uiFrame, Color3.fromRGB(255, 255, 255), 1.1, 0.35)
								addGradient(winStroke, map4.acc, map4.acc2, 60)
								if isTouch then
									create("UIScale", { Name = "WinScale", Scale = uiScale }, uiFrame)  
								end
								local entrance = create("UIScale", { Scale = 0.94 }, uiFrame)
								tween(entrance, 0.32, { Scale = 1 }, Enum.EasingStyle.Back)
								local Frame7 = create("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = map4.bg, BorderSizePixel = 0 }, uiFrame)
								addCorner(Frame7, 14)
								create("Frame", {
									Size = UDim2.new(1, 0, 0, 2),
									Position = UDim2.new(0, 0, 1, -2),
									BackgroundColor3 = map4.acc,
									BorderSizePixel = 0,
									}, Frame7)  
								local label = makeLabel(arg4, 15, map4.txt, gothamBlack, Enum.TextXAlignment.Left, Frame7)  
								label.Size = UDim2.new(1, -24, 1, 0)
								label.Position = UDim2.fromOffset(12, 0)
								enableDrag(Frame7, uiFrame)
								return uiFrame, Frame7, label
							end
							makeButton = function(arg, arg2)
								local TextButton2 = create("TextButton", {
									BackgroundColor3 = map4.panel,
									Text = translate(arg),  
									Font = gothamBold,
									TextSize = 12,
									TextColor3 = map4.sub,
									AutoButtonColor = false,
									BorderSizePixel = 0,
									}, arg2)
								addCorner(TextButton2, 8)
								registerLang(TextButton2, arg)
								local stroke = addStroke(TextButton2, map4.line, 1, 0.15)
								local hover = false
								local pressed = false
								local function render()
									local bg, fg, line
									if pressed then
										bg, fg, line = map4.dark, map4.txt, map4.acc
									elseif hover then
										bg, fg, line = map4.panel2, map4.txt, map4.acc
									else
										bg, fg, line = map4.panel, map4.sub, map4.line
									end
									tween(TextButton2, 0.1, { BackgroundColor3 = bg, TextColor3 = fg })
									tween(stroke, 0.1, { Color = line, Transparency = line == map4.acc and 0 or 0.15 })
								end
								TextButton2.MouseEnter:Connect(function()
									hover = true
									render()
								end)
								TextButton2.MouseLeave:Connect(function()
									hover = false
									pressed = false
									render()
								end)
								TextButton2.MouseButton1Down:Connect(function()
									pressed = true
									render()
									playClick()
								end)
								TextButton2.MouseButton1Up:Connect(function()
									pressed = false
									render()
								end)
								return TextButton2
							end
							makeAccentButton = function(arg, arg2)  
								local TextButton2 = create("TextButton", {
									BackgroundColor3 = map4.acc,
									Text = translate(arg),
									Font = gothamBlack,
									TextSize = 13,
									TextColor3 = Color3.fromRGB(10, 12, 16),
									AutoButtonColor = false,
									ClipsDescendants = true,
									BorderSizePixel = 0,
									}, arg2)
								addCorner(TextButton2, 8)
								registerLang(TextButton2, arg)
								themeAccent[#themeAccent + 1] = { obj = TextButton2, key = themeKey(TextButton2.BackgroundColor3) }
								local hover = false
								local pressed = false
								local function render()
									local bg
									if pressed then
										bg = map4.acc2
									elseif hover then
										bg = map4.accHi
									else
										bg = map4.acc
									end
									tween(TextButton2, 0.1, { BackgroundColor3 = bg })
								end
								TextButton2.MouseEnter:Connect(function()
									hover = true
									render()
								end)
								TextButton2.MouseLeave:Connect(function()
									hover = false
									pressed = false
									render()
								end)
								TextButton2.MouseButton1Down:Connect(function(input)
									pressed = true
									render()
									playClick()
									local rel = Vector2.new(input.Position.X - TextButton2.AbsolutePosition.X, input.Position.Y - TextButton2.AbsolutePosition.Y)
									local ripple = create("Frame", {
										AnchorPoint = Vector2.new(0.5, 0.5),
										Position = UDim2.fromOffset(rel.X, rel.Y),
										Size = UDim2.fromOffset(8, 8),
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										BackgroundTransparency = 0.72,
										BorderSizePixel = 0,
										}, TextButton2)
									create("UICorner", { CornerRadius = UDim.new(1, 0) }, ripple)
									local span = math.max(TextButton2.AbsoluteSize.X, TextButton2.AbsoluteSize.Y) * 2.2
									tween(ripple, 0.45, { Size = UDim2.fromOffset(span, span), BackgroundTransparency = 1 })
									task.delay(0.5, function()
										if ripple.Parent then
											ripple:Destroy()
										end
									end)
								end)
								TextButton2.MouseButton1Up:Connect(function()
									pressed = false
									render()
								end)
								return TextButton2
							end  
							iconButtons = {}
							makeIconButton = function(icon, parent, size, tip)
								local TextButton2 = create("TextButton", {
									BackgroundColor3 = map4.panel,
									Text = "",
									AutoButtonColor = false,
									BorderSizePixel = 0,
									}, parent)
								addCorner(TextButton2, 8)
								local stroke = addStroke(TextButton2, map4.line, 1, 0.16)
								local img = create("ImageLabel", {
									Name = "Icon",
									Size = UDim2.fromOffset(size or 16, size or 16),
									Position = UDim2.fromScale(0.5, 0.5),
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundTransparency = 1,
									Image = icon,
									ImageColor3 = map4.sub,
									}, TextButton2)
								local hover = false
								local pressed = false
								local state = { active = false, img = img }
								local function render()
									local on = hover or pressed
									local col
									if pressed then
										col = map4.accHi
									elseif hover then
										col = map4.acc
									else
										col = state.active and map4.acc or map4.sub
									end
									tween(img, 0.1, { ImageColor3 = col })
									tween(TextButton2, 0.1, { BackgroundColor3 = on and map4.panel2 or map4.panel })
									tween(stroke, 0.1, { Color = (on or state.active) and map4.acc or map4.line, Transparency = (on or state.active) and 0 or 0.16 })
								end
								state.render = render
								iconButtons[TextButton2] = state
								TextButton2.MouseEnter:Connect(function()
									hover = true
									render()
								end)
								TextButton2.MouseLeave:Connect(function()
									hover = false
									pressed = false
									render()
								end)
								TextButton2.MouseButton1Down:Connect(function()
									pressed = true
									render()
									playClick()
								end)
								TextButton2.MouseButton1Up:Connect(function()
									pressed = false
									render()
								end)
								if tip then
									attachTooltip(TextButton2, tip)
								end
								return TextButton2, img
							end
						end
					end
					do
						local hui = gethui and gethui() or playerGui
						local traced = hui:FindFirstChild("Fettah")
						if traced then
							traced:Destroy()
						end
						ScreenGui = create("ScreenGui", {  
							Name = "Fettah",
							ResetOnSpawn = false,
							ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
							DisplayOrder = 250,
							}, hui)
						tooltip = create("TextLabel", {
							Name = "FettahTooltip",
							Size = UDim2.fromOffset(0, 22),
							AutomaticSize = Enum.AutomaticSize.X,
							BackgroundColor3 = map4.panel2,
							BorderSizePixel = 0,
							Text = "",
							Font = gothamBold,
							TextSize = 10,
							TextColor3 = map4.txt,
							TextXAlignment = Enum.TextXAlignment.Center,
							TextYAlignment = Enum.TextYAlignment.Center,
							Visible = false,
							ZIndex = 500,
							}, ScreenGui)
						create("UIPadding", {
							PaddingLeft = UDim.new(0, 9),
							PaddingRight = UDim.new(0, 9),
							}, tooltip)
						addCorner(tooltip, 6)
						addStroke(tooltip, map4.line, 1, 0.1)
						local tooltipInsetY = 0
						pcall(function()
							local inset = game:GetService("GuiService"):GetGuiInset()
							if typeof(inset) == "Vector2" then
								tooltipInsetY = inset.Y
							end
						end)
						local function moveTooltip()
							local m = UserInputService:GetMouseLocation()
							local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
							local w = tooltip.AbsoluteSize.X
							local x = m.X + 14
							if x + w > vp.X - 8 then
								x = vp.X - w - 8
							end
							tooltip.Position = UDim2.fromOffset(x, m.Y + 16 + tooltipInsetY)
						end
						attachTooltip = function(obj, text)
							if not (obj and text) then
								return
							end
							obj.MouseEnter:Connect(function()
								tooltip.Text = text
								tooltip.Visible = true
								moveTooltip()
								task.defer(moveTooltip)
							end)
							obj.MouseLeave:Connect(function()
								tooltip.Visible = false
							end)
						end
						UserInputService.InputChanged:Connect(function(input)
							if tooltip.Visible and input.UserInputType == Enum.UserInputType.MouseMovement then
								moveTooltip()
							end
						end)
					end
					do
						local value6
						Main, value4, value6 = makeWindow("Main", 316, 548, "FETTAH")
						Main.Position = UDim2.new(1, -340, 0.5, -274)  
						if isTouch then
							Main.Position = UDim2.new(1, -math.floor(316 * uiScale) - 8, 0.5, -math.floor(548 * uiScale / 2))
						end
						Main.Parent = ScreenGui
						value6.Size = UDim2.new(1, -262, 1, 0)
					end
				end
				do
					addCorner(create("ImageLabel", {  
						Name = "CityBg",
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						ZIndex = 0,
						Image = "rbxthumb://type=Asset&id=96519310989847&w=420&h=420",
						ImageTransparency = 0.5,
						ImageColor3 = Color3.fromRGB(140, 190, 205),
						ScaleType = Enum.ScaleType.Crop,
						}, Main), 14)  
					do
						local Frame7 = create("Frame", {
							Name = "LeavesLayer",
							Size = UDim2.new(1, 0, 1, 0),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							ZIndex = 0,
							ClipsDescendants = true,
							}, Main)
						addCorner(Frame7, 14)  
						local map5 = {}
					local color = Color3.fromRGB(170, 245, 235)
					local color2 = Color3.fromRGB(120, 230, 225)
					local color3 = Color3.fromRGB(60, 205, 195)
					local color4 = Color3.fromRGB(205, 255, 250)
						local color5 = Color3.fromRGB
						local num2 = 160
						map5[1] = color
						map5[2] = color2  
						map5[3] = color3
						map5[4] = color4
						do
							local values = table.pack(color5(0, 175, num2))
							table.move(values, 1, values.n, 5, map5)
						end
						for i = 1, 18 do
							task.spawn(function()
								task.wait(math.random() * 2.5)
								while Frame7.Parent do  
									local rnd = math.random(5, 8)
									local rnd2 = rnd + math.random(2, 4)
									local rnd3 = math.random()
									local num3 = 0.3
									local Frame8 = create("Frame", {
										Size = UDim2.new(0, rnd, 0, rnd2),
										AnchorPoint = Vector2.new(0.5, 0.5),
										Position = UDim2.new(rnd3, 0, 0, -rnd2),
										BackgroundColor3 = map5[math.random(#map5)],  
										BackgroundTransparency = 0.15 + math.random() * num3,
										BorderSizePixel = 0,
										ZIndex = 0,
										Rotation = math.random(0, 359),
										}, Frame7)
									create("UICorner", { CornerRadius = UDim.new(1, 0) }, Frame8)
									local new = NumberSequenceKeypoint.new
									create("UIGradient", {
										Rotation = math.random(0, 359),
										Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), new(1, 0.55) }),  
										}, Frame8)
									local rnd4 = 4 + math.random() * 2.6
									local num4 = 0.3
									local rnd5 = (math.random() - 0.5) * num4
									local rnd6 = math.random(180, 540)
									local rnd7 = math.random() < 0.5 and -1 or 1
									value3:Create(Frame8, TweenInfo.new(rnd4, Enum.EasingStyle.Linear), { Position = UDim2.new(rnd3 + rnd5, 0, 1, rnd2 * 2), Rotation = Frame8.Rotation + rnd6 * rnd7 }):Play()
									task.wait(rnd4)
									if Frame8 and Frame8.Parent then  
										Frame8:Destroy()
									end
									task.wait(math.random() * 0.5)
								end
							end)
						end
					end
				end
				do
					Frame = create("Frame", {  
						Size = UDim2.fromOffset(8, 8),
						Position = UDim2.new(1, -212, 0.5, -4),
						BackgroundColor3 = map4.sub,
						BorderSizePixel = 0,
						Visible = false,
						}, value4)
					addCorner(Frame, 4)
					Rag = makeIconButton(ICONS.shield, value4, 15, "Anti-Ragdoll")
					Rag.Size = UDim2.fromOffset(30, 22)
					Rag.Position = UDim2.new(1, -164, 0.5, -11)
					testButton = makeIconButton(ICONS.bell, value4, 15, "Announce")
					testButton.Size = UDim2.fromOffset(30, 22)
					testButton.Position = UDim2.new(1, -130, 0.5, -11)
					feedButton = makeIconButton(ICONS.feed, value4, 15, "Activity Feed")
					feedButton.Size = UDim2.fromOffset(30, 22)
					feedButton.Position = UDim2.new(1, -96, 0.5, -11)
					Settings = makeIconButton(ICONS.settings, value4, 15, "Settings")
					Settings.Size = UDim2.fromOffset(30, 22)
					Settings.Position = UDim2.new(1, -62, 0.5, -11)
					do
						local button, buttonIcon = makeIconButton(ICONS.minus, value4, 14, "Collapse")
						button.Size = UDim2.fromOffset(22, 22)
						button.Position = UDim2.new(1, -28, 0.5, -11)
						windowHeight = 548
						visible = false
						button.MouseButton1Click:Connect(function()
							visible = not visible
							buttonIcon.Image = visible and ICONS.plus or ICONS.minus
							tween(Main, 0.25, { Size = UDim2.fromOffset(316, visible and 179 or windowHeight) })
						end)
					end  
				end
			end
			Frame6 = create("Frame", {
				Size = UDim2.new(1, -20, 1, -54),
				Position = UDim2.fromOffset(10, 48),
				BackgroundTransparency = 1,
				}, Main)
			create("UIListLayout", {
				Padding = UDim.new(0, 5),
				SortOrder = Enum.SortOrder.LayoutOrder,  
				}, Frame6)
			do
				local Frame7 = create("Frame", {
					Size = UDim2.new(1, 0, 0, 32),
					BackgroundColor3 = map4.panel,
					BorderSizePixel = 0,
					LayoutOrder = 1,
					}, Frame6)
				addCorner(Frame7, 9)  
				addStroke(Frame7, map4.line, 1, 0.16)
				local Frame8 = create("Frame", {
					Size = UDim2.fromOffset(8, 8),
					Position = UDim2.new(0, 12, 0.5, -4),
					BackgroundColor3 = map4.sub,
					BorderSizePixel = 0,
					}, Frame7)
				addCorner(Frame8, 4)
				statusLabel = makeLabel("starting...", 12, map4.txt, gothamBold, Enum.TextXAlignment.Left, Frame7)
				statusLabel.Size = UDim2.new(1, -32, 1, 0)  
				statusLabel.Position = UDim2.fromOffset(28, 0)
				statusLabel.TextTruncate = Enum.TextTruncate.AtEnd
				setStatus = function(text, arg)
					statusLabel.Text = text
					local ok = arg == "ok" and map4.ok or arg == "err" and map4.err or arg == "busy" and map4.acc or arg == "wait" and map4.warn or map4.txt
					statusLabel.TextColor3 = ok
					Frame8.BackgroundColor3 = ok
				end
			end
		end  
		do
			do
				do
					do
						local uiFrame = create("Frame", {
							Size = UDim2.new(1, 0, 0, 50),
							BackgroundColor3 = map4.panel,
							BorderSizePixel = 0,
							LayoutOrder = 2,
							}, Frame6)  
						addCorner(uiFrame, 9)
						addStroke(uiFrame, map4.line, 1, 0.16)
						local label = makeLabel("CODE", 9, map4.acc, gothamBlack, Enum.TextXAlignment.Left, uiFrame)
						label.Size = UDim2.new(1, -16, 0, 11)
						label.Position = UDim2.fromOffset(11, 5)
						TextBox = create("TextBox", {
							Size = UDim2.new(1, -18, 0, 26),
							Position = UDim2.fromOffset(9, 18),
							BackgroundColor3 = map4.input,  
							Text = "",
							PlaceholderText = "type or snipe a code...",
							PlaceholderColor3 = map4.sub,
							Font = gothamBlack,
							TextSize = 14,
							TextColor3 = map4.txt,
							ClearTextOnFocus = false,
							BorderSizePixel = 0,
							TextXAlignment = Enum.TextXAlignment.Left,
							}, uiFrame)  
					end
					do
						addCorner(TextBox, 7)
						do
							local stroke = addStroke(TextBox, map4.line, 1.2, 0.16)
							create("UIPadding", {
								PaddingLeft = UDim.new(0, 9),
								PaddingRight = UDim.new(0, 9),
								}, TextBox)  
							TextBox.Focused:Connect(function()
								tween(stroke, 0.12, { Color = map4.acc, Transparency = 0 })
							end)
							TextBox.FocusLost:Connect(function()
								tween(stroke, 0.12, { Color = map4.line, Transparency = 0.16 })
							end)
						end
					end
					do  
						local uiFrame = create("Frame", {
							Size = UDim2.new(1, 0, 0, 33),
							BackgroundTransparency = 1,
							LayoutOrder = 3,
							}, Frame6)
						create("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							Padding = UDim.new(0, 6),
							SortOrder = Enum.SortOrder.LayoutOrder,
							}, uiFrame)  
						copyButton = makeButton("COPY", uiFrame)
						copyButton.Size = UDim2.new(0.33333333333333331, -4, 1, 0)
						copyButton.LayoutOrder = 1
						attachTooltip(copyButton, "Copy the captured code")
						clear = makeButton("CLEAR", uiFrame)
						clear.Size = UDim2.new(0.33333333333333331, -4, 1, 0)
						clear.LayoutOrder = 2
						attachTooltip(clear, "Clear the captured text")
						redeem = makeAccentButton("REDEEM", uiFrame)
						attachTooltip(redeem, "Submit the captured code now")
					end
				end
				do  
					local addMainToggle
					do
						redeem.Size = UDim2.new(0.33333333333333331, -4, 1, 0)
						redeem.LayoutOrder = 3
						redeem.TextColor3 = Color3.fromRGB(0, 0, 0)
						addToggle = function(arg, arg2, arg3, arg4, arg5, arg6)
							local Frame7 = create("Frame", {
								Size = UDim2.new(1, 0, 0, 31),
								BackgroundColor3 = map4.panel,
								BorderSizePixel = 0,  
								LayoutOrder = arg2,
								}, arg)
							addCorner(Frame7, 8)
							local rowStroke = addStroke(Frame7, map4.line, 1, 0.16)
							local label = makeLabel(arg3, 11, map4.sub, gothamBold, Enum.TextXAlignment.Left, Frame7)
							label.Size = UDim2.new(1, -56, 1, 0)
							label.Position = UDim2.fromOffset(12, 0)
							label.TextTruncate = Enum.TextTruncate.AtEnd
							local Frame8 = create("Frame", {  
								Size = UDim2.fromOffset(38, 19),
								Position = UDim2.new(1, -46, 0.5, -9.5),
								BackgroundColor3 = map4.line,
								BorderSizePixel = 0,
								}, Frame7)
							addCorner(Frame8, 9)
							local trackStroke = addStroke(Frame8, map4.line, 1, 0.5)
							local Frame9 = create("Frame", {
								Size = UDim2.fromOffset(15, 15),
								Position = UDim2.new(0, 2, 0.5, -7.5),
								BackgroundColor3 = map4.txt,  
								BorderSizePixel = 0,
								}, Frame8)
							addCorner(Frame9, 7)
							local button = create("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "" }, Frame7)
							local cond = arg4
							local function updateToggleVisuals()
								tween(Frame8, 0.16, { BackgroundColor3 = cond and map4.acc or map4.line })
								tween(trackStroke, 0.16, { Color = cond and map4.acc or map4.line, Transparency = cond and 0 or 0.5 })
								tween(Frame9, 0.16, { Position = UDim2.new(0, cond and 21 or 2, 0.5, -7.5) }, Enum.EasingStyle.Back)
								tween(label, 0.16, { TextColor3 = cond and map4.txt or map4.sub })  
							end
							updateToggleVisuals()
							button.MouseEnter:Connect(function()
								tween(Frame7, 0.12, { BackgroundColor3 = map4.panel2 })
								tween(rowStroke, 0.12, { Color = map4.acc, Transparency = 0 })
							end)
							button.MouseLeave:Connect(function()
								tween(Frame7, 0.12, { BackgroundColor3 = map4.panel })
								tween(rowStroke, 0.12, { Color = map4.line, Transparency = 0.16 })
								tween(button, 0.1, { BackgroundTransparency = 1 })
							end)
							button.MouseButton1Down:Connect(function()
								tween(button, 0.08, { BackgroundTransparency = 0.88, BackgroundColor3 = map4.txt })
							end)
							button.MouseButton1Up:Connect(function()
								tween(button, 0.1, { BackgroundTransparency = 1 })
							end)
							button.MouseButton1Click:Connect(function()
								cond = not cond
								updateToggleVisuals()
								playToggle()
								if arg5 then
									arg5(cond)
								end
							end)  
							if arg6 then
								attachTooltip(button, arg6)
							end
							return Frame7
						end
						addMainToggle = function(arg, arg2, arg3, arg4, arg5)
							return addToggle(Frame6, arg, arg2, arg3, arg4, arg5)
						end
						do
							local Frame7 = create("Frame", {
								Size = UDim2.new(1, 0, 0, 31),
								BackgroundColor3 = map4.panel,
								BorderSizePixel = 0,  
								LayoutOrder = 4,
								}, Frame6)
							addCorner(Frame7, 8)
							addStroke(Frame7, map4.line, 1, 0.16)
							listen = makeLabel("LISTEN", 11, map4.sub, gothamBold, Enum.TextXAlignment.Left, Frame7)
							listen.Size = UDim2.new(1, -56, 1, 0)
							listen.Position = UDim2.fromOffset(12, 0)
							Frame2 = create("Frame", {
								Size = UDim2.fromOffset(36, 18),  
								Position = UDim2.new(1, -44, 0.5, -9),
								BackgroundColor3 = map4.line,
								BorderSizePixel = 0,
								}, Frame7)
							addCorner(Frame2, 9)
							Frame3 = create("Frame", {
								Size = UDim2.fromOffset(14, 14),
								Position = UDim2.new(0, 2, 0.5, -7),
								BackgroundColor3 = map4.txt,
								BorderSizePixel = 0,  
								}, Frame2)
							addCorner(Frame3, 7)
							TextButton = create("TextButton", {
								Size = UDim2.fromScale(1, 1),
								BackgroundTransparency = 1,
								Text = "",
								}, Frame7)
						end
					end  
					do
						Frame5 = create("Frame", {
							Size = UDim2.new(1, 0, 0, 31),
							BackgroundColor3 = map4.panel,
							BorderSizePixel = 0,
							LayoutOrder = 5,
							}, Frame6)
						addCorner(Frame5, 8)
						addStroke(Frame5, map4.line, 1, 0.16)  
						do
							local label = makeLabel("LISTEN KEY", 11, map4.sub, gothamBold, Enum.TextXAlignment.Left, Frame5)
							label.Size = UDim2.new(1, -100, 1, 0)
							label.Position = UDim2.fromOffset(12, 0)
						end
					end
					listenKeyButton = makeButton(listenKey and listenKey.Name or "-", Frame5)
					listenKeyButton.Size = UDim2.fromOffset(46, 24)
					listenKeyButton.Position = UDim2.new(1, -84, 0.5, -12)
					listenKeyButton.TextSize = 11  
					attachTooltip(listenKeyButton, "Click to set the LISTEN key")
					clearListenButton = makeButton("X", Frame5)
					clearListenButton.Size = UDim2.fromOffset(24, 24)
					clearListenButton.Position = UDim2.new(1, -32, 0.5, -12)
					clearListenButton.TextSize = 12
					attachTooltip(clearListenButton, "Clear the LISTEN key")
					Frame4 = create("Frame", {
						Size = UDim2.new(1, 0, 0, 31),
						BackgroundColor3 = map4.panel,
						BorderSizePixel = 0,
						LayoutOrder = 6,
						}, Frame6)  
					addCorner(Frame4, 8)
					addStroke(Frame4, map4.line, 1, 0.16)
					do
						local label = makeLabel("REDEEM KEY", 11, map4.sub, gothamBold, Enum.TextXAlignment.Left, Frame4)
						label.Size = UDim2.new(1, -100, 1, 0)
						label.Position = UDim2.fromOffset(12, 0)
					end
					redeemKeyButton = makeButton(redeemKey and redeemKey.Name or "-", Frame4)
					redeemKeyButton.Size = UDim2.fromOffset(46, 24)  
					redeemKeyButton.Position = UDim2.new(1, -84, 0.5, -12)
					redeemKeyButton.TextSize = 11
					attachTooltip(redeemKeyButton, "Click to set the REDEEM key")
					clearRedeemButton = makeButton("X", Frame4)
					clearRedeemButton.Size = UDim2.fromOffset(24, 24)
					clearRedeemButton.Position = UDim2.new(1, -32, 0.5, -12)
					clearRedeemButton.TextSize = 12
					attachTooltip(clearRedeemButton, "Clear the REDEEM key")
					addMainToggle(7, "AUTO REDEEM", autoRedeem, function(arg)
						autoRedeem = arg
						_G.__RdmCfgSet("autoRedeem", arg)
					end, "Automatically submit captured codes")  
					addMainToggle(8, "AUTO TYPE", autoType, function(arg)
						autoType = arg
						_G.__RdmCfgSet("autoType", arg)
					end, "Type the code into the box for you")
					addMainToggle(9, "MANUAL", manual, function(arg)
						manual = arg
						map2 = {}
						setWordsRowVisible()
					end, "Only redeem when you press the fire key")  
				end
				do
					local function addOptionRow(arg, arg2, arg3, arg4, arg5)
						local Frame7 = create("Frame", {
							Size = UDim2.new(1, 0, 0, 31),
							BackgroundColor3 = map4.panel,
							BorderSizePixel = 0,
							LayoutOrder = arg,
							}, Frame6)
						addCorner(Frame7, 8)
						addStroke(Frame7, map4.line, 1, 0.16)
						local label = makeLabel(arg2, 11, map4.sub, gothamBold, Enum.TextXAlignment.Left, Frame7)
						label.Size = UDim2.fromOffset(56, 31)
						label.Position = UDim2.fromOffset(11, 0)
						local uiFrame = create("Frame", {
							Size = UDim2.fromOffset(168, 23),
							Position = UDim2.new(1, -177, 0.5, -11.5),
							BackgroundColor3 = map4.input,
							BorderSizePixel = 0,  
							}, Frame7)
						addCorner(uiFrame, 7)
						local map5 = {}
						local function onOptionClick(arg6)
							for k, value3 in pairs(map5) do
								local cond = k == arg6
								tween(value3, 0.12, { BackgroundColor3 = cond and map4.acc or map4.input })
								value3.TextColor3 = cond and Color3.fromRGB(255, 255, 255) or map4.sub
							end
							if arg5 then
								arg5(arg6)
							end
						end
						for i, value3 in ipairs(arg3) do
							local cond = type(value3) == "table" and value3[1] or value3
							local cond2 = type(value3) == "table" and value3[2] or value3
							local TextButton2 = create("TextButton", {
								Size = UDim2.new(1 / #arg3, -2, 1, -2),
								Position = UDim2.new((i - 1) / #arg3, 1, 0, 1),  
								BackgroundColor3 = map4.input,
								Text = cond2,
								Font = gothamBold,
								TextSize = cond2:find("\n") and 8 or 10,
								TextColor3 = map4.sub,
								AutoButtonColor = false,
								BorderSizePixel = 0,
								}, uiFrame)
							addCorner(TextButton2, 6)
							map5[cond] = TextButton2  
							TextButton2.MouseButton1Click:Connect(function()
								onOptionClick(cond)
							end)
						end
						onOptionClick(arg4)
						return Frame7, onOptionClick
					end
					words = addOptionRow(11, "WORDS", { "1", "2", "3", "4" }, tostring(wordLimit), function(arg)
						wordLimit = tonumber(arg) or 1
						map2 = {}  
						if isListening and not manual then
							setStatus(("listening... 0/%d"):format(wordLimit), "wait")
						end
					end)
					local Frame7 = create("Frame", {
						Size = UDim2.new(1, 0, 0, 31),
						BackgroundColor3 = map4.panel,
						BorderSizePixel = 0,
						LayoutOrder = 12,  
						}, Frame6)
					addCorner(Frame7, 8)
					spamRowStroke = addStroke(Frame7, map4.line, 1, 0.16)
					spamLabel = makeLabel("SPAM", 11, map4.sub, gothamBold, Enum.TextXAlignment.Left, Frame7)
					spamLabel.Size = UDim2.new(1, -94, 1, 0)
					spamLabel.Position = UDim2.fromOffset(11, 0)
					start = makeButton("START", Frame7)
					start.Size = UDim2.fromOffset(70, 24)
					start.Position = UDim2.new(1, -78, 0.5, -12)
					start.TextSize = 11
					attachTooltip(start, "Start or stop the spam loop")
					spamDot = create("Frame", {
						Size = UDim2.fromOffset(7, 7),
						Position = UDim2.new(0, 9, 0.5, -3.5),
						BackgroundColor3 = map4.line,
						BorderSizePixel = 0,
						}, start)
					addCorner(spamDot, 4)
					addOptionRow(13, "SPEED", { "MAX", { "WORD", "EVERY\nWORD" } }, _G.__RdmCfgBool("wordMode", false) and "WORD" or "MAX", function(arg)
						wordMode = arg == "WORD"  
						if not wordMode then
							max = speeds[arg] or speeds.MAX
						end
						_G.__RdmCfgSet("speed", arg)
						_G.__RdmCfgSet("wordMode", wordMode)
					end)
				end
			end
			do
				local Frame7  
				do
					do
						do
							local temp = nil
							for _, descendant in ipairs(Frame6:GetDescendants()) do
								if descendant:IsA("TextButton") and descendant.Text == "EVERY\nWORD" then
									temp = descendant
									break
								else
									temp = nil  
								end
							end
							if temp then
								create("TextLabel", {
									Size = UDim2.fromOffset(64, 8),
									AnchorPoint = Vector2.new(0.5, 1),
									Position = UDim2.new(0.5, 0, 0, -1),
									BackgroundTransparency = 1,
									TextColor3 = map4.warn,  
									TextTransparency = 0.35,
									Font = gothamBlack,
									TextSize = 8,
									Text = "RISKY",
									ZIndex = 3,
									}, temp)
							end
						end
					end
					Frame7 = create("Frame", {  
						Size = UDim2.new(1, 0, 0, 31),
						BackgroundColor3 = map4.panel,
						BorderSizePixel = 0,
						LayoutOrder = 14,
						}, Frame6)
					addCorner(Frame7, 8)
					addStroke(Frame7, map4.line, 1, 0.16)
					do
						local events = makeLabel("EVENTS", 11, map4.sub, gothamBold, Enum.TextXAlignment.Left, Frame7)  
						events.Size = UDim2.new(1, -104, 1, 0)
						events.Position = UDim2.fromOffset(11, 0)
					end
				end
				local blockAll = makeButton("BLOCK ALL", Frame7)
				blockAll.Size = UDim2.fromOffset(88, 24)
				blockAll.Position = UDim2.new(1, -97, 0.5, -12)
				blockAll.TextSize = 10
				attachTooltip(blockAll, "Toggle blocking of all events")
				local cond = false
				local temp = nil  
				local text2 = nil
				local text3 = nil
				local num2 = 0
				local function refreshBlockButton()
					local cond2 = os.clock() < num2
					local stateKey = tostring(map3.ready) .. tostring(cond2)
					if stateKey == temp then
						return
					end  
					temp = stateKey
					blockAll.Text = cond2 and "BLOCKED" or "BLOCK ALL"
					blockAll.TextColor3 = not map3.ready and map4.sub or cond2 and map4.ok or map4.txt
				end
				blockAll.MouseButton1Click:Connect(function()
					if cond then
						return
					end
					if not map3.ready then
						local text4 = "err"  
						setStatus("events: " .. tostring(map3.why), text4)
						return
					end
					cond = true
					setStatus("blocking events...", "busy")
					task.spawn(function()
						local ok, result, result2 = pcall(map3.Block)
						if ok and result then
							result2 = result2 or "blocked"  
							text2 = result2
							text3 = "ok"
						else
							text2 = "events: " .. tostring(result2 or result)
							text3 = "err"
						end
						cond = false
					end)
				end)
				task.spawn(function()  
					while Frame7.Parent do
						if text2 then
							local value3 = text2
							local value4 = text3
							text2 = nil
							text3 = nil
							if value4 == "ok" then
								num2 = os.clock() + 1
							end
							pcall(setStatus, value3, value4)  
						end
						pcall(refreshBlockButton)
						task.wait(0.2)
					end
				end)
				refreshBlockButton()
			end
		end
	end  
	do
		local setKeybindRowsVisible, Settings2
		do
			do
				do
					local num2 = 548
					local num3 = 36
					local rowStates = {}
					local map5 = {}
					local num4 = 0  
					local function toggleAccordion(arg, arg2, arg3)
						local cond = rowStates[arg]
						if cond == nil then
							cond = true
						end
						if cond == arg2 then
							return
						end
						rowStates[arg] = arg2
						local value3 = (map5[arg] or 0) + 1  
						map5[arg] = value3
						num4 = math.max(0, num4 + (arg2 and -1 or 1))
						windowHeight = num2 - num4 * num3
						if not visible then
							if arg3 then
								Main.Size = UDim2.fromOffset(316, windowHeight)
							else
								tween(Main, 0.2, { Size = UDim2.fromOffset(316, windowHeight) }, Enum.EasingStyle.Quart)
							end  
						end
						arg.ClipsDescendants = true
						if arg2 then
							arg.Visible = true
							if arg3 then
								arg.Size = UDim2.new(1, 0, 0, 31)
								arg.ClipsDescendants = false
								return
							end
							arg.Size = UDim2.new(1, 0, 0, 0)  
							tween(arg, 0.2, { Size = UDim2.new(1, 0, 0, 31) }, Enum.EasingStyle.Quart)
							task.delay(0.22, function()
								if map5[arg] == value3 then
									arg.ClipsDescendants = false
								end
							end)
						elseif arg3 then
							arg.Size = UDim2.new(1, 0, 0, 0)
							arg.Visible = false
							return  
						else
							tween(arg, 0.2, { Size = UDim2.new(1, 0, 0, 0) }, Enum.EasingStyle.Quart)
							task.delay(0.22, function()
								if map5[arg] == value3 then
									arg.Visible = false
								end
							end)
						end
					end
					setWordsRowVisible = function(arg)  
						toggleAccordion(words, not manual, arg)
					end
					setKeybindRowsVisible = function(arg)
						toggleAccordion(Frame5, showKeybinds, arg)
						toggleAccordion(Frame4, showKeybinds, arg)
					end
				end
			end
			do  
				local value3
				Settings2, value3 = makeWindow("Settings", 300, isTouch and 360 or 330, "SETTINGS")
				Settings2.Visible = false
				Settings2.Parent = ScreenGui
				local button = makeButton("X", value3)
				button.Size = UDim2.fromOffset(22, 22)
				button.Position = UDim2.new(1, -28, 0.5, -11)
				button.TextSize = 12
				button.MouseButton1Click:Connect(function()  
					Settings2.Visible = false
				end)
			end
		end
		local Frame6
		do
			Frame6 = create("ScrollingFrame", {
				Size = UDim2.new(1, -20, 1, -60),
				Position = UDim2.fromOffset(10, 52),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				CanvasSize = UDim2.new(),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ScrollBarThickness = 3,
				ScrollBarImageColor3 = map4.line,
				ScrollBarImageTransparency = 0.15,
				ElasticBehavior = Enum.ElasticBehavior.WhenScrollable,
				}, Settings2)
			create("UIPadding", {
				PaddingRight = UDim.new(0, 8),
				PaddingBottom = UDim.new(0, 12),
				}, Frame6)
			create("UIListLayout", {
				Padding = UDim.new(0, 5),
				SortOrder = Enum.SortOrder.LayoutOrder,
				}, Frame6)
			local function addSection(order, title, tip)
				local lbl = makeLabel(title, 10, map4.acc, gothamBold, Enum.TextXAlignment.Left, Frame6)
				lbl.Name = title
				lbl.Size = UDim2.new(1, -2, 0, 17)
				lbl.LayoutOrder = order
				if tip then
					attachTooltip(lbl, tip)
				end
				return lbl
			end
			addSection(1, "BEHAVIOR", "Core automation behaviour")
			addToggle(Frame6, 2, "AUTO LISTEN", autoListen, function(arg)
				autoListen = arg
				_G.__RdmCfgSet("autoListen", arg)  
			end, "Listen to chat and capture codes automatically")
			addToggle(Frame6, 3, "SPAM ON LISTEN", spamOnListen, function(arg)
				spamOnListen = arg
				_G.__RdmCfgSet("spamOnListen", arg)
			end, "Try a captured code as soon as it is heard")
			addToggle(Frame6, 4, "SHOW KEYBINDS", showKeybinds, function(arg)
				showKeybinds = arg
				setKeybindRowsVisible()
				_G.__RdmCfgSet("showKeybinds", arg)
			end, "Show or hide the keybind panel")
			addToggle(Frame6, 5, "IGNORE SYSTEM PHRASES", ignoreSystem, function(arg)
				ignoreSystem = arg
				_G.__RdmCfgSet("ignoreSystem", arg)
			end, "Skip server notices and non-code messages")
			addToggle(Frame6, 7, "CODE SPACES", codeSpaces, function(arg)
				codeSpaces = arg
				_G.__RdmCfgSet("codeSpaces", arg)
			end, "Join captured words with spaces before redeeming")
			do
				local toggle = addToggle(Frame6, 6, "DUO MODE (WITH RIDDLER)", _G.__RdmDuo, function(rdmDuo)
					_G.__RdmDuo = rdmDuo
					_G.__RdmCfgSet("duo", rdmDuo)
					if _G.__SabDuoSync then  
						_G.__SabDuoSync()
					end
					return
				end, "Team up with Riddler for combined redeeming")
				local label = makeLabel("0/2", 10, map4.sub, gothamBold, Enum.TextXAlignment.Right, toggle)
				label.Size = UDim2.fromOffset(50, 31)
				label.Position = UDim2.new(1, -84, 0, 0)
				for _, child in ipairs(toggle:GetChildren()) do
					if child:IsA("TextLabel") and child ~= label then
						child.Size = UDim2.new(1, -100, 1, 0)  
					end
				end
				local function redeemer()
					local value3 = (_G.__RiddlerDuo and 1 or 0) + (_G.__RdmDuo and 1 or 0)
					label.Text = value3 .. "/2"
					label.TextColor3 = value3 == 2 and map4.acc or value3 == 1 and (map4.warn or map4.sub) or map4.sub
				end
				redeemer()
				_G.__SabDuoRefresh = _G.__SabDuoRefresh or {}
				_G.__SabDuoRefresh.redeemer = redeemer  
				_G.__SabDuoSync = function()
					local value3 = pairs
					local sabDuoRefresh = _G.__SabDuoRefresh or {}
					for _, value4 in value3(sabDuoRefresh) do
						pcall(value4)
					end
				end
				_G.__SabDuoSync()
				task.spawn(function()  
					while toggle.Parent do
						redeemer()
						task.wait(1)
					end
				end)
			end
			do
				local function addPickRow(order, title, options, current, onPick, tip)
					local row = create("Frame", {
						Size = UDim2.new(1, 0, 0, 31),
						BackgroundColor3 = map4.panel,
						BorderSizePixel = 0,
						LayoutOrder = order,
						}, Frame6)
					addCorner(row, 8)
					addStroke(row, map4.line, 1, 0.16)
					local lbl = makeLabel(title, 11, map4.sub, gothamBold, Enum.TextXAlignment.Left, row)
					lbl.Size = UDim2.fromOffset(96, 31)
					lbl.Position = UDim2.fromOffset(11, 0)
					local holder = create("Frame", {
						Size = UDim2.fromOffset(168, 23),
						Position = UDim2.new(1, -177, 0.5, -11.5),
						BackgroundColor3 = map4.input,
						BorderSizePixel = 0,
						}, row)
					addCorner(holder, 7)
					local buttons = {}
					local function pick(value)
						for k, btn in pairs(buttons) do
							local on = k == value
							tween(btn, 0.12, { BackgroundColor3 = on and map4.acc or map4.input })
							btn.TextColor3 = on and Color3.fromRGB(255, 255, 255) or map4.sub
						end
						if onPick then
							onPick(value)
						end
					end
					for i, value in ipairs(options) do
						local btn = create("TextButton", {
							Size = UDim2.new(1 / #options, -2, 1, -2),
							Position = UDim2.new((i - 1) / #options, 1, 0, 1),
						BackgroundColor3 = map4.input,
						Text = value,
						Font = gothamBold,
						TextSize = 8,
						TextTruncate = Enum.TextTruncate.AtEnd,
						TextColor3 = map4.sub,
						AutoButtonColor = false,
						BorderSizePixel = 0,
						}, holder)
						addCorner(btn, 6)
						buttons[value] = btn
						btn.MouseButton1Click:Connect(function()
							playToggle()
							pick(value)
						end)
					end
					pick(current)
					if tip then
						attachTooltip(row, tip)
					end
					return row
				end
				addSection(8, "INTERFACE", "Look and feel")
				addPickRow(10, "THEME", { "TEAL", "BLUE", "PURPLE", "LIME", "RED", "LIGHT" }, theme, function(value)
					applyTheme(value)
				end, "Change the colour theme")
				addPickRow(11, "LANGUAGE", { "EN", "TR" }, lang, function(value)
					lang = value
					_G.__RdmCfgSet("lang", value)
					applyLang()
				end, "Switch the interface language")
				addToggle(Frame6, 12, "UI SOUND", uiSoundOn, function(arg)
					uiSoundOn = arg
					_G.__RdmCfgSet("uiSound", arg)
				end, "Play a sound on clicks and toggles")
			end
		end
		do
			local Frame7
			do  
				if isTouch then
					local Frame8
					do
						local Frame9 = create("Frame", {
							Size = UDim2.new(1, 0, 0, 31),
							BackgroundColor3 = map4.panel,
							BorderSizePixel = 0,
							LayoutOrder = 9,
							}, Frame6)
						addCorner(Frame9, 8)  
						addStroke(Frame9, map4.line, 1, 0.16)
						local uiSize = makeLabel("UI SIZE", 11, map4.sub, gothamBold, Enum.TextXAlignment.Left, Frame9)
						uiSize.Size = UDim2.fromOffset(70, 31)
						uiSize.Position = UDim2.fromOffset(11, 0)
						Frame8 = create("Frame", {
							Size = UDim2.fromOffset(168, 23),
							Position = UDim2.new(1, -177, 0.5, -11.5),
							BackgroundColor3 = map4.input,
							BorderSizePixel = 0,
							}, Frame9)  
					end
					addCorner(Frame8, 7)
					do
						local sizeButtons = {}
						local function selectSize(arg, arg2)
							for k, value3 in pairs(sizeButtons) do
								local cond = k == arg
								tween(value3, 0.12, { BackgroundColor3 = cond and map4.acc or map4.input })
								value3.TextColor3 = cond and Color3.fromRGB(255, 255, 255) or map4.sub  
							end
							if arg2 then
								return
							end
							_G.__RdmCfgSet("uiSize", arg)
							if map.refit then
								map.refit()
							end
						end
						local map5 = { "BIG", "MEDIUM", "SMALL" }  
						for i, value3 in ipairs(map5) do
							local TextButton2 = create("TextButton", {
								Size = UDim2.new(1 / #map5, -2, 1, -2),
								Position = UDim2.new((i - 1) / #map5, 1, 0, 1),
								BackgroundColor3 = map4.input,
								Text = value3,
								Font = gothamBold,
								TextSize = 9,
								TextColor3 = map4.sub,  
								AutoButtonColor = false,
								BorderSizePixel = 0,
								}, Frame8)
							addCorner(TextButton2, 6)
							sizeButtons[value3] = TextButton2
							TextButton2.MouseButton1Click:Connect(function()
								selectSize(value3)
							end)
						end  
						selectSize(_G.__RdmCfgStr("uiSize", "MEDIUM"), true)
					end
				end
				Frame7 = create("Frame", {
					Size = UDim2.new(1, 0, 0, 31),
					BackgroundColor3 = map4.panel,
					BorderSizePixel = 0,
					LayoutOrder = 6,
					}, Frame6)
				addCorner(Frame7, 8)  
				addStroke(Frame7, map4.line, 1, 0.16)
				do
					local autoBuy = makeLabel("AUTO BUY", 11, map4.sub, gothamBold, Enum.TextXAlignment.Left, Frame7)
					autoBuy.Size = UDim2.new(1, -70, 1, 0)
					autoBuy.Position = UDim2.fromOffset(12, 0)
				end
			end
			local open = makeButton("OPEN", Frame7)
			open.Size = UDim2.fromOffset(52, 22)  
			open.Position = UDim2.new(1, -60, 0.5, -11)
			open.TextSize = 10
			open.MouseButton1Click:Connect(function()
				Settings2.Visible = false
				if startAutoBuy then
					startAutoBuy()
				end
			end)
		end
		do
			local function toggleSettings()
				if isTouch then
					Settings2.Position = UDim2.new(0.5, -math.floor(Settings2.AbsoluteSize.X / 2), 0.5, -math.floor(Settings2.AbsoluteSize.Y / 2))
				else
					local position = Main.Position
					Settings2.Position = UDim2.new(position.X.Scale, position.X.Offset - Settings2.AbsoluteSize.X - 10, position.Y.Scale, position.Y.Offset)
				end
				Settings2.Visible = true
			end  
			openSettings = toggleSettings
			Settings.MouseButton1Click:Connect(function()
				if not Settings2.Visible then
					toggleSettings()
					return
				end
				Settings2.Visible = false
			end)
		end  
		setKeybindRowsVisible(true)
	end
	setWordsRowVisible(true)
end
local Frame4, useFeedCode, unusedHelper, antiRagState
do
	do
		do
			local Feed, value3, value4
			do  
				do
					local value5
					Feed, value5 = makeWindow("Feed", 300, 320, "LIVE FEED")
					Feed.Visible = false
					Feed.Parent = ScreenGui
					Frame4 = create("Frame", {
						Size = UDim2.fromOffset(8, 8),
						Position = UDim2.new(1, -176, 0.5, -4),
						BackgroundColor3 = map4.sub,
						BorderSizePixel = 0,  
						}, value5)
					addCorner(Frame4, 4)
					value3 = makeLabel("0 caught", 10, map4.sub, gothamBold, Enum.TextXAlignment.Right, value5)
					value3.Size = UDim2.fromOffset(80, 44)
					value3.Position = UDim2.new(1, -166, 0, 0)
					value4 = makeButton("CLEAR", value5)
					value4.Size = UDim2.fromOffset(40, 22)
					value4.Position = UDim2.new(1, -82, 0.5, -11)
					value4.TextSize = 10  
					local button = makeButton("X", value5)
					button.Size = UDim2.fromOffset(22, 22)
					button.Position = UDim2.new(1, -32, 0.5, -11)
					button.TextSize = 12
					button.MouseButton1Click:Connect(function()
						Feed.Visible = false
					end)
				end
			end
			local ScrollingFrame = create("ScrollingFrame", {  
				Size = UDim2.new(1, -18, 1, -56),
				Position = UDim2.fromOffset(11, 50),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = 3,
				ScrollBarImageColor3 = map4.acc,
				ScrollBarImageTransparency = 0.3,
				CanvasSize = UDim2.new(),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollingDirection = Enum.ScrollingDirection.Y,  
				}, Feed)
			create("UIListLayout", {
				Padding = UDim.new(0, 6),
				SortOrder = Enum.SortOrder.LayoutOrder,
				}, ScrollingFrame)
			local label = makeLabel("waiting for announcements...", 11, map4.sub, gothamMedium, Enum.TextXAlignment.Center, ScrollingFrame)
			label.Size = UDim2.new(1, 0, 0, 34)
			label.LayoutOrder = 999
			local map5 = {}  
			local num2 = 0
			useFeedCode = nil
			local function toggleFeed()
				if isTouch then
					Feed.Position = UDim2.new(0.5, -math.floor(Feed.AbsoluteSize.X / 2), 0.5, -math.floor(Feed.AbsoluteSize.Y / 2))
				else
					local position = Main.Position
					Feed.Position = UDim2.new(position.X.Scale, position.X.Offset - Feed.AbsoluteSize.X - 10, position.Y.Scale, position.Y.Offset)
				end  
				Feed.Visible = true
			end
			unusedHelper = function(arg, arg2)
				if label then
					label:Destroy()
					label = nil
				end
				num2 += 1
				value3.Text = num2 .. " caught"
				local Frame5 = create("Frame", {  
					Size = UDim2.new(1, -4, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = map4.panel,
					BorderSizePixel = 0,
					LayoutOrder = -num2,
					}, ScrollingFrame)
				addCorner(Frame5, 9)
				addStroke(Frame5, arg2 and map4.acc or map4.line, 1, arg2 and 0.3 or 0.5)
				create("UIPadding", {  
					PaddingTop = UDim.new(0, 8),
					PaddingBottom = UDim.new(0, 8),
					PaddingLeft = UDim.new(0, 10),
					PaddingRight = UDim.new(0, 10),
					}, Frame5)
				create("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }, Frame5)
				local uiFrame = create("Frame", { Size = UDim2.new(1, 0, 0, 12), BackgroundTransparency = 1, LayoutOrder = 1 }, Frame5)
				addCorner(create("Frame", {
					Size = UDim2.fromOffset(6, 6),
					Position = UDim2.new(0, 0, 0.5, -3),  
					BackgroundColor3 = arg2 and map4.acc or map4.sub,
					BorderSizePixel = 0,
					}, uiFrame), 3)
				makeLabel("NOTIFY", 8, map4.acc, gothamBlack, Enum.TextXAlignment.Left, uiFrame).Position = UDim2.fromOffset(12, 0)
				local sub = map4.sub
				local right = Enum.TextXAlignment.Right
				local label2 = makeLabel(os.date("%H:%M:%S"), 8, sub, gothamMedium, right, uiFrame)
				label2.Size = UDim2.new(0, 60, 1, 0)
				label2.Position = UDim2.new(1, -60, 0, 0)  
				local label3 = makeLabel(arg, 10, map4.txt, gothamMedium, Enum.TextXAlignment.Left, Frame5)
				label3.Size = UDim2.new(1, 0, 0, 0)
				label3.AutomaticSize = Enum.AutomaticSize.Y
				label3.TextWrapped = true
				label3.LayoutOrder = 2
				if arg2 then
					local Frame6 = create("Frame", {
						Size = UDim2.new(1, 0, 0, 24),
						BackgroundTransparency = 1,
						LayoutOrder = 3,  
						}, Frame5)
					local TextLabel = create("TextLabel", {
						Size = UDim2.new(0.5, -3, 1, 0),
						BackgroundColor3 = map4.input,
						Text = arg2,
						Font = gothamBlack,
						TextSize = 12,
						TextColor3 = map4.acc,
						BorderSizePixel = 0,  
						}, Frame6)
					addCorner(TextLabel, 6)
					addStroke(TextLabel, map4.acc, 1, 0.4)
					local copy = makeButton("COPY", Frame6)
					copy.Size = UDim2.new(0.22, -3, 1, 0)
					copy.Position = UDim2.new(0.52, 3, 0, 0)
					copy.TextSize = 9
					copy.MouseButton1Click:Connect(function()
						copy.Text = copyText(arg2) and "OK" or "ERR"
						task.delay(0.7, function()
							if copy.Parent then
								copy.Text = translate("COPY")
							end
						end)
					end)
					local accentButton = makeAccentButton("USE", Frame6)
					accentButton.Size = UDim2.new(0.26, -3, 1, 0)
					accentButton.Position = UDim2.new(0.74, 3, 0, 0)
					accentButton.TextSize = 10  
					accentButton.MouseButton1Click:Connect(function()
						accentButton.Text = "..."
						useFeedCode(arg2)
						accentButton.Text = "USE"
					end)
				end
				local entrance = create("UIScale", { Scale = 0.94 }, Frame5)
				tween(entrance, 0.3, { Scale = 1 }, Enum.EasingStyle.Back)
				table.insert(map5, Frame5)
				if #map5 > map.maxFeed then
					local value5 = table.remove(map5, 1)  
					if value5 then
						value5:Destroy()
					end
				end
			end
			value4.MouseButton1Click:Connect(function()
				for _, value5 in ipairs(map5) do
					value5:Destroy()
				end
				map5 = {}  
				num2 = 0
				value3.Text = "0 caught"
				if not label then
					label = makeLabel("waiting for announcements...", 11, map4.sub, gothamMedium, Enum.TextXAlignment.Center, ScrollingFrame)
					label.Size = UDim2.new(1, 0, 0, 34)
					label.LayoutOrder = 999
				end
			end)
			feedButton.MouseButton1Click:Connect(function()  
				if Feed.Visible then
					Feed.Visible = false
					return
				end
				toggleFeed()
			end)
		end
		do
			local value3, value4, TextBox2
			do  
				do
					local value5
					value3, value5 = makeWindow("Test", 300, 178, "FAKE NOTIFY")
					value3.Visible = false
					value3.Parent = ScreenGui
					local button = makeButton("X", value5)
					button.Size = UDim2.fromOffset(22, 22)
					button.Position = UDim2.new(1, -28, 0.5, -11)
					button.TextSize = 12
					button.MouseButton1Click:Connect(function()  
						value3.Visible = false
					end)
				end
				do
					value4 = create("Frame", {
						Size = UDim2.new(1, -24, 1, -58),
						Position = UDim2.fromOffset(12, 50),
						BackgroundTransparency = 1,
						}, value3)
					create("UIListLayout", {  
						Padding = UDim.new(0, 8),
						SortOrder = Enum.SortOrder.LayoutOrder,
						}, value4)
					do
						local Frame5 = create("Frame", {
							Size = UDim2.new(1, 0, 0, 54),
							BackgroundColor3 = map4.panel,
							BorderSizePixel = 0,
							LayoutOrder = 1,  
							}, value4)
						addCorner(Frame5, 9)
						addStroke(Frame5, map4.line, 1, 0.16)
						local message = makeLabel("MESSAGE", 9, map4.acc, gothamBlack, Enum.TextXAlignment.Left, Frame5)
						message.Size = UDim2.new(1, -16, 0, 12)
						message.Position = UDim2.fromOffset(11, 6)
						TextBox2 = create("TextBox", {
							Size = UDim2.new(1, -18, 0, 26),
							Position = UDim2.fromOffset(9, 20),
							BackgroundColor3 = map4.input,  
							Text = "",
							PlaceholderText = "type a fake announcement...",
							PlaceholderColor3 = map4.sub,
							Font = gothamBlack,
							TextSize = 12,
							TextColor3 = map4.txt,
							ClearTextOnFocus = false,
							BorderSizePixel = 0,
							TextXAlignment = Enum.TextXAlignment.Left,
							}, Frame5)  
					end
				end
				addCorner(TextBox2, 7)
				do
					local stroke = addStroke(TextBox2, map4.line, 1.2, 0.25)
					create("UIPadding", {
						PaddingLeft = UDim.new(0, 9),
						PaddingRight = UDim.new(0, 9),
						}, TextBox2)  
					TextBox2.Focused:Connect(function()
						tween(stroke, 0.12, { Color = map4.acc, Transparency = 0 })
					end)
					TextBox2.FocusLost:Connect(function()
						tween(stroke, 0.12, { Color = map4.line, Transparency = 0.25 })
					end)
				end
			end
			local testCode, send  
			do
				local uiFrame = create("Frame", {
					Size = UDim2.new(1, 0, 0, 34),
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					}, value4)
				testCode = makeButton("TEST CODE", uiFrame)
				testCode.Size = UDim2.new(0.4, -4, 1, 0)
				attachTooltip(testCode, "Fill the redeem box with this code")
				send = makeAccentButton("SEND", uiFrame)
				attachTooltip(send, "Send this code to an announce channel")
			end  
			send.Size = UDim2.new(0.6, -4, 1, 0)
			send.Position = UDim2.new(0.4, 4, 0, 0)
			do
				local label = makeLabel("", 10, map4.sub, gothamMedium, Enum.TextXAlignment.Left, value4)
				label.Size = UDim2.new(1, -4, 0, 14)
				label.LayoutOrder = 3
				local function sendFakeNotify(arg)
					local localTest = trimText(arg)
					if localTest == "" then  
						label.Text = "nothing to send"
						label.TextColor3 = map4.err
						return
					end
					if not (notifyRemote and not autoStarted and typeof(firesignal) == "function") then
						local ok = pcall(handleAnnouncement, localTest, nil, nil, "Top", 2678001507)
						label.Text = ok and "local test: " .. localTest or "handler error"
						label.TextColor3 = ok and map4.ok or map4.err
						return  
					end
					local ok = pcall(firesignal, notifyRemote.OnClientEvent, localTest, nil, nil, "Top", 2678001507)
					label.Text = ok and "fired: " .. localTest or "firesignal failed"
					label.TextColor3 = ok and map4.ok or map4.err
					return
				end
				send.MouseButton1Click:Connect(function()
					sendFakeNotify(TextBox2.Text)
					TextBox2.Text = ""
					TextBox2:CaptureFocus()  
				end)
				TextBox2.FocusLost:Connect(function(enterPressed)
					if enterPressed then
						sendFakeNotify(TextBox2.Text)
						TextBox2.Text = ""
						TextBox2:CaptureFocus()
					end
				end)
				testCode.MouseButton1Click:Connect(function()
					sendFakeNotify("TESTCODE" .. tostring(math.random(1000, 9999)))  
				end)
			end
			testButton.MouseButton1Click:Connect(function()
				if value3.Visible then
					value3.Visible = false
					return
				end
				if isTouch then
					value3.Position = UDim2.new(0.5, -math.floor(value3.AbsoluteSize.X / 2), 0.5, -math.floor(value3.AbsoluteSize.Y / 2))
				else  
					local position = Main.Position
					value3.Position = UDim2.new(position.X.Scale, position.X.Offset - value3.AbsoluteSize.X - 10, position.Y.Scale, position.Y.Offset + Main.AbsoluteSize.Y - value3.AbsoluteSize.Y)
				end
				value3.Visible = true
			end)
		end
	end
	do
		local isRagdollForce, isRagdollName, getCharacter, isJumpPaused, destroyWelds, weldCharacter, setRagdollStates, stripConstraints, enableMotors, setNetworkOwner  
		local stabilizeCharacter
		do
			do
				if _G.__AntiRagdollToggleCleanup then
					pcall(_G.__AntiRagdollToggleCleanup)
				end
				antiRagState = {
					Enabled = false,
					Connections = {},
					Welds = {},  
					LastPosition = nil,
					JumpPauseUntil = 0,
					JumpPauseDuration = 0.6,
					KnockbackThreshold = 35,
					MaxUpwardVelocity = 60,
					MaxHorizontalVelocity = 12,
					MaxFrameDisplacement = 10,
				}
				do  
					local map5 = {
						"ragdoll",
						"knock",
						"launch",
						"stun",
						"fall",
						"down",
						"flop",
						"trip",
						"push",  
						"shove",
						"blast",
						"force",
					}
					local map6 = {
						"BodyVelocity",
						"BodyPosition",
						"BodyGyro",
						"BodyForce",
						"BodyAngularVelocity",  
						"RocketPropulsion",
						"BodyThrust",
						"LinearVelocity",
						"AngularVelocity",
						"VectorForce",
						"Torque",
					}
					isRagdollForce = function(arg)
						for _, value3 in ipairs(map6) do  
							if arg:IsA(value3) then
								return true
							end
						end
						return false
					end
					isRagdollName = function(arg)
						local text2 = arg:lower()
						for _, value3 in ipairs(map5) do
							if text2:find(value3) then  
								return true
							end
						end
						return false
					end
				end
			end
			getCharacter = function()
				local character = player.Character  
				if character then
					local humanoid = character:FindFirstChildOfClass("Humanoid")
					local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
					local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
					if humanoid and humanoidRootPart and animator then
						return character, humanoid, humanoidRootPart, animator
					end
					return
				end
			end  
			isJumpPaused = function(arg)
				local jumpPauseUntil = antiRagState.JumpPauseUntil
				if tick() < jumpPauseUntil then
					return true
				end
				if arg then
					local state = arg:GetState()
					if state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall then
						return true  
					end
				end
				return false
			end
			destroyWelds = function()
				for _, weld in ipairs(antiRagState.Welds) do
					pcall(function()
						weld:Destroy()
					end)  
				end
				antiRagState.Welds = {}
			end
			weldCharacter = function(arg, part0)
				if not arg or not part0 then
					return
				end
				destroyWelds()
				for _, descendant in ipairs(arg:GetDescendants()) do
					if descendant:IsA("BasePart") and descendant ~= part0 then  
						local instance = Instance.new("WeldConstraint")
						instance.Name = "AntiRagdollWeld"
						instance.Part0 = part0
						instance.Part1 = descendant
						instance.Parent = part0
						table.insert(antiRagState.Welds, instance)
					end
				end
			end
			setRagdollStates = function(arg, arg2)  
				pcall(function()
					arg:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, arg2)
					arg:SetStateEnabled(Enum.HumanoidStateType.Physics, arg2)
					arg:SetStateEnabled(Enum.HumanoidStateType.FallingDown, arg2)
					arg:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, arg2)
				end)
			end
			stripConstraints = function(arg, arg2)
				if not arg then  
					return
				end
				for _, descendant in ipairs(arg:GetDescendants()) do
					if descendant:IsA("BallSocketConstraint") or descendant:IsA("HingeConstraint") or descendant:IsA("RopeConstraint") or descendant:IsA("RodConstraint") then
						pcall(function()
							descendant:Destroy()
						end)
					elseif isRagdollForce(descendant) then
						local parent = descendant.Parent
						local name = parent and parent.Name or ""  
						if parent == arg2 or isRagdollName(descendant.Name) or isRagdollName(name) then
							pcall(function()
								descendant:Destroy()
							end)
						end
					end
				end
			end
			enableMotors = function(arg)
				if not arg then  
					return
				end
				for _, descendant in ipairs(arg:GetDescendants()) do
					if descendant:IsA("Motor6D") then
						descendant.Enabled = true
					end
				end
			end
			do
				local function helper(arg, arg2)  
					if not arg then
						return
					end
					for _, descendant in ipairs(arg:GetDescendants()) do
						if descendant:IsA("BasePart") then
							if descendant == arg2 then
								descendant.CanCollide = false
								descendant.Massless = false
								pcall(function()  
									descendant.CustomPhysicalProperties = PhysicalProperties.new(50, 0.3, 0.5, 100, 100)
								end)
							else
								descendant.CanCollide = false
								descendant.Massless = true
							end
						end
					end
				end
				setNetworkOwner = function(arg)
					pcall(function()
						if arg:CanSetNetworkOwnership() then
							arg:SetNetworkOwner(player)
						end
					end)
				end
				stabilizeCharacter = function(arg, cameraSubject, arg2)
					if not (not arg or not cameraSubject or cameraSubject.Health <= 0) then
						cameraSubject.PlatformStand = false  
						cameraSubject.Sit = false
						cameraSubject.AutoRotate = true
						cameraSubject.BreakJointsOnDeath = false
						cameraSubject.RequiresNeck = false
						if cameraSubject.WalkSpeed < 1 then
							cameraSubject.WalkSpeed = 16
						end
						if cameraSubject.JumpPower < 1 and cameraSubject.JumpHeight < 1 then
							cameraSubject.JumpPower = 50  
						end
						enableMotors(arg)
						helper(arg, arg2)
						local currentCamera = workspace.CurrentCamera
						if currentCamera and currentCamera.CameraSubject ~= cameraSubject then
							currentCamera.CameraSubject = cameraSubject
						end
						return
					end
				end  
			end
		end
		local clampVelocity, forceUpright
		do
			do
				local function stopRagAnimations(arg)
					local currentCamera = workspace.CurrentCamera
					currentCamera = currentCamera and currentCamera.CFrame.LookVector or arg.CFrame.LookVector
					local vector = Vector3.new(currentCamera.X, 0, currentCamera.Z)
					if vector.Magnitude < 0.05 then  
						local lookVector = arg.CFrame.LookVector
						vector = Vector3.new(lookVector.X, 0, lookVector.Z)
					end
					if vector.Magnitude < 0.05 then
						return Vector3.new(0, 0, -1)
					end
					return vector.Unit
				end
				clampVelocity = function(arg)
					local assemblyLinearVelocity = arg.AssemblyLinearVelocity  
					arg.AssemblyAngularVelocity = Vector3.zero
					local z = assemblyLinearVelocity.Z
					arg.AssemblyLinearVelocity = Vector3.new(math.clamp(assemblyLinearVelocity.X, -antiRagState.MaxHorizontalVelocity, antiRagState.MaxHorizontalVelocity), math.clamp(assemblyLinearVelocity.Y, -50, antiRagState.MaxUpwardVelocity), math.clamp(z, -antiRagState.MaxHorizontalVelocity, antiRagState.MaxHorizontalVelocity))
				end
				forceUpright = function(arg, arg2, arg3, arg4)
					if not arg or not arg2 or not arg3 or arg2.Health <= 0 then
						return
					end
					stabilizeCharacter(arg, arg2, arg3)
					local number = stopRagAnimations(arg3)  
					if not isJumpPaused(arg2) then
						clampVelocity(arg3)
					end
					arg3.CFrame = arg3.CFrame:Lerp(CFrame.lookAt(arg3.Position, arg3.Position + number), arg4 and 1 or 0.5)
					arg2.PlatformStand = false
					arg2.Sit = false
					arg2:ChangeState(Enum.HumanoidStateType.GettingUp)
					task.defer(function()
						if arg2.Parent and arg2.Health > 0 then  
							arg2:ChangeState(Enum.HumanoidStateType.Running)
						end
					end)
				end
			end
		end
		do
			local function helper(arg)
				if not arg then
					return  
				end
				for _, value3 in ipairs(arg:GetPlayingAnimationTracks()) do
					if isRagdollName(value3.Animation and value3.Animation.Name or "") then
						value3:Stop(0)
					end
				end
			end
			local function helper2(arg, arg2, arg3, arg4)
				if not arg or not arg2 or arg2.Health <= 0 then  
					return
				end
				stripConstraints(arg, arg3)
				stabilizeCharacter(arg, arg2, arg3)
				helper(arg4)
				setNetworkOwner(arg3)
				pcall(function()
					local playerModule = player.PlayerScripts:FindFirstChild("PlayerModule")
					if playerModule then
						local controls = require(playerModule):GetControls()  
						if controls then
							controls:Enable()
						end
					end
				end)
			end
			antiRagState.Disable = function(arg)
				arg.Enabled = false
				arg.LastPosition = nil
				arg.JumpPauseUntil = 0  
				for _, connection in ipairs(arg.Connections) do
					pcall(function()
						connection:Disconnect()
					end)
				end
				arg.Connections = {}
				destroyWelds()
				local _, humanoid2 = getCharacter()
				if humanoid2 then  
					setRagdollStates(humanoid2, true)
				end
			end
			antiRagState.Enable = function(arg)
				if arg.Enabled then
					return
				end
				arg.Enabled = true
				local character2, humanoid2, rootPart, animator2 = getCharacter()
				if not character2 then  
					arg.Enabled = false
					return
				end
				helper2(character2, humanoid2, rootPart, animator2)
				setRagdollStates(humanoid2, false)
				forceUpright(character2, humanoid2, rootPart, true)
				weldCharacter(character2, rootPart)
				arg.LastPosition = rootPart.Position
				table.insert(arg.Connections, UserInputService.JumpRequest:Connect(function()  
					if not arg.Enabled then
						return
					end
					local jumpPauseDuration = arg.JumpPauseDuration
					arg.JumpPauseUntil = tick() + jumpPauseDuration
				end))
				table.insert(arg.Connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
					if not arg.Enabled or gameProcessed then
						return
					end  
					if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
						local jumpPauseDuration = arg.JumpPauseDuration
						arg.JumpPauseUntil = tick() + jumpPauseDuration
					end
				end))
				table.insert(arg.Connections, RunService.Stepped:Connect(function()
					if not arg.Enabled then
						return
					end  
					local character3, humanoid3, rootPart2 = getCharacter()
					if not character3 or humanoid3.Health <= 0 then
						return
					end
					if not isJumpPaused(humanoid3) then
						clampVelocity(rootPart2)
					end
					setNetworkOwner(rootPart2)
				end))
				table.insert(arg.Connections, RunService.Heartbeat:Connect(function()  
					if not arg.Enabled then
						return
					end
					local character3, humanoid3, rootPart2, animator3 = getCharacter()
					if not character3 or humanoid3.Health <= 0 then
						return
					end
					setRagdollStates(humanoid3, false)
					stabilizeCharacter(character3, humanoid3, rootPart2)
					stripConstraints(character3, rootPart2)  
					local value3 = isJumpPaused(humanoid3)
					local state = humanoid3:GetState()
					local cond = state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.PlatformStanding or state == Enum.HumanoidStateType.Seated
					local cond2 = rootPart2.CFrame.UpVector.Y < 0.85
					if cond or cond2 then
						forceUpright(character3, humanoid3, rootPart2, cond2 and rootPart2.CFrame.UpVector.Y < 0.5)
						helper(animator3)
					end
					if value3 then  
						arg.LastPosition = rootPart2.Position
						return
					end
					if arg.LastPosition then
						local value4 = rootPart2.Position - arg.LastPosition
						local vector = Vector3.new(value4.X, 0, value4.Z)
						if arg.MaxFrameDisplacement < vector.Magnitude then
							local value5 = arg.LastPosition + vector.Unit * arg.MaxFrameDisplacement
							rootPart2.CFrame = CFrame.new(value5.X, rootPart2.Position.Y, value5.Z) * (rootPart2.CFrame - rootPart2.Position)
							rootPart2.AssemblyLinearVelocity = Vector3.zero  
							rootPart2.AssemblyAngularVelocity = Vector3.zero
						end
					end
					arg.LastPosition = rootPart2.Position
					if arg.KnockbackThreshold < rootPart2.AssemblyLinearVelocity.Magnitude then
						rootPart2.AssemblyLinearVelocity = Vector3.zero
						rootPart2.AssemblyAngularVelocity = Vector3.zero
						helper2(character3, humanoid3, rootPart2, animator3)
					else  
						clampVelocity(rootPart2)
					end
				end))
				table.insert(arg.Connections, humanoid2.StateChanged:Connect(function(old, new)
					if not arg.Enabled then
						return
					end
					if ({
						[Enum.HumanoidStateType.Ragdoll] = true,
						[Enum.HumanoidStateType.Physics] = true,  
						[Enum.HumanoidStateType.FallingDown] = true,
						[Enum.HumanoidStateType.PlatformStanding] = true,
					})[new] then
						humanoid2.PlatformStand = false
						humanoid2.Sit = false
						humanoid2:ChangeState(Enum.HumanoidStateType.GettingUp)
						humanoid2:ChangeState(Enum.HumanoidStateType.Running)
						local character3, humanoid3, rootPart2, animator3 = getCharacter()
						if character3 then  
							helper2(character3, humanoid3, rootPart2, animator3)
							forceUpright(character3, humanoid3, rootPart2, true)
						end
					end
				end))
				table.insert(arg.Connections, character2.DescendantAdded:Connect(function(descendant)
					if not arg.Enabled then
						return
					end
					if descendant:IsA("Motor6D") then  
						descendant.Enabled = true
						return
					end
					if descendant:IsA("BasePart") then
						task.wait()
						local character3, humanoid3, rootPart2 = getCharacter()
						if character3 and rootPart2 and descendant ~= rootPart2 and descendant.Parent then
							local weldConstraint = Instance.new("WeldConstraint")
							weldConstraint.Name = "AntiRagdollWeld"  
							weldConstraint.Part0 = rootPart2
							weldConstraint.Part1 = descendant
							weldConstraint.Parent = rootPart2
							table.insert(antiRagState.Welds, weldConstraint)
						end
						return
					end
					if descendant:IsA("BallSocketConstraint") or descendant:IsA("HingeConstraint") or descendant:IsA("RopeConstraint") or descendant:IsA("RodConstraint") then
						task.wait()
						pcall(function()  
							descendant:Destroy()
						end)
						return
					end
					if isRagdollForce(descendant) then
						local character3, humanoid3, rootPart2 = getCharacter()
						local name = descendant.Parent and descendant.Parent.Name or ""
						local cond = descendant.Parent == rootPart2
						local value3 = isRagdollName(descendant.Name) or isRagdollName(name)  
						if cond or value3 then
							task.wait()
							pcall(function()
								descendant:Destroy()
							end)
						end
					end
				end))
				table.insert(arg.Connections, character2.DescendantRemoving:Connect(function(descendant)  
					if not arg.Enabled then
						return
					end
					if descendant:IsA("Motor6D") then
						task.defer(function()
							local character = player.Character
							if character then
								enableMotors(character)
							end
						end)  
					end
				end))
				table.insert(arg.Connections, player.CharacterAdded:Connect(function()
					task.wait(1)
					if arg.Enabled then
						arg:Disable()
						arg:Enable()
					end
				end))  
			end
		end
	end
end
local toggleAntiRagdoll
do
	do
		local AntiRagdoll
		do
			do  
				do
					local function clearRagBillboard()
						local ragCountdownBillboard = hud:FindFirstChild("RagCountdownBillboard")
						if ragCountdownBillboard then
							ragCountdownBillboard:Destroy()
						end
					end
					clearRagBillboard()
					antiRagState.Disable = function(arg)  
						arg.Enabled = false
						arg.ResetCooldown = 0
						clearRagBillboard()
						if arg.V2Connection then
							arg.V2Connection:Disconnect()
							arg.V2Connection = nil
						end
					end
				end  
			end
			antiRagState.Enable = function(arg)
				if arg.V2Connection then
					return
				end
				arg.Enabled = true
				arg.ResetCooldown = 0
				arg.V2Connection = RunService.Heartbeat:Connect(function()
					if not arg.Enabled then
						return  
					end
					local character = player.Character
					if not character then
						return
					end
					local humanoid = character:FindFirstChildOfClass("Humanoid")
					local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
					if not humanoid or not humanoidRootPart or humanoid.Health <= 0 then
						return
					end  
					local state = humanoid:GetState()
					local now2 = tick()
					if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
						if now2 - arg.ResetCooldown > 0.15 then
							arg.ResetCooldown = now2
							pcall(function()
								humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
								humanoidRootPart.Velocity = Vector3.zero
								humanoidRootPart.RotVelocity = Vector3.zero
								humanoidRootPart.AssemblyLinearVelocity = Vector3.zero  
								humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
								for _, descendant in ipairs(character:GetDescendants()) do
									if descendant:IsA("Motor6D") then
										descendant.Enabled = true
									end
									if descendant:IsA("Weld") then
										descendant.Enabled = true
									end
								end  
								workspace.CurrentCamera.CameraSubject = humanoid
								local playerModule = player.PlayerScripts:FindFirstChild("PlayerModule")
								playerModule = playerModule and playerModule:FindFirstChild("ControlModule")
								if playerModule then
									local module = require(playerModule)
									if module and module.Enable then
										module:Enable()
									end
								end
								humanoid.AutoRotate = true  
								humanoid.PlatformStand = false
								humanoid.Sit = false
							end)
						end
					end
				end)
			end
			_G.__AntiRagdollToggleCleanup = function()
				pcall(function()  
					antiRagState:Disable()
				end)
			end
			do
				local value3
				AntiRagdoll, value3 = makeWindow("AntiRagdoll", 260, 180, "ANTI RAGDOLL")
				AntiRagdoll.Visible = false
				AntiRagdoll.Parent = ScreenGui
				local button = makeButton("X", value3)
				button.Size = UDim2.fromOffset(22, 22)  
				button.Position = UDim2.new(1, -28, 0.5, -11)
				button.TextSize = 12
				button.MouseButton1Click:Connect(function()
					AntiRagdoll.Visible = false
				end)
			end
		end
		local Frame5, Frame6, value3
		do
			Frame5 = create("Frame", {  
				Size = UDim2.new(1, -24, 1, -58),
				Position = UDim2.fromOffset(12, 50),
				BackgroundTransparency = 1,
				}, AntiRagdoll)
			create("UIListLayout", {
				Padding = UDim.new(0, 8),
				SortOrder = Enum.SortOrder.LayoutOrder,
				}, Frame5)
			do
				local Frame7 = create("Frame", {  
					Size = UDim2.new(1, 0, 0, 38),
					BackgroundColor3 = map4.panel,
					BorderSizePixel = 0,
					LayoutOrder = 1,
					}, Frame5)
				addCorner(Frame7, 9)
				addStroke(Frame7, map4.line, 1, 0.16)
				Frame6 = create("Frame", {
					Size = UDim2.fromOffset(8, 8),
					Position = UDim2.new(0, 12, 0.5, -4),  
					BackgroundColor3 = map4.err,
					BorderSizePixel = 0,
					}, Frame7)
				addCorner(Frame6, 4)
				value3 = makeLabel("disabled", 12, map4.txt, gothamBold, Enum.TextXAlignment.Left, Frame7)
			end
		end
		local enable
		do  
			value3.Size = UDim2.new(1, -32, 1, 0)
			value3.Position = UDim2.fromOffset(28, 0)
			enable = makeAccentButton("ENABLE", Frame5)
			enable.Size = UDim2.new(1, 0, 0, 36)
			enable.LayoutOrder = 2
			enable.TextColor3 = Color3.fromRGB(0, 0, 0)
			do
				local label = makeLabel("rigidifies your character and strips ragdoll forces / states", 10, map4.sub, gothamMedium, Enum.TextXAlignment.Left, Frame5)
				label.Size = UDim2.new(1, 0, 0, 30)
				label.LayoutOrder = 3  
				label.TextWrapped = true
			end
		end
		do
			local function updateRagStatus()
				local enabled = antiRagState.Enabled
				value3.Text = enabled and "enabled - staying upright" or "disabled"
				value3.TextColor3 = enabled and map4.ok or map4.sub
				Frame6.BackgroundColor3 = enabled and map4.ok or map4.err
				enable.Text = enabled and "DISABLE" or "ENABLE"
				local ragIcon = iconButtons[Rag]
				if ragIcon then
					ragIcon.active = enabled
					ragIcon.render()
				end
			end
			enable.MouseButton1Click:Connect(function()
				if antiRagState.Enabled then
					antiRagState:Disable()
				else
					antiRagState:Enable()
				end
				updateRagStatus()  
			end)
			Rag.MouseButton1Click:Connect(function()
				if AntiRagdoll.Visible then
					AntiRagdoll.Visible = false
					return
				end
				if isTouch then
					AntiRagdoll.Position = UDim2.new(0.5, -math.floor(AntiRagdoll.AbsoluteSize.X / 2), 0.5, -math.floor(AntiRagdoll.AbsoluteSize.Y / 2))
				else  
					local position = Main.Position
					AntiRagdoll.Position = UDim2.new(position.X.Scale, position.X.Offset - AntiRagdoll.AbsoluteSize.X - 10, position.Y.Scale, position.Y.Offset + 96)
				end
				AntiRagdoll.Visible = true
			end)
			player.CharacterAdded:Connect(function()
				task.wait(1)
				updateRagStatus()
			end)
			updateRagStatus()  
		end
	end
	do
		local function initAutoBuy()
			local map5 = { Enabled = false }
			local map6 = {}
			local buyState = { animals = nil, game = nil, mutations = nil, traits = nil, tried = false }
			local function getUpvalueName(arg, arg2)
				local getupvalue_ = debug and debug.getupvalue or getupvalue  
				local upvalue, upvalue2 = getupvalue_(arg, arg2)
				return upvalue2 ~= nil and upvalue2 or upvalue
			end
			local function hasRawField(arg, arg2)
				for _, value9 in pairs(arg) do
					if type(value9) == "table" and tonumber(rawget(value9, arg2)) ~= nil then
						return true
					end
				end
				return false  
			end
			local function helper()
				if buyState.tried then
					return
				end
				buyState.tried = true
				local ok, result = pcall(require, ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Animals"))
				if ok then
					local text2 = "table"  
					ok = type(result) == text2
				end
				local value = ok and rawget(result, "GetGeneration") or nil
				if type(value) ~= "function" then
					return
				end
				for i = 1, 20 do
					local ok2, game_ = pcall(getUpvalueName, value, i)
					if ok2 and type(game_) == "table" then  
						local value2 = rawget(game_, "Game")
						if not buyState.game and type(value2) == "table" and tonumber(rawget(value2, "AnimalGanerationModifier")) then
							buyState.game = game_
						elseif not buyState.traits and hasRawField(game_, "MultiplierModifier") then
							buyState.traits = game_
						elseif not buyState.mutations and hasRawField(game_, "Modifier") then
							buyState.mutations = game_
						elseif not buyState.animals and (hasRawField(game_, "Generation") or hasRawField(game_, "Price")) then
							buyState.animals = game_
						end  
					end
				end
			end
			local function helper2(arg, arg2, arg3)
				local value = buyState.animals and rawget(buyState.animals, arg)
				if type(value) ~= "table" then
					return nil, nil
				end
				local num = tonumber(rawget(value, "Generation"))  
				if not num then
					local game_ = buyState.game
					if game_ then
						game_ = tonumber(rawget(rawget(buyState.game, "Game") or {}, "AnimalGanerationModifier"))
					end
					game_ = game_ or 0
					num = (tonumber(rawget(value, "Price")) or 0) * game_
				end
				local mutations = arg2 and buyState.mutations
				local num4 = 1  
				if mutations then
					local value2 = rawget(buyState.mutations, arg2)
					if type(value2) == "table" then
						num4 = 1 + (tonumber(rawget(value2, "Modifier")) or 0)
					end
				end
				local traits = type(arg3) == "table" and buyState.traits
				local cond = false
				if traits then  
					for _, value11 in ipairs(arg3) do
						if value11 == "Sleepy" then
							cond = true
						else
							local value2 = rawget(buyState.traits, value11)
							if type(value2) == "table" then
								num4 += tonumber(rawget(value2, "MultiplierModifier")) or 0
							end
						end  
					end
				end
				local value9 = num * num4
				local value10
				if cond then
					value10 = value9 * 0.5
				else
					value10 = value9
				end
				return math.round(value10), value  
			end
			local modelSet = {}
			local function indexModel(child)
				if child:IsA("Model") and child:GetAttribute("Index") ~= nil then
					modelSet[child] = true
				end
			end
			local connections = {}
			local onPromptChanged = nil  
			local resetBuyInfo = nil
			local function cleanupWatchers()
				for _, value9 in ipairs(connections) do
					pcall(function()
						value9:Disconnect()
					end)
				end
				connections = {}
				modelSet = {}  
				if resetBuyInfo then
					pcall(resetBuyInfo)
				end
			end
			local function helper3()
				if #connections > 0 then
					return
				end
				helper()
				for _, child in ipairs(workspace:GetChildren()) do  
					indexModel(child)
				end
				connections[#connections + 1] = workspace.ChildAdded:Connect(indexModel)
				connections[#connections + 1] = workspace.ChildRemoved:Connect(function(child)
					modelSet[child] = nil
				end)
				connections[#connections + 1] = RunService.Heartbeat:Connect(function(deltaTime)
					if onPromptChanged then
						onPromptChanged(deltaTime)
					end  
				end)
			end
			local function helper4(arg)
				local primaryPart = arg.PrimaryPart or arg:FindFirstChildWhichIsA("BasePart")
				if not primaryPart then
					return nil
				end
				local value9 = primaryPart:FindFirstChildOfClass("Attachment")
				value9 = value9 and value9:FindFirstChildOfClass("ProximityPrompt")  
				if value9 and value9.Enabled and value9.ActionText == "Purchase" then
					return value9, primaryPart
				end
				return nil
			end
			local function helper5()
				local character = localPlayer.Character
				character = character and character:FindFirstChild("HumanoidRootPart")
				if not character then
					return nil, nil, math.huge  
				end
				local huge = math.huge
				local temp2 = nil
				local temp3 = nil
				for k in pairs(modelSet) do
					if k.Parent == workspace then
						local value9, extra = helper4(k)
						if value9 then
							local magnitude = (character.Position - extra.Position).Magnitude  
							if magnitude < huge then
								huge = magnitude
								temp2 = k
								temp3 = value9
							end
						end
					else
						modelSet[k] = nil
					end
				end  
				return temp2, temp3, huge
			end
			local function formatNumber(arg)
				local num = tonumber(arg)
				if not num then
					return tostring(arg or "---")
				end
				local value9 = math.abs(num)
				for _, value10 in ipairs({ { 1000000000000, "T" }, { 1000000000, "B" }, { 1000000, "M" }, { 1000, "K" } }) do  
					if value10[1] <= value9 then
						local value11 = num / value10[1]
						return string.format(value11 >= 100 and "%.0f%s" or "%.1f%s", value11, value10[2])
					end
				end
				if num % 1 == 0 then
					return tostring(math.floor(num))
				end
				return string.format("%.1f", num)
			end  
			local function firePrompt(arg)
				if not arg or not arg.Parent or not arg.Enabled then
					return false, "prompt gone"
				end
				local text2 = "function"
				if type(fireproximityprompt) == text2 then
					local ok = pcall(fireproximityprompt, arg)
					return ok, ok and nil or "fire failed"
				end  
				local ok = pcall(function()
					arg:InputHoldBegin()
					local num4 = 0.05
					task.wait(math.max(arg.HoldDuration, 0.05) + num4)
					arg:InputHoldEnd()
				end)
				return ok, ok and nil or "hold failed"
			end
			local AutoBuy, header = makeWindow("AutoBuy", 300, 306, "AUTO BUY")  
			AutoBuy.Visible = false
			AutoBuy.Parent = ScreenGui
			local button = makeButton("X", header)
			button.Size = UDim2.fromOffset(22, 22)
			button.Position = UDim2.new(1, -28, 0.5, -11)
			button.TextSize = 12
			button.MouseButton1Click:Connect(function()
				AutoBuy.Visible = false
				if openSettings then
					openSettings()  
				end
			end)
			local Frame5 = create("Frame", {
				Size = UDim2.new(1, -24, 1, -58),
				Position = UDim2.fromOffset(12, 50),
				BackgroundTransparency = 1,
				}, AutoBuy)
			create("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, Frame5)
			local Frame6 = create("Frame", {  
				Size = UDim2.new(1, 0, 0, 32),
				BackgroundColor3 = map4.panel,
				BorderSizePixel = 0,
				LayoutOrder = 1,
				}, Frame5)
			addCorner(Frame6, 9)
			addStroke(Frame6, map4.line, 1, 0.16)
			local Frame7 = create("Frame", {
				Size = UDim2.fromOffset(8, 8),  
				Position = UDim2.new(0, 12, 0.5, -4),
				BackgroundColor3 = map4.line,
				BorderSizePixel = 0,
				}, Frame6)
			addCorner(Frame7, 4)
			local label = makeLabel("idle", 12, map4.sub, gothamBold, Enum.TextXAlignment.Left, Frame6)
			label.Size = UDim2.new(1, -32, 1, 0)
			label.Position = UDim2.fromOffset(28, 0)
			label.TextTruncate = Enum.TextTruncate.AtEnd
			local function setAutoStatus(text, arg)  
				label.Text = text
				local ok = arg == "ok" and map4.ok or arg == "err" and map4.err or arg == "busy" and map4.acc or arg == "wait" and map4.warn or map4.sub
				label.TextColor3 = ok
				Frame7.BackgroundColor3 = ok
			end
			addToggle(Frame5, 2, "AUTO BUY", false, function(enabled)
				map5.Enabled = enabled
				if enabled then
					helper3()  
				else
					cleanupWatchers()
				end
				if not enabled then
					setAutoStatus("idle", nil)
				else
					setAutoStatus("armed - looking for a buy...", "wait")
				end
			end)
			local nearestBuyable = makeLabel("NEAREST BUYABLE", 9, map4.acc, gothamBlack, Enum.TextXAlignment.Left, Frame5)  
			nearestBuyable.Size = UDim2.new(1, 0, 0, 14)
			nearestBuyable.LayoutOrder = 3
			local function addInfoLine(layoutOrder, arg, arg2, arg3)
				local label2 = makeLabel(arg, 11, arg2 or map4.sub, gothamBold, Enum.TextXAlignment.Left, Frame5)
				label2.Size = UDim2.new(1, 0, 0, arg3 or 16)
				label2.LayoutOrder = layoutOrder
				label2.TextTruncate = Enum.TextTruncate.AtEnd
				return label2
			end  
			local value3 = addInfoLine(4, "Name: ---", map4.txt)
			local value4 = addInfoLine(5, "Income: --- /sec", map4.acc)
			local value5 = addInfoLine(6, "Rarity: ---")
			local value6 = addInfoLine(7, "Mutation: ---")
			local value7 = addInfoLine(8, "Traits: ---", map4.sub, 30)
			value7.TextWrapped = true
			value7.TextYAlignment = Enum.TextYAlignment.Top
			local value8 = addInfoLine(9, "Distance: ---", map4.sub, 14)
			value8.TextSize = 9
			resetBuyInfo = function()  
				value3.Text = "Name: ---"
				value4.Text = "Income: --- /sec"
				value5.Text = "Rarity: ---"
				value6.Text = "Mutation: ---"
				value7.Text = "Traits: ---"
				value8.Text = "Distance: ---"
			end
			local function updateBuyInfo(arg, arg2, arg3)
				if not (arg and arg2) then  
					resetBuyInfo()
					return
				end
				local attribute = arg:GetAttribute("Index")
				local attribute2 = arg:GetAttribute("Mutation")
				local attribute3 = arg:GetAttribute("Traits")
				local text2 = "string"
				local traitList
				if type(attribute3) == text2 and attribute3 ~= "" then
					traitList = { attribute3 }  
				else
					traitList = attribute3
				end
				local income, entry = helper2(attribute, attribute2, traitList)
				local value = entry and rawget(entry, "Price")
				value3.Text = "Name: " .. tostring(entry and rawget(entry, "DisplayName") or attribute or arg2.ObjectText or "---") .. (value and " ($" .. formatNumber(value) .. ")" or "")
				value4.Text = "Income: " .. formatNumber(income) .. " /sec"
				value5.Text = "Rarity: " .. tostring(entry and rawget(entry, "Rarity") or "---")
				value6.Text = "Mutation: " .. tostring(attribute2 or "---")  
				value7.Text = "Traits: " .. (type(traitList) == "table" and #traitList > 0 and table.concat(traitList, ", ") or "---")
				value8.Text = string.format("Distance: %.1f studs", arg3)
			end
			local temp = nil
			local num2 = 0
			local num3 = 0
			local cond = false
			onPromptChanged = function(arg)
				if not map5.Enabled then
					if cond then  
						resetBuyInfo()
						cond = false
					end
					return
				end
				num3 += arg
				if num3 < 0.2 then
					return
				end  
				num3 = 0
				local value9, value10, value11 = helper5()
				updateBuyInfo(value9, value10, value11)
				cond = value10 ~= nil
				if value10 then
					if value11 > (value10.MaxActivationDistance or 10) + 2 then
						setAutoStatus("move closer to buy", "wait")
						return
					end
					if value10 ~= temp or os.clock() - num2 >= 1.2 then  
						local now2 = os.clock()
						temp = value10
						num2 = now2
						setAutoStatus("buying...", "busy")
						task.spawn(function()
							local ok22, message2 = firePrompt(value10)
							if ok22 then
								setAutoStatus("bought!", "ok")
							elseif map5.Enabled then
								setAutoStatus(message2 or "buy failed", "err")  
							end
						end)
					end
					return
				end
				setAutoStatus("no buy prompt in range", "wait")
			end
			startAutoBuy = function()
				if isTouch then
					local num4 = 0.5  
					AutoBuy.Position = UDim2.new(0.5, -math.floor(AutoBuy.AbsoluteSize.X / 2), num4, -math.floor(AutoBuy.AbsoluteSize.Y / 2))
				else
					local position = Main.Position
					AutoBuy.Position = UDim2.new(position.X.Scale, position.X.Offset - AutoBuy.AbsoluteSize.X - 10, position.Y.Scale, position.Y.Offset)
				end
				AutoBuy.Visible = true
			end
			stopAutoBuy = function()
				map5.Enabled = false  
				cleanupWatchers()
				for _, value9 in ipairs(map6) do
					pcall(function()
						value9:Disconnect()
					end)
				end
				map6 = {}
			end
		end
		initAutoBuy()  
	end
	do
		local text2, value3
		do
			text2 = ""
			value3 = 0
			do
				local function onNotification(descendant)
					task.defer(function()  
						if not descendant.Parent then
							return
						end
						local descendants = descendant:IsA("TextLabel") and { descendant } or descendant:GetDescendants()
						for _, descendant2 in ipairs(descendants) do
							if descendant2:IsA("TextLabel") and descendant2.Text ~= "" then
								local text3 = stripTags(descendant2.Text):lower()
								local now2 = os.clock()
								text2 = text3
								value3 = now2  
								return
							end
						end
					end)
				end
				local function watchTextLabel(arg)
					if not arg then
						return
					end  
					arg.DescendantAdded:Connect(onNotification)
					for _, descendant in ipairs(arg:GetDescendants()) do
						if descendant:IsA("TextLabel") then
							descendant:GetPropertyChangedSignal("Text"):Connect(function()
								if descendant.Text ~= "" then
									local text3 = stripTags(descendant.Text):lower()
									local now2 = os.clock()
									text2 = text3
									value3 = now2
								end  
							end)
						end
					end
				end
				watchTextLabel(playerGui:FindFirstChild("Notification"))
				watchTextLabel(playerGui:FindFirstChild("Notifications"))
				watchTextLabel(playerGui:FindFirstChild("Announcement"))
			end
		end  
		do
			local map5 = {
				"base is full",
				"sold out",
				"out of stock",
				"already redeemed",
				"already used",
				"code redeemed",
				"you have already",
			}  
			toggleAntiRagdoll = function(arg)
				if value3 <= (arg or 0) then
					return nil
				end
				if os.clock() - value3 > 3 then
					return nil
				end
				for _, value4 in ipairs(map5) do
					if text2:find(value4, 1, true) then  
						return value4
					end
				end
			end
		end
	end
end
local performRedeem, spamTick, applyAnnouncedText, hintFireKey, idleHint, setListening, handleCapturedCode, retryRedeem, toggleManualListen, isSystemMessage
do  
	do
		performRedeem = function(arg, arg2)
			local text2 = trimText(arg)
			if text2 == "" then
				setStatus("nothing to redeem", "err")
				return false, false
			end
			arg2 = arg2 and arg2 .. " " or ""
			setStatus(("%sredeeming: [%s] (len %d)"):format(arg2, text2, #text2), "busy")
			local ok22, value3, confirmed = submitCode(text2)
			local cond = ok22 and confirmed
			if cond then
				setStatus(("%sredeemed (%s): [%s]"):format(arg2, tostring(value3), text2), "ok")
			elseif ok22 then
				setStatus(("%ssent (%s): [%s]"):format(arg2, tostring(value3), text2), "busy")
			else
				setStatus(("%sfailed (%s): [%s]"):format(arg2, tostring(value3), text2), "err")
			end
			return ok22, cond
		end
		useFeedCode = function(text)
			TextBox.Text = text
			performRedeem(text)
		end
		do
			local toggleSpam = nil
			local function redeemWord(arg)  
				local text2 = trimText(arg or "")
				if text2 == "" then
					return false
				end
				attemptCount += 1
				local value3, value4 = performRedeem(text2)
				if value3 and value4 then
					local text3 = "ok"
					setStatus(("spam %d - redeemed: %s"):format(attemptCount, text2), text3)  
				elseif value3 then
					setStatus(("spam %d - sent: %s"):format(attemptCount, text2), "busy")
				else
					setStatus(("spam %d - failed: %s"):format(attemptCount, text2), "err")
				end
				return value3
			end
			spamTick = function(arg)
				if isSpamming and isListening and wordMode then
					redeemWord(arg)  
				end
			end
			local function helper()
				while isSpamming and isListening do
					if wordMode then
						if attemptCount == 0 then
							setStatus("spam - redeem on every word", "wait")
						end
						task.wait(0.1)  
					elseif manual then
						setStatus("spam - waiting for " .. hintFireKey(), "wait")
						task.wait(0.1)
					elseif #map2 >= wordLimit and trimText(TextBox.Text) ~= "" then
						redeemWord(TextBox.Text)
						task.wait(max)
					elseif trimText(TextBox.Text) == "" then
						setStatus("spam - waiting for a code...", "wait")
						task.wait(0.1)
					else
						setStatus(("spam - waiting %d/%d - enter at %d"):format(#map2, wordLimit, wordLimit), "wait")
						task.wait(0.1)
					end
				end  
				if isSpamming then
					toggleSpam(false)
				end
			end
			toggleSpam = function(arg)
				if arg and not isListening then
					setStatus("turn LISTEN on first", "err")
					return
				end
				if arg == isSpamming then  
					return
				end
				isSpamming = arg
				start.Text = arg and "STOP" or "START"
				start.TextColor3 = arg and map4.acc or map4.txt
				tween(spamDot, 0.16, { BackgroundColor3 = arg and map4.acc or map4.line })
				tween(spamLabel, 0.16, { TextColor3 = arg and map4.txt or map4.sub })
				tween(spamRowStroke, 0.16, { Color = arg and map4.acc or map4.line, Transparency = arg and 0.15 or 0.3 })
				if arg then  
					attemptCount = 0
					thread = task.spawn(helper)
				else
					thread = nil
					if isListening then
						setStatus("spam stopped", "wait")
					end
				end
			end
			start.MouseButton1Click:Connect(function()  
				toggleSpam(not isSpamming)
			end)
			redeem.MouseButton1Click:Connect(function()
				redeem.Text = "..."
				performRedeem(TextBox.Text)
				redeem.Text = translate("REDEEM")
			end)
			TextBox.FocusLost:Connect(function(enterPressed)
				if enterPressed then  
					performRedeem(TextBox.Text)
				end
			end)
			copyButton.MouseButton1Click:Connect(function()
				local copied = trimText(TextBox.Text)
				if copied == "" then
					setStatus("nothing to copy", "err")
					return
				end
				local copied2 = copyText(copied)  
				setStatus(copied2 and "copied: " .. copied or "copy failed", copied2 and "ok" or "err")
			end)
			clear.MouseButton1Click:Connect(function()
				TextBox.Text = ""
				lastCode = nil
				map2 = {}
				setStatus(isListening and "listening... (cleared)" or "cleared", isListening and "wait" or "idle")
			end)
			applyAnnouncedText = function(text)
				lastCode = text  
				TextBox.Text = text
			end
			hintFireKey = function()
				if not (not keyboardEnabled or not listenKey) then
					return "press " .. listenKey.Name .. " to fire"
				end
				return "tap LISTEN to fire"
			end
			idleHint = function()  
				if not keyboardEnabled then
					return "idle - tap LISTEN to start"
				end
				return listenKey and "idle - press " .. listenKey.Name .. " to listen" or "idle - no listen key bound"
			end
			setListening = function(arg)
				isListening = arg
				if not arg and isSpamming then
					toggleSpam(false)
				end  
				tween(Frame2, 0.16, { BackgroundColor3 = arg and map4.acc or map4.line })
				tween(Frame3, 0.16, { Position = UDim2.new(0, arg and 20 or 2, 0.5, -7) }, Enum.EasingStyle.Back)
				tween(listen, 0.16, { TextColor3 = arg and map4.txt or map4.sub })
				if arg then
					map2 = {}
					if spamOnListen and not isSpamming then
						if lastCode and TextBox.Text == lastCode then
							applyAnnouncedText("")
						end
						toggleSpam(true)  
					end
					if manual then
						setStatus("listening... " .. hintFireKey(), "wait")
					else
						local text2 = "wait"
						setStatus(("listening... 0/%d"):format(wordLimit), text2)
					end
				else
					setStatus(idleHint(), "idle")  
				end
			end
		end
	end
	do
		handleCapturedCode = function(arg)
			if autoType then
				applyAnnouncedText(arg)
			end
			if autoRedeem then  
				performRedeem(arg, "[FULL]")
			else
				setStatus("captured: " .. arg .. " (auto-redeem off)", "ok")
			end
		end
		retryRedeem = function(arg)
			local text2 = trimText(arg or "")
			if text2 == "" then
				return  
			end
			local now2 = os.clock()
			task.spawn(function()
				for i = 1, 3 do
					task.wait(retryDelay)
					local value3 = toggleAntiRagdoll(now2)
					if value3 then
						local text3 = "wait"
						setStatus(("%s - stopped retrying"):format(value3), text3)
						break  
					else
						attemptCount += 1
						local value4, value5 = performRedeem(text2, "[FULL]")
						setStatus(("confirm %d/%d - %s%s"):format(i, 3, value4 and "sent: " or "retry: ", text2), value4 and "ok" or "busy")
						if not value4 then
							continue
						end
					end
					break  
				end
			end)
		end
		do
			local function flushCapturedWords()
				local text2 = table.concat(map2, codeSpaces and " " or "")
				local value3 = isSpamming
				setListening(false)
				if text2 ~= "" then
					handleCapturedCode(text2)  
					if value3 then
						retryRedeem(text2)
					end
				end
			end
			toggleManualListen = function()
				if isListening then
					if manual then
						flushCapturedWords()  
					else
						setListening(false)
					end
				else
					setListening(true)
				end
			end
		end
	end
	TextButton.MouseButton1Click:Connect(toggleManualListen)  
	listenKeyButton.MouseButton1Click:Connect(function()
		pendingBind = "listen"
		listenKeyButton.Text = "..."
		listenKeyButton.TextColor3 = map4.warn
	end)
	clearListenButton.MouseButton1Click:Connect(function()
		listenKey = nil
		pendingBind = nil
		listenKeyButton.Text = "-"  
		listenKeyButton.TextColor3 = map4.txt
		if not isListening then
			setStatus(idleHint(), "idle")
		end
	end)
	redeemKeyButton.MouseButton1Click:Connect(function()
		pendingBind = "redeem"
		redeemKeyButton.Text = "..."
		redeemKeyButton.TextColor3 = map4.warn
	end)  
	clearRedeemButton.MouseButton1Click:Connect(function()
		redeemKey = nil
		pendingBind = nil
		redeemKeyButton.Text = "-"
		redeemKeyButton.TextColor3 = map4.txt
	end)
	TextBox:GetPropertyChangedSignal("Text"):Connect(function()
		if isListening and TextBox.Text ~= lastCode then
			map2 = {}
		end  
	end)
	map.positions = {
		Top = true,
		Bottom = true,
		Center = true,
		Middle = true,
		Left = true,
		Right = true,
		TopRight = true,
		TopLeft = true,  
		BottomRight = true,
		BottomLeft = true,
	}
	do
		local function helper(arg)
			return stripTags(tostring(arg or "")):lower():gsub("[^%w]", "")
		end
		local map5 = {
			phrases = {
				"code is",  
				"use code",
				"font color",
				"fontcolour",
				"fontcolor",
				"font colour",
				"sammy has activated bubblegum machine",
				"sammy activated 2x luck",
				"sammy activated 6x luck",
				"sammy activated 8x luck",
				"sammy activated 10x luck",  
				"sammy activated 12x luck",
				"sammy activated 15x luck",
				"sammy activated 20x luck",
				"sammy activated 25x luck",
				"sammy activated 30x luck",
				"sammy activated 35x luck",
				"sammy activated",
				"coins shop",
				"brainrot trader",
				"robux shop",  
				"robuxshop",
				"spin wheel",
				"spinwheel",
				"trade plaza",
				"tradeplaza",
				"event has started",
				"eventhasstarted",
				"allowfriends",
				"setcreatorid",
				"to buy this",  
				"tobuythis",
				"your base is already locked",
				"your base is full",
				"request failed",
				"you locked your base for",
				"you got a free spin",
				"broke into your base",
				"someone is stealing",
				"trade has been completed",
				"tradehasbeencompleted",  
				"event has been activated",
				"has been activated",
				"has activated",
				"base is already locked",
				"you locked your base",
				"you have locked your base",
				"locked your base",
				"brainrot express has arrived",
				"brainrot express has arrv",
				"brainrot express leaving in",  
			},
			prefixes = { "sammy:", "spydersammy:" },
			compact = {},
		}
		local map6 = {}
		for _, phrase in ipairs(map5.phrases) do
			local value3 = helper(phrase)
			if value3 ~= "" and not map6[value3] then
				map6[value3] = true  
				map5.compact[#map5.compact + 1] = { phrase = phrase, compact = value3 }
			end
		end
		isSystemMessage = function(arg)
			if not ignoreSystem or not isListening then
				return false
			end
			local text2 = stripTags(tostring(arg or "")):lower()
			local text3 = text2:gsub("%s+", "")
			for _, prefixe in ipairs(map5.prefixes) do
				if text3:find(prefixe, 1, true) then
					return true, prefixe
				end
			end
			local value3 = helper(text2)
			for _, value4 in ipairs(map5.compact) do
				if value3:find(value4.compact, 1, true) then
					return true, value4.phrase
				end  
			end
			return false
		end
	end
end
do
	do
		local function helper(...)
			local args = table.pack(...)  
			if args.n == 0 or typeof(args[1]) ~= "string" then
				return false
			end
			if ignoreSystem then
				return args[4] == "Top"
			end
			for i = 2, args.n do
				local value3 = args[i]
				if typeof(value3) == "string" and (value3:find("Sounds%.") or value3:find("rbxassetid") or map.positions[value3]) then
					return true  
				end
			end
			return false
		end
		handleAnnouncement = function(...)
			local args = table.pack(...)
			if not helper(...) then
				return
			end  
			local text2 = stripTags(tostring(args[1] or ""))
			if text2 ~= "" then
				if isSystemMessage(text2) then
					return
				end
				if _G.__RdmDuo and _G.__RiddlerDuo then
					local value4 = _G.__SabClassifyDrop(text2)
					if value4 == "riddle" then
						_G.__SabDropClaim = { text = text2, kind = "riddle", at = os.clock() }
						setStatus("riddle - left to the AI riddler", "wait")  
						unusedHelper(text2, nil)
						return
					end
					if value4 == "code" then
						_G.__SabDropClaim = { text = text2, kind = "code", at = os.clock() }
					end
				end
				local code = extractCode(text2)
				local value3  
				if autoListen and not isListening then
					value3 = extractCodeFromMessage(text2)
					if value3 then
						setListening(true)
						if value3 == "" then
							setStatus("trigger heard - waiting for the code...", "busy")
							unusedHelper(text2, code)
							return
						end  
					else
						value3 = text2
					end
				else
					value3 = text2
				end
				if isListening then
					for _, value4 in ipairs(splitWords(value3)) do
						map2[#map2 + 1] = value4
						if wordMode and isSpamming and manual then
							spamTick(table.concat(map2, codeSpaces and " " or ""))
						end
					end
					if manual then
						local text3 = table.concat(map2, codeSpaces and " " or "")
						applyAnnouncedText(text3)
						setCodeBoxText(text3)
						local text4 = "wait"
						setStatus(("listening... %d words - %s"):format(#map2, hintFireKey()), text4)
					else
						local value4 = wordLimit  
						local map5 = {}
						for i = 1, math.min(#map2, value4) do
							map5[i] = map2[i]
						end
						local text3 = table.concat(map5, codeSpaces and " " or "")
						applyAnnouncedText(text3)
						setCodeBoxText(text3)
						if value4 <= #map2 then
							local value5 = isSpamming  
							map2 = {}
							setListening(false)
							handleCapturedCode(text3)
							if value5 then
								retryRedeem(text3)
								code = text3
							else
								code = text3
							end
						else  
							setStatus(("listening... %d/%d - enter at %d"):format(#map2, value4, value4), "wait")
						end
					end
				end
				unusedHelper(text2, code)
				return
			end
		end
	end  
end
if getgenv and getgenv().StopFettah then
	pcall(getgenv().StopFettah)
end
do
	local map5 = {}
	local temp = nil
	local num2 = 0
	local function helper(...)  
		local args = table.pack(...)
		local text2 = tostring(...)
		local now2 = os.clock()
		if text2 == temp and now2 - num2 < 0.25 then
			return
		end
		temp = text2
		num2 = now2
		pcall(handleAnnouncement, table.unpack(args, 1, args.n))
	end  
	notifyRemote = findNotifyRemote()
	if notifyRemote then
		Frame.BackgroundColor3 = map4.ok
		Frame4.BackgroundColor3 = map4.ok
		map5[#map5 + 1] = notifyRemote.OnClientEvent:Connect(helper)
	else
		do
			local num3 = 0
			for _, child in ipairs(net:GetChildren()) do  
				if child:IsA("RemoteEvent") or child:IsA("UnreliableRemoteEvent") then
					num3 += 1
					map5[#map5 + 1] = child.OnClientEvent:Connect(helper)
					if not (num3 >= 400) then
						continue
					end
				else
					continue
				end
				break  
			end
			map5[#map5 + 1] = net.ChildAdded:Connect(function(child)
				if child:IsA("RemoteEvent") or child:IsA("UnreliableRemoteEvent") then
					map5[#map5 + 1] = child.OnClientEvent:Connect(helper)
				end
			end)
			autoStarted = num3 > 0
		end
		local warn_ = autoStarted and map4.warn or map4.err  
		Frame.BackgroundColor3 = warn_
		Frame4.BackgroundColor3 = warn_
	end
	if isTouch then
		local currentCamera = workspace.CurrentCamera
		local function refit()
			uiScale = computeUiScale()
			for _, descendant in ipairs(ScreenGui:GetDescendants()) do
				if descendant:IsA("UIScale") and descendant.Name == "WinScale" then
					descendant.Scale = uiScale  
				end
			end
			Main.Position = UDim2.new(1, -math.floor(316 * uiScale) - 8, 0.5, -math.floor(windowHeight * uiScale / 2))
		end
		if currentCamera then
			currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(refit)
		end
		map.refit = refit
		refit()
	end  
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		local userInputType = input.UserInputType
		if not (userInputType == Enum.UserInputType.Keyboard or userInputType == Enum.UserInputType.Gamepad1) then
			if pendingBind and userInputType == Enum.UserInputType.Touch then
				local rebinding = pendingBind
				pendingBind = nil
				if rebinding == "listen" then
					listenKeyButton.Text = listenKey and listenKey.Name or "-"
					listenKeyButton.TextColor3 = map4.txt  
				else
					redeemKeyButton.Text = redeemKey and redeemKey.Name or "-"
					redeemKeyButton.TextColor3 = map4.txt
				end
			end
			return
		end
		if pendingBind == "listen" then
			pendingBind = nil
			if input.KeyCode ~= Enum.KeyCode.Escape then  
				listenKey = input.KeyCode
			end
			listenKeyButton.Text = listenKey and listenKey.Name or "-"
			listenKeyButton.TextColor3 = map4.txt
			if not isListening then
				setStatus(idleHint(), "idle")
			end
			return
		end
		if pendingBind == "redeem" then  
			pendingBind = nil
			if input.KeyCode ~= Enum.KeyCode.Escape then
				redeemKey = input.KeyCode
			end
			redeemKeyButton.Text = redeemKey and redeemKey.Name or "-"
			redeemKeyButton.TextColor3 = map4.txt
			return
		end
		if gameProcessed then
			return  
		end
		if listenKey and input.KeyCode == listenKey then
			toggleManualListen()
		end
		if redeemKey and input.KeyCode == redeemKey then
			performRedeem(TextBox.Text)
		end
	end)
	if getgenv then  
		getgenv().FettahAnnounce = function(...)
			handleAnnouncement(...)
		end
		getgenv().FettahStatus = function()
			return statusLabel.Text
		end
		getgenv().StopFettah = function()
			isSpamming = false
			isListening = false
			pcall(function()  
				antiRagState:Disable()
			end)
			if stopAutoBuy then
				pcall(stopAutoBuy)
			end
			for _, value3 in ipairs(map5) do
				pcall(function()
					value3:Disconnect()
				end)  
			end
			map5 = {}
			if ScreenGui then
				ScreenGui:Destroy()
			end
		end
		getgenv().FettahUnblockEvents = function()
			if not map3.ready then
				return false, map3.why  
			end
			return map3.Unblock()
		end
	end
end
setListening(false)
if notifyRemote or autoStarted then
	setStatus(keyboardEnabled and (listenKey and "ready - press " .. listenKey.Name .. " to listen" or "ready - no listen key bound") or "ready - tap LISTEN to start", "idle")
else
	setStatus("notify remote not found", "err")  
end
