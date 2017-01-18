From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2] ovl: fix possible use after free on redirect dir
 lookup
Date: Wed, 18 Jan 2017 11:38:34 +0100
Message-ID: <20170118103834.GG27207@veci.piliscsaba.szeredi.hu>
References: <1484656498-5265-1-git-send-email-amir73il@gmail.com>
 <1484727330-7260-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36137 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751842AbdARKim (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Jan 2017 05:38:42 -0500
Received: by mail-wm0-f67.google.com with SMTP id r126so3014643wmr.3
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Jan 2017 02:38:41 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1484727330-7260-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org

Amir,

Thanks for spotting this bug and for the patch.

I simplified it a bit (appended)

I don't think it's justified to copy the string just for the sake of an
assertation, so got rid of that.  Also tweaked the breakout condition to make
things clearer.

Only compile tested.  Please let me know if this works or not.

Thanks,
Miklos

---
From: Amir Goldstein <amir73il@gmail.com>
Subject: ovl: fix possible use after free on redirect dir lookup

ovl_lookup_layer() iterates on path elements of d->name.name
but also frees and allocates a new pointer for d->name.name.

For the case of lookup in upper layer, the initial d->name.name
pointer is stable (dentry->d_name), but for lower layers, the
initial d->name.name can be d->redirect, which can be freed during
iteration.

[SzM]
Keep the count of remaining characters in the redirect path and calculate
the current position from that.  This works becuase only the prefix is
modified, the ending always stays the same.

Fixes: 02b69b284cd7 ("ovl: lookup redirects")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/namei.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -154,29 +154,32 @@ static int ovl_lookup_single(struct dent
 static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
 			    struct dentry **ret)
 {
-	const char *s = d->name.name;
+	/* Counting down from the end, since the prefix can change */
+	size_t rem = d->name.len;
 	struct dentry *dentry = NULL;
 	int err;
 
-	if (*s != '/')
+	if (d->name.name[0] != '/')
 		return ovl_lookup_single(base, d, d->name.name, d->name.len,
 					 0, "", ret);
 
-	while (*s++ == '/' && !IS_ERR_OR_NULL(base) && d_can_lookup(base)) {
+	rem--;
+	while (!IS_ERR_OR_NULL(base) && d_can_lookup(base)) {
+		const char *s = d->name.name + d->name.len - rem;
 		const char *next = strchrnul(s, '/');
-		size_t slen = strlen(s);
+		size_t thislen = next - s;
+		bool end = !next[0];
 
-		if (WARN_ON(slen > d->name.len) ||
-		    WARN_ON(strcmp(d->name.name + d->name.len - slen, s)))
-			return -EIO;
-
-		err = ovl_lookup_single(base, d, s, next - s,
-					d->name.len - slen, next, &base);
+		err = ovl_lookup_single(base, d, s, thislen,
+					d->name.len - rem, next, &base);
 		dput(dentry);
 		if (err)
 			return err;
 		dentry = base;
-		s = next;
+		if (end)
+			break;
+
+		rem -= thislen + 1;
 	}
 	*ret = dentry;
 	return 0;
