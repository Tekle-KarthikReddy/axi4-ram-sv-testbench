class environment;
        rand int run_for_n_times;
        virtual infc.tb rtr_io;

        semaphore sem[];
        driver drvr;
        receiver rcvr;
        generator gen;
        scoreboard sb;

        constraint valid{this.run_for_n_times inside {[100:200]};}

        extern function new(virtual infc.tb rtr_io);
        extern virtual task run();
        extern virtual function void configure();
        extern virtual function void build();
        extern virtual task start();
        extern virtual task wait_for_end();
        extern virtual task reset();
endclass

function environment::new(virtual infc.tb rtr_io);
        this.rtr_io=rtr_io;
endfunction

task environment::run();
        this.build();
        this.reset();
        this.start();
        this.wait_for_end();
endtask

function void environment::configure();
        if(!this.randomize()) begin
                $display("environment randomize failed");
                this.run_for_n_times=100;
        end
endfunction

function void environment::build();
        if(!this.run_for_n_times) this.run_for_n_times=100;
        this.sem=new[1];
        this.gen=new();
        this.sb=new();
        foreach(sem[i])
                this.sem[i]=new(1);
        this.drvr = new(this.sem,this.gen.out_box,this.sb.driver_mbox,this.rtr_io);
        this.rcvr = new(this.sb.receiver_mbox,this.rtr_io);
endfunction

task environment::reset();
        this.rtr_io.arst <= 1'b1;
        this.rtr_io.cb.axi_awaddr <= 0;
        this.rtr_io.cb.axi_awvalid <= 0;
        this.rtr_io.cb.axi_wdata <= 0;
        this.rtr_io.cb.axi_wvalid <= 0;
        this.rtr_io.cb.axi_bready <= 0;
        this.rtr_io.cb.axi_araddr <= 0;
        this.rtr_io.cb.axi_arvalid <= 0;
        this.rtr_io.cb.axi_rready <= 0;
        repeat(4) @(this.rtr_io.cb);
        this.rtr_io.arst <= 1'b0;
endtask

task environment::start();
        this.gen.start();
        this.sb.start();
        this.drvr.start();
        this.rcvr.start();
endtask

task environment::wait_for_end();
        fork
                @(this.sb.DONE);
        begin
                repeat(run_for_n_times * 80 +5000) @(this.rtr_io.cb);
                $display("%0t timeout waiting for scoreboard DONE",$time);
        end
        join_any
        disable fork;
        repeat(20) @(this.rtr_io.cb);
        $display("test completed: PASS=%0d FAIL=%0d",this.sb.pass_count,this.sb.fail_count);
endtask
