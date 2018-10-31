Return-Path: <xiakaixu1987@gmail.com>
Return-Path: <xiakaixu1987@gmail.com>
From: kaixuxia <xiakaixu1987@gmail.com>
Subject: [PATCH] ovl: do not hash ovl dentry when inode is NULL in ovl_lookup
Message-ID: <877bef77-3434-656f-a989-143179c2e1b7@gmail.com>
Date: Wed, 31 Oct 2018 15:12:03 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: miklos@szeredi.hu
Cc: linux-unionfs@vger.kernel.org, amir73il@gmail.com
List-ID: <linux-unionfs@vger.kernel.org>

The dentry is hashed even if the inode is NULL in ovl_lookup and
later we get this dentry in lookup_dcache. But this dentry may
become stale when someone could (mistakenly or maliciously) manually
unlink the whiteout file directly from upperdir. So the NUll pointer
error occur when create the same name directory and system crash.

Simple reproducer:
   $ mkdir lower upper work merge
   $ touch lower/file
   $ mount -t overlay overlay 
-olowerdir=lower,upperdir=upper,workdir=work merge
   $ rm merge/file
   $ ls -al merge/file
ls: cannot access merge/file: No such file or directory
   $ rm upper/file
   $ ls -al merge/
ls: cannot access merge/file: No such file or directory
total 0
drwxr-xr-x 1 root root  6 Oct 30 09:16 .
drwxr-xr-x 6 root root 57 Oct 30 09:15 ..
-????????? ? ?    ?     ?            ? file
   $ mkdir merge/file
Killed

[ 2313.705789] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000000
[ 2313.706124] PGD 80000005082af067 P4D 80000005082af067 PUD 4f9133067 PMD 0
[ 2313.706408] Oops: 0000 [#1] SMP PTI
[ 2313.706592] CPU: 1 PID: 6162 Comm: mkdir Not tainted 4.19.0-tlinux2+ #3
[ 2313.706861] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS 
VirtualBox 12/01/2006
[ 2313.707304] RIP: 0010:xfs_vn_rename+0x4d/0x150 [xfs]
[ 2313.707619] Code: 00 00 00 48 89 44 24 30 31 c0 41 f7 c0 f8 ff ff ff 
0f 85 ec 00 00 00 41
[ 2313.708495] RSP: 0018:ffffa1b18746bc78 EFLAGS: 00010202
[ 2313.708824] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 
ffff9171b9db5c00
[ 2313.709198] RDX: ffff9171c26dc8c8 RSI: ffff9171ba113480 RDI: 
ffff9171ba025b88
[ 2313.709573] RBP: ffff9171b9db5c00 R08: 0000000000000002 R09: 
0000000000000002
[ 2313.709947] R10: 0000000000000000 R11: 000000007fffffff R12: 
ffff9171ba113480
[ 2313.710324] R13: ffff9171ba025b88 R14: ffff9171c26dc8c8 R15: 
0000000000000000
[ 2313.710699] FS:  00007fb6c909b800(0000) GS:ffff9171cba80000(0000) 
knlGS:0000000000000000
[ 2313.711187] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2313.711524] CR2: 0000000000000000 CR3: 000000050691a000 CR4: 
00000000000406e0
[ 2313.711900] Call Trace:
[ 2313.712949]  vfs_rename+0x1d8/0x740
[ 2313.713243]  ? ovl_check_setxattr+0x5c/0xf0 [overlay]
[ 2313.713579]  ovl_do_rename+0x36/0xa0 [overlay]
[ 2313.713884]  ovl_create_or_link+0x508/0x5a0 [overlay]
[ 2313.714209]  ? ovl_sync_fs+0x10/0x50 [overlay]
[ 2313.714514]  ? kmem_cache_alloc+0x190/0x1a0
[ 2313.714809]  ? inode_init_always+0x110/0x1c0
[ 2313.715105]  ? inode_sb_list_add+0x47/0x80
[ 2313.715397]  ? ovl_fill_inode+0x134/0x140 [overlay]
[ 2313.715711]  ovl_create_object+0xda/0x110 [overlay]
[ 2313.716027]  vfs_mkdir+0xbf/0x160
[ 2313.716297]  do_mkdirat+0x77/0xe0
[ 2313.716602]  do_syscall_64+0x3f/0xf0
[ 2313.716891]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Signed-off-by: kaixuxia <xiakaixu1987@gmail.com>
---
  fs/overlayfs/namei.c | 2 ++
  1 file changed, 2 insertions(+)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 9c0ca6a..b2c7b4a 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1075,6 +1075,8 @@ struct dentry *ovl_lookup(struct inode *dir, 
struct dentry *dentry,
         dput(index);
         kfree(stack);
         kfree(d.redirect);
+       if (!inode)
+               return NULL;
         return d_splice_alias(inode, dentry);

  out_free_oe:
-- 
1.8.3.1

-- 
kaixuxia
