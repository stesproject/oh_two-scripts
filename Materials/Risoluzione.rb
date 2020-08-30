def screen_resize(w, h)
  getSystemMetrics = Win32API.new('user32', 'GetSystemMetrics', 'i','i')
  moveWindow = Win32API.new('user32', 'MoveWindow', 'liiiil', 'l')
  findWindowEx = Win32API.new('user32', 'FindWindowEx', 'llpp', 'i')
  win = findWindowEx.call(0, 0 , 'RGSS Player', 0)
  sw, sh = getSystemMetrics.call(0), getSystemMetrics.call(1)
  moveWindow.call(win, (sw - w) / 2, (sh - h) / 2, w, h, 1)
end
screen_resize(1000, 765)