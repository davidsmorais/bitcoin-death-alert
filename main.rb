require 'os'

def alert
  if (OS.mac?)
    system('afplay alert.mp3')
  elsif (OS.linux?)
    system("mpg123 alert.mp3")
end

alert
