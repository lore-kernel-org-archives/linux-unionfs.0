From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Overalyfs regression in 4.0
Date: Wed, 13 May 2015 17:11:01 +0200
Message-ID: <20150513151101.GA19583@tucsk.suse.de>
References: <CA+5PVA5uqoJjj24oUT=KMiVfytC7yyRtOggagv-5wUUcgG8iRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:33722 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934398AbbEMPIu (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 13 May 2015 11:08:50 -0400
Received: by wgin8 with SMTP id n8so46976654wgi.0
        for <linux-unionfs@vger.kernel.org>; Wed, 13 May 2015 08:08:49 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CA+5PVA5uqoJjj24oUT=KMiVfytC7yyRtOggagv-5wUUcgG8iRA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Miklos Szeredi <mszeredi@suse.cz>, Vincent Batts <vbatts@gmail.com>, David Howells <dhowells@redhat.com>, linux-unionfs@vger.kernel.org, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>

On Wed, May 13, 2015 at 09:06:26AM -0400, Josh Boyer wrote:
> Hi Miklos,
> 
> Vincent reported[1] what appears to be a regression in Overlayfs with
> 4.0.  This was found in the upstream docker community[2] on Ubuntu
> with 4.0.1 as well, so it is distro agnostic.  The following sequence
> of commands in the bug report seems to allow one to remove a non-empty
> directory.
> 
> Is this expected behavior now?  I looked through the commits in 4.0
> and saw a few that might lead to a behavior change, but I am not
> familiar enough with Overalyfs to know if this was intentional or not.
> 
> josh
> 
> [1] https://bugzilla.redhat.com/show_bug.cgi?id=1220915
> [2] https://github.com/docker/docker/issues/13108

Good report, thanks!

Follwing patch should fix it.

Thanks,
Miklos

---
Subject: ovl: don't remove non-empty opaque directory
From: Miklos Szeredi <mszeredi@suse.cz>

When removing an opaque directory we can't just call rmdir() to check for
emptyness, because the directory will need to be replaced with a whiteout.
The replacement is done with RENAME_EXCHANGE, which doesn't check
emptyness.

Solution is just to check emptyness by reading the directory.  In the
future we could add a new rename flag to check for emptyness even for
RENAME_EXCHANGE to optimize this case.

Reported-by: Vincent Batts <vbatts@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Fixes: 263b4a0fee43 ("ovl: dont replace opaque dir")
Cc: <stable@vger.kernel.org> # v4.0+
---
 fs/overlayfs/dir.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -506,11 +506,25 @@ static int ovl_remove_and_whiteout(struc
 	struct dentry *opaquedir = NULL;
 	int err;
 
-	if (is_dir && OVL_TYPE_MERGE_OR_LOWER(ovl_path_type(dentry))) {
-		opaquedir = ovl_check_empty_and_clear(dentry);
-		err = PTR_ERR(opaquedir);
-		if (IS_ERR(opaquedir))
-			goto out;
+	if (is_dir) {
+		if (OVL_TYPE_MERGE_OR_LOWER(ovl_path_type(dentry))) {
+			opaquedir = ovl_check_empty_and_clear(dentry);
+			err = PTR_ERR(opaquedir);
+			if (IS_ERR(opaquedir))
+				goto out;
+		} else {
+			LIST_HEAD(list);
+
+			/*
+			 * When removing an empty opaque directory, then it
+			 * makes no sense to replace it with an exact replica of
+			 * itself.  But emptiness still needs to be checked.
+			 */
+			err = ovl_check_empty_dir(dentry, &list);
+			ovl_cache_free(&list);
+			if (err)
+				goto out;
+		}
 	}
 
 	err = ovl_lock_rename_workdir(workdir, upperdir);
