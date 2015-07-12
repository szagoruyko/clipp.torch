require 'image'
include 'ffi.lua'
local C = clipp.C
local clC = require 'opencl.C'
local ffi = require 'ffi'


local errcheck = function(f, ...)
   local status = C[f](...)
   if status ~= 0 then
     local str = ffi.string(C.ocipGetErrorName(status))
     error('Error in clipp: ' .. str)
   end
end
clipp.errcheck = errcheck


function clipp.createContext(preference, type)
  local context = ffi.new'ocipContext[1]'
  errcheck('ocipInitialize',context, preference, clC.CL_DEVICE_TYPE_ALL)
  ffi.gc(context, function(d) errcheck('ocipUninitialize', d[0]) end)
  --local clfiles = paths.dirname(package.searchpath('clipp/init', package.path)) .. '/cl-files'
  --print(clfiles)
  C.ocipSetCLFilesPath('/opt/rocks/clipp.torch/cl-files')
  return context
end


function clipp.getDeviceName()
  local name = ffi.new'char[64]'
  errcheck('ocipGetDeviceName',name,64)
  return ffi.string(name)
end

-- helper functions
function clipp.toHW4(t)
  assert(t:nDimension() == 3 and t:size(1) == 3)
  return torch.cat(t, t.new(1,t:size(2),t:size(3)),1):permute(2,3,1):contiguous()
end

-- helper functions
function clipp.to3HW(t)
  assert(t:nDimension() == 3 and t:size(3) == 4)
  return t:permute(3,1,2):narrow(1,1,3)
end

local supported_types = {
  {ttype = 'torch.CharTensor', stype = 'S8', ctype = 'char'},
  {ttype = 'torch.ByteTensor', stype = 'U8', ctype = 'unsigned char'},
  {ttype = 'torch.ShortTensor', stype = 'S16', ctype = 'short int'},
  {ttype = 'torch.IntTensor', stype = 'S32', ctype = 'int'},
  {ttype = 'torch.FloatTensor', stype = 'F32', ctype = 'float'},
  {ttype = 'torch.DoubleTensor', stype = 'F64', ctype = 'double'},
}

function clipp.createImage(tensor)
  local im = ffi.new'ocipImage[1]'
  local simage = ffi.new'struct SImage'
  simage.Height = tensor:size(1)
  simage.Width = tensor:size(2)
  simage.Channels = tensor:size(3)

  local ttype = tensor:type()
  local utype
  if ttype == 'torch.FloatTensor' then utype = supported_types[5]
  elseif ttype == 'torch.DoubleTensor' then utype = supported_types[6]
  elseif ttype == 'torch.ByteTensor' then utype = supported_types[2]
  elseif ttype == 'torch.CharTensor' then utype = supported_types[1]
  elseif ttype == 'torch.IntTensor' then utype = supported_types[4]
  elseif ttype == 'torch.ShortTensor' then utype = supported_types[3]
  end
  simage.Type = utype.stype
  simage.Step = tensor:stride(1) * ffi.sizeof(utype.ctype)
  errcheck('ocipCreateImage', im, simage, tensor:data(), clC.CL_MEM_READ_WRITE)
  ffi.gc(im, function(d) errcheck('ocipReleaseImage', d[0]) end)
  return im
end


local prepares = {
  'ocipPrepareConversion',
  'ocipPrepareArithmetic',
  'ocipPrepareLogic',
  'ocipPrepareLUT',
  'ocipPrepareMorphology',
  'ocipPrepareFilters',
  'ocipPrepareThresholding',
  'ocipPrepareProximity',
  'ocipPrepareTransform',
  'ocipPrepareStatistics',
  'ocipPrepareIntegral',
  'ocipPrepareBlob',
}

for i,ocip_name in ipairs(prepares) do
  local name = ocip_name:gsub('ocip','')

  clipp[name] = function(ctype)
    for j,v in ipairs(supported_types) do
      if ctype == v.ctype then
        local t = torch.Tensor(1,1,1):type(v.ttype)
        errcheck(ocip_name, clipp.createImage(t)[0])
      end
    end
  end
