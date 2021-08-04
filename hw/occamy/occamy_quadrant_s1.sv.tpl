// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>
// Author: Fabian Schuiki <fschuiki@iis.ee.ethz.ch>

// AUTOMATICALLY GENERATED by occamygen.py; edit the script instead.
<%
  cut_width = 1
  nr_clusters = int(cfg["s1_quadrant"]["nr_clusters"])
%>

/// Occamy Stage 1 Quadrant
module occamy_quadrant_s1
  import occamy_pkg::*;
(
  input  logic                         clk_i,
  input  logic                         rst_ni,
  input  logic                         test_mode_i,
  input  tile_id_t                     tile_id_i,
  input  logic [NrCoresS1Quadrant-1:0] debug_req_i,
  input  logic [NrCoresS1Quadrant-1:0] meip_i,
  input  logic [NrCoresS1Quadrant-1:0] mtip_i,
  input  logic [NrCoresS1Quadrant-1:0] msip_i,
  input  logic [3:0]                   isolate_i,
  output logic [3:0]                   isolated_o,
  // HBI Connection
  output ${wide_xbar_quadrant_s1.out_hbi.req_type()}   quadrant_hbi_out_req_o,
  input  ${wide_xbar_quadrant_s1.out_hbi.rsp_type()}   quadrant_hbi_out_rsp_i,
  // Next-Level
  output ${soc_narrow_xbar.in_s1_quadrant_0.req_type()} quadrant_narrow_out_req_o,
  input  ${soc_narrow_xbar.in_s1_quadrant_0.rsp_type()} quadrant_narrow_out_rsp_i,
  input  ${soc_narrow_xbar.out_s1_quadrant_0.req_type()} quadrant_narrow_in_req_i,
  output ${soc_narrow_xbar.out_s1_quadrant_0.rsp_type()} quadrant_narrow_in_rsp_o,
  output ${soc_wide_xbar.in_s1_quadrant_0.req_type()}   quadrant_wide_out_req_o,
  input  ${soc_wide_xbar.in_s1_quadrant_0.rsp_type()}   quadrant_wide_out_rsp_i,
  input  ${soc_wide_xbar.out_s1_quadrant_0.req_type()}   quadrant_wide_in_req_i,
  output ${soc_wide_xbar.out_s1_quadrant_0.rsp_type()}   quadrant_wide_in_rsp_o
);

 // Calculate cluster base address based on `tile id`.
  addr_t [${nr_clusters-1}:0] cluster_base_addr;
  % for i in range(nr_clusters):
  assign cluster_base_addr[${i}] = ClusterBaseOffset + tile_id_i * NrClustersS1Quadrant * ClusterAddressSpace + ${i} * ClusterAddressSpace;
  %endfor

  ///////////////////
  //   CROSSBARS   //
  ///////////////////
  ${module}

  ///////////////////////////////
  // Narrow In + IW Converter //
  ///////////////////////////////
  <%
    narrow_cluster_in_iwc = soc_narrow_xbar.out_s1_quadrant_0 \
      .copy(name="narrow_cluster_in_iwc") \
      .declare(context) \
      .isolate(context, "isolate_i[0]", "narrow_cluster_in_isolate", isolated="isolated_o[0]") \
      .change_iw(context, narrow_xbar_quadrant_s1.in_top.iw, "narrow_cluster_in_iwc", to=narrow_xbar_quadrant_s1.in_top)
  %>
  assign narrow_cluster_in_iwc_req = quadrant_narrow_in_req_i;
  assign quadrant_narrow_in_rsp_o = narrow_cluster_in_iwc_rsp;

  ///////////////////////////////
  // Narrow Out + IW Converter //
  ///////////////////////////////
  <% narrow_cluster_out_iwc = narrow_xbar_quadrant_s1.out_top \
    .change_iw(context, soc_narrow_xbar.in_s1_quadrant_0.iw, "narrow_cluster_out_iwc") \
    .isolate(context, "isolate_i[1]", "narrow_cluster_out_isolate", isolated="isolated_o[1]") %>

  assign quadrant_narrow_out_req_o = ${narrow_cluster_out_iwc.req_name()};
  assign ${narrow_cluster_out_iwc.rsp_name()} = quadrant_narrow_out_rsp_i;

  ////////////////////////////////////////////
  // Wide Out + Const Cache + IW Converter  //
  ////////////////////////////////////////////
  addr_t const_cache_start_addr, const_cache_end_addr;
  assign const_cache_start_addr = '0;
  assign const_cache_end_addr = '1;
  <%
    const_cache_cfg = cfg["s1_quadrant"].get("const_cache")
    if const_cache_cfg:
      wide_cluster_out_const_cache = wide_xbar_quadrant_s1.out_top \
      .add_const_cache(context, "snitch_const_cache", const_cache_cfg["width"], const_cache_cfg["count"], const_cache_cfg["sets"])
    else:
      wide_cluster_out_const_cache = wide_xbar_quadrant_s1.out_top

    wide_cluster_out_iwc = wide_cluster_out_const_cache \
      .change_iw(context, 3, "wide_cluster_out_iwc") \
      .isolate(context, "isolate_i[3]", "wide_cluster_out_isolate", isolated="isolated_o[3]")
  %>

  assign quadrant_wide_out_req_o = ${wide_cluster_out_iwc.req_name()};
  assign ${wide_cluster_out_iwc.rsp_name()} = quadrant_wide_out_rsp_i;

  ////////////////////
  // HBI Connection //
  ////////////////////
  <%
      wide_cluster_hbi_out_iwc = wide_xbar_quadrant_s1.out_hbi.cut(context, cut_width)
  %>

  assign quadrant_hbi_out_req_o = ${wide_cluster_hbi_out_iwc.req_name()};
  assign ${wide_cluster_hbi_out_iwc.rsp_name()} = quadrant_hbi_out_rsp_i;

  ////////////////////////////
  // Wide In + IW Converter //
  ////////////////////////////
  <%
    soc_wide_xbar.out_s1_quadrant_0 \
      .copy(name="wide_cluster_in_iwc") \
      .declare(context) \
      .isolate(context, "isolate_i[2]", "wide_cluster_in_isolate", isolated="isolated_o[2]") \
      .change_iw(context, wide_xbar_quadrant_s1.in_top.iw, "wide_cluster_in_iwc", to=wide_xbar_quadrant_s1.in_top)
  %>
  assign wide_cluster_in_iwc_req = quadrant_wide_in_req_i;
  assign quadrant_wide_in_rsp_o = wide_cluster_in_iwc_rsp;

