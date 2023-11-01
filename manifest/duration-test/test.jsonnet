function (
  certDuration="1h60s"
)

local timeArr = [["h", 3600], ["m", 60], ["s", 1]];
local total(duration, times) = 
  local current = std.split(duration, times[0][0]);
  if std.length(times) == 0 then 0
  else if std.length(current) == 1 then total(std.strReplace(current[0], times[0][0], ""), times[1:])
  else total(std.strReplace(current[1], times[0][0], ""), times[1:]) + std.parseInt(current[0]) * times[0][1];

local parsedTime(seconds, times) =
  if std.length(times) == 0 then ""
  else std.floor(seconds/times[0][1]) + times[0][0] + parsedTime(seconds%times[0][1], times[1:]);

[
  {
    "4": total(certDuration, timeArr),
    "5": parsedTime(total(certDuration, timeArr), timeArr)
  }
]