--[[
down
01-02-03-04

up
05-06-07-08

left
09-10-11-12

--]]
require("lfs")


local replaceString = {
	["_01.png"] = "_move_down_0.png",
	["_02.png"] = "_move_down_1.png",
	["_03.png"] = "_move_up_0.png",
	["_04.png"] = "_move_up_1.png",
	["_05.png"] = "_move_left_0.png",
	["_06.png"] = "_move_left_1.png",
	["_07.png"] = "_stand_down_0.png",
	["_08.png"] = "_stand_up_0.png",
	["_09.png"] = "_stand_left_0.png",
	["_10.png"] = "_dead_1.png",
	["_11.png"] = "_dead_2.png",
}


local allImages = {}
local dirPath = "."
for file in lfs.dir(dirPath) do
	if file ~= "." and file ~= ".." then
		local f = dirPath .. file
		table.insert(allImages, f)
	end
end

for _, fullpath in pairs(allImages) do
	fullpath = string.sub(fullpath, 2, string.len(fullpath))
	local newName = string.gsub(fullpath, ".JPG", ".jpg")
	local cmd = string.format("rename %s %s", fullpath, newName)
	print(cmd)
	os.execute(cmd)
	-- for origPost, newPost in pairs(replaceString) do
	-- 	if string.sub(fullpath, -7) == origPost then
	-- 		local newName = string.gsub(fullpath, origPost, newPost)
	-- 		local cmd = string.format("rename %s %s", fullpath, newName)
	-- 		print(cmd)
	-- 		os.execute(cmd)
	-- 	end
	-- end
end

-- local newDirs = {}
-- for newName, _ in pairs(images) do
-- 	for _, fullpath in pairs(allImages) do
-- 		fullpath = string.sub(fullpath, 2, string.len(fullpath))
-- 		if string.find(fullpath, newName) then
-- 			if not newDirs[newName] then
-- 				lfs.mkdir(newName)
-- 				newDirs[newName] = 1
-- 			end

-- 			local cmd = string.format("move %s %s", fullpath, newName)
-- 			os.execute(cmd)
-- 		end
-- 	end
-- end