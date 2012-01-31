#ifndef DEVICEINFO_H_
#define DEVICEINFO_H_

#include "cuda_runtime.h"

class CudaDeviceInfo {
public:
	int deviceCount;
	cudaDeviceProp* deviceProp;

	static void loadDeviceInfo();
	static int getDeviceCount();
	~CudaDeviceInfo();
protected:
	static CudaDeviceInfo& getInstance();
	CudaDeviceInfo();
};

#endif /* DEVICEINFO_H_ */
