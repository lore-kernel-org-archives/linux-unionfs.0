Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v2 2/4] ovl: Do not check for redirect if this is last layer
Date: Fri,  9 Mar 2018 15:44:42 -0500
Message-Id: <20180309204444.13237-3-vgoyal@redhat.com>
In-Reply-To: <20180309204444.13237-1-vgoyal@redhat.com>
References: <20180309204444.13237-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

If we are looking in last layer, then there should not be any need to
process redirect. redirect information is used only for lookup in next
lower layer and there is no more lower layer to look into. So no need
to process redirects.

IOW, ignore redirects on lowest layer.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 78798367c4f0..e27afd8d378a 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -248,7 +248,10 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 		goto out;
 	}
 	d->is_dir = true;
-	if (!d->last && ovl_is_opaquedir(this)) {
+	if (d->last)
+		goto out;
+
+	if (ovl_is_opaquedir(this)) {
 		d->stop = d->opaque = true;
 		goto out;
 	}
-- 
2.13.6
