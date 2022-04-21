#include <stdlib.h>
#include <iostream>
#include <iomanip>
#include <fstream>
#include <math.h>

#include "VTop.h"
#include "VTop_Top.h"

#include "verilated.h"
#include "verilated_vcd_c.h"

#define MAX_SIM_TIME 2 * 800 * 525

int main(int argc, char *argv[])
{
    fprintf(stdout, "Starting XDN simulation...\n");

    // store pixel data for saving
    uint8_t *pixel_data = new uint8_t[640*480*3];
    uint64_t ptr = 0;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;

    VTop *dut = new VTop;

    dut->trace(tfp, 99);
    tfp->open("trace.vcd");

    uint64_t ticks = 0;

    while(!dut->o_VGA_VSYNC)
    {
        // Update the clock signal, evaluate the state of the design,
        // and dump the state to the trace file.
        dut->i_CLK ^= 1;
        dut->eval();

        // Clock has a frequency of 50 MHz, which means that each clock
        // oscillation takes 10 ns.
        tfp->dump(ticks * 10);
        ticks++;

        if (dut->o_VGA_CLK && dut->i_CLK && dut->o_DRAW_ENABLE) {
            pixel_data[ptr++] = dut->o_VGA_RED;
            pixel_data[ptr++] = dut->o_VGA_GREEN;
            pixel_data[ptr++] = dut->o_VGA_BLUE;
        }
    }
    tfp->close();
    delete dut;

    printf("Received %ld pixels of data.\n", ptr++);
    printf("Simulated %ld ticks (%.1f ms)\n", ticks, ticks / pow(10, 5));

    printf("Writing simulation results to file...\n");
    std::stringstream ss;
    ss << std::hex << std::setfill('0');
    for(int i = 0; i < 3*640*480; i++)
        ss << std::setw(2) << static_cast<unsigned>(pixel_data[i]);

    std::ofstream file("simulation.hex");
    if (file.is_open()) {
        file << ss.str();
    }
    file.close();

    return EXIT_SUCCESS;
}