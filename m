From: "arnaud.mouiche@invoxia.com" <arnaud.mouiche@invoxia.com>
Subject: Overlayfs with NFS lower layer is still not working
Date: Tue, 19 Jan 2016 16:09:31 +0100
Message-ID: <569E51AB.2040001@invoxia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37289 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbcASPJf (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 19 Jan 2016 10:09:35 -0500
Received: by mail-wm0-f45.google.com with SMTP id n5so116910097wmn.0
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Jan 2016 07:09:34 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>

Hi,

I'm following the progress done for supporting NFS as lower layer.
It is still not working since ENXIO is returned on every attempt to open 
a file (linux 4.4 + overlayfs-next branch)

here is a simple example:

mkdir /tmp/nfs
mount -t nfs x.x.x.x:/export/foo  -o nolock /tmp/nfs

mkdir -p /tmp/nv/overlay.wd
mkdir -p /tmp/nv/upper

mkdir /tmp/ovl
mount -t overlay overlay 
-olowerdir=/tmp/nfs,upperdir=/tmp/nv/upper,workdir=/tmp/nv/overlay.wd 
/tmp/ovl

# up to this point every thing is fine. "ls" is working. yet

cat /tmp/ovl/some_file_exisiting on /tmp/nfs
cat: can't open '/tmp/ovl/some_file_exisiting': No such device or address


I dig and I just found that it fails because every inode created by 
ovl_lookup() are keeping the initial no_open() (fs/inode.c) method as 
inode->i_fops->open,

[<800d38f4>] (inode_init_always) from [<800d4204>] (alloc_inode+0x48/0x98)
[<800d4204>] (alloc_inode) from [<800d5fac>] (new_inode_pseudo+0x8/0x64)
[<800d5fac>] (new_inode_pseudo) from [<800d6014>] (new_inode+0xc/0x20)
[<800d6014>] (new_inode) from [<80179688>] (ovl_new_inode+0x10/0xe0)
[<80179688>] (ovl_new_inode) from [<80178ae8>] (ovl_lookup+0x1d0/0x44c)
[<80178ae8>] (ovl_lookup) from [<800c5f00>] (lookup_real+0x30/0x4c)
[<800c5f00>] (lookup_real) from [<800c9030>] (lookup_open+0xd8/0x184)
[<800c9030>] (lookup_open) from [<800c9284>] (do_last+0x1a8/0x6e8)
[<800c9284>] (do_last) from [<800c9858>] (path_openat+0x94/0x134)
[<800c9858>] (path_openat) from [<800caec8>] (do_filp_open+0x38/0x84)
[<800caec8>] (do_filp_open) from [<800bd604>] (do_sys_open+0x124/0x1c4)
[<800bd604>] (do_sys_open) from [<8000ed20>] (ret_fast_syscall+0x0/0x3c)

When the layer is not a remote one (eg. ramfs), d_select_inode() is 
called before the open() call, giving a change to change i_fops content 
with the real ones.
But in NFS case, the i_fops switch done during d_select_inode() is not 
done, and vfs_open() will finally call no_open() returning ENXIO.

Just trying to also add a "d_select_inode" phase in 
"ovl_reval_dentry_operations" fix this... but the system crash later 
when the file is closed.
Just to tell that there is still something missing...

Unfortunately, I'm definitely not familiar at all with VFS & co to 
understand exactly what is missing ;)

Regards,
Arnaud
