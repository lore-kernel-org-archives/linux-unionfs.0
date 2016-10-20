From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [POC/RFC PATCH] overlayfs: fix data inconsistency at copy up
Date: Thu, 20 Oct 2016 16:46:30 -0400
Message-ID: <20161020204630.GA1000@redhat.com>
References: <20161012133326.GD31239@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161012133326.GD31239@veci.piliscsaba.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Jeremy Eder <jeder@redhat.com>, David Howells <dhowells@redhat.com>, Ratna Bolla <rbolla@portworx.com>, Gou Rao <grao@portworx.com>, Vinod Jayaraman <jv@portworx.com>, Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Oct 12, 2016 at 03:33:26PM +0200, Miklos Szeredi wrote:
> This is a proof of concept patch to fix the following.
> 
> /ovl is in overlay mount and /ovl/foo exists on the lower layer only.
> 
>  rofd = open("/ovl/foo", O_RDONLY);
>  rwfd = open("/ovl/foo", O_WRONLY); /* this causes copy up */
>  write(rwfd, "bar", 3);
>  read(rofd, buf, 3); 
>  assert(memcmp(buf, "bar", 3) == 0);
> 
> Similar problem exists with an MAP_SHARED mmap created from rofd.
> 
> While this has only caused few problems (yum/dnf failure is the only one I know
> of) and easily worked around in userspace, many see it as a proof that overlayfs
> can never be a proper "POSIX" filesystem.
> 
> To quell those worries, here's a simple patch that should address the above.
> 
> The only VFS change is that f_op is initialized from f_path.dentry->d_inode
> instead of file_inode(filp) in open.  The effect of this is that overlayfs can
> intercept open and other file operations, while the file still effectively
> belongs to the underlying fs.
> 
> The patch does not give up on the nice properties of overlayfs, like sharing the
> page cache with the underlying files.  It does cause copy up in one case where
> previously there wasn't one and that's the O_RDONLY/MAP_SHARED case.  I haven't
> done much research into this, but running some tests in chroot didn't trigger
> this.
> 
> Comments, testing are welcome.

Hi Miklos, 

This looks like a very interesting idea. In fact once file has been copied
up and writen to, and if I do fstat(rofd), it shows the size of copied up
file but one can read the contents. So fixing that anomaly would be nice.

Hopefully O_RDONLY/MAP_SHARED is not a common case and we get away with
this forced copy up penalty.

