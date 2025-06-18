(module $kernel.wasm
  (type (;0;) (func (result i32)))
  (type (;1;) (func (param i32 i32 i32 i32) (result i32)))
  (type (;2;) (func (param i32)))
  (type (;3;) (func))
  (type (;4;) (func (param i32) (result i32)))
  (type (;5;) (func (param i32 i32) (result i32)))
  (type (;6;) (func (param i32 i32 i32) (result i32)))
  (import "env" "memory" (memory (;0;) 529 2048 shared))
  (import "wasi_snapshot_preview1" "fd_write" (func $__wasi_fd_write (type 1)))
  (import "wasi_snapshot_preview1" "proc_exit" (func $__wasi_proc_exit (type 2)))
  (func $__wasm_init_memory (type 3)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 33560320
          i32.const 0
          i32.const 1
          i32.atomic.rmw.cmpxchg
          br_table 0 (;@3;) 1 (;@2;) 2 (;@1;)
        end
        i32.const 1024
        i32.const 0
        i32.const 1746
        memory.init $.rodata
        i32.const 2784
        i32.const 0
        i32.const 33557536
        memory.fill
        i32.const 33560320
        i32.const 2
        i32.atomic.store
        i32.const 33560320
        i32.const -1
        memory.atomic.notify
        drop
        br 1 (;@1;)
      end
      i32.const 33560320
      i32.const 1
      i64.const -1
      memory.atomic.wait32
      drop
    end
    data.drop $.rodata)
  (func $kernel_main (type 3)
    (local i32)
    i32.const 1642
    call $kputs
    drop
    i32.const 1838
    call $kputs
    drop
    i32.const 1931
    call $kputs
    drop
    i32.const 1764
    call $kputs
    drop
    i32.const 1838
    call $kputs
    drop
    i32.const 2769
    call $kputs
    drop
    i32.const 2093
    call $kputs
    drop
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            call $mm_init
            i32.const 0
            i32.ge_s
            br_if 0 (;@4;)
            i32.const 2406
            local.set 0
            br 1 (;@3;)
          end
          i32.const 1541
          call $kputs
          drop
          block  ;; label = @4
            call $fs_init
            i32.const 0
            i32.ge_s
            br_if 0 (;@4;)
            i32.const 2566
            local.set 0
            br 1 (;@3;)
          end
          i32.const 1612
          call $kputs
          drop
          call $drivers_init
          i32.const 0
          i32.ge_s
          br_if 1 (;@2;)
          i32.const 2453
          local.set 0
        end
        i32.const 2
        local.get 0
        i32.const 0
        call $kfprintf
        drop
        i32.const 2
        i32.const 2695
        i32.const 0
        call $kfprintf
        drop
        i32.const 1
        call $wasi_exit
        br 1 (;@1;)
      end
      i32.const 1578
      call $kputs
      drop
      i32.const 1422
      call $kputs
      drop
    end
    i32.const 2062
    call $kputs
    drop
    i32.const 2175
    call $kputs
    drop
    call $shell_main
    i32.const 2134
    call $kputs
    drop
    i32.const 1693
    call $kputs
    drop
    i32.const 0
    call $wasi_exit)
  (func $_start (type 3)
    call $kernel_main)
  (func $mm_init (type 0) (result i32)
    i32.const 0
    i64.const 0
    i64.store offset=2792
    i32.const 0
    i64.const 4328521712
    i64.store offset=2784
    i32.const 0
    i32.const 2784
    i32.store offset=33557216
    i32.const 0
    i32.const 16
    i32.store offset=33557220
    i32.const 0)
  (func $fs_init (type 0) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      i32.const 0
      i32.load offset=33559872
      local.tee 0
      i32.const 9
      i32.gt_s
      br_if 0 (;@1;)
      i32.const 0
      local.get 0
      i32.const 1
      i32.add
      local.tee 1
      i32.store offset=33559872
      local.get 0
      i32.const 264
      i32.mul
      i32.const 33557232
      i32.add
      local.tee 2
      i32.const 47
      i32.store8
      i32.const 0
      local.set 3
      loop  ;; label = @2
        local.get 2
        local.get 3
        i32.add
        i32.const 1
        i32.add
        i32.const 0
        i32.store16 align=1
        local.get 3
        i32.const 2
        i32.add
        local.tee 3
        i32.const 254
        i32.ne
        br_if 0 (;@2;)
      end
      local.get 2
      i32.const 1
      i32.store offset=256
      local.get 2
      i32.const 0
      i32.store8 offset=255
      i32.const 0
      i32.load offset=33559876
      local.set 3
      i32.const 0
      local.get 2
      i32.store offset=33559876
      local.get 2
      local.get 3
      i32.store offset=260
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.const 9
          i32.eq
          br_if 0 (;@3;)
          i32.const 0
          local.get 0
          i32.const 2
          i32.add
          local.tee 4
          i32.store offset=33559872
          local.get 1
          i32.const 264
          i32.mul
          i32.const 33557232
          i32.add
          local.tee 5
          i32.const 1986356271
          i32.store
          local.get 0
          i32.const 264
          i32.mul
          i32.const 33557232
          i32.add
          local.set 6
          i32.const -248
          local.set 3
          loop  ;; label = @4
            local.get 6
            local.get 3
            i32.add
            local.tee 1
            i32.const 518
            i32.add
            i32.const 0
            i32.store8
            local.get 1
            i32.const 516
            i32.add
            i32.const 0
            i32.store16
            local.get 3
            i32.eqz
            br_if 2 (;@2;)
            local.get 1
            i32.const 523
            i32.add
            i32.const 0
            i32.store8
            local.get 1
            i32.const 519
            i32.add
            i32.const 0
            i32.store align=1
            local.get 3
            i32.const 8
            i32.add
            local.set 3
            br 0 (;@4;)
          end
        end
        i32.const 2
        i32.const 2379
        i32.const 0
        call $kfprintf
        drop
        i32.const -1
        return
      end
      local.get 5
      local.get 2
      i32.store offset=260
      local.get 5
      i32.const 2
      i32.store offset=256
      local.get 5
      i32.const 0
      i32.store8 offset=255
      i32.const 0
      local.get 5
      i32.store offset=33559876
      block  ;; label = @2
        local.get 0
        i32.const 7
        i32.gt_s
        br_if 0 (;@2;)
        i32.const 0
        local.get 0
        i32.const 3
        i32.add
        i32.store offset=33559872
        local.get 4
        i32.const 264
        i32.mul
        local.tee 3
        i32.const 33557236
        i32.add
        i32.const 99
        i32.store8
        local.get 3
        i32.const 33557232
        i32.add
        local.tee 6
        i32.const 1869770799
        i32.store
        local.get 0
        i32.const 264
        i32.mul
        i32.const 33557232
        i32.add
        local.set 2
        i32.const -250
        local.set 3
        loop  ;; label = @3
          local.get 2
          local.get 3
          i32.add
          local.tee 1
          i32.const 787
          i32.add
          i32.const 0
          i32.store8
          local.get 1
          i32.const 783
          i32.add
          i32.const 0
          i32.store align=1
          local.get 3
          i32.const 5
          i32.add
          local.tee 3
          br_if 0 (;@3;)
        end
        local.get 6
        local.get 5
        i32.store offset=260
        local.get 6
        i32.const 3
        i32.store offset=256
        local.get 6
        i32.const 0
        i32.store8 offset=255
        i32.const 0
        local.get 6
        i32.store offset=33559876
        i32.const 0
        return
      end
      i32.const 2
      i32.const 2667
      i32.const 0
      call $kfprintf
      drop
      i32.const -1
      return
    end
    i32.const 2
    i32.const 2528
    i32.const 0
    call $kfprintf
    drop
    i32.const -1)
  (func $console_init (type 0) (result i32)
    i32.const 0)
  (func $drivers_init (type 0) (result i32)
    (local i32 i32)
    i32.const 0
    i32.load offset=33560052
    local.set 0
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 0
          i32.load offset=33560048
          local.tee 1
          i32.const 9
          i32.gt_s
          br_if 0 (;@3;)
          i32.const 0
          local.get 1
          i32.const 1
          i32.add
          i32.store offset=33560048
          local.get 1
          i32.const 4
          i32.shl
          local.tee 1
          i32.const 33559900
          i32.add
          local.get 0
          i32.store
          local.get 1
          i32.const 33559896
          i32.add
          i32.const 0
          i32.store
          local.get 1
          i32.const 33559892
          i32.add
          i32.const 1
          i32.store
          local.get 1
          i32.const 33559888
          i32.add
          local.tee 0
          i32.const 1460
          i32.store
          i32.const 0
          local.get 0
          i32.store offset=33560052
          br 1 (;@2;)
        end
        local.get 0
        i32.eqz
        br_if 1 (;@1;)
      end
      loop  ;; label = @2
        i32.const 2737
        i32.const 0
        call $kprintf
        drop
        block  ;; label = @3
          local.get 0
          i32.load offset=4
          local.tee 1
          i32.eqz
          br_if 0 (;@3;)
          local.get 1
          call_indirect (type 0)
          local.tee 1
          i32.const -1
          i32.gt_s
          br_if 0 (;@3;)
          i32.const 2
          i32.const 2490
          i32.const 0
          call $kfprintf
          drop
          local.get 1
          return
        end
        local.get 0
        i32.load offset=12
        local.tee 0
        br_if 0 (;@2;)
      end
    end
    i32.const 2633
    i32.const 0
    call $kprintf
    drop
    i32.const 0)
  (func $kputs (type 4) (param i32) (result i32)
    (local i32 i32 i32)
    i32.const 0
    local.set 1
    loop  ;; label = @1
      local.get 0
      local.get 1
      i32.add
      local.set 2
      local.get 1
      i32.const 1
      i32.add
      local.tee 3
      local.set 1
      local.get 2
      i32.load8_u
      br_if 0 (;@1;)
    end
    i32.const 1
    local.get 0
    local.get 3
    i32.const -1
    i32.add
    call $wasi_write
    drop
    i32.const 1
    i32.const 2768
    i32.const 1
    call $wasi_write
    drop
    local.get 3)
  (func $kprintf (type 5) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 1056
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.load8_u
        local.tee 3
        br_if 0 (;@2;)
        i32.const 0
        local.set 4
        br 1 (;@1;)
      end
      i32.const 0
      local.set 4
      local.get 0
      local.set 5
      i32.const 0
      local.set 6
      loop  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 3
              i32.const 255
              i32.and
              i32.const 37
              i32.ne
              br_if 0 (;@5;)
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        local.get 5
                        i32.const 1
                        i32.add
                        i32.load8_u
                        local.tee 5
                        i32.const -100
                        i32.add
                        br_table 2 (;@8;) 3 (;@7;) 3 (;@7;) 3 (;@7;) 3 (;@7;) 3 (;@7;) 3 (;@7;) 3 (;@7;) 3 (;@7;) 3 (;@7;) 3 (;@7;) 3 (;@7;) 3 (;@7;) 3 (;@7;) 3 (;@7;) 1 (;@9;) 0 (;@10;)
                      end
                      local.get 5
                      i32.eqz
                      br_if 4 (;@5;)
                      local.get 5
                      i32.const 37
                      i32.ne
                      br_if 2 (;@7;)
                      local.get 2
                      i32.const 32
                      i32.add
                      local.get 4
                      i32.add
                      i32.const 37
                      i32.store8
                      local.get 4
                      i32.const 1
                      i32.add
                      local.set 4
                      local.get 6
                      i32.const 2
                      i32.add
                      local.set 6
                      br 6 (;@3;)
                    end
                    block  ;; label = @9
                      local.get 4
                      i32.eqz
                      br_if 0 (;@9;)
                      i32.const 1
                      local.get 2
                      i32.const 32
                      i32.add
                      local.get 4
                      call $wasi_write
                      drop
                    end
                    i32.const 1
                    i32.const 1798
                    i32.const 4
                    call $wasi_write
                    drop
                    i32.const 0
                    local.set 4
                    local.get 6
                    i32.const 2
                    i32.add
                    local.set 6
                    br 5 (;@3;)
                  end
                  local.get 2
                  i32.const 48
                  i32.store16
                  i32.const 0
                  local.set 3
                  loop  ;; label = @8
                    local.get 2
                    local.get 3
                    i32.add
                    local.set 5
                    local.get 3
                    i32.const 1
                    i32.add
                    local.tee 7
                    local.set 3
                    local.get 5
                    i32.load8_u
                    br_if 0 (;@8;)
                  end
                  local.get 7
                  i32.const 1
                  i32.eq
                  br_if 1 (;@6;)
                  local.get 4
                  i32.const 1022
                  i32.gt_u
                  br_if 1 (;@6;)
                  local.get 7
                  i32.const -1
                  i32.add
                  local.set 8
                  local.get 2
                  i32.const 32
                  i32.add
                  local.get 4
                  i32.add
                  local.set 9
                  i32.const 0
                  local.set 3
                  loop  ;; label = @8
                    local.get 9
                    local.get 3
                    i32.add
                    local.get 2
                    local.get 3
                    i32.add
                    i32.load8_u
                    i32.store8
                    local.get 3
                    i32.const 1
                    i32.add
                    local.tee 5
                    local.get 8
                    i32.ge_u
                    br_if 4 (;@4;)
                    local.get 4
                    local.get 3
                    i32.add
                    local.set 7
                    local.get 5
                    local.set 3
                    local.get 7
                    i32.const 1022
                    i32.lt_u
                    br_if 0 (;@8;)
                    br 4 (;@4;)
                  end
                end
                local.get 2
                i32.const 32
                i32.add
                local.get 4
                i32.add
                local.tee 3
                local.get 5
                i32.store8 offset=1
                local.get 3
                i32.const 37
                i32.store8
                local.get 4
                i32.const 2
                i32.add
                local.set 4
              end
              local.get 6
              i32.const 2
              i32.add
              local.set 6
              br 2 (;@3;)
            end
            local.get 2
            i32.const 32
            i32.add
            local.get 4
            i32.add
            local.get 3
            i32.store8
            local.get 4
            i32.const 1
            i32.add
            local.set 4
            local.get 6
            i32.const 1
            i32.add
            local.set 6
            br 1 (;@3;)
          end
          local.get 4
          local.get 5
          i32.add
          local.set 4
          local.get 6
          i32.const 2
          i32.add
          local.set 6
        end
        block  ;; label = @3
          local.get 0
          local.get 6
          i32.add
          local.tee 5
          i32.load8_u
          local.tee 3
          i32.eqz
          br_if 0 (;@3;)
          local.get 4
          i32.const 1023
          i32.lt_u
          br_if 1 (;@2;)
        end
      end
      local.get 4
      i32.const 1
      i32.lt_s
      br_if 0 (;@1;)
      i32.const 1
      local.get 2
      i32.const 32
      i32.add
      local.get 4
      call $wasi_write
      drop
    end
    local.get 2
    i32.const 1056
    i32.add
    global.set $__stack_pointer
    local.get 4)
  (func $kfprintf (type 6) (param i32 i32 i32) (result i32)
    (local i32 i32 i32)
    i32.const 0
    local.set 3
    loop  ;; label = @1
      local.get 1
      local.get 3
      i32.add
      local.set 4
      local.get 3
      i32.const 1
      i32.add
      local.tee 5
      local.set 3
      local.get 4
      i32.load8_u
      br_if 0 (;@1;)
    end
    local.get 0
    local.get 1
    local.get 5
    i32.const -1
    i32.add
    local.tee 3
    call $wasi_write
    drop
    local.get 3)
  (func $wasi_write (type 6) (param i32 i32 i32) (result i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 3
    global.set $__stack_pointer
    local.get 3
    local.get 2
    i32.store offset=12
    local.get 3
    local.get 1
    i32.store offset=8
    local.get 0
    local.get 3
    i32.const 8
    i32.add
    i32.const 1
    local.get 3
    i32.const 4
    i32.add
    call $__wasi_fd_write
    local.set 2
    local.get 3
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get 2)
  (func $wasi_exit (type 2) (param i32)
    local.get 0
    call $__wasi_proc_exit)
  (func $execute_command (type 2) (param i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    local.get 0
    local.set 2
    block  ;; label = @1
      block  ;; label = @2
        loop  ;; label = @3
          local.get 2
          i32.load8_u
          local.tee 3
          i32.eqz
          br_if 1 (;@2;)
          block  ;; label = @4
            local.get 3
            i32.const 32
            i32.eq
            br_if 0 (;@4;)
            local.get 2
            i32.const 1
            i32.add
            local.set 2
            br 1 (;@3;)
          end
        end
        local.get 2
        i32.const 0
        i32.store8
        loop  ;; label = @3
          local.get 2
          i32.const 1
          i32.add
          local.tee 2
          i32.load8_u
          i32.const 32
          i32.eq
          br_if 0 (;@3;)
          br 2 (;@1;)
        end
      end
      i32.const 0
      local.set 2
    end
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          local.get 0
                          i32.load8_u
                          local.tee 4
                          br_if 0 (;@11;)
                          i32.const 0
                          local.set 5
                          i32.const 1061
                          local.set 3
                          br 1 (;@10;)
                        end
                        local.get 0
                        i32.const 1
                        i32.add
                        local.set 6
                        i32.const 0
                        local.set 3
                        local.get 4
                        local.set 5
                        block  ;; label = @11
                          loop  ;; label = @12
                            local.get 5
                            i32.const 255
                            i32.and
                            local.get 3
                            i32.const 1129
                            i32.add
                            i32.load8_u
                            local.tee 7
                            i32.ne
                            br_if 1 (;@11;)
                            local.get 6
                            local.get 3
                            i32.add
                            local.set 5
                            local.get 3
                            i32.const 1
                            i32.add
                            local.tee 7
                            local.set 3
                            local.get 5
                            i32.load8_u
                            local.tee 5
                            br_if 0 (;@12;)
                          end
                          local.get 7
                          i32.const 1129
                          i32.add
                          i32.load8_u
                          local.set 7
                          i32.const 0
                          local.set 5
                        end
                        local.get 5
                        i32.const 255
                        i32.and
                        local.get 7
                        i32.const 255
                        i32.and
                        i32.eq
                        br_if 3 (;@7;)
                        local.get 0
                        i32.const 1
                        i32.add
                        local.set 7
                        i32.const 1123
                        local.set 5
                        local.get 4
                        local.set 3
                        block  ;; label = @11
                          loop  ;; label = @12
                            local.get 3
                            i32.const 255
                            i32.and
                            local.get 5
                            i32.load8_u
                            i32.ne
                            br_if 1 (;@11;)
                            local.get 5
                            i32.const 1
                            i32.add
                            local.set 5
                            local.get 7
                            i32.load8_u
                            local.set 3
                            local.get 7
                            i32.const 1
                            i32.add
                            local.set 7
                            local.get 3
                            br_if 0 (;@12;)
                          end
                          i32.const 0
                          local.set 3
                        end
                        local.get 3
                        i32.const 255
                        i32.and
                        local.get 5
                        i32.load8_u
                        i32.eq
                        br_if 4 (;@6;)
                        local.get 0
                        i32.const 1
                        i32.add
                        local.set 6
                        i32.const 0
                        local.set 3
                        local.get 4
                        local.set 5
                        block  ;; label = @11
                          loop  ;; label = @12
                            local.get 5
                            i32.const 255
                            i32.and
                            local.get 3
                            i32.const 1134
                            i32.add
                            i32.load8_u
                            local.tee 7
                            i32.ne
                            br_if 1 (;@11;)
                            local.get 6
                            local.get 3
                            i32.add
                            local.set 5
                            local.get 3
                            i32.const 1
                            i32.add
                            local.tee 7
                            local.set 3
                            local.get 5
                            i32.load8_u
                            local.tee 5
                            br_if 0 (;@12;)
                          end
                          local.get 7
                          i32.const 1134
                          i32.add
                          i32.load8_u
                          local.set 7
                          i32.const 0
                          local.set 5
                        end
                        local.get 5
                        i32.const 255
                        i32.and
                        local.get 7
                        i32.const 255
                        i32.and
                        i32.eq
                        br_if 1 (;@9;)
                        local.get 0
                        i32.const 1
                        i32.add
                        local.set 7
                        i32.const 1061
                        local.set 3
                        local.get 4
                        local.set 5
                        block  ;; label = @11
                          loop  ;; label = @12
                            local.get 5
                            i32.const 255
                            i32.and
                            local.get 3
                            i32.load8_u
                            i32.ne
                            br_if 1 (;@11;)
                            local.get 3
                            i32.const 1
                            i32.add
                            local.set 3
                            local.get 7
                            i32.load8_u
                            local.set 5
                            local.get 7
                            i32.const 1
                            i32.add
                            local.set 7
                            local.get 5
                            br_if 0 (;@12;)
                          end
                          i32.const 0
                          local.set 5
                        end
                        local.get 5
                        i32.const 255
                        i32.and
                        local.set 5
                      end
                      local.get 5
                      local.get 3
                      i32.load8_u
                      i32.ne
                      br_if 1 (;@8;)
                      i32.const 1724
                      call $kputs
                      drop
                      i32.const 1973
                      call $kputs
                      drop
                      i32.const 1910
                      call $kputs
                      drop
                      i32.const 1672
                      call $kputs
                      drop
                      i32.const 2769
                      call $kputs
                      drop
                      i32.const 1189
                      call $kputs
                      drop
                      i32.const 2024
                      call $kputs
                      drop
                      br 8 (;@1;)
                    end
                    block  ;; label = @9
                      block  ;; label = @10
                        local.get 2
                        i32.eqz
                        br_if 0 (;@10;)
                        local.get 2
                        i32.load8_u
                        br_if 1 (;@9;)
                      end
                      i32.const 2769
                      local.set 2
                    end
                    local.get 2
                    call $kputs
                    drop
                    br 7 (;@1;)
                  end
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          local.get 4
                          br_if 0 (;@11;)
                          i32.const 0
                          local.set 3
                          i32.const 1067
                          local.set 2
                          br 1 (;@10;)
                        end
                        local.get 0
                        i32.const 1
                        i32.add
                        local.set 6
                        i32.const 0
                        local.set 3
                        local.get 4
                        local.set 5
                        block  ;; label = @11
                          loop  ;; label = @12
                            local.get 5
                            i32.const 255
                            i32.and
                            local.get 3
                            i32.const 1076
                            i32.add
                            i32.load8_u
                            local.tee 7
                            i32.ne
                            br_if 1 (;@11;)
                            local.get 6
                            local.get 3
                            i32.add
                            local.set 5
                            local.get 3
                            i32.const 1
                            i32.add
                            local.tee 7
                            local.set 3
                            local.get 5
                            i32.load8_u
                            local.tee 5
                            br_if 0 (;@12;)
                          end
                          local.get 7
                          i32.const 1076
                          i32.add
                          i32.load8_u
                          local.set 7
                          i32.const 0
                          local.set 5
                        end
                        local.get 5
                        i32.const 255
                        i32.and
                        local.get 7
                        i32.const 255
                        i32.and
                        i32.eq
                        br_if 5 (;@5;)
                        local.get 0
                        i32.const 1
                        i32.add
                        local.set 7
                        i32.const 1079
                        local.set 5
                        local.get 4
                        local.set 3
                        block  ;; label = @11
                          loop  ;; label = @12
                            local.get 3
                            i32.const 255
                            i32.and
                            local.get 5
                            i32.load8_u
                            i32.ne
                            br_if 1 (;@11;)
                            local.get 5
                            i32.const 1
                            i32.add
                            local.set 5
                            local.get 7
                            i32.load8_u
                            local.set 3
                            local.get 7
                            i32.const 1
                            i32.add
                            local.set 7
                            local.get 3
                            br_if 0 (;@12;)
                          end
                          i32.const 0
                          local.set 3
                        end
                        local.get 3
                        i32.const 255
                        i32.and
                        local.get 5
                        i32.load8_u
                        i32.eq
                        br_if 6 (;@4;)
                        local.get 0
                        i32.const 1
                        i32.add
                        local.set 6
                        i32.const 0
                        local.set 3
                        local.get 4
                        local.set 5
                        block  ;; label = @11
                          loop  ;; label = @12
                            local.get 5
                            i32.const 255
                            i32.and
                            local.get 3
                            i32.const 1072
                            i32.add
                            i32.load8_u
                            local.tee 7
                            i32.ne
                            br_if 1 (;@11;)
                            local.get 6
                            local.get 3
                            i32.add
                            local.set 5
                            local.get 3
                            i32.const 1
                            i32.add
                            local.tee 7
                            local.set 3
                            local.get 5
                            i32.load8_u
                            local.tee 5
                            br_if 0 (;@12;)
                          end
                          local.get 7
                          i32.const 1072
                          i32.add
                          i32.load8_u
                          local.set 7
                          i32.const 0
                          local.set 5
                        end
                        local.get 5
                        i32.const 255
                        i32.and
                        local.get 7
                        i32.const 255
                        i32.and
                        i32.eq
                        br_if 1 (;@9;)
                        local.get 0
                        i32.const 1
                        i32.add
                        local.set 5
                        i32.const 1067
                        local.set 2
                        local.get 4
                        local.set 3
                        block  ;; label = @11
                          loop  ;; label = @12
                            local.get 3
                            i32.const 255
                            i32.and
                            local.get 2
                            i32.load8_u
                            i32.ne
                            br_if 1 (;@11;)
                            local.get 2
                            i32.const 1
                            i32.add
                            local.set 2
                            local.get 5
                            i32.load8_u
                            local.set 3
                            local.get 5
                            i32.const 1
                            i32.add
                            local.set 5
                            local.get 3
                            br_if 0 (;@12;)
                          end
                          i32.const 0
                          local.set 3
                        end
                        local.get 3
                        i32.const 255
                        i32.and
                        local.set 3
                      end
                      local.get 3
                      local.get 2
                      i32.load8_u
                      i32.ne
                      br_if 1 (;@8;)
                      i32.const 2331
                      call $kputs
                      drop
                      i32.const 0
                      call $wasi_exit
                      br 8 (;@1;)
                    end
                    local.get 2
                    i32.eqz
                    br_if 5 (;@3;)
                    local.get 2
                    i32.load8_u
                    local.tee 7
                    i32.eqz
                    br_if 5 (;@3;)
                    i32.const 0
                    local.set 3
                    local.get 7
                    local.set 5
                    block  ;; label = @9
                      loop  ;; label = @10
                        local.get 5
                        i32.const 255
                        i32.and
                        local.get 3
                        i32.const 1175
                        i32.add
                        i32.load8_u
                        local.tee 6
                        i32.ne
                        br_if 1 (;@9;)
                        local.get 2
                        local.get 3
                        i32.add
                        local.set 5
                        local.get 3
                        i32.const 1
                        i32.add
                        local.tee 6
                        local.set 3
                        local.get 5
                        i32.const 1
                        i32.add
                        i32.load8_u
                        local.tee 5
                        br_if 0 (;@10;)
                      end
                      local.get 6
                      i32.const 1175
                      i32.add
                      i32.load8_u
                      local.set 6
                      i32.const 0
                      local.set 5
                    end
                    local.get 5
                    i32.const 255
                    i32.and
                    local.get 6
                    i32.const 255
                    i32.and
                    i32.eq
                    br_if 6 (;@2;)
                    i32.const 0
                    local.set 3
                    block  ;; label = @9
                      loop  ;; label = @10
                        local.get 7
                        i32.const 255
                        i32.and
                        local.get 3
                        i32.const 1503
                        i32.add
                        i32.load8_u
                        local.tee 5
                        i32.ne
                        br_if 1 (;@9;)
                        local.get 2
                        local.get 3
                        i32.add
                        local.set 5
                        local.get 3
                        i32.const 1
                        i32.add
                        local.tee 6
                        local.set 3
                        local.get 5
                        i32.const 1
                        i32.add
                        i32.load8_u
                        local.tee 7
                        br_if 0 (;@10;)
                      end
                      local.get 6
                      i32.const 1503
                      i32.add
                      i32.load8_u
                      local.set 5
                      i32.const 0
                      local.set 7
                    end
                    block  ;; label = @9
                      local.get 7
                      i32.const 255
                      i32.and
                      local.get 5
                      i32.const 255
                      i32.and
                      i32.ne
                      br_if 0 (;@9;)
                      i32.const 1351
                      call $kputs
                      drop
                      i32.const 1381
                      call $kputs
                      drop
                      br 8 (;@1;)
                    end
                    local.get 1
                    local.get 2
                    i32.store offset=16
                    i32.const 2343
                    local.get 1
                    i32.const 16
                    i32.add
                    call $kprintf
                    drop
                    br 7 (;@1;)
                  end
                  local.get 4
                  i32.eqz
                  br_if 6 (;@1;)
                  local.get 1
                  local.get 0
                  i32.store
                  i32.const 2606
                  local.get 1
                  call $kprintf
                  drop
                  br 6 (;@1;)
                end
                i32.const 1876
                call $kputs
                drop
                i32.const 1468
                call $kputs
                drop
                i32.const 1320
                call $kputs
                drop
                i32.const 1024
                call $kputs
                drop
                i32.const 2243
                call $kputs
                drop
                i32.const 2277
                call $kputs
                drop
                i32.const 2202
                call $kputs
                drop
                i32.const 1234
                call $kputs
                drop
                i32.const 1139
                call $kputs
                drop
                br 5 (;@1;)
              end
              i32.const 1
              i32.const 1803
              i32.const 7
              call $wasi_write
              drop
              br 4 (;@1;)
            end
            i32.const 1811
            call $kputs
            drop
            i32.const 1290
            call $kputs
            drop
            i32.const 1261
            call $kputs
            drop
            br 3 (;@1;)
          end
          i32.const 1082
          call $kputs
          drop
          br 2 (;@1;)
        end
        i32.const 1515
        call $kputs
        drop
        br 1 (;@1;)
      end
      i32.const 1953
      call $kputs
      drop
    end
    local.get 1
    i32.const 32
    i32.add
    global.set $__stack_pointer)
  (func $shell_main (type 3)
    i32.const 2769
    call $kputs
    drop
    i32.const 2307
    call $kputs
    drop
    i32.const 1988
    call $kputs
    drop
    i32.const 2769
    call $kputs
    drop
    i32.const 1
    i32.const 2340
    i32.const 2
    call $wasi_write
    drop)
  (func $handle_command (type 2) (param i32)
    (local i32 i32 i32)
    i32.const 2
    local.set 1
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          loop  ;; label = @4
            local.get 0
            local.get 1
            i32.add
            local.tee 2
            i32.const -2
            i32.add
            i32.load8_u
            local.tee 3
            i32.eqz
            br_if 2 (;@2;)
            local.get 1
            i32.const 33560062
            i32.add
            local.get 3
            i32.store8
            local.get 2
            i32.const -1
            i32.add
            i32.load8_u
            local.tee 3
            i32.eqz
            br_if 1 (;@3;)
            local.get 1
            i32.const 33560063
            i32.add
            local.get 3
            i32.store8
            local.get 2
            i32.load8_u
            local.tee 2
            i32.eqz
            br_if 3 (;@1;)
            local.get 1
            i32.const 33560064
            i32.add
            local.get 2
            i32.store8
            local.get 1
            i32.const 3
            i32.add
            local.tee 1
            i32.const 257
            i32.ne
            br_if 0 (;@4;)
          end
          i32.const 255
          local.set 1
          br 2 (;@1;)
        end
        local.get 1
        i32.const -1
        i32.add
        local.set 1
        br 1 (;@1;)
      end
      local.get 1
      i32.const -2
      i32.add
      local.set 1
    end
    local.get 1
    i32.const 33560064
    i32.add
    i32.const 0
    i32.store8
    i32.const 33560064
    call $execute_command
    i32.const 1
    i32.const 2340
    i32.const 2
    call $wasi_write
    drop)
  (table (;0;) 2 2 funcref)
  (global $__stack_pointer (mut i32) (i32.const 34608912))
  (global $__tls_base (mut i32) (i32.const 0))
  (export "_start" (func $_start))
  (export "handle_command" (func $handle_command))
  (start $__wasm_init_memory)
  (elem (;0;) (i32.const 1) func $console_init)
  (data $.rodata "  echo    - Echo arguments to stdout\00about\00exit\00cat\00ps\00ls\00bin  dev  etc  home  proc  tmp  usr  var\00clear\00help\00echo\00  about   - Show system information\00/proc/version\00This is a minimal UNIX-like operating system\00  exit    - Exit the shell\002    tty0     00:00:00 shell\001    tty0     00:00:00 kernel\00  clear   - Clear the terminal\00root:x:0:0:root:/root:/bin/sh\00user:x:1000:1000:user:/home/user:/bin/sh\00[INIT] Kernel initialization complete\00console\00  help    - Show this help message\00/etc/passwd\00cat: missing file operand\00[INIT] Memory management initialized\00[INIT] Device drivers initialized\00[INIT] Filesystem initialized\00[DEBUG] kernel_main() started\00Memory: 128MB shared\00[DEBUG] kernel_main() finished\00WebVM - POSIX-compatible WebAssembly OS\00  POSIX-compatible WebAssembly OS\00TODO\00\1b[2J\1b[H\00PID  TTY      TIME     CMD\00=====================================\00WebVM Shell - Available commands:\00Architecture: wasm32\00  WebVM Kernel v0.1.0\00WebVM version 0.1.0\00Version: 0.1.0\00Type 'help' for available commands.\00running entirely in your web browser.\00[KERNEL] Entering main loop...\00[INIT] Starting kernel initialization...\00[KERNEL] Shell exited, halting system...\00[KERNEL] Starting shell...\00  cat     - Display file contents (stub)\00  ps      - List processes (stub)\00  ls      - List files (stub)\00Welcome to WebVM Shell!\00Goodbye!\00$ \00cat: %s: No such file or directory\0a\00[FS] Failed to mount /dev\0a\00[INIT] Failed to initialize memory management\0a\00[INIT] Failed to initialize drivers\0a\00[DRIVER] Failed to initialize driver\0a\00[FS] Failed to mount root filesystem\0a\00[INIT] Failed to initialize filesystem\0a\00sh: %s: command not found\0a\00[DRIVER] All drivers initialized\0a\00[FS] Failed to mount /proc\0a\00[KERNEL] Initialization failed, halting.\0a\00[DRIVER] Initializing driver...\0a\00"))
