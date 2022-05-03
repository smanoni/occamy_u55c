  axi_riscv_atomics #(
    .AXI_ADDR_WIDTH (${bus_in.aw}),
    .AXI_DATA_WIDTH (${bus_in.dw}),
    .AXI_ID_WIDTH (${bus_in.iw}),
    .AXI_USER_WIDTH (${max(bus_in.uw, 1)}),
    .AXI_MAX_READ_TXNS (${max_trans}),
    .AXI_MAX_WRITE_TXNS (${max_trans}),
    .AXI_USER_AS_ID (${user_as_id}),
    .AXI_USER_ID_MSB (${user_id_msb}),
    .AXI_USER_ID_LSB (${user_id_lsb}),
    .RISCV_WORD_WIDTH (64)
  ) ${name} (
    .clk_i (${bus_in.clk}),
    .rst_ni (${bus_in.rst}),
    .slv_aw_addr_i (${bus_in.req_name()}.aw.addr),
    .slv_aw_prot_i (${bus_in.req_name()}.aw.prot),
    .slv_aw_region_i (${bus_in.req_name()}.aw.region),
    .slv_aw_atop_i (${bus_in.req_name()}.aw.atop),
    .slv_aw_len_i (${bus_in.req_name()}.aw.len),
    .slv_aw_size_i (${bus_in.req_name()}.aw.size),
    .slv_aw_burst_i (${bus_in.req_name()}.aw.burst),
    .slv_aw_lock_i (${bus_in.req_name()}.aw.lock),
    .slv_aw_cache_i (${bus_in.req_name()}.aw.cache),
    .slv_aw_qos_i (${bus_in.req_name()}.aw.qos),
    .slv_aw_id_i (${bus_in.req_name()}.aw.id),
    .slv_aw_user_i (${bus_in.req_name()}.aw.user),
    .slv_aw_ready_o (${bus_in.rsp_name()}.aw_ready),
    .slv_aw_valid_i (${bus_in.req_name()}.aw_valid),
    .slv_ar_addr_i (${bus_in.req_name()}.ar.addr),
    .slv_ar_prot_i (${bus_in.req_name()}.ar.prot),
    .slv_ar_region_i (${bus_in.req_name()}.ar.region),
    .slv_ar_len_i (${bus_in.req_name()}.ar.len),
    .slv_ar_size_i (${bus_in.req_name()}.ar.size),
    .slv_ar_burst_i (${bus_in.req_name()}.ar.burst),
    .slv_ar_lock_i (${bus_in.req_name()}.ar.lock),
    .slv_ar_cache_i (${bus_in.req_name()}.ar.cache),
    .slv_ar_qos_i (${bus_in.req_name()}.ar.qos),
    .slv_ar_id_i (${bus_in.req_name()}.ar.id),
    .slv_ar_user_i (${bus_in.req_name()}.ar.user),
    .slv_ar_ready_o (${bus_in.rsp_name()}.ar_ready),
    .slv_ar_valid_i (${bus_in.req_name()}.ar_valid),
    .slv_w_data_i (${bus_in.req_name()}.w.data),
    .slv_w_strb_i (${bus_in.req_name()}.w.strb),
    .slv_w_user_i (${bus_in.req_name()}.w.user),
    .slv_w_last_i (${bus_in.req_name()}.w.last),
    .slv_w_ready_o (${bus_in.rsp_name()}.w_ready),
    .slv_w_valid_i (${bus_in.req_name()}.w_valid),
    .slv_r_data_o (${bus_in.rsp_name()}.r.data),
    .slv_r_resp_o (${bus_in.rsp_name()}.r.resp),
    .slv_r_last_o (${bus_in.rsp_name()}.r.last),
    .slv_r_id_o (${bus_in.rsp_name()}.r.id),
    .slv_r_user_o (${bus_in.rsp_name()}.r.user),
    .slv_r_ready_i (${bus_in.req_name()}.r_ready),
    .slv_r_valid_o (${bus_in.rsp_name()}.r_valid),
    .slv_b_resp_o (${bus_in.rsp_name()}.b.resp),
    .slv_b_id_o (${bus_in.rsp_name()}.b.id),
    .slv_b_user_o (${bus_in.rsp_name()}.b.user),
    .slv_b_ready_i (${bus_in.req_name()}.b_ready),
    .slv_b_valid_o (${bus_in.rsp_name()}.b_valid),

    .mst_aw_addr_o (${bus_out.req_name()}.aw.addr),
    .mst_aw_prot_o (${bus_out.req_name()}.aw.prot),
    .mst_aw_region_o (${bus_out.req_name()}.aw.region),
    .mst_aw_atop_o (${bus_out.req_name()}.aw.atop),
    .mst_aw_len_o (${bus_out.req_name()}.aw.len),
    .mst_aw_size_o (${bus_out.req_name()}.aw.size),
    .mst_aw_burst_o (${bus_out.req_name()}.aw.burst),
    .mst_aw_lock_o (${bus_out.req_name()}.aw.lock),
    .mst_aw_cache_o (${bus_out.req_name()}.aw.cache),
    .mst_aw_qos_o (${bus_out.req_name()}.aw.qos),
    .mst_aw_id_o (${bus_out.req_name()}.aw.id),
    .mst_aw_user_o (${bus_out.req_name()}.aw.user),
    .mst_aw_ready_i (${bus_out.rsp_name()}.aw_ready),
    .mst_aw_valid_o (${bus_out.req_name()}.aw_valid),
    .mst_ar_addr_o (${bus_out.req_name()}.ar.addr),
    .mst_ar_prot_o (${bus_out.req_name()}.ar.prot),
    .mst_ar_region_o (${bus_out.req_name()}.ar.region),
    .mst_ar_len_o (${bus_out.req_name()}.ar.len),
    .mst_ar_size_o (${bus_out.req_name()}.ar.size),
    .mst_ar_burst_o (${bus_out.req_name()}.ar.burst),
    .mst_ar_lock_o (${bus_out.req_name()}.ar.lock),
    .mst_ar_cache_o (${bus_out.req_name()}.ar.cache),
    .mst_ar_qos_o (${bus_out.req_name()}.ar.qos),
    .mst_ar_id_o (${bus_out.req_name()}.ar.id),
    .mst_ar_user_o (${bus_out.req_name()}.ar.user),
    .mst_ar_ready_i (${bus_out.rsp_name()}.ar_ready),
    .mst_ar_valid_o (${bus_out.req_name()}.ar_valid),
    .mst_w_data_o (${bus_out.req_name()}.w.data),
    .mst_w_strb_o (${bus_out.req_name()}.w.strb),
    .mst_w_user_o (${bus_out.req_name()}.w.user),
    .mst_w_last_o (${bus_out.req_name()}.w.last),
    .mst_w_ready_i (${bus_out.rsp_name()}.w_ready),
    .mst_w_valid_o (${bus_out.req_name()}.w_valid),
    .mst_r_data_i (${bus_out.rsp_name()}.r.data),
    .mst_r_resp_i (${bus_out.rsp_name()}.r.resp),
    .mst_r_last_i (${bus_out.rsp_name()}.r.last),
    .mst_r_id_i (${bus_out.rsp_name()}.r.id),
    .mst_r_user_i (${bus_out.rsp_name()}.r.user),
    .mst_r_ready_o (${bus_out.req_name()}.r_ready),
    .mst_r_valid_i (${bus_out.rsp_name()}.r_valid),
    .mst_b_resp_i (${bus_out.rsp_name()}.b.resp),
    .mst_b_id_i (${bus_out.rsp_name()}.b.id),
    .mst_b_user_i (${bus_out.rsp_name()}.b.user),
    .mst_b_ready_o (${bus_out.req_name()}.b_ready),
    .mst_b_valid_i (${bus_out.rsp_name()}.b_valid)
  );
