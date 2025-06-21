(module $kernel.wasm
  (type (;0;) (func (result i32)))
  (type (;1;) (func (param i32 i32 i32) (result i32)))
  (type (;2;) (func (param i32 i32 i32 i32 i32) (result i32)))
  (type (;3;) (func (param i32 i32 i32 i32) (result i32)))
  (type (;4;) (func (param i32 i32) (result i32)))
  (type (;5;) (func (param i32)))
  (type (;6;) (func (param i32 i64 i32) (result i32)))
  (type (;7;) (func))
  (type (;8;) (func (param i32) (result i32)))
  (type (;9;) (func (result i64)))
  (import "env" "memory" (memory (;0;) 530 2048 shared))
  (import "wasi_snapshot_preview1" "file_create" (func $__wasi_file_create (type 1)))
  (import "wasi_snapshot_preview1" "file_read_direct" (func $__wasi_file_read_direct (type 2)))
  (import "wasi_snapshot_preview1" "file_write" (func $__wasi_file_write (type 3)))
  (import "wasi_snapshot_preview1" "file_close_direct" (func $__wasi_file_close_direct (type 4)))
  (import "wasi_snapshot_preview1" "path_create_directory" (func $__wasi_path_create_directory (type 3)))
  (import "wasi_snapshot_preview1" "path_remove_directory" (func $__wasi_path_remove_directory (type 1)))
  (import "wasi_snapshot_preview1" "file_delete" (func $__wasi_file_delete (type 4)))
  (import "wasi_snapshot_preview1" "directory_exists" (func $__wasi_directory_exists (type 1)))
  (import "wasi_snapshot_preview1" "file_exists" (func $__wasi_file_exists (type 1)))
  (import "wasi_snapshot_preview1" "file_get_size" (func $__wasi_file_get_size (type 1)))
  (import "wasi_snapshot_preview1" "list_directory" (func $__wasi_list_directory (type 2)))
  (import "wasi_snapshot_preview1" "fd_write" (func $__wasi_fd_write (type 3)))
  (import "wasi_snapshot_preview1" "proc_exit" (func $__wasi_proc_exit (type 5)))
  (import "wasi_snapshot_preview1" "clock_time_get" (func $__wasi_clock_time_get (type 6)))
  (func $__wasm_init_memory (type 7)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 33643592
          i32.const 0
          i32.const 1
          i32.atomic.rmw.cmpxchg
          br_table 0 (;@3;) 1 (;@2;) 2 (;@1;)
        end
        i32.const 1024
        i32.const 0
        i32.const 4552
        memory.init $.rodata
        i32.const 5584
        i32.const 0
        i32.const 260
        memory.init $.data
        i32.const 5856
        i32.const 0
        i32.const 33637736
        memory.fill
        i32.const 33643592
        i32.const 2
        i32.atomic.store
        i32.const 33643592
        i32.const -1
        memory.atomic.notify
        drop
        br 1 (;@1;)
      end
      i32.const 33643592
      i32.const 1
      i64.const -1
      memory.atomic.wait32
      drop
    end
    data.drop $.rodata
    data.drop $.data)
  (func $kernel_main (type 7)
    (local i32)
    i32.const 2390
    call $kputs
    drop
    i32.const 2550
    call $kputs
    drop
    i32.const 2643
    call $kputs
    drop
    i32.const 2484
    call $kputs
    drop
    i32.const 2550
    call $kputs
    drop
    i32.const 5351
    call $kputs
    drop
    i32.const 2807
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
            i32.const 3407
            local.set 0
            br 1 (;@3;)
          end
          i32.const 2199
          call $kputs
          drop
          block  ;; label = @4
            call $fs_init
            i32.const 0
            i32.ge_s
            br_if 0 (;@4;)
            i32.const 3989
            local.set 0
            br 1 (;@3;)
          end
          i32.const 2337
          call $kputs
          drop
          block  ;; label = @4
            call $drivers_init
            i32.const 0
            i32.ge_s
            br_if 0 (;@4;)
            i32.const 3540
            local.set 0
            br 1 (;@3;)
          end
          i32.const 2274
          call $kputs
          drop
          block  ;; label = @4
            call $process_init
            i32.const 0
            i32.ge_s
            br_if 0 (;@4;)
            i32.const 3454
            local.set 0
            br 1 (;@3;)
          end
          i32.const 2236
          call $kputs
          drop
          call $scheduler_init
          i32.const 2308
          call $kputs
          drop
          call $ipc_init
          i32.const 0
          i32.ge_s
          br_if 1 (;@2;)
          i32.const 4818
          local.set 0
        end
        i32.const 2
        local.get 0
        i32.const 0
        call $kfprintf
        drop
        i32.const 2
        i32.const 4882
        i32.const 0
        call $kfprintf
        drop
        i32.const 1
        call $wasi_exit
        br 1 (;@1;)
      end
      i32.const 2367
      call $kputs
      drop
      i32.const 1800
      call $kputs
      drop
    end
    i32.const 2776
    call $kputs
    drop
    i32.const 2848
    call $kputs
    drop
    call $shell_main)
  (func $_start (type 7)
    call $kernel_main)
  (func $mm_init (type 0) (result i32)
    i32.const 0
    i64.const 0
    i64.store offset=5864
    i32.const 0
    i64.const 4328521712
    i64.store offset=5856
    i32.const 0
    i32.const 5856
    i32.store offset=33560288
    i32.const 0
    i32.const 16
    i32.store offset=33560292
    i32.const 0)
  (func $kmalloc (type 8) (param i32) (result i32)
    (local i32 i32 i32 i32)
    block  ;; label = @1
      i32.const 0
      i32.load offset=33560288
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
          i32.load offset=33560292
          local.get 0
          i32.add
          i32.store offset=33560292
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
  (func $kfree (type 5) (param i32)
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
      i32.load offset=33560292
      local.get 0
      i32.const -16
      i32.add
      local.tee 1
      i32.load
      local.tee 2
      i32.sub
      i32.store offset=33560292
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
    i32.const -70656
    local.set 0
    loop  ;; label = @1
      local.get 0
      i32.const 33630960
      i32.add
      i64.const 0
      i64.store
      local.get 0
      i32.const 8
      i32.add
      local.tee 0
      br_if 0 (;@1;)
    end
    i32.const 0
    i32.const 28265
    i32.store16 offset=33560316
    i32.const 0
    i64.const 7238537148778243119
    i64.store offset=33560308 align=4
    i32.const 0
    i32.const 1
    i32.store offset=33560304
    i32.const -246
    local.set 0
    loop  ;; label = @1
      local.get 0
      i32.const 33560568
      i32.add
      i32.const 0
      i32.store16
      local.get 0
      i32.const 33560564
      i32.add
      i32.const 0
      i32.store align=2
      local.get 0
      i32.const 6
      i32.add
      local.tee 0
      br_if 0 (;@1;)
    end
    i32.const 0
    i32.const 116
    i32.store8 offset=33560594
    i32.const 0
    i32.const 30063
    i32.store16 offset=33560592
    i32.const 0
    i64.const 7238537148778243119
    i64.store offset=33560584
    i32.const 0
    i32.const 1
    i32.store offset=33560580
    i32.const -245
    local.set 0
    loop  ;; label = @1
      local.get 0
      i32.const 33560846
      i32.add
      i32.const 0
      i32.store8
      local.get 0
      i32.const 33560844
      i32.add
      i32.const 0
      i32.store16 align=1
      local.get 0
      i32.const 33560840
      i32.add
      i32.const 0
      i32.store align=1
      local.get 0
      i32.const 7
      i32.add
      local.tee 0
      br_if 0 (;@1;)
    end
    i32.const 0
    i32.const 114
    i32.store8 offset=33560870
    i32.const 0
    i32.const 29285
    i32.store16 offset=33560868
    i32.const 0
    i64.const 7238537148778243119
    i64.store offset=33560860 align=4
    i32.const 0
    i32.const 1
    i32.store offset=33560856
    i32.const -245
    local.set 0
    loop  ;; label = @1
      local.get 0
      i32.const 33561122
      i32.add
      i32.const 0
      i32.store8
      local.get 0
      i32.const 33561120
      i32.add
      i32.const 0
      i32.store16 align=1
      local.get 0
      i32.const 33561116
      i32.add
      i32.const 0
      i32.store align=1
      local.get 0
      i32.const 7
      i32.add
      local.tee 0
      br_if 0 (;@1;)
    end
    block  ;; label = @1
      block  ;; label = @2
        i32.const 0
        i32.load offset=33633616
        local.tee 1
        i32.const 9
        i32.gt_s
        br_if 0 (;@2;)
        i32.const 0
        local.get 1
        i32.const 1
        i32.add
        local.tee 2
        i32.store offset=33633616
        local.get 1
        i32.const 264
        i32.mul
        i32.const 33630976
        i32.add
        local.tee 3
        i32.const 47
        i32.store8
        i32.const 0
        local.set 0
        loop  ;; label = @3
          local.get 3
          local.get 0
          i32.add
          i32.const 1
          i32.add
          i32.const 0
          i32.store16 align=1
          local.get 0
          i32.const 2
          i32.add
          local.tee 0
          i32.const 254
          i32.ne
          br_if 0 (;@3;)
        end
        local.get 3
        i32.const 1
        i32.store offset=256
        local.get 3
        i32.const 0
        i32.store8 offset=255
        i32.const 0
        i32.load offset=33633620
        local.set 0
        i32.const 0
        local.get 3
        i32.store offset=33633620
        local.get 3
        local.get 0
        i32.store offset=260
        block  ;; label = @3
          block  ;; label = @4
            local.get 1
            i32.const 9
            i32.eq
            br_if 0 (;@4;)
            i32.const 0
            local.get 1
            i32.const 2
            i32.add
            local.tee 4
            i32.store offset=33633616
            local.get 2
            i32.const 264
            i32.mul
            i32.const 33630976
            i32.add
            local.tee 5
            i32.const 1986356271
            i32.store
            local.get 1
            i32.const 264
            i32.mul
            i32.const 33630976
            i32.add
            local.set 6
            i32.const -248
            local.set 0
            loop  ;; label = @5
              local.get 6
              local.get 0
              i32.add
              local.tee 2
              i32.const 518
              i32.add
              i32.const 0
              i32.store8
              local.get 2
              i32.const 516
              i32.add
              i32.const 0
              i32.store16
              local.get 0
              i32.eqz
              br_if 2 (;@3;)
              local.get 2
              i32.const 523
              i32.add
              i32.const 0
              i32.store8
              local.get 2
              i32.const 519
              i32.add
              i32.const 0
              i32.store align=1
              local.get 0
              i32.const 8
              i32.add
              local.set 0
              br 0 (;@5;)
            end
          end
          i32.const 2
          i32.const 3380
          i32.const 0
          call $kfprintf
          drop
          i32.const -1
          return
        end
        local.get 5
        local.get 3
        i32.store offset=260
        local.get 5
        i32.const 2
        i32.store offset=256
        local.get 5
        i32.const 0
        i32.store8 offset=255
        i32.const 0
        local.get 5
        i32.store offset=33633620
        local.get 1
        i32.const 7
        i32.gt_s
        br_if 1 (;@1;)
        i32.const 0
        local.get 1
        i32.const 3
        i32.add
        i32.store offset=33633616
        local.get 4
        i32.const 264
        i32.mul
        local.tee 0
        i32.const 33630980
        i32.add
        i32.const 99
        i32.store8
        local.get 0
        i32.const 33630976
        i32.add
        local.tee 6
        i32.const 1869770799
        i32.store
        local.get 1
        i32.const 264
        i32.mul
        i32.const 33630976
        i32.add
        local.set 3
        i32.const -250
        local.set 0
        loop  ;; label = @3
          local.get 3
          local.get 0
          i32.add
          local.tee 2
          i32.const 787
          i32.add
          i32.const 0
          i32.store8
          local.get 2
          i32.const 783
          i32.add
          i32.const 0
          i32.store align=1
          local.get 0
          i32.const 5
          i32.add
          local.tee 0
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
        i32.store offset=33633620
        i32.const 0
        i32.const 1
        i32.store8 offset=33630960
        i32.const 0
        return
      end
      i32.const 2
      i32.const 3951
      i32.const 0
      call $kfprintf
      drop
      i32.const -1
      return
    end
    i32.const 2
    i32.const 4725
    i32.const 0
    call $kfprintf
    drop
    i32.const -1)
  (func $fs_open (type 1) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 288
    i32.sub
    local.tee 3
    global.set $__stack_pointer
    block  ;; label = @1
      block  ;; label = @2
        i32.const 0
        i32.load8_u offset=33630960
        br_if 0 (;@2;)
        i32.const -1
        local.set 0
        br 1 (;@1;)
      end
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.load8_u
          i32.const 47
          i32.eq
          br_if 0 (;@3;)
          i32.const -257
          local.set 4
          loop  ;; label = @4
            local.get 4
            i32.const 5841
            i32.add
            local.set 5
            local.get 4
            i32.const 1
            i32.add
            local.tee 6
            local.set 4
            local.get 5
            i32.load8_u
            br_if 0 (;@4;)
          end
          i32.const 0
          local.set 4
          loop  ;; label = @4
            local.get 0
            local.get 4
            i32.add
            local.set 5
            local.get 4
            i32.const 1
            i32.add
            local.tee 7
            local.set 4
            local.get 5
            i32.load8_u
            br_if 0 (;@4;)
          end
          block  ;; label = @4
            local.get 6
            local.get 7
            i32.add
            i32.const -257
            i32.ge_u
            br_if 0 (;@4;)
            i32.const -1
            local.set 0
            br 3 (;@1;)
          end
          i32.const 0
          local.set 4
          loop  ;; label = @4
            local.get 3
            local.get 4
            i32.add
            local.get 4
            i32.const 5584
            i32.add
            i32.load8_u
            local.tee 5
            i32.store8
            local.get 4
            i32.const 1
            i32.add
            local.set 4
            local.get 5
            br_if 0 (;@4;)
          end
          i32.const 0
          local.set 4
          block  ;; label = @4
            block  ;; label = @5
              i32.const 0
              i32.load8_u offset=5584
              local.tee 5
              br_if 0 (;@5;)
              i32.const 2700
              local.set 6
              br 1 (;@4;)
            end
            i32.const 0
            local.set 4
            block  ;; label = @5
              block  ;; label = @6
                loop  ;; label = @7
                  local.get 5
                  i32.const 255
                  i32.and
                  local.get 4
                  i32.const 2700
                  i32.add
                  i32.load8_u
                  i32.ne
                  br_if 1 (;@6;)
                  local.get 4
                  i32.const 5585
                  i32.add
                  local.set 5
                  local.get 4
                  i32.const 1
                  i32.add
                  local.tee 6
                  local.set 4
                  local.get 5
                  i32.load8_u
                  local.tee 5
                  br_if 0 (;@7;)
                end
                local.get 6
                i32.const 2700
                i32.add
                local.set 6
                i32.const 0
                local.set 5
                br 1 (;@5;)
              end
              local.get 4
              i32.const 2700
              i32.add
              local.set 6
            end
            local.get 5
            i32.const 255
            i32.and
            local.set 4
          end
          block  ;; label = @4
            local.get 4
            local.get 6
            i32.load8_u
            i32.eq
            br_if 0 (;@4;)
            local.get 3
            i32.const -1
            i32.add
            local.set 4
            loop  ;; label = @5
              local.get 4
              i32.const 1
              i32.add
              local.tee 4
              i32.load8_u
              br_if 0 (;@5;)
            end
            local.get 4
            i32.const 47
            i32.store16 align=1
          end
          local.get 3
          i32.const -1
          i32.add
          local.set 5
          loop  ;; label = @4
            local.get 5
            i32.const 1
            i32.add
            local.tee 5
            i32.load8_u
            br_if 0 (;@4;)
          end
          i32.const 0
          local.set 4
          loop  ;; label = @4
            local.get 5
            local.get 4
            i32.add
            local.get 0
            local.get 4
            i32.add
            i32.load8_u
            local.tee 6
            i32.store8
            local.get 4
            i32.const 1
            i32.add
            local.set 4
            local.get 6
            br_if 0 (;@4;)
            br 2 (;@2;)
          end
        end
        i32.const 0
        local.set 4
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              loop  ;; label = @6
                local.get 0
                local.get 4
                i32.add
                local.tee 5
                i32.load8_u
                local.tee 7
                i32.eqz
                br_if 2 (;@4;)
                local.get 3
                local.get 4
                i32.add
                local.tee 6
                local.get 7
                i32.store8
                block  ;; label = @7
                  local.get 5
                  i32.const 1
                  i32.add
                  i32.load8_u
                  local.tee 7
                  i32.eqz
                  br_if 0 (;@7;)
                  local.get 6
                  i32.const 1
                  i32.add
                  local.get 7
                  i32.store8
                  local.get 5
                  i32.const 2
                  i32.add
                  i32.load8_u
                  local.tee 5
                  i32.eqz
                  br_if 2 (;@5;)
                  local.get 6
                  i32.const 2
                  i32.add
                  local.get 5
                  i32.store8
                  local.get 4
                  i32.const 3
                  i32.add
                  local.tee 4
                  i32.const 255
                  i32.ne
                  br_if 1 (;@6;)
                  br 4 (;@3;)
                end
              end
              local.get 4
              i32.const 1
              i32.add
              local.set 4
              br 1 (;@4;)
            end
            local.get 4
            i32.const 2
            i32.add
            local.set 4
          end
          local.get 4
          i32.const 254
          i32.gt_u
          br_if 0 (;@3;)
          local.get 4
          local.set 5
          block  ;; label = @4
            local.get 4
            i32.const 7
            i32.and
            local.tee 0
            i32.const 7
            i32.eq
            br_if 0 (;@4;)
            local.get 3
            local.get 4
            i32.add
            local.set 6
            i32.const 0
            local.set 5
            loop  ;; label = @5
              local.get 6
              local.get 5
              i32.add
              i32.const 0
              i32.store8
              local.get 0
              local.get 5
              i32.const 1
              i32.add
              local.tee 5
              i32.xor
              i32.const 7
              i32.ne
              br_if 0 (;@5;)
            end
            local.get 4
            local.get 5
            i32.add
            local.set 5
          end
          local.get 4
          i32.const 247
          i32.gt_u
          br_if 0 (;@3;)
          local.get 3
          local.set 4
          i32.const 255
          local.set 0
          loop  ;; label = @4
            local.get 4
            local.get 5
            i32.add
            i64.const 0
            i64.store align=1
            local.get 4
            i32.const 8
            i32.add
            local.set 4
            local.get 5
            local.get 0
            i32.const -8
            i32.add
            local.tee 0
            i32.ne
            br_if 0 (;@4;)
          end
        end
        local.get 3
        i32.const 0
        i32.store8 offset=255
      end
      block  ;; label = @2
        block  ;; label = @3
          local.get 1
          i32.const 64
          i32.and
          local.tee 8
          br_if 0 (;@3;)
          i32.const -1
          local.set 0
          local.get 3
          local.get 3
          i32.const 256
          i32.add
          call $fs_stat
          i32.const -1
          i32.le_s
          br_if 2 (;@1;)
          local.get 3
          i32.load offset=264
          i32.eqz
          br_if 0 (;@3;)
          i32.const 6
          i32.const 2
          i32.const 4
          local.get 1
          i32.const 1
          i32.and
          select
          local.get 1
          i32.const 2
          i32.and
          select
          local.set 4
          local.get 3
          i32.load offset=260
          local.set 5
          block  ;; label = @4
            local.get 3
            i32.load offset=268
            br_if 0 (;@4;)
            local.get 5
            i32.const 3
            i32.shr_u
            local.get 4
            i32.and
            local.get 4
            i32.eq
            br_if 1 (;@3;)
          end
          i32.const -1
          local.set 0
          local.get 5
          local.get 4
          i32.and
          local.get 4
          i32.ne
          br_if 2 (;@1;)
          i32.const 0
          i32.load offset=5840
          local.tee 9
          i32.const 256
          i32.ge_s
          br_if 2 (;@1;)
          br 1 (;@2;)
        end
        i32.const 0
        i32.load offset=5840
        local.tee 9
        i32.const 255
        i32.le_s
        br_if 0 (;@2;)
        i32.const -1
        local.set 0
        br 1 (;@1;)
      end
      local.get 9
      i32.const 276
      i32.mul
      i32.const 33560304
      i32.add
      local.set 4
      local.get 9
      local.set 5
      block  ;; label = @2
        loop  ;; label = @3
          local.get 4
          i32.load
          i32.eqz
          br_if 1 (;@2;)
          local.get 4
          i32.const 276
          i32.add
          local.set 4
          local.get 5
          i32.const 1
          i32.add
          local.tee 5
          i32.const 256
          i32.ne
          br_if 0 (;@3;)
        end
        i32.const -1
        local.set 0
        br 1 (;@1;)
      end
      local.get 4
      i32.const 1
      i32.store
      i32.const 0
      local.set 0
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            loop  ;; label = @5
              local.get 3
              local.get 0
              i32.add
              local.tee 6
              i32.load8_u
              local.tee 10
              i32.eqz
              br_if 2 (;@3;)
              local.get 4
              local.get 0
              i32.add
              local.tee 7
              i32.const 4
              i32.add
              local.get 10
              i32.store8
              block  ;; label = @6
                local.get 6
                i32.const 1
                i32.add
                i32.load8_u
                local.tee 10
                i32.eqz
                br_if 0 (;@6;)
                local.get 7
                i32.const 5
                i32.add
                local.get 10
                i32.store8
                local.get 6
                i32.const 2
                i32.add
                i32.load8_u
                local.tee 6
                i32.eqz
                br_if 2 (;@4;)
                local.get 7
                i32.const 6
                i32.add
                local.get 6
                i32.store8
                local.get 0
                i32.const 3
                i32.add
                local.tee 0
                i32.const 255
                i32.ne
                br_if 1 (;@5;)
                br 4 (;@2;)
              end
            end
            local.get 0
            i32.const 1
            i32.add
            local.set 0
            br 1 (;@3;)
          end
          local.get 0
          i32.const 2
          i32.add
          local.set 0
        end
        local.get 0
        i32.const 254
        i32.gt_u
        br_if 0 (;@2;)
        local.get 0
        local.set 10
        block  ;; label = @3
          local.get 0
          i32.const 7
          i32.and
          local.tee 7
          i32.const 7
          i32.eq
          br_if 0 (;@3;)
          local.get 4
          local.get 0
          i32.add
          local.set 10
          i32.const 0
          local.set 6
          loop  ;; label = @4
            local.get 10
            local.get 6
            i32.add
            i32.const 4
            i32.add
            i32.const 0
            i32.store8
            local.get 7
            local.get 6
            i32.const 1
            i32.add
            local.tee 6
            i32.xor
            i32.const 7
            i32.ne
            br_if 0 (;@4;)
          end
          local.get 0
          local.get 6
          i32.add
          local.set 10
        end
        local.get 0
        i32.const 247
        i32.gt_u
        br_if 0 (;@2;)
        local.get 10
        i32.const -255
        i32.add
        local.set 6
        local.get 4
        local.get 10
        i32.add
        local.set 0
        loop  ;; label = @3
          local.get 0
          i32.const 4
          i32.add
          i64.const 0
          i64.store align=1
          local.get 0
          i32.const 8
          i32.add
          local.set 0
          local.get 6
          i32.const 8
          i32.add
          local.tee 6
          br_if 0 (;@3;)
        end
      end
      i32.const 0
      local.set 0
      local.get 4
      i32.const 272
      i32.add
      i32.const 0
      i32.store
      local.get 4
      i32.const 264
      i32.add
      i64.const 0
      i64.store align=4
      local.get 4
      i32.const 260
      i32.add
      local.get 1
      i32.store
      local.get 4
      i32.const 259
      i32.add
      i32.const 0
      i32.store8
      block  ;; label = @2
        block  ;; label = @3
          local.get 8
          i32.eqz
          br_if 0 (;@3;)
          loop  ;; label = @4
            local.get 3
            local.get 0
            i32.add
            local.set 6
            local.get 0
            i32.const 1
            i32.add
            local.tee 7
            local.set 0
            local.get 6
            i32.load8_u
            br_if 0 (;@4;)
          end
          i32.const -1
          local.set 0
          local.get 3
          local.get 7
          i32.const -1
          i32.add
          local.get 2
          call $__wasi_file_create
          br_if 1 (;@2;)
          i32.const 0
          i32.const 0
          i32.store8 offset=33633632
          i32.const 0
          i32.load offset=5840
          local.set 9
        end
        local.get 4
        i32.const 268
        i32.add
        i64.const 0
        i64.store align=4
        block  ;; label = @3
          local.get 5
          local.get 9
          i32.lt_s
          br_if 0 (;@3;)
          i32.const 0
          local.get 5
          i32.const 1
          i32.add
          i32.store offset=5840
        end
        local.get 5
        local.set 0
        br 1 (;@1;)
      end
      local.get 4
      i32.const 0
      i32.store
    end
    local.get 3
    i32.const 288
    i32.add
    global.set $__stack_pointer
    local.get 0)
  (func $fs_stat (type 4) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 272
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    i32.const -1
    local.set 3
    block  ;; label = @1
      local.get 1
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.load8_u
          i32.const 47
          i32.eq
          br_if 0 (;@3;)
          i32.const -257
          local.set 4
          loop  ;; label = @4
            local.get 4
            i32.const 5841
            i32.add
            local.set 5
            local.get 4
            i32.const 1
            i32.add
            local.tee 6
            local.set 4
            local.get 5
            i32.load8_u
            br_if 0 (;@4;)
          end
          i32.const 0
          local.set 4
          loop  ;; label = @4
            local.get 0
            local.get 4
            i32.add
            local.set 5
            local.get 4
            i32.const 1
            i32.add
            local.tee 7
            local.set 4
            local.get 5
            i32.load8_u
            br_if 0 (;@4;)
          end
          local.get 6
          local.get 7
          i32.add
          i32.const -257
          i32.lt_u
          br_if 2 (;@1;)
          i32.const 0
          local.set 4
          loop  ;; label = @4
            local.get 2
            i32.const 16
            i32.add
            local.get 4
            i32.add
            local.get 4
            i32.const 5584
            i32.add
            i32.load8_u
            local.tee 5
            i32.store8
            local.get 4
            i32.const 1
            i32.add
            local.set 4
            local.get 5
            br_if 0 (;@4;)
          end
          i32.const 0
          local.set 4
          block  ;; label = @4
            block  ;; label = @5
              i32.const 0
              i32.load8_u offset=5584
              local.tee 5
              br_if 0 (;@5;)
              i32.const 2700
              local.set 6
              br 1 (;@4;)
            end
            i32.const 0
            local.set 4
            block  ;; label = @5
              block  ;; label = @6
                loop  ;; label = @7
                  local.get 5
                  i32.const 255
                  i32.and
                  local.get 4
                  i32.const 2700
                  i32.add
                  i32.load8_u
                  i32.ne
                  br_if 1 (;@6;)
                  local.get 4
                  i32.const 5585
                  i32.add
                  local.set 5
                  local.get 4
                  i32.const 1
                  i32.add
                  local.tee 6
                  local.set 4
                  local.get 5
                  i32.load8_u
                  local.tee 5
                  br_if 0 (;@7;)
                end
                local.get 6
                i32.const 2700
                i32.add
                local.set 6
                i32.const 0
                local.set 5
                br 1 (;@5;)
              end
              local.get 4
              i32.const 2700
              i32.add
              local.set 6
            end
            local.get 5
            i32.const 255
            i32.and
            local.set 4
          end
          block  ;; label = @4
            local.get 4
            local.get 6
            i32.load8_u
            i32.eq
            br_if 0 (;@4;)
            local.get 2
            i32.const 15
            i32.add
            local.set 4
            loop  ;; label = @5
              local.get 4
              i32.const 1
              i32.add
              local.tee 4
              i32.load8_u
              br_if 0 (;@5;)
            end
            local.get 4
            i32.const 47
            i32.store16 align=1
          end
          local.get 2
          i32.const 15
          i32.add
          local.set 5
          loop  ;; label = @4
            local.get 5
            i32.const 1
            i32.add
            local.tee 5
            i32.load8_u
            br_if 0 (;@4;)
          end
          i32.const 0
          local.set 4
          loop  ;; label = @4
            local.get 5
            local.get 4
            i32.add
            local.get 0
            local.get 4
            i32.add
            i32.load8_u
            local.tee 6
            i32.store8
            local.get 4
            i32.const 1
            i32.add
            local.set 4
            local.get 6
            br_if 0 (;@4;)
            br 2 (;@2;)
          end
        end
        i32.const 0
        local.set 4
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              loop  ;; label = @6
                local.get 0
                local.get 4
                i32.add
                local.tee 5
                i32.load8_u
                local.tee 7
                i32.eqz
                br_if 2 (;@4;)
                local.get 2
                i32.const 16
                i32.add
                local.get 4
                i32.add
                local.tee 6
                local.get 7
                i32.store8
                block  ;; label = @7
                  local.get 5
                  i32.const 1
                  i32.add
                  i32.load8_u
                  local.tee 7
                  i32.eqz
                  br_if 0 (;@7;)
                  local.get 6
                  i32.const 1
                  i32.add
                  local.get 7
                  i32.store8
                  local.get 5
                  i32.const 2
                  i32.add
                  i32.load8_u
                  local.tee 5
                  i32.eqz
                  br_if 2 (;@5;)
                  local.get 6
                  i32.const 2
                  i32.add
                  local.get 5
                  i32.store8
                  local.get 4
                  i32.const 3
                  i32.add
                  local.tee 4
                  i32.const 255
                  i32.ne
                  br_if 1 (;@6;)
                  br 4 (;@3;)
                end
              end
              local.get 4
              i32.const 1
              i32.add
              local.set 4
              br 1 (;@4;)
            end
            local.get 4
            i32.const 2
            i32.add
            local.set 4
          end
          local.get 4
          i32.const 254
          i32.gt_u
          br_if 0 (;@3;)
          local.get 4
          local.set 5
          block  ;; label = @4
            local.get 4
            i32.const 7
            i32.and
            local.tee 0
            i32.const 7
            i32.eq
            br_if 0 (;@4;)
            local.get 2
            i32.const 16
            i32.add
            local.get 4
            i32.add
            local.set 6
            i32.const 0
            local.set 5
            loop  ;; label = @5
              local.get 6
              local.get 5
              i32.add
              i32.const 0
              i32.store8
              local.get 0
              local.get 5
              i32.const 1
              i32.add
              local.tee 5
              i32.xor
              i32.const 7
              i32.ne
              br_if 0 (;@5;)
            end
            local.get 4
            local.get 5
            i32.add
            local.set 5
          end
          local.get 4
          i32.const 247
          i32.gt_u
          br_if 0 (;@3;)
          local.get 2
          i32.const 16
          i32.add
          local.set 4
          i32.const 255
          local.set 0
          loop  ;; label = @4
            local.get 4
            local.get 5
            i32.add
            i64.const 0
            i64.store align=1
            local.get 4
            i32.const 8
            i32.add
            local.set 4
            local.get 5
            local.get 0
            i32.const -8
            i32.add
            local.tee 0
            i32.ne
            br_if 0 (;@4;)
          end
        end
        local.get 2
        i32.const 0
        i32.store8 offset=271
      end
      local.get 1
      i64.const 0
      i64.store offset=24 align=4
      local.get 1
      i64.const 0
      i64.store offset=16 align=4
      local.get 1
      i64.const 0
      i64.store offset=8 align=4
      local.get 1
      i64.const 142541374619649
      i64.store align=4
      local.get 1
      i32.const 16
      i32.add
      local.set 3
      block  ;; label = @2
        block  ;; label = @3
          local.get 2
          i32.load8_u offset=16
          i32.const 47
          i32.ne
          br_if 0 (;@3;)
          local.get 2
          i32.load8_u offset=17
          i32.const 255
          i32.and
          i32.const 100
          i32.ne
          br_if 0 (;@3;)
          local.get 2
          i32.load8_u offset=18
          i32.const 255
          i32.and
          i32.const 101
          i32.ne
          br_if 0 (;@3;)
          local.get 2
          i32.load8_u offset=19
          i32.const 255
          i32.and
          i32.const 118
          i32.ne
          br_if 0 (;@3;)
          local.get 2
          i32.load8_u offset=20
          i32.const 255
          i32.and
          i32.const 47
          i32.ne
          br_if 0 (;@3;)
          local.get 1
          i32.const 8624
          i32.store offset=4
          br 1 (;@2;)
        end
        i32.const 0
        local.set 4
        local.get 2
        i32.const 0
        i32.store offset=12
        local.get 2
        i32.const 0
        i32.store offset=8
        loop  ;; label = @3
          local.get 2
          i32.const 16
          i32.add
          local.get 4
          i32.add
          local.set 5
          local.get 4
          i32.const 1
          i32.add
          local.tee 0
          local.set 4
          local.get 5
          i32.load8_u
          br_if 0 (;@3;)
        end
        i32.const 0
        local.set 4
        local.get 2
        i32.const 16
        i32.add
        local.get 0
        i32.const -1
        i32.add
        local.get 2
        i32.const 12
        i32.add
        call $__wasi_directory_exists
        local.set 6
        loop  ;; label = @3
          local.get 2
          i32.const 16
          i32.add
          local.get 4
          i32.add
          local.set 5
          local.get 4
          i32.const 1
          i32.add
          local.tee 0
          local.set 4
          local.get 5
          i32.load8_u
          br_if 0 (;@3;)
        end
        local.get 2
        i32.const 16
        i32.add
        local.get 0
        i32.const -1
        i32.add
        local.get 2
        i32.const 8
        i32.add
        call $__wasi_file_exists
        local.set 4
        block  ;; label = @3
          local.get 6
          br_if 0 (;@3;)
          local.get 2
          i32.load offset=12
          i32.eqz
          br_if 0 (;@3;)
          local.get 1
          i32.const 16877
          i32.store offset=4
          br 1 (;@2;)
        end
        block  ;; label = @3
          local.get 4
          br_if 0 (;@3;)
          local.get 2
          i32.load offset=8
          i32.eqz
          br_if 0 (;@3;)
          i32.const 0
          local.set 4
          loop  ;; label = @4
            local.get 2
            i32.const 16
            i32.add
            local.get 4
            i32.add
            local.set 5
            local.get 4
            i32.const 1
            i32.add
            local.tee 0
            local.set 4
            local.get 5
            i32.load8_u
            br_if 0 (;@4;)
          end
          local.get 2
          i32.const 16
          i32.add
          local.get 0
          i32.const -1
          i32.add
          local.get 3
          call $__wasi_file_get_size
          br_if 1 (;@2;)
          local.get 1
          i32.const 0
          i32.store offset=28
          local.get 1
          i64.const 0
          i64.store offset=20 align=4
          local.get 1
          i64.const 0
          i64.store offset=8 align=4
          local.get 1
          i64.const 142541374619649
          i64.store align=4
          br 1 (;@2;)
        end
        block  ;; label = @3
          block  ;; label = @4
            local.get 2
            i32.load8_u offset=16
            local.tee 5
            br_if 0 (;@4;)
            i32.const 0
            local.set 5
            i32.const 2700
            local.set 4
            br 1 (;@3;)
          end
          local.get 2
          i32.const 16
          i32.add
          i32.const 1
          i32.or
          local.set 0
          i32.const 2700
          local.set 4
          block  ;; label = @4
            loop  ;; label = @5
              local.get 5
              i32.const 255
              i32.and
              local.get 4
              i32.load8_u
              i32.ne
              br_if 1 (;@4;)
              local.get 4
              i32.const 1
              i32.add
              local.set 4
              local.get 0
              i32.load8_u
              local.set 5
              local.get 0
              i32.const 1
              i32.add
              local.set 0
              local.get 5
              br_if 0 (;@5;)
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
        local.get 4
        i32.load8_u
        i32.ne
        br_if 0 (;@2;)
        local.get 1
        i32.const 16877
        i32.store offset=4
      end
      i32.const 0
      local.set 6
      i32.const 33560309
      local.set 7
      block  ;; label = @2
        loop  ;; label = @3
          block  ;; label = @4
            local.get 6
            i32.const 276
            i32.mul
            i32.const 33560304
            i32.add
            local.tee 1
            i32.load
            i32.eqz
            br_if 0 (;@4;)
            block  ;; label = @5
              block  ;; label = @6
                local.get 1
                i32.load8_u offset=4
                local.tee 5
                br_if 0 (;@6;)
                i32.const 0
                local.set 5
                local.get 2
                i32.const 16
                i32.add
                local.set 4
                br 1 (;@5;)
              end
              local.get 2
              i32.const 16
              i32.add
              local.set 4
              local.get 7
              local.set 0
              block  ;; label = @6
                loop  ;; label = @7
                  local.get 5
                  i32.const 255
                  i32.and
                  local.get 4
                  i32.load8_u
                  i32.ne
                  br_if 1 (;@6;)
                  local.get 4
                  i32.const 1
                  i32.add
                  local.set 4
                  local.get 0
                  i32.load8_u
                  local.set 5
                  local.get 0
                  i32.const 1
                  i32.add
                  local.set 0
                  local.get 5
                  br_if 0 (;@7;)
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
            local.get 4
            i32.load8_u
            i32.ne
            br_if 0 (;@4;)
            local.get 3
            local.get 1
            i32.load offset=268
            i32.store
            br 2 (;@2;)
          end
          local.get 7
          i32.const 276
          i32.add
          local.set 7
          local.get 6
          i32.const 1
          i32.add
          local.tee 6
          i32.const 256
          i32.ne
          br_if 0 (;@3;)
        end
      end
      i32.const 0
      local.set 3
    end
    local.get 2
    i32.const 272
    i32.add
    global.set $__stack_pointer
    local.get 3)
  (func $fs_read (type 1) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 3
    global.set $__stack_pointer
    i32.const -1
    local.set 4
    block  ;; label = @1
      local.get 0
      i32.const 255
      i32.gt_u
      br_if 0 (;@1;)
      local.get 0
      i32.const 276
      i32.mul
      i32.const 33560304
      i32.add
      local.tee 5
      i32.load
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 5
        i32.load8_u offset=4
        i32.const 47
        i32.ne
        br_if 0 (;@2;)
        local.get 5
        i32.load8_u offset=5
        i32.const 100
        i32.ne
        br_if 0 (;@2;)
        local.get 5
        i32.load8_u offset=6
        i32.const 101
        i32.ne
        br_if 0 (;@2;)
        local.get 5
        i32.load8_u offset=7
        i32.const 118
        i32.ne
        br_if 0 (;@2;)
        i32.const 0
        local.set 4
        local.get 5
        i32.load8_u offset=8
        i32.const 47
        i32.eq
        br_if 1 (;@1;)
      end
      i32.const 4
      local.set 0
      local.get 5
      i32.const 4
      i32.add
      local.set 6
      local.get 3
      i32.const 0
      i32.store offset=12
      loop  ;; label = @2
        local.get 5
        local.get 0
        i32.add
        local.set 4
        local.get 0
        i32.const 1
        i32.add
        local.tee 7
        local.set 0
        local.get 4
        i32.load8_u
        br_if 0 (;@2;)
      end
      block  ;; label = @2
        local.get 6
        local.get 7
        i32.const -5
        i32.add
        local.get 1
        local.get 2
        local.get 3
        i32.const 12
        i32.add
        call $__wasi_file_read_direct
        i32.eqz
        br_if 0 (;@2;)
        i32.const -1
        local.set 4
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 3
        i32.load offset=12
        local.tee 4
        br_if 0 (;@2;)
        i32.const 0
        local.set 4
        br 1 (;@1;)
      end
      local.get 5
      local.get 5
      i32.load offset=264
      local.get 4
      i32.add
      i32.store offset=264
    end
    local.get 3
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get 4)
  (func $fs_write (type 1) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32)
    i32.const -1
    local.set 3
    block  ;; label = @1
      local.get 0
      i32.const 255
      i32.gt_u
      br_if 0 (;@1;)
      local.get 0
      i32.const 276
      i32.mul
      i32.const 33560304
      i32.add
      local.tee 4
      i32.load
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 4
        i32.load8_u offset=4
        i32.const 47
        i32.ne
        br_if 0 (;@2;)
        local.get 4
        i32.load8_u offset=5
        i32.const 100
        i32.ne
        br_if 0 (;@2;)
        local.get 4
        i32.load8_u offset=6
        i32.const 101
        i32.ne
        br_if 0 (;@2;)
        local.get 4
        i32.load8_u offset=7
        i32.const 118
        i32.ne
        br_if 0 (;@2;)
        local.get 4
        i32.load8_u offset=8
        i32.const 47
        i32.ne
        br_if 0 (;@2;)
        local.get 2
        return
      end
      block  ;; label = @2
        block  ;; label = @3
          local.get 4
          i32.load offset=272
          local.tee 5
          i32.eqz
          br_if 0 (;@3;)
          local.get 4
          i32.load offset=268
          local.set 6
          br 1 (;@2;)
        end
        local.get 4
        i32.const 4096
        call $kmalloc
        local.tee 5
        i32.store offset=272
        local.get 5
        i32.eqz
        br_if 1 (;@1;)
        i32.const 0
        local.set 6
        local.get 4
        i32.const 0
        i32.store offset=268
      end
      block  ;; label = @2
        i32.const 4096
        local.get 6
        i32.sub
        local.get 2
        local.get 6
        local.get 2
        i32.add
        local.tee 7
        i32.const 4096
        i32.gt_u
        select
        local.tee 3
        br_if 0 (;@2;)
        i32.const 0
        return
      end
      local.get 3
      i32.const 3
      i32.and
      local.set 8
      i32.const 0
      local.set 0
      block  ;; label = @2
        local.get 6
        local.get 7
        i32.const 4096
        local.get 7
        i32.const 4096
        i32.lt_u
        select
        local.tee 9
        i32.sub
        i32.const -4
        i32.gt_u
        br_if 0 (;@2;)
        local.get 5
        local.get 6
        i32.add
        local.set 10
        local.get 3
        i32.const -4
        i32.and
        local.set 11
        i32.const 0
        local.set 0
        loop  ;; label = @3
          local.get 10
          local.get 0
          i32.add
          local.tee 2
          local.get 1
          local.get 0
          i32.add
          local.tee 7
          i32.load8_u
          i32.store8
          local.get 2
          i32.const 1
          i32.add
          local.get 7
          i32.const 1
          i32.add
          i32.load8_u
          i32.store8
          local.get 2
          i32.const 2
          i32.add
          local.get 7
          i32.const 2
          i32.add
          i32.load8_u
          i32.store8
          local.get 2
          i32.const 3
          i32.add
          local.get 7
          i32.const 3
          i32.add
          i32.load8_u
          i32.store8
          local.get 11
          local.get 0
          i32.const 4
          i32.add
          local.tee 0
          i32.ne
          br_if 0 (;@3;)
        end
      end
      block  ;; label = @2
        local.get 8
        i32.eqz
        br_if 0 (;@2;)
        local.get 1
        local.get 0
        i32.add
        local.set 2
        local.get 5
        local.get 6
        local.get 0
        i32.add
        i32.add
        local.set 0
        loop  ;; label = @3
          local.get 0
          local.get 2
          i32.load8_u
          i32.store8
          local.get 2
          i32.const 1
          i32.add
          local.set 2
          local.get 0
          i32.const 1
          i32.add
          local.set 0
          local.get 8
          i32.const -1
          i32.add
          local.tee 8
          br_if 0 (;@3;)
        end
      end
      local.get 4
      local.get 9
      i32.store offset=268
      local.get 4
      local.get 4
      i32.load offset=264
      local.get 3
      i32.add
      i32.store offset=264
    end
    local.get 3)
  (func $fs_close (type 8) (param i32) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    i32.const -1
    local.set 1
    block  ;; label = @1
      local.get 0
      i32.const 255
      i32.gt_u
      br_if 0 (;@1;)
      local.get 0
      i32.const 276
      i32.mul
      i32.const 33560304
      i32.add
      local.tee 2
      i32.load
      i32.eqz
      br_if 0 (;@1;)
      i32.const 0
      local.set 1
      local.get 0
      i32.const 3
      i32.lt_u
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 2
        i32.load offset=272
        local.tee 3
        i32.eqz
        br_if 0 (;@2;)
        local.get 2
        i32.load offset=268
        local.tee 4
        i32.eqz
        br_if 0 (;@2;)
        i32.const 4
        local.set 0
        local.get 2
        i32.const 4
        i32.add
        local.set 5
        loop  ;; label = @3
          local.get 2
          local.get 0
          i32.add
          local.set 1
          local.get 0
          i32.const 1
          i32.add
          local.tee 6
          local.set 0
          local.get 1
          i32.load8_u
          br_if 0 (;@3;)
        end
        local.get 5
        local.get 6
        i32.const -5
        i32.add
        local.get 3
        local.get 4
        call $__wasi_file_write
        drop
        i32.const 0
        i32.const 0
        i32.store8 offset=33633632
      end
      i32.const 4
      local.set 0
      local.get 2
      i32.const 4
      i32.add
      local.set 3
      loop  ;; label = @2
        local.get 2
        local.get 0
        i32.add
        local.set 1
        local.get 0
        i32.const 1
        i32.add
        local.tee 6
        local.set 0
        local.get 1
        i32.load8_u
        br_if 0 (;@2;)
      end
      local.get 3
      local.get 6
      i32.const -5
      i32.add
      call $__wasi_file_close_direct
      drop
      block  ;; label = @2
        local.get 2
        i32.load offset=272
        local.tee 0
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        call $kfree
      end
      i32.const 0
      local.set 1
      local.get 2
      i32.const 0
      i32.store offset=272
      local.get 2
      i32.const 0
      i32.store
      local.get 2
      i64.const 0
      i64.store offset=264 align=4
    end
    local.get 1)
  (func $fs_mkdir (type 4) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 256
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.load8_u
          i32.const 47
          i32.eq
          br_if 0 (;@3;)
          i32.const -257
          local.set 3
          loop  ;; label = @4
            local.get 3
            i32.const 5841
            i32.add
            local.set 4
            local.get 3
            i32.const 1
            i32.add
            local.tee 5
            local.set 3
            local.get 4
            i32.load8_u
            br_if 0 (;@4;)
          end
          i32.const 0
          local.set 3
          loop  ;; label = @4
            local.get 0
            local.get 3
            i32.add
            local.set 4
            local.get 3
            i32.const 1
            i32.add
            local.tee 6
            local.set 3
            local.get 4
            i32.load8_u
            br_if 0 (;@4;)
          end
          i32.const -1
          local.set 3
          local.get 5
          local.get 6
          i32.add
          i32.const -257
          i32.lt_u
          br_if 2 (;@1;)
          i32.const 0
          local.set 3
          loop  ;; label = @4
            local.get 2
            local.get 3
            i32.add
            local.get 3
            i32.const 5584
            i32.add
            i32.load8_u
            local.tee 4
            i32.store8
            local.get 3
            i32.const 1
            i32.add
            local.set 3
            local.get 4
            br_if 0 (;@4;)
          end
          i32.const 0
          local.set 3
          block  ;; label = @4
            block  ;; label = @5
              i32.const 0
              i32.load8_u offset=5584
              local.tee 4
              br_if 0 (;@5;)
              i32.const 2700
              local.set 5
              br 1 (;@4;)
            end
            i32.const 0
            local.set 3
            block  ;; label = @5
              block  ;; label = @6
                loop  ;; label = @7
                  local.get 4
                  i32.const 255
                  i32.and
                  local.get 3
                  i32.const 2700
                  i32.add
                  i32.load8_u
                  i32.ne
                  br_if 1 (;@6;)
                  local.get 3
                  i32.const 5585
                  i32.add
                  local.set 4
                  local.get 3
                  i32.const 1
                  i32.add
                  local.tee 5
                  local.set 3
                  local.get 4
                  i32.load8_u
                  local.tee 4
                  br_if 0 (;@7;)
                end
                local.get 5
                i32.const 2700
                i32.add
                local.set 5
                i32.const 0
                local.set 4
                br 1 (;@5;)
              end
              local.get 3
              i32.const 2700
              i32.add
              local.set 5
            end
            local.get 4
            i32.const 255
            i32.and
            local.set 3
          end
          block  ;; label = @4
            local.get 3
            local.get 5
            i32.load8_u
            i32.eq
            br_if 0 (;@4;)
            local.get 2
            i32.const -1
            i32.add
            local.set 3
            loop  ;; label = @5
              local.get 3
              i32.const 1
              i32.add
              local.tee 3
              i32.load8_u
              br_if 0 (;@5;)
            end
            local.get 3
            i32.const 47
            i32.store16 align=1
          end
          local.get 2
          i32.const -1
          i32.add
          local.set 4
          loop  ;; label = @4
            local.get 4
            i32.const 1
            i32.add
            local.tee 4
            i32.load8_u
            br_if 0 (;@4;)
          end
          i32.const 0
          local.set 3
          loop  ;; label = @4
            local.get 4
            local.get 3
            i32.add
            local.get 0
            local.get 3
            i32.add
            i32.load8_u
            local.tee 5
            i32.store8
            local.get 3
            i32.const 1
            i32.add
            local.set 3
            local.get 5
            br_if 0 (;@4;)
            br 2 (;@2;)
          end
        end
        i32.const 0
        local.set 3
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              loop  ;; label = @6
                local.get 0
                local.get 3
                i32.add
                local.tee 4
                i32.load8_u
                local.tee 6
                i32.eqz
                br_if 2 (;@4;)
                local.get 2
                local.get 3
                i32.add
                local.tee 5
                local.get 6
                i32.store8
                block  ;; label = @7
                  local.get 4
                  i32.const 1
                  i32.add
                  i32.load8_u
                  local.tee 6
                  i32.eqz
                  br_if 0 (;@7;)
                  local.get 5
                  i32.const 1
                  i32.add
                  local.get 6
                  i32.store8
                  local.get 4
                  i32.const 2
                  i32.add
                  i32.load8_u
                  local.tee 4
                  i32.eqz
                  br_if 2 (;@5;)
                  local.get 5
                  i32.const 2
                  i32.add
                  local.get 4
                  i32.store8
                  local.get 3
                  i32.const 3
                  i32.add
                  local.tee 3
                  i32.const 255
                  i32.ne
                  br_if 1 (;@6;)
                  br 4 (;@3;)
                end
              end
              local.get 3
              i32.const 1
              i32.add
              local.set 3
              br 1 (;@4;)
            end
            local.get 3
            i32.const 2
            i32.add
            local.set 3
          end
          local.get 3
          i32.const 254
          i32.gt_u
          br_if 0 (;@3;)
          local.get 3
          local.set 4
          block  ;; label = @4
            local.get 3
            i32.const 7
            i32.and
            local.tee 0
            i32.const 7
            i32.eq
            br_if 0 (;@4;)
            local.get 2
            local.get 3
            i32.add
            local.set 5
            i32.const 0
            local.set 4
            loop  ;; label = @5
              local.get 5
              local.get 4
              i32.add
              i32.const 0
              i32.store8
              local.get 0
              local.get 4
              i32.const 1
              i32.add
              local.tee 4
              i32.xor
              i32.const 7
              i32.ne
              br_if 0 (;@5;)
            end
            local.get 3
            local.get 4
            i32.add
            local.set 4
          end
          local.get 3
          i32.const 247
          i32.gt_u
          br_if 0 (;@3;)
          local.get 2
          local.set 3
          i32.const 255
          local.set 0
          loop  ;; label = @4
            local.get 3
            local.get 4
            i32.add
            i64.const 0
            i64.store align=1
            local.get 3
            i32.const 8
            i32.add
            local.set 3
            local.get 4
            local.get 0
            i32.const -8
            i32.add
            local.tee 0
            i32.ne
            br_if 0 (;@4;)
          end
        end
        local.get 2
        i32.const 0
        i32.store8 offset=255
      end
      i32.const 0
      local.set 3
      loop  ;; label = @2
        local.get 2
        local.get 3
        i32.add
        local.set 4
        local.get 3
        i32.const 1
        i32.add
        local.tee 0
        local.set 3
        local.get 4
        i32.load8_u
        br_if 0 (;@2;)
      end
      block  ;; label = @2
        i32.const 0
        local.get 2
        local.get 0
        i32.const -1
        i32.add
        local.get 1
        call $__wasi_path_create_directory
        local.tee 3
        br_if 0 (;@2;)
        i32.const 0
        i32.const 0
        i32.store8 offset=33633632
      end
      i32.const -1
      i32.const 0
      local.get 3
      select
      local.set 3
    end
    local.get 2
    i32.const 256
    i32.add
    global.set $__stack_pointer
    local.get 3)
  (func $fs_rmdir (type 8) (param i32) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 256
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    i32.const -1
    local.set 2
    block  ;; label = @1
      local.get 0
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      i32.load8_u
      local.tee 3
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  local.get 3
                  i32.const 47
                  i32.ne
                  br_if 0 (;@7;)
                  i32.const 0
                  local.set 3
                  loop  ;; label = @8
                    local.get 0
                    local.get 3
                    i32.add
                    local.tee 4
                    i32.load8_u
                    local.tee 5
                    i32.eqz
                    br_if 4 (;@4;)
                    local.get 1
                    local.get 3
                    i32.add
                    local.tee 6
                    local.get 5
                    i32.store8
                    local.get 4
                    i32.const 1
                    i32.add
                    i32.load8_u
                    local.tee 5
                    i32.eqz
                    br_if 2 (;@6;)
                    local.get 6
                    i32.const 1
                    i32.add
                    local.get 5
                    i32.store8
                    local.get 4
                    i32.const 2
                    i32.add
                    i32.load8_u
                    local.tee 4
                    i32.eqz
                    br_if 3 (;@5;)
                    local.get 6
                    i32.const 2
                    i32.add
                    local.get 4
                    i32.store8
                    local.get 3
                    i32.const 3
                    i32.add
                    local.tee 3
                    i32.const 255
                    i32.ne
                    br_if 0 (;@8;)
                    br 5 (;@3;)
                  end
                end
                i32.const -257
                local.set 3
                loop  ;; label = @7
                  local.get 3
                  i32.const 5841
                  i32.add
                  local.set 4
                  local.get 3
                  i32.const 1
                  i32.add
                  local.tee 6
                  local.set 3
                  local.get 4
                  i32.load8_u
                  br_if 0 (;@7;)
                end
                i32.const 0
                local.set 3
                loop  ;; label = @7
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
                  i32.load8_u
                  br_if 0 (;@7;)
                end
                local.get 6
                local.get 5
                i32.add
                i32.const -257
                i32.lt_u
                br_if 5 (;@1;)
                i32.const 0
                local.set 3
                loop  ;; label = @7
                  local.get 1
                  local.get 3
                  i32.add
                  local.get 3
                  i32.const 5584
                  i32.add
                  i32.load8_u
                  local.tee 4
                  i32.store8
                  local.get 3
                  i32.const 1
                  i32.add
                  local.set 3
                  local.get 4
                  br_if 0 (;@7;)
                end
                i32.const 0
                local.set 3
                block  ;; label = @7
                  block  ;; label = @8
                    i32.const 0
                    i32.load8_u offset=5584
                    local.tee 4
                    br_if 0 (;@8;)
                    i32.const 2700
                    local.set 6
                    br 1 (;@7;)
                  end
                  i32.const 0
                  local.set 3
                  block  ;; label = @8
                    block  ;; label = @9
                      loop  ;; label = @10
                        local.get 4
                        i32.const 255
                        i32.and
                        local.get 3
                        i32.const 2700
                        i32.add
                        i32.load8_u
                        i32.ne
                        br_if 1 (;@9;)
                        local.get 3
                        i32.const 5585
                        i32.add
                        local.set 4
                        local.get 3
                        i32.const 1
                        i32.add
                        local.tee 6
                        local.set 3
                        local.get 4
                        i32.load8_u
                        local.tee 4
                        br_if 0 (;@10;)
                      end
                      local.get 6
                      i32.const 2700
                      i32.add
                      local.set 6
                      i32.const 0
                      local.set 4
                      br 1 (;@8;)
                    end
                    local.get 3
                    i32.const 2700
                    i32.add
                    local.set 6
                  end
                  local.get 4
                  i32.const 255
                  i32.and
                  local.set 3
                end
                block  ;; label = @7
                  local.get 3
                  local.get 6
                  i32.load8_u
                  i32.eq
                  br_if 0 (;@7;)
                  local.get 1
                  i32.const -1
                  i32.add
                  local.set 3
                  loop  ;; label = @8
                    local.get 3
                    i32.const 1
                    i32.add
                    local.tee 3
                    i32.load8_u
                    br_if 0 (;@8;)
                  end
                  local.get 3
                  i32.const 47
                  i32.store16 align=1
                end
                local.get 1
                i32.const -1
                i32.add
                local.set 4
                loop  ;; label = @7
                  local.get 4
                  i32.const 1
                  i32.add
                  local.tee 4
                  i32.load8_u
                  br_if 0 (;@7;)
                end
                i32.const 0
                local.set 3
                loop  ;; label = @7
                  local.get 4
                  local.get 3
                  i32.add
                  local.get 0
                  local.get 3
                  i32.add
                  i32.load8_u
                  local.tee 6
                  i32.store8
                  local.get 3
                  i32.const 1
                  i32.add
                  local.set 3
                  local.get 6
                  br_if 0 (;@7;)
                  br 5 (;@2;)
                end
              end
              local.get 3
              i32.const 1
              i32.add
              local.set 3
              br 1 (;@4;)
            end
            local.get 3
            i32.const 2
            i32.add
            local.set 3
          end
          local.get 3
          i32.const 254
          i32.gt_u
          br_if 0 (;@3;)
          local.get 3
          local.set 0
          block  ;; label = @4
            local.get 3
            i32.const 7
            i32.and
            local.tee 4
            i32.const 7
            i32.eq
            br_if 0 (;@4;)
            local.get 1
            local.get 3
            i32.add
            local.set 6
            i32.const 0
            local.set 0
            loop  ;; label = @5
              local.get 6
              local.get 0
              i32.add
              i32.const 0
              i32.store8
              local.get 4
              local.get 0
              i32.const 1
              i32.add
              local.tee 0
              i32.xor
              i32.const 7
              i32.ne
              br_if 0 (;@5;)
            end
            local.get 3
            local.get 0
            i32.add
            local.set 0
          end
          local.get 3
          i32.const 247
          i32.gt_u
          br_if 0 (;@3;)
          local.get 1
          local.set 3
          i32.const 255
          local.set 4
          loop  ;; label = @4
            local.get 3
            local.get 0
            i32.add
            i64.const 0
            i64.store align=1
            local.get 3
            i32.const 8
            i32.add
            local.set 3
            local.get 0
            local.get 4
            i32.const -8
            i32.add
            local.tee 4
            i32.ne
            br_if 0 (;@4;)
          end
        end
        local.get 1
        i32.const 0
        i32.store8 offset=255
      end
      i32.const 0
      local.set 3
      loop  ;; label = @2
        local.get 1
        local.get 3
        i32.add
        local.set 0
        local.get 3
        i32.const 1
        i32.add
        local.tee 4
        local.set 3
        local.get 0
        i32.load8_u
        br_if 0 (;@2;)
      end
      block  ;; label = @2
        i32.const 0
        local.get 1
        local.get 4
        i32.const -1
        i32.add
        call $__wasi_path_remove_directory
        local.tee 3
        br_if 0 (;@2;)
        i32.const 0
        i32.const 0
        i32.store8 offset=33633632
      end
      i32.const -1
      i32.const 0
      local.get 3
      select
      local.set 2
    end
    local.get 1
    i32.const 256
    i32.add
    global.set $__stack_pointer
    local.get 2)
  (func $fs_unlink (type 8) (param i32) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 256
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    i32.const -1
    local.set 2
    block  ;; label = @1
      local.get 0
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      i32.load8_u
      local.tee 3
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  local.get 3
                  i32.const 47
                  i32.ne
                  br_if 0 (;@7;)
                  i32.const 0
                  local.set 3
                  loop  ;; label = @8
                    local.get 0
                    local.get 3
                    i32.add
                    local.tee 4
                    i32.load8_u
                    local.tee 5
                    i32.eqz
                    br_if 4 (;@4;)
                    local.get 1
                    local.get 3
                    i32.add
                    local.tee 6
                    local.get 5
                    i32.store8
                    local.get 4
                    i32.const 1
                    i32.add
                    i32.load8_u
                    local.tee 5
                    i32.eqz
                    br_if 2 (;@6;)
                    local.get 6
                    i32.const 1
                    i32.add
                    local.get 5
                    i32.store8
                    local.get 4
                    i32.const 2
                    i32.add
                    i32.load8_u
                    local.tee 4
                    i32.eqz
                    br_if 3 (;@5;)
                    local.get 6
                    i32.const 2
                    i32.add
                    local.get 4
                    i32.store8
                    local.get 3
                    i32.const 3
                    i32.add
                    local.tee 3
                    i32.const 255
                    i32.ne
                    br_if 0 (;@8;)
                    br 5 (;@3;)
                  end
                end
                i32.const -257
                local.set 3
                loop  ;; label = @7
                  local.get 3
                  i32.const 5841
                  i32.add
                  local.set 4
                  local.get 3
                  i32.const 1
                  i32.add
                  local.tee 6
                  local.set 3
                  local.get 4
                  i32.load8_u
                  br_if 0 (;@7;)
                end
                i32.const 0
                local.set 3
                loop  ;; label = @7
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
                  i32.load8_u
                  br_if 0 (;@7;)
                end
                local.get 6
                local.get 5
                i32.add
                i32.const -257
                i32.lt_u
                br_if 5 (;@1;)
                i32.const 0
                local.set 3
                loop  ;; label = @7
                  local.get 1
                  local.get 3
                  i32.add
                  local.get 3
                  i32.const 5584
                  i32.add
                  i32.load8_u
                  local.tee 4
                  i32.store8
                  local.get 3
                  i32.const 1
                  i32.add
                  local.set 3
                  local.get 4
                  br_if 0 (;@7;)
                end
                i32.const 0
                local.set 3
                block  ;; label = @7
                  block  ;; label = @8
                    i32.const 0
                    i32.load8_u offset=5584
                    local.tee 4
                    br_if 0 (;@8;)
                    i32.const 2700
                    local.set 6
                    br 1 (;@7;)
                  end
                  i32.const 0
                  local.set 3
                  block  ;; label = @8
                    block  ;; label = @9
                      loop  ;; label = @10
                        local.get 4
                        i32.const 255
                        i32.and
                        local.get 3
                        i32.const 2700
                        i32.add
                        i32.load8_u
                        i32.ne
                        br_if 1 (;@9;)
                        local.get 3
                        i32.const 5585
                        i32.add
                        local.set 4
                        local.get 3
                        i32.const 1
                        i32.add
                        local.tee 6
                        local.set 3
                        local.get 4
                        i32.load8_u
                        local.tee 4
                        br_if 0 (;@10;)
                      end
                      local.get 6
                      i32.const 2700
                      i32.add
                      local.set 6
                      i32.const 0
                      local.set 4
                      br 1 (;@8;)
                    end
                    local.get 3
                    i32.const 2700
                    i32.add
                    local.set 6
                  end
                  local.get 4
                  i32.const 255
                  i32.and
                  local.set 3
                end
                block  ;; label = @7
                  local.get 3
                  local.get 6
                  i32.load8_u
                  i32.eq
                  br_if 0 (;@7;)
                  local.get 1
                  i32.const -1
                  i32.add
                  local.set 3
                  loop  ;; label = @8
                    local.get 3
                    i32.const 1
                    i32.add
                    local.tee 3
                    i32.load8_u
                    br_if 0 (;@8;)
                  end
                  local.get 3
                  i32.const 47
                  i32.store16 align=1
                end
                local.get 1
                i32.const -1
                i32.add
                local.set 4
                loop  ;; label = @7
                  local.get 4
                  i32.const 1
                  i32.add
                  local.tee 4
                  i32.load8_u
                  br_if 0 (;@7;)
                end
                i32.const 0
                local.set 3
                loop  ;; label = @7
                  local.get 4
                  local.get 3
                  i32.add
                  local.get 0
                  local.get 3
                  i32.add
                  i32.load8_u
                  local.tee 6
                  i32.store8
                  local.get 3
                  i32.const 1
                  i32.add
                  local.set 3
                  local.get 6
                  br_if 0 (;@7;)
                  br 5 (;@2;)
                end
              end
              local.get 3
              i32.const 1
              i32.add
              local.set 3
              br 1 (;@4;)
            end
            local.get 3
            i32.const 2
            i32.add
            local.set 3
          end
          local.get 3
          i32.const 254
          i32.gt_u
          br_if 0 (;@3;)
          local.get 3
          local.set 0
          block  ;; label = @4
            local.get 3
            i32.const 7
            i32.and
            local.tee 4
            i32.const 7
            i32.eq
            br_if 0 (;@4;)
            local.get 1
            local.get 3
            i32.add
            local.set 6
            i32.const 0
            local.set 0
            loop  ;; label = @5
              local.get 6
              local.get 0
              i32.add
              i32.const 0
              i32.store8
              local.get 4
              local.get 0
              i32.const 1
              i32.add
              local.tee 0
              i32.xor
              i32.const 7
              i32.ne
              br_if 0 (;@5;)
            end
            local.get 3
            local.get 0
            i32.add
            local.set 0
          end
          local.get 3
          i32.const 247
          i32.gt_u
          br_if 0 (;@3;)
          local.get 1
          local.set 3
          i32.const 255
          local.set 4
          loop  ;; label = @4
            local.get 3
            local.get 0
            i32.add
            i64.const 0
            i64.store align=1
            local.get 3
            i32.const 8
            i32.add
            local.set 3
            local.get 0
            local.get 4
            i32.const -8
            i32.add
            local.tee 4
            i32.ne
            br_if 0 (;@4;)
          end
        end
        local.get 1
        i32.const 0
        i32.store8 offset=255
      end
      i32.const 0
      local.set 3
      loop  ;; label = @2
        local.get 1
        local.get 3
        i32.add
        local.set 0
        local.get 3
        i32.const 1
        i32.add
        local.tee 4
        local.set 3
        local.get 0
        i32.load8_u
        br_if 0 (;@2;)
      end
      block  ;; label = @2
        local.get 1
        local.get 4
        i32.const -1
        i32.add
        call $__wasi_file_delete
        local.tee 3
        br_if 0 (;@2;)
        i32.const 0
        i32.const 0
        i32.store8 offset=33633632
      end
      i32.const -1
      i32.const 0
      local.get 3
      select
      local.set 2
    end
    local.get 1
    i32.const 256
    i32.add
    global.set $__stack_pointer
    local.get 2)
  (func $fs_chdir (type 8) (param i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 1024
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    i32.const -1
    local.set 2
    block  ;; label = @1
      local.get 0
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      i32.load8_u
      local.tee 3
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 3
              i32.const 47
              i32.eq
              br_if 0 (;@5;)
              i32.const -513
              local.set 3
              loop  ;; label = @6
                local.get 3
                i32.const 6097
                i32.add
                local.set 4
                local.get 3
                i32.const 1
                i32.add
                local.tee 5
                local.set 3
                local.get 4
                i32.load8_u
                br_if 0 (;@6;)
              end
              i32.const 0
              local.set 3
              loop  ;; label = @6
                local.get 0
                local.get 3
                i32.add
                local.set 4
                local.get 3
                i32.const 1
                i32.add
                local.tee 6
                local.set 3
                local.get 4
                i32.load8_u
                br_if 0 (;@6;)
              end
              local.get 5
              local.get 6
              i32.add
              i32.const -513
              i32.lt_u
              br_if 4 (;@1;)
              i32.const 0
              local.set 3
              loop  ;; label = @6
                local.get 1
                i32.const 512
                i32.add
                local.get 3
                i32.add
                local.get 3
                i32.const 5584
                i32.add
                i32.load8_u
                local.tee 4
                i32.store8
                local.get 3
                i32.const 1
                i32.add
                local.set 3
                local.get 4
                br_if 0 (;@6;)
              end
              i32.const 0
              local.set 3
              i32.const 0
              i32.load8_u offset=5584
              local.tee 4
              br_if 1 (;@4;)
              i32.const 2700
              local.set 5
              br 2 (;@3;)
            end
            local.get 1
            i32.const 47
            i32.store8 offset=512
            local.get 0
            i32.const 1
            i32.add
            local.set 3
            local.get 1
            i32.const 512
            i32.add
            i32.const 1
            i32.or
            local.set 4
            loop  ;; label = @5
              local.get 4
              local.get 3
              i32.load8_u
              local.tee 0
              i32.store8
              local.get 3
              i32.const 1
              i32.add
              local.set 3
              local.get 4
              i32.const 1
              i32.add
              local.set 4
              local.get 0
              br_if 0 (;@5;)
              br 3 (;@2;)
            end
          end
          i32.const 0
          local.set 3
          block  ;; label = @4
            block  ;; label = @5
              loop  ;; label = @6
                local.get 4
                i32.const 255
                i32.and
                local.get 3
                i32.const 2700
                i32.add
                i32.load8_u
                i32.ne
                br_if 1 (;@5;)
                local.get 3
                i32.const 5585
                i32.add
                local.set 4
                local.get 3
                i32.const 1
                i32.add
                local.tee 5
                local.set 3
                local.get 4
                i32.load8_u
                local.tee 4
                br_if 0 (;@6;)
              end
              local.get 5
              i32.const 2700
              i32.add
              local.set 5
              i32.const 0
              local.set 4
              br 1 (;@4;)
            end
            local.get 3
            i32.const 2700
            i32.add
            local.set 5
          end
          local.get 4
          i32.const 255
          i32.and
          local.set 3
        end
        block  ;; label = @3
          local.get 3
          local.get 5
          i32.load8_u
          i32.eq
          br_if 0 (;@3;)
          local.get 1
          i32.const 511
          i32.add
          local.set 3
          loop  ;; label = @4
            local.get 3
            i32.const 1
            i32.add
            local.tee 3
            i32.load8_u
            br_if 0 (;@4;)
          end
          local.get 3
          i32.const 47
          i32.store16 align=1
        end
        local.get 1
        i32.const 511
        i32.add
        local.set 4
        loop  ;; label = @3
          local.get 4
          i32.const 1
          i32.add
          local.tee 4
          i32.load8_u
          br_if 0 (;@3;)
        end
        i32.const 0
        local.set 3
        loop  ;; label = @3
          local.get 4
          local.get 3
          i32.add
          local.get 0
          local.get 3
          i32.add
          i32.load8_u
          local.tee 5
          i32.store8
          local.get 3
          i32.const 1
          i32.add
          local.set 3
          local.get 5
          br_if 0 (;@3;)
        end
      end
      local.get 1
      i32.const 512
      i32.add
      local.set 3
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              loop  ;; label = @6
                block  ;; label = @7
                  local.get 3
                  i32.load8_u
                  local.tee 4
                  i32.const 47
                  i32.eq
                  br_if 0 (;@7;)
                  local.get 4
                  i32.eqz
                  br_if 4 (;@3;)
                  local.get 3
                  i32.const 1
                  i32.add
                  local.set 0
                  block  ;; label = @8
                    block  ;; label = @9
                      loop  ;; label = @10
                        local.get 4
                        i32.const 255
                        i32.and
                        local.tee 4
                        i32.eqz
                        br_if 1 (;@9;)
                        block  ;; label = @11
                          local.get 4
                          i32.const 47
                          i32.eq
                          br_if 0 (;@11;)
                          local.get 0
                          i32.load8_u
                          local.set 4
                          local.get 0
                          i32.const 1
                          i32.add
                          local.set 0
                          br 1 (;@10;)
                        end
                      end
                      local.get 0
                      i32.const -1
                      i32.add
                      i32.const 0
                      i32.store8
                      br 1 (;@8;)
                    end
                    i32.const 0
                    local.set 0
                  end
                  i32.const 0
                  local.set 7
                  loop  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          local.get 3
                          i32.load8_u
                          local.tee 8
                          br_if 0 (;@11;)
                          i32.const 2872
                          local.set 4
                          i32.const 0
                          local.set 5
                          br 1 (;@10;)
                        end
                        local.get 3
                        i32.const 1
                        i32.add
                        local.set 5
                        i32.const 0
                        local.set 4
                        local.get 8
                        local.set 6
                        block  ;; label = @11
                          loop  ;; label = @12
                            local.get 6
                            i32.const 255
                            i32.and
                            local.get 4
                            i32.const 2873
                            i32.add
                            i32.load8_u
                            local.tee 9
                            i32.ne
                            br_if 1 (;@11;)
                            local.get 5
                            local.get 4
                            i32.add
                            local.set 6
                            local.get 4
                            i32.const 1
                            i32.add
                            local.tee 9
                            local.set 4
                            local.get 6
                            i32.load8_u
                            local.tee 6
                            br_if 0 (;@12;)
                          end
                          local.get 9
                          i32.const 2873
                          i32.add
                          i32.load8_u
                          local.set 9
                          i32.const 0
                          local.set 6
                        end
                        local.get 6
                        i32.const 255
                        i32.and
                        local.get 9
                        i32.const 255
                        i32.and
                        i32.eq
                        br_if 1 (;@9;)
                        i32.const 2872
                        local.set 4
                        block  ;; label = @11
                          loop  ;; label = @12
                            local.get 8
                            i32.const 255
                            i32.and
                            local.get 4
                            i32.load8_u
                            i32.ne
                            br_if 1 (;@11;)
                            local.get 4
                            i32.const 1
                            i32.add
                            local.set 4
                            local.get 5
                            i32.load8_u
                            local.set 8
                            local.get 5
                            i32.const 1
                            i32.add
                            local.set 5
                            local.get 8
                            br_if 0 (;@12;)
                          end
                          i32.const 0
                          local.set 8
                        end
                        local.get 8
                        i32.const 255
                        i32.and
                        local.set 5
                      end
                      block  ;; label = @10
                        local.get 5
                        local.get 4
                        i32.load8_u
                        i32.ne
                        br_if 0 (;@10;)
                        local.get 7
                        local.get 7
                        i32.const 0
                        i32.gt_s
                        i32.sub
                        local.set 7
                        br 1 (;@9;)
                      end
                      local.get 1
                      i32.const 256
                      i32.add
                      local.get 7
                      i32.const 2
                      i32.shl
                      i32.add
                      local.get 3
                      i32.store
                      local.get 7
                      i32.const 1
                      i32.add
                      local.set 7
                    end
                    local.get 0
                    i32.eqz
                    br_if 3 (;@5;)
                    local.get 0
                    i32.const 1
                    i32.add
                    local.set 4
                    local.get 0
                    local.set 3
                    loop  ;; label = @9
                      block  ;; label = @10
                        local.get 3
                        i32.load8_u
                        local.tee 0
                        i32.const 47
                        i32.eq
                        br_if 0 (;@10;)
                        local.get 0
                        i32.eqz
                        br_if 5 (;@5;)
                        block  ;; label = @11
                          block  ;; label = @12
                            loop  ;; label = @13
                              local.get 0
                              i32.const 255
                              i32.and
                              local.tee 0
                              i32.eqz
                              br_if 1 (;@12;)
                              block  ;; label = @14
                                local.get 0
                                i32.const 47
                                i32.eq
                                br_if 0 (;@14;)
                                local.get 4
                                i32.load8_u
                                local.set 0
                                local.get 4
                                i32.const 1
                                i32.add
                                local.set 4
                                br 1 (;@13;)
                              end
                            end
                            local.get 4
                            i32.const -1
                            i32.add
                            i32.const 0
                            i32.store8
                            local.get 4
                            local.set 0
                            br 1 (;@11;)
                          end
                          i32.const 0
                          local.set 0
                        end
                        local.get 7
                        i32.const 64
                        i32.lt_s
                        br_if 2 (;@8;)
                        local.get 1
                        i32.const 0
                        i32.store8
                        br 6 (;@4;)
                      end
                      local.get 4
                      i32.const 1
                      i32.add
                      local.set 4
                      local.get 3
                      i32.const 1
                      i32.add
                      local.set 3
                      br 0 (;@9;)
                    end
                  end
                end
                local.get 3
                i32.const 1
                i32.add
                local.set 3
                br 0 (;@6;)
              end
            end
            local.get 7
            i32.eqz
            br_if 1 (;@3;)
            local.get 1
            i32.const 0
            i32.store8
            local.get 7
            i32.const 1
            i32.lt_s
            br_if 2 (;@2;)
          end
          local.get 1
          i32.const -1
          i32.add
          local.set 8
          i32.const 0
          local.set 6
          loop  ;; label = @4
            local.get 8
            local.set 3
            loop  ;; label = @5
              local.get 3
              i32.const 1
              i32.add
              local.tee 3
              i32.load8_u
              br_if 0 (;@5;)
            end
            local.get 3
            i32.const 47
            i32.store16 align=1
            local.get 1
            i32.const 256
            i32.add
            local.get 6
            i32.const 2
            i32.shl
            i32.add
            i32.load
            local.set 5
            local.get 8
            local.set 4
            loop  ;; label = @5
              local.get 4
              i32.const 1
              i32.add
              local.tee 4
              i32.load8_u
              br_if 0 (;@5;)
            end
            i32.const 0
            local.set 3
            loop  ;; label = @5
              local.get 4
              local.get 3
              i32.add
              local.get 5
              local.get 3
              i32.add
              i32.load8_u
              local.tee 0
              i32.store8
              local.get 3
              i32.const 1
              i32.add
              local.set 3
              local.get 0
              br_if 0 (;@5;)
            end
            local.get 6
            i32.const 1
            i32.add
            local.tee 6
            local.get 7
            i32.ne
            br_if 0 (;@4;)
            br 2 (;@2;)
          end
        end
        local.get 1
        i32.const 47
        i32.store16
      end
      local.get 1
      local.get 1
      i32.const 512
      i32.add
      call $fs_stat
      i32.const 0
      i32.lt_s
      br_if 0 (;@1;)
      local.get 1
      i32.load8_u offset=517
      i32.const 64
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      i32.const 0
      local.set 2
      i32.const 0
      local.set 3
      loop  ;; label = @2
        local.get 3
        i32.const 5584
        i32.add
        local.get 1
        local.get 3
        i32.add
        i32.load8_u
        local.tee 4
        i32.store8
        local.get 3
        i32.const 1
        i32.add
        local.set 3
        local.get 4
        br_if 0 (;@2;)
      end
    end
    local.get 1
    i32.const 1024
    i32.add
    global.set $__stack_pointer
    local.get 2)
  (func $fs_getcwd (type 4) (param i32 i32) (result i32)
    (local i32 i32 i32 i32)
    i32.const 0
    local.set 2
    block  ;; label = @1
      local.get 0
      i32.eqz
      br_if 0 (;@1;)
      local.get 1
      i32.eqz
      br_if 0 (;@1;)
      i32.const -1
      local.set 3
      loop  ;; label = @2
        local.get 3
        i32.const 5585
        i32.add
        local.set 4
        local.get 3
        i32.const 1
        i32.add
        local.tee 5
        local.set 3
        local.get 4
        i32.load8_u
        br_if 0 (;@2;)
      end
      local.get 5
      local.get 1
      i32.ge_u
      br_if 0 (;@1;)
      i32.const 0
      local.set 3
      loop  ;; label = @2
        local.get 0
        local.get 3
        i32.add
        local.get 3
        i32.const 5584
        i32.add
        i32.load8_u
        local.tee 4
        i32.store8
        local.get 3
        i32.const 1
        i32.add
        local.set 3
        local.get 4
        br_if 0 (;@2;)
      end
      local.get 0
      local.set 2
    end
    local.get 2)
  (func $fs_opendir (type 8) (param i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    block  ;; label = @1
      block  ;; label = @2
        i32.const 0
        i32.load8_u offset=33630960
        br_if 0 (;@2;)
        i32.const -1
        local.set 2
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 0
        local.get 1
        call $fs_stat
        i32.const 0
        i32.ge_s
        br_if 0 (;@2;)
        i32.const -1
        local.set 2
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 1
        i32.load8_u offset=5
        i32.const 64
        i32.and
        br_if 0 (;@2;)
        i32.const -1
        local.set 2
        br 1 (;@1;)
      end
      block  ;; label = @2
        i32.const 0
        i32.load offset=5840
        local.tee 2
        i32.const 255
        i32.le_s
        br_if 0 (;@2;)
        i32.const -1
        local.set 2
        br 1 (;@1;)
      end
      local.get 2
      i32.const 276
      i32.mul
      i32.const 33560304
      i32.add
      local.set 3
      block  ;; label = @2
        loop  ;; label = @3
          local.get 3
          i32.load
          i32.eqz
          br_if 1 (;@2;)
          local.get 3
          i32.const 276
          i32.add
          local.set 3
          local.get 2
          i32.const 1
          i32.add
          local.tee 2
          i32.const 256
          i32.ne
          br_if 0 (;@3;)
        end
        i32.const -1
        local.set 2
        br 1 (;@1;)
      end
      local.get 3
      i32.const 1
      i32.store
      i32.const 0
      local.set 4
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            loop  ;; label = @5
              local.get 0
              local.get 4
              i32.add
              local.tee 5
              i32.load8_u
              local.tee 6
              i32.eqz
              br_if 2 (;@3;)
              local.get 3
              local.get 4
              i32.add
              local.tee 7
              i32.const 4
              i32.add
              local.get 6
              i32.store8
              block  ;; label = @6
                local.get 5
                i32.const 1
                i32.add
                i32.load8_u
                local.tee 6
                i32.eqz
                br_if 0 (;@6;)
                local.get 7
                i32.const 5
                i32.add
                local.get 6
                i32.store8
                local.get 5
                i32.const 2
                i32.add
                i32.load8_u
                local.tee 5
                i32.eqz
                br_if 2 (;@4;)
                local.get 7
                i32.const 6
                i32.add
                local.get 5
                i32.store8
                local.get 4
                i32.const 3
                i32.add
                local.tee 4
                i32.const 255
                i32.ne
                br_if 1 (;@5;)
                br 4 (;@2;)
              end
            end
            local.get 4
            i32.const 1
            i32.add
            local.set 4
            br 1 (;@3;)
          end
          local.get 4
          i32.const 2
          i32.add
          local.set 4
        end
        local.get 4
        i32.const 254
        i32.gt_u
        br_if 0 (;@2;)
        local.get 4
        local.set 7
        block  ;; label = @3
          local.get 4
          i32.const 7
          i32.and
          local.tee 5
          i32.const 7
          i32.eq
          br_if 0 (;@3;)
          local.get 3
          local.get 4
          i32.add
          local.set 7
          i32.const 0
          local.set 0
          loop  ;; label = @4
            local.get 7
            local.get 0
            i32.add
            i32.const 4
            i32.add
            i32.const 0
            i32.store8
            local.get 5
            local.get 0
            i32.const 1
            i32.add
            local.tee 0
            i32.xor
            i32.const 7
            i32.ne
            br_if 0 (;@4;)
          end
          local.get 4
          local.get 0
          i32.add
          local.set 7
        end
        local.get 4
        i32.const 247
        i32.gt_u
        br_if 0 (;@2;)
        local.get 7
        i32.const -255
        i32.add
        local.set 0
        local.get 3
        local.get 7
        i32.add
        local.set 4
        loop  ;; label = @3
          local.get 4
          i32.const 4
          i32.add
          i64.const 0
          i64.store align=1
          local.get 4
          i32.const 8
          i32.add
          local.set 4
          local.get 0
          i32.const 8
          i32.add
          local.tee 0
          br_if 0 (;@3;)
        end
      end
      local.get 3
      i32.const 268
      i32.add
      i64.const 0
      i64.store align=4
      local.get 3
      i32.const 260
      i32.add
      i64.const 0
      i64.store align=4
      local.get 3
      i32.const 259
      i32.add
      i32.const 0
      i32.store8
    end
    local.get 1
    i32.const 32
    i32.add
    global.set $__stack_pointer
    local.get 2)
  (func $fs_readdir (type 4) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    i32.const -1
    local.set 2
    block  ;; label = @1
      local.get 0
      i32.const 255
      i32.gt_u
      br_if 0 (;@1;)
      local.get 1
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      i32.const 276
      i32.mul
      i32.const 33560304
      i32.add
      local.tee 3
      i32.load
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                local.get 3
                i32.load offset=264
                local.tee 4
                br_table 2 (;@4;) 0 (;@6;) 1 (;@5;)
              end
              local.get 1
              i32.const 0
              i32.store8 offset=6
              local.get 1
              i32.const 11822
              i32.store16 offset=4 align=1
              i32.const 2
              local.set 0
              local.get 1
              i32.const 2
              i32.store
              br 3 (;@2;)
            end
            i32.const 4
            local.set 0
            i32.const 0
            local.set 5
            local.get 3
            i32.const 4
            i32.add
            local.tee 6
            local.set 7
            block  ;; label = @5
              i32.const 0
              i32.load8_u offset=33633632
              local.tee 2
              i32.eqz
              br_if 0 (;@5;)
              block  ;; label = @6
                loop  ;; label = @7
                  local.get 2
                  i32.const 255
                  i32.and
                  local.get 3
                  local.get 0
                  i32.add
                  local.tee 7
                  i32.load8_u
                  i32.ne
                  br_if 1 (;@6;)
                  local.get 0
                  i32.const 33633629
                  i32.add
                  local.set 2
                  local.get 0
                  i32.const 1
                  i32.add
                  local.tee 7
                  local.set 0
                  local.get 2
                  i32.load8_u
                  local.tee 2
                  br_if 0 (;@7;)
                end
                local.get 3
                local.get 7
                i32.add
                local.set 7
                i32.const 0
                local.set 2
              end
              local.get 2
              i32.const 255
              i32.and
              local.set 5
            end
            block  ;; label = @5
              block  ;; label = @6
                local.get 4
                i32.const 3
                i32.lt_s
                br_if 0 (;@6;)
                local.get 5
                local.get 7
                i32.load8_u
                i32.eq
                br_if 1 (;@5;)
              end
              i32.const 4
              local.set 0
              loop  ;; label = @6
                local.get 3
                local.get 0
                i32.add
                local.set 2
                local.get 0
                i32.const 1
                i32.add
                local.tee 7
                local.set 0
                local.get 2
                i32.load8_u
                br_if 0 (;@6;)
              end
              i32.const 1
              local.set 2
              local.get 6
              local.get 7
              i32.const -5
              i32.add
              i32.const 33633888
              i32.const 1024
              i32.const 33634912
              call $__wasi_list_directory
              br_if 4 (;@1;)
              i32.const 0
              local.set 0
              loop  ;; label = @6
                local.get 0
                i32.const 33633632
                i32.add
                local.get 6
                local.get 0
                i32.add
                i32.load8_u
                local.tee 2
                i32.store8
                local.get 0
                i32.const 1
                i32.add
                local.set 0
                local.get 2
                br_if 0 (;@6;)
              end
            end
            i32.const 0
            local.set 8
            i32.const 1
            local.set 2
            i32.const 0
            i32.load offset=33634912
            local.tee 9
            i32.const 1
            i32.lt_s
            br_if 3 (;@1;)
            local.get 3
            i32.load offset=264
            i32.const -2
            i32.add
            local.set 10
            i32.const 33633888
            local.set 0
            i32.const 0
            local.set 11
            loop  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    local.get 0
                    i32.load8_u
                    local.tee 4
                    br_if 0 (;@8;)
                    i32.const 0
                    local.set 7
                    i32.const 2872
                    local.set 2
                    br 1 (;@7;)
                  end
                  local.get 0
                  i32.const 1
                  i32.add
                  local.set 7
                  i32.const 0
                  local.set 2
                  local.get 4
                  local.set 6
                  block  ;; label = @8
                    loop  ;; label = @9
                      local.get 6
                      i32.const 255
                      i32.and
                      local.get 2
                      i32.const 2873
                      i32.add
                      i32.load8_u
                      local.tee 5
                      i32.ne
                      br_if 1 (;@8;)
                      local.get 7
                      local.get 2
                      i32.add
                      local.set 6
                      local.get 2
                      i32.const 1
                      i32.add
                      local.tee 5
                      local.set 2
                      local.get 6
                      i32.load8_u
                      local.tee 6
                      br_if 0 (;@9;)
                    end
                    local.get 5
                    i32.const 2873
                    i32.add
                    i32.load8_u
                    local.set 5
                    i32.const 0
                    local.set 6
                  end
                  local.get 6
                  i32.const 255
                  i32.and
                  local.get 5
                  i32.const 255
                  i32.and
                  i32.eq
                  br_if 1 (;@6;)
                  i32.const 2872
                  local.set 2
                  block  ;; label = @8
                    loop  ;; label = @9
                      local.get 4
                      i32.const 255
                      i32.and
                      local.get 2
                      i32.load8_u
                      i32.ne
                      br_if 1 (;@8;)
                      local.get 2
                      i32.const 1
                      i32.add
                      local.set 2
                      local.get 7
                      i32.load8_u
                      local.set 4
                      local.get 7
                      i32.const 1
                      i32.add
                      local.set 7
                      local.get 4
                      br_if 0 (;@9;)
                    end
                    i32.const 0
                    local.set 4
                  end
                  local.get 4
                  i32.const 255
                  i32.and
                  local.set 7
                end
                local.get 7
                local.get 2
                i32.load8_u
                i32.eq
                br_if 0 (;@6;)
                block  ;; label = @7
                  local.get 11
                  local.get 10
                  i32.ne
                  br_if 0 (;@7;)
                  local.get 1
                  local.get 8
                  i32.const 100
                  i32.add
                  i32.store
                  local.get 1
                  i32.const 4
                  i32.add
                  local.set 2
                  loop  ;; label = @8
                    local.get 2
                    local.get 0
                    i32.load8_u
                    local.tee 7
                    i32.store8
                    local.get 2
                    i32.const 1
                    i32.add
                    local.set 2
                    local.get 0
                    i32.const 1
                    i32.add
                    local.set 0
                    local.get 7
                    br_if 0 (;@8;)
                  end
                  i32.const 4
                  local.set 0
                  loop  ;; label = @8
                    local.get 1
                    local.get 0
                    i32.add
                    local.set 2
                    local.get 0
                    i32.const 1
                    i32.add
                    local.tee 7
                    local.set 0
                    local.get 2
                    i32.load8_u
                    br_if 0 (;@8;)
                  end
                  i32.const 1
                  local.set 0
                  local.get 7
                  i32.const -5
                  i32.add
                  i32.const 1
                  i32.lt_s
                  br_if 5 (;@2;)
                  local.get 1
                  local.get 7
                  i32.add
                  i32.const -2
                  i32.add
                  local.tee 2
                  i32.load8_u
                  i32.const 47
                  i32.ne
                  br_if 5 (;@2;)
                  local.get 2
                  i32.const 0
                  i32.store8
                  br 4 (;@3;)
                end
                local.get 11
                i32.const 1
                i32.add
                local.set 11
              end
              loop  ;; label = @6
                local.get 0
                i32.load8_u
                local.set 2
                local.get 0
                i32.const 1
                i32.add
                local.tee 7
                local.set 0
                local.get 2
                br_if 0 (;@6;)
              end
              i32.const 1
              local.set 2
              local.get 7
              local.set 0
              local.get 8
              i32.const 1
              i32.add
              local.tee 8
              local.get 9
              i32.ne
              br_if 0 (;@5;)
              br 4 (;@1;)
            end
          end
          local.get 1
          i32.const 46
          i32.store16 offset=4 align=1
          local.get 1
          i32.const 1
          i32.store
        end
        i32.const 2
        local.set 0
      end
      local.get 1
      local.get 0
      i32.store8 offset=260
      local.get 3
      local.get 3
      i32.load offset=264
      i32.const 1
      i32.add
      i32.store offset=264
      i32.const 0
      local.set 2
    end
    local.get 2)
  (func $fs_closedir (type 8) (param i32) (result i32)
    local.get 0
    call $fs_close)
  (func $console_init (type 0) (result i32)
    i32.const 0)
  (func $drivers_init (type 0) (result i32)
    (local i32 i32)
    i32.const 0
    i32.load offset=33635092
    local.set 0
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 0
          i32.load offset=33635088
          local.tee 1
          i32.const 9
          i32.gt_s
          br_if 0 (;@3;)
          i32.const 0
          local.get 1
          i32.const 1
          i32.add
          i32.store offset=33635088
          local.get 1
          i32.const 4
          i32.shl
          local.tee 1
          i32.const 33634940
          i32.add
          local.get 0
          i32.store
          local.get 1
          i32.const 33634936
          i32.add
          i32.const 0
          i32.store
          local.get 1
          i32.const 33634932
          i32.add
          i32.const 1
          i32.store
          local.get 1
          i32.const 33634928
          i32.add
          local.tee 0
          i32.const 1838
          i32.store
          i32.const 0
          local.get 0
          i32.store offset=33635092
          br 1 (;@2;)
        end
        local.get 0
        i32.eqz
        br_if 1 (;@1;)
      end
      loop  ;; label = @2
        i32.const 4970
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
          i32.const 3913
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
    i32.const 4296
    i32.const 0
    call $kprintf
    drop
    i32.const 0)
  (func $kputs (type 8) (param i32) (result i32)
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
    i32.const 5346
    i32.const 1
    call $wasi_write
    drop
    local.get 3)
  (func $kprintf (type 4) (param i32 i32) (result i32)
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
                              i32.const 2937
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
                                  i32.const 3090
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
                            i32.const 3090
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
  (func $kfprintf (type 1) (param i32 i32 i32) (result i32)
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
                    i32.const 2937
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
  (func $wasi_write (type 1) (param i32 i32 i32) (result i32)
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
  (func $wasi_exit (type 5) (param i32)
    local.get 0
    call $__wasi_proc_exit)
  (func $wasi_get_time_ns (type 9) (result i64)
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
  (func $execute_command (type 5) (param i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 1248
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
                    local.get 0
                    i32.load8_u
                    local.tee 4
                    br_if 0 (;@8;)
                    i32.const 0
                    local.set 5
                    i32.const 1232
                    local.set 3
                    br 1 (;@7;)
                  end
                  local.get 0
                  i32.const 1
                  i32.add
                  local.set 6
                  i32.const 0
                  local.set 3
                  local.get 4
                  local.set 5
                  block  ;; label = @8
                    loop  ;; label = @9
                      local.get 5
                      i32.const 255
                      i32.and
                      local.get 3
                      i32.const 1444
                      i32.add
                      i32.load8_u
                      local.tee 7
                      i32.ne
                      br_if 1 (;@8;)
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
                      br_if 0 (;@9;)
                    end
                    local.get 7
                    i32.const 1444
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
                  br_if 3 (;@4;)
                  local.get 0
                  i32.const 1
                  i32.add
                  local.set 7
                  i32.const 1438
                  local.set 5
                  local.get 4
                  local.set 3
                  block  ;; label = @8
                    loop  ;; label = @9
                      local.get 3
                      i32.const 255
                      i32.and
                      local.get 5
                      i32.load8_u
                      i32.ne
                      br_if 1 (;@8;)
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
                      br_if 0 (;@9;)
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
                  br_if 2 (;@5;)
                  local.get 0
                  i32.const 1
                  i32.add
                  local.set 6
                  i32.const 0
                  local.set 3
                  local.get 4
                  local.set 5
                  block  ;; label = @8
                    loop  ;; label = @9
                      local.get 5
                      i32.const 255
                      i32.and
                      local.get 3
                      i32.const 1452
                      i32.add
                      i32.load8_u
                      local.tee 7
                      i32.ne
                      br_if 1 (;@8;)
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
                      br_if 0 (;@9;)
                    end
                    local.get 7
                    i32.const 1452
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
                  br_if 1 (;@6;)
                  local.get 0
                  i32.const 1
                  i32.add
                  local.set 7
                  i32.const 1232
                  local.set 3
                  local.get 4
                  local.set 5
                  block  ;; label = @8
                    loop  ;; label = @9
                      local.get 5
                      i32.const 255
                      i32.and
                      local.get 3
                      i32.load8_u
                      i32.ne
                      br_if 1 (;@8;)
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
                      br_if 0 (;@9;)
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
                br_if 3 (;@3;)
                i32.const 2444
                call $kputs
                drop
                i32.const 2685
                call $kputs
                drop
                i32.const 2622
                call $kputs
                drop
                i32.const 2420
                call $kputs
                drop
                i32.const 5351
                call $kputs
                drop
                i32.const 1555
                call $kputs
                drop
                i32.const 2738
                call $kputs
                drop
                br 5 (;@1;)
              end
              block  ;; label = @6
                local.get 2
                i32.eqz
                br_if 0 (;@6;)
                i32.const 0
                local.set 3
                loop  ;; label = @7
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
                  br_if 0 (;@7;)
                end
                block  ;; label = @7
                  local.get 7
                  i32.const -1
                  i32.add
                  i32.const 511
                  i32.gt_u
                  br_if 0 (;@7;)
                  i32.const 0
                  local.set 3
                  loop  ;; label = @8
                    local.get 1
                    i32.const 736
                    i32.add
                    local.get 3
                    i32.add
                    local.get 2
                    local.get 3
                    i32.add
                    i32.load8_u
                    local.tee 5
                    i32.store8
                    local.get 3
                    i32.const 1
                    i32.add
                    local.set 3
                    local.get 5
                    br_if 0 (;@8;)
                  end
                  local.get 1
                  i32.const 736
                  i32.add
                  local.set 3
                  block  ;; label = @8
                    loop  ;; label = @9
                      local.get 3
                      i32.load8_u
                      local.tee 5
                      i32.eqz
                      br_if 1 (;@8;)
                      local.get 5
                      i32.const 62
                      i32.eq
                      br_if 1 (;@8;)
                      local.get 3
                      i32.const 1
                      i32.add
                      local.set 3
                      br 0 (;@9;)
                    end
                  end
                  i32.const -1
                  local.set 6
                  local.get 5
                  i32.const 62
                  i32.ne
                  br_if 5 (;@2;)
                  block  ;; label = @8
                    block  ;; label = @9
                      local.get 3
                      local.get 1
                      i32.const 736
                      i32.add
                      i32.le_u
                      br_if 0 (;@9;)
                      local.get 3
                      i32.const -1
                      i32.add
                      local.tee 2
                      i32.load8_u
                      i32.const 62
                      i32.ne
                      br_if 0 (;@9;)
                      local.get 2
                      i32.const 0
                      i32.store8
                      i32.const 1089
                      local.set 6
                      br 1 (;@8;)
                    end
                    local.get 3
                    i32.const 0
                    i32.store8
                    i32.const 577
                    local.set 6
                  end
                  local.get 3
                  i32.const 2
                  i32.add
                  local.set 2
                  block  ;; label = @8
                    loop  ;; label = @9
                      block  ;; label = @10
                        local.get 2
                        i32.const -1
                        i32.add
                        i32.load8_u
                        local.tee 3
                        i32.const 9
                        i32.eq
                        br_if 0 (;@10;)
                        local.get 3
                        i32.const 32
                        i32.eq
                        br_if 0 (;@10;)
                        i32.const 0
                        local.set 7
                        block  ;; label = @11
                          loop  ;; label = @12
                            local.get 3
                            i32.const 32
                            i32.or
                            i32.const 255
                            i32.and
                            i32.const 32
                            i32.eq
                            br_if 1 (;@11;)
                            local.get 3
                            i32.const 255
                            i32.and
                            i32.const 9
                            i32.eq
                            br_if 1 (;@11;)
                            local.get 7
                            i32.const 126
                            i32.gt_u
                            br_if 1 (;@11;)
                            local.get 1
                            i32.const 608
                            i32.add
                            local.get 7
                            i32.add
                            local.get 3
                            i32.store8
                            local.get 2
                            local.get 7
                            i32.add
                            i32.load8_u
                            local.set 3
                            local.get 7
                            i32.const 1
                            i32.add
                            local.set 7
                            br 0 (;@12;)
                          end
                        end
                        local.get 1
                        i32.const 608
                        i32.add
                        local.get 7
                        i32.add
                        i32.const 0
                        i32.store8
                        block  ;; label = @11
                          local.get 1
                          i32.load8_u offset=608
                          br_if 0 (;@11;)
                          i32.const 1463
                          call $kputs
                          drop
                          br 10 (;@1;)
                        end
                        local.get 1
                        i32.const 608
                        i32.add
                        local.get 6
                        i32.const 420
                        call $fs_open
                        local.tee 6
                        i32.const 0
                        i32.lt_s
                        br_if 2 (;@8;)
                        local.get 1
                        i32.const 734
                        i32.add
                        local.set 2
                        loop  ;; label = @11
                          local.get 2
                          i32.const 2
                          i32.add
                          local.set 7
                          local.get 2
                          i32.const 1
                          i32.add
                          local.tee 3
                          local.set 2
                          local.get 7
                          i32.load8_u
                          br_if 0 (;@11;)
                        end
                        local.get 1
                        i32.const 736
                        i32.add
                        local.set 2
                        local.get 3
                        local.get 1
                        i32.const 736
                        i32.add
                        i32.le_u
                        br_if 8 (;@2;)
                        loop  ;; label = @11
                          block  ;; label = @12
                            local.get 3
                            i32.load8_u
                            local.tee 7
                            i32.const 32
                            i32.eq
                            br_if 0 (;@12;)
                            local.get 7
                            i32.const 9
                            i32.ne
                            br_if 10 (;@2;)
                          end
                          local.get 3
                          i32.const 0
                          i32.store8
                          local.get 3
                          i32.const -1
                          i32.add
                          local.tee 3
                          local.get 1
                          i32.const 736
                          i32.add
                          i32.gt_u
                          br_if 0 (;@11;)
                          br 9 (;@2;)
                        end
                      end
                      local.get 2
                      i32.const 1
                      i32.add
                      local.set 2
                      br 0 (;@9;)
                    end
                  end
                  local.get 1
                  local.get 1
                  i32.const 608
                  i32.add
                  i32.store offset=80
                  i32.const 3612
                  local.get 1
                  i32.const 80
                  i32.add
                  call $kprintf
                  drop
                  br 6 (;@1;)
                end
                i32.const 1772
                call $kputs
                drop
                br 5 (;@1;)
              end
              i32.const 5351
              call $kputs
              drop
              br 4 (;@1;)
            end
            i32.const 1
            i32.const 2518
            i32.const 7
            call $wasi_write
            drop
            br 3 (;@1;)
          end
          i32.const 2588
          call $kputs
          drop
          i32.const 1927
          call $kputs
          drop
          i32.const 1664
          call $kputs
          drop
          i32.const 1195
          call $kputs
          drop
          i32.const 1365
          call $kputs
          drop
          i32.const 2944
          call $kputs
          drop
          i32.const 1294
          call $kputs
          drop
          i32.const 1400
          call $kputs
          drop
          i32.const 1247
          call $kputs
          drop
          i32.const 1846
          call $kputs
          drop
          i32.const 2875
          call $kputs
          drop
          i32.const 1876
          call $kputs
          drop
          i32.const 1898
          call $kputs
          drop
          i32.const 1134
          call $kputs
          drop
          i32.const 1163
          call $kputs
          drop
          i32.const 1098
          call $kputs
          drop
          i32.const 1637
          call $kputs
          drop
          i32.const 1502
          call $kputs
          drop
          br 2 (;@1;)
        end
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                block  ;; label = @15
                                  local.get 4
                                  br_if 0 (;@15;)
                                  i32.const 0
                                  local.set 5
                                  i32.const 1362
                                  local.set 3
                                  br 1 (;@14;)
                                end
                                local.get 0
                                i32.const 1
                                i32.add
                                local.set 6
                                i32.const 0
                                local.set 3
                                local.get 4
                                local.set 5
                                block  ;; label = @15
                                  loop  ;; label = @16
                                    local.get 5
                                    i32.const 255
                                    i32.and
                                    local.get 3
                                    i32.const 1359
                                    i32.add
                                    i32.load8_u
                                    local.tee 7
                                    i32.ne
                                    br_if 1 (;@15;)
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
                                    br_if 0 (;@16;)
                                  end
                                  local.get 7
                                  i32.const 1359
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
                                br_if 4 (;@10;)
                                local.get 0
                                i32.const 1
                                i32.add
                                local.set 7
                                i32.const 1600
                                local.set 5
                                local.get 4
                                local.set 3
                                block  ;; label = @15
                                  loop  ;; label = @16
                                    local.get 3
                                    i32.const 255
                                    i32.and
                                    local.get 5
                                    i32.load8_u
                                    i32.ne
                                    br_if 1 (;@15;)
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
                                    br_if 0 (;@16;)
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
                                br_if 1 (;@13;)
                                local.get 0
                                i32.const 1
                                i32.add
                                local.set 6
                                i32.const 0
                                local.set 3
                                local.get 4
                                local.set 5
                                block  ;; label = @15
                                  loop  ;; label = @16
                                    local.get 5
                                    i32.const 255
                                    i32.and
                                    local.get 3
                                    i32.const 1457
                                    i32.add
                                    i32.load8_u
                                    local.tee 7
                                    i32.ne
                                    br_if 1 (;@15;)
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
                                    br_if 0 (;@16;)
                                  end
                                  local.get 7
                                  i32.const 1457
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
                                br_if 2 (;@12;)
                                local.get 0
                                i32.const 1
                                i32.add
                                local.set 7
                                i32.const 1362
                                local.set 3
                                local.get 4
                                local.set 5
                                block  ;; label = @15
                                  loop  ;; label = @16
                                    local.get 5
                                    i32.const 255
                                    i32.and
                                    local.get 3
                                    i32.load8_u
                                    i32.ne
                                    br_if 1 (;@15;)
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
                                    br_if 0 (;@16;)
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
                              br_if 2 (;@11;)
                              local.get 2
                              call $cmd_ls
                              br 12 (;@1;)
                            end
                            local.get 2
                            i32.eqz
                            br_if 3 (;@9;)
                            local.get 2
                            i32.load8_u
                            local.tee 5
                            i32.eqz
                            br_if 3 (;@9;)
                            local.get 2
                            i32.const 1
                            i32.add
                            local.set 3
                            block  ;; label = @13
                              block  ;; label = @14
                                block  ;; label = @15
                                  block  ;; label = @16
                                    loop  ;; label = @17
                                      block  ;; label = @18
                                        local.get 5
                                        i32.const 255
                                        i32.and
                                        i32.const -9
                                        i32.add
                                        br_table 0 (;@18;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 0 (;@18;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 3 (;@15;) 4 (;@14;) 3 (;@15;) 2 (;@16;) 3 (;@15;)
                                      end
                                      local.get 3
                                      i32.load8_u
                                      local.set 5
                                      local.get 3
                                      i32.const 1
                                      i32.add
                                      local.set 3
                                      br 0 (;@17;)
                                    end
                                  end
                                  i32.const -1
                                  local.set 6
                                  br 2 (;@13;)
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
                            block  ;; label = @13
                              local.get 3
                              i32.load8_u
                              local.tee 5
                              i32.const -48
                              i32.add
                              i32.const 255
                              i32.and
                              i32.const 9
                              i32.gt_u
                              br_if 0 (;@13;)
                              local.get 3
                              i32.const 1
                              i32.add
                              local.set 3
                              i32.const 0
                              local.set 7
                              loop  ;; label = @14
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
                                br_if 0 (;@14;)
                              end
                            end
                            block  ;; label = @13
                              local.get 7
                              local.get 6
                              i32.mul
                              local.tee 3
                              i32.const -1
                              i32.gt_s
                              br_if 0 (;@13;)
                              local.get 1
                              local.get 2
                              i32.store offset=16
                              i32.const 3700
                              local.get 1
                              i32.const 16
                              i32.add
                              call $kprintf
                              drop
                              br 12 (;@1;)
                            end
                            block  ;; label = @13
                              local.get 3
                              i32.const 1
                              i32.ne
                              br_if 0 (;@13;)
                              i32.const 1605
                              call $kputs
                              drop
                              br 12 (;@1;)
                            end
                            block  ;; label = @13
                              local.get 3
                              i32.const 9
                              call $process_kill
                              i32.const -1
                              i32.gt_s
                              br_if 0 (;@13;)
                              local.get 1
                              local.get 3
                              i32.store offset=32
                              i32.const 4554
                              local.get 1
                              i32.const 32
                              i32.add
                              call $kprintf
                              drop
                              br 12 (;@1;)
                            end
                            local.get 1
                            local.get 3
                            i32.store offset=48
                            i32.const 4439
                            local.get 1
                            i32.const 48
                            i32.add
                            call $kprintf
                            drop
                            br 11 (;@1;)
                          end
                          block  ;; label = @12
                            i32.const 1281
                            i32.const 2
                            call $spawn_simple
                            local.tee 2
                            i32.const -1
                            i32.gt_s
                            br_if 0 (;@12;)
                            i32.const 1327
                            call $kputs
                            drop
                            br 11 (;@1;)
                          end
                          local.get 1
                          local.get 2
                          i32.store offset=64
                          i32.const 4632
                          local.get 1
                          i32.const 64
                          i32.add
                          call $kprintf
                          drop
                          br 10 (;@1;)
                        end
                        block  ;; label = @11
                          block  ;; label = @12
                            local.get 4
                            br_if 0 (;@12;)
                            i32.const 0
                            local.set 5
                            i32.const 1552
                            local.set 3
                            br 1 (;@11;)
                          end
                          local.get 0
                          i32.const 1
                          i32.add
                          local.set 6
                          i32.const 0
                          local.set 3
                          local.get 4
                          local.set 5
                          block  ;; label = @12
                            loop  ;; label = @13
                              local.get 5
                              i32.const 255
                              i32.and
                              local.get 3
                              i32.const 1243
                              i32.add
                              i32.load8_u
                              local.tee 7
                              i32.ne
                              br_if 1 (;@12;)
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
                              br_if 0 (;@13;)
                            end
                            local.get 7
                            i32.const 1243
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
                          br_if 3 (;@8;)
                          local.get 0
                          i32.const 1
                          i32.add
                          local.set 7
                          i32.const 1766
                          local.set 5
                          local.get 4
                          local.set 3
                          block  ;; label = @12
                            loop  ;; label = @13
                              local.get 3
                              i32.const 255
                              i32.and
                              local.get 5
                              i32.load8_u
                              i32.ne
                              br_if 1 (;@12;)
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
                              br_if 0 (;@13;)
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
                          br_if 4 (;@7;)
                          local.get 0
                          i32.const 1
                          i32.add
                          local.set 6
                          i32.const 0
                          local.set 3
                          local.get 4
                          local.set 5
                          block  ;; label = @12
                            loop  ;; label = @13
                              local.get 5
                              i32.const 255
                              i32.and
                              local.get 3
                              i32.const 1432
                              i32.add
                              i32.load8_u
                              local.tee 7
                              i32.ne
                              br_if 1 (;@12;)
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
                              br_if 0 (;@13;)
                            end
                            local.get 7
                            i32.const 1432
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
                          br_if 5 (;@6;)
                          local.get 0
                          i32.const 1
                          i32.add
                          local.set 7
                          i32.const 1552
                          local.set 3
                          local.get 4
                          local.set 5
                          block  ;; label = @12
                            loop  ;; label = @13
                              local.get 5
                              i32.const 255
                              i32.and
                              local.get 3
                              i32.load8_u
                              i32.ne
                              br_if 1 (;@12;)
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
                              br_if 0 (;@13;)
                            end
                            i32.const 0
                            local.set 5
                          end
                          local.get 5
                          i32.const 255
                          i32.and
                          local.set 5
                        end
                        block  ;; label = @11
                          local.get 5
                          local.get 3
                          i32.load8_u
                          i32.ne
                          br_if 0 (;@11;)
                          local.get 2
                          call $cmd_rm
                          br 10 (;@1;)
                        end
                        block  ;; label = @11
                          block  ;; label = @12
                            local.get 4
                            br_if 0 (;@12;)
                            i32.const 0
                            local.set 3
                            i32.const 1974
                            local.set 2
                            br 1 (;@11;)
                          end
                          local.get 0
                          i32.const 1
                          i32.add
                          local.set 6
                          i32.const 0
                          local.set 3
                          local.get 4
                          local.set 5
                          block  ;; label = @12
                            loop  ;; label = @13
                              local.get 5
                              i32.const 255
                              i32.and
                              local.get 3
                              i32.const 1449
                              i32.add
                              i32.load8_u
                              local.tee 7
                              i32.ne
                              br_if 1 (;@12;)
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
                              br_if 0 (;@13;)
                            end
                            local.get 7
                            i32.const 1449
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
                          br_if 6 (;@5;)
                          local.get 0
                          i32.const 1
                          i32.add
                          local.set 7
                          i32.const 1192
                          local.set 5
                          local.get 4
                          local.set 3
                          block  ;; label = @12
                            loop  ;; label = @13
                              local.get 3
                              i32.const 255
                              i32.and
                              local.get 5
                              i32.load8_u
                              i32.ne
                              br_if 1 (;@12;)
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
                              br_if 0 (;@13;)
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
                          br_if 7 (;@4;)
                          local.get 0
                          i32.const 1
                          i32.add
                          local.set 6
                          i32.const 0
                          local.set 3
                          local.get 4
                          local.set 5
                          block  ;; label = @12
                            loop  ;; label = @13
                              local.get 5
                              i32.const 255
                              i32.and
                              local.get 3
                              i32.const 2441
                              i32.add
                              i32.load8_u
                              local.tee 7
                              i32.ne
                              br_if 1 (;@12;)
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
                              br_if 0 (;@13;)
                            end
                            local.get 7
                            i32.const 2441
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
                          br_if 8 (;@3;)
                          local.get 0
                          i32.const 1
                          i32.add
                          local.set 5
                          i32.const 1974
                          local.set 2
                          local.get 4
                          local.set 3
                          block  ;; label = @12
                            loop  ;; label = @13
                              local.get 3
                              i32.const 255
                              i32.and
                              local.get 2
                              i32.load8_u
                              i32.ne
                              br_if 1 (;@12;)
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
                              br_if 0 (;@13;)
                            end
                            i32.const 0
                            local.set 3
                          end
                          local.get 3
                          i32.const 255
                          i32.and
                          local.set 3
                        end
                        block  ;; label = @11
                          local.get 3
                          local.get 2
                          i32.load8_u
                          i32.ne
                          br_if 0 (;@11;)
                          call $cmd_pwd
                          br 10 (;@1;)
                        end
                        local.get 4
                        i32.eqz
                        br_if 9 (;@1;)
                        i32.const 0
                        local.set 2
                        block  ;; label = @11
                          loop  ;; label = @12
                            local.get 4
                            i32.const 255
                            i32.and
                            local.get 2
                            i32.const 1238
                            i32.add
                            i32.load8_u
                            local.tee 3
                            i32.ne
                            br_if 1 (;@11;)
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
                            br_if 0 (;@12;)
                          end
                          local.get 5
                          i32.const 1238
                          i32.add
                          i32.load8_u
                          local.set 3
                          i32.const 0
                          local.set 4
                        end
                        block  ;; label = @11
                          local.get 4
                          i32.const 255
                          i32.and
                          local.get 3
                          i32.const 255
                          i32.and
                          i32.ne
                          br_if 0 (;@11;)
                          i32.const 3013
                          call $kputs
                          drop
                          br 10 (;@1;)
                        end
                        local.get 1
                        local.get 0
                        i32.store
                        i32.const 4195
                        local.get 1
                        call $kprintf
                        drop
                        br 9 (;@1;)
                      end
                      call $process_dump_table
                      br 8 (;@1;)
                    end
                    i32.const 2526
                    call $kputs
                    drop
                    br 7 (;@1;)
                  end
                  local.get 2
                  call $cmd_cat
                  br 6 (;@1;)
                end
                local.get 2
                call $cmd_touch
                br 5 (;@1;)
              end
              local.get 2
              call $cmd_mkdir
              br 4 (;@1;)
            end
            local.get 2
            call $cmd_cp
            br 3 (;@1;)
          end
          local.get 2
          call $cmd_mv
          br 2 (;@1;)
        end
        local.get 2
        call $cmd_cd
        br 1 (;@1;)
      end
      loop  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  local.get 2
                  i32.load8_u
                  local.tee 3
                  br_table 2 (;@5;) 1 (;@6;) 1 (;@6;) 1 (;@6;) 1 (;@6;) 1 (;@6;) 1 (;@6;) 1 (;@6;) 1 (;@6;) 4 (;@3;) 0 (;@7;)
                end
                local.get 3
                i32.const 32
                i32.eq
                br_if 3 (;@3;)
              end
              local.get 2
              i32.const 1
              i32.add
              local.set 2
              i32.const 0
              local.set 7
              loop  ;; label = @6
                block  ;; label = @7
                  local.get 3
                  i32.const 255
                  i32.and
                  i32.const 34
                  i32.eq
                  br_if 0 (;@7;)
                  local.get 1
                  i32.const 96
                  i32.add
                  local.get 7
                  i32.add
                  local.get 3
                  i32.store8
                  local.get 7
                  i32.const 1
                  i32.add
                  local.set 7
                end
                local.get 2
                i32.load8_u
                local.tee 3
                i32.eqz
                br_if 2 (;@4;)
                local.get 2
                i32.const 1
                i32.add
                local.set 2
                local.get 7
                i32.const 511
                i32.lt_u
                br_if 0 (;@6;)
                br 2 (;@4;)
              end
            end
            i32.const 0
            local.set 7
          end
          local.get 1
          i32.const 96
          i32.add
          local.get 7
          i32.add
          i32.const 0
          i32.store8
          local.get 1
          i32.load8_u offset=96
          local.set 2
          block  ;; label = @4
            local.get 5
            i32.const 62
            i32.eq
            br_if 0 (;@4;)
            block  ;; label = @5
              local.get 2
              i32.const 255
              i32.and
              i32.eqz
              br_if 0 (;@5;)
              local.get 1
              i32.const 96
              i32.add
              call $kputs
              drop
              br 4 (;@1;)
            end
            i32.const 5351
            call $kputs
            drop
            br 3 (;@1;)
          end
          block  ;; label = @4
            local.get 2
            i32.const 255
            i32.and
            i32.eqz
            br_if 0 (;@4;)
            i32.const 0
            local.set 2
            loop  ;; label = @5
              local.get 1
              i32.const 96
              i32.add
              local.get 2
              i32.add
              local.set 3
              local.get 2
              i32.const 1
              i32.add
              local.tee 5
              local.set 2
              local.get 3
              i32.load8_u
              br_if 0 (;@5;)
            end
            local.get 6
            local.get 1
            i32.const 96
            i32.add
            local.get 5
            i32.const -1
            i32.add
            call $fs_write
            drop
          end
          local.get 6
          i32.const 5346
          i32.const 1
          call $fs_write
          drop
          local.get 6
          call $fs_close
          drop
          br 2 (;@1;)
        end
        local.get 2
        i32.const 1
        i32.add
        local.set 2
        br 0 (;@2;)
      end
    end
    local.get 1
    i32.const 1248
    i32.add
    global.set $__stack_pointer)
  (func $cmd_ls (type 5) (param i32)
    (local i32 i32 i32)
    global.get $__stack_pointer
    i32.const 576
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        i32.load8_u
        br_if 1 (;@1;)
      end
      local.get 1
      i32.const 48
      i32.add
      i32.const 2700
      local.get 1
      i32.const 48
      i32.add
      i32.const 256
      call $fs_getcwd
      select
      local.set 0
    end
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        call $fs_opendir
        local.tee 2
        i32.const 0
        i32.lt_s
        br_if 0 (;@2;)
        block  ;; label = @3
          local.get 2
          local.get 1
          i32.const 312
          i32.add
          call $fs_readdir
          br_if 0 (;@3;)
          local.get 1
          local.get 1
          i32.const 316
          i32.add
          local.tee 3
          i32.store offset=32
          i32.const 1423
          local.get 1
          i32.const 32
          i32.add
          call $kprintf
          drop
          block  ;; label = @4
            local.get 2
            local.get 1
            i32.const 312
            i32.add
            call $fs_readdir
            br_if 0 (;@4;)
            i32.const 1
            local.set 0
            loop  ;; label = @5
              block  ;; label = @6
                local.get 0
                i32.const 7
                i32.and
                br_if 0 (;@6;)
                i32.const 5351
                call $kputs
                drop
              end
              local.get 1
              local.get 3
              i32.store offset=16
              i32.const 1423
              local.get 1
              i32.const 16
              i32.add
              call $kprintf
              drop
              local.get 0
              i32.const 1
              i32.add
              local.set 0
              local.get 2
              local.get 1
              i32.const 312
              i32.add
              call $fs_readdir
              i32.eqz
              br_if 0 (;@5;)
            end
          end
          i32.const 5351
          call $kputs
          drop
        end
        local.get 2
        call $fs_closedir
        drop
        br 1 (;@1;)
      end
      local.get 1
      local.get 0
      i32.store
      i32.const 3229
      local.get 1
      call $kprintf
      drop
    end
    local.get 1
    i32.const 576
    i32.add
    global.set $__stack_pointer)
  (func $test_process_entry (type 4) (param i32 i32) (result i32)
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
    i32.const 5184
    local.get 2
    i32.const 80
    i32.add
    call $kprintf
    drop
    local.get 2
    i32.const 0
    i32.store offset=64
    i32.const 4462
    local.get 2
    i32.const 64
    i32.add
    call $kprintf
    drop
    call $scheduler_yield
    local.get 2
    i32.const 1
    i32.store offset=48
    i32.const 4462
    local.get 2
    i32.const 48
    i32.add
    call $kprintf
    drop
    call $scheduler_yield
    local.get 2
    i32.const 2
    i32.store offset=32
    i32.const 4462
    local.get 2
    i32.const 32
    i32.add
    call $kprintf
    drop
    call $scheduler_yield
    local.get 2
    i32.const 3
    i32.store offset=16
    i32.const 4462
    local.get 2
    i32.const 16
    i32.add
    call $kprintf
    drop
    call $scheduler_yield
    local.get 2
    i32.const 4
    i32.store
    i32.const 4462
    local.get 2
    call $kprintf
    drop
    call $scheduler_yield
    i32.const 4029
    i32.const 0
    call $kprintf
    drop
    local.get 2
    i32.const 96
    i32.add
    global.set $__stack_pointer
    i32.const 0)
  (func $cmd_rm (type 5) (param i32)
    (local i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 48
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                local.get 0
                i32.eqz
                br_if 0 (;@6;)
                local.get 0
                i32.load8_u
                local.tee 2
                i32.const 45
                i32.eq
                br_if 1 (;@5;)
                local.get 2
                i32.eqz
                br_if 0 (;@6;)
                i32.const 3022
                local.set 3
                local.get 2
                local.set 4
                br 2 (;@4;)
              end
              i32.const 2001
              call $kputs
              drop
              br 4 (;@1;)
            end
            block  ;; label = @5
              local.get 0
              i32.load8_u offset=1
              local.tee 4
              i32.const 114
              i32.eq
              br_if 0 (;@5;)
              i32.const 3023
              local.set 3
              br 1 (;@4;)
            end
            local.get 0
            i32.load8_u offset=2
            local.tee 4
            i32.const 32
            i32.eq
            br_if 1 (;@3;)
            i32.const 3024
            local.set 3
          end
          local.get 4
          local.get 3
          i32.load8_u
          i32.eq
          br_if 0 (;@3;)
          block  ;; label = @4
            block  ;; label = @5
              local.get 2
              i32.const 45
              i32.eq
              br_if 0 (;@5;)
              i32.const 5348
              local.set 5
              local.get 2
              local.set 3
              br 1 (;@4;)
            end
            block  ;; label = @5
              local.get 0
              i32.load8_u offset=1
              local.tee 3
              i32.const 114
              i32.eq
              br_if 0 (;@5;)
              i32.const 5349
              local.set 5
              br 1 (;@4;)
            end
            local.get 0
            i32.load8_u offset=2
            local.tee 3
            i32.const 9
            i32.eq
            br_if 1 (;@3;)
            i32.const 5350
            local.set 5
          end
          i32.const 1
          local.set 4
          local.get 3
          local.get 5
          i32.load8_u
          i32.ne
          br_if 1 (;@2;)
        end
        local.get 0
        i32.const 3
        i32.add
        local.set 0
        block  ;; label = @3
          loop  ;; label = @4
            block  ;; label = @5
              local.get 0
              i32.load8_u
              local.tee 2
              i32.const 32
              i32.eq
              br_if 0 (;@5;)
              local.get 2
              i32.const 9
              i32.ne
              br_if 2 (;@3;)
            end
            local.get 0
            i32.const 1
            i32.add
            local.set 0
            br 0 (;@4;)
          end
        end
        i32.const 0
        local.set 4
      end
      block  ;; label = @2
        local.get 2
        br_if 0 (;@2;)
        i32.const 2001
        call $kputs
        drop
        br 1 (;@1;)
      end
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          local.get 1
          i32.const 16
          i32.add
          call $fs_stat
          i32.const 0
          i32.ge_s
          br_if 0 (;@3;)
          i32.const 3329
          local.set 2
          br 1 (;@2;)
        end
        block  ;; label = @3
          local.get 1
          i32.load8_u offset=21
          i32.const 64
          i32.and
          i32.eqz
          br_if 0 (;@3;)
          block  ;; label = @4
            local.get 4
            i32.eqz
            br_if 0 (;@4;)
            i32.const 5119
            local.set 2
            br 2 (;@2;)
          end
          i32.const 3092
          i32.const 3636
          local.get 0
          call $fs_rmdir
          i32.const 0
          i32.lt_s
          select
          local.set 2
          br 1 (;@2;)
        end
        i32.const 3844
        i32.const 3723
        local.get 0
        call $fs_unlink
        i32.const 0
        i32.lt_s
        select
        local.set 2
      end
      local.get 1
      local.get 0
      i32.store
      local.get 2
      local.get 1
      call $kprintf
      drop
    end
    local.get 1
    i32.const 48
    i32.add
    global.set $__stack_pointer)
  (func $cmd_pwd (type 7)
    (local i32)
    global.get $__stack_pointer
    i32.const 256
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    local.get 0
    i32.const 1061
    local.get 0
    i32.const 256
    call $fs_getcwd
    select
    call $kputs
    drop
    local.get 0
    i32.const 256
    i32.add
    global.set $__stack_pointer)
  (func $cmd_cat (type 5) (param i32)
    (local i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 288
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            i32.eqz
            br_if 0 (;@4;)
            local.get 0
            i32.load8_u
            local.tee 2
            i32.eqz
            br_if 0 (;@4;)
            i32.const 0
            local.set 3
            local.get 2
            local.set 4
            block  ;; label = @5
              loop  ;; label = @6
                local.get 4
                i32.const 255
                i32.and
                local.get 3
                i32.const 1538
                i32.add
                i32.load8_u
                local.tee 5
                i32.ne
                br_if 1 (;@5;)
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
                br_if 0 (;@6;)
              end
              local.get 5
              i32.const 1538
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
            br_if 1 (;@3;)
            i32.const 0
            local.set 3
            block  ;; label = @5
              loop  ;; label = @6
                local.get 2
                i32.const 255
                i32.and
                local.get 3
                i32.const 1962
                i32.add
                i32.load8_u
                local.tee 4
                i32.ne
                br_if 1 (;@5;)
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
                br_if 0 (;@6;)
              end
              local.get 5
              i32.const 1962
              i32.add
              i32.load8_u
              local.set 4
              i32.const 0
              local.set 2
            end
            block  ;; label = @5
              local.get 2
              i32.const 255
              i32.and
              local.get 4
              i32.const 255
              i32.and
              i32.ne
              br_if 0 (;@5;)
              i32.const 1695
              call $kputs
              drop
              i32.const 1725
              call $kputs
              drop
              br 4 (;@1;)
            end
            local.get 0
            i32.const 0
            i32.const 0
            call $fs_open
            local.tee 4
            i32.const 0
            i32.lt_s
            br_if 2 (;@2;)
            block  ;; label = @5
              local.get 4
              local.get 1
              i32.const 32
              i32.add
              i32.const 255
              call $fs_read
              local.tee 3
              i32.const 1
              i32.lt_s
              br_if 0 (;@5;)
              loop  ;; label = @6
                local.get 1
                i32.const 32
                i32.add
                local.get 3
                i32.add
                i32.const 0
                i32.store8
                local.get 1
                local.get 1
                i32.const 32
                i32.add
                i32.store offset=16
                i32.const 1429
                local.get 1
                i32.const 16
                i32.add
                call $kprintf
                drop
                local.get 4
                local.get 1
                i32.const 32
                i32.add
                i32.const 255
                call $fs_read
                local.tee 3
                i32.const 0
                i32.gt_s
                br_if 0 (;@6;)
              end
            end
            local.get 4
            call $fs_close
            drop
            br 3 (;@1;)
          end
          i32.const 2120
          call $kputs
          drop
          br 2 (;@1;)
        end
        i32.const 2665
        call $kputs
        drop
        br 1 (;@1;)
      end
      local.get 1
      local.get 0
      i32.store
      i32.const 3158
      local.get 1
      call $kprintf
      drop
    end
    local.get 1
    i32.const 288
    i32.add
    global.set $__stack_pointer)
  (func $cmd_touch (type 5) (param i32)
    (local i32 i32)
    global.get $__stack_pointer
    i32.const 32
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
          br_if 1 (;@2;)
        end
        i32.const 2171
        call $kputs
        drop
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 0
        i32.const 65
        i32.const 420
        call $fs_open
        local.tee 2
        i32.const -1
        i32.gt_s
        br_if 0 (;@2;)
        local.get 1
        local.get 0
        i32.store
        i32.const 3790
        local.get 1
        call $kprintf
        drop
        br 1 (;@1;)
      end
      local.get 2
      call $fs_close
      drop
      local.get 1
      local.get 0
      i32.store offset=16
      i32.const 3682
      local.get 1
      i32.const 16
      i32.add
      call $kprintf
      drop
    end
    local.get 1
    i32.const 32
    i32.add
    global.set $__stack_pointer)
  (func $cmd_mkdir (type 5) (param i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 32
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
          br_if 1 (;@2;)
        end
        i32.const 1978
        call $kputs
        drop
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 0
        i32.const 493
        call $fs_mkdir
        i32.const -1
        i32.gt_s
        br_if 0 (;@2;)
        local.get 1
        local.get 0
        i32.store
        i32.const 5222
        local.get 1
        call $kprintf
        drop
        br 1 (;@1;)
      end
      local.get 1
      local.get 0
      i32.store offset=16
      i32.const 3659
      local.get 1
      i32.const 16
      i32.add
      call $kprintf
      drop
    end
    local.get 1
    i32.const 32
    i32.add
    global.set $__stack_pointer)
  (func $cmd_cp (type 5) (param i32)
    (local i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 304
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
          local.get 0
          local.set 3
          block  ;; label = @4
            block  ;; label = @5
              loop  ;; label = @6
                local.get 2
                i32.const 255
                i32.and
                local.tee 2
                i32.eqz
                br_if 1 (;@5;)
                local.get 2
                i32.const 32
                i32.eq
                br_if 2 (;@4;)
                local.get 3
                i32.const 1
                i32.add
                local.tee 3
                i32.load8_u
                local.set 2
                br 0 (;@6;)
              end
            end
            i32.const 2058
            call $kputs
            drop
            br 3 (;@1;)
          end
          local.get 3
          i32.const 0
          i32.store8
          loop  ;; label = @4
            local.get 3
            i32.const 1
            i32.add
            local.tee 3
            i32.load8_u
            local.tee 2
            i32.const 32
            i32.eq
            br_if 0 (;@4;)
          end
          block  ;; label = @4
            local.get 2
            br_if 0 (;@4;)
            i32.const 2058
            call $kputs
            drop
            br 3 (;@1;)
          end
          block  ;; label = @4
            local.get 0
            i32.const 0
            i32.const 0
            call $fs_open
            local.tee 4
            i32.const -1
            i32.gt_s
            br_if 0 (;@4;)
            local.get 1
            local.get 0
            i32.store
            i32.const 3280
            local.get 1
            call $kprintf
            drop
            br 3 (;@1;)
          end
          local.get 3
          i32.const 577
          i32.const 420
          call $fs_open
          local.tee 5
          i32.const 0
          i32.lt_s
          br_if 1 (;@2;)
          block  ;; label = @4
            loop  ;; label = @5
              local.get 4
              local.get 1
              i32.const 48
              i32.add
              i32.const 256
              call $fs_read
              local.tee 2
              i32.const 1
              i32.lt_s
              br_if 1 (;@4;)
              local.get 5
              local.get 1
              i32.const 48
              i32.add
              local.get 2
              call $fs_write
              local.get 2
              i32.eq
              br_if 0 (;@5;)
            end
            i32.const 3896
            i32.const 0
            call $kprintf
            drop
          end
          local.get 4
          call $fs_close
          drop
          local.get 5
          call $fs_close
          drop
          local.get 1
          local.get 3
          i32.store offset=36
          local.get 1
          local.get 0
          i32.store offset=32
          i32.const 5279
          local.get 1
          i32.const 32
          i32.add
          call $kprintf
          drop
          br 2 (;@1;)
        end
        i32.const 2146
        call $kputs
        drop
        br 1 (;@1;)
      end
      local.get 1
      local.get 3
      i32.store offset=16
      i32.const 5324
      local.get 1
      i32.const 16
      i32.add
      call $kprintf
      drop
      local.get 4
      call $fs_close
      drop
    end
    local.get 1
    i32.const 304
    i32.add
    global.set $__stack_pointer)
  (func $cmd_mv (type 5) (param i32)
    (local i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        i32.load8_u
        local.tee 2
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        local.set 3
        block  ;; label = @3
          block  ;; label = @4
            loop  ;; label = @5
              local.get 2
              i32.const 255
              i32.and
              local.tee 2
              i32.eqz
              br_if 1 (;@4;)
              local.get 2
              i32.const 32
              i32.eq
              br_if 2 (;@3;)
              local.get 3
              i32.const 1
              i32.add
              local.tee 3
              i32.load8_u
              local.set 2
              br 0 (;@5;)
            end
          end
          i32.const 2021
          call $kputs
          drop
          br 2 (;@1;)
        end
        local.get 3
        i32.const 0
        i32.store8
        local.get 3
        local.set 2
        loop  ;; label = @3
          local.get 2
          i32.const 1
          i32.add
          local.tee 2
          i32.load8_u
          local.tee 4
          i32.const 32
          i32.eq
          br_if 0 (;@3;)
        end
        block  ;; label = @3
          local.get 4
          br_if 0 (;@3;)
          i32.const 2021
          call $kputs
          drop
          br 2 (;@1;)
        end
        local.get 0
        call $cmd_cp
        local.get 3
        i32.const 32
        i32.store8
        block  ;; label = @3
          local.get 0
          call $fs_unlink
          i32.const -1
          i32.gt_s
          br_if 0 (;@3;)
          local.get 1
          local.get 0
          i32.store
          i32.const 5300
          local.get 1
          call $kprintf
          drop
          br 2 (;@1;)
        end
        local.get 1
        local.get 2
        i32.store offset=20
        local.get 1
        local.get 0
        i32.store offset=16
        i32.const 5259
        local.get 1
        i32.const 16
        i32.add
        call $kprintf
        drop
        br 1 (;@1;)
      end
      i32.const 2095
      call $kputs
      drop
    end
    local.get 1
    i32.const 32
    i32.add
    global.set $__stack_pointer)
  (func $cmd_cd (type 5) (param i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        br_if 0 (;@2;)
        i32.const 2700
        local.set 0
        br 1 (;@1;)
      end
      local.get 0
      i32.const 2700
      local.get 0
      i32.load8_u
      select
      local.set 0
    end
    block  ;; label = @1
      local.get 0
      call $fs_chdir
      i32.const -1
      i32.gt_s
      br_if 0 (;@1;)
      local.get 1
      local.get 0
      i32.store
      i32.const 3194
      local.get 1
      call $kprintf
      drop
    end
    local.get 1
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $shell_main (type 7)
    (local i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 560
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    i32.const 5351
    call $kputs
    drop
    i32.const 2989
    call $kputs
    drop
    i32.const 2702
    call $kputs
    drop
    i32.const 5351
    call $kputs
    drop
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.const 304
        i32.add
        i32.const 256
        call $fs_getcwd
        i32.eqz
        br_if 0 (;@2;)
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            i32.load8_u offset=304
            local.tee 1
            br_if 0 (;@4;)
            i32.const 0
            local.set 2
            br 1 (;@3;)
          end
          local.get 0
          i32.const 304
          i32.add
          i32.const 1
          i32.or
          local.set 3
          i32.const 0
          local.set 4
          loop  ;; label = @4
            local.get 0
            local.get 4
            i32.add
            local.get 1
            i32.store8
            local.get 4
            i32.const 1
            i32.add
            local.set 2
            local.get 3
            local.get 4
            i32.add
            i32.load8_u
            local.tee 1
            i32.eqz
            br_if 1 (;@3;)
            local.get 4
            i32.const 296
            i32.lt_u
            local.set 5
            local.get 2
            local.set 4
            local.get 5
            br_if 0 (;@4;)
          end
        end
        local.get 0
        local.get 2
        i32.add
        i32.const 2106426
        i32.store align=1
        i32.const 1
        local.get 0
        local.get 2
        i32.const 3
        i32.add
        call $wasi_write
        drop
        br 1 (;@1;)
      end
      i32.const 1
      i32.const 3053
      i32.const 2
      call $wasi_write
      drop
    end
    local.get 0
    i32.const 560
    i32.add
    global.set $__stack_pointer)
  (func $handle_command (type 5) (param i32)
    (local i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 560
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    i32.const 2
    local.set 2
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          loop  ;; label = @4
            local.get 0
            local.get 2
            i32.add
            local.tee 3
            i32.const -2
            i32.add
            i32.load8_u
            local.tee 4
            i32.eqz
            br_if 2 (;@2;)
            local.get 2
            i32.const 33635102
            i32.add
            local.get 4
            i32.store8
            local.get 3
            i32.const -1
            i32.add
            i32.load8_u
            local.tee 4
            i32.eqz
            br_if 1 (;@3;)
            local.get 2
            i32.const 33635103
            i32.add
            local.get 4
            i32.store8
            local.get 3
            i32.load8_u
            local.tee 3
            i32.eqz
            br_if 3 (;@1;)
            local.get 2
            i32.const 33635104
            i32.add
            local.get 3
            i32.store8
            local.get 2
            i32.const 3
            i32.add
            local.tee 2
            i32.const 257
            i32.ne
            br_if 0 (;@4;)
          end
          i32.const 255
          local.set 2
          br 2 (;@1;)
        end
        local.get 2
        i32.const -1
        i32.add
        local.set 2
        br 1 (;@1;)
      end
      local.get 2
      i32.const -2
      i32.add
      local.set 2
    end
    i32.const 0
    local.set 3
    local.get 2
    i32.const 33635104
    i32.add
    i32.const 0
    i32.store8
    i32.const 33635104
    call $execute_command
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i32.const 304
        i32.add
        i32.const 256
        call $fs_getcwd
        i32.eqz
        br_if 0 (;@2;)
        block  ;; label = @3
          local.get 1
          i32.load8_u offset=304
          local.tee 4
          i32.eqz
          br_if 0 (;@3;)
          local.get 1
          i32.const 304
          i32.add
          i32.const 1
          i32.or
          local.set 5
          i32.const 0
          local.set 2
          loop  ;; label = @4
            local.get 1
            local.get 2
            i32.add
            local.get 4
            i32.store8
            local.get 2
            i32.const 1
            i32.add
            local.set 3
            local.get 5
            local.get 2
            i32.add
            i32.load8_u
            local.tee 4
            i32.eqz
            br_if 1 (;@3;)
            local.get 2
            i32.const 296
            i32.lt_u
            local.set 0
            local.get 3
            local.set 2
            local.get 0
            br_if 0 (;@4;)
          end
        end
        local.get 1
        local.get 3
        i32.add
        i32.const 2106426
        i32.store align=1
        i32.const 1
        local.get 1
        local.get 3
        i32.const 3
        i32.add
        call $wasi_write
        drop
        br 1 (;@1;)
      end
      i32.const 1
      i32.const 3053
      i32.const 2
      call $wasi_write
      drop
    end
    local.get 1
    i32.const 560
    i32.add
    global.set $__stack_pointer)
  (func $process_init (type 0) (result i32)
    (local i32)
    i32.const 4924
    i32.const 0
    call $kprintf
    drop
    i32.const -7184
    local.set 0
    loop  ;; label = @1
      local.get 0
      i32.const 33642544
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
      i32.const 33642680
      i32.add
      i32.const 0
      i32.store
      local.get 0
      i32.const 33642528
      i32.add
      i32.const -1
      i32.store
      local.get 0
      i32.const 33642568
      i32.add
      i32.const 0
      i32.store
      local.get 0
      i32.const 33642792
      i32.add
      i32.const 0
      i32.store
      local.get 0
      i32.const 33642640
      i32.add
      i32.const -1
      i32.store
      local.get 0
      i32.const 33642904
      i32.add
      i32.const 0
      i32.store
      local.get 0
      i32.const 33642752
      i32.add
      i32.const -1
      i32.store
      local.get 0
      i32.const 33642864
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
      i32.const 33635360
      i32.const 5352
      i32.const 112
      memory.copy
    end
    block  ;; label = @1
      local.get 0
      br_if 0 (;@1;)
      i32.const 33635472
      i32.const 5464
      i32.const 112
      memory.copy
    end
    i32.const 0
    i32.const 33635472
    i32.store offset=33642528
    i32.const 0
    i64.const 8589934594
    i64.store offset=33642536
    i32.const 4254
    i32.const 0
    call $kprintf
    drop
    i32.const 0)
  (func $process_create (type 3) (param i32 i32 i32 i32) (result i32)
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
                  i32.const 33635512
                  i32.add
                  i32.load
                  i32.eqz
                  br_if 1 (;@6;)
                  local.get 5
                  i32.const 33635624
                  i32.add
                  i32.load
                  i32.eqz
                  br_if 2 (;@5;)
                  local.get 5
                  i32.const 33635736
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
              i32.const 33635472
              i32.add
              local.set 6
              br 2 (;@3;)
            end
            local.get 5
            i32.const 33635584
            i32.add
            local.set 6
            br 1 (;@3;)
          end
          local.get 5
          i32.const 33635696
          i32.add
          local.set 6
        end
        i32.const 0
        local.set 5
        local.get 6
        i32.const 0
        i32.load offset=33642536
        local.tee 7
        i32.store
        i32.const 0
        local.get 7
        i32.const 1
        i32.add
        i32.store offset=33642536
        i32.const 0
        local.set 7
        block  ;; label = @3
          i32.const 0
          i32.load offset=33642528
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
          i32.const 4503
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
        i32.load offset=33642540
        i32.const 1
        i32.add
        i32.store offset=33642540
        local.get 4
        local.get 6
        i32.load
        i32.store offset=16
        local.get 4
        local.get 9
        i32.store offset=20
        i32.const 3736
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
      i32.const 4152
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
    i32.load offset=33642528)
  (func $process_find (type 8) (param i32) (result i32)
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
      i32.const 33635360
      i32.add
      i32.const 0
      local.get 0
      i32.const 33635400
      i32.add
      i32.load
      select
      local.set 1
    end
    local.get 1)
  (func $process_kill (type 4) (param i32 i32) (result i32)
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
          i32.const 33635400
          i32.add
          i32.load
          br_if 1 (;@2;)
        end
        local.get 2
        local.get 0
        i32.store
        i32.const 4222
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
        i32.const 3502
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
      i32.const 4587
      local.get 2
      i32.const 32
      i32.add
      call $kprintf
      drop
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 3
            i32.const 33635360
            i32.add
            local.tee 3
            i32.load offset=40
            br_table 0 (;@4;) 2 (;@2;) 1 (;@3;) 2 (;@2;) 2 (;@2;) 2 (;@2;) 0 (;@4;) 2 (;@2;)
          end
          local.get 2
          local.get 0
          i32.store offset=16
          i32.const 4398
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
      i32.load offset=33642540
      i32.const -1
      i32.add
      i32.store offset=33642540
    end
    local.get 2
    i32.const 48
    i32.add
    global.set $__stack_pointer
    local.get 0)
  (func $process_dump_table (type 7)
    (local i32 i32 i32 i64)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    i32.const 0
    local.set 1
    i32.const 4851
    i32.const 0
    call $kprintf
    drop
    i32.const 4790
    i32.const 0
    call $kprintf
    drop
    i32.const 5079
    i32.const 0
    call $kprintf
    drop
    loop  ;; label = @1
      i32.const 3074
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
                      i32.const 33635400
                      i32.add
                      i32.load
                      br_table 7 (;@2;) 6 (;@3;) 0 (;@9;) 1 (;@8;) 2 (;@7;) 3 (;@6;) 4 (;@5;) 5 (;@4;)
                    end
                    i32.const 3065
                    local.set 2
                    br 5 (;@3;)
                  end
                  i32.const 3044
                  local.set 2
                  br 4 (;@3;)
                end
                i32.const 3035
                local.set 2
                br 3 (;@3;)
              end
              i32.const 3056
              local.set 2
              br 2 (;@3;)
            end
            i32.const 3083
            local.set 2
            br 1 (;@3;)
          end
          i32.const 3026
          local.set 2
        end
        local.get 1
        i32.const 33635360
        i32.add
        i64.load
        local.set 3
        local.get 0
        local.get 1
        i32.const 33635368
        i32.add
        i32.store offset=28
        local.get 0
        local.get 2
        i32.store offset=24
        local.get 0
        local.get 3
        i64.store offset=16
        i32.const 3770
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
    i32.load offset=33642540
    i32.store
    i32.const 4704
    local.get 0
    call $kprintf
    drop
    local.get 0
    i32.const 32
    i32.add
    global.set $__stack_pointer)
  (func $scheduler_init (type 7)
    i32.const 5003
    i32.const 0
    call $kprintf
    drop
    i32.const 0
    i64.const 0
    i64.store offset=33642552
    i32.const 0
    i32.const 1
    i32.store8 offset=33642560
    i32.const 0
    i32.const 0
    i32.store offset=33642548
    i32.const 0
    i32.const 0
    i32.store offset=33642544
    i32.const 4330
    i32.const 0
    call $kprintf
    drop)
  (func $scheduler_add_ready (type 5) (param i32)
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
          i32.load offset=33642544
          br_if 0 (;@3;)
          i32.const 0
          local.get 0
          i32.store offset=33642544
          br 1 (;@2;)
        end
        i32.const 0
        i32.load offset=33642548
        local.tee 2
        local.get 0
        i32.store offset=104
        local.get 0
        local.get 2
        i32.store offset=108
      end
      i32.const 0
      local.get 0
      i32.store offset=33642548
      local.get 1
      local.get 0
      i32.load
      i32.store
      i32.const 4058
      local.get 1
      call $kprintf
      drop
    end
    local.get 1
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $scheduler_remove_ready (type 5) (param i32)
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
        i32.store offset=33642544
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
        i32.store offset=33642548
      end
      local.get 0
      i64.const 0
      i64.store offset=104
      local.get 1
      local.get 0
      i32.load
      i32.store
      i32.const 4103
      local.get 1
      call $kprintf
      drop
    end
    local.get 1
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $scheduler_yield (type 7)
    (local i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 64
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    block  ;; label = @1
      i32.const 0
      i32.load8_u offset=33642560
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
      i32.const 4753
      local.get 0
      i32.const 48
      i32.add
      call $kprintf
      drop
      block  ;; label = @2
        block  ;; label = @3
          i32.const 0
          i32.load offset=33642544
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
            i32.store offset=33642544
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
            i32.store offset=33642548
          end
          local.get 2
          i64.const 0
          i64.store offset=104
          local.get 0
          local.get 2
          i32.load
          i32.store offset=32
          i32.const 4103
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
        i32.const 3577
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
      i32.const 4666
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
            i32.load offset=33642544
            br_if 0 (;@4;)
            i32.const 0
            local.get 1
            i32.store offset=33642544
            br 1 (;@3;)
          end
          i32.const 0
          i32.load offset=33642548
          local.tee 3
          local.get 1
          i32.store offset=104
          local.get 1
          local.get 3
          i32.store offset=108
        end
        i32.const 0
        local.get 1
        i32.store offset=33642548
        local.get 0
        local.get 1
        i32.load
        i32.store
        i32.const 4058
        local.get 0
        call $kprintf
        drop
      end
      i32.const 33635360
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
  (func $spawn_simple (type 4) (param i32 i32) (result i32)
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
    i32.const 5042
    i32.const 0
    call $kprintf
    drop
    i32.const -1024
    local.set 0
    loop  ;; label = @1
      local.get 0
      i32.const 33643644
      i32.add
      i64.const 68719476736
      i64.store align=4
      local.get 0
      i32.const 33643636
      i32.add
      i64.const 0
      i64.store align=4
      local.get 0
      i32.const 33643628
      i32.add
      i64.const 68719476736
      i64.store align=4
      local.get 0
      i32.const 33643620
      i32.add
      i64.const 0
      i64.store align=4
      local.get 0
      i32.const 33643612
      i32.add
      i64.const 68719476736
      i64.store align=4
      local.get 0
      i32.const 33643604
      i32.add
      i64.const 0
      i64.store align=4
      local.get 0
      i32.const 33643596
      i32.add
      i64.const 68719476736
      i64.store align=4
      local.get 0
      i32.const 33643588
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
    i32.store8 offset=33643588
    i32.const 4365
    i32.const 0
    call $kprintf
    drop
    i32.const 0)
  (table (;0;) 3 3 funcref)
  (global $__stack_pointer (mut i32) (i32.const 34692176))
  (global $__tls_base (mut i32) (i32.const 0))
  (export "_start" (func $_start))
  (export "handle_command" (func $handle_command))
  (start $__wasm_init_memory)
  (elem (;0;) (i32.const 1) func $console_init $test_process_entry)
  (data $.rodata "0123456789abcdefghijklmnopqrstuvwxyz\00pwd: error getting current directory\00  pwd     - Print working directory\00  mkdir   - Create directory\00  cd      - Change directory\00mv\00  echo    - Echo arguments to stdout\00about\00exit\00cat\00  cat     - Display file contents\00test_process\00  spawn   - Spawn a test process\00spawn: failed to create process\00ps\00ls\00  ps      - List running processes\00  ls      - List files\00%-10s\00%s\00mkdir\00clear\00help\00cp\00echo\00spawn\00echo: missing filename for redirection\00  about   - Show system information\00/proc/version\00rm\00This is a minimal UNIX-like operating system\00kill\00kill: cannot kill current shell\00  exit    - Exit the shell\00  clear   - Clear the terminal\00root:x:0:0:root:/root:/bin/sh\00user:x:1000:1000:user:/home/user:/bin/sh\00touch\00echo: command line too long\00[INIT] Kernel initialization complete\00console\00  touch   - Create empty file\00  cp      - Copy file\00  mv      - Move/rename file\00  help    - Show this help message\00/etc/passwd\00pwd\00mkdir: missing operand\00rm: missing operand\00mv: missing destination file operand\00cp: missing destination file operand\00mv: missing file operand\00cat: missing file operand\00cp: missing file operand\00touch: missing file operand\00[INIT] Memory management initialized\00[INIT] Process management initialized\00[INIT] Device drivers initialized\00[INIT] Scheduler initialized\00[INIT] Filesystem initialized\00[INIT] IPC initialized\00[DEBUG] kernel_main() started\00Memory: 128MB shared\00cd\00WebVM - POSIX-compatible WebAssembly OS\00  POSIX-compatible WebAssembly OS\00\1b[2J\1b[H\00kill: usage: kill <pid>\00=====================================\00WebVM Shell - Available commands:\00Architecture: wasm32\00  WebVM Kernel v0.1.0\00WebVM version 0.1.0\00Version: 0.1.0\00/\00Type 'help' for available commands.\00running entirely in your web browser.\00[KERNEL] Entering main loop...\00[INIT] Starting kernel initialization...\00[KERNEL] Starting shell...\00  rm      - Remove file or directory (use -r for directories)\00(null)\00  kill    - Terminate a process (kill <pid>)\00Welcome to WebVM Shell!\00Goodbye!\00-r \00UNKNOWN \00WAITING \00RUNNING \00$ \00ZOMBIE  \00READY   \00INIT    \00TERM    \00rm: cannot remove directory '%s': Permission denied or not empty\0a\00cat: %s: No such file or directory\0a\00cd: %s: No such file or directory\0a\00ls: cannot access '%s': No such file or directory\0a\00cp: cannot open '%s': No such file or directory\0a\00rm: cannot remove '%s': No such file or directory\0a\00[FS] Failed to mount /dev\0a\00[INIT] Failed to initialize memory management\0a\00[INIT] Failed to initialize process management\0a\00[PROCESS] Cannot kill kernel process\0a\00[INIT] Failed to initialize drivers\0a\00[SCHEDULER] No runnable processes\0a\00echo: cannot create %s\0a\00Removed directory: %s\0a\00Created directory: %s\0a\00Created file: %s\0a\00kill: invalid pid: %s\0a\00Removed: %s\0a\00[PROCESS] Created process %d: %s\0a\00%-3d  %-4d  %s  %s\0a\00touch: cannot touch '%s': Permission denied or error\0a\00rm: cannot remove '%s': Permission denied or error\0a\00cp: write error\0a\00[DRIVER] Failed to initialize driver\0a\00[FS] Failed to mount root filesystem\0a\00[INIT] Failed to initialize filesystem\0a\00[TEST] Test process exiting\0a\00[SCHEDULER] Added process %d to ready queue\0a\00[SCHEDULER] Removed process %d from ready queue\0a\00[PROCESS] No free process slots available\0a\00sh: %s: command not found\0a\00[PROCESS] Process %d not found\0a\00[PROCESS] Process management initialized\0a\00[DRIVER] All drivers initialized\0a\00[SCHEDULER] Scheduler initialized\0a\00[IPC] IPC subsystem initialized\0a\00[PROCESS] Process %d already terminated\0a\00Process %d terminated\0a\00[TEST] Test process running... count=%d\0a\00[PROCESS] Failed to allocate stack for process %d\0a\00kill: failed to kill process %d\0a\00[PROCESS] Killing process %d with signal %d\0a\00Spawned test process with PID %d\0a\00[SCHEDULER] Context switch: %d -> %d\0a\00Total processes: %d\0a\00[FS] Failed to mount /proc\0a\00[SCHEDULER] Process %d yielding CPU\0a\00PID  PPID  STATE      NAME\0a\00[INIT] Failed to initialize IPC\0a\00[PROCESS] Process table dump:\0a\00[KERNEL] Initialization failed, halting.\0a\00[PROCESS] Initializing process management...\0a\00[DRIVER] Initializing driver...\0a\00[SCHEDULER] Initializing scheduler...\0a\00[IPC] Initializing IPC subsystem...\0a\00---  ----  ---------  ----------------\0a\00rm: cannot remove '%s': Is a directory (use -r for directories)\0a\00[TEST] Test process started (pid=%d)\0a\00mkdir: cannot create directory '%s'\0a\00Moved '%s' to '%s'\0a\00Copied '%s' to '%s'\0a\00mv: cannot remove '%s'\0a\00cp: cannot create '%s'\0a\00-r\09\00\00\00\00\00\ff\ff\ff\ffkernel\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\01\00\00\00\00\00\00\00shell\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\03\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
  (data $.data "/\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\03\00\00\00"))
