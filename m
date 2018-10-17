MIME-Version: 1.0
In-Reply-To: <f6de5a77786759a7308ec8dc6cfe41c6@agner.ch>
References: <f6de5a77786759a7308ec8dc6cfe41c6@agner.ch>
Date: Wed, 17 Oct 2018 10:29:30 +0200
Message-ID: <CAJfpegvn9pXJ9EULD-+HXJJNkH58CSB5TEhpv3udHFo47BqeNQ@mail.gmail.com>
Subject: Re: WARNING: possible recursive locking detected in mnt_want_write/mnt_want_write_file_path
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: overlayfs <linux-unionfs@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Stefan Agner <stefan@agner.ch>
List-ID: <linux-unionfs@vger.kernel.org>

Cc: linux-unionfs@vger

On Wed, Oct 17, 2018 at 10:00 AM, Stefan Agner <stefan@agner.ch> wrote:
> Hi,
>
> I noticed this warning since we moved to 4.18. It appears when
> using Docker (which uses overlayfs). Is this a known issue?
>
> [  543.235366] WARNING: possible recursive locking detected
> [  543.240747] 4.18.14 #1 Not tainted
> [  543.244195] --------------------------------------------
> [  543.249573] dockerd/522 is trying to acquire lock:
> [  543.254426] 86b0f89c (sb_writers#7){.+.+}, at: mnt_want_write+0x20/0x4c
> [  543.261152] but task is already holding lock:
> [  543.267053] 86b0f89c (sb_writers#7){.+.+}, at: mnt_want_write_file_path+0x24/0x54
> [  543.274641] other info that might help us debug this:
> [  543.281242]  Possible unsafe locking scenario:
> [  543.287227]        CPU0
> [  543.289706]        ----
> [  543.292183]   lock(sb_writers#7);
> [  543.295547]   lock(sb_writers#7);
> [  543.298912]  *** DEADLOCK ***
> [  543.306825]  May be due to missing lock nesting notation
> [  543.315594] 2 locks held by dockerd/522:
> [  543.320487]  #0: 86b0f89c (sb_writers#7){.+.+}, at: mnt_want_write_file_path+0x24/0x54
> [  543.330353]  #1: fbe4681b (&ovl_i_mutex_key[depth]){+.+.}, at: chown_common+0xf8/0x1c0
> [  543.340298] stack backtrace:
> [  543.346553] CPU: 0 PID: 522 Comm: dockerd Not tainted 4.18.14 #1
> [  543.353556] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> [  543.361088] Backtrace:
> [  543.364530] [<c010ecd0>] (dump_backtrace) from [<c010f058>] (show_stack+0x18/0x1c)
> [  543.374116]  r7:00000000 r6:600d0093 r5:00000000 r4:c118cc04
> [  543.380816] [<c010f040>] (show_stack) from [<c0bca044>] (dump_stack+0xb4/0xec)
> [  543.390112] [<c0bc9f90>] (dump_stack) from [<c0190890>] (__lock_acquire+0xd0c/0x1978)
> [  543.400071]  r10:e80f0628 r9:c18b2ad0 r8:e80f0000 r7:00000000 r6:e80f05e8 r5:c1623390
> [  543.410132]  r4:c1623390 r3:e5e422a5
> [  543.414845] [<c018fb84>] (__lock_acquire) from [<c0191cfc>] (lock_acquire+0x70/0x90)
> [  543.424956]  r10:00000004 r9:00000001 r8:00000001 r7:00000001 r6:600d0013 r5:00000000
> [  543.435317]  r4:ffffe000
> [  543.439144] [<c0191c8c>] (lock_acquire) from [<c02a0ce4>] (__sb_start_write+0x114/0x1b4)
> [  543.449944]  r8:c02c57d8 r7:ec1191f4 r6:00000000 r5:00000000 r4:ec1191f4
> [  543.458074] [<c02a0bd0>] (__sb_start_write) from [<c02c57d8>] (mnt_want_write+0x20/0x4c)
> [  543.468997]  r10:00000004 r9:dbb48ac8 r8:c1108908 r7:e80f9ee8 r6:e80f9ee8 r5:dbb48ac8
> [  543.479693]  r4:edea6610
> [  543.483672] [<c02c57b8>] (mnt_want_write) from [<bf09eb5c>] (ovl_want_write+0x1c/0x20 [overlay])
> [  543.495307]  r5:dbb48ac8 r4:00000000
> [  543.500396] [<bf09eb40>] (ovl_want_write [overlay]) from [<bf0a02e0>] (ovl_setattr+0x30/0x110 [overlay])
> [  543.512871] [<bf0a02b0>] (ovl_setattr [overlay]) from [<c02c0658>] (notify_change+0x25c/0x440)
> [  543.524467]  r9:dbb48ac8 r8:c1108908 r7:e80f9ee8 r6:dbb4cd88 r5:00000000 r4:00001846
> [  543.535205] [<c02c03fc>] (notify_change) from [<c029a050>] (chown_common+0x108/0x1c0)
> [  543.546047]  r10:e8488c88 r9:dbb4ce40 r8:00000000 r7:00000000 r6:00000000 r5:dbb4cd88
> [  543.556891]  r4:e80f8000
> [  543.560893] [<c0299f48>] (chown_common) from [<c029b664>] (ksys_fchown+0x44/0x78)
> [  543.571335]  r10:000000cf r9:e80f8000 r8:00000000 r7:00000000 r6:00000000 r5:e8488c80
> [  543.582164]  r4:e8488c81
> [  543.586163] [<c029b620>] (ksys_fchown) from [<c029b6a8>] (sys_fchown+0x10/0x14)
> [  543.596418]  r9:e80f8000 r8:c01011e4 r7:000000cf r6:1421d548 r5:00000000 r4:00000000
> [  543.607166] [<c029b698>] (sys_fchown) from [<c0101000>] (ret_fast_syscall+0x0/0x28)
> [  543.617828] Exception stack(0xe80f9fa8 to 0xe80f9ff0)
> [  543.624387] 9fa0:                   00000000 00000000 00000012 00000000 00000000 00000000
> [  543.635546] 9fc0: 00000000 00000000 1421d548 000000cf 149cf708 00000000 1425e620 02970ec4
> [  543.646767] 9fe0: 149cf705 1503f618 007572d0 007f1ce4
>
> --
> Stefan
