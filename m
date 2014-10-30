From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Overlayfs: ovl_fill_merge() should use container_of()
 rather than direct cast
Date: Thu, 30 Oct 2014 14:10:05 +0000
Message-ID: <20141030141004.28203.79687.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@ZenIV.linux.org.uk, miklos@szeredi.hu
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

ovl_fill_merge() effectively directly casts the buf pointer to an
ovl_readdir_data struct pointer, but the pointer actually points to the
dir_context struct contained therein.

So use container_of() instead.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/overlayfs/readdir.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 910553f37aca..d142c2bf8f1e 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -181,7 +181,9 @@ static void ovl_cache_put(struct ovl_dir_file *od, struct dentry *dentry)
 static int ovl_fill_merge(void *buf, const char *name, int namelen,
 			  loff_t offset, u64 ino, unsigned int d_type)
 {
-	struct ovl_readdir_data *rdd = buf;
+	struct dir_context *ctx = buf;
+	struct ovl_readdir_data *rdd =
+		container_of(ctx, struct ovl_readdir_data, ctx);
 
 	rdd->count++;
 	if (!rdd->is_merge)
