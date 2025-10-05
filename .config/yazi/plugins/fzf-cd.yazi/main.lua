local function fzf_select_and_jump()
	-- 隐藏Yazi界面
	local permit = ya.hide()
	if not permit then
		ya.notify({ title = "错误", content = "无法显示fzf窗口", level = "error", timeout = 2 })
		return
	end

	-- 获取当前目录
	local current_dir = ""
	local cwd_file = os.getenv("HOME") .. "/.local/state/yazi/cwd"
	local file_handle = io.open(cwd_file, "r")
	if file_handle then
		current_dir = file_handle:read("*line") or ""
		file_handle:close()
	end
	if current_dir == "" then
		current_dir = os.getenv("PWD") or ""
	end
	if current_dir == "" then
		ya.notify({ title = "错误", content = "无法获取当前目录", level = "error", timeout = 2 })
		permit:drop()
		return
	end

	-- 构建fzf命令：移除-z选项以兼容macOS
	local safe_dir = current_dir:gsub('"', '\\"'):gsub("'", "\\'")
	local fzf_cmd = string.format(
		'(find "%s" -mindepth 1 -maxdepth 1 -type d; '
			.. 'find "%s" -mindepth 2 -maxdepth 3 -type d) | '
			.. 'awk -v base_dir="%s" \'{sub(base_dir "/", ""); print $0}\' | '
			.. "sort | uniq | " -- 移除-z选项，使用默认换行分隔
			.. 'fzf --prompt "选择目录 > " '
			.. "--height 100%% "
			.. "--layout=reverse-list "
			.. '--preview "ls -ld %s/{}" '
			.. "--preview-window=top:0 "
			.. "--no-info "
			.. "--border=horizontal "
			.. "--exit-0",
		safe_dir,
		safe_dir,
		safe_dir,
		safe_dir
	)

	-- 用临时文件处理结果
	local temp_file = os.tmpname()
	local full_cmd = fzf_cmd .. " > " .. temp_file .. " 2>/dev/null; sleep 0.1"
	os.execute(full_cmd)

	-- 读取相对路径并转换为绝对路径
	local selected_dir = ""
	local retry = 2
	while retry > 0 do
		local handle = io.open(temp_file, "r")
		if handle then
			local rel_path = handle:read("*line") or ""
			handle:close()
			if rel_path ~= "" then
				selected_dir = current_dir .. "/" .. rel_path
				break
			end
		end
		retry = retry - 1
		os.execute("sleep 0.05")
	end
	os.remove(temp_file)

	-- 恢复界面
	permit:drop()

	-- 处理结果
	if selected_dir ~= "" then
		local success, err = pcall(function()
			ya.manager_emit("cd", { selected_dir })
		end)
		if success then
			-- 关键添加：将目录记录到zoxide
			local safe_selected = selected_dir:gsub('"', '\\"') -- 转义双引号，避免路径含空格报错
			os.execute('zoxide add "' .. safe_selected .. '" 2>/dev/null')

			local rel_path = selected_dir:sub(#current_dir + 2)
			ya.notify({
				title = "成功",
				content = "已切换到: " .. rel_path .. "\n已记录到zoxide",
				level = "info",
				timeout = 2,
			})
		else
			ya.notify({ title = "错误", content = "切换目录失败: " .. err, level = "error", timeout = 2 })
		end
	else
		ya.notify({ title = "取消", content = "操作已取消", level = "info", timeout = 1 })
	end
end

return { entry = fzf_select_and_jump }
