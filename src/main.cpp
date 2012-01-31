#include <iostream>

#include "CudaDeviceInfo.h"

using namespace std;

int main(int argc, char** argv)
{

	cout << "CUDA device count: " << CudaDeviceInfo::getDeviceCount() << endl;

	if(CudaDeviceInfo::getDeviceCount() > 1) {
		cudaSetDevice(1);
	}

	return 0;
}
