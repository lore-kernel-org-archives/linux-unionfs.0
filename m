From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 0/6] ovl: consistent_fd feature
Date: Thu, 30 Mar 2017 14:34:16 +0300
Message-ID: <CAOQ4uxgcOD0DEZse2hWRWopDdBPsb+f=XX0SPQirbX_WGmLR-w@mail.gmail.com>
References: <1490798166-22310-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36432 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750878AbdC3LeS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 30 Mar 2017 07:34:18 -0400
Received: by mail-oi0-f66.google.com with SMTP id b187so4160038oif.3
        for <linux-unionfs@vger.kernel.org>; Thu, 30 Mar 2017 04:34:17 -0700 (PDT)
In-Reply-To: <1490798166-22310-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

On Wed, Mar 29, 2017 at 5:36 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Mikos,
>
> This patch set implement the 'simple' solution we discussed on LSF.
> For the special case of all overlays on the same fs with clone support,
> files are copied up on open for read (as O_TMPFILE) and linked to
> upperdir on first open for write.
>
> - Patches 1-2 are the refactoring I sent you earlier.  They are not
>   strictly needed for the consistent_fd feature - up to you.
> - Patches 3-4 test 'samefs' and 'cloneup' properties of underlying fs.
> - Patch 5 copies up open for read (for the special case).
> - Patch 6 defers linking the tmpfile to first open for write.
>
> Some of the design choices for patch 6 are questionable:
> the storing of tempfile in ovl_dentry_update(),
> temp dentry is freed only on overlay dentry release.
> awaiting your feedback about those choises.
>
> xfstests run of ./check -overlay -g quick passed on
> both ext4 (no clone) and xfs+reflink (yes clone).
> test overlay/016 ("Test ro/rw fd data inconsistecies")
> passes with xfs+reflink.
> test overlay/013 ("Test truncate running executable...")
> fails with xfs+reflink, because test expects the inconsistency.
>
> I also modified unionmount-testsuite and added ./run --ov --samefs
> to setup lower+upper on same base fs of your choise [1].
> It passes with base fs tmpfs (no clone) and base fs xfs+reflink.
>

FYI, I also used this test patch to easily verify when temp inode has been
allocated (on open for read) and when it was freed (on drop_caches),
simply by looking at the overlay inode number.

I don't think we want to make this patch official, because then inode
number can change several times during the lifetime of overlay
instead of just once and worse, changing between 2 subsequent reads...

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 2fb90be..cd06425 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -62,10 +62,15 @@ static int ovl_getattr(const struct path *path,
struct kstat *stat,
 {
        struct dentry *dentry = path->dentry;
        struct path realpath;
+       enum ovl_path_type type = ovl_path_real(dentry, &realpath);
        const struct cred *old_cred;
        int err;

-       ovl_path_real(dentry, &realpath);
+       if (!OVL_TYPE_UPPER(type) && OVL_TYPE_RO_UPPER(type)) {
+               ovl_path_upper(dentry, &realpath);
+               realpath.dentry = ovl_dentry_ro_upper(dentry);
+       }
+
        old_cred = ovl_override_creds(dentry->d_sb);
        err = vfs_getattr(&realpath, stat, request_mask, flags);
        revert_creds(old_cred);
