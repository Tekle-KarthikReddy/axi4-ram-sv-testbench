class scoreboard;
        event DONE;
        transaction refpkt[$];
        transaction trans1;
        mailbox#(transaction) driver_mbox;
        mailbox#(transaction) receiver_mbox;
        logic [3:0] addr;
        int pkts_checked = 0;
        int pass_count = 0;
        int fail_count = 0;
        real coverage_result;

        covergroup cg;
                coverpoint addr;
        endgroup

        extern function new(mailbox#(transaction) driver_mbox=null, receiver_mbox=null);
        extern virtual task start();
        extern virtual task check();
endclass

function scoreboard::new(mailbox#(transaction) driver_mbox,receiver_mbox);
        if(driver_mbox==null) driver_mbox =new();
        this.driver_mbox=driver_mbox;
        if(receiver_mbox==null) receiver_mbox=new();
        this.receiver_mbox=receiver_mbox;
        cg=new();
endfunction

task scoreboard::start();
        fork
                forever begin
                        transaction pkt;
                        driver_mbox.get(pkt);
                        refpkt.push_back(pkt);
                end
                forever begin
                        receiver_mbox.get(trans1);
                        check();
                end
        join_none
endtask

task scoreboard::check();
        string message ="";
        int idx=-1;
        foreach(refpkt[i]) begin
                if(refpkt[i].addr==trans1.addr) begin
                        idx=i;
                        break;
                end
        end
        if(idx==-1) begin
                message = " no matching reference packet";
                $display("[SB] ERROR : %s for addr=%0h",message,trans1.addr);
                fail_count++;
        end
        else begin
                if(!refpkt[idx].compare(trans1,message)) begin
                        $display("[SB] error comparing: %s",message);
                        fail_count++;
                end
                else
                        pass_count++;
                this.addr=refpkt[idx].addr;
                cg.sample();
                refpkt.delete(idx);
        end

        pkts_checked++;
        coverage_result=cg.get_coverage();
        $display(" packets %0d  addr=%0h %s coverage=%3.2f",pkts_checked,trans1.addr,message,coverage_result);
        if(pkts_checked>=run_for_n_times)
                ->DONE;
endtask
