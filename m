From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/4] fscrypt: Export fscrypt_d_ops
Date: Thu, 14 Mar 2019 18:15:57 +0100
Message-ID: <20190314171559.27584-3-richard@nod.at>
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

If a filesystem manages dentry operations itself it might want to
re-use fscrypt_d_ops.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/crypto/crypto.c          | 1 +
 fs/crypto/fscrypt_private.h | 1 -
 include/linux/fscrypt.h     | 1 +
 3 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 4dc788e3bc96..8018f8bba50d 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -357,6 +357,7 @@ static int fscrypt_d_revalidate(struct dentry *dentry, unsigned int flags)
 const struct dentry_operations fscrypt_d_ops = {
 	.d_revalidate = fscrypt_d_revalidate,
 };
+EXPORT_SYMBOL(fscrypt_d_ops);
 
 void fscrypt_restore_control_page(struct page *page)
 {
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 7da276159593..bced1ee4fd64 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -125,7 +125,6 @@ extern int fscrypt_do_page_crypto(const struct inode *inode,
 				  gfp_t gfp_flags);
 extern struct page *fscrypt_alloc_bounce_page(struct fscrypt_ctx *ctx,
 					      gfp_t gfp_flags);
-extern const struct dentry_operations fscrypt_d_ops;
 
 extern void __printf(3, 4) __cold
 fscrypt_msg(struct super_block *sb, const char *level, const char *fmt, ...);
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 7139a110ac4f..2b9577e4707f 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -231,6 +231,7 @@ extern int __fscrypt_encrypt_symlink(struct inode *inode, const char *target,
 extern const char *fscrypt_get_symlink(struct inode *inode, const void *caddr,
 				       unsigned int max_size,
 				       struct delayed_call *done);
+extern const struct dentry_operations fscrypt_d_ops;
 #else  /* !CONFIG_FS_ENCRYPTION */
 
 static inline bool fscrypt_has_encryption_key(const struct inode *inode)
-- 
2.21.0


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
