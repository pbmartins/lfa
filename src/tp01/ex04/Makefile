CXX = g++
CXXFLAGS = -Wall

TARGETS = main-1 main-2

all:    $(TARGETS)

main-1: main-1.cpp calculate.cpp
	$(CXX) -o $@ $^ 

main-2: main-2.cpp m1.cpp
	$(CXX) -o $@ $^ 

cleanall:
	rm -f $(TARGETS)
