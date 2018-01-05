From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 07/23] ovl: verify stored origin fh matches lower dir
Date: Fri, 5 Jan 2018 11:35:22 -0500
Message-ID: <20180105163522.GE29480@redhat.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
 <1515084018-25134-8-git-send-email-amir73il@gmail.com>
 <20180105160427.GD29480@redhat.com>
 <CAOQ4uxg-DfS1iWzozN3LBhDJtO=TLkSjuXY+fe5O3Uz0hCGg-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56682 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751774AbeAEQfX (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 Jan 2018 11:35:23 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxg-DfS1iWzozN3LBhDJtO=TLkSjuXY+fe5O3Uz0hCGg-A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Jan 05, 2018 at 06:26:55PM +0200, Amir Goldstein wrote:
> On Fri, Jan 5, 2018 at 6:04 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Thu, Jan 04, 2018 at 06:40:02PM +0200, Amir Goldstein wrote:
> >> When the "verify" feature is enabled, a directory inode found in lower
> >> layer by name or by redirect_dir is verified against the file handle of
> >> the copy up origin that is stored in the upper layer.
> >>
> >> This introduces a change of behavior for the case of lower layer
> >> modification while overlay is offline. A lower directory created or
> >> moved offline under an exisitng upper directory, will not be merged with
> >> that upper directory.
> >>
> >> The "verify" feature should not be used after copying layers,
> >> because the new lower directory inodes would fail verification.
> >>
> >> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >> ---
> >>  Documentation/filesystems/overlayfs.txt | 16 ++++++++++++++++
> >>  fs/overlayfs/namei.c                    | 13 +++++++++++++
> >>  2 files changed, 29 insertions(+)
> >>
> >> diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
> >> index e6a5f4912b6d..00e0595f3d7e 100644
> >> --- a/Documentation/filesystems/overlayfs.txt
> >> +++ b/Documentation/filesystems/overlayfs.txt
> >> @@ -299,6 +299,22 @@ filesystem are not allowed.  If the underlying filesystem is changed,
> >>  the behavior of the overlay is undefined, though it will not result in
> >>  a crash or deadlock.
> >>
> >> +When the underlying filesystems supports NFS export, overlay mount can be
> >> +made more resilient to offline and online changes of the underlying lower
> >> +layer by enabling the "verify" feature.
> >> +
> >> +On every copy_up, an NFS file handle of the lower inode, along with the
> >> +UUID of the lower filesystem, are encoded and stored in an extended
> >> +attribute "trusted.overlay.origin" on the upper inode.
> >> +
> >> +When the "verify" feature is enabled, a lookup of a merged directory, that
> >> +found a lower directory at the lookup path or at the path pointed to by
> >> +the "trusted.overlay.redirect" extended attribute, will verify that the
> >> +found lower directory file handle and lower filesystem UUID match the
> >> +origin file handle that was stored at copy_up time.  If a found lower
> >> +directory does not match the stored origin, that directory will not be
> >> +merged with the upper directory.
> >> +
> >>  Testsuite
> >>  ---------
> >>
> >> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> >> index 46a3e31b0225..56deb2785af7 100644
> >> --- a/fs/overlayfs/namei.c
> >> +++ b/fs/overlayfs/namei.c
> >> @@ -734,6 +734,19 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
> >>                       }
> >>               }
> >>
> >> +             /*
> >> +              * When "verify" feature is enabled, do not merge with a lower
> >> +              * dir that does not match a stored origin xattr.
> >> +              */
> >> +             if (upperdentry && !ctr && ovl_verify(dentry->d_sb)) {
> >> +                     err = ovl_verify_origin(upperdentry, this, false,
> >> +                                             false);
> >> +                     if (err) {
> >> +                             dput(this);
> >> +                             break;
> >> +                     }
> >> +             }
> >> +
> >
> > So this will verify directory origin only for top level lower dir. Rest
> > of the lowers can still be modified offline without this code noticing it?
> >
> 
> Correct, from patch 6/23:
> 
> +       } else if (ofs->config.verify && ofs->config.upperdir && stacklen > 1) {
> +               pr_warn("overlayfs: option 'verify=on' cannot verify
> redirects from middle layer dirs\n");

So for non-dir case, we check origin by default and error out if decoding
of fh fails.  Why not do the same thing for directories as well. I mean
why directory origin check should be hidden behind a mount option
(verfiy=).

Vivek

> 
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