[..]
> +static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *to)
> +{
> +	struct file *file = iocb->ki_filp;
> +	bool isupper = OVL_TYPE_UPPER(ovl_path_type(file->f_path.dentry));
> +	ssize_t ret = -EINVAL;
> +
> +	if (likely(!isupper)) {
> +		const struct file_operations *fop = ovl_real_fop(file);
> +
> +		if (likely(fop->read_iter))
> +			ret = fop->read_iter(iocb, to);
> +	} else {
> +		struct file *upperfile = filp_clone_open(file);
> +

IIUC, every read of lower file will call filp_clone_open(). Looking at the
code of filp_clone_open(), I am concerned about the overhead of this call.
Is it significant? Don't want to be paying too much of penalty for read
operation on lower files. That would be a common case for containers.

BTW, I did a quick testing. Using docker launched a fedora container and
called "dnf update" inside that. And later I noticed following on serial
console.

Thanks
Vivek

[  309.075885] ======================================================
[  309.076841] [ INFO: possible circular locking dependency detected ]
[  309.077818] 4.9.0-rc1+ #197 Not tainted
[  309.078411] -------------------------------------------------------
[  309.079377] dnf/2468 is trying to acquire lock:
[  309.080082]  ([  309.080324] &type->s_vfs_rename_key
#2[  309.080942] ){+.+.+.}
, at: [  309.081435] [<ffffffff8129f652>] lock_rename+0x32/0x100
[  309.082261] 
[  309.082261] but task is already holding lock:
[  309.083158]  ([  309.083399] &mm->mmap_sem
){++++++}[  309.083974] , at: 
[  309.084316] [<ffffffff8121df0c>] vm_mmap_pgoff+0x8c/0x100
[  309.085150] 
[  309.085150] which lock already depends on the new lock.
[  309.085150] 
[  309.086393] 
[  309.086393] the existing dependency chain (in reverse order) is:
[  309.088279] 
-> #3[  309.088612]  (
&mm->mmap_sem[  309.089091] ){++++++}
[  309.089470] :
[  309.089735]        [  309.090046] [<ffffffff81112786>] lock_acquire+0xf6/0x1f0
[  309.090884]        [  309.091197] [<ffffffff812316c0>] __might_fault+0x70/0xa0
[  309.092047]        [  309.092357] [<ffffffff812aa585>] filldir+0xb5/0x140
[  309.093128]        [  309.093434] [<ffffffff8132f235>] call_filldir+0x65/0x130
[  309.094273]        [  309.094590] [<ffffffff8132fc0f>] ext4_readdir+0x6cf/0x8a0
[  309.095425]        [  309.095742] [<ffffffff812aa24b>] iterate_dir+0x17b/0x1b0
[  309.096572]        [  309.096878] [<ffffffff812aa76c>] SyS_getdents+0x9c/0x130
[  309.097716]        [  309.098026] [<ffffffff818a4bc1>] entry_SYSCALL_64_fastpath+0x1f/0xc2
[  309.099005] 
-> #2[  309.099304]  (
&type->i_mutex_dir_key[  309.099888] #3
){++++++}[  309.100301] :
[  309.100576]        [  309.100881] [<ffffffff81112786>] lock_acquire+0xf6/0x1f0
[  309.101711]        [  309.102017] [<ffffffff818a1279>] down_write+0x49/0x80
[  309.102798]        [  309.103098] [<ffffffff8129fea5>] vfs_rmdir+0x55/0x140
[  309.103878]        [  309.104179] [<ffffffff812a5bdd>] do_rmdir+0x1bd/0x230
[  309.104958]        [  309.105256] [<ffffffff812a6a12>] SyS_unlinkat+0x22/0x30
[  309.106063]        [  309.106364] [<ffffffff818a4bc1>] entry_SYSCALL_64_fastpath+0x1f/0xc2
[  309.107345] 
-> #1[  309.107661]  (
&type->i_mutex_dir_key[  309.108256] #3
/1[  309.108597] ){+.+.+.}
[  309.108971] :
[  309.109225]        [  309.109532] [<ffffffff81112786>] lock_acquire+0xf6/0x1f0
[  309.110370]        [  309.110686] [<ffffffff8110c8df>] down_write_nested+0x4f/0x80
[  309.111606]        [  309.111916] [<ffffffff8129f701>] lock_rename+0xe1/0x100
[  309.112752]        [  309.113062] [<ffffffff812a7842>] SyS_renameat+0x212/0x3f0
[  309.113918]        [  309.114224] [<ffffffff818a4bc1>] entry_SYSCALL_64_fastpath+0x1f/0xc2
[  309.115218] 
-> #0[  309.115525]  (
&type->s_vfs_rename_key[  309.116138] #2
){+.+.+.}[  309.116564] :
[  309.116837]        [  309.117146] [<ffffffff811121a0>] __lock_acquire+0x1110/0x12a0
[  309.118047]        [  309.118354] [<ffffffff81112786>] lock_acquire+0xf6/0x1f0
[  309.119193]        [  309.119500] [<ffffffff818a0159>] mutex_lock_nested+0x79/0x3c0
[  309.120406]        [  309.120723] [<ffffffff8129f652>] lock_rename+0x32/0x100
[  309.121564]        [  309.121875] [<ffffffffa02d1617>] ovl_copy_up_one+0xf7/0x6a0 [overlay]
[  309.122866]        [  309.123170] [<ffffffffa02d1ccb>] ovl_copy_up+0x10b/0x13d [overlay]
[  309.124136]        [  309.124442] [<ffffffffa02cd7a5>] ovl_mmap+0x55/0x90 [overlay]
[  309.125348]        [  309.125677] [<ffffffff8123f3a4>] mmap_region+0x394/0x630
[  309.126510]        [  309.126829] [<ffffffff8123fa86>] do_mmap+0x446/0x530
[  309.127616]        [  309.127928] [<ffffffff8121df3d>] vm_mmap_pgoff+0xbd/0x100
[  309.128783]        [  309.129092] [<ffffffff8123d5c1>] SyS_mmap_pgoff+0x1c1/0x290
[  309.129973]        [  309.130284] [<ffffffff8103b71b>] SyS_mmap+0x1b/0x30
[  309.131058]        [  309.131368] [<ffffffff818a4bc1>] entry_SYSCALL_64_fastpath+0x1f/0xc2
[  309.132377] 
[  309.132377] other info that might help us debug this:
[  309.132377] 
[  309.133608] Chain exists of:
  [  309.134084] &type->s_vfs_rename_key
