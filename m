From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/4] ubifs: Simplify fscrypt_get_encryption_info() error
 handling
Date: Thu, 14 Mar 2019 18:15:58 +0100
Message-ID: <20190314171559.27584-4-richard@nod.at>
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

fscrypt_get_encryption_info() does not return -ENOKEY,
there is no need to handle this case.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/ubifs/dir.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 5767b373a8ff..b0cb913697c5 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -526,7 +526,7 @@ static int ubifs_readdir(struct file *file, struct dir_context *ctx)
 
 	if (encrypted) {
 		err = fscrypt_get_encryption_info(dir);
-		if (err && err != -ENOKEY)
+		if (err)
 			return err;
 
 		err = fscrypt_fname_alloc_buffer(dir, UBIFS_MAX_NLEN, &fstr);
@@ -794,7 +794,7 @@ static int ubifs_unlink(struct inode *dir, struct dentry *dentry)
 
 	if (ubifs_crypt_is_encrypted(dir)) {
 		err = fscrypt_get_encryption_info(dir);
-		if (err && err != -ENOKEY)
+		if (err)
 			return err;
 	}
 
@@ -904,7 +904,7 @@ static int ubifs_rmdir(struct inode *dir, struct dentry *dentry)
 
 	if (ubifs_crypt_is_encrypted(dir)) {
 		err = fscrypt_get_encryption_info(dir);
-		if (err && err != -ENOKEY)
+		if (err)
 			return err;
 	}
 
-- 
2.21.0


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
