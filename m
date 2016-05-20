From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] overlayfs: Do d_type check only if work dir creation was
 successful
Date: Fri, 20 May 2016 09:04:26 -0400
Message-ID: <20160520130426.GA31667@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, mszeredi@redhat.com
List-Id: linux-unionfs@vger.kernel.org

d_type check requires successful creation of workdir as iterates
through work dir and expects work dir to be present in it. If that's
not the case, this check will always return d_type not supported even
if underlying filesystem might be supporting it.

So don't do this check if work dir creation failed in previous step.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/super.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 791235e..48234425 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1064,16 +1064,19 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		/*
 		 * Upper should support d_type, else whiteouts are visible.
 		 * Given workdir and upper are on same fs, we can do
-		 * iterate_dir() on workdir.
+		 * iterate_dir() on workdir. This check requires successful
+		 * creation of workdir in previous step.
 		 */
-		err = ovl_check_d_type_supported(&workpath);
-		if (err < 0)
-			goto out_put_workdir;
+		if (ufs->workdir) {
+			err = ovl_check_d_type_supported(&workpath);
+			if (err < 0)
+				goto out_put_workdir;
 
-		if (!err) {
-			pr_err("overlayfs: upper fs needs to support d_type.\n");
-			err = -EINVAL;
-			goto out_put_workdir;
+			if (!err) {
+				pr_err("overlayfs: upper fs needs to support d_type.\n");
+				err = -EINVAL;
+				goto out_put_workdir;
+			}
 		}
 	}
 
-- 
2.7.4
