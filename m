From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH 16/35] ovl: readd lsattr/chattr support
Date: Sun, 22 Apr 2018 18:18:41 +0300
Message-ID: <CAOQ4uxjdXjHMVmaU4WgOhV_v9U-bWQy9BMMmgvDzFV71eoxf_g@mail.gmail.com>
References: <20180412150826.20988-1-mszeredi@redhat.com> <20180412150826.20988-17-mszeredi@redhat.com>
 <CAOQ4uxhw+B_BqMjojSSrvnCYOLgc7J1TR_eOvPkfo=Gb0vcW8Q@mail.gmail.com> <CAOQ4uxhzsV=9PaJF3uPpMMrkKAmysFuOqmPzjhRCzmWjNC8S+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxhzsV=9PaJF3uPpMMrkKAmysFuOqmPzjhRCzmWjNC8S+w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Sun, Apr 22, 2018 at 11:35 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, Apr 17, 2018 at 10:51 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Thu, Apr 12, 2018 at 6:08 PM, Miklos Szeredi <mszeredi@redhat.com> wrote:
>>> Implement FS_IOC_GETFLAGS and FS_IOC_SETFLAGS.
>>>
> ...
>>> +long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>>> +{
>>> +       long ret;
>>> +       struct inode *inode = file_inode(file);
>>> +
>>> +       switch (cmd) {
>>> +       case FS_IOC_GETFLAGS:
>>> +               ret = ovl_real_ioctl(file, cmd, arg);
>>> +               break;
>>> +
>>> +       case FS_IOC_SETFLAGS:
>>> +               if (!inode_owner_or_capable(inode))
>>> +                       return -EACCES;
>>> +
>>> +               ret = mnt_want_write_file(file);
>>> +               if (ret)
>>> +                       return ret;
>>> +
>>> +               ret = ovl_copy_up(file_dentry(file));
>>> +               if (!ret) {
>>> +                       ret = ovl_real_ioctl(file, cmd, arg);
>>> +
>>
>> I got this lockdep splat with overlayfs-rorw and overlay/040, but I don't
>> see the problem in the patch:
>>
>
> Ouch! the problem is not with the patch. The patch is just bring to light
> the fact that filesystems do mnt_want_write_file(file) on ioctls such as
> FS_IOC_SETFLAGS and if that file happens to be an overlayfs file
> then filesystems are getting write access to overlay mount and that was
> not their intention. That can be a way to bypass filesystem ro mount
> and freeze protection.
>
> I couldn't reproduce ro/freeze protection with xfs and ext4 on upstream
> kernel, but did reproduce freeze protection bypass with ext4 and the ro-rw
> patches. ext4 also hits a WARN_ON with upstream kernel and with ro-rw:
>
> root@kvm-xfstests:~# mount /vdf
> root@kvm-xfstests:~# mkdir -p /vdf/ovl-lower /vdf/ovl-upper /vdf/ovl-work
> root@kvm-xfstests:~# touch /vdf/ovl-upper/foo
> root@kvm-xfstests:~# mount -t overlay none /mnt -o
> lowerdir=/vdf/ovl-lower,upperdir=/vdf/ovl-upper,workdir=/vdf/ovl-work
> root@kvm-xfstests:~# fsfreeze -f /vdf
> root@kvm-xfstests:~# chattr +i /mnt/foo
> root@kvm-xfstests:~# lsattr -l /mnt/foo
> /mnt/scratch/foo             Immutable, Extents
>
[...]

> Upstream WARN_ON:
>
> [  302.631228] WARNING: CPU: 0 PID: 1406 at
> /home/amir/build/src/linux/fs/ext4/ext4_jbd2.c:53
> ext4_journal_check_start+0x48/0x82
> [  302.635440] CPU: 0 PID: 1406 Comm: chattr Not tainted
> 4.17.0-rc1-xfstests #3237
> [  302.638200] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
> [  302.641172] RIP: 0010:ext4_journal_check_start+0x48/0x82
> [  302.643154] RSP: 0018:ffffc9000076fbd8 EFLAGS: 00010246
> [  302.644466] RAX: 00000000ffffffe2 RBX: ffff88007a77b000 RCX: 0000000000000000
> [  302.646418] RDX: ffff88007c9df000 RSI: 00000000ffffffff RDI: 0000000000000246
> [  302.648130] RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000006
> [  302.649764] R10: 0000000000000001 R11: ffffffff82210708 R12: 0000000000000000
> [  302.651719] R13: ffff88007c468180 R14: 000000000000019c R15: 0000000000000000
> [  302.653437] FS:  00007f070a480780(0000) GS:ffff88007f200000(0000)
> knlGS:0000000000000000
> [  302.655711] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  302.657923] CR2: 0000564edb963008 CR3: 000000007a676000 CR4: 00000000000006f0
> [  302.660718] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  302.663476] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  302.666179] Call Trace:
> [  302.667071]  __ext4_journal_start_sb+0xe4/0x1a4
> [  302.668763]  ? ext4_file_open+0xb6/0x189
> [  302.670118]  ext4_file_open+0xb6/0x189
> [  302.671528]  ? ext4_release_file+0x9f/0x9f
> [  302.673211]  do_dentry_open+0x19e/0x2d5
> [  302.674747]  ? ovl_inode_init_once+0xe/0xe
> [  302.676398]  do_last+0x520/0x5f9
> [  302.677668]  path_openat+0x1fa/0x26b
> [  302.679100]  do_filp_open+0x4d/0xa3
> [  302.680280]  ? __lock_acquire+0x5e6/0x67b
> [  302.681567]  ? __alloc_fd+0x1a4/0x1b6
> [  302.683051]  ? do_sys_open+0x13c/0x1c1
> [  302.684170]  do_sys_open+0x13c/0x1c1
> [  302.685361]  do_syscall_64+0x5d/0x167
> [  302.686458]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [  302.688029] RIP: 0033:0x7f07099524b0
> [  302.689090] RSP: 002b:00007ffcfefc3178 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000002
> [  302.691309] RAX: ffffffffffffffda RBX: 00007ffcfefc3daf RCX: 00007f07099524b0
> [  302.693346] RDX: 00007ffcfefc3190 RSI: 0000000000000800 RDI: 00007ffcfefc3daf
> [  302.695389] RBP: 00007ffcfefc3daf R08: 0000000000000000 R09: 0000000000000001
> [  302.697766] R10: 00007f07098f5ff0 R11: 0000000000000246 R12: 00007ffcfefc3268
> [  302.699955] R13: 00007ffcfefc3480 R14: 00007ffcfefc3468 R15: 0000000000000000
> [  302.702521] Code: 8b 93 60 07 00 00 b8 fb ff ff ff 48 8b 8a e8 03
> 00 00 80 e1 02 75 4c f6 43 50 01 b8 e2 ff ff ff 75 41 83 bb 28 03 00
> 00 04 75 02 <0f> 0b 48 8b 92 30 03 00 00 31 c0 48 85 d2 74 28 48 8b 02
> 83 e0
> [  302.706996] irq event stamp: 2376
> [  302.707868] hardirqs last  enabled at (2375): [<ffffffff811f8e72>]
> prepend_path+0x205/0x449
> [  302.709872] hardirqs last disabled at (2376): [<ffffffff81a0118f>]
> error_entry+0x7f/0x100
> [  302.712311] softirqs last  enabled at (1060): [<ffffffff81c0033b>]
> __do_softirq+0x33b/0x433
> [  302.714754] softirqs last disabled at (1041): [<ffffffff8107c541>]
> irq_exit+0x59/0xa8
> [  302.716465] ---[ end trace e891c35ae0c8bbe5 ]---
>

That's an ext4 bug unrelated to overlayfs.
reproduced by:
# mount /vdf/
# fsfreeze -f /vdf/
# cat /vdf/foo

> Is there a reason why the real file can't get the real path?
> For current kernels, can you say what else can go wrong when filesystems
> call mnt_want_write_file() on an overlay file on ioctl with filesystem
> inode and why I couldn't reproduce readonly/freeze bypass?
>

The reason is that commit 7c6893e3c9ab ("ovl: don't allow writing ioctl
on lower layer") also silently fixed "block writing ioctl on upper layer
of frozen fs".

Thanks,
Amir.
