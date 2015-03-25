From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/15] VFS: Fix up missed bits of lustre to use d_inode()
Date: Wed, 25 Mar 2015 14:44:08 +0000
Message-ID: <20150325144408.17670.52088.stgit@warthog.procyon.org.uk>
References: <20150325144330.17670.6959.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150325144330.17670.6959.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@ftp.linux.org.uk
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu
List-Id: linux-unionfs@vger.kernel.org

Fix up missed bits of lustre to use d_inode() where the clause didn't match
the autoconversion script RE because of brackets.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/staging/lustre/lustre/llite/namei.c     |    2 +-
 drivers/staging/lustre/lustre/llite/statahead.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
index 890ac190f5fa..a27193b316eb 100644
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@ -447,7 +447,7 @@ static int ll_lookup_it_finish(struct ptlrpc_request *request,
 		   !it_disposition(it, DISP_OPEN_CREATE)) {
 		/* With DISP_OPEN_CREATE dentry will
 		   instantiated in ll_create_it. */
-		LASSERT((*de)->d_inode == NULL);
+		LASSERT(d_inode(*de) == NULL);
 		d_instantiate(*de, inode);
 	}
 
diff --git a/drivers/staging/lustre/lustre/llite/statahead.c b/drivers/staging/lustre/lustre/llite/statahead.c
index 6ad9dd0fe2b3..b27dc991aa3a 100644
--- a/drivers/staging/lustre/lustre/llite/statahead.c
+++ b/drivers/staging/lustre/lustre/llite/statahead.c
@@ -1595,7 +1595,7 @@ int do_statahead_enter(struct inode *dir, struct dentry **dentryp,
 			rc = md_revalidate_lock(ll_i2mdexp(dir), &it,
 						ll_inode2fid(inode), &bits);
 			if (rc == 1) {
-				if ((*dentryp)->d_inode == NULL) {
+				if (d_inode(*dentryp) == NULL) {
 					struct dentry *alias;
 
 					alias = ll_splice_alias(inode,
@@ -1605,13 +1605,13 @@ int do_statahead_enter(struct inode *dir, struct dentry **dentryp,
 						return PTR_ERR(alias);
 					}
 					*dentryp = alias;
-				} else if ((*dentryp)->d_inode != inode) {
+				} else if (d_inode(*dentryp) != inode) {
 					/* revalidate, but inode is recreated */
 					CDEBUG(D_READA,
 					      "stale dentry %pd inode %lu/%u, statahead inode %lu/%u\n",
 					      *dentryp,
-					      (*dentryp)->d_inode->i_ino,
-					      (*dentryp)->d_inode->i_generation,
+					      d_inode(*dentryp)->i_ino,
+					      d_inode(*dentryp)->i_generation,
 					      inode->i_ino,
 					      inode->i_generation);
 					ll_sai_unplug(sai, entry);
