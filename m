Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 3/3] ovl: set d->is_dir and d->opaque for last path element
Date: Thu,  8 Mar 2018 17:18:04 -0500
Message-Id: <20180308221804.15708-4-vgoyal@redhat.com>
In-Reply-To: <20180308221804.15708-1-vgoyal@redhat.com>
References: <20180308221804.15708-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Certain properties in ovl_lookup_data should be set only for the last
element of the path. IOW, of we are calling ovl_lookup_single() for an
absolute redirect, then d->is_dir and d->opaque do not make much sense
for intermediate path elements. Instead set them only if dentry being
lookup is last path element.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/namei.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 32d1d96f80b6..dfefe6277659 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -220,6 +220,7 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 {
 	struct dentry *this;
 	int err;
+	bool last_element = !post[0];
 
 	this = lookup_one_len_unlocked(name, base, namelen);
 	if (IS_ERR(this)) {
@@ -247,9 +248,10 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 			goto put_and_out;
 		goto out;
 	}
-	d->is_dir = true;
+	if (last_element)
+		d->is_dir = true;
 	if (!d->last) {
-		if (ovl_is_opaquedir(this)) {
+		if (last_element && ovl_is_opaquedir(this)) {
 			d->stop = d->opaque = true;
 			goto out;
 		}
-- 
2.13.6