#2[  309.134694]  --> 
&type->i_mutex_dir_key[  309.135324] #3
 --> [  309.135705] &mm->mmap_sem
[  309.136131] 
[  309.136131] 
[  309.136599]  Possible unsafe locking scenario:
[  309.136599] 
[  309.137499]        CPU0                    CPU1
[  309.138202]        ----                    ----
[  309.138905]   lock([  309.139211] &mm->mmap_sem
[  309.139646] );
[  309.139914]                                lock([  309.140602] &type->i_mutex_dir_key
#3[  309.141190] );
[  309.141472]                                lock([  309.142175] &mm->mmap_sem
[  309.142610] );
[  309.142877]   lock([  309.143186] &type->s_vfs_rename_key
#2[  309.143796] );
[  309.144084] 
[  309.144084]  *** DEADLOCK ***
[  309.144084] 
[  309.144991] 1 lock held by dnf/2468:
[  309.145543]  #0: [  309.145827]  (
&mm->mmap_sem[  309.146299] ){++++++}
, at: [  309.146782] [<ffffffff8121df0c>] vm_mmap_pgoff+0x8c/0x100
[  309.147634] 
[  309.147634] stack backtrace:
[  309.148310] CPU: 4 PID: 2468 Comm: dnf Not tainted 4.9.0-rc1+ #197
[  309.149257] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.8.2-20150714_191134- 04/01/2014
[  309.150717]  ffffc900033cf900 ffffffff8144b253 ffffffff828b29f0 ffffffff828e8d50
[  309.151942]  ffffc900033cf940 ffffffff8110f83e 00000000f7ac0000 ffff8801f7ac0860
[  309.153660]  ffff8801f7ac0000 ffff8801f7ac0838 0000000000000001 0000000000000000
[  309.154877] Call Trace:
[  309.155266]  [<ffffffff8144b253>] dump_stack+0x86/0xc3
[  309.156062]  [<ffffffff8110f83e>] print_circular_bug+0x1be/0x210
[  309.156991]  [<ffffffff811121a0>] __lock_acquire+0x1110/0x12a0
[  309.157896]  [<ffffffff8112ee3d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  309.158912]  [<ffffffff813c3ed4>] ? avc_has_perm+0x34/0x290
[  309.159768]  [<ffffffff81112786>] lock_acquire+0xf6/0x1f0
[  309.160597]  [<ffffffff8129f652>] ? lock_rename+0x32/0x100
[  309.161438]  [<ffffffff818a0159>] mutex_lock_nested+0x79/0x3c0
[  309.162351]  [<ffffffff8129f652>] ? lock_rename+0x32/0x100
[  309.163202]  [<ffffffff813c92fb>] ? selinux_inode_getattr+0x8b/0xb0
[  309.164162]  [<ffffffff8129f652>] lock_rename+0x32/0x100
[  309.164981]  [<ffffffffa02d1617>] ovl_copy_up_one+0xf7/0x6a0 [overlay]
[  309.165987]  [<ffffffff813c3fd3>] ? avc_has_perm+0x133/0x290
[  309.166864]  [<ffffffff813c3ed4>] ? avc_has_perm+0x34/0x290
[  309.167723]  [<ffffffff810e348a>] ? __might_sleep+0x4a/0x80
[  309.168580]  [<ffffffffa02d1ccb>] ovl_copy_up+0x10b/0x13d [overlay]
[  309.169539]  [<ffffffffa02cd7a5>] ovl_mmap+0x55/0x90 [overlay]
[  309.170436]  [<ffffffff8123f3a4>] mmap_region+0x394/0x630
[  309.171269]  [<ffffffff8123fa86>] do_mmap+0x446/0x530
[  309.172064]  [<ffffffff8121df3d>] vm_mmap_pgoff+0xbd/0x100
[  309.172908]  [<ffffffff8123d5c1>] SyS_mmap_pgoff+0x1c1/0x290
[  309.173777]  [<ffffffff8103b71b>] SyS_mmap+0x1b/0x30
[  309.174539]  [<ffffffff818a4bc1>] entry_SYSCALL_64_fastpath+0x1f/0xc2
