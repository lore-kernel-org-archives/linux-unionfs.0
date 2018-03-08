Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: fix lookup with middle layer opaque dir and absolute path redirects
Date: Thu,  8 Mar 2018 23:31:40 +0200
Message-Id: <1520544700-17628-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

The only way to explain the problem is with an example.
Watch me make foo disappear:

 $ mkdir lower middle upper work work2 merged
 $ mkdir lower/origin
 $ touch lower/origin/foo
 $ mount -t overlay none merged/ \
         -olowerdir=lower,upperdir=middle,workdir=work2
 $ mkdir merged/pure
 $ mv merged/origin merged/pure/redirect
 $ umount merged
 $ mount -t overlay none merged/ \
         -olowerdir=middle:lower,upperdir=upper,workdir=work
 $ mv merged/pure/redirect merged/redirect

Now you see foo inside a twice redirected merged dir:

 $ ls merged/redirect
 foo
 $ umount merged
 $ mount -t overlay none merged/ \
         -olowerdir=middle:lower,upperdir=upper,workdir=work

After mount cycle you don't see foo inside the same dir:

 $ ls merged/redirect

During middle layer lookup, the opaqueness of middle/pure is left in
the lookup state and then middle/pure/redirect is wrongly treated as
opaque.

Fixes: 02b69b284cd7 ("ovl: lookup redirects")
Cc: <stable@vger.kernel.org> #v4.10
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Vivek,

This is the bug I was talking about in review of metacopy lookup.

Miklos,

This change seems a bit subtle... besides the reproducer I sanity tested
redirects with unionmount-testsuite ./run --ov=10 and the overlay/quick
xfstests. Neither would have hit this sort of corner case though.
I will add a test to cover this case later on.

Thanks,
Amir.

 fs/overlayfs/namei.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 70fcfcc684cc..31ca563b7666 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -51,6 +51,14 @@ static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
 	if (res == 0)
 		goto invalid;
 	if (buf[0] == '/') {
+		/*
+		 * One of the ancestor path elements in an absolute path
+		 * lookup in ovl_lookup_layer() could have been opaque, but it
+		 * possible for a decendant path element to reset opaqueness in
+		 * case this path element has an absolute redirect to a lower
+		 * layer.
+		 */
+		d->stop = d->opaque = false;
 		for (s = buf; *s++ == '/'; s = next) {
 			next = strchrnul(s, '/');
 			if (s == next)
-- 
2.7.4
