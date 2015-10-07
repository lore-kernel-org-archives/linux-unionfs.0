From: Alban Crequy <alban.crequy@gmail.com>
Subject: overlayfs: regression bug from 4bacc9c9 (Make f_path always point to
 the overlay and f_inode to the underlay)
Date: Wed, 7 Oct 2015 14:23:23 +0200
Message-ID: <CAMXgnP7G-6bOu==DC_q2iQkfQ5p3YjSM8j1t=d-RbHBh-V9rOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, sds@tycho.nsa.gov, Alexander Viro <viro@zeniv.linux.org.uk>, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, LSM <linux-security-module@vger.kernel.org>, linux-unionfs@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iaguis@gmail.com>
List-Id: linux-unionfs@vger.kernel.org

Hi,

I'm reporting an issue in overlay fs that was introduced in v4.2 (it
worked on v4.1): when overlay fs is mounted inside a overlay fs, I get
a "no such device or address" error (ENXIO) during open(). After
adding some debug printks, I found that the ENXIO comes from
fs/inode.c:no_open().

The bug was initially reported on:
https://github.com/coreos/rkt/issues/1537

The following commands can reproduce the issue:

# mkdir upper lower work merged
# mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work merged/
# cd merged
# mkdir upper2 lower2 work2 merged2
# mount -t overlay overlay
-olowerdir=lower2,upperdir=upper2,workdir=work2 merged2/
# cd merged2
# echo hello > test.txt
bash: test.txt: No such device or address

For debugging purposes, I added a "BUG()" in fs/inode.c:no_open() in
order to see the stack at the moment the ENXIO is returned:

[    0.446166] Call Trace:
[    0.446166]  [<ffffffff8121701f>] do_dentry_open+0x1ff/0x2f0
[    0.446166]  [<ffffffff81232960>] ? inode_init_always+0x1b0/0x1b0
[    0.446166]  [<ffffffff812184c6>] vfs_open+0x56/0x60
[    0.446166]  [<ffffffff812271ee>] path_openat+0x1de/0x1250
[    0.446166]  [<ffffffff8119ee61>] ? filemap_fault+0xb1/0x420
[    0.446166]  [<ffffffff811bcf00>] ? __inc_zone_state+0x20/0x60
[    0.446166]  [<ffffffff81229401>] do_filp_open+0x91/0x100
[    0.446166]  [<ffffffff811fad03>] ? kmem_cache_alloc+0x193/0x210
[    0.446166]  [<ffffffff81228436>] ? getname_flags+0x56/0x1f0
[    0.446166]  [<ffffffff8123634f>] ? __alloc_fd+0x3f/0x100
[    0.446166]  [<ffffffff8121887a>] do_sys_open+0x13a/0x230
[    0.446166]  [<ffffffff8121898e>] SyS_open+0x1e/0x20
[    0.446166]  [<ffffffff81790fee>] entry_SYSCALL_64_fastpath+0x12/0x71

git-bisect found the following:

> 4bacc9c9234c7c8eec44f5ed4e960d9f96fa0f01 is the first bad commit
> commit 4bacc9c9234c7c8eec44f5ed4e960d9f96fa0f01
> Author: David Howells <dhowells@redhat.com>
> Date:   Thu Jun 18 14:32:31 2015 +0100
>
>     overlayfs: Make f_path always point to the overlay
>     and f_inode to the underlay

See patch (2) in https://lwn.net/Articles/648525/:

> (2) The main VFS patch that makes an open file struct referring to a union
>     file have ->f_path point to the union/overlay file whilst ->f_inode and
>     ->f_mapping refer to the subordinate file that does the actual work.

Cheers,
Alban
