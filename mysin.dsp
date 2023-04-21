import("stdfaust.lib");
process = os.osc(vslider("Volume[style:knob][acc: 0 0 -10 0 10]", 1000, 100, 10000, 1));

