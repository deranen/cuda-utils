PROJ_INC = include
PROJ_SRC = src
PROJ_BIN = bin
PROJ_CU_INC = $(PROJ_INC)/cuda
PROJ_CU_SRC = $(PROJ_SRC)/cuda

VPATH = $(PROJ_INC) $(PROJ_SRC) $(PROJ_CU_INC) $(PROJ_CU_SRC)

NVCC = nvcc
NVCCFLAGS = -m64 -arch=sm_20 \
            --compiler-bindir=/usr/local/gcc-4.4.6/bin
            
NVCCINCLUDES = -I$(PROJ_INC) -I$(PROJ_CU_INC)
                          
NVCCLDFLAGS = 

GCC = /usr/local/gcc-4.4.6/bin/gcc

GCCFLAGS = -g -m64 -Wall -O3
           
GCCINCLUDES = -I$(PROJ_INC) -I$(PROJ_CU_INC) \
              -I/usr/local/cuda/include
              
CUSOURCES := $(wildcard $(PROJ_CU_SRC)/*.cu)
CUHEADERS := $(wildcard $(PROJ_CU_INC)/*.cuh)
CUOBJECTS  = $(CUSOURCES:.cu=.o)

CPPSOURCES := $(wildcard $(PROJ_SRC)/*.cpp)
CPPHEADERS := $(wildcard $(PROJ_INC)/*.h)
CPPOBJECTS  = $(CPPSOURCES:.cpp=.o)

ALLOBJECTS = $(CPPOBJECTS) $(CUOBJECTS)

EXECUTABLE = $(PROJ_BIN)/main

.PHONY: all clean

all: $(EXECUTABLE)

$(EXECUTABLE): $(ALLOBJECTS)
	$(NVCC) $(NVCCLDFLAGS) $(ALLOBJECTS) -o $@
	
-include $(ALLOBJECTS:.o=.d)

%.o: %.cpp
	$(GCC) $(GCCINCLUDES) -c $< -o $@ $(GCCFLAGS)
	
%.o: %.cu
	$(NVCC) $(NVCCINCLUDES) -c $< -o $@ $(NVCCFLAGS)
	
%.d: %.cpp
	$(GCC) -MM -MT '$*.o $@' $(GCCFLAGS) $(GCCINCLUDES) $< > $@

%.d: %.cu
	$(GCC) -x c++ -MM -MT '$*.o $@' $(GCCFLAGS) $(NVCCINCLUDES) $(GCCINCLUDES) $< > $@

clean:
	rm -rf $(ALLOBJECTS) $(ALLOBJECTS:.o=.d) $(EXECUTABLE)
