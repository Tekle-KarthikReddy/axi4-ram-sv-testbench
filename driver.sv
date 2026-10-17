`include "driverbase.sv"
class driver extends driverbase;
        mailbox #(transaction) in_box;
        mailbox #(transaction) out_box;
        transaction trans;
        semaphore sem[];

        extern function new(semaphore sem[],mailbox #(transaction) in_box, out_box, virtual infc.tb rtr_io);
        extern virtual task start();
endclass

function driver::new(semaphore sem[],mailbox#(transaction) in_box, out_box, virtual infc.tb rtr_io);
        super.new(rtr_io);
        this.sem=sem;
        this.in_box=in_box;
        this.out_box=out_box;
endfunction

task driver::start();
        fork
                forever begin
                        transaction ref_pkt;
                        this.in_box.get(this.trans);
                        this.addr=this.trans.addr;
                        this.w_data = this.trans.w_data;
                        this.r_data = this.trans.r_data;
                        this.sem[0].get(1);
                        ref_pkt = new this.trans;
                        this.out_box.put(ref_pkt);
                        this.send();
                        this.sem[0].put(1);
                end
        join_none
endtask
