{
  zramSwap = {
    enable = true;
    algorithm = "lz4";
    memoryPercent = 100;
    priority = 999;
  };

  # The sysctls below are all disk-swap-era defaults. zram swap is compressed
  # RAM, not disk, so the usual caution around swapping is counterproductive
  # here and actively hurts build/compile workloads.
  boot.kernel.sysctl = {
    # Default (60) keeps the kernel reluctant to swap, since on a real disk
    # swapping is slow. zram round-trips in microseconds, so prefer pushing
    # cold anonymous pages (process heap/stack) into zram over evicting the
    # page cache, which is what's holding hot Nix store paths, source trees,
    # and object files in memory during a build.
    "vm.swappiness" = 180;

    # kswapd reclaims memory asynchronously in the background once free
    # memory drops below a "low" watermark, aiming to get back up to a
    # "high" watermark before anyone stalls. This factor sets the gap
    # between those watermarks, in parts per 10000 of RAM. The default (10)
    # leaves almost no headroom, so a sudden allocation burst -- e.g. a
    # parallel compile spawning one process per core -- outruns kswapd and
    # those processes end up doing synchronous reclaim themselves instead of
    # compiling. A wider gap (125) lets kswapd stay ahead of bursty
    # allocators.
    "vm.watermark_scale_factor" = 125;

    # On swap-in, the kernel also speculatively reads neighboring pages
    # (2^page-cluster of them) because on disk/SSD swap, batching reads
    # amortizes seek cost. zram has no seek cost, so clustering here only
    # burns CPU decompressing pages that may never be touched. 0 reads
    # exactly the faulting page.
    "vm.page-cluster" = 0;
  };
}
