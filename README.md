# clipp.torch
Torch interface to OpenCLIPP

##### WORK IN PROGRESS !

The goal of this package is bring to Torch [OpenCLIPP](https://github.com/CRVI/OpenCLIPP) image processing library with capabilities of running on CPU and GPU.

For now only grayscale images are supported.

### Supported transformations

#### image.scale

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