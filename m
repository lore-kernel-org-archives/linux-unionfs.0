From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RESEND 1/2] ovl: free stack of paths in ovl_fill_super
Date: Mon, 24 Aug 2015 15:57:18 +0300
Message-ID: <20150824125718.6218.9443.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This fixes small memory leak after mount.

Kmemleak report:

unreferenced object 0xffff88003683fe00 (size 16):
  comm "mount", pid 2029, jiffies 4294909563 (age 33.380s)
  hex dump (first 16 bytes):
    20 27 1f bb 00 88 ff ff 40 4b 0f 36 02 88 ff ff   '......@K.6....
  backtrace:
    [<ffffffff811f8cd4>] create_object+0x124/0x2c0
    [<ffffffff817a059b>] kmemleak_alloc+0x7b/0xc0
    [<ffffffff811dffe6>] __kmalloc+0x106/0x340
    [<ffffffffa01b7a29>] ovl_fill_super+0x389/0x9a0 [overlay]
    [<ffffffff81200ac4>] mount_nodev+0x54/0xa0
    [<ffffffffa01b7118>] ovl_mount+0x18/0x20 [overlay]
    [<ffffffff81201ab3>] mount_fs+0x43/0x170
    [<ffffffff81220d34>] vfs_kern_mount+0x74/0x170
    [<ffffffff812233ad>] do_mount+0x22d/0xdf0
    [<ffffffff812242cb>] SyS_mount+0x7b/0xc0
    [<ffffffff817b6bee>] entry_SYSCALL_64_fastpath+0x12/0x76
    [<ffffffffffffffff>] 0xffffffffffffffff

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Fixes: a78d9f0d5d5c ("ovl: support multiple lower layers")
Cc: stable@vger.kernel.org # v4.0
---
 fs/overlayfs/super.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 7466ff339c66..3f90c43c3c4a 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1048,6 +1048,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		oe->lowerstack[i].dentry = stack[i].dentry;
 		oe->lowerstack[i].mnt = ufs->lower_mnt[i];
 	}
+	kfree(stack);
 
 	root_dentry->d_fsdata = oe;
 
