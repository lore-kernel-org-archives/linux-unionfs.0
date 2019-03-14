From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/4] fscrypt: Implement FS_CFLG_OWN_D_OPS
Date: Thu, 14 Mar 2019 18:15:56 +0100
Message-ID: <20190314171559.27584-2-richard@nod.at>
References: <CAJfpegvX4ANfso-Jn1zaB+m4Q_0eK9i-+MCJ+sTH5QzD3PZFMQ@mail.gmail.com>
 <20190314171559.27584-1-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <20190314171559.27584-1-richard@nod.at>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: linux-mtd@lists.infradead.org
Cc: tytso@mit.edu, miklos@szeredi.hu, Richard Weinberger <richard@nod.at>, amir73il@gmail.com, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, paullawrence@google.com, linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, jaegeuk@kernel.org
List-Id: linux-unionfs@vger.kernel.org

If a filesystem sets FS_CFLG_OWN_D_OPS it manages dentry operations
itself and fscrypt is not allowed to set them.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/crypto/hooks.c       | 4 +++-
 include/linux/fscrypt.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 56debb1fcf5e..3ec925405fbe 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -107,7 +107,9 @@ int __fscrypt_prepare_lookup(struct inode *dir, struct dentry *dentry)
 		spin_unlock(&dentry->d_lock);
 	}
 
-	d_set_d_op(dentry, &fscrypt_d_ops);
+	if ((dir->i_sb->s_cop->flags & FS_CFLG_OWN_D_OPS) == 0)
+		d_set_d_op(dentry, &fscrypt_d_ops);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(__fscrypt_prepare_lookup);
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index e5194fc3983e..7139a110ac4f 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -48,6 +48,7 @@ struct fscrypt_name {
  * fscrypt superblock flags
  */
 #define FS_CFLG_OWN_PAGES (1U << 1)
+#define FS_CFLG_OWN_D_OPS (1U << 2)
 
 /*
  * crypto operations for filesystems
-- 
2.21.0


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
