From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RESEND 2/2] ovl: free lower_mnt array in ovl_put_super
Date: Mon, 24 Aug 2015 15:57:19 +0300
Message-ID: <20150824125719.6218.68404.stgit@buzz>
References: <20150824125718.6218.9443.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20150824125718.6218.9443.stgit@buzz>
Sender: stable-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This fixes memory leak after umount.

Kmemleak report:

unreferenced object 0xffff8800ba791010 (size 8):
  comm "mount", pid 2394, jiffies 4294996294 (age 53.920s)
  hex dump (first 8 bytes):
    20 1c 13 02 00 88 ff ff                           .......
  backtrace:
    [<ffffffff811f8cd4>] create_object+0x124/0x2c0
    [<ffffffff817a059b>] kmemleak_alloc+0x7b/0xc0
    [<ffffffff811dffe6>] __kmalloc+0x106/0x340
    [<ffffffffa0152bfc>] ovl_fill_super+0x55c/0x9b0 [overlay]
    [<ffffffff81200ac4>] mount_nodev+0x54/0xa0
    [<ffffffffa0152118>] ovl_mount+0x18/0x20 [overlay]
    [<ffffffff81201ab3>] mount_fs+0x43/0x170
    [<ffffffff81220d34>] vfs_kern_mount+0x74/0x170
    [<ffffffff812233ad>] do_mount+0x22d/0xdf0
    [<ffffffff812242cb>] SyS_mount+0x7b/0xc0
    [<ffffffff817b6bee>] entry_SYSCALL_64_fastpath+0x12/0x76
    [<ffffffffffffffff>] 0xffffffffffffffff

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Fixes: dd662667e6d3 ("ovl: add mutli-layer infrastructure")
Cc: stable@vger.kernel.org # v4.0
---
 fs/overlayfs/super.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 3f90c43c3c4a..8d04b86e0680 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -544,6 +544,7 @@ static void ovl_put_super(struct super_block *sb)
 	mntput(ufs->upper_mnt);
 	for (i = 0; i < ufs->numlower; i++)
 		mntput(ufs->lower_mnt[i]);
+	kfree(ufs->lower_mnt);
 
 	kfree(ufs->config.lowerdir);
 	kfree(ufs->config.upperdir);
