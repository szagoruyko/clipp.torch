////////////////////////////////////////////////////////////////////////////////
//! @file	: OpenCLIPP.hpp
//! @date   : Jan 2014
//!
//! @brief  : Main include file for C++ interface of OpenCLIPP
//! 
//! Copyright (C) 2014 - CRVI
//!
//! This file is part of OpenCLIPP.
//! 
//! OpenCLIPP is free software: you can redistribute it and/or modify
//! it under the terms of the GNU Lesser General Public License version 3
//! as published by the Free Software Foundation.
//! 
//! OpenCLIPP is distributed in the hope that it will be useful,
//! but WITHOUT ANY WARRANTY; without even the implied warranty of
//! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//! GNU Lesser General Public License for more details.
//! 
//! You should have received a copy of the GNU Lesser General Public License
//! along with OpenCLIPP.  If not, see <http://www.gnu.org/licenses/>.
//! 
////////////////////////////////////////////////////////////////////////////////

#include "src/OpenCL.h"
#include "src/Buffer.h"
#include "src/Image.h"
#include "src/Programs/Program.h"
#include "src/Programs/Arithmetic.h"
#include "src/Programs/Blob.h"
#include "src/Programs/Conversions.h"
#include "src/Programs/Filters.h"
#include "src/Programs/Histogram.h"
#include "src/Programs/Integral.h"
#include "src/Programs/Logic.h"
#include "src/Programs/Lut.h"
#include "src/Programs/Morphology.h"
#include "src/Programs/ImageProximity.h"
#include "src/Programs/ImageProximityFFT.h"
#include "src/Programs/Statistics.h"
#include "src/Programs/Transform.h"
#include "src/Programs/Thresholding.h"
#include "src/Programs/FFT.h"
