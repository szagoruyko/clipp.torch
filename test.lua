dofile 'init.lua'
require 'image'

local context = clipp.createContext'Intel'
print(clipp.getDeviceName())
clipp.PrepareTransform'float'
clipp.PrepareFilters'float'

local mytester = torch.Tester()
local precision = 1e-3
local clipptest = {}

function clipptest.scale_grayscale()
  -- not a really good test because the implementations are different
  local im = image.lena():mean(1):float():squeeze()
  local w = math.random(100,1000)
  local h = math.random(100,1000)

  for i,mode in ipairs{'simple','bilinear'} do
    local ref = image.scale(im,w,h,mode)
    local com = clipp.scale(im,w,h,mode)
    mytester:assertlt(torch.abs(ref - com):mean(), 1e-1, 'bilinear resize')
  end
end

function clipptest.scale_rgb()
  -- not a really good test because the implementations are different
  local im = image.lena():float():squeeze()
  local w = math.random(100,1000)
  local h = math.random(100,1000)

  for i,mode in ipairs{'simple','bilinear'} do
    local ref = image.scale(im,w,h,mode)
    local com = clipp.to3HW(clipp.scale(clipp.toHW4(im),w,h,mode))
    mytester:assertlt(torch.abs(ref - com):mean(), 1e-1, 'bilinear resize')
  end
end

--function clipptest.flip

mytester:add(clipptest)
mytester:run()
