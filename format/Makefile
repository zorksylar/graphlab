
CXX?=g++
CXXFLAGS?=-fPIC -O3 -g -Wall -std=c++11
LDFLAGS?=-lglog -lgflags
INCLUDES?=-I.

snap2glabmtx : snap2glabmtx.o
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)

snap2glabmtx.o : snap2glabmtx.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

all : snap2glabmtx


.PHONY:

clean : 
	rm -f snap2glabmtx
	rm -f snap2glabmtx.o
	
