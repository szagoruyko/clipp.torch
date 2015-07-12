clipp = {}
local ffi = require 'ffi'

ffi.cdef[[
typedef char ocipBool;
typedef unsigned int uint;

typedef uint64_t        cl_ulong;
typedef cl_ulong            cl_bitfield;
typedef cl_bitfield         cl_device_type;
typedef cl_bitfield         cl_mem_flags;
typedef int cl_int;

typedef struct SImage SImage;
typedef cl_int ocipError;

typedef struct _cl_context * ocipContext;
typedef struct _cl_image * ocipImage;
typedef struct _cl_program * ocipProgram;


struct SImage
{
   uint Width;    ///< Width of the image, in pixels
   uint Height;   ///< Height of the image, in pixels
   uint Step;     ///< Nb of bytes between each row
   uint Channels; ///< Number of channels in the image, allowed values : 1, 2, 3 or 4

   /// EDataType : Lists possible types of data
   enum EDataType
   {
      U8,            /// Unsigned 8-bit integer (unsigned char)
      S8,            /// Signed 8-bit integer (char)
      U16,           /// Unsigned 16-bit integer (unsigned short)
      S16,           /// Signed 16-bit integer (short)
      U32,           /// Unsigned 32-bit integer (unsigned int)
      S32,           /// Signed 32-bit integer (int)
      F32,           /// 32-bit floating point (float)
      F64,           /// 64-bit floating point (double)
      NbDataTypes,   /// Number of possible data types
   } Type;  ///< Data type of each channel in the image
};

enum ocipInterpolationType
{
   ocipNearestNeighbour,
   ocipLinear,
   ocipCubic,
   ocipLanczos2,
   ocipLanczos3,
   ocipSuperSampling,
   ocipBestQuality,
};

ocipError ocipInitialize(ocipContext * ContextPtr, const char * PreferredPlatform, cl_device_type deviceType);

ocipError ocipUninitialize(ocipContext Context);

ocipError ocipChangeContext(ocipContext Context);

void ocipSetCLFilesPath(const char * Path);

const char * ocipGetErrorName(ocipError Error);

ocipError ocipGetDeviceName(char * Name, uint BufferLength);

ocipError ocipFinish();

ocipError ocipCreateImage( ocipImage * ImagePtr, SImage Image, void * ImageData, cl_mem_flags flags);

ocipError ocipSendImage( ocipImage Image);

ocipError ocipReadImage( ocipImage Image);

ocipError ocipReleaseImage(ocipImage Image);

ocipError ocipPrepareExample(ocipImage Image);

ocipError ocipPrepareExample2(ocipProgram * ProgramPtr, ocipImage Image);

ocipError ocipReleaseProgram(ocipProgram Program);

ocipError ocipPrepareConversion(ocipImage Image);

ocipError ocipConvert( ocipImage Source, ocipImage Dest);

ocipError ocipScale( ocipImage Source, ocipImage Dest);

ocipError ocipScale2( ocipImage Source, ocipImage Dest, int Offset, float Ratio);

ocipError ocipCopy( ocipImage Source, ocipImage Dest);

ocipError ocipToGray( ocipImage Source, ocipImage Dest);

ocipError ocipSelectChannel(ocipImage Source, ocipImage Dest, int ChannelNo);

ocipError ocipToColor( ocipImage Source, ocipImage Dest);

ocipError ocipPrepareArithmetic(ocipImage Image);

ocipError ocipAdd( ocipImage Source1, ocipImage Source2, ocipImage Dest);
ocipError ocipAddSquare(ocipImage Source1, ocipImage Source2, ocipImage Dest);
ocipError ocipSub( ocipImage Source1, ocipImage Source2, ocipImage Dest);
ocipError ocipAbsDiff( ocipImage Source1, ocipImage Source2, ocipImage Dest);
ocipError ocipMul( ocipImage Source1, ocipImage Source2, ocipImage Dest);
ocipError ocipDiv( ocipImage Source1, ocipImage Source2, ocipImage Dest);
ocipError ocipImgMin( ocipImage Source1, ocipImage Source2, ocipImage Dest);
ocipError ocipImgMax( ocipImage Source1, ocipImage Source2, ocipImage Dest);
ocipError ocipImgMean( ocipImage Source1, ocipImage Source2, ocipImage Dest);
ocipError ocipCombine( ocipImage Source1, ocipImage Source2, ocipImage Dest);

ocipError ocipAddC( ocipImage Source, ocipImage Dest, float value);
ocipError ocipSubC( ocipImage Source, ocipImage Dest, float value);
ocipError ocipAbsDiffC(ocipImage Source, ocipImage Dest, float value);
ocipError ocipMulC( ocipImage Source, ocipImage Dest, float value);
ocipError ocipDivC( ocipImage Source, ocipImage Dest, float value);
ocipError ocipRevDivC( ocipImage Source, ocipImage Dest, float value);
ocipError ocipMinC( ocipImage Source, ocipImage Dest, float value);
ocipError ocipMaxC( ocipImage Source, ocipImage Dest, float value);
ocipError ocipMeanC( ocipImage Source, ocipImage Dest, float value);

ocipError ocipAbs( ocipImage Source, ocipImage Dest);
ocipError ocipInvert( ocipImage Source, ocipImage Dest);
ocipError ocipSqr( ocipImage Source, ocipImage Dest);

ocipError ocipExp( ocipImage Source, ocipImage Dest);
ocipError ocipLog( ocipImage Source, ocipImage Dest);
ocipError ocipSqrt( ocipImage Source, ocipImage Dest);
ocipError ocipSin( ocipImage Source, ocipImage Dest);
ocipError ocipCos( ocipImage Source, ocipImage Dest);

ocipError ocipPrepareLogic(ocipImage Image);

ocipError ocipAnd( ocipImage Source1, ocipImage Source2, ocipImage Dest);
ocipError ocipOr( ocipImage Source1, ocipImage Source2, ocipImage Dest);
ocipError ocipXor( ocipImage Source1, ocipImage Source2, ocipImage Dest);
ocipError ocipAndC(ocipImage Source, ocipImage Dest, uint value);
ocipError ocipOrC( ocipImage Source, ocipImage Dest, uint value);
ocipError ocipXorC(ocipImage Source, ocipImage Dest, uint value);
ocipError ocipNot( ocipImage Source, ocipImage Dest);

ocipError ocipPrepareLUT(ocipImage Image);

ocipError ocipLut( ocipImage Source, ocipImage Dest, uint * levels, uint * values, int NbValues);

ocipError ocipLutLinear( ocipImage Source, ocipImage Dest, float * levels, float * values, int NbValues);

ocipError ocipBasicLut( ocipImage Source, ocipImage Dest, unsigned char * values);

ocipError ocipLutScale( ocipImage Source, ocipImage Dest, float SrcMin, float SrcMax, float DstMin, float DstMax);

ocipError ocipPrepareMorphology(ocipImage Image);

ocipError ocipErode( ocipImage Source, ocipImage Dest, int Width);
ocipError ocipDilate( ocipImage Source, ocipImage Dest, int Width);
ocipError ocipGradient( ocipImage Source, ocipImage Dest, ocipImage Temp, int Width);

ocipError ocipErode2( ocipImage Source, ocipImage Dest, ocipImage Temp, int Iterations, int Width);
ocipError ocipDilate2( ocipImage Source, ocipImage Dest, ocipImage Temp, int Iterations, int Width);
ocipError ocipOpen( ocipImage Source, ocipImage Dest, ocipImage Temp, int Depth, int Width);
ocipError ocipClose( ocipImage Source, ocipImage Dest, ocipImage Temp, int Depth, int Width);
ocipError ocipTopHat( ocipImage Source, ocipImage Dest, ocipImage Temp, int Depth, int Width);
ocipError ocipBlackHat( ocipImage Source, ocipImage Dest, ocipImage Temp, int Depth, int Width);

ocipError ocipPrepareTransform(ocipImage Image);

ocipError ocipMirrorX( ocipImage Source, ocipImage Dest);

ocipError ocipMirrorY( ocipImage Source, ocipImage Dest);

ocipError ocipFlip( ocipImage Source, ocipImage Dest);

ocipError ocipTranspose( ocipImage Source, ocipImage Dest);

ocipError ocipRotate( ocipImage Source, ocipImage Dest, double Angle, double XShift, double YShift, enum ocipInterpolationType Interpolation);

ocipError ocipResize( ocipImage Source, ocipImage Dest, enum ocipInterpolationType Interpolation, ocipBool KeepRatio);

ocipError ocipShear(ocipImage Source, ocipImage Dest, double ShearX, double ShearY, double XShift, double YShift, enum ocipInterpolationType Interpolation);

ocipError ocipRemap(ocipImage Source, ocipImage MapX, ocipImage MapY, ocipImage Dest, enum ocipInterpolationType Interpolation);

ocipError ocipSet( ocipImage Dest, float Value);

ocipError ocipPrepareFilters(ocipImage Image);

ocipError ocipGaussianBlur(ocipImage Source, ocipImage Dest, float Sigma);

ocipError ocipGauss( ocipImage Source, ocipImage Dest, int Width);

ocipError ocipSharpen( ocipImage Source, ocipImage Dest, int Width);

ocipError ocipSmooth( ocipImage Source, ocipImage Dest, int Width);

ocipError ocipMedian( ocipImage Source, ocipImage Dest, int Width);

ocipError ocipSobelVert( ocipImage Source, ocipImage Dest, int Width);

ocipError ocipSobelHoriz(ocipImage Source, ocipImage Dest, int Width);

ocipError ocipSobelCross(ocipImage Source, ocipImage Dest, int Width);

ocipError ocipSobel( ocipImage Source, ocipImage Dest, int Width);

ocipError ocipPrewittVert(ocipImage Source, ocipImage Dest, int Width);

ocipError ocipPrewittHoriz(ocipImage Source, ocipImage Dest, int Width);

ocipError ocipPrewitt( ocipImage Source, ocipImage Dest, int Width);

ocipError ocipScharrVert( ocipImage Source, ocipImage Dest, int Width);

ocipError ocipScharrHoriz( ocipImage Source, ocipImage Dest, int Width);

ocipError ocipScharr( ocipImage Source, ocipImage Dest, int Width);

ocipError ocipHipass( ocipImage Source, ocipImage Dest, int Width);

ocipError ocipLaplace( ocipImage Source, ocipImage Dest, int Width);

ocipError ocipPrepareHistogram(ocipImage Image);

ocipError ocipHistogram_1C(ocipImage Source, uint * Histogram);

ocipError ocipHistogram_4C(ocipImage Source, uint * Histogram);

ocipError ocipOtsuThreshold(ocipImage Source, uint * Value);

ocipError ocipPrepareStatistics(ocipProgram * ProgramPtr, ocipImage Image);

ocipError ocipMin( ocipProgram Program, ocipImage Source, double * Result);
ocipError ocipMax( ocipProgram Program, ocipImage Source, double * Result);
ocipError ocipMinAbs( ocipProgram Program, ocipImage Source, double * Result);
ocipError ocipMaxAbs( ocipProgram Program, ocipImage Source, double * Result);
ocipError ocipSum( ocipProgram Program, ocipImage Source, double * Result);
ocipError ocipSumSqr( ocipProgram Program, ocipImage Source, double * Result);
ocipError ocipMean( ocipProgram Program, ocipImage Source, double * Result);
ocipError ocipMeanSqr( ocipProgram Program, ocipImage Source, double * Result);
ocipError ocipStdDev( ocipProgram Program, ocipImage Source, double * Result);
ocipError ocipMean_StdDev( ocipProgram Program, ocipImage Source, double * Mean, double * StdDev);

ocipError ocipCountNonZero( ocipProgram Program, ocipImage Source, uint * Result);
ocipError ocipMinIndx( ocipProgram Program, ocipImage Source, double * Result, int * IndexX, int * IndexY);
ocipError ocipMaxIndx( ocipProgram Program, ocipImage Source, double * Result, int * IndexX, int * IndexY);
ocipError ocipMinAbsIndx( ocipProgram Program, ocipImage Source, double * Result, int * IndexX, int * IndexY);
ocipError ocipMaxAbsIndx( ocipProgram Program, ocipImage Source, double * Result, int * IndexX, int * IndexY);

ocipError ocipPrepareThresholding(ocipImage Image);

enum ECompareOperation { LT, LQ, EQ, GQ, GT, };

ocipError ocipThreshold( ocipImage Source, ocipImage Dest, float Thresh, float value, enum ECompareOperation Op);


ocipError ocipThresholdGTLT(ocipImage Source, ocipImage Dest, float threshLT, float valueLower, float threshGT, float valueHigher);


ocipError ocipThreshold_Img(ocipImage Source1, ocipImage Source2, ocipImage Dest, enum ECompareOperation Op);

ocipError ocipCompare( ocipImage Source1, ocipImage Source2, ocipImage Dest, enum ECompareOperation Op);

ocipError ocipCompareC( ocipImage Source, ocipImage Dest, float Value, enum ECompareOperation Op);

ocipError ocipPrepareBlob(ocipProgram * ProgramPtr, ocipImage Image);
ocipError ocipComputeLabels(ocipProgram Program, ocipImage Source, ocipImage Labels, int ConnectType);

ocipError ocipRenameLabels(ocipProgram Program, ocipImage Labels);

ocipError ocipPrepareFFT( ocipProgram * ProgramPtr, ocipImage RealImage, ocipImage ComplexImage);

ocipBool ocipIsFFTAvailable();

ocipError ocipFFTForward( ocipProgram Program, ocipImage RealSource, ocipImage ComplexDest);

ocipError ocipFFTInverse( ocipProgram Program, ocipImage ComplexSource, ocipImage RealDest);

ocipError ocipPrepareIntegral(ocipProgram * ProgramPtr, ocipImage Image);

ocipError ocipIntegral( ocipProgram Program, ocipImage Source, ocipImage Dest);

ocipError ocipSqrIntegral( ocipProgram Program, ocipImage Source, ocipImage Dest);

ocipError ocipPrepareProximity(ocipImage Image);

ocipError ocipSqrDistance_Norm(ocipImage Source, ocipImage Template, ocipImage Dest);

ocipError ocipSqrDistance(ocipImage Source, ocipImage Template, ocipImage Dest);

ocipError ocipAbsDistance(ocipImage Source, ocipImage Template, ocipImage Dest);

ocipError ocipCrossCorr(ocipImage Source, ocipImage Template, ocipImage Dest);

ocipError ocipCrossCorr_Norm(ocipImage Source, ocipImage Template, ocipImage Dest);

ocipError ocipPrepareImageProximityFFT(ocipProgram * ProgramPtr, ocipImage Image, ocipImage Template);

ocipError ocipSqrDistanceFFT(ocipProgram Program, ocipImage Source, ocipImage Template, ocipImage Dest);

ocipError ocipSqrDistanceFFT_Norm(ocipProgram Program, ocipImage Source, ocipImage Template, ocipImage Dest);

ocipError ocipCrossCorrFFT(ocipProgram Program, ocipImage Source, ocipImage Template, ocipImage Dest);


ocipError ocipCrossCorrFFT_Norm(ocipProgram Program, ocipImage Source, ocipImage Template, ocipImage Dest);

]]

clipp.C = ffi.load(package.searchpath('libclipp', package.cpath))
