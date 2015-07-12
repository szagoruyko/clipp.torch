# clipp.torch
Torch interface to OpenCLIPP

##### WORK IN PROGRESS !

The goal of this package is bring to Torch [OpenCLIPP](https://github.com/CRVI/OpenCLIPP) image processing library with capabilities of running on CPU and GPU.

Accepted formats:

* HW
* HW1
* HW4

Accepted tensors:

* torch.CharTensor
* torch.ByteTensor
* torch.ShortTensor
* torch.IntTensor
* torch.FloatTensor
* torch.DoubleTensor

### Supported transformations

#### image.scale

THE IMPLEMENTATION IS DIFFERENT FROM image.scale !
in the following modes:

* bilinear
* simple
* cubic
* lanczos2
* lanczos3
* supersampling
* best

### Supported filters:

```c++
/// Gaussian blur filter - with sigma parameter.
/// \param Sigma : Intensity of the filer - Allowed values : 0.01-10
ocipError ocip_API ocipGaussianBlur(ocipImage Source, ocipImage Dest, float Sigma);

/// Gaussian filter - with width parameter.
/// \param Width : Width of the filter box - Allowed values : 3 or 5
ocipError ocip_API ocipGauss(     ocipImage Source, ocipImage Dest, int Width);

/// Sharpen filter.
/// \param Width : Width of the filter box - Allowed values : 3
ocipError ocip_API ocipSharpen(   ocipImage Source, ocipImage Dest, int Width);

/// Smooth filter - or Box filter.
/// \param Width : Width of the filter box - Allowed values : Impair & >=3
ocipError ocip_API ocipSmooth(    ocipImage Source, ocipImage Dest, int Width);

/// Median filter
/// \param Width : Width of the filter box - Allowed values : 3 or 5
ocipError ocip_API ocipMedian(    ocipImage Source, ocipImage Dest, int Width);

/// Vertical Sobel filter
/// \param Width : Width of the filter box - Allowed values : 3 or 5
ocipError ocip_API ocipSobelVert( ocipImage Source, ocipImage Dest, int Width);

/// Horizontal Sobel filter
/// \param Width : Width of the filter box - Allowed values : 3 or 5
ocipError ocip_API ocipSobelHoriz(ocipImage Source, ocipImage Dest, int Width);

/// Cross Sobel filter
/// \param Width : Width of the filter box - Allowed values : 3 or 5
ocipError ocip_API ocipSobelCross(ocipImage Source, ocipImage Dest, int Width);

/// Combined Sobel filter
/// Does SobelVert & SobelHoriz and the combines the two with sqrt(V*V + H*H)
/// \param Width : Width of the filter box - Allowed values : 3 or 5
ocipError ocip_API ocipSobel(     ocipImage Source, ocipImage Dest, int Width);

/// Vertical Prewitt filter
/// \param Width : Width of the filter box - Allowed values : 3 or 5
ocipError ocip_API ocipPrewittVert(ocipImage Source, ocipImage Dest, int Width);

/// Horizontal Prewitt filter
/// \param Width : Width of the filter box - Allowed values : 3 or 5
ocipError ocip_API ocipPrewittHoriz(ocipImage Source, ocipImage Dest, int Width);

/// Combined Prewitt filter
/// Does PrewittVert & PrewittHoriz and the combines the two with sqrt(V*V + H*H)
/// \param Width : Width of the filter box - Allowed values : 3 or 5
ocipError ocip_API ocipPrewitt(     ocipImage Source, ocipImage Dest, int Width);

/// Vertical Scharr filter
/// \param Width : Width of the filter box - Allowed values : 3 or 5
ocipError ocip_API ocipScharrVert(   ocipImage Source, ocipImage Dest, int Width);

/// Horizontal Scharr filter
/// \param Width : Width of the filter box - Allowed values : 3 or 5
ocipError ocip_API ocipScharrHoriz(  ocipImage Source, ocipImage Dest, int Width);

/// Combined Scharr filter
/// Does ScharrVert & ScharrHoriz and the combines the two with sqrt(V*V + H*H)
/// \param Width : Width of the filter box - Allowed values : 3 or 5
ocipError ocip_API ocipScharr(       ocipImage Source, ocipImage Dest, int Width);

/// Hipass filter
/// \param Width : Width of the filter box - Allowed values : 3 or 5
ocipError ocip_API ocipHipass(       ocipImage Source, ocipImage Dest, int Width);

/// Laplace filter
/// \param Width : Width of the filter box - Allowed values : 3 or 5
ocipError ocip_API ocipLaplace(      ocipImage Source, ocipImage Dest, int Width);

```
### Table of supported functions

| function name | status |
| - | - |
| ocipInitialize | done |
| ocipUninitialize | done |
| ocipChangeContext |  |
| ocipSetCLFilesPath | done |
| ocipGetErrorName | done |
| ocipGetDeviceName | done |
| ocipFinish |  |
| ocipCreateImage | done |
| ocipSendImage | done |
| ocipReadImage | done |
| ocipReleaseImage |  |
| ocipReleaseProgram |  |
| - | - |
|  ocipPrepareConversion | done |
|  ocipConvert |  |
|  ocipScale |  |
|  ocipScale2 |  |
|  ocipCopy |  |
|  ocipToGray |  |
|  ocipSelectChannel |  |
|  ocipToColor |  |
| - | - |
|  ocipPrepareArithmetic | done |
|  ocipAdd |  |
|  ocipAddSquare |  |
|  ocipSub |  |
|  ocipAbsDiff |  |
|  ocipMul |  |
|  ocipDiv |  |
|  ocipImgMin |  |
|  ocipImgMax |  |
|  ocipImgMean |  |
|  ocipCombine |  |
|  ocipAddC |  |
|  ocipSubC |  |
|  ocipAbsDiffC |  |
|  ocipMulC |  |
|  ocipDivC |  |
|  ocipRevDivC |  |
|  ocipMinC |  |
|  ocipMaxC |  |
|  ocipMeanC |  |
|  ocipAbs |  |
|  ocipInvert |  |
|  ocipSqr |  |
|  ocipExp |  |
|  ocipLog |  |
|  ocipSqrt |  |
|  ocipSin |  |
|  ocipCos |  |
| ---------------- | - |
|  ocipPrepareLogic | done |
|  ocipAnd |  |
|  ocipOr |  |
|  ocipXor |  |
|  ocipAndC |  |
|  ocipOrC |  |
|  ocipXorC |  |
|  ocipNot |  |
| ---------------- | - |
|  ocipPrepareLUT | done |
|  ocipLut |  |
|  ocipLutLinear |  |
|  ocipBasicLut |  |
|  ocipLutScale |  |
| ---------------- | - |
|  ocipPrepareMorphology | done |
|  ocipErode |  |
|  ocipDilate |  |
|  ocipGradient |  |
|  ocipErode2 |  |
|  ocipDilate2 |  |
|  ocipOpen |  |
|  ocipClose |  |
|  ocipTopHat |  |
|  ocipBlackHat |  |
| ---------------- | - |
|  ocipPrepareTransform | done |
|  ocipMirrorX | done |
|  ocipMirrorY | done |
|  ocipFlip | done |
|  ocipTranspose | done |
|  ocipRotate | done |
|  ocipResize | done |
|  ocipShear |  |
|  ocipRemap |  |
|  ocipSet |  |
| ---------------- | - |
|  ocipPrepareFilters | done |
|  ocipGaussianBlur | done |
|  ocipGauss | done |
|  ocipSharpen | done |
|  ocipSmooth | done |
|  ocipMedian | done |
|  ocipSobelVert | done |
|  ocipSobelHoriz | done |
|  ocipSobelCross | done |
|  ocipSobel | done |
|  ocipPrewittVert | done |
|  ocipPrewittHoriz | done |
|  ocipPrewitt | done |
|  ocipScharrVert | done |
|  ocipScharrHoriz | done |
|  ocipScharr | done |
|  ocipHipass | done |
|  ocipLaplace | done |
| ---------------- | - |
|  ocipPrepareHistogram | done |
|  ocipHistogram_1C |  |
|  ocipHistogram_4C |  |
|  ocipOtsuThreshold |  |
| ---------------- | - |
|  ocipPrepareStatistics | done |
|  ocipMin |  |
|  ocipMax |  |
|  ocipMinAbs |  |
|  ocipMaxAbs |  |
|  ocipSum |  |
|  ocipSumSqr |  |
|  ocipMean |  |
|  ocipMeanSqr |  |
|  ocipStdDev |  |
|  ocipMean_StdDev |  |
|  ocipCountNonZero |  |
|  ocipMinIndx |  |
|  ocipMaxIndx |  |
|  ocipMinAbsIndx |  |
|  ocipMaxAbsIndx |  |
| ---------------- | - |
|  ocipPrepareThresholding | done |
|  ocipThreshold |  |
|  ocipThresholdGTLT |  |
|  ocipThreshold_Img |  |
|  ocipCompare |  |
|  ocipCompareC |  |
| ---------------- | - |
|  ocipPrepareBlob | done |
|  ocipComputeLabels |  |
|  ocipRenameLabels |  |
| ---------------- | - |
|  ocipPrepareFFT |  |
|  ocipIsFFTAvailable |  |
|  ocipFFTForward |  |
|  ocipFFTInverse |  |
| ---------------- | - |
|  ocipPrepareIntegral | done |
|  ocipIntegral |  |
|  ocipSqrIntegral |  |
| ---------------- | - |
|  ocipPrepareProximity | done |
|  ocipSqrDistance_Norm |  |
|  ocipSqrDistance |  |
|  ocipAbsDistance |  |
|  ocipCrossCorr |  |
|  ocipCrossCorr_Norm |  |
| ---------------- | - |
|  ocipPrepareImageProximityFFT | done |
|  ocipSqrDistanceFFT |  |
|  ocipSqrDistanceFFT_Norm |  |
|  ocipCrossCorrFFT |  |
|  ocipCrossCorrFFT_Norm |  |
