class generator;
        transaction trans;

        mailbox #(transaction) out_box;

        extern function new();
        extern virtual task gen();
        extern virtual task start();
endclass

function generator::new();
        this.out_box=new();
endfunction

task generator::gen();
        this.trans=new();
        if(!this.trans.randomize()) begin
                $display("error");
                $finish;
        end
endtask

task generator::start();
        fork
                for(int i=0;i<run_for_n_times;i++) begin
                        this.gen();
                        out_box.put(this.trans);
                end
        join_none
endtask
