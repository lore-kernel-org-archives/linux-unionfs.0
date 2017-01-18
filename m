From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2] ovl: fix possible use after free on redirect dir lookup
Date: Wed, 18 Jan 2017 10:15:30 +0200
Message-ID: <1484727330-7260-1-git-send-email-amir73il@gmail.com>
References: <1484656498-5265-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34504 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751570AbdARIX1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Jan 2017 03:23:27 -0500
Received: by mail-wm0-f66.google.com with SMTP id c85so2239113wmi.1
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Jan 2017 00:23:26 -0800 (PST)
In-Reply-To: <1484656498-5265-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

ovl_lookup_layer() iterates on path elements of d->name.name
but also frees and allocates a new pointer for d->name.name.

For the case of lookup in upper layer, the initial d->name.name
pointer is stable (dentry->d_name), but for lower layers, the
initial d->name.name can be d->redirect, which can be freed during
iteration.

Make a copy of initial d->name.name before iterating it and reset
the iteration pointer to point inside the newly allocated d->redirect
path after lookup of every element in the path.

Fixes: 02b69b284cd7 ("ovl: lookup redirects")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

Miklos,

I was pretty close with the test case yesterday, but got it right this morning:
https://github.com/amir73il/unionmount-testsuite/commit/fac638f1d1d0191ca3590f22519a4715a96d5bf2

'./run --ov=20 rename-move-dir' fails on kernel 4.10-rc1:
...
TEST rename-move-dir.py:123: Rename populated dir and parent and move into another
 ./run --rename /mnt/a/dir106/pop /mnt/a/dir106/popx  #no_recycle
 ./run --rename /mnt/a/dir106 /mnt/a/dir106x             #recycle
 ./run --rename /mnt/a/dir106x/popx /mnt/a/empty106/popx #recycle
...
 ./run --open-file /mnt/a/empty106/popx -r -d
/mnt/a/empty106/popx/b: File is missing

I actually wrote the right test description yesterday:
("Rename populated dir and parent and move self into another dir")
but implemented instead:
("Rename populated dir and child and move self into another dir")

Both cases get to a point of iterating over freed memory and that
causes iteration to stop (*s != '/') on my debug kernel.
Latter case would have stopped iterating anyway (postlen == 0),
while Former case would have continued iterating, but does not,
so the test case fails to lookup inside the moved directory.

Amir.

v2:
- Remove stable tag
- Add Fixes tag

v1:
- Initial fix

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 9ad48d9..9cb589c 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -154,6 +154,7 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
 			    struct dentry **ret)
 {
+	struct qstr name = d->name;
 	const char *s = d->name.name;
 	struct dentry *dentry = NULL;
 	int err;
@@ -162,24 +163,36 @@ static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
 		return ovl_lookup_single(base, d, d->name.name, d->name.len,
 					 0, "", ret);
 
+	/* ovl_lookup_single() -> ovl_check_redirect() may free d->name.name */
+	s = name.name = kstrdup(d->name.name, GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+
 	while (*s++ == '/' && !IS_ERR_OR_NULL(base) && d_can_lookup(base)) {
-		const char *next = strchrnul(s, '/');
+		const char *post = strchrnul(s, '/');
 		size_t slen = strlen(s);
+		size_t postlen = slen - (post - s);
 
-		if (WARN_ON(slen > d->name.len) ||
-		    WARN_ON(strcmp(d->name.name + d->name.len - slen, s)))
-			return -EIO;
-
-		err = ovl_lookup_single(base, d, s, next - s,
-					d->name.len - slen, next, &base);
+		err = ovl_lookup_single(base, d, s, post - s,
+					d->name.len - slen, post, &base);
 		dput(dentry);
 		if (err)
-			return err;
+			goto out_err;
 		dentry = base;
-		s = next;
+
+		/* d->name.name may be a new string with modified prefix */
+		s = d->name.name + d->name.len - postlen;
+		err = -EIO;
+		if (WARN_ON(postlen > name.len) ||
+		    WARN_ON(strcmp(name.name + name.len - postlen, s)))
+			goto out_err;
 	}
+
 	*ret = dentry;
-	return 0;
+	err = 0;
+out_err:
+	kfree(name.name);
+	return err;
 }
 
 /*
-- 
2.7.4
