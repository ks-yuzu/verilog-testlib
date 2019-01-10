/**
  * @file  test.svh
  * @brief ハードウェア (Verilog HDL 等) のテストのためのヘッダ
  * @note  このファイルを include する側で以下を定義して動作を変更可能
  *        `define ENABLE_TEST_VERBOSE 1   // 1 にすると ok でも詳細なテスト結果を出力
  */


// シミュレーション時以外は何もしない
`ifdef DISABLE_TEST
  `define TRACE_INFO                /* */
  `define is(_got, _exp, comment)   /* */
  `define ok(_val, comment)         /* */
`else


// テストのファイル/行番号/シミュレーション内の時刻を表示
`define TRACE_INFO   \
  $display("%s:%0d  at #%0d", `__FILE__, `__LINE__, $time);



// ---------- 以下のマクロを使用  ----------
// (TRACE_INFO を使うので task では実装できない)

// Test::More の is 的なやつ
`define is(_got, _exp, comment)                                  \
  _show_test_result(_got === _exp, comment);                     \
  `ifndef ENABLE_TEST_VERBOSE                                    \
  if ( _got !== _exp ) begin                                     \
  `else                                                          \
  if ( `ENABLE_TEST_VERBOSE || _got !== _exp ) begin             \
  `endif                                                         \
    $display(`"  got: _got (%x),  exp: _exp (%x)`", _got, _exp); \
    $write("  ");                                                \
    `TRACE_INFO                                                  \
    $display("");                                                \
  end


// Test::More の ok 的なやつ
`define ok(_val, comment)                                        \
  show_test_result(_val, comment);                               \
  `ifndef ENABLE_TEST_VERBOSE                                    \
  if ( ! _val ) begin                                            \
  `else                                                          \
  if ( `ENABLE_TEST_VERBOSE || ! _val ) begin                    \
  `endif                                                         \
    $display(`"  val: _val (%x)`", _val);                        \
    $write("  ");                                                \
    `TRACE_INFO                                                  \
    $display("");                                                \
  end



// ---------- 内部で使うやつ ----------

// テスト番号を表示するためのカウンタ
integer test_count = 0;

task _show_test_result(
  input bit [31:0] flag,
  input string     comment
);
  test_count++;
  if ( flag ) $display("ok %1d - %s"    , test_count, comment);
  else        $display("not ok %1d - %s", test_count, comment);
endtask


 `endif // DISABLE_TEST
