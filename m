Return-Path: <vgoyal@redhat.com>
Date: Mon, 12 Mar 2018 10:30:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v2.1 4/4] ovl: fix lookup with middle layer opaque dir and
 absolute path redirects
Message-ID: <20180312143041.GB2718@redhat.com>
References: <20180309204444.13237-1-vgoyal@redhat.com>
 <20180309204444.13237-5-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180309204444.13237-5-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com
List-ID: <linux-unionfs@vger.kernel.org>


From: Amir Goldstein <amir73il@gmail.com>
 
As of now if we encounter an opaque dir while looking for a dentry, we set
d->last=true. This means that there is no need to look further in any of
the lower layers. This works fine as long as there are no redirets or
relative redircts. But what if there is an absolute redirect on the
children dentry of opaque directory. We still need to continue to look into
next lower layer. This patch fixes it.

Here is an example to demonstrate the issue. Say you have following setup.

upper:  /redirect (redirect=/a/b/c)
lower1: /a/[b]/c       ([b] is opaque) (c has absolute redirect=/a/b/d/)
lower0: /a/b/d/foo

Now "redirect" dir should merge with lower1:/a/b/c/ and lower0:/a/b/d. Note,
despite the fact lower1:/a/[b] is opaque, we need to continue to look into
lower0 because children c has an absolute redirect.

Following is a reproducer.

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
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/namei.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: rhvgoyal-linux/fs/overlayfs/namei.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/namei.c	2018-03-12 09:09:28.239836991 -0400
+++ rhvgoyal-linux/fs/overlayfs/namei.c	2018-03-12 09:16:48.004836991 -0400
@@ -56,6 +56,15 @@ static int ovl_check_redirect(struct den
 			if (s == next)
 				goto invalid;
 		}
+		/*
+		 * One of the ancestor path elements in an absolute path
+		 * lookup in ovl_lookup_layer() could have been opaque and
+		 * that will stop further lookup in lower layers (d->stop=true)
+		 * But we have found an absolute redirect in decendant path
+		 * element and that should force continue lookup in lower
+		 * layers (reset d->stop).
+		 */
+		d->stop = false;
 	} else {
 		if (strchr(buf, '/') != NULL)
 			goto invalid;
