/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    work_m_00000000000921845704_3493794191_init();
    work_m_00000000003804802078_2203017034_init();
    work_m_00000000000762384770_3328827335_init();
    work_m_00000000003591904911_3076671627_init();
    work_m_00000000002422704941_2549720805_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000002422704941_2549720805");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}
