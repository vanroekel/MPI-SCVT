CC = mpic++
BDIR = /usr/projects/climate/SHARED_CLIMATE/software/mustang/boost/1.57.0/gcc-4.8.2/openmpi-1.6.5
NCDFDIR = /usr/projects/climate/SHARED_CLIMATE/software/mustang/netcdf/4.4.0/gcc-4.8.2
LIBS = -I${BDIR}/include/ -L${BDIR}/lib/ -lboost_mpi -lboost_serialization

ifeq ($(NETCDF),yes)
NCDFDIR = $NETCDF 
LIBS += -I$(NCDFDIR)/include/ -L$(NCDFDIR)/lib/ -lnetcdf -lnetcdf_c++
NCDF_FLAGS = -DUSE_NETCDF
endif

FLAGS = -O3 -m64 $(NCDF_FLAGS)
DFLAGS = -g -m64 -D_DEBUG
EXE=MpiScvt.x
TRISRC=Triangle/

PLATFORM=_MACOS
PLATFORM=_LINUX

ifeq ($(PLATFORM),_LINUX)
	FLAGS = -O3 -m64 -DLINUX $(NCDF_FLAGS)
	DFLAGS = -g -m64 -D_DEBUG -DLINUX
endif

ifeq ($(PLATFORM),_MACOS)
	FLAGS = -O3 -m64 $(NCDF_FLAGS)
	DFLAGS = -g -m64 -D_DEBUG
endif

TRILIBDEFS= -DTRILIBRARY

all: trilibrary
	${CC} scvt-mpi.cpp ${TRISRC}triangle.o ${LIBS} ${FLAGS} -o ${EXE}

debug: trilibrary-debug
	${CC} scvt-mpi.cpp ${TRISRC}triangle.o ${LIBS} ${DFLAGS} -o ${EXE}

trilibrary:
	$(CC) $(CSWITCHES) $(TRILIBDEFS) ${FLAGS} -c -o ${TRISRC}triangle.o ${TRISRC}triangle.c

trilibrary-debug:
	$(CC) $(CSWITCHES) $(TRILIBDEFS) ${DFLAGS} -c -o ${TRISRC}triangle.o ${TRISRC}triangle.c

clean:
	rm -f *.dat ${EXE} ${TRISRC}triangle.o
