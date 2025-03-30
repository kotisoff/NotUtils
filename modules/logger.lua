local logger = {
  ---@class Logger
  ---@field private silentlogs string[]
  ---@field private logs string[]
  ---@field private prefix fun(self): string
  ---@field private filepath fun(self): string
  __index = {
    silentlog = {},
    log = {},
    prefix = function(self) return '[' .. self.packid .. '][' .. self.name .. '] ' end,

    filepath = function(self)
      return pack.shared_file(self.packid, self.name .. "-latest.log")
    end,

    silent = function(self, ...)
      table.insert(self.silentlog, self:prefix() .. table.concat({ ... }, " "));
    end,

    info = function(self, ...)
      table.insert(self.log, self:prefix() .. table.concat({ ... }, " "));
      self:silent(...);
    end,

    save = function(self)
      file.write(self:filepath(), table.concat(self.silentlog, "\n"))
    end,

    clear_info_log = function(self)
      self.log = {};
    end,

    print = function(self)
      print(table.concat(self.log, "\n"));
      self.log = {};
    end,

    println = function(self, ...)
      print(self:prefix() .. table.concat({ ... }, " "))
    end
  }
}

local Logger = {
  new = function(packid, name)
    return setmetatable({ packid = packid, name = name }, logger);
  end
}

return Logger
