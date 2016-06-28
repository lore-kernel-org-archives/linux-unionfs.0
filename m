Return-Path: <alessioigorbogani@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20160627185431.GA2388@veci.piliscsaba.szeredi.hu>
References: <CAPk1OjHwxm_=+rBNXMLXbJvyNGVaGKV0sd_-0RThY-FnTTBALA@mail.gmail.com>
	<20160627185431.GA2388@veci.piliscsaba.szeredi.hu>
Date: Tue, 28 Jun 2016 17:13:00 +0200
Message-ID: <CAPk1OjH1AqJdp_7z8wYbZTg3s+vDOfeqL2QV7gv7XSZ3PwWGSA@mail.gmail.com>
Subject: Re: Problem with two overlayed 9p filesystems
From: Alessio Igor Bogani <alessioigorbogani@gmail.com>
Content-Type: multipart/alternative; boundary=001a1149993a91f6fc0536581219
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>, v9fs-developer@lists.sourceforge.net, linux-unionfs@vger.kernel.org, LFSDEV <linux-fsdevel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>
List-ID: <linux-unionfs@vger.kernel.org>

--001a1149993a91f6fc0536581219
Content-Type: text/plain; charset=UTF-8

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
> @@ -74,7 +74,7 @@ int v9fs_file_open(struct inode *inode, struct file
*file)
> v9fs_proto_dotu(v9ses));
> fid = file->private_data;
> if (!fid) {
> - fid = v9fs_fid_clone(file->f_path.dentry);
> + fid = v9fs_fid_clone(file_dentry(file));
> if (IS_ERR(fid))
> return PTR_ERR(fid);
>
> @@ -100,7 +100,7 @@ int v9fs_file_open(struct inode *inode, struct file
*file)
> * because we want write after unlink usecase
> * to work.
> */
> - fid = v9fs_writeback_fid(file->f_path.dentry);
> + fid = v9fs_writeback_fid(file_dentry(file));
> if (IS_ERR(fid)) {
> err = PTR_ERR(fid);
> mutex_unlock(&v9inode->v_mutex);
> @@ -516,7 +516,7 @@ v9fs_mmap_file_mmap(struct file *filp, struct
vm_area_struct *vma)
> * because we want write after unlink usecase
> * to work.
> */
> - fid = v9fs_writeback_fid(filp->f_path.dentry);
> + fid = v9fs_writeback_fid(file_dentry(filp));
> if (IS_ERR(fid)) {
> retval = PTR_ERR(fid);
> mutex_unlock(&v9inode->v_mutex);

Your patch works!

In the dmesg output there is a WARNING but the system is still working:

[ 7.454660] ------------[ cut here ]------------
[ 7.454774] WARNING: CPU: 0 PID: 123 at /home/alessio/linux/fs/inode.c:337
inc_nlink+0x74/0x78
[ 7.454792] Modules linked in:
[ 7.454842] CPU: 0 PID: 123 Comm: mkdir Not tainted 4.7.0-rc5 #2
[ 7.454859] Hardware name: Generic AM33XX (Flattened Device Tree)
[ 7.454961] [<c010ff7c>] (unwind_backtrace) from [<c010c6dc>]
(show_stack+0x20/0x24)
[ 7.455017] [<c010c6dc>] (show_stack) from [<c04a9dc8>]
(dump_stack+0x24/0x28)
[ 7.455076] [<c04a9dc8>] (dump_stack) from [<c012d150>] (__warn+0xf4/0x10c)
[ 7.455117] [<c012d150>] (__warn) from [<c012d238>]
(warn_slowpath_null+0x30/0x38)
[ 7.455155] [<c012d238>] (warn_slowpath_null) from [<c024fb88>]
(inc_nlink+0x74/0x78)
[ 7.455212] [<c024fb88>] (inc_nlink) from [<c0373b48>]
(v9fs_vfs_mkdir_dotl+0x140/0x1dc)
[ 7.455262] [<c0373b48>] (v9fs_vfs_mkdir_dotl) from [<c0240420>]
(vfs_mkdir+0xc0/0x10c)
[ 7.455305] [<c0240420>] (vfs_mkdir) from [<c0244844>]
(SyS_mkdirat+0x78/0xc4)
[ 7.455341] [<c0244844>] (SyS_mkdirat) from [<c02448b4>]
(SyS_mkdir+0x24/0x28)
[ 7.455378] [<c02448b4>] (SyS_mkdir) from [<c0108160>]
(ret_fast_syscall+0x0/0x3c)
[ 7.455400] ---[ end trace a878e09ce9f6bbd7 ]---

Thank you very much!

Ciao,
Alessio

--001a1149993a91f6fc0536581219
Content-Type: text/html; charset=UTF-8

<p dir="ltr">Miklos,</p>
<p dir="ltr">On 27 June 2016 at 20:54, Miklos Szeredi &lt;<a href="mailto:miklos@szeredi.hu">miklos@szeredi.hu</a>&gt; wrote:<br>
&gt; On Mon, Jun 27, 2016 at 04:30:59PM +0200, Alessio Igor Bogani wrote:<br>
&gt;&gt; Hi,<br>
&gt;&gt;<br>
&gt;&gt; Using v4.0 I used to put two 9p or two ext4 filesystems in overlay.<br>
&gt;&gt; Now with v4.7-rc5 I can still put two ext4 filesystems in overlay but<br>
&gt;&gt; not two 9p filesystems anymore. In the later I obtain the following<br>
&gt;&gt; error executing a simple &quot;cat overlay/test.txt&quot;.<br>
&gt;&gt;<br>
&gt;&gt; Bisecting results in the first offending commit<br>
&gt;&gt; 4bacc9c9234c7c8eec44f5ed4e960d9f96fa0f01 which though contains only<br>
&gt;<br>
&gt; Please try the following patch.<br>
&gt;<br>
&gt; Thanks,<br>
&gt; Miklos<br>
&gt;<br>
&gt; diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c<br>
&gt; index b84c291ba1eb..d7b78d531e63 100644<br>
&gt; --- a/fs/9p/vfs_file.c<br>
&gt; +++ b/fs/9p/vfs_file.c<br>
&gt; @@ -74,7 +74,7 @@ int v9fs_file_open(struct inode *inode, struct file *file)<br>
&gt; v9fs_proto_dotu(v9ses));<br>
&gt; fid = file-&gt;private_data;<br>
&gt; if (!fid) {<br>
&gt; - fid = v9fs_fid_clone(file-&gt;f_path.dentry);<br>
&gt; + fid = v9fs_fid_clone(file_dentry(file));<br>
&gt; if (IS_ERR(fid))<br>
&gt; return PTR_ERR(fid);<br>
&gt;<br>
&gt; @@ -100,7 +100,7 @@ int v9fs_file_open(struct inode *inode, struct file *file)<br>
&gt; * because we want write after unlink usecase<br>
&gt; * to work.<br>
&gt; */<br>
&gt; - fid = v9fs_writeback_fid(file-&gt;f_path.dentry);<br>
&gt; + fid = v9fs_writeback_fid(file_dentry(file));<br>
&gt; if (IS_ERR(fid)) {<br>
&gt; err = PTR_ERR(fid);<br>
&gt; mutex_unlock(&amp;v9inode-&gt;v_mutex);<br>
&gt; @@ -516,7 +516,7 @@ v9fs_mmap_file_mmap(struct file *filp, struct vm_area_struct *vma)<br>
&gt; * because we want write after unlink usecase<br>
&gt; * to work.<br>
&gt; */<br>
&gt; - fid = v9fs_writeback_fid(filp-&gt;f_path.dentry);<br>
&gt; + fid = v9fs_writeback_fid(file_dentry(filp));<br>
&gt; if (IS_ERR(fid)) {<br>
&gt; retval = PTR_ERR(fid);<br>
&gt; mutex_unlock(&amp;v9inode-&gt;v_mutex);</p>
<p dir="ltr">Your patch works!</p>
<p dir="ltr">In the dmesg output there is a WARNING but the system is still working:</p>
<p dir="ltr">[ 7.454660] ------------[ cut here ]------------<br>
[ 7.454774] WARNING: CPU: 0 PID: 123 at /home/alessio/linux/fs/inode.c:337 inc_nlink+0x74/0x78<br>
[ 7.454792] Modules linked in:<br>
[ 7.454842] CPU: 0 PID: 123 Comm: mkdir Not tainted 4.7.0-rc5 #2<br>
[ 7.454859] Hardware name: Generic AM33XX (Flattened Device Tree)<br>
[ 7.454961] [&lt;c010ff7c&gt;] (unwind_backtrace) from [&lt;c010c6dc&gt;] (show_stack+0x20/0x24)<br>
[ 7.455017] [&lt;c010c6dc&gt;] (show_stack) from [&lt;c04a9dc8&gt;] (dump_stack+0x24/0x28)<br>
[ 7.455076] [&lt;c04a9dc8&gt;] (dump_stack) from [&lt;c012d150&gt;] (__warn+0xf4/0x10c)<br>
[ 7.455117] [&lt;c012d150&gt;] (__warn) from [&lt;c012d238&gt;] (warn_slowpath_null+0x30/0x38)<br>
[ 7.455155] [&lt;c012d238&gt;] (warn_slowpath_null) from [&lt;c024fb88&gt;] (inc_nlink+0x74/0x78)<br>
[ 7.455212] [&lt;c024fb88&gt;] (inc_nlink) from [&lt;c0373b48&gt;] (v9fs_vfs_mkdir_dotl+0x140/0x1dc)<br>
[ 7.455262] [&lt;c0373b48&gt;] (v9fs_vfs_mkdir_dotl) from [&lt;c0240420&gt;] (vfs_mkdir+0xc0/0x10c)<br>
[ 7.455305] [&lt;c0240420&gt;] (vfs_mkdir) from [&lt;c0244844&gt;] (SyS_mkdirat+0x78/0xc4)<br>
[ 7.455341] [&lt;c0244844&gt;] (SyS_mkdirat) from [&lt;c02448b4&gt;] (SyS_mkdir+0x24/0x28)<br>
[ 7.455378] [&lt;c02448b4&gt;] (SyS_mkdir) from [&lt;c0108160&gt;] (ret_fast_syscall+0x0/0x3c)<br>
[ 7.455400] ---[ end trace a878e09ce9f6bbd7 ]---</p>
<p dir="ltr">Thank you very much!</p>
<p dir="ltr">Ciao,<br>
Alessio</p>

--001a1149993a91f6fc0536581219--
