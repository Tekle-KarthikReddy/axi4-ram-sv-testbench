program automatic test(infc.tb rtr_io);
        import packet_test_pkg::*;

        environment env;
        initial begin
                env = new(rtr_io);
                env.configure();
                run_for_n_times=env.run_for_n_times;
                $display("running %0d times",run_for_n_times);
                env.run();
                $finish;
        end
endprogram
