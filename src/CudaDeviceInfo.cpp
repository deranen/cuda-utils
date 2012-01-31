#include "CudaDeviceInfo.h"

#include <iostream>
#include <stdlib.h>

using namespace std;

CudaDeviceInfo& CudaDeviceInfo::getInstance()
{
	static CudaDeviceInfo deviceInfo;
	return deviceInfo;
}

int CudaDeviceInfo::getDeviceCount()
{
	return CudaDeviceInfo::getInstance().deviceCount;
}

void CudaDeviceInfo::loadDeviceInfo()
{
	CudaDeviceInfo::getInstance();
}

CudaDeviceInfo::CudaDeviceInfo()
{
    cudaError_t error_id = cudaGetDeviceCount(&deviceCount);
    if(error_id != cudaSuccess) {
        cout << cudaGetErrorString(error_id) << ". Exiting..." << endl;
        exit(1);
    }
    if (deviceCount == 0) {
    	cout << "There is no device supporting CUDA. Exiting..." << endl;
    	exit(0);
    }

    deviceProp = new cudaDeviceProp[deviceCount];

    for (int dev = 0; dev < deviceCount; dev++) {
        cudaGetDeviceProperties(&deviceProp[dev], dev);
    }
}

CudaDeviceInfo::~CudaDeviceInfo() {
	delete deviceProp;
}
