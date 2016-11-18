From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Fri, 18 Nov 2016 17:37:12 +0200
Message-ID: <CAOQ4uxjD60ZqjXYq345SEjg79V89NvM8bUGt1=CUSiQHyQcBkA@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com> <20161025115748.ydhkkp5cfcdnjzwn@home.ouaza.com>
 <CAJfpegu97ce6LtMeKSHqDxZGAtCJUGgYUwOwYm9P6p8XtNXf_A@mail.gmail.com>
 <CALYGNiN_Hj+4Kf4HJihu5OEkNFU+zzioz5Cc1oHpJ8Wggi0M8Q@mail.gmail.com>
 <20161107110319.7goz3ym3e6fu5lag@home.ouaza.com> <CALYGNiP=BjxrU9YLL=bGJ5yXSefGMWEAU8ni23mUipL3frjhzA@mail.gmail.com>
 <20161107134215.2v5leafss2mamim5@home.ouaza.com> <CAJfpeguvHgWuefxfB76qPh8xGW74tuB1q3kgXvEBw5qY80xz-w@mail.gmail.com>
 <CAOQ4uxiC+O93=Dbgogc-GpL_7rF-qCRXeGzy3epVfpZRHNQf=A@mail.gmail.com>
 <CAOQ4uxjAZAWTy14B1HA-=RmPVsgBBXve7914g0gn7EG3xADebA@mail.gmail.com> <CAJfpegsKmo9zES6ZpHkjVE50z6ere3J9X2ixSFN6dhU_cEReSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33992 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751180AbcKRPhP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 18 Nov 2016 10:37:15 -0500
In-Reply-To: <CAJfpegsKmo9zES6ZpHkjVE50z6ere3J9X2ixSFN6dhU_cEReSw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Raphael Hertzog <hertzog@debian.org>, Konstantin Khlebnikov <koct9i@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Thu, Nov 17, 2016 at 12:00 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Mon, Nov 14, 2016 at 5:25 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Sun, Nov 13, 2016 at 12:00 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>
> >> Looks goods, except for the case of change from relative to absolute
> >> redirect of the victim dentry. IIUC, ovl_set_redirect() will return immediately
> >> because ovl_dentry_is_redirect() and will not get to setting the absolute
> >> redirect.
> >>
> >
> > I added some more tests to catch this problem at:
> > https://github.com/amir73il/unionmount-testsuite.git #ovl_rename_dir
>
> Thanks for testing.
>
> Force pushed updated version to the usual place:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git #redirect
>

Found one typo and one bug in error that can cause crash on dput(ERR_PTR(err)):

diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
index 21ddac7..0daac51 100644
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -15,7 +15,7 @@ config OVERLAY_FS_REDIRECT_DIR
        help
          If this config option is enabled then overlay filesystems will use
          redirects when renaming directories by default.  In this case it is
-         still possible possible to turn off redirects globally with the
+         still possible to turn off redirects globally with the
          "redirect_dir=off" module option or on a filesystem instance basis
          with the "redirect_dir=off" mount option.

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 5eaa9f9..a19fc5c 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -105,11 +105,12 @@ static int ovl_lookup_single(struct dentry
*base, struct ovl_lookup_data *d,

        this = lookup_one_len_unlocked(name, base, namelen);
        if (IS_ERR(this)) {
-               if (PTR_ERR(this) == -ENOENT ||
-                   PTR_ERR(this) == -ENAMETOOLONG) {
+               err = PTR_ERR(this);
+               if (err == -ENOENT || err == -ENAMETOOLONG) {
                        this = NULL;
+                       goto out;
                }
-               goto out;
+               return err;
        }
        if (!this->d_inode)
                goto put_and_out;

> This also has the xattr feature thing replaced with mount option,
> module param and kernel config option.
>

I like the kernel config/module param/mount option for
enabling/disabling the feature.

But I still think that we should write the features xattr on the first
redirect rename.
The features xattr tell us what can be found on the layer, so we would
be wise to
keep it around for all sorts of backward compatibility aspect.

Amir.
