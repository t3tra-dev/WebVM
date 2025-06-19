(module $kernel.wasm
  (type (;0;) (func (result i32)))
  (type (;1;) (func (param i32 i32 i32 i32) (result i32)))
  (type (;2;) (func (param i32)))
  (type (;3;) (func (param i32 i64 i32) (result i32)))
  (type (;4;) (func))
  (type (;5;) (func (param i32) (result i32)))
  (type (;6;) (func (param i32 i32) (result i32)))
  (type (;7;) (func (param i32 i32 i32) (result i32)))
  (type (;8;) (func (result i64)))
  (import "env" "memory" (memory (;0;) 529 2048 shared))
  (import "wasi_snapshot_preview1" "fd_write" (func $__wasi_fd_write (type 1)))
  (import "wasi_snapshot_preview1" "proc_exit" (func $__wasi_proc_exit (type 2)))
  (import "wasi_snapshot_preview1" "clock_time_get" (func $__wasi_clock_time_get (type 3)))
  (func $__wasm_init_memory (type 4)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 33570152
          i32.const 0
          i32.const 1
          i32.atomic.rmw.cmpxchg
          br_table 0 (;@3;) 1 (;@2;) 2 (;@1;)
        end
        i32.const 1024
        i32.const 0
        i32.const 3360
        memory.init $.rodata
        i32.const 4384
        i32.const 0
        i32.const 33565768
        memory.fill
        i32.const 33570152
        i32.const 2
        i32.atomic.store
        i32.const 33570152
        i32.const -1
        memory.atomic.notify
        drop
        br 1 (;@1;)
      end
      i32.const 33570152
      i32.const 1
      i64.const -1
      memory.atomic.wait32
      drop
    end
    data.drop $.rodata)
  (func $kernel_main (type 4)
    (local i32)
    i32.const 1866
    call $kputs
    drop
    i32.const 2023
    call $kputs
    drop
    i32.const 2116
    call $kputs
    drop
    i32.const 1957
    call $kputs
    drop
    i32.const 2023
    call $kputs
    drop
    i32.const 4156
    call $kputs
    drop
    i32.const 2278
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
            i32.const 2631
            local.set 0
            br 1 (;@3;)
          end
          i32.const 1675
          call $kputs
          drop
          block  ;; label = @4
            call $fs_init
            i32.const 0
            i32.ge_s
            br_if 0 (;@4;)
            i32.const 2989
            local.set 0
            br 1 (;@3;)
          end
          i32.const 1813
          call $kputs
          drop
          block  ;; label = @4
            call $drivers_init
            i32.const 0
            i32.ge_s
            br_if 0 (;@4;)
            i32.const 2764
            local.set 0
            br 1 (;@3;)
          end
          i32.const 1750
          call $kputs
          drop
          block  ;; label = @4
            call $process_init
            i32.const 0
            i32.ge_s
            br_if 0 (;@4;)
            i32.const 2678
            local.set 0
            br 1 (;@3;)
          end
          i32.const 1712
          call $kputs
          drop
          call $scheduler_init
          i32.const 1784
          call $kputs
          drop
          call $ipc_init
          i32.const 0
          i32.ge_s
          br_if 1 (;@2;)
          i32.const 3818
          local.set 0
        end
        i32.const 2
        local.get 0
        i32.const 0
        call $kfprintf
        drop
        i32.const 2
        i32.const 3882
        i32.const 0
        call $kfprintf
        drop
        i32.const 1
        call $wasi_exit
        br 1 (;@1;)
      end
      i32.const 1843
      call $kputs
      drop
      i32.const 1556
      call $kputs
      drop
    end
    i32.const 2247
    call $kputs
    drop
    i32.const 2319
    call $kputs
    drop
    call $shell_main)
  (func $_start (type 4)
    call $kernel_main)
  (func $mm_init (type 0) (result i32)
    i32.const 0
    i64.const 0
    i64.store offset=4392
    i32.const 0
    i64.const 4328521712
    i64.store offset=4384
    i32.const 0
    i32.const 4384
    i32.store offset=33558816
    i32.const 0
    i32.const 16
    i32.store offset=33558820
    i32.const 0)
  (func $kmalloc (type 5) (param i32) (result i32)
    (local i32 i32 i32 i32)
    block  ;; label = @1
      i32.const 0
      i32.load offset=33558816
      local.tee 1
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      i32.const 7
      i32.add
      i32.const -8
      i32.and
      local.set 0
      loop  ;; label = @2
        block  ;; label = @3
          local.get 1
          i32.load offset=4
          i32.eqz
          br_if 0 (;@3;)
          local.get 1
          i32.load
          local.tee 2
          local.get 0
          i32.lt_u
          br_if 0 (;@3;)
          block  ;; label = @4
            local.get 2
            local.get 0
            i32.const 80
            i32.add
            i32.le_u
            br_if 0 (;@4;)
            local.get 1
            local.get 0
            i32.add
            local.tee 3
            i32.const 1
            i32.store offset=20
            local.get 3
            local.get 1
            i32.store offset=28
            local.get 3
            local.get 1
            i32.load offset=8
            local.tee 4
            i32.store offset=24
            local.get 3
            local.get 2
            local.get 0
            i32.sub
            i32.const -16
            i32.add
            i32.store offset=16
            local.get 3
            i32.const 16
            i32.add
            local.set 2
            block  ;; label = @5
              local.get 4
              i32.eqz
              br_if 0 (;@5;)
              local.get 4
              local.get 2
              i32.store offset=12
            end
            local.get 1
            local.get 2
            i32.store offset=8
            local.get 1
            local.get 0
            i32.store
          end
          local.get 1
          i32.const 0
          i32.store offset=4
          i32.const 0
          i32.const 0
          i32.load offset=33558820
          local.get 0
          i32.add
          i32.store offset=33558820
          local.get 1
          i32.const 16
          i32.add
          return
        end
        local.get 1
        i32.load offset=8
        local.tee 1
        br_if 0 (;@2;)
      end
    end
    i32.const 0)
  (func $kfree (type 2) (param i32)
    (local i32 i32 i32 i32)
    block  ;; label = @1
      local.get 0
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      i32.const -12
      i32.add
      i32.const 1
      i32.store
      i32.const 0
      i32.const 0
      i32.load offset=33558820
      local.get 0
      i32.const -16
      i32.add
      local.tee 1
      i32.load
      local.tee 2
      i32.sub
      i32.store offset=33558820
      block  ;; label = @2
        local.get 0
        i32.const -4
        i32.add
        local.tee 3
        i32.load
        local.tee 4
        i32.eqz
        br_if 0 (;@2;)
        local.get 4
        i32.load offset=4
        i32.eqz
        br_if 0 (;@2;)
        local.get 4
        local.get 0
        i32.const -8
        i32.add
        i32.load
        local.tee 0
        i32.store offset=8
        local.get 4
        local.get 2
        local.get 4
        i32.load
        i32.add
        i32.const 16
        i32.add
        i32.store
        block  ;; label = @3
          local.get 0
          br_if 0 (;@3;)
          local.get 4
          local.set 1
          br 1 (;@2;)
        end
        local.get 0
        local.get 4
        i32.store offset=12
        local.get 3
        i32.load
        local.set 1
      end
      local.get 1
      i32.load offset=8
      local.tee 0
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      i32.load offset=4
      i32.eqz
      br_if 0 (;@1;)
      local.get 1
      local.get 0
      i32.load offset=8
      local.tee 4
      i32.store offset=8
      local.get 1
      local.get 0
      i32.load
      local.get 1
      i32.load
      i32.add
      i32.const 16
      i32.add
      i32.store
      local.get 4
      i32.eqz
      br_if 0 (;@1;)
      local.get 4
      local.get 1
      i32.store offset=12
    end)
  (func $fs_init (type 0) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      i32.const 0
      i32.load offset=33561472
      local.tee 0
      i32.const 9
      i32.gt_s
      br_if 0 (;@1;)
      i32.const 0
      local.get 0
      i32.const 1
      i32.add
      local.tee 1
      i32.store offset=33561472
      local.get 0
      i32.const 264
      i32.mul
      i32.const 33558832
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
      i32.load offset=33561476
      local.set 3
      i32.const 0
      local.get 2
      i32.store offset=33561476
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
          i32.store offset=33561472
          local.get 1
          i32.const 264
          i32.mul
          i32.const 33558832
          i32.add
          local.tee 5
          i32.const 1986356271
          i32.store
          local.get 0
          i32.const 264
          i32.mul
          i32.const 33558832
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
        i32.const 2604
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
      i32.store offset=33561476
      block  ;; label = @2
        local.get 0
        i32.const 7
        i32.gt_s
        br_if 0 (;@2;)
        i32.const 0
        local.get 0
        i32.const 3
        i32.add
        i32.store offset=33561472
        local.get 4
        i32.const 264
        i32.mul
        local.tee 3
        i32.const 33558836
        i32.add
        i32.const 99
        i32.store8
        local.get 3
        i32.const 33558832
        i32.add
        local.tee 6
        i32.const 1869770799
        i32.store
        local.get 0
        i32.const 264
        i32.mul
        i32.const 33558832
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
        i32.store offset=33561476
        i32.const 0
        return
      end
      i32.const 2
      i32.const 3725
      i32.const 0
      call $kfprintf
      drop
      i32.const -1
      return
    end
    i32.const 2
    i32.const 2951
    i32.const 0
    call $kfprintf
    drop
    i32.const -1)
  (func $console_init (type 0) (result i32)
    i32.const 0)
  (func $drivers_init (type 0) (result i32)
    (local i32 i32)
    i32.const 0
    i32.load offset=33561652
    local.set 0
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 0
          i32.load offset=33561648
          local.tee 1
          i32.const 9
          i32.gt_s
          br_if 0 (;@3;)
          i32.const 0
          local.get 1
          i32.const 1
          i32.add
          i32.store offset=33561648
          local.get 1
          i32.const 4
          i32.shl
          local.tee 1
          i32.const 33561500
          i32.add
          local.get 0
          i32.store
          local.get 1
          i32.const 33561496
          i32.add
          i32.const 0
          i32.store
          local.get 1
          i32.const 33561492
          i32.add
          i32.const 1
          i32.store
          local.get 1
          i32.const 33561488
          i32.add
          local.tee 0
          i32.const 1594
          i32.store
          i32.const 0
          local.get 0
          i32.store offset=33561652
          br 1 (;@2;)
        end
        local.get 0
        i32.eqz
        br_if 1 (;@1;)
      end
      loop  ;; label = @2
        i32.const 3970
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
          i32.const 2913
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
    i32.const 3296
    i32.const 0
    call $kprintf
    drop
    i32.const 0)
  (func $kputs (type 5) (param i32) (result i32)
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
    i32.const 4155
    i32.const 1
    call $wasi_write
    drop
    local.get 3)
  (func $kprintf (type 6) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 1072
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    local.get 1
    i32.store offset=44
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
      local.get 0
      i32.const 1
      i32.add
      local.set 5
      local.get 2
      i32.const -1
      i32.add
      local.set 6
      i32.const 0
      local.set 1
      i32.const 0
      local.set 7
      i32.const 0
      local.set 4
      block  ;; label = @2
        loop  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          local.get 3
                          i32.const 255
                          i32.and
                          i32.const 37
                          i32.ne
                          br_if 0 (;@11;)
                          local.get 0
                          local.get 7
                          i32.const 1
                          i32.add
                          local.tee 8
                          i32.add
                          i32.load8_u
                          local.tee 9
                          i32.eqz
                          br_if 0 (;@11;)
                          i32.const 0
                          local.set 10
                          block  ;; label = @12
                            block  ;; label = @13
                              local.get 0
                              local.get 7
                              i32.const 2
                              i32.add
                              local.get 8
                              local.get 9
                              i32.const 45
                              i32.eq
                              local.tee 11
                              select
                              local.tee 3
                              i32.add
                              i32.load8_u
                              local.tee 8
                              i32.const -48
                              i32.add
                              i32.const 255
                              i32.and
                              i32.const 9
                              i32.le_u
                              br_if 0 (;@13;)
                              local.get 3
                              local.set 7
                              br 1 (;@12;)
                            end
                            i32.const 0
                            local.set 10
                            loop  ;; label = @13
                              local.get 10
                              i32.const 10
                              i32.mul
                              local.get 8
                              i32.const -48
                              i32.add
                              i32.const 255
                              i32.and
                              i32.add
                              local.set 10
                              local.get 5
                              local.get 3
                              i32.add
                              local.set 8
                              local.get 3
                              i32.const 1
                              i32.add
                              local.tee 7
                              local.set 3
                              local.get 8
                              i32.load8_u
                              local.tee 8
                              i32.const -48
                              i32.add
                              i32.const 255
                              i32.and
                              i32.const 10
                              i32.lt_u
                              br_if 0 (;@13;)
                            end
                          end
                          block  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                local.get 8
                                i32.const 255
                                i32.and
                                local.tee 3
                                i32.const -100
                                i32.add
                                br_table 1 (;@13;) 5 (;@9;) 5 (;@9;) 5 (;@9;) 5 (;@9;) 5 (;@9;) 5 (;@9;) 5 (;@9;) 5 (;@9;) 5 (;@9;) 5 (;@9;) 5 (;@9;) 5 (;@9;) 5 (;@9;) 5 (;@9;) 0 (;@14;) 5 (;@9;) 5 (;@9;) 5 (;@9;) 5 (;@9;) 7 (;@7;) 4 (;@10;)
                              end
                              block  ;; label = @14
                                local.get 1
                                i32.const 1
                                i32.lt_s
                                br_if 0 (;@14;)
                                i32.const 1
                                local.get 2
                                i32.const 48
                                i32.add
                                local.get 1
                                call $wasi_write
                                drop
                                local.get 1
                                local.get 4
                                i32.add
                                local.set 4
                              end
                              local.get 2
                              local.get 2
                              i32.load offset=44
                              local.tee 1
                              i32.const 4
                              i32.add
                              i32.store offset=44
                              local.get 1
                              i32.load
                              local.tee 1
                              i32.const 2346
                              local.get 1
                              select
                              local.set 12
                              i32.const -1
                              local.set 1
                              local.get 10
                              local.set 3
                              loop  ;; label = @14
                                local.get 3
                                local.tee 8
                                i32.const -1
                                i32.add
                                local.set 3
                                local.get 12
                                local.get 1
                                i32.add
                                local.set 13
                                local.get 1
                                i32.const 1
                                i32.add
                                local.tee 14
                                local.set 1
                                local.get 13
                                i32.const 1
                                i32.add
                                i32.load8_u
                                br_if 0 (;@14;)
                              end
                              block  ;; label = @14
                                local.get 11
                                br_if 0 (;@14;)
                                local.get 10
                                local.get 14
                                i32.le_s
                                br_if 0 (;@14;)
                                local.get 8
                                local.set 1
                                loop  ;; label = @15
                                  i32.const 1
                                  i32.const 2566
                                  i32.const 1
                                  call $wasi_write
                                  drop
                                  local.get 4
                                  i32.const 1
                                  i32.add
                                  local.set 4
                                  local.get 1
                                  i32.const -1
                                  i32.add
                                  local.tee 1
                                  br_if 0 (;@15;)
                                end
                              end
                              i32.const 1
                              local.get 12
                              local.get 14
                              call $wasi_write
                              drop
                              local.get 4
                              local.get 14
                              i32.add
                              local.set 3
                              i32.const 0
                              local.set 1
                              block  ;; label = @14
                                local.get 9
                                i32.const 45
                                i32.eq
                                br_if 0 (;@14;)
                                local.get 3
                                local.set 4
                                br 10 (;@4;)
                              end
                              local.get 10
                              local.get 14
                              i32.gt_s
                              br_if 1 (;@12;)
                              local.get 3
                              local.set 4
                              br 9 (;@4;)
                            end
                            local.get 2
                            local.get 2
                            i32.load offset=44
                            local.tee 3
                            i32.const 4
                            i32.add
                            i32.store offset=44
                            local.get 3
                            i32.load
                            local.tee 12
                            local.get 12
                            i32.const 31
                            i32.shr_s
                            local.tee 3
                            i32.xor
                            local.get 3
                            i32.sub
                            local.set 3
                            local.get 2
                            local.set 8
                            loop  ;; label = @13
                              local.get 8
                              local.get 3
                              local.get 3
                              i32.const 10
                              i32.div_u
                              local.tee 13
                              i32.const 10
                              i32.mul
                              i32.sub
                              i32.const 1024
                              i32.add
                              i32.load8_u
                              i32.store8
                              local.get 8
                              i32.const 1
                              i32.add
                              local.set 8
                              local.get 3
                              i32.const 9
                              i32.gt_u
                              local.set 14
                              local.get 13
                              local.set 3
                              local.get 14
                              br_if 0 (;@13;)
                            end
                            block  ;; label = @13
                              local.get 12
                              i32.const -1
                              i32.gt_s
                              br_if 0 (;@13;)
                              local.get 8
                              i32.const 45
                              i32.store8
                              local.get 8
                              i32.const 1
                              i32.add
                              local.set 8
                            end
                            local.get 8
                            i32.const 0
                            i32.store8
                            block  ;; label = @13
                              local.get 2
                              local.get 8
                              i32.const -1
                              i32.add
                              local.tee 3
                              i32.ge_u
                              br_if 0 (;@13;)
                              local.get 2
                              local.set 8
                              loop  ;; label = @14
                                local.get 3
                                i32.load8_u
                                local.set 13
                                local.get 3
                                local.get 8
                                i32.load8_u
                                i32.store8
                                local.get 8
                                local.get 13
                                i32.store8
                                local.get 8
                                i32.const 1
                                i32.add
                                local.tee 8
                                local.get 3
                                i32.const -1
                                i32.add
                                local.tee 3
                                i32.lt_u
                                br_if 0 (;@14;)
                              end
                            end
                            local.get 10
                            i32.const 1
                            i32.add
                            local.set 8
                            i32.const 0
                            local.set 3
                            loop  ;; label = @13
                              local.get 8
                              i32.const -1
                              i32.add
                              local.set 8
                              local.get 3
                              local.tee 13
                              i32.const 1
                              i32.add
                              local.set 3
                              local.get 2
                              local.get 13
                              i32.add
                              i32.load8_u
                              br_if 0 (;@13;)
                            end
                            local.get 3
                            i32.const -1
                            i32.add
                            local.set 15
                            block  ;; label = @13
                              local.get 11
                              br_if 0 (;@13;)
                              local.get 10
                              local.get 15
                              i32.le_s
                              br_if 0 (;@13;)
                              block  ;; label = @14
                                i32.const 0
                                local.get 8
                                i32.sub
                                i32.const -4
                                i32.gt_u
                                br_if 0 (;@14;)
                                local.get 10
                                local.get 13
                                i32.sub
                                i32.const -4
                                i32.and
                                local.set 11
                                loop  ;; label = @15
                                  i32.const 1023
                                  local.set 14
                                  i32.const 1023
                                  local.set 12
                                  block  ;; label = @16
                                    local.get 1
                                    i32.const 1022
                                    i32.gt_u
                                    br_if 0 (;@16;)
                                    local.get 2
                                    i32.const 48
                                    i32.add
                                    local.get 1
                                    i32.add
                                    i32.const 32
                                    i32.store8
                                    local.get 1
                                    i32.const 1
                                    i32.add
                                    local.set 12
                                  end
                                  block  ;; label = @16
                                    local.get 12
                                    i32.const 1022
                                    i32.gt_u
                                    br_if 0 (;@16;)
                                    local.get 2
                                    i32.const 48
                                    i32.add
                                    local.get 12
                                    i32.add
                                    i32.const 32
                                    i32.store8
                                    local.get 12
                                    i32.const 1
                                    i32.add
                                    local.set 14
                                  end
                                  i32.const 1023
                                  local.set 1
                                  i32.const 1023
                                  local.set 12
                                  block  ;; label = @16
                                    local.get 14
                                    i32.const 1022
                                    i32.gt_u
                                    br_if 0 (;@16;)
                                    local.get 2
                                    i32.const 48
                                    i32.add
                                    local.get 14
                                    i32.add
                                    i32.const 32
                                    i32.store8
                                    local.get 14
                                    i32.const 1
                                    i32.add
                                    local.set 12
                                  end
                                  block  ;; label = @16
                                    local.get 12
                                    i32.const 1022
                                    i32.gt_u
                                    br_if 0 (;@16;)
                                    local.get 2
                                    i32.const 48
                                    i32.add
                                    local.get 12
                                    i32.add
                                    i32.const 32
                                    i32.store8
                                    local.get 12
                                    i32.const 1
                                    i32.add
                                    local.set 1
                                  end
                                  local.get 11
                                  i32.const -4
                                  i32.add
                                  local.tee 11
                                  br_if 0 (;@15;)
                                end
                              end
                              local.get 8
                              i32.const 3
                              i32.and
                              i32.eqz
                              br_if 0 (;@13;)
                              local.get 10
                              local.get 13
                              i32.sub
                              i32.const 3
                              i32.and
                              local.set 12
                              local.get 1
                              local.set 14
                              loop  ;; label = @14
                                i32.const 1023
                                local.set 1
                                block  ;; label = @15
                                  local.get 14
                                  i32.const 1022
                                  i32.gt_u
                                  br_if 0 (;@15;)
                                  local.get 2
                                  i32.const 48
                                  i32.add
                                  local.get 14
                                  i32.add
                                  i32.const 32
                                  i32.store8
                                  local.get 14
                                  i32.const 1
                                  i32.add
                                  local.set 1
                                end
                                local.get 1
                                local.set 14
                                local.get 12
                                i32.const -1
                                i32.add
                                local.tee 12
                                br_if 0 (;@14;)
                              end
                            end
                            local.get 3
                            i32.const 1
                            i32.eq
                            br_if 7 (;@5;)
                            local.get 1
                            i32.const 1022
                            i32.gt_u
                            br_if 7 (;@5;)
                            local.get 2
                            i32.const 48
                            i32.add
                            local.get 1
                            i32.add
                            local.set 11
                            i32.const 0
                            local.set 3
                            loop  ;; label = @13
                              local.get 11
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
                              local.tee 14
                              local.get 15
                              i32.ge_u
                              br_if 7 (;@6;)
                              local.get 1
                              local.get 3
                              i32.add
                              local.set 12
                              local.get 14
                              local.set 3
                              local.get 12
                              i32.const 1022
                              i32.lt_u
                              br_if 0 (;@13;)
                              br 7 (;@6;)
                            end
                          end
                          loop  ;; label = @12
                            i32.const 1
                            i32.const 2566
                            i32.const 1
                            call $wasi_write
                            drop
                            local.get 8
                            i32.const -1
                            i32.add
                            local.tee 8
                            br_if 0 (;@12;)
                          end
                          local.get 4
                          local.get 10
                          i32.add
                          local.set 4
                          br 7 (;@4;)
                        end
                        local.get 2
                        i32.const 48
                        i32.add
                        local.get 1
                        i32.add
                        local.get 3
                        i32.store8
                        local.get 1
                        i32.const 1
                        i32.add
                        local.set 1
                        br 6 (;@4;)
                      end
                      local.get 3
                      i32.const 37
                      i32.eq
                      br_if 1 (;@8;)
                    end
                    local.get 2
                    i32.const 48
                    i32.add
                    local.get 1
                    i32.add
                    i32.const 37
                    i32.store8
                    block  ;; label = @9
                      local.get 1
                      i32.const 1021
                      i32.le_u
                      br_if 0 (;@9;)
                      i32.const 1023
                      local.set 1
                      br 7 (;@2;)
                    end
                    local.get 1
                    local.get 2
                    i32.const 48
                    i32.add
                    i32.add
                    local.get 8
                    i32.store8 offset=1
                    local.get 1
                    i32.const 2
                    i32.add
                    local.set 1
                    br 4 (;@4;)
                  end
                  local.get 2
                  i32.const 48
                  i32.add
                  local.get 1
                  i32.add
                  i32.const 37
                  i32.store8
                  local.get 1
                  i32.const 1
                  i32.add
                  local.set 1
                  br 3 (;@4;)
                end
                local.get 2
                local.get 2
                i32.load offset=44
                local.tee 3
                i32.const 4
                i32.add
                i32.store offset=44
                local.get 3
                i32.load
                local.set 10
                local.get 6
                local.set 3
                loop  ;; label = @7
                  local.get 3
                  i32.const 1
                  i32.add
                  local.tee 3
                  local.get 10
                  i32.const 15
                  i32.and
                  i32.const 1024
                  i32.add
                  i32.load8_u
                  i32.store8
                  local.get 10
                  i32.const 15
                  i32.gt_u
                  local.set 8
                  local.get 10
                  i32.const 4
                  i32.shr_u
                  local.set 10
                  local.get 8
                  br_if 0 (;@7;)
                end
                local.get 3
                i32.const 1
                i32.add
                i32.const 0
                i32.store8
                block  ;; label = @7
                  local.get 2
                  local.get 3
                  i32.ge_u
                  br_if 0 (;@7;)
                  local.get 2
                  local.set 10
                  loop  ;; label = @8
                    local.get 3
                    i32.load8_u
                    local.set 8
                    local.get 3
                    local.get 10
                    i32.load8_u
                    i32.store8
                    local.get 10
                    local.get 8
                    i32.store8
                    local.get 10
                    i32.const 1
                    i32.add
                    local.tee 10
                    local.get 3
                    i32.const -1
                    i32.add
                    local.tee 3
                    i32.lt_u
                    br_if 0 (;@8;)
                  end
                end
                i32.const 0
                local.set 3
                loop  ;; label = @7
                  local.get 2
                  local.get 3
                  i32.add
                  local.set 10
                  local.get 3
                  i32.const 1
                  i32.add
                  local.tee 8
                  local.set 3
                  local.get 10
                  i32.load8_u
                  br_if 0 (;@7;)
                end
                local.get 8
                i32.const 1
                i32.eq
                br_if 2 (;@4;)
                local.get 1
                i32.const 1022
                i32.gt_u
                br_if 2 (;@4;)
                local.get 8
                i32.const -1
                i32.add
                local.set 13
                local.get 2
                i32.const 48
                i32.add
                local.get 1
                i32.add
                local.set 14
                i32.const 0
                local.set 3
                block  ;; label = @7
                  loop  ;; label = @8
                    local.get 14
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
                    local.tee 10
                    local.get 13
                    i32.ge_u
                    br_if 1 (;@7;)
                    local.get 1
                    local.get 3
                    i32.add
                    local.set 8
                    local.get 10
                    local.set 3
                    local.get 8
                    i32.const 1022
                    i32.lt_u
                    br_if 0 (;@8;)
                  end
                end
                local.get 1
                local.get 10
                i32.add
                local.set 1
                br 2 (;@4;)
              end
              local.get 1
              local.get 14
              i32.add
              local.set 1
            end
            local.get 9
            i32.const 45
            i32.ne
            br_if 0 (;@4;)
            local.get 10
            local.get 15
            i32.le_s
            br_if 0 (;@4;)
            block  ;; label = @5
              i32.const 0
              local.get 8
              i32.sub
              i32.const -4
              i32.gt_u
              br_if 0 (;@5;)
              local.get 10
              local.get 13
              i32.sub
              i32.const -4
              i32.and
              local.set 3
              loop  ;; label = @6
                block  ;; label = @7
                  local.get 1
                  i32.const 1022
                  i32.gt_u
                  br_if 0 (;@7;)
                  local.get 2
                  i32.const 48
                  i32.add
                  local.get 1
                  i32.add
                  i32.const 32
                  i32.store8
                  local.get 1
                  i32.const 1
                  i32.add
                  local.set 1
                end
                block  ;; label = @7
                  local.get 1
                  i32.const 1022
                  i32.gt_u
                  br_if 0 (;@7;)
                  local.get 2
                  i32.const 48
                  i32.add
                  local.get 1
                  i32.add
                  i32.const 32
                  i32.store8
                  local.get 1
                  i32.const 1
                  i32.add
                  local.set 1
                end
                block  ;; label = @7
                  local.get 1
                  i32.const 1022
                  i32.gt_u
                  br_if 0 (;@7;)
                  local.get 2
                  i32.const 48
                  i32.add
                  local.get 1
                  i32.add
                  i32.const 32
                  i32.store8
                  local.get 1
                  i32.const 1
                  i32.add
                  local.set 1
                end
                block  ;; label = @7
                  local.get 1
                  i32.const 1022
                  i32.gt_u
                  br_if 0 (;@7;)
                  local.get 2
                  i32.const 48
                  i32.add
                  local.get 1
                  i32.add
                  i32.const 32
                  i32.store8
                  local.get 1
                  i32.const 1
                  i32.add
                  local.set 1
                end
                local.get 3
                i32.const -4
                i32.add
                local.tee 3
                br_if 0 (;@6;)
              end
            end
            local.get 8
            i32.const 3
            i32.and
            i32.eqz
            br_if 0 (;@4;)
            local.get 10
            local.get 13
            i32.sub
            i32.const 3
            i32.and
            local.set 3
            loop  ;; label = @5
              block  ;; label = @6
                local.get 1
                i32.const 1022
                i32.gt_u
                br_if 0 (;@6;)
                local.get 2
                i32.const 48
                i32.add
                local.get 1
                i32.add
                i32.const 32
                i32.store8
                local.get 1
                i32.const 1
                i32.add
                local.set 1
              end
              local.get 3
              i32.const -1
              i32.add
              local.tee 3
              br_if 0 (;@5;)
            end
          end
          block  ;; label = @4
            local.get 0
            local.get 7
            i32.const 1
            i32.add
            local.tee 7
            i32.add
            i32.load8_u
            local.tee 3
            i32.eqz
            br_if 0 (;@4;)
            local.get 1
            i32.const 1023
            i32.lt_u
            br_if 1 (;@3;)
          end
        end
        local.get 1
        i32.const 1
        i32.lt_s
        br_if 1 (;@1;)
      end
      i32.const 1
      local.get 2
      i32.const 48
      i32.add
      local.get 1
      call $wasi_write
      drop
      local.get 1
      local.get 4
      i32.add
      local.set 4
    end
    local.get 2
    i32.const 1072
    i32.add
    global.set $__stack_pointer
    local.get 4)
  (func $kfprintf (type 7) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 1072
    i32.sub
    local.tee 3
    global.set $__stack_pointer
    local.get 3
    local.get 2
    i32.store offset=44
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i32.load8_u
        local.tee 2
        br_if 0 (;@2;)
        i32.const 0
        local.set 4
        br 1 (;@1;)
      end
      local.get 1
      local.set 5
      i32.const 0
      local.set 6
      i32.const 0
      local.set 7
      i32.const 0
      local.set 4
      loop  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 2
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
                      local.get 3
                      i32.const 48
                      i32.add
                      local.get 6
                      i32.add
                      i32.const 37
                      i32.store8
                      local.get 6
                      i32.const 1
                      i32.add
                      local.set 6
                      local.get 7
                      i32.const 2
                      i32.add
                      local.set 7
                      br 6 (;@3;)
                    end
                    block  ;; label = @9
                      local.get 6
                      i32.eqz
                      br_if 0 (;@9;)
                      local.get 0
                      local.get 3
                      i32.const 48
                      i32.add
                      local.get 6
                      call $wasi_write
                      drop
                    end
                    local.get 3
                    local.get 3
                    i32.load offset=44
                    local.tee 2
                    i32.const 4
                    i32.add
                    i32.store offset=44
                    local.get 2
                    i32.load
                    local.tee 2
                    i32.const 2346
                    local.get 2
                    select
                    local.set 8
                    i32.const 0
                    local.set 2
                    loop  ;; label = @9
                      local.get 8
                      local.get 2
                      i32.add
                      local.set 5
                      local.get 2
                      i32.const 1
                      i32.add
                      local.tee 9
                      local.set 2
                      local.get 5
                      i32.load8_u
                      br_if 0 (;@9;)
                    end
                    local.get 0
                    local.get 8
                    local.get 9
                    i32.const -1
                    i32.add
                    local.tee 2
                    call $wasi_write
                    drop
                    local.get 2
                    local.get 6
                    local.get 4
                    i32.add
                    i32.add
                    local.set 4
                    i32.const 0
                    local.set 6
                    local.get 7
                    i32.const 2
                    i32.add
                    local.set 7
                    br 5 (;@3;)
                  end
                  local.get 3
                  local.get 3
                  i32.load offset=44
                  local.tee 2
                  i32.const 4
                  i32.add
                  i32.store offset=44
                  local.get 2
                  i32.load
                  local.tee 10
                  local.get 10
                  i32.const 31
                  i32.shr_s
                  local.tee 2
                  i32.xor
                  local.get 2
                  i32.sub
                  local.set 2
                  local.get 3
                  local.set 5
                  loop  ;; label = @8
                    local.get 5
                    local.get 2
                    local.get 2
                    i32.const 10
                    i32.div_u
                    local.tee 8
                    i32.const 10
                    i32.mul
                    i32.sub
                    i32.const 1024
                    i32.add
                    i32.load8_u
                    i32.store8
                    local.get 5
                    i32.const 1
                    i32.add
                    local.set 5
                    local.get 2
                    i32.const 9
                    i32.gt_u
                    local.set 9
                    local.get 8
                    local.set 2
                    local.get 9
                    br_if 0 (;@8;)
                  end
                  block  ;; label = @8
                    local.get 10
                    i32.const -1
                    i32.gt_s
                    br_if 0 (;@8;)
                    local.get 5
                    i32.const 45
                    i32.store8
                    local.get 5
                    i32.const 1
                    i32.add
                    local.set 5
                  end
                  local.get 5
                  i32.const 0
                  i32.store8
                  block  ;; label = @8
                    local.get 3
                    local.get 5
                    i32.const -1
                    i32.add
                    local.tee 2
                    i32.ge_u
                    br_if 0 (;@8;)
                    local.get 3
                    local.set 5
                    loop  ;; label = @9
                      local.get 2
                      i32.load8_u
                      local.set 8
                      local.get 2
                      local.get 5
                      i32.load8_u
                      i32.store8
                      local.get 5
                      local.get 8
                      i32.store8
                      local.get 5
                      i32.const 1
                      i32.add
                      local.tee 5
                      local.get 2
                      i32.const -1
                      i32.add
                      local.tee 2
                      i32.lt_u
                      br_if 0 (;@9;)
                    end
                  end
                  i32.const 0
                  local.set 2
                  loop  ;; label = @8
                    local.get 3
                    local.get 2
                    i32.add
                    local.set 5
                    local.get 2
                    i32.const 1
                    i32.add
                    local.tee 8
                    local.set 2
                    local.get 5
                    i32.load8_u
                    br_if 0 (;@8;)
                  end
                  local.get 8
                  i32.const 1
                  i32.eq
                  br_if 1 (;@6;)
                  local.get 6
                  i32.const 1022
                  i32.gt_u
                  br_if 1 (;@6;)
                  local.get 8
                  i32.const -1
                  i32.add
                  local.set 9
                  local.get 3
                  i32.const 48
                  i32.add
                  local.get 6
                  i32.add
                  local.set 10
                  i32.const 0
                  local.set 2
                  loop  ;; label = @8
                    local.get 10
                    local.get 2
                    i32.add
                    local.get 3
                    local.get 2
                    i32.add
                    i32.load8_u
                    i32.store8
                    local.get 2
                    i32.const 1
                    i32.add
                    local.tee 5
                    local.get 9
                    i32.ge_u
                    br_if 4 (;@4;)
                    local.get 6
                    local.get 2
                    i32.add
                    local.set 8
                    local.get 5
                    local.set 2
                    local.get 8
                    i32.const 1022
                    i32.lt_u
                    br_if 0 (;@8;)
                    br 4 (;@4;)
                  end
                end
                local.get 3
                i32.const 48
                i32.add
                local.get 6
                i32.add
                i32.const 37
                i32.store8
                block  ;; label = @7
                  local.get 6
                  i32.const 1021
                  i32.le_u
                  br_if 0 (;@7;)
                  i32.const 1023
                  local.set 6
                  local.get 7
                  i32.const 2
                  i32.add
                  local.set 7
                  br 4 (;@3;)
                end
                local.get 6
                local.get 3
                i32.const 48
                i32.add
                i32.add
                local.get 5
                i32.store8 offset=1
                local.get 6
                i32.const 2
                i32.add
                local.set 6
              end
              local.get 7
              i32.const 2
              i32.add
              local.set 7
              br 2 (;@3;)
            end
            local.get 3
            i32.const 48
            i32.add
            local.get 6
            i32.add
            local.get 2
            i32.store8
            local.get 6
            i32.const 1
            i32.add
            local.set 6
            local.get 7
            i32.const 1
            i32.add
            local.set 7
            br 1 (;@3;)
          end
          local.get 6
          local.get 5
          i32.add
          local.set 6
          local.get 7
          i32.const 2
          i32.add
          local.set 7
        end
        block  ;; label = @3
          local.get 1
          local.get 7
          i32.add
          local.tee 5
          i32.load8_u
          local.tee 2
          i32.eqz
          br_if 0 (;@3;)
          local.get 6
          i32.const 1023
          i32.lt_u
          br_if 1 (;@2;)
        end
      end
      local.get 6
      i32.const 1
      i32.lt_s
      br_if 0 (;@1;)
      local.get 0
      local.get 3
      i32.const 48
      i32.add
      local.get 6
      call $wasi_write
      drop
      local.get 6
      local.get 4
      i32.add
      local.set 4
    end
    local.get 3
    i32.const 1072
    i32.add
    global.set $__stack_pointer
    local.get 4)
  (func $wasi_write (type 7) (param i32 i32 i32) (result i32)
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
  (func $wasi_get_time_ns (type 8) (result i64)
    (local i32 i64)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    i32.const 0
    i64.const 1000000
    local.get 0
    i32.const 8
    i32.add
    call $__wasi_clock_time_get
    drop
    local.get 0
    i64.load offset=8
    local.set 1
    local.get 0
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get 1)
  (func $execute_command (type 2) (param i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 80
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
                        local.get 0
                        i32.load8_u
                        local.tee 4
                        br_if 0 (;@10;)
                        i32.const 0
                        local.set 5
                        i32.const 1098
                        local.set 3
                        br 1 (;@9;)
                      end
                      local.get 0
                      i32.const 1
                      i32.add
                      local.set 6
                      i32.const 0
                      local.set 3
                      local.get 4
                      local.set 5
                      block  ;; label = @10
                        loop  ;; label = @11
                          local.get 5
                          i32.const 255
                          i32.and
                          local.get 3
                          i32.const 1279
                          i32.add
                          i32.load8_u
                          local.tee 7
                          i32.ne
                          br_if 1 (;@10;)
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
                          br_if 0 (;@11;)
                        end
                        local.get 7
                        i32.const 1279
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
                      br_if 3 (;@6;)
                      local.get 0
                      i32.const 1
                      i32.add
                      local.set 7
                      i32.const 1273
                      local.set 5
                      local.get 4
                      local.set 3
                      block  ;; label = @10
                        loop  ;; label = @11
                          local.get 3
                          i32.const 255
                          i32.and
                          local.get 5
                          i32.load8_u
                          i32.ne
                          br_if 1 (;@10;)
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
                          br_if 0 (;@11;)
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
                      br_if 4 (;@5;)
                      local.get 0
                      i32.const 1
                      i32.add
                      local.set 6
                      i32.const 0
                      local.set 3
                      local.get 4
                      local.set 5
                      block  ;; label = @10
                        loop  ;; label = @11
                          local.get 5
                          i32.const 255
                          i32.and
                          local.get 3
                          i32.const 1284
                          i32.add
                          i32.load8_u
                          local.tee 7
                          i32.ne
                          br_if 1 (;@10;)
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
                          br_if 0 (;@11;)
                        end
                        local.get 7
                        i32.const 1284
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
                      br_if 1 (;@8;)
                      local.get 0
                      i32.const 1
                      i32.add
                      local.set 7
                      i32.const 1098
                      local.set 3
                      local.get 4
                      local.set 5
                      block  ;; label = @10
                        loop  ;; label = @11
                          local.get 5
                          i32.const 255
                          i32.and
                          local.get 3
                          i32.load8_u
                          i32.ne
                          br_if 1 (;@10;)
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
                          br_if 0 (;@11;)
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
                    br_if 1 (;@7;)
                    i32.const 1917
                    call $kputs
                    drop
                    i32.const 2158
                    call $kputs
                    drop
                    i32.const 2095
                    call $kputs
                    drop
                    i32.const 1896
                    call $kputs
                    drop
                    i32.const 4156
                    call $kputs
                    drop
                    i32.const 1345
                    call $kputs
                    drop
                    i32.const 2209
                    call $kputs
                    drop
                    br 7 (;@1;)
                  end
                  block  ;; label = @8
                    block  ;; label = @9
                      local.get 2
                      i32.eqz
                      br_if 0 (;@9;)
                      local.get 2
                      i32.load8_u
                      br_if 1 (;@8;)
                    end
                    i32.const 4156
                    local.set 2
                  end
                  local.get 2
                  call $kputs
                  drop
                  br 6 (;@1;)
                end
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          local.get 4
                          br_if 0 (;@11;)
                          i32.const 0
                          local.set 5
                          i32.const 1194
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
                            i32.const 1191
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
                          i32.const 1191
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
                        br_if 6 (;@4;)
                        local.get 0
                        i32.const 1
                        i32.add
                        local.set 7
                        i32.const 1390
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
                        br_if 1 (;@9;)
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
                            i32.const 1289
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
                          i32.const 1289
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
                        br_if 2 (;@8;)
                        local.get 0
                        i32.const 1
                        i32.add
                        local.set 7
                        i32.const 1194
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
                      br_if 2 (;@7;)
                      i32.const 1232
                      call $kputs
                      drop
                      br 8 (;@1;)
                    end
                    local.get 2
                    i32.eqz
                    br_if 5 (;@3;)
                    local.get 2
                    i32.load8_u
                    local.tee 5
                    i32.eqz
                    br_if 5 (;@3;)
                    local.get 2
                    i32.const 1
                    i32.add
                    local.set 3
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            loop  ;; label = @13
                              block  ;; label = @14
                                local.get 5
                                i32.const 255
                                i32.and
                                i32.const -9
                                i32.add
                                br_table 0 (;@14;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 0 (;@14;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 3 (;@11;) 4 (;@10;) 3 (;@11;) 2 (;@12;) 3 (;@11;)
                              end
                              local.get 3
                              i32.load8_u
                              local.set 5
                              local.get 3
                              i32.const 1
                              i32.add
                              local.set 3
                              br 0 (;@13;)
                            end
                          end
                          i32.const -1
                          local.set 6
                          br 2 (;@9;)
                        end
                        local.get 3
                        i32.const -1
                        i32.add
                        local.set 3
                      end
                      i32.const 1
                      local.set 6
                    end
                    i32.const 0
                    local.set 7
                    block  ;; label = @9
                      local.get 3
                      i32.load8_u
                      local.tee 5
                      i32.const -48
                      i32.add
                      i32.const 255
                      i32.and
                      i32.const 9
                      i32.gt_u
                      br_if 0 (;@9;)
                      local.get 3
                      i32.const 1
                      i32.add
                      local.set 3
                      i32.const 0
                      local.set 7
                      loop  ;; label = @10
                        local.get 7
                        i32.const 10
                        i32.mul
                        local.get 5
                        i32.const -48
                        i32.add
                        i32.const 255
                        i32.and
                        i32.add
                        local.set 7
                        local.get 3
                        i32.load8_u
                        local.set 5
                        local.get 3
                        i32.const 1
                        i32.add
                        local.set 3
                        local.get 5
                        i32.const -48
                        i32.add
                        i32.const 255
                        i32.and
                        i32.const 10
                        i32.lt_u
                        br_if 0 (;@10;)
                      end
                    end
                    block  ;; label = @9
                      local.get 7
                      local.get 6
                      i32.mul
                      local.tee 3
                      i32.const -1
                      i32.gt_s
                      br_if 0 (;@9;)
                      local.get 1
                      local.get 2
                      i32.store offset=16
                      i32.const 2836
                      local.get 1
                      i32.const 16
                      i32.add
                      call $kprintf
                      drop
                      br 8 (;@1;)
                    end
                    block  ;; label = @9
                      local.get 3
                      i32.const 1
                      i32.ne
                      br_if 0 (;@9;)
                      i32.const 1395
                      call $kputs
                      drop
                      br 8 (;@1;)
                    end
                    block  ;; label = @9
                      local.get 3
                      i32.const 9
                      call $process_kill
                      i32.const -1
                      i32.gt_s
                      br_if 0 (;@9;)
                      local.get 1
                      local.get 3
                      i32.store offset=32
                      i32.const 3554
                      local.get 1
                      i32.const 32
                      i32.add
                      call $kprintf
                      drop
                      br 8 (;@1;)
                    end
                    local.get 1
                    local.get 3
                    i32.store offset=48
                    i32.const 3439
                    local.get 1
                    i32.const 48
                    i32.add
                    call $kprintf
                    drop
                    br 7 (;@1;)
                  end
                  block  ;; label = @8
                    i32.const 1113
                    i32.const 2
                    call $spawn_simple
                    local.tee 2
                    i32.const -1
                    i32.gt_s
                    br_if 0 (;@8;)
                    i32.const 1159
                    call $kputs
                    drop
                    br 7 (;@1;)
                  end
                  local.get 1
                  local.get 2
                  i32.store offset=64
                  i32.const 3632
                  local.get 1
                  i32.const 64
                  i32.add
                  call $kprintf
                  drop
                  br 6 (;@1;)
                end
                local.get 4
                i32.eqz
                br_if 5 (;@1;)
                i32.const 0
                local.set 3
                local.get 4
                local.set 5
                block  ;; label = @7
                  loop  ;; label = @8
                    local.get 5
                    i32.const 255
                    i32.and
                    local.get 3
                    i32.const 1109
                    i32.add
                    i32.load8_u
                    local.tee 7
                    i32.ne
                    br_if 1 (;@7;)
                    local.get 0
                    local.get 3
                    i32.add
                    local.set 5
                    local.get 3
                    i32.const 1
                    i32.add
                    local.tee 7
                    local.set 3
                    local.get 5
                    i32.const 1
                    i32.add
                    i32.load8_u
                    local.tee 5
                    br_if 0 (;@8;)
                  end
                  local.get 7
                  i32.const 1109
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
                br_if 4 (;@2;)
                i32.const 0
                local.set 2
                block  ;; label = @7
                  block  ;; label = @8
                    loop  ;; label = @9
                      local.get 4
                      i32.const 255
                      i32.and
                      local.get 2
                      i32.const 1104
                      i32.add
                      i32.load8_u
                      i32.ne
                      br_if 1 (;@8;)
                      local.get 0
                      local.get 2
                      i32.add
                      local.set 3
                      local.get 2
                      i32.const 1
                      i32.add
                      local.tee 5
                      local.set 2
                      local.get 3
                      i32.const 1
                      i32.add
                      i32.load8_u
                      local.tee 4
                      br_if 0 (;@9;)
                    end
                    local.get 5
                    i32.const 1104
                    i32.add
                    local.set 2
                    i32.const 0
                    local.set 4
                    br 1 (;@7;)
                  end
                  local.get 2
                  i32.const 1104
                  i32.add
                  local.set 2
                end
                block  ;; label = @7
                  local.get 4
                  i32.const 255
                  i32.and
                  local.get 2
                  i32.load8_u
                  i32.ne
                  br_if 0 (;@7;)
                  i32.const 2493
                  call $kputs
                  drop
                  br 6 (;@1;)
                end
                local.get 1
                local.get 0
                i32.store
                i32.const 3195
                local.get 1
                call $kprintf
                drop
                br 5 (;@1;)
              end
              i32.const 2061
              call $kputs
              drop
              i32.const 1602
              call $kputs
              drop
              i32.const 1454
              call $kputs
              drop
              i32.const 1061
              call $kputs
              drop
              i32.const 1197
              call $kputs
              drop
              i32.const 2424
              call $kputs
              drop
              i32.const 1126
              call $kputs
              drop
              i32.const 2394
              call $kputs
              drop
              i32.const 2353
              call $kputs
              drop
              i32.const 1427
              call $kputs
              drop
              i32.const 1295
              call $kputs
              drop
              br 4 (;@1;)
            end
            i32.const 1
            i32.const 1991
            i32.const 7
            call $wasi_write
            drop
            br 3 (;@1;)
          end
          call $process_dump_table
          br 2 (;@1;)
        end
        i32.const 1999
        call $kputs
        drop
        br 1 (;@1;)
      end
      local.get 2
      call $cmd_cat
    end
    local.get 1
    i32.const 80
    i32.add
    global.set $__stack_pointer)
  (func $test_process_entry (type 6) (param i32 i32) (result i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 96
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    call $process_get_current
    i32.load
    i32.store offset=80
    i32.const 4119
    local.get 2
    i32.const 80
    i32.add
    call $kprintf
    drop
    local.get 2
    i32.const 0
    i32.store offset=64
    i32.const 3462
    local.get 2
    i32.const 64
    i32.add
    call $kprintf
    drop
    call $scheduler_yield
    local.get 2
    i32.const 1
    i32.store offset=48
    i32.const 3462
    local.get 2
    i32.const 48
    i32.add
    call $kprintf
    drop
    call $scheduler_yield
    local.get 2
    i32.const 2
    i32.store offset=32
    i32.const 3462
    local.get 2
    i32.const 32
    i32.add
    call $kprintf
    drop
    call $scheduler_yield
    local.get 2
    i32.const 3
    i32.store offset=16
    i32.const 3462
    local.get 2
    i32.const 16
    i32.add
    call $kprintf
    drop
    call $scheduler_yield
    local.get 2
    i32.const 4
    i32.store
    i32.const 3462
    local.get 2
    call $kprintf
    drop
    call $scheduler_yield
    i32.const 3029
    i32.const 0
    call $kprintf
    drop
    local.get 2
    i32.const 96
    i32.add
    global.set $__stack_pointer
    i32.const 0)
  (func $cmd_cat (type 2) (param i32)
    (local i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.eqz
          br_if 0 (;@3;)
          local.get 0
          i32.load8_u
          local.tee 2
          i32.eqz
          br_if 0 (;@3;)
          i32.const 0
          local.set 3
          local.get 2
          local.set 4
          block  ;; label = @4
            loop  ;; label = @5
              local.get 4
              i32.const 255
              i32.and
              local.get 3
              i32.const 1331
              i32.add
              i32.load8_u
              local.tee 5
              i32.ne
              br_if 1 (;@4;)
              local.get 0
              local.get 3
              i32.add
              local.set 4
              local.get 3
              i32.const 1
              i32.add
              local.tee 5
              local.set 3
              local.get 4
              i32.const 1
              i32.add
              i32.load8_u
              local.tee 4
              br_if 0 (;@5;)
            end
            local.get 5
            i32.const 1331
            i32.add
            i32.load8_u
            local.set 5
            i32.const 0
            local.set 4
          end
          local.get 4
          i32.const 255
          i32.and
          local.get 5
          i32.const 255
          i32.and
          i32.eq
          br_if 1 (;@2;)
          i32.const 0
          local.set 3
          block  ;; label = @4
            loop  ;; label = @5
              local.get 2
              i32.const 255
              i32.and
              local.get 3
              i32.const 1637
              i32.add
              i32.load8_u
              local.tee 4
              i32.ne
              br_if 1 (;@4;)
              local.get 0
              local.get 3
              i32.add
              local.set 4
              local.get 3
              i32.const 1
              i32.add
              local.tee 5
              local.set 3
              local.get 4
              i32.const 1
              i32.add
              i32.load8_u
              local.tee 2
              br_if 0 (;@5;)
            end
            local.get 5
            i32.const 1637
            i32.add
            i32.load8_u
            local.set 4
            i32.const 0
            local.set 2
          end
          block  ;; label = @4
            local.get 2
            i32.const 255
            i32.and
            local.get 4
            i32.const 255
            i32.and
            i32.ne
            br_if 0 (;@4;)
            i32.const 1485
            call $kputs
            drop
            i32.const 1515
            call $kputs
            drop
            br 3 (;@1;)
          end
          local.get 1
          local.get 0
          i32.store
          i32.const 2568
          local.get 1
          call $kprintf
          drop
          br 2 (;@1;)
        end
        i32.const 1649
        call $kputs
        drop
        br 1 (;@1;)
      end
      i32.const 2138
      call $kputs
      drop
    end
    local.get 1
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $shell_main (type 4)
    i32.const 4156
    call $kputs
    drop
    i32.const 2469
    call $kputs
    drop
    i32.const 2173
    call $kputs
    drop
    i32.const 4156
    call $kputs
    drop
    i32.const 1
    i32.const 2529
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
            i32.const 33561662
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
            i32.const 33561663
            i32.add
            local.get 3
            i32.store8
            local.get 2
            i32.load8_u
            local.tee 2
            i32.eqz
            br_if 3 (;@1;)
            local.get 1
            i32.const 33561664
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
    i32.const 33561664
    i32.add
    i32.const 0
    i32.store8
    i32.const 33561664
    call $execute_command
    i32.const 1
    i32.const 2529
    i32.const 2
    call $wasi_write
    drop)
  (func $process_init (type 0) (result i32)
    (local i32)
    i32.const 3924
    i32.const 0
    call $kprintf
    drop
    i32.const -7184
    local.set 0
    loop  ;; label = @1
      local.get 0
      i32.const 33569104
      i32.add
      i64.const 0
      i64.store align=1
      local.get 0
      i32.const 8
      i32.add
      local.tee 0
      br_if 0 (;@1;)
    end
    i32.const -7168
    local.set 0
    loop  ;; label = @1
      local.get 0
      i32.const 33569240
      i32.add
      i32.const 0
      i32.store
      local.get 0
      i32.const 33569088
      i32.add
      i32.const -1
      i32.store
      local.get 0
      i32.const 33569128
      i32.add
      i32.const 0
      i32.store
      local.get 0
      i32.const 33569352
      i32.add
      i32.const 0
      i32.store
      local.get 0
      i32.const 33569200
      i32.add
      i32.const -1
      i32.store
      local.get 0
      i32.const 33569464
      i32.add
      i32.const 0
      i32.store
      local.get 0
      i32.const 33569312
      i32.add
      i32.const -1
      i32.store
      local.get 0
      i32.const 33569424
      i32.add
      i32.const -1
      i32.store
      local.get 0
      i32.const 448
      i32.add
      local.tee 0
      br_if 0 (;@1;)
    end
    block  ;; label = @1
      i32.const 112
      i32.eqz
      local.tee 0
      br_if 0 (;@1;)
      i32.const 33561920
      i32.const 4160
      i32.const 112
      memory.copy
    end
    block  ;; label = @1
      local.get 0
      br_if 0 (;@1;)
      i32.const 33562032
      i32.const 4272
      i32.const 112
      memory.copy
    end
    i32.const 0
    i32.const 33562032
    i32.store offset=33569088
    i32.const 0
    i64.const 8589934594
    i64.store offset=33569096
    i32.const 3254
    i32.const 0
    call $kprintf
    drop
    i32.const 0)
  (func $process_create (type 1) (param i32 i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i64)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 4
    global.set $__stack_pointer
    i32.const 0
    local.set 5
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                loop  ;; label = @7
                  local.get 5
                  i32.const 33562072
                  i32.add
                  i32.load
                  i32.eqz
                  br_if 1 (;@6;)
                  local.get 5
                  i32.const 33562184
                  i32.add
                  i32.load
                  i32.eqz
                  br_if 2 (;@5;)
                  local.get 5
                  i32.const 33562296
                  i32.add
                  i32.load
                  i32.eqz
                  br_if 3 (;@4;)
                  local.get 5
                  i32.const 336
                  i32.add
                  local.tee 5
                  i32.const 7056
                  i32.eq
                  br_if 5 (;@2;)
                  br 0 (;@7;)
                end
              end
              local.get 5
              i32.const 33562032
              i32.add
              local.set 6
              br 2 (;@3;)
            end
            local.get 5
            i32.const 33562144
            i32.add
            local.set 6
            br 1 (;@3;)
          end
          local.get 5
          i32.const 33562256
          i32.add
          local.set 6
        end
        i32.const 0
        local.set 5
        local.get 6
        i32.const 0
        i32.load offset=33569096
        local.tee 7
        i32.store
        i32.const 0
        local.get 7
        i32.const 1
        i32.add
        i32.store offset=33569096
        i32.const 0
        local.set 7
        block  ;; label = @3
          i32.const 0
          i32.load offset=33569088
          local.tee 8
          i32.eqz
          br_if 0 (;@3;)
          local.get 8
          i32.load
          local.set 7
        end
        local.get 6
        local.get 7
        i32.store offset=4
        local.get 6
        i32.const 8
        i32.add
        local.set 9
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                loop  ;; label = @7
                  local.get 0
                  local.get 5
                  i32.add
                  local.tee 7
                  i32.load8_u
                  local.tee 10
                  i32.eqz
                  br_if 3 (;@4;)
                  local.get 6
                  local.get 5
                  i32.add
                  local.tee 8
                  i32.const 8
                  i32.add
                  local.get 10
                  i32.store8
                  block  ;; label = @8
                    local.get 7
                    i32.const 1
                    i32.add
                    i32.load8_u
                    local.tee 10
                    i32.eqz
                    br_if 0 (;@8;)
                    local.get 8
                    i32.const 9
                    i32.add
                    local.get 10
                    i32.store8
                    local.get 7
                    i32.const 2
                    i32.add
                    i32.load8_u
                    local.tee 10
                    i32.eqz
                    br_if 2 (;@6;)
                    local.get 8
                    i32.const 10
                    i32.add
                    local.get 10
                    i32.store8
                    local.get 5
                    i32.const 28
                    i32.eq
                    br_if 5 (;@3;)
                    local.get 7
                    i32.const 3
                    i32.add
                    i32.load8_u
                    local.tee 7
                    i32.eqz
                    br_if 3 (;@5;)
                    local.get 8
                    i32.const 11
                    i32.add
                    local.get 7
                    i32.store8
                    local.get 5
                    i32.const 4
                    i32.add
                    local.set 5
                    br 1 (;@7;)
                  end
                end
                local.get 5
                i32.const 1
                i32.add
                local.set 5
                br 2 (;@4;)
              end
              local.get 5
              i32.const 2
              i32.add
              local.set 5
              br 1 (;@4;)
            end
            local.get 5
            i32.const 3
            i32.add
            local.set 5
          end
          local.get 5
          i32.const 30
          i32.gt_u
          br_if 0 (;@3;)
          local.get 5
          local.set 7
          block  ;; label = @4
            local.get 5
            i32.const 7
            i32.and
            local.tee 8
            i32.const 7
            i32.eq
            br_if 0 (;@4;)
            local.get 9
            local.get 5
            i32.add
            local.set 10
            i32.const 0
            local.set 7
            loop  ;; label = @5
              local.get 10
              local.get 7
              i32.add
              i32.const 0
              i32.store8
              local.get 8
              local.get 7
              i32.const 1
              i32.add
              local.tee 7
              i32.xor
              i32.const 7
              i32.ne
              br_if 0 (;@5;)
            end
            local.get 5
            local.get 7
            i32.add
            local.set 7
          end
          local.get 5
          i32.const 23
          i32.gt_u
          br_if 0 (;@3;)
          i32.const 31
          local.set 8
          local.get 6
          local.set 5
          loop  ;; label = @4
            local.get 5
            local.get 7
            i32.add
            i32.const 8
            i32.add
            i64.const 0
            i64.store align=1
            local.get 5
            i32.const 8
            i32.add
            local.set 5
            local.get 7
            local.get 8
            i32.const -8
            i32.add
            local.tee 8
            i32.ne
            br_if 0 (;@4;)
          end
        end
        local.get 6
        i32.const 65536
        i32.store offset=48
        local.get 6
        i32.const 1
        i32.store offset=40
        local.get 6
        i32.const 0
        i32.store8 offset=39
        local.get 6
        i32.const 65536
        call $kmalloc
        local.tee 5
        i32.store offset=44
        block  ;; label = @3
          local.get 5
          br_if 0 (;@3;)
          local.get 4
          local.get 6
          i32.load
          i32.store
          i32.const 3503
          local.get 4
          call $kprintf
          drop
          local.get 6
          i32.const 0
          i32.store offset=40
          i32.const -1
          local.set 5
          br 2 (;@1;)
        end
        local.get 6
        local.get 3
        i32.store offset=80
        local.get 6
        local.get 2
        i32.store offset=76
        local.get 6
        local.get 1
        i32.store offset=72
        local.get 6
        local.get 1
        i32.store offset=64
        local.get 6
        local.get 5
        local.get 6
        i32.load offset=48
        i32.add
        i32.store offset=60
        call $wasi_get_time_ns
        local.set 11
        local.get 6
        i64.const 0
        i64.store offset=96
        local.get 6
        local.get 11
        i64.store offset=88
        local.get 6
        i32.const 2
        i32.store offset=40
        local.get 6
        call $scheduler_add_ready
        i32.const 0
        i32.const 0
        i32.load offset=33569100
        i32.const 1
        i32.add
        i32.store offset=33569100
        local.get 4
        local.get 6
        i32.load
        i32.store offset=16
        local.get 4
        local.get 9
        i32.store offset=20
        i32.const 2859
        local.get 4
        i32.const 16
        i32.add
        call $kprintf
        drop
        local.get 6
        i32.load
        local.set 5
        br 1 (;@1;)
      end
      i32.const 3152
      i32.const 0
      call $kprintf
      drop
      i32.const -1
      local.set 5
    end
    local.get 4
    i32.const 32
    i32.add
    global.set $__stack_pointer
    local.get 5)
  (func $process_get_current (type 0) (result i32)
    i32.const 0
    i32.load offset=33569088)
  (func $process_find (type 5) (param i32) (result i32)
    (local i32)
    i32.const 0
    local.set 1
    block  ;; label = @1
      local.get 0
      i32.const 63
      i32.gt_u
      br_if 0 (;@1;)
      local.get 0
      i32.const 112
      i32.mul
      local.tee 0
      i32.const 33561920
      i32.add
      i32.const 0
      local.get 0
      i32.const 33561960
      i32.add
      i32.load
      select
      local.set 1
    end
    local.get 1)
  (func $process_kill (type 6) (param i32 i32) (result i32)
    (local i32 i32)
    global.get $__stack_pointer
    i32.const 48
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.const 63
          i32.gt_u
          br_if 0 (;@3;)
          local.get 0
          i32.const 112
          i32.mul
          local.tee 3
          i32.const 33561960
          i32.add
          i32.load
          br_if 1 (;@2;)
        end
        local.get 2
        local.get 0
        i32.store
        i32.const 3222
        local.get 2
        call $kprintf
        drop
        i32.const -1
        local.set 0
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 0
        br_if 0 (;@2;)
        i32.const 2726
        i32.const 0
        call $kprintf
        drop
        i32.const -1
        local.set 0
        br 1 (;@1;)
      end
      local.get 2
      local.get 1
      i32.store offset=36
      local.get 2
      local.get 0
      i32.store offset=32
      i32.const 3587
      local.get 2
      i32.const 32
      i32.add
      call $kprintf
      drop
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 3
            i32.const 33561920
            i32.add
            local.tee 3
            i32.load offset=40
            br_table 0 (;@4;) 2 (;@2;) 1 (;@3;) 2 (;@2;) 2 (;@2;) 2 (;@2;) 0 (;@4;) 2 (;@2;)
          end
          local.get 2
          local.get 0
          i32.store offset=16
          i32.const 3398
          local.get 2
          i32.const 16
          i32.add
          call $kprintf
          drop
          i32.const -1
          local.set 0
          br 2 (;@1;)
        end
        local.get 3
        call $scheduler_remove_ready
      end
      local.get 3
      i32.const 6
      i32.store offset=40
      local.get 3
      i32.const 0
      local.get 1
      i32.sub
      i32.store offset=84
      block  ;; label = @2
        local.get 3
        i32.load offset=44
        local.tee 0
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        call $kfree
        local.get 3
        i32.const 0
        i32.store offset=44
      end
      block  ;; label = @2
        local.get 3
        i32.load offset=52
        local.tee 0
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        call $kfree
        local.get 3
        i32.const 0
        i32.store offset=52
      end
      local.get 3
      i32.const -1
      i32.store
      i32.const 0
      local.set 0
      local.get 3
      i32.const 0
      i32.store offset=40
      i32.const 0
      i32.const 0
      i32.load offset=33569100
      i32.const -1
      i32.add
      i32.store offset=33569100
    end
    local.get 2
    i32.const 48
    i32.add
    global.set $__stack_pointer
    local.get 0)
  (func $process_dump_table (type 4)
    (local i32 i32 i32 i64)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    i32.const 0
    local.set 1
    i32.const 3851
    i32.const 0
    call $kprintf
    drop
    i32.const 3790
    i32.const 0
    call $kprintf
    drop
    i32.const 4079
    i32.const 0
    call $kprintf
    drop
    loop  ;; label = @1
      i32.const 2550
      local.set 2
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      local.get 1
                      i32.const 33561960
                      i32.add
                      i32.load
                      br_table 7 (;@2;) 6 (;@3;) 0 (;@9;) 1 (;@8;) 2 (;@7;) 3 (;@6;) 4 (;@5;) 5 (;@4;)
                    end
                    i32.const 2541
                    local.set 2
                    br 5 (;@3;)
                  end
                  i32.const 2520
                  local.set 2
                  br 4 (;@3;)
                end
                i32.const 2511
                local.set 2
                br 3 (;@3;)
              end
              i32.const 2532
              local.set 2
              br 2 (;@3;)
            end
            i32.const 2559
            local.set 2
            br 1 (;@3;)
          end
          i32.const 2502
          local.set 2
        end
        local.get 1
        i32.const 33561920
        i32.add
        i64.load
        local.set 3
        local.get 0
        local.get 1
        i32.const 33561928
        i32.add
        i32.store offset=28
        local.get 0
        local.get 2
        i32.store offset=24
        local.get 0
        local.get 3
        i64.store offset=16
        i32.const 2893
        local.get 0
        i32.const 16
        i32.add
        call $kprintf
        drop
      end
      local.get 1
      i32.const 112
      i32.add
      local.tee 1
      i32.const 7168
      i32.ne
      br_if 0 (;@1;)
    end
    local.get 0
    i32.const 0
    i32.load offset=33569100
    i32.store
    i32.const 3704
    local.get 0
    call $kprintf
    drop
    local.get 0
    i32.const 32
    i32.add
    global.set $__stack_pointer)
  (func $scheduler_init (type 4)
    i32.const 4003
    i32.const 0
    call $kprintf
    drop
    i32.const 0
    i64.const 0
    i64.store offset=33569112
    i32.const 0
    i32.const 1
    i32.store8 offset=33569120
    i32.const 0
    i32.const 0
    i32.store offset=33569108
    i32.const 0
    i32.const 0
    i32.store offset=33569104
    i32.const 3330
    i32.const 0
    call $kprintf
    drop)
  (func $scheduler_add_ready (type 2) (param i32)
    (local i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    block  ;; label = @1
      local.get 0
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      i32.load offset=40
      i32.const 2
      i32.ne
      br_if 0 (;@1;)
      local.get 0
      i64.const 0
      i64.store offset=104
      block  ;; label = @2
        block  ;; label = @3
          i32.const 0
          i32.load offset=33569104
          br_if 0 (;@3;)
          i32.const 0
          local.get 0
          i32.store offset=33569104
          br 1 (;@2;)
        end
        i32.const 0
        i32.load offset=33569108
        local.tee 2
        local.get 0
        i32.store offset=104
        local.get 0
        local.get 2
        i32.store offset=108
      end
      i32.const 0
      local.get 0
      i32.store offset=33569108
      local.get 1
      local.get 0
      i32.load
      i32.store
      i32.const 3058
      local.get 1
      call $kprintf
      drop
    end
    local.get 1
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $scheduler_remove_ready (type 2) (param i32)
    (local i32 i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    block  ;; label = @1
      local.get 0
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      i32.load offset=104
      local.set 2
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.load offset=108
          local.tee 3
          i32.eqz
          br_if 0 (;@3;)
          local.get 3
          local.get 2
          i32.store offset=104
          br 1 (;@2;)
        end
        i32.const 0
        local.get 2
        i32.store offset=33569104
      end
      block  ;; label = @2
        block  ;; label = @3
          local.get 2
          i32.eqz
          br_if 0 (;@3;)
          local.get 2
          local.get 3
          i32.store offset=108
          br 1 (;@2;)
        end
        i32.const 0
        local.get 3
        i32.store offset=33569108
      end
      local.get 0
      i64.const 0
      i64.store offset=104
      local.get 1
      local.get 0
      i32.load
      i32.store
      i32.const 3103
      local.get 1
      call $kprintf
      drop
    end
    local.get 1
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $scheduler_yield (type 4)
    (local i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 64
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    block  ;; label = @1
      i32.const 0
      i32.load8_u offset=33569120
      i32.eqz
      br_if 0 (;@1;)
      call $process_get_current
      local.tee 1
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      local.get 1
      i32.load
      i32.store offset=48
      i32.const 3753
      local.get 0
      i32.const 48
      i32.add
      call $kprintf
      drop
      block  ;; label = @2
        block  ;; label = @3
          i32.const 0
          i32.load offset=33569104
          local.tee 2
          i32.eqz
          br_if 0 (;@3;)
          local.get 2
          i32.load offset=104
          local.set 3
          block  ;; label = @4
            block  ;; label = @5
              local.get 2
              i32.load offset=108
              local.tee 4
              i32.eqz
              br_if 0 (;@5;)
              local.get 4
              local.get 3
              i32.store offset=104
              br 1 (;@4;)
            end
            i32.const 0
            local.get 3
            i32.store offset=33569104
          end
          block  ;; label = @4
            block  ;; label = @5
              local.get 3
              i32.eqz
              br_if 0 (;@5;)
              local.get 3
              local.get 4
              i32.store offset=108
              br 1 (;@4;)
            end
            i32.const 0
            local.get 4
            i32.store offset=33569108
          end
          local.get 2
          i64.const 0
          i64.store offset=104
          local.get 0
          local.get 2
          i32.load
          i32.store offset=32
          i32.const 3103
          local.get 0
          i32.const 32
          i32.add
          call $kprintf
          drop
          br 1 (;@2;)
        end
        i32.const 0
        call $process_find
        local.tee 2
        br_if 0 (;@2;)
        i32.const 2801
        i32.const 0
        call $kprintf
        drop
        br 1 (;@1;)
      end
      local.get 1
      local.get 2
      i32.eq
      br_if 0 (;@1;)
      local.get 1
      i32.load
      local.set 3
      local.get 0
      local.get 2
      i32.load
      i32.store offset=20
      local.get 0
      local.get 3
      i32.store offset=16
      i32.const 3666
      local.get 0
      i32.const 16
      i32.add
      call $kprintf
      drop
      block  ;; label = @2
        local.get 1
        i32.load offset=40
        i32.const 3
        i32.ne
        br_if 0 (;@2;)
        local.get 1
        i64.const 0
        i64.store offset=104
        local.get 1
        i32.const 2
        i32.store offset=40
        block  ;; label = @3
          block  ;; label = @4
            i32.const 0
            i32.load offset=33569104
            br_if 0 (;@4;)
            i32.const 0
            local.get 1
            i32.store offset=33569104
            br 1 (;@3;)
          end
          i32.const 0
          i32.load offset=33569108
          local.tee 3
          local.get 1
          i32.store offset=104
          local.get 1
          local.get 3
          i32.store offset=108
        end
        i32.const 0
        local.get 1
        i32.store offset=33569108
        local.get 0
        local.get 1
        i32.load
        i32.store
        i32.const 3058
        local.get 0
        call $kprintf
        drop
      end
      i32.const 33561920
      local.get 2
      i32.store offset=7168
      local.get 2
      i32.const 3
      i32.store offset=40
    end
    local.get 0
    i32.const 64
    i32.add
    global.set $__stack_pointer)
  (func $spawn_simple (type 6) (param i32 i32) (result i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    i32.const 0
    i32.store offset=12
    local.get 2
    local.get 0
    i32.store offset=8
    local.get 0
    local.get 1
    i32.const 1
    local.get 2
    i32.const 8
    i32.add
    call $process_create
    local.set 0
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get 0)
  (func $ipc_init (type 0) (result i32)
    (local i32)
    i32.const 4042
    i32.const 0
    call $kprintf
    drop
    i32.const -1024
    local.set 0
    loop  ;; label = @1
      local.get 0
      i32.const 33570204
      i32.add
      i64.const 68719476736
      i64.store align=4
      local.get 0
      i32.const 33570196
      i32.add
      i64.const 0
      i64.store align=4
      local.get 0
      i32.const 33570188
      i32.add
      i64.const 68719476736
      i64.store align=4
      local.get 0
      i32.const 33570180
      i32.add
      i64.const 0
      i64.store align=4
      local.get 0
      i32.const 33570172
      i32.add
      i64.const 68719476736
      i64.store align=4
      local.get 0
      i32.const 33570164
      i32.add
      i64.const 0
      i64.store align=4
      local.get 0
      i32.const 33570156
      i32.add
      i64.const 68719476736
      i64.store align=4
      local.get 0
      i32.const 33570148
      i32.add
      i64.const 0
      i64.store align=4
      local.get 0
      i32.const 64
      i32.add
      local.tee 0
      br_if 0 (;@1;)
    end
    i32.const 0
    i32.const 1
    i32.store8 offset=33570148
    i32.const 3365
    i32.const 0
    call $kprintf
    drop
    i32.const 0)
  (table (;0;) 3 3 funcref)
  (global $__stack_pointer (mut i32) (i32.const 34618736))
  (global $__tls_base (mut i32) (i32.const 0))
  (export "_start" (func $_start))
  (export "handle_command" (func $handle_command))
  (start $__wasm_init_memory)
  (elem (;0;) (i32.const 1) func $console_init $test_process_entry)
  (data $.rodata "0123456789abcdefghijklmnopqrstuvwxyz\00  echo    - Echo arguments to stdout\00about\00exit\00cat\00test_process\00  spawn   - Spawn a test process\00spawn: failed to create process\00ps\00ls\00  ps      - List running processes\00bin  dev  etc  home  proc  tmp  usr  var\00clear\00help\00echo\00spawn\00  about   - Show system information\00/proc/version\00This is a minimal UNIX-like operating system\00kill\00kill: cannot kill current shell\00  exit    - Exit the shell\00  clear   - Clear the terminal\00root:x:0:0:root:/root:/bin/sh\00user:x:1000:1000:user:/home/user:/bin/sh\00[INIT] Kernel initialization complete\00console\00  help    - Show this help message\00/etc/passwd\00cat: missing file operand\00[INIT] Memory management initialized\00[INIT] Process management initialized\00[INIT] Device drivers initialized\00[INIT] Scheduler initialized\00[INIT] Filesystem initialized\00[INIT] IPC initialized\00[DEBUG] kernel_main() started\00Memory: 128MB shared\00WebVM - POSIX-compatible WebAssembly OS\00  POSIX-compatible WebAssembly OS\00\1b[2J\1b[H\00kill: usage: kill <pid>\00=====================================\00WebVM Shell - Available commands:\00Architecture: wasm32\00  WebVM Kernel v0.1.0\00WebVM version 0.1.0\00Version: 0.1.0\00Type 'help' for available commands.\00running entirely in your web browser.\00[KERNEL] Entering main loop...\00[INIT] Starting kernel initialization...\00[KERNEL] Starting shell...\00(null)\00  cat     - Display file contents (stub)\00  ls      - List files (stub)\00  kill    - Terminate a process (kill <pid>)\00Welcome to WebVM Shell!\00Goodbye!\00UNKNOWN \00WAITING \00RUNNING \00$ \00ZOMBIE  \00READY   \00INIT    \00TERM    \00cat: %s: No such file or directory\0a\00[FS] Failed to mount /dev\0a\00[INIT] Failed to initialize memory management\0a\00[INIT] Failed to initialize process management\0a\00[PROCESS] Cannot kill kernel process\0a\00[INIT] Failed to initialize drivers\0a\00[SCHEDULER] No runnable processes\0a\00kill: invalid pid: %s\0a\00[PROCESS] Created process %d: %s\0a\00%-3d  %-4d  %s  %s\0a\00[DRIVER] Failed to initialize driver\0a\00[FS] Failed to mount root filesystem\0a\00[INIT] Failed to initialize filesystem\0a\00[TEST] Test process exiting\0a\00[SCHEDULER] Added process %d to ready queue\0a\00[SCHEDULER] Removed process %d from ready queue\0a\00[PROCESS] No free process slots available\0a\00sh: %s: command not found\0a\00[PROCESS] Process %d not found\0a\00[PROCESS] Process management initialized\0a\00[DRIVER] All drivers initialized\0a\00[SCHEDULER] Scheduler initialized\0a\00[IPC] IPC subsystem initialized\0a\00[PROCESS] Process %d already terminated\0a\00Process %d terminated\0a\00[TEST] Test process running... count=%d\0a\00[PROCESS] Failed to allocate stack for process %d\0a\00kill: failed to kill process %d\0a\00[PROCESS] Killing process %d with signal %d\0a\00Spawned test process with PID %d\0a\00[SCHEDULER] Context switch: %d -> %d\0a\00Total processes: %d\0a\00[FS] Failed to mount /proc\0a\00[SCHEDULER] Process %d yielding CPU\0a\00PID  PPID  STATE      NAME\0a\00[INIT] Failed to initialize IPC\0a\00[PROCESS] Process table dump:\0a\00[KERNEL] Initialization failed, halting.\0a\00[PROCESS] Initializing process management...\0a\00[DRIVER] Initializing driver...\0a\00[SCHEDULER] Initializing scheduler...\0a\00[IPC] Initializing IPC subsystem...\0a\00---  ----  ---------  ----------------\0a\00[TEST] Test process started (pid=%d)\0a\00\00\00\00\00\00\00\00\ff\ff\ff\ffkernel\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\01\00\00\00\00\00\00\00shell\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00"))
