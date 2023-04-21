import("stdfaust.lib");

process = os.osc(440) * vslider("Volume[style:knob][acc: 0 0 -10 0 10]", 0.5, 0, 1, 0.1);

