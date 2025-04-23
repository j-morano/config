function Linemode:size_and_mtime()
  local time = math.floor(self._file.cha.mtime or 0)
  if time == 0 then
    time = ""
  elseif os.date("%Y", time) == os.date("%Y") then
    time = os.date("%b %d %H:%M", time)
  else
    time = os.date("%b %d  %Y", time)
  end

  local size = self._file:size()
  if size then
    return string.format("%s %s", size and ya.readable_size(size) or "-", time)
  else
    local folder = cx.active:history(self._file.url)
    size = folder and tostring(#folder.files) or ""
    return string.format("%s %s", size, time)
  end
end


-- Cross-instance yank ability plugin
-- https://yazi-rs.github.io/docs/dds#session.lua
require("session"):setup {
  sync_yanked = true,
}
