all: make_ratios

make_ratios: make_ratios.cc
	g++ -O3 -Wall -Wextra -Wno-attributes --std=c++11 -g `root-config --libs` `root-config --cflags` \
		make_ratios.cc -o make_ratios