end

-- ================= FILTERS ================= --

local filters = {
  'ocipGaussianBlur',
  'ocipGauss',
  'ocipSharpen',
  'ocipSmooth',
  'ocipMedian',
  'ocipSobelVert',
  'ocipSobelHoriz',
  'ocipSobelCross',
  'ocipSobel',
  'ocipPrewittVert',
  'ocipPrewittHoriz',
  'ocipPrewitt',
  'ocipScharrVert',
  'ocipScharrHoriz',
  'ocipScharr',
  'ocipHipass',
  'ocipLaplace',
}

for i,ocip_name in ipairs(filters) do
  local name = ocip_name:gsub('ocip','')

  clipp[name] = function(...)
    local src, dst, param
    local arg = {...}
    if #arg == 2 then
      src, param = unpack(arg)
      dst = src:clone()
    elseif #arg == 3 then
      src, dst, param = unpack(arg)
      dst:resize(#src)
    end
    local a = clipp.createImage(src)
    local b = clipp.createImage(dst)
    errcheck(ocip_name, a[0], b[0], param)
    errcheck('ocipReadImage',b[0])
    return dst
  end
end

local scale_modes = {
  bilinear = C.ocipLinear,
  simple = C.ocipNearestNeighbour,
  cubic = C.ocipCubic,
  lanczos2 = C.ocipLanczos2,
  lanczos3 = C.ocipLanczos3,
  supersampling = C.ocipSuperSampling,
  best = C.ocipBestQuality
}


-- ================= TRANSFORMS ================= --

function clipp.scale(...)
   local dst,src,width,height,mode,size
   local args = {...}
   if select('#',...) == 4 then
      src = args[1]
      width = args[2]
      height = args[3]
      mode = args[4]
   elseif select('#',...) == 3 then
      if type(args[3]) == 'string' then
         if type(args[2]) == 'string' or type(args[2]) == 'number' then
            src = args[1]
            size = args[2]
            mode = args[3]
         else
            dst = args[1]
            src = args[2]
            mode = args[3]
         end
      else
         src = args[1]
         width = args[2]
         height = args[3]
      end
   elseif select('#',...) == 2 then
      if type(args[2]) == 'string' or type(args[2]) == 'number' then
         src = args[1]
         size = args[2]
      else
         dst = args[1]
         src = args[2]
      end
  end
   if size then
      local iwidth,iheight
      if src:nDimension() == 3 then
         iwidth,iheight = src:size(3),src:size(2)
      else
         iwidth,iheight = src:size(2),src:size(1)
      end
      local imax = math.max(iwidth,iheight)
      local omax = tonumber(size)
      if omax then
         height = iheight / imax * omax
         width = iwidth / imax * omax
      else
         width,height = size:gfind('(%d*)x(%d*)')()
         if not width or not height then
            local imin = math.min(iwidth,iheight)
            local omin = size:gfind('%^(%d*)')()
            if omin then
               height = iheight / imin * omin
               width = iwidth / imin * omin
            end
         end
      end
   end
   if not dst and (not width or not height) then
      error('could not find valid dest size', 'image.scale')
   end
   if not dst then
      if src:nDimension() == 3 then
         dst = src.new(src:size(1), height, width)
      else
         dst = src.new(height, width)
      end
   end
  mode = mode or 'bilinear'
  src = src:nDimension() == 3 and src or src:view(src:size(1),src:size(2),1)
  assert(src:size(3) == 4 or src:size(3) == 1)
  dst:resize(height,width,src:size(3))
  local a = clipp.createImage(src)
  local b = clipp.createImage(dst)
  errcheck('ocipResize', a[0], b[0], scale_modes[mode], ffi.new('ocipBool',0))
  errcheck('ocipReadImage',b[0])
  return dst:squeeze()
end


