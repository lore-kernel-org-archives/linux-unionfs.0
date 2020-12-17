Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73030C4361B
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Dec 2020 21:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D14023A54
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Dec 2020 21:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730152AbgLQV5p (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Dec 2020 16:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgLQV5p (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Dec 2020 16:57:45 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461C0C061794
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Dec 2020 13:57:05 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id q25so619543oij.10
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Dec 2020 13:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+NSeg1HJTtcRuNYWdd9oWzAbg6Uc7MhUrOjQsvHCTi8=;
        b=MN2kL7kLYDyEOhj0hG4hyg3bZfEH/yODiIDDNVomFyBEsRDv8t4LfkaVpNQPOiGtgu
         OCv3ixHDacFxzCQn/kZ5m4f1zmv9OyRPQLXSOZEwZLxRXL5GzfvG7mhAmhTCErrKhpMY
         /5FhiAZAMQC+8jk5wUPKb7nD/3SJcrVvGwDNjHjOEJlgywXX5be3zRQPWkrJzNRVDon8
         hAPeGk7dJayVUlBicw6/VH67wzAyeebR6dBKpbd7P/o5zOZ0i+Ro1oaJUhAm/cDwh8bu
         u+5fpXn4FmjWhlfxl+Pdu1pc3VQde0pKoFDcVTszx+q91MHR89yAnNaJgKZzI/+xtVhl
         4Uxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+NSeg1HJTtcRuNYWdd9oWzAbg6Uc7MhUrOjQsvHCTi8=;
        b=sg9mDlIOo9ZyJLqdGWYMzA8V89qGD4+uFgMdcFgD+hUPTDiT5iXkWw9PCo8GWXxazd
         BIceu1QqYXr/V/wiZ9iGfvjPxnHHVcYISdl70BvJFhwJEVqOtCzgQnScXIiJDn1ESqk+
         fURBf/YcvAvtKJg+rIfwkr42wqJwMB5jghM/4q1C+HrUOg1mgEfMoQLbjNPbTuGp1JkY
         ajDQGPKGxEvmkTN95YCAomDu8mDGom3w+1xpyl0aWW+JCK5D1P9Mdda9PmhBfZem99VV
         BUc1eH0RUqSgDW0OqYfYMv00wlUwN+258GfayLhKcOZLHuq+H2FMvkD/9YClGjpdiyXg
         GxFw==
X-Gm-Message-State: AOAM530+C1br8ooJXJyETsMomzCS27dKlDYv0fjFluGcnGKEKHEXz1p/
        BI4+ryqknjyjZh6jAn+f1bGCXeLeXfoF7CxGZAk=
X-Google-Smtp-Source: ABdhPJwXFX2ATAWQu+8TNLPW6Xv/fN8SMcMcr3o8VecoR2GcZU8dRKrLEoWBVqQBU2mkkstAQLyNht53Y6OtF+AsLhw=
X-Received: by 2002:aca:ec43:: with SMTP id k64mr888529oih.43.1608242224511;
 Thu, 17 Dec 2020 13:57:04 -0800 (PST)
MIME-Version: 1.0
References: <2nv9d47zt7.fsf@aldarion.sourceruckus.org> <2n1rfrf5l0.fsf@aldarion.sourceruckus.org>
 <CAOQ4uxg4hmtGXg6dNghjfVpfiJFj6nauzqTgZucwSJAJq1Z3Eg@mail.gmail.com>
 <CAOQxz3wW8QF-+HFL1gcgH+nVvySN3fogop0v+KNcxpbzu9BkJA@mail.gmail.com>
 <CAOQ4uxgsFnkUqnXYyMNdZU=s_Wq18fdbr0ZhepNLMYh9MfPe9w@mail.gmail.com>
 <CAOQxz3wUvi_O7hzNrN8oTGfnFz-PiVr3Z6nG1ZXLFjpnH4q81g@mail.gmail.com>
 <CAOQxz3zGaKnJCUe7DuegOqbbPAvNj8hTFA6_LsGEPTMXwUpn6g@mail.gmail.com>
 <CAOQ4uxifSf-q1fXC_zxOpqR8GDX8sr2CWPsXrJ6e0YSrfB6v8Q@mail.gmail.com>
 <CAOQxz3xZWCdF=7AZ=N0ajcN8FVjzU2sS_SpxzwRFyHGvwc7dZA@mail.gmail.com>
 <CAOQ4uxjmUY+N6sBoD-d2MN4eehPCcWzBXTHkDqAcCVtkpbG2kw@mail.gmail.com>
 <CAOQxz3y8N6ny23iA1Fe0L4M1gR=FHP5xANZXquu4NSLoucorKw@mail.gmail.com> <CAOQ4uxg++DkgcO9K6wkSn0p6QvvkwK0nvxBzSpNE6RdaCH3aQg@mail.gmail.com>
In-Reply-To: <CAOQ4uxg++DkgcO9K6wkSn0p6QvvkwK0nvxBzSpNE6RdaCH3aQg@mail.gmail.com>
From:   Michael Labriola <michael.d.labriola@gmail.com>
Date:   Thu, 17 Dec 2020 16:56:53 -0500
Message-ID: <CAOQxz3wbqnUxSL-Ks=7USUZU1+04Uvqi-FnTZFGRL9uqQvvNfA@mail.gmail.com>
Subject: Re: failed open: No data available
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Dec 17, 2020 at 3:25 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Dec 17, 2020 at 9:46 PM Michael Labriola
> <michael.d.labriola@gmail.com> wrote:
> >
> > On Thu, Dec 17, 2020 at 1:07 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On Thu, Dec 17, 2020 at 6:22 PM Michael Labriola
> > *snip*
> > > > On Thu, Dec 17, 2020 at 7:00 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > Thanks, Amir.  I didn't have CONFIG_DYNAMIC_DEBUG enabled, so
> > >
> > > I honestly don't expect to find much in the existing overlay debug prints
> > > but you never know..
> > > I suspect you will have to add debug prints to find the problem.
> >
> > Ok, here goes.  I had to setup a new virtual machine that doesn't use
> > overlayfs for its root filesystem because turning on dynamic debug
> > gave way too much output for a nice controlled test.  It's exhibiting
> > the same behavior as my previous tests (5.8 good, 5.9 bad).  The is
> > with a freshly compiled 5.9.15 w/ CONFIG_OVERLAY_FS_XINO_AUTO turned
> > off and CONFIG_DYNAMIC_DEBUG turned on.  Here's what we get:
> >
> >  echo "file fs/overlayfs/*  +p" > /sys/kernel/debug/dynamic_debug/control
> >  mount borky2.sqsh t
> >  mount -t tmpfs tmp tt
> >  mkdir -p tt/upper/{upper,work}
> >  mount -t overlay -o \
> >     lowerdir=t,upperdir=tt/upper/upper,workdir=tt/upper/work blarg ttt
> > [  164.505193] overlayfs: mkdir(work/work, 040000) = 0
> > [  164.505204] overlayfs: tmpfile(work/work, 0100000) = 0
> > [  164.505209] overlayfs: create(work/#3, 0100000) = 0
> > [  164.505210] overlayfs: rename(work/#3, work/#4, 0x4)
> > [  164.505216] overlayfs: unlink(work/#3) = 0
> > [  164.505217] overlayfs: unlink(work/#4) = 0
> > [  164.505221] overlayfs: setxattr(work/work,
> > "trusted.overlay.opaque", "0", 1, 0x0) = 0
> >
> >  touch ttt/FOO
> > touch: cannot touch 'ttt/FOO': No data available
> > [  191.919498] overlayfs: setxattr(upper/upper,
> > "trusted.overlay.impure", "y", 1, 0x0) = 0
> > [  191.919523] overlayfs: tmpfile(work/work, 0100644) = 0
> > [  191.919788] overlayfs: tmpfile(work/work, 0100644) = 0
> >
> > That give you any hints?  I'll start reading through the overlayfs
> > code.  I've never actually looked at it, so I'll be planting printk
> > calls at random.  ;-)
>
> We have seen that open("FOO", O_WRONLY) fails
> We know that FOO is lower at that time so that brings us to
>
> ovl_open
>   ovl_maybe_copy_up
>     ovl_copy_up_flags
>       ovl_copy_up_one
>         ovl_do_copy_up
>           ovl_set_impure
> [  191.919498] overlayfs: setxattr(upper/upper,
> "trusted.overlay.impure", "y", 1, 0x0) = 0
>           ovl_copy_up_tmpfile
>             ovl_do_tmpfile
> [  191.919523] overlayfs: tmpfile(work/work, 0100644) = 0
>             ovl_copy_up_inode
> This must be were we fail and likely in:
>               ovl_copy_xattr
>                  vfs_getxattr
> which can return -ENODATA, but it is not expected because the
> xattrs returned by vfs_listxattr should exist...
>
> So first guess would be to add a debug print for xattr 'name'
> and return value of vfs_getxattr().

Ok, here we go.  I've added a bunch of printks all over the place.
Here's what we've got.  Things are unchanged during mount.  Trying to
touch FOO now gives me this:

[  114.365444] ovl_open: start
[  114.365450] ovl_maybe_copy_up: start
[  114.365452] ovl_maybe_copy_up: need copy up
[  114.365454] ovl_maybe_copy_up: ovl_want_write succeeded
[  114.365459] ovl_copy_up_one: calling ovl_do_copy_up()
[  114.365460] ovl_do_copy_up: start
[  114.365462] ovl_do_copy_up: impure
[  114.365464] ovl_set_impure: start
[  114.365484] overlayfs: setxattr(upper/upper,
"trusted.overlay.impure", "y", 1, 0x0) = 0
[  114.365486] ovl_copy_up_tmpfile: start
[  114.365507] overlayfs: tmpfile(work/work, 0100644) = 0
[  114.365510] ovl_copy_up_inode: start
[  114.365511] ovl_copy_up_inode: ISREG && !metacopy
[  114.365625] ovl_copy_xattr: start
[  114.365630] ovl_copy_xattr: vfs_listxattr() returned 17
[  114.365632] ovl_copy_xattr: buf allocated good
[  114.365634] ovl_copy_xattr: vfs_listxattr() returned 17
[  114.365636] ovl_copy_xattr: slen=17
[  114.365638] ovl_copy_xattr: name='security.selinux'
[  114.365643] ovl_copy_xattr: vfs_getxattr returned size=-61
[  114.365644] ovl_copy_xattr: cleaning up
[  114.365647] ovl_copy_up_inode: ovl_copy_xattr error=-61
[  114.365649] ovl_copy_up_one: error=-61
[  114.365651] ovl_copy_up_one: calling ovl_copy_up_end()
[  114.365653] ovl_copy_up_flags: ovl_copy_up_one error=-61
[  114.365655] ovl_maybe_copy_up: ovl_copy_up_flags error=-61
[  114.365658] ovl_open: ovl_maybe_copy_up error=-61
[  114.365728] ovl_copy_up_one: calling ovl_do_copy_up()
[  114.365730] ovl_do_copy_up: start
[  114.365731] ovl_do_copy_up: impure
[  114.365733] ovl_set_impure: start
[  114.365735] ovl_copy_up_tmpfile: start
[  114.365748] overlayfs: tmpfile(work/work, 0100644) = 0
[  114.365750] ovl_copy_up_inode: start
[  114.365752] ovl_copy_up_inode: ISREG && !metacopy
[  114.365770] ovl_copy_xattr: start
[  114.365773] ovl_copy_xattr: vfs_listxattr() returned 17
[  114.365774] ovl_copy_xattr: buf allocated good
[  114.365776] ovl_copy_xattr: vfs_listxattr() returned 17
[  114.365778] ovl_copy_xattr: slen=17
[  114.365780] ovl_copy_xattr: name='security.selinux'
[  114.365784] ovl_copy_xattr: vfs_getxattr returned size=-61
[  114.365785] ovl_copy_xattr: cleaning up
[  114.365787] ovl_copy_up_inode: ovl_copy_xattr error=-61
[  114.365789] ovl_copy_up_one: error=-61
[  114.365790] ovl_copy_up_one: calling ovl_copy_up_end()
[  114.365792] ovl_copy_up_flags: ovl_copy_up_one error=-61


And so you can decode my splattering of debug, here's my diff
(although I'm sure gmail will line-wrap it to death):


diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index d07fb92b7253..f3f25c1bf13e 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -50,11 +50,13 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
     int error = 0;
     size_t slen;

+    printk("%s: start\n", __func__);
     if (!(old->d_inode->i_opflags & IOP_XATTR) ||
         !(new->d_inode->i_opflags & IOP_XATTR))
         return 0;

-    list_size = vfs_listxattr(old, NULL, 0);
+    list_size = vfs_listxattr(old, NULL, 0);
+    printk("%s: vfs_listxattr() returned %ld\n", __func__, list_size);
     if (list_size <= 0) {
         if (list_size == -EOPNOTSUPP)
             return 0;
@@ -64,8 +66,10 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
     buf = kzalloc(list_size, GFP_KERNEL);
     if (!buf)
         return -ENOMEM;
+    printk("%s: buf allocated good\n", __func__);

     list_size = vfs_listxattr(old, buf, list_size);
+    printk("%s: vfs_listxattr() returned %ld\n", __func__, list_size);
     if (list_size <= 0) {
         error = list_size;
         goto out;
@@ -73,7 +77,9 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)

     for (name = buf; list_size; name += slen) {
         slen = strnlen(name, list_size) + 1;
-
+        printk("%s: slen=%ld\n", __func__, slen);
+        printk("%s: name='%s'\n", __func__, name);
+
         /* underlying fs providing us with an broken xattr list? */
         if (WARN_ON(slen > list_size)) {
             error = -EIO;
@@ -81,24 +87,34 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
         }
         list_size -= slen;

-        if (ovl_is_private_xattr(name))
+        if (ovl_is_private_xattr(name)) {
+            printk("%s: ovl_is_private_xattr, continue\n", __func__);
             continue;
+        }
 retry:
         size = vfs_getxattr(old, name, value, value_size);
-        if (size == -ERANGE)
+        printk("%s: vfs_getxattr returned size=%ld\n", __func__, size);
+
+        if (size == -ERANGE) {
+            printk("%s: ERANGE, trying again\n", __func__);
             size = vfs_getxattr(old, name, NULL, 0);
+            printk("%s: 2nd try size=%ld\n", __func__, size);
+        }

         if (size < 0) {
             error = size;
             break;
         }
+        printk("%s: value_size=%ld\n", __func__, value_size);

         if (size > value_size) {
             void *new;

+            printk("%s: reallocating\n", __func__);
             new = krealloc(value, size, GFP_KERNEL);
             if (!new) {
                 error = -ENOMEM;
+                printk("%s: krealloc error\n", __func__);
                 break;
             }
             value = new;
@@ -107,6 +123,7 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
         }

         error = security_inode_copy_up_xattr(name);
+        printk("%s: security_inode_copy_up_xattr() error=%d\n",
__func__, error);
         if (error < 0 && error != -EOPNOTSUPP)
             break;
         if (error == 1) {
@@ -114,6 +131,7 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
             continue; /* Discard */
         }
         error = vfs_setxattr(new, name, value, size, 0);
+        printk("%s: vfs_setxattr() error=%d\n", __func__, error);
         if (error) {
             if (error != -EOPNOTSUPP || ovl_must_copy_xattr(name))
                 break;
@@ -122,6 +140,7 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
             error = 0;
         }
     }
+    printk("%s: cleaning up", __func__);
     kfree(value);
 out:
     kfree(buf);
@@ -485,6 +504,7 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
 static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 {
     int err;
+    printk("%s: start\n", __func__);

     /*
      * Copy up data first and then xattrs. Writing data after
@@ -492,6 +512,7 @@ static int ovl_copy_up_inode(struct
ovl_copy_up_ctx *c, struct dentry *temp)
      */
     if (S_ISREG(c->stat.mode) && !c->metacopy) {
         struct path upperpath, datapath;
+        printk("%s: ISREG && !metacopy\n", __func__);

         ovl_path_upper(c->dentry, &upperpath);
         if (WARN_ON(upperpath.dentry != NULL))
@@ -500,13 +521,17 @@ static int ovl_copy_up_inode(struct
ovl_copy_up_ctx *c, struct dentry *temp)

         ovl_path_lowerdata(c->dentry, &datapath);
         err = ovl_copy_up_data(&datapath, &upperpath, c->stat.size);
-        if (err)
+        if (err) {
+            printk("%s: ovl_copy_up_data error=%d\n", __func__, err);
             return err;
+        }
     }

     err = ovl_copy_xattr(c->lowerpath.dentry, temp);
-    if (err)
+    if (err) {
+        printk("%s: ovl_copy_xattr error=%d\n", __func__, err);
         return err;
+    }

     /*
      * Store identifier of lower inode in upper inode xattr to
@@ -516,23 +541,36 @@ static int ovl_copy_up_inode(struct
ovl_copy_up_ctx *c, struct dentry *temp)
      * hard link.
      */
     if (c->origin) {
+        printk("%s: origin\n", __func__);
         err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
-        if (err)
+        if (err) {
+            printk("%s: ovl_set_origin error=%d\n", __func__, err);
             return err;
+        }
     }

     if (c->metacopy) {
+        printk("%s: metacopy\n", __func__);
         err = ovl_check_setxattr(c->dentry, temp, OVL_XATTR_METACOPY,
                      NULL, 0, -EOPNOTSUPP);
-        if (err)
+        if (err) {
+            printk("%s: ovl_check_setxattr error=%d\n", __func__, err);
             return err;
+        }
     }

     inode_lock(temp->d_inode);
-    if (S_ISREG(c->stat.mode))
+    if (S_ISREG(c->stat.mode)) {
+        printk("%s: ISREG\n", __func__);
         err = ovl_set_size(temp, &c->stat);
-    if (!err)
+        if (err)
+            printk("%s: ovl_set_size error=%d\n", __func__, err);
+    }
+    if (!err) {
         err = ovl_set_attr(temp, &c->stat);
+        if (err)
+            printk("%s: ovl_set_attr error=%d\n", __func__, err);
+    }
     inode_unlock(temp->d_inode);

     return err;
@@ -645,6 +683,8 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_ctx *c)
     struct ovl_cu_creds cc;
     int err;

+    printk("%s: start\n", __func__);
+
     err = ovl_prep_cu_creds(c->dentry, &cc);
     if (err)
         return err;
@@ -698,6 +738,8 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
     struct ovl_fs *ofs = c->dentry->d_sb->s_fs_info;
     bool to_index = false;

+    printk("%s: start\n", __func__);
+
     /*
      * Indexed non-dir is copied up directly to the index entry and then
      * hardlinked to upper dir. Indexed dir is copied up to indexdir,
@@ -705,6 +747,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
      * Copying dir up to indexdir instead of workdir simplifies locking.
      */
     if (ovl_need_index(c->dentry)) {
+        printk("%s: need index\n", __func__);
         c->indexed = true;
         if (S_ISDIR(c->stat.mode))
             c->workdir = ovl_indexdir(c->dentry->d_sb);
@@ -716,6 +759,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
         c->origin = true;

     if (to_index) {
+        printk("%s: to_index\n", __func__);
         c->destdir = ovl_indexdir(c->dentry->d_sb);
         err = ovl_get_index_name(c->lowerpath.dentry, &c->destname);
         if (err)
@@ -724,6 +768,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
         /* Disconnected dentry must be copied up to index dir */
         return -EIO;
     } else {
+        printk("%s: impure\n", __func__);
         /*
          * Mark parent "impure" because it may now contain non-pure
          * upper
@@ -882,12 +927,25 @@ static int ovl_copy_up_one(struct dentry
*parent, struct dentry *dentry,
         if (err > 0)
             err = 0;
     } else {
-        if (!ovl_dentry_upper(dentry))
+        if (!ovl_dentry_upper(dentry)) {
+            printk("%s: calling ovl_do_copy_up()\n", __func__);
             err = ovl_do_copy_up(&ctx);
-        if (!err && parent && !ovl_dentry_has_upper_alias(dentry))
+            if (err)
+                printk("%s: error=%d\n", __func__, err);
+        }
+        if (!err && parent && !ovl_dentry_has_upper_alias(dentry)) {
+            printk("%s: calling ovl_link_up()\n", __func__);
             err = ovl_link_up(&ctx);
-        if (!err && ovl_dentry_needs_data_copy_up_locked(dentry, flags))
+            if (err)
+                printk("%s: error=%d\n", __func__, err);
+        }
+        if (!err && ovl_dentry_needs_data_copy_up_locked(dentry, flags)) {
+            printk("%s: calling ovl_copy_up_meta_inode_data()\n", __func__);
             err = ovl_copy_up_meta_inode_data(&ctx);
+            if (err)
+                printk("%s: error=%d\n", __func__, err);
+        }
+        printk("%s: calling ovl_copy_up_end()\n", __func__);
         ovl_copy_up_end(dentry);
     }
     do_delayed_call(&done);
@@ -929,6 +987,8 @@ static int ovl_copy_up_flags(struct dentry
*dentry, int flags)
         }

         err = ovl_copy_up_one(parent, next, flags);
+        if (err)
+            printk("%s: ovl_copy_up_one error=%d\n", __func__, err);

         dput(parent);
         dput(next);
@@ -957,10 +1017,15 @@ int ovl_maybe_copy_up(struct dentry *dentry, int flags)
 {
     int err = 0;

+    printk("%s: start\n", __func__);
     if (ovl_open_need_copy_up(dentry, flags)) {
+        printk("%s: need copy up\n", __func__);
         err = ovl_want_write(dentry);
         if (!err) {
+            printk("%s: ovl_want_write succeeded\n", __func__);
             err = ovl_copy_up_flags(dentry, flags);
+            if (err)
+                printk("%s: ovl_copy_up_flags error=%d\n", __func__, err);
             ovl_drop_write(dentry);
         }
     }
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 0d940e29d62b..b9de23a17268 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -144,19 +144,25 @@ static int ovl_open(struct inode *inode, struct
file *file)
     struct file *realfile;
     int err;

+    printk("%s: start\n", __func__);
     err = ovl_maybe_copy_up(file_dentry(file), file->f_flags);
-    if (err)
+    if (err) {
+        printk("%s: ovl_maybe_copy_up error=%d\n", __func__, err);
         return err;
+    }

     /* No longer need these flags, so don't pass them on to underlying fs */
     file->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);

     realfile = ovl_open_realfile(file, ovl_inode_realdata(inode));
-    if (IS_ERR(realfile))
+    if (IS_ERR(realfile)) {
+        printk("%s: ovl_open_realfile error=%ld\n", __func__,
PTR_ERR(realfile));
         return PTR_ERR(realfile);
+    }

     file->private_data = realfile;

+    printk("%s: done\n", __func__);
     return 0;
 }

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 56c1f89f20c9..2f0071595ed7 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -597,6 +597,7 @@ int ovl_set_impure(struct dentry *dentry, struct
dentry *upperdentry)
 {
     int err;

+    printk("%s: start\n", __func__);
     if (ovl_test_flag(OVL_IMPURE, d_inode(dentry)))
         return 0;




-- 
Michael D Labriola
21 Rip Van Winkle Cir
Warwick, RI 02886
401-316-9844 (cell)
