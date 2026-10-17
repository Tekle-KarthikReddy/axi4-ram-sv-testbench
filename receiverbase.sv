class receiverbase;
        virtual infc.tb rtr_io;
        transaction trans1;

        extern function new(virtual infc.tb rtr_io);
        extern virtual task recv();
endclass

function receiverbase::new(virtual infc.tb rtr_io);
        this.rtr_io=rtr_io;
        this.trans1=new();
endfunction

task receiverbase::recv();
        do begin @(this.rtr_io.mcb); end
        while(!(this.rtr_io.mcb.axi_arvalid === 1'b1 && this.rtr_io.mcb.axi_arready === 1'b1));
        this.trans1.addr = this.rtr_io.mcb.axi_araddr;

        do begin @(this.rtr_io.mcb); end
        while (!(this.rtr_io.mcb.axi_rvalid === 1'b1 && this.rtr_io.mcb.axi_rready === 1'b1));
        this.trans1.r_data=this.rtr_io.mcb.axi_rdata;
endtask
