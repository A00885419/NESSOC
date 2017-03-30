// nesTop.v

// Generated using ACDS version 16.1 196

`timescale 1 ps / 1 ps
module nesTop (
		input  wire       clk_clk,       //   clk.clk
		output wire [7:0] led_export,    //   led.export
		input  wire       reset_reset_n  // reset.reset_n
	);

	wire         processor_debug_reset_request_reset;                       // processor:debug_reset_request -> altmemddr_0:soft_reset_n
	wire  [31:0] processor_data_master_readdata;                            // mm_interconnect_0:processor_data_master_readdata -> processor:d_readdata
	wire         processor_data_master_waitrequest;                         // mm_interconnect_0:processor_data_master_waitrequest -> processor:d_waitrequest
	wire         processor_data_master_debugaccess;                         // processor:debug_mem_slave_debugaccess_to_roms -> mm_interconnect_0:processor_data_master_debugaccess
	wire  [16:0] processor_data_master_address;                             // processor:d_address -> mm_interconnect_0:processor_data_master_address
	wire   [3:0] processor_data_master_byteenable;                          // processor:d_byteenable -> mm_interconnect_0:processor_data_master_byteenable
	wire         processor_data_master_read;                                // processor:d_read -> mm_interconnect_0:processor_data_master_read
	wire         processor_data_master_write;                               // processor:d_write -> mm_interconnect_0:processor_data_master_write
	wire  [31:0] processor_data_master_writedata;                           // processor:d_writedata -> mm_interconnect_0:processor_data_master_writedata
	wire  [31:0] processor_instruction_master_readdata;                     // mm_interconnect_0:processor_instruction_master_readdata -> processor:i_readdata
	wire         processor_instruction_master_waitrequest;                  // mm_interconnect_0:processor_instruction_master_waitrequest -> processor:i_waitrequest
	wire  [16:0] processor_instruction_master_address;                      // processor:i_address -> mm_interconnect_0:processor_instruction_master_address
	wire         processor_instruction_master_read;                         // processor:i_read -> mm_interconnect_0:processor_instruction_master_read
	wire         mm_interconnect_0_jtag_uart_avalon_jtag_slave_chipselect;  // mm_interconnect_0:jtag_uart_avalon_jtag_slave_chipselect -> jtag_uart:av_chipselect
	wire  [31:0] mm_interconnect_0_jtag_uart_avalon_jtag_slave_readdata;    // jtag_uart:av_readdata -> mm_interconnect_0:jtag_uart_avalon_jtag_slave_readdata
	wire         mm_interconnect_0_jtag_uart_avalon_jtag_slave_waitrequest; // jtag_uart:av_waitrequest -> mm_interconnect_0:jtag_uart_avalon_jtag_slave_waitrequest
	wire   [0:0] mm_interconnect_0_jtag_uart_avalon_jtag_slave_address;     // mm_interconnect_0:jtag_uart_avalon_jtag_slave_address -> jtag_uart:av_address
	wire         mm_interconnect_0_jtag_uart_avalon_jtag_slave_read;        // mm_interconnect_0:jtag_uart_avalon_jtag_slave_read -> jtag_uart:av_read_n
	wire         mm_interconnect_0_jtag_uart_avalon_jtag_slave_write;       // mm_interconnect_0:jtag_uart_avalon_jtag_slave_write -> jtag_uart:av_write_n
	wire  [31:0] mm_interconnect_0_jtag_uart_avalon_jtag_slave_writedata;   // mm_interconnect_0:jtag_uart_avalon_jtag_slave_writedata -> jtag_uart:av_writedata
	wire  [31:0] mm_interconnect_0_processor_debug_mem_slave_readdata;      // processor:debug_mem_slave_readdata -> mm_interconnect_0:processor_debug_mem_slave_readdata
	wire         mm_interconnect_0_processor_debug_mem_slave_waitrequest;   // processor:debug_mem_slave_waitrequest -> mm_interconnect_0:processor_debug_mem_slave_waitrequest
	wire         mm_interconnect_0_processor_debug_mem_slave_debugaccess;   // mm_interconnect_0:processor_debug_mem_slave_debugaccess -> processor:debug_mem_slave_debugaccess
	wire   [8:0] mm_interconnect_0_processor_debug_mem_slave_address;       // mm_interconnect_0:processor_debug_mem_slave_address -> processor:debug_mem_slave_address
	wire         mm_interconnect_0_processor_debug_mem_slave_read;          // mm_interconnect_0:processor_debug_mem_slave_read -> processor:debug_mem_slave_read
	wire   [3:0] mm_interconnect_0_processor_debug_mem_slave_byteenable;    // mm_interconnect_0:processor_debug_mem_slave_byteenable -> processor:debug_mem_slave_byteenable
	wire         mm_interconnect_0_processor_debug_mem_slave_write;         // mm_interconnect_0:processor_debug_mem_slave_write -> processor:debug_mem_slave_write
	wire  [31:0] mm_interconnect_0_processor_debug_mem_slave_writedata;     // mm_interconnect_0:processor_debug_mem_slave_writedata -> processor:debug_mem_slave_writedata
	wire         mm_interconnect_0_memory_s1_chipselect;                    // mm_interconnect_0:memory_s1_chipselect -> memory:chipselect
	wire  [31:0] mm_interconnect_0_memory_s1_readdata;                      // memory:readdata -> mm_interconnect_0:memory_s1_readdata
	wire  [12:0] mm_interconnect_0_memory_s1_address;                       // mm_interconnect_0:memory_s1_address -> memory:address
	wire   [3:0] mm_interconnect_0_memory_s1_byteenable;                    // mm_interconnect_0:memory_s1_byteenable -> memory:byteenable
	wire         mm_interconnect_0_memory_s1_write;                         // mm_interconnect_0:memory_s1_write -> memory:write
	wire  [31:0] mm_interconnect_0_memory_s1_writedata;                     // mm_interconnect_0:memory_s1_writedata -> memory:writedata
	wire         mm_interconnect_0_memory_s1_clken;                         // mm_interconnect_0:memory_s1_clken -> memory:clken
	wire         mm_interconnect_0_timer_s1_chipselect;                     // mm_interconnect_0:timer_s1_chipselect -> timer:chipselect
	wire  [15:0] mm_interconnect_0_timer_s1_readdata;                       // timer:readdata -> mm_interconnect_0:timer_s1_readdata
	wire   [2:0] mm_interconnect_0_timer_s1_address;                        // mm_interconnect_0:timer_s1_address -> timer:address
	wire         mm_interconnect_0_timer_s1_write;                          // mm_interconnect_0:timer_s1_write -> timer:write_n
	wire  [15:0] mm_interconnect_0_timer_s1_writedata;                      // mm_interconnect_0:timer_s1_writedata -> timer:writedata
	wire         mm_interconnect_0_pio_s1_chipselect;                       // mm_interconnect_0:pio_s1_chipselect -> pio:chipselect
	wire  [31:0] mm_interconnect_0_pio_s1_readdata;                         // pio:readdata -> mm_interconnect_0:pio_s1_readdata
	wire   [1:0] mm_interconnect_0_pio_s1_address;                          // mm_interconnect_0:pio_s1_address -> pio:address
	wire         mm_interconnect_0_pio_s1_write;                            // mm_interconnect_0:pio_s1_write -> pio:write_n
	wire  [31:0] mm_interconnect_0_pio_s1_writedata;                        // mm_interconnect_0:pio_s1_writedata -> pio:writedata
	wire         irq_mapper_receiver0_irq;                                  // timer:irq -> irq_mapper:receiver0_irq
	wire         irq_mapper_receiver1_irq;                                  // jtag_uart:av_irq -> irq_mapper:receiver1_irq
	wire  [31:0] processor_irq_irq;                                         // irq_mapper:sender_irq -> processor:irq
	wire         rst_controller_reset_out_reset;                            // rst_controller:reset_out -> altmemddr_0:global_reset_n
	wire         altmemddr_0_reset_request_n_reset;                         // altmemddr_0:reset_request_n -> [rst_controller:reset_in0, rst_controller_002:reset_in1]
	wire         rst_controller_001_reset_out_reset;                        // rst_controller_001:reset_out -> [jtag_uart:rst_n, mm_interconnect_0:jtag_uart_reset_reset_bridge_in_reset_reset]
	wire         rst_controller_002_reset_out_reset;                        // rst_controller_002:reset_out -> [irq_mapper:reset, memory:reset, mm_interconnect_0:processor_reset_reset_bridge_in_reset_reset, pio:reset_n, processor:reset_n, rst_translator:in_reset, timer:reset_n]
	wire         rst_controller_002_reset_out_reset_req;                    // rst_controller_002:reset_req -> [memory:reset_req, processor:reset_req, rst_translator:reset_req_in]

	nesTop_altmemddr_0 altmemddr_0 (
		.local_address     (),                                     //                  s1.address
		.local_write_req   (),                                     //                    .write
		.local_read_req    (),                                     //                    .read
		.local_burstbegin  (),                                     //                    .beginbursttransfer
		.local_ready       (),                                     //                    .waitrequest_n
		.local_rdata       (),                                     //                    .readdata
		.local_rdata_valid (),                                     //                    .readdatavalid
		.local_wdata       (),                                     //                    .writedata
		.local_be          (),                                     //                    .byteenable
		.local_size        (),                                     //                    .burstcount
		.local_refresh_ack (),                                     // external_connection.export
		.local_init_done   (),                                     //                    .export
		.reset_phy_clk_n   (),                                     //                    .export
		.mem_odt           (),                                     //              memory.mem_odt
		.mem_clk           (),                                     //                    .mem_clk
		.mem_clk_n         (),                                     //                    .mem_clk_n
		.mem_cs_n          (),                                     //                    .mem_cs_n
		.mem_cke           (),                                     //                    .mem_cke
		.mem_addr          (),                                     //                    .mem_addr
		.mem_ba            (),                                     //                    .mem_ba
		.mem_ras_n         (),                                     //                    .mem_ras_n
		.mem_cas_n         (),                                     //                    .mem_cas_n
		.mem_we_n          (),                                     //                    .mem_we_n
		.mem_dq            (),                                     //                    .mem_dq
		.mem_dqs           (),                                     //                    .mem_dqs
		.mem_dm            (),                                     //                    .mem_dm
		.pll_ref_clk       (clk_clk),                              //              refclk.clk
		.soft_reset_n      (~processor_debug_reset_request_reset), //        soft_reset_n.reset_n
		.global_reset_n    (~rst_controller_reset_out_reset),      //      global_reset_n.reset_n
		.reset_request_n   (altmemddr_0_reset_request_n_reset),    //     reset_request_n.reset_n
		.phy_clk           (),                                     //              sysclk.clk
		.aux_full_rate_clk (),                                     //             auxfull.clk
		.aux_half_rate_clk ()                                      //             auxhalf.clk
	);

	nesTop_jtag_uart jtag_uart (
		.clk            (clk_clk),                                                   //               clk.clk
		.rst_n          (~rst_controller_001_reset_out_reset),                       //             reset.reset_n
		.av_chipselect  (mm_interconnect_0_jtag_uart_avalon_jtag_slave_chipselect),  // avalon_jtag_slave.chipselect
		.av_address     (mm_interconnect_0_jtag_uart_avalon_jtag_slave_address),     //                  .address
		.av_read_n      (~mm_interconnect_0_jtag_uart_avalon_jtag_slave_read),       //                  .read_n
		.av_readdata    (mm_interconnect_0_jtag_uart_avalon_jtag_slave_readdata),    //                  .readdata
		.av_write_n     (~mm_interconnect_0_jtag_uart_avalon_jtag_slave_write),      //                  .write_n
		.av_writedata   (mm_interconnect_0_jtag_uart_avalon_jtag_slave_writedata),   //                  .writedata
		.av_waitrequest (mm_interconnect_0_jtag_uart_avalon_jtag_slave_waitrequest), //                  .waitrequest
		.av_irq         (irq_mapper_receiver1_irq)                                   //               irq.irq
	);

	nesTop_memory memory (
		.clk        (clk_clk),                                //   clk1.clk
		.address    (mm_interconnect_0_memory_s1_address),    //     s1.address
		.clken      (mm_interconnect_0_memory_s1_clken),      //       .clken
		.chipselect (mm_interconnect_0_memory_s1_chipselect), //       .chipselect
		.write      (mm_interconnect_0_memory_s1_write),      //       .write
		.readdata   (mm_interconnect_0_memory_s1_readdata),   //       .readdata
		.writedata  (mm_interconnect_0_memory_s1_writedata),  //       .writedata
		.byteenable (mm_interconnect_0_memory_s1_byteenable), //       .byteenable
		.reset      (rst_controller_002_reset_out_reset),     // reset1.reset
		.reset_req  (rst_controller_002_reset_out_reset_req), //       .reset_req
		.freeze     (1'b0)                                    // (terminated)
	);

	nesTop_pio pio (
		.clk        (clk_clk),                             //                 clk.clk
		.reset_n    (~rst_controller_002_reset_out_reset), //               reset.reset_n
		.address    (mm_interconnect_0_pio_s1_address),    //                  s1.address
		.write_n    (~mm_interconnect_0_pio_s1_write),     //                    .write_n
		.writedata  (mm_interconnect_0_pio_s1_writedata),  //                    .writedata
		.chipselect (mm_interconnect_0_pio_s1_chipselect), //                    .chipselect
		.readdata   (mm_interconnect_0_pio_s1_readdata),   //                    .readdata
		.out_port   (led_export)                           // external_connection.export
	);

	nesTop_processor processor (
		.clk                                 (clk_clk),                                                 //                       clk.clk
		.reset_n                             (~rst_controller_002_reset_out_reset),                     //                     reset.reset_n
		.reset_req                           (rst_controller_002_reset_out_reset_req),                  //                          .reset_req
		.d_address                           (processor_data_master_address),                           //               data_master.address
		.d_byteenable                        (processor_data_master_byteenable),                        //                          .byteenable
		.d_read                              (processor_data_master_read),                              //                          .read
		.d_readdata                          (processor_data_master_readdata),                          //                          .readdata
		.d_waitrequest                       (processor_data_master_waitrequest),                       //                          .waitrequest
		.d_write                             (processor_data_master_write),                             //                          .write
		.d_writedata                         (processor_data_master_writedata),                         //                          .writedata
		.debug_mem_slave_debugaccess_to_roms (processor_data_master_debugaccess),                       //                          .debugaccess
		.i_address                           (processor_instruction_master_address),                    //        instruction_master.address
		.i_read                              (processor_instruction_master_read),                       //                          .read
		.i_readdata                          (processor_instruction_master_readdata),                   //                          .readdata
		.i_waitrequest                       (processor_instruction_master_waitrequest),                //                          .waitrequest
		.irq                                 (processor_irq_irq),                                       //                       irq.irq
		.debug_reset_request                 (processor_debug_reset_request_reset),                     //       debug_reset_request.reset
		.debug_mem_slave_address             (mm_interconnect_0_processor_debug_mem_slave_address),     //           debug_mem_slave.address
		.debug_mem_slave_byteenable          (mm_interconnect_0_processor_debug_mem_slave_byteenable),  //                          .byteenable
		.debug_mem_slave_debugaccess         (mm_interconnect_0_processor_debug_mem_slave_debugaccess), //                          .debugaccess
		.debug_mem_slave_read                (mm_interconnect_0_processor_debug_mem_slave_read),        //                          .read
		.debug_mem_slave_readdata            (mm_interconnect_0_processor_debug_mem_slave_readdata),    //                          .readdata
		.debug_mem_slave_waitrequest         (mm_interconnect_0_processor_debug_mem_slave_waitrequest), //                          .waitrequest
		.debug_mem_slave_write               (mm_interconnect_0_processor_debug_mem_slave_write),       //                          .write
		.debug_mem_slave_writedata           (mm_interconnect_0_processor_debug_mem_slave_writedata),   //                          .writedata
		.dummy_ci_port                       ()                                                         // custom_instruction_master.readra
	);

	nesTop_timer timer (
		.clk        (clk_clk),                               //   clk.clk
		.reset_n    (~rst_controller_002_reset_out_reset),   // reset.reset_n
		.address    (mm_interconnect_0_timer_s1_address),    //    s1.address
		.writedata  (mm_interconnect_0_timer_s1_writedata),  //      .writedata
		.readdata   (mm_interconnect_0_timer_s1_readdata),   //      .readdata
		.chipselect (mm_interconnect_0_timer_s1_chipselect), //      .chipselect
		.write_n    (~mm_interconnect_0_timer_s1_write),     //      .write_n
		.irq        (irq_mapper_receiver0_irq)               //   irq.irq
	);

	nesTop_mm_interconnect_0 mm_interconnect_0 (
		.clock_clk_clk                               (clk_clk),                                                   //                             clock_clk.clk
		.jtag_uart_reset_reset_bridge_in_reset_reset (rst_controller_001_reset_out_reset),                        // jtag_uart_reset_reset_bridge_in_reset.reset
		.processor_reset_reset_bridge_in_reset_reset (rst_controller_002_reset_out_reset),                        // processor_reset_reset_bridge_in_reset.reset
		.processor_data_master_address               (processor_data_master_address),                             //                 processor_data_master.address
		.processor_data_master_waitrequest           (processor_data_master_waitrequest),                         //                                      .waitrequest
		.processor_data_master_byteenable            (processor_data_master_byteenable),                          //                                      .byteenable
		.processor_data_master_read                  (processor_data_master_read),                                //                                      .read
		.processor_data_master_readdata              (processor_data_master_readdata),                            //                                      .readdata
		.processor_data_master_write                 (processor_data_master_write),                               //                                      .write
		.processor_data_master_writedata             (processor_data_master_writedata),                           //                                      .writedata
		.processor_data_master_debugaccess           (processor_data_master_debugaccess),                         //                                      .debugaccess
		.processor_instruction_master_address        (processor_instruction_master_address),                      //          processor_instruction_master.address
		.processor_instruction_master_waitrequest    (processor_instruction_master_waitrequest),                  //                                      .waitrequest
		.processor_instruction_master_read           (processor_instruction_master_read),                         //                                      .read
		.processor_instruction_master_readdata       (processor_instruction_master_readdata),                     //                                      .readdata
		.jtag_uart_avalon_jtag_slave_address         (mm_interconnect_0_jtag_uart_avalon_jtag_slave_address),     //           jtag_uart_avalon_jtag_slave.address
		.jtag_uart_avalon_jtag_slave_write           (mm_interconnect_0_jtag_uart_avalon_jtag_slave_write),       //                                      .write
		.jtag_uart_avalon_jtag_slave_read            (mm_interconnect_0_jtag_uart_avalon_jtag_slave_read),        //                                      .read
		.jtag_uart_avalon_jtag_slave_readdata        (mm_interconnect_0_jtag_uart_avalon_jtag_slave_readdata),    //                                      .readdata
		.jtag_uart_avalon_jtag_slave_writedata       (mm_interconnect_0_jtag_uart_avalon_jtag_slave_writedata),   //                                      .writedata
		.jtag_uart_avalon_jtag_slave_waitrequest     (mm_interconnect_0_jtag_uart_avalon_jtag_slave_waitrequest), //                                      .waitrequest
		.jtag_uart_avalon_jtag_slave_chipselect      (mm_interconnect_0_jtag_uart_avalon_jtag_slave_chipselect),  //                                      .chipselect
		.memory_s1_address                           (mm_interconnect_0_memory_s1_address),                       //                             memory_s1.address
		.memory_s1_write                             (mm_interconnect_0_memory_s1_write),                         //                                      .write
		.memory_s1_readdata                          (mm_interconnect_0_memory_s1_readdata),                      //                                      .readdata
		.memory_s1_writedata                         (mm_interconnect_0_memory_s1_writedata),                     //                                      .writedata
		.memory_s1_byteenable                        (mm_interconnect_0_memory_s1_byteenable),                    //                                      .byteenable
		.memory_s1_chipselect                        (mm_interconnect_0_memory_s1_chipselect),                    //                                      .chipselect
		.memory_s1_clken                             (mm_interconnect_0_memory_s1_clken),                         //                                      .clken
		.pio_s1_address                              (mm_interconnect_0_pio_s1_address),                          //                                pio_s1.address
		.pio_s1_write                                (mm_interconnect_0_pio_s1_write),                            //                                      .write
		.pio_s1_readdata                             (mm_interconnect_0_pio_s1_readdata),                         //                                      .readdata
		.pio_s1_writedata                            (mm_interconnect_0_pio_s1_writedata),                        //                                      .writedata
		.pio_s1_chipselect                           (mm_interconnect_0_pio_s1_chipselect),                       //                                      .chipselect
		.processor_debug_mem_slave_address           (mm_interconnect_0_processor_debug_mem_slave_address),       //             processor_debug_mem_slave.address
		.processor_debug_mem_slave_write             (mm_interconnect_0_processor_debug_mem_slave_write),         //                                      .write
		.processor_debug_mem_slave_read              (mm_interconnect_0_processor_debug_mem_slave_read),          //                                      .read
		.processor_debug_mem_slave_readdata          (mm_interconnect_0_processor_debug_mem_slave_readdata),      //                                      .readdata
		.processor_debug_mem_slave_writedata         (mm_interconnect_0_processor_debug_mem_slave_writedata),     //                                      .writedata
		.processor_debug_mem_slave_byteenable        (mm_interconnect_0_processor_debug_mem_slave_byteenable),    //                                      .byteenable
		.processor_debug_mem_slave_waitrequest       (mm_interconnect_0_processor_debug_mem_slave_waitrequest),   //                                      .waitrequest
		.processor_debug_mem_slave_debugaccess       (mm_interconnect_0_processor_debug_mem_slave_debugaccess),   //                                      .debugaccess
		.timer_s1_address                            (mm_interconnect_0_timer_s1_address),                        //                              timer_s1.address
		.timer_s1_write                              (mm_interconnect_0_timer_s1_write),                          //                                      .write
		.timer_s1_readdata                           (mm_interconnect_0_timer_s1_readdata),                       //                                      .readdata
		.timer_s1_writedata                          (mm_interconnect_0_timer_s1_writedata),                      //                                      .writedata
		.timer_s1_chipselect                         (mm_interconnect_0_timer_s1_chipselect)                      //                                      .chipselect
	);

	nesTop_irq_mapper irq_mapper (
		.clk           (clk_clk),                            //       clk.clk
		.reset         (rst_controller_002_reset_out_reset), // clk_reset.reset
		.receiver0_irq (irq_mapper_receiver0_irq),           // receiver0.irq
		.receiver1_irq (irq_mapper_receiver1_irq),           // receiver1.irq
		.sender_irq    (processor_irq_irq)                   //    sender.irq
	);

	altera_reset_controller #(
		.NUM_RESET_INPUTS          (1),
		.OUTPUT_RESET_SYNC_EDGES   ("deassert"),
		.SYNC_DEPTH                (2),
		.RESET_REQUEST_PRESENT     (0),
		.RESET_REQ_WAIT_TIME       (1),
		.MIN_RST_ASSERTION_TIME    (3),
		.RESET_REQ_EARLY_DSRT_TIME (1),
		.USE_RESET_REQUEST_IN0     (0),
		.USE_RESET_REQUEST_IN1     (0),
		.USE_RESET_REQUEST_IN2     (0),
		.USE_RESET_REQUEST_IN3     (0),
		.USE_RESET_REQUEST_IN4     (0),
		.USE_RESET_REQUEST_IN5     (0),
		.USE_RESET_REQUEST_IN6     (0),
		.USE_RESET_REQUEST_IN7     (0),
		.USE_RESET_REQUEST_IN8     (0),
		.USE_RESET_REQUEST_IN9     (0),
		.USE_RESET_REQUEST_IN10    (0),
		.USE_RESET_REQUEST_IN11    (0),
		.USE_RESET_REQUEST_IN12    (0),
		.USE_RESET_REQUEST_IN13    (0),
		.USE_RESET_REQUEST_IN14    (0),
		.USE_RESET_REQUEST_IN15    (0),
		.ADAPT_RESET_REQUEST       (0)
	) rst_controller (
		.reset_in0      (~altmemddr_0_reset_request_n_reset), // reset_in0.reset
		.clk            (clk_clk),                            //       clk.clk
		.reset_out      (rst_controller_reset_out_reset),     // reset_out.reset
		.reset_req      (),                                   // (terminated)
		.reset_req_in0  (1'b0),                               // (terminated)
		.reset_in1      (1'b0),                               // (terminated)
		.reset_req_in1  (1'b0),                               // (terminated)
		.reset_in2      (1'b0),                               // (terminated)
		.reset_req_in2  (1'b0),                               // (terminated)
		.reset_in3      (1'b0),                               // (terminated)
		.reset_req_in3  (1'b0),                               // (terminated)
		.reset_in4      (1'b0),                               // (terminated)
		.reset_req_in4  (1'b0),                               // (terminated)
		.reset_in5      (1'b0),                               // (terminated)
		.reset_req_in5  (1'b0),                               // (terminated)
		.reset_in6      (1'b0),                               // (terminated)
		.reset_req_in6  (1'b0),                               // (terminated)
		.reset_in7      (1'b0),                               // (terminated)
		.reset_req_in7  (1'b0),                               // (terminated)
		.reset_in8      (1'b0),                               // (terminated)
		.reset_req_in8  (1'b0),                               // (terminated)
		.reset_in9      (1'b0),                               // (terminated)
		.reset_req_in9  (1'b0),                               // (terminated)
		.reset_in10     (1'b0),                               // (terminated)
		.reset_req_in10 (1'b0),                               // (terminated)
		.reset_in11     (1'b0),                               // (terminated)
		.reset_req_in11 (1'b0),                               // (terminated)
		.reset_in12     (1'b0),                               // (terminated)
		.reset_req_in12 (1'b0),                               // (terminated)
		.reset_in13     (1'b0),                               // (terminated)
		.reset_req_in13 (1'b0),                               // (terminated)
		.reset_in14     (1'b0),                               // (terminated)
		.reset_req_in14 (1'b0),                               // (terminated)
		.reset_in15     (1'b0),                               // (terminated)
		.reset_req_in15 (1'b0)                                // (terminated)
	);

	altera_reset_controller #(
		.NUM_RESET_INPUTS          (1),
		.OUTPUT_RESET_SYNC_EDGES   ("deassert"),
		.SYNC_DEPTH                (2),
		.RESET_REQUEST_PRESENT     (0),
		.RESET_REQ_WAIT_TIME       (1),
		.MIN_RST_ASSERTION_TIME    (3),
		.RESET_REQ_EARLY_DSRT_TIME (1),
		.USE_RESET_REQUEST_IN0     (0),
		.USE_RESET_REQUEST_IN1     (0),
		.USE_RESET_REQUEST_IN2     (0),
		.USE_RESET_REQUEST_IN3     (0),
		.USE_RESET_REQUEST_IN4     (0),
		.USE_RESET_REQUEST_IN5     (0),
		.USE_RESET_REQUEST_IN6     (0),
		.USE_RESET_REQUEST_IN7     (0),
		.USE_RESET_REQUEST_IN8     (0),
		.USE_RESET_REQUEST_IN9     (0),
		.USE_RESET_REQUEST_IN10    (0),
		.USE_RESET_REQUEST_IN11    (0),
		.USE_RESET_REQUEST_IN12    (0),
		.USE_RESET_REQUEST_IN13    (0),
		.USE_RESET_REQUEST_IN14    (0),
		.USE_RESET_REQUEST_IN15    (0),
		.ADAPT_RESET_REQUEST       (0)
	) rst_controller_001 (
		.reset_in0      (~reset_reset_n),                     // reset_in0.reset
		.clk            (clk_clk),                            //       clk.clk
		.reset_out      (rst_controller_001_reset_out_reset), // reset_out.reset
		.reset_req      (),                                   // (terminated)
		.reset_req_in0  (1'b0),                               // (terminated)
		.reset_in1      (1'b0),                               // (terminated)
		.reset_req_in1  (1'b0),                               // (terminated)
		.reset_in2      (1'b0),                               // (terminated)
		.reset_req_in2  (1'b0),                               // (terminated)
		.reset_in3      (1'b0),                               // (terminated)
		.reset_req_in3  (1'b0),                               // (terminated)
		.reset_in4      (1'b0),                               // (terminated)
		.reset_req_in4  (1'b0),                               // (terminated)
		.reset_in5      (1'b0),                               // (terminated)
		.reset_req_in5  (1'b0),                               // (terminated)
		.reset_in6      (1'b0),                               // (terminated)
		.reset_req_in6  (1'b0),                               // (terminated)
		.reset_in7      (1'b0),                               // (terminated)
		.reset_req_in7  (1'b0),                               // (terminated)
		.reset_in8      (1'b0),                               // (terminated)
		.reset_req_in8  (1'b0),                               // (terminated)
		.reset_in9      (1'b0),                               // (terminated)
		.reset_req_in9  (1'b0),                               // (terminated)
		.reset_in10     (1'b0),                               // (terminated)
		.reset_req_in10 (1'b0),                               // (terminated)
		.reset_in11     (1'b0),                               // (terminated)
		.reset_req_in11 (1'b0),                               // (terminated)
		.reset_in12     (1'b0),                               // (terminated)
		.reset_req_in12 (1'b0),                               // (terminated)
		.reset_in13     (1'b0),                               // (terminated)
		.reset_req_in13 (1'b0),                               // (terminated)
		.reset_in14     (1'b0),                               // (terminated)
		.reset_req_in14 (1'b0),                               // (terminated)
		.reset_in15     (1'b0),                               // (terminated)
		.reset_req_in15 (1'b0)                                // (terminated)
	);

	altera_reset_controller #(
		.NUM_RESET_INPUTS          (2),
		.OUTPUT_RESET_SYNC_EDGES   ("deassert"),
		.SYNC_DEPTH                (2),
		.RESET_REQUEST_PRESENT     (1),
		.RESET_REQ_WAIT_TIME       (1),
		.MIN_RST_ASSERTION_TIME    (3),
		.RESET_REQ_EARLY_DSRT_TIME (1),
		.USE_RESET_REQUEST_IN0     (0),
		.USE_RESET_REQUEST_IN1     (0),
		.USE_RESET_REQUEST_IN2     (0),
		.USE_RESET_REQUEST_IN3     (0),
		.USE_RESET_REQUEST_IN4     (0),
		.USE_RESET_REQUEST_IN5     (0),
		.USE_RESET_REQUEST_IN6     (0),
		.USE_RESET_REQUEST_IN7     (0),
		.USE_RESET_REQUEST_IN8     (0),
		.USE_RESET_REQUEST_IN9     (0),
		.USE_RESET_REQUEST_IN10    (0),
		.USE_RESET_REQUEST_IN11    (0),
		.USE_RESET_REQUEST_IN12    (0),
		.USE_RESET_REQUEST_IN13    (0),
		.USE_RESET_REQUEST_IN14    (0),
		.USE_RESET_REQUEST_IN15    (0),
		.ADAPT_RESET_REQUEST       (0)
	) rst_controller_002 (
		.reset_in0      (~reset_reset_n),                         // reset_in0.reset
		.reset_in1      (~altmemddr_0_reset_request_n_reset),     // reset_in1.reset
		.clk            (clk_clk),                                //       clk.clk
		.reset_out      (rst_controller_002_reset_out_reset),     // reset_out.reset
		.reset_req      (rst_controller_002_reset_out_reset_req), //          .reset_req
		.reset_req_in0  (1'b0),                                   // (terminated)
		.reset_req_in1  (1'b0),                                   // (terminated)
		.reset_in2      (1'b0),                                   // (terminated)
		.reset_req_in2  (1'b0),                                   // (terminated)
		.reset_in3      (1'b0),                                   // (terminated)
		.reset_req_in3  (1'b0),                                   // (terminated)
		.reset_in4      (1'b0),                                   // (terminated)
		.reset_req_in4  (1'b0),                                   // (terminated)
		.reset_in5      (1'b0),                                   // (terminated)
		.reset_req_in5  (1'b0),                                   // (terminated)
		.reset_in6      (1'b0),                                   // (terminated)
		.reset_req_in6  (1'b0),                                   // (terminated)
		.reset_in7      (1'b0),                                   // (terminated)
		.reset_req_in7  (1'b0),                                   // (terminated)
		.reset_in8      (1'b0),                                   // (terminated)
		.reset_req_in8  (1'b0),                                   // (terminated)
		.reset_in9      (1'b0),                                   // (terminated)
		.reset_req_in9  (1'b0),                                   // (terminated)
		.reset_in10     (1'b0),                                   // (terminated)
		.reset_req_in10 (1'b0),                                   // (terminated)
		.reset_in11     (1'b0),                                   // (terminated)
		.reset_req_in11 (1'b0),                                   // (terminated)
		.reset_in12     (1'b0),                                   // (terminated)
		.reset_req_in12 (1'b0),                                   // (terminated)
		.reset_in13     (1'b0),                                   // (terminated)
		.reset_req_in13 (1'b0),                                   // (terminated)
		.reset_in14     (1'b0),                                   // (terminated)
		.reset_req_in14 (1'b0),                                   // (terminated)
		.reset_in15     (1'b0),                                   // (terminated)
		.reset_req_in15 (1'b0)                                    // (terminated)
	);

endmodule
