From: Alessio Igor Bogani <alessioigorbogani@gmail.com>
Subject: Re: Problem with two overlayed 9p filesystems
Date: Tue, 28 Jun 2016 14:11:28 +0200
Message-ID: <CAPk1OjHePfz=WjSr=ivdeWKH-674AEcm7eMJnDGzx_tvgw_Auw@mail.gmail.com>
References: <CAPk1OjHwxm_=+rBNXMLXbJvyNGVaGKV0sd_-0RThY-FnTTBALA@mail.gmail.com>
 <20160627185431.GA2388@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35820 "EHLO
	mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbcF1MLa (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 28 Jun 2016 08:11:30 -0400
In-Reply-To: <20160627185431.GA2388@veci.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>, v9fs-developer@lists.sourceforge.net, linux-unionfs@vger.kernel.org, LFSDEV <linux-fsdevel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>

Miklos,

On 27 June 2016 at 20:54, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, Jun 27, 2016 at 04:30:59PM +0200, Alessio Igor Bogani wrote:
>> Hi,
>>
>> Using v4.0 I used to put two 9p or two ext4 filesystems in overlay.
>> Now with v4.7-rc5 I can still put two ext4 filesystems in overlay but
>> not two 9p filesystems anymore. In the later I obtain the following
>> error executing a simple "cat overlay/test.txt".
>>
>> Bisecting results in the first offending commit
>> 4bacc9c9234c7c8eec44f5ed4e960d9f96fa0f01 which though contains only
>
> Please try the following patch.
>
> Thanks,
> Miklos
>
> diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
> index b84c291ba1eb..d7b78d531e63 100644
> --- a/fs/9p/vfs_file.c
> +++ b/fs/9p/vfs_file.c
> @@ -74,7 +74,7 @@ int v9fs_file_open(struct inode *inode, struct file *file)
>                                         v9fs_proto_dotu(v9ses));
>         fid = file->private_data;
>         if (!fid) {
> -               fid = v9fs_fid_clone(file->f_path.dentry);
> +               fid = v9fs_fid_clone(file_dentry(file));
>                 if (IS_ERR(fid))
>                         return PTR_ERR(fid);
>
> @@ -100,7 +100,7 @@ int v9fs_file_open(struct inode *inode, struct file *file)
>                  * because we want write after unlink usecase
>                  * to work.
>                  */
> -               fid = v9fs_writeback_fid(file->f_path.dentry);
> +               fid = v9fs_writeback_fid(file_dentry(file));
>                 if (IS_ERR(fid)) {
>                         err = PTR_ERR(fid);
>                         mutex_unlock(&v9inode->v_mutex);
> @@ -516,7 +516,7 @@ v9fs_mmap_file_mmap(struct file *filp, struct vm_area_struct *vma)
>                  * because we want write after unlink usecase
>                  * to work.
>                  */
> -               fid = v9fs_writeback_fid(filp->f_path.dentry);
> +               fid = v9fs_writeback_fid(file_dentry(filp));
>                 if (IS_ERR(fid)) {
>                         retval = PTR_ERR(fid);
>                         mutex_unlock(&v9inode->v_mutex);

Your patch works!

In the dmesg output there is a WARNING but the system is still working:

[    7.454660] ------------[ cut here ]------------
[    7.454774] WARNING: CPU: 0 PID: 123 at
/home/alessio/linux/fs/inode.c:337 inc_nlink+0x74/0x78
[    7.454792] Modules linked in:
[    7.454842] CPU: 0 PID: 123 Comm: mkdir Not tainted 4.7.0-rc5 #2
[    7.454859] Hardware name: Generic AM33XX (Flattened Device Tree)
[    7.454961] [<c010ff7c>] (unwind_backtrace) from [<c010c6dc>]
(show_stack+0x20/0x24)
[    7.455017] [<c010c6dc>] (show_stack) from [<c04a9dc8>]
(dump_stack+0x24/0x28)
[    7.455076] [<c04a9dc8>] (dump_stack) from [<c012d150>] (__warn+0xf4/0x10c)
[    7.455117] [<c012d150>] (__warn) from [<c012d238>]
(warn_slowpath_null+0x30/0x38)
[    7.455155] [<c012d238>] (warn_slowpath_null) from [<c024fb88>]
(inc_nlink+0x74/0x78)
[    7.455212] [<c024fb88>] (inc_nlink) from [<c0373b48>]
(v9fs_vfs_mkdir_dotl+0x140/0x1dc)
[    7.455262] [<c0373b48>] (v9fs_vfs_mkdir_dotl) from [<c0240420>]
(vfs_mkdir+0xc0/0x10c)
[    7.455305] [<c0240420>] (vfs_mkdir) from [<c0244844>]
(SyS_mkdirat+0x78/0xc4)
[    7.455341] [<c0244844>] (SyS_mkdirat) from [<c02448b4>]
(SyS_mkdir+0x24/0x28)
[    7.455378] [<c02448b4>] (SyS_mkdir) from [<c0108160>]
(ret_fast_syscall+0x0/0x3c)
[    7.455400] ---[ end trace a878e09ce9f6bbd7 ]---

Thank you very much!

Ciao,
Alessio