% for i in range(nr_clusters):
  ///////////////
  // Cluster ${i} //
  ///////////////
  <%
    narrow_cluster_in = narrow_xbar_quadrant_s1.__dict__["out_cluster_{}".format(i)].change_iw(context, 2, "narrow_in_iwc_{}".format(i)).cut(context, cut_width)
    narrow_cluster_out = narrow_xbar_quadrant_s1.__dict__["in_cluster_{}".format(i)].copy(name="narrow_out_{}".format(i)).declare(context)
    narrow_cluster_out.cut(context, cut_width, to=narrow_xbar_quadrant_s1.__dict__["in_cluster_{}".format(i)])
    wide_cluster_in = wide_xbar_quadrant_s1.__dict__["out_cluster_{}".format(i)].change_iw(context, 2, "wide_in_iwc_{}".format(i)).cut(context, cut_width)
    wide_cluster_out = wide_xbar_quadrant_s1.__dict__["in_cluster_{}".format(i)].copy(name="wide_out_{}".format(i)).declare(context)
    wide_cluster_out.cut(context, cut_width, to=wide_xbar_quadrant_s1.__dict__["in_cluster_{}".format(i)])
  %>

  logic [9:0] hart_base_id_${i};
  assign hart_base_id_${i} = HartIdOffset + tile_id_i * NrCoresS1Quadrant + ${i} * NrCoresCluster;

  occamy_cluster_wrapper i_occamy_cluster_${i} (
    .clk_i (clk_i),
    .rst_ni (rst_ni),
    .debug_req_i (debug_req_i[${i}*NrCoresCluster+:NrCoresCluster]),
    .meip_i (meip_i[${i}*NrCoresCluster+:NrCoresCluster]),
    .mtip_i (mtip_i[${i}*NrCoresCluster+:NrCoresCluster]),
    .msip_i (msip_i[${i}*NrCoresCluster+:NrCoresCluster]),
    .hart_base_id_i (hart_base_id_${i}),
    .cluster_base_addr_i (cluster_base_addr[${i}]),
    .clk_d2_bypass_i (1'b0),
    .narrow_in_req_i (${narrow_cluster_in.req_name()}),
    .narrow_in_resp_o (${narrow_cluster_in.rsp_name()}),
    .narrow_out_req_o  (${narrow_cluster_out.req_name()}),
    .narrow_out_resp_i (${narrow_cluster_out.rsp_name()}),
    .wide_out_req_o  (${wide_cluster_out.req_name()}),
    .wide_out_resp_i (${wide_cluster_out.rsp_name()}),
    .wide_in_req_i (${wide_cluster_in.req_name()}),
    .wide_in_resp_o (${wide_cluster_in.rsp_name()})
  );

% endfor
endmodule
