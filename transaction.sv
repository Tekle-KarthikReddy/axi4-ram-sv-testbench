class transaction;
        rand logic  [3:0] addr;
        rand int w_data;
        int  r_data;

        constraint a{w_data inside{[0:1000]};}
        extern function bit compare(transaction trans1,ref string message);

endclass

function bit transaction::compare(transaction trans1,ref string message);
        if(w_data != trans1.r_data) begin
                message=$sformatf("r_data mismatch exp =%0d rec=%0d",w_data,trans1.r_data);
                return(0);
        end
        message="successfully compared successfully";
        return(1);
endfunction
