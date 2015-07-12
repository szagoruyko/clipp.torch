require 'clipp'
require 'image'

local context = clipp.createContext'Intel'
print(clipp.getDeviceName())
clipp.PrepareTransform'float'
clipp.PrepareFilters'float'

local mytester = torch.Tester()
local precision = 1e-3
local clipptest = {}

local im_gray = image.lena():mean(1):float():squeeze()
local im_rgb  = image.lena():float()

-- not a really good test because the implementations are different
function clipptest.scale_grayscale()
  local im = im_gray
  local w = math.random(100,1000)
  local h = math.random(100,1000)
  for i,mode in ipairs{'simple','bilinear'} do
    local ref = image.scale(im,w,h,mode)
    local com = clipp.scale(im,w,h,mode)
    mytester:assertlt(torch.abs(ref - com):mean(), 1e-1, 'bilinear resize')
  end
end

function clipptest.scale_rgb()
  local im = im_rgb
  local w = math.random(100,1000)
  local h = math.random(100,1000)

  for i,mode in ipairs{'simple','bilinear'} do
    local ref = image.scale(im,w,h,mode)
    local com = clipp.to3HW(clipp.scale(clipp.toHW4(im),w,h,mode))
    mytester:assertlt(torch.abs(ref - com):mean(), 1e-1, 'bilinear resize')
  end
end

function clipptest.flip()
  local im = im_gray
  for i,mode in ipairs{'hflip','vflip'} do
    local ref = image[mode](im)
    local com = clipp[mode](im)
    mytester:asserteq(torch.abs(ref - com):max(), 0, mode..' GRAY')
  end

  local im = im_rgb
  for i,mode in ipairs{'hflip','vflip'} do
    local ref = image[mode](im)
    local com = clipp.to3HW(clipp[mode](clipp.toHW4(im)))
    mytester:asserteq(torch.abs(ref - com):max(), 0, mode..' RGB')
  end
end

function clipptest.flipXY()
  local im = im_gray
  local ref = image.hflip(image.vflip(im))
  local com = clipp.Flip(im)
  mytester:asserteq(torch.abs(ref - com):max(), 0, 'flipXY GRAY')

  local im = im_rgb
  local ref = image.hflip(image.vflip(im))
  local com = clipp.to3HW(clipp.Flip(clipp.toHW4(im)))
  mytester:asserteq(torch.abs(ref - com):max(), 0, 'flipXY RGB')
end

function clipptest.transpose()
  local im = im_gray
  local ref = im_gray:t()
  local com = clipp.Transpose(im)
  mytester:asserteq(torch.abs(ref - com):max(), 0, 'transpose GRAY')

  local im = im_rgb
  local ref = im:transpose(2,3)
  local com = clipp.to3HW(clipp.Transpose(clipp.toHW4(im)))
  mytester:asserteq(torch.abs(ref - com):max(), 0, 'transpose RGB')
end


mytester:add(clipptest)
mytester:run()
