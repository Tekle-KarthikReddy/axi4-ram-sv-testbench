`include "receiverbase.sv"
class receiver extends receiverbase;
        mailbox#(transaction) out_box;

        extern function new(mailbox#(transaction) out_box,virtual infc.tb rtr_io);
        extern virtual task start();
endclass

function receiver::new(mailbox#(transaction) out_box,virtual infc.tb rtr_io);
        super.new(rtr_io);
        this.out_box = out_box;
endfunction

task receiver::start();
        fork
                forever begin
                        transaction pkt;
                        this.recv();
                        pkt = new this.trans1;
                        this.out_box.put(pkt);
                        $display("recceiver captured data %0h",this.trans1.r_data);
                end
        join_none
endtask
