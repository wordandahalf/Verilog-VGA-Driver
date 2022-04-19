#include <stdlib.h>
#include "VTop.h"

#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char *argv[])
{
    fprintf(stderr, "Starting XDN simulation!\n");
    uint64_t tickcount = 0;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;

    VTop *vxdn = new VTop;

    vxdn->trace(tfp, 99);
    tfp->open("trace.vcd");
    for(; tickcount < 640 * 480 ; )
    {
        tickcount++;

        vxdn->i_CLK             = 0;
        // vxdn->i_CYCLE_IMAGE     = 0;
        // vxdn->i_BLANK_DISPLAY   = 0;
        vxdn->eval();

        tfp->dump(10 * tickcount - 2);

        vxdn->i_CLK = 1;
        vxdn->eval();
        tfp->dump(10 * tickcount);
        
        vxdn->i_CLK = 0;
        vxdn->eval();
        tfp->dump(10 * tickcount + 5);
        tfp->flush();

    }
    tfp->close();

    return EXIT_SUCCESS;
}