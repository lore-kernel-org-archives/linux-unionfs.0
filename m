From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH 16/35] ovl: readd lsattr/chattr support
Date: Tue, 17 Apr 2018 22:51:03 +0300
Message-ID: <CAOQ4uxhw+B_BqMjojSSrvnCYOLgc7J1TR_eOvPkfo=Gb0vcW8Q@mail.gmail.com>
References: <20180412150826.20988-1-mszeredi@redhat.com> <20180412150826.20988-17-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180412150826.20988-17-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Apr 12, 2018 at 6:08 PM, Miklos Szeredi <mszeredi@redhat.com> wrote:
> Implement FS_IOC_GETFLAGS and FS_IOC_SETFLAGS.
>
> Needs vfs_ioctl() exported to modules.
>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/internal.h       |  1 -
>  fs/ioctl.c          |  1 +
>  fs/overlayfs/file.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/fs.h  |  2 ++
>  4 files changed, 62 insertions(+), 1 deletion(-)
>
> diff --git a/fs/internal.h b/fs/internal.h
> index 3319bf39e339..d5108d9c6a2f 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -176,7 +176,6 @@ extern const struct dentry_operations ns_dentry_operations;
>   */
>  extern int do_vfs_ioctl(struct file *file, unsigned int fd, unsigned int cmd,
>                     unsigned long arg);
> -extern long vfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
>
>  /*
>   * iomap support:
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 5ace7efb0d04..696f4c46a868 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -49,6 +49,7 @@ long vfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>   out:
>         return error;
>  }
> +EXPORT_SYMBOL(vfs_ioctl);
>
>  static int ioctl_fibmap(struct file *filp, int __user *p)
>  {
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 05e3e2f80b89..cc004ff1b05b 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -8,6 +8,7 @@
>
>  #include <linux/cred.h>
>  #include <linux/file.h>
> +#include <linux/mount.h>
>  #include <linux/xattr.h>
>  #include <linux/uio.h>
>  #include "overlayfs.h"
> @@ -291,6 +292,63 @@ long ovl_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>         return ret;
>  }
>
> +static long ovl_real_ioctl(struct file *file, unsigned int cmd,
> +                          unsigned long arg)
> +{
> +       struct fd real;
> +       const struct cred *old_cred;
> +       long ret;
> +
> +       ret = ovl_real_file(file, &real);
> +       if (ret)
> +               return ret;
> +
> +       old_cred = ovl_override_creds(file_inode(file)->i_sb);
> +       ret = vfs_ioctl(real.file, cmd, arg);
> +       revert_creds(old_cred);
> +
> +       fdput(real);
> +
> +       return ret;
> +}
> +
> +long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +       long ret;
> +       struct inode *inode = file_inode(file);
> +
> +       switch (cmd) {
> +       case FS_IOC_GETFLAGS:
> +               ret = ovl_real_ioctl(file, cmd, arg);
> +               break;
> +
> +       case FS_IOC_SETFLAGS:
> +               if (!inode_owner_or_capable(inode))
> +                       return -EACCES;
> +
> +               ret = mnt_want_write_file(file);
> +               if (ret)
> +                       return ret;
> +
> +               ret = ovl_copy_up(file_dentry(file));
> +               if (!ret) {
> +                       ret = ovl_real_ioctl(file, cmd, arg);
> +

I got this lockdep splat with overlayfs-rorw and overlay/040, but I don't
see the problem in the patch:

overlay/040 [19:29:01][    7.414427]
[    7.415349] ============================================
[    7.417863] WARNING: possible recursive locking detected
[    7.419652] 4.16.0-rc7-xfstests-00054-g1b18a246f764-dirty #3233 Not tainted
[    7.421517] --------------------------------------------
[    7.422736] chattr/2376 is trying to acquire lock:
[    7.423843]  (sb_writers#10){.+.+}, at: [<000000003170ac81>]
mnt_want_write_file+0x21/0x4a
[    7.425683]
[    7.425683] but task is already holding lock:
[    7.427397]  (sb_writers#10){.+.+}, at: [<000000003170ac81>]
mnt_want_write_file+0x21/0x4a
[    7.430180]
[    7.430180] other info that might help us debug this:
[    7.432511]  Possible unsafe locking scenario:
[    7.432511]
[    7.433860]        CPU0
[    7.434424]        ----
[    7.434987]   lock(sb_writers#10);
[    7.435768]   lock(sb_writers#10);
[    7.436692]
[    7.436692]  *** DEADLOCK ***
[    7.436692]
[    7.438460]  May be due to missing lock nesting notation
[    7.438460]
[    7.440477] 1 lock held by chattr/2376:
[    7.441876]  #0:  (sb_writers#10){.+.+}, at: [<000000003170ac81>]
mnt_want_write_file+0x21/0x4a
[    7.444537]
[    7.444537] stack backtrace:
[    7.445881] CPU: 1 PID: 2376 Comm: chattr Not tainted
4.16.0-rc7-xfstests-00054-g1b18a246f764-dirty #3233
[    7.449594] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[    7.453121] Call Trace:
[    7.453945]  dump_stack+0x7c/0xb2
[    7.454957]  validate_chain.isra.24+0x6da/0x8af
[    7.456341]  __lock_acquire+0x5e6/0x67b
[    7.457643]  ? __lock_acquire+0x5e6/0x67b
[    7.458879]  lock_acquire+0x139/0x1dd
[    7.459988]  ? mnt_want_write_file+0x21/0x4a
[    7.461317]  __sb_start_write+0x91/0x163
[    7.462500]  ? mnt_want_write_file+0x21/0x4a
[    7.463822]  mnt_want_write_file+0x21/0x4a
[    7.465091]  xfs_ioc_setxflags+0x70/0xe5
[    7.466266]  xfs_file_ioctl+0x4a7/0xa90
[    7.467452]  ? __lock_acquire+0x5e6/0x67b
[    7.468681]  ? terminate_walk+0x20/0xd9
[    7.469835]  ? __lock_is_held+0x40/0x71
[    7.471012]  vfs_ioctl+0x1e/0x2b
[    7.472008]  ovl_real_ioctl+0x45/0x71
[    7.473122]  ovl_ioctl+0x9a/0xf2
[    7.474114]  vfs_ioctl+0x1e/0x2b
[    7.475149]  do_vfs_ioctl+0x579/0x5f1
[    7.476341]  ? entry_SYSCALL_64_after_hwframe+0x52/0xb7
[    7.477765]  SyS_ioctl+0x52/0x74
[    7.479041]  do_syscall_64+0x76/0x182
[    7.480419]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[    7.482536] RIP: 0033:0x7fde8d270dd7
[    7.483919] RSP: 002b:00007ffde2ae7e98 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[    7.486862] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fde8d270dd7
[    7.489554] RDX: 00007ffde2ae7eac RSI: 0000000040086602 RDI: 0000000000000003
[    7.492227] RBP: 0000000000000010 R08: 0000000000000000 R09: 0000000000000001
[    7.494922] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
[    7.497642] R13: 00007ffde2ae81a0 R14: 00007ffde2ae8188 R15: 0000000000000000
[    7.540886] XFS (vdf): Mounting V5 Filesystem
[    7.563795] XFS (vdf): Ending clean mount

Thanks,
Amir.
