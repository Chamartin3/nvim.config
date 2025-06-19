M = {}

---@class GitCommitInfo
---@field date string
---@field author string
---@field title string
---@field hash string
---@return GitCommitInfo
local function getLastCommitInfo()
  local result = vim.fn.system('git log -1 --format=%cd¦%an¦%s¦%h --date=short'):gsub('\n$', '')
  if vim.v.shell_error ~= 0 then
    return nil
  end

  local date, author, title, hash = unpack(vim.split(result, '¦'))

  return {
    date = date,
    author = author,
    title = title,
    hash = hash,
  }
end
---@class RemoteInfo
---@field fetch string
---@field push string
---@return table<string, RemoteInfo>
local function getGitRemotes()
  local remotes = {}
  local output = vim.fn.systemlist 'git remote -v'
  for _, line in ipairs(output) do
    local name, url, type = line:match '(%S+)%s+(%S+)%s+%((%w+)%)'
    if not remotes[name] then
      remotes[name] = { fetch = '', push = '' }
    end
    remotes[name][type] = url
  end
  return remotes
end

--- @class GitInfo
--- @field name string
--- @field is_root boolean
--- @field root_path string
--- @field branch string
--- @field last_commit GitCommitInfo
--- @field remotes table<string, RemoteInfo>

---@return GitInfo|nil
---Returns information about the current folder
M.getGitInfo = function()
  local cwd = vim.fn.getcwd()
  local is_inside_git_repo = vim.fn.system 'git rev-parse --is-inside-work-tree 2>/dev/null' == 'true\n'
  if not is_inside_git_repo then
    return nil
  end
  local git_root = vim.fn.system('git rev-parse --show-toplevel'):gsub('\n$', '')
  local git_info = {}
  git_info.is_root = git_root == cwd
  git_info.root_path = git_root
  git_info.name = vim.fn.fnamemodify(git_root, ':t')
  local git_branch = vim.fn.system 'git rev-parse --abbrev-ref HEAD 2>/dev/null'
  if git_branch ~= '' then
    git_info.branch = git_branch:gsub('%s+', '')
  end
  git_info.last_commit = getLastCommitInfo()
  git_info.remotes = getGitRemotes()

  return git_info
end

return M
