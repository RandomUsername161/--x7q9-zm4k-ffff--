-- Monster TD Hub — Public Loader
-- Замени YOUR_GITHUB_USER и YOUR_REPO на свой ник и название репозитория!
local BASE_URL = "https://raw.githubusercontent.com/YOUR_GITHUB_USER/YOUR_REPO/main/"

local LOBBY_PLACE_ID = 9035888777
local GAME_PLACE_ID = 9181976110

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local genv = (typeof(getgenv) == "function" and getgenv()) or _G
if game.PlaceId ~= LOBBY_PLACE_ID and game.PlaceId ~= GAME_PLACE_ID then
	warn("[Monster TD Hub] Этот скрипт работает в Monster TD (Лобби / Матч).")
	return
end

local targetFile = if game.PlaceId == GAME_PLACE_ID then "match.luau" else "lobby.luau"

-- Авто-перезагрузка при переходе между Лобби и Матчем (работает у друга без autoexec!)
local qfn = (typeof(queue_on_teleport) == "function" and queue_on_teleport)
	or (typeof(queueonteleport) == "function" and queueonteleport)
if qfn and not genv.__mtdPublicQueueBound then
	genv.__mtdPublicQueueBound = true
	pcall(qfn, string.format('loadstring(game:HttpGet(%q))()', BASE_URL .. "loader.luau"))
end

local ok, src = pcall(function()
	return game:HttpGet(BASE_URL .. targetFile)
end)
if not ok or type(src) ~= "string" or #src < 100 then
	warn("[Monster TD Hub] Не удалось загрузить " .. targetFile .. ": " .. tostring(src))
	return
end

local fn, err = loadstring(src)
if not fn then
	warn("[Monster TD Hub] Ошибка компиляции: " .. tostring(err))
	return
end
fn()
