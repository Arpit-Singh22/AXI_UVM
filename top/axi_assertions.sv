module axi_assertions(axi_interface pif);
    
    property WA_HSK_PROP;
        @(posedge pif.aclk) pif.awvalid |-> ##[0:3] pif.awready==1;
    endproperty

    property WR_HSK_PROP;
        @(posedge pif.aclk) pif.bvalid |-> ##[0:3] pif.bready==1;
    endproperty

    property AXI_ERRM_WDATA_STABLE_PROP;
        @(posedge pif.aclk) $stable(pif.wdata) throughout (pif.wvalid && ~pif.wready);
    endproperty

    //ASSERT AND COVER
    WA_HSK_CHECK: assert property (WA_HSK_PROP);
    WA_HSK_COVER: cover property (WA_HSK_PROP);

    WR_HSK_CHECK: assert property (WR_HSK_PROP);
    WR_HSK_COVER: cover property (WR_HSK_PROP);

    //AXI_ERRM_WDATA_STABLE_CHECK: assert property (AXI_ERRM_WDATA_STABLE_PROP);
    //AXI_ERRM_WDATA_STABLE_COVER: cover property (AXI_ERRM_WDATA_STABLE_PROP);
endmodule
