Return-Path: <SRS0=qTYs=6B=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27EFDC3A5A0
	for <linux-unionfs@archiver.kernel.org>; Fri, 17 Apr 2020 16:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05C0F22202
	for <linux-unionfs@archiver.kernel.org>; Fri, 17 Apr 2020 16:56:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JHzvDzqT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgDQQ4f (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 17 Apr 2020 12:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728320AbgDQQ4e (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 17 Apr 2020 12:56:34 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB7EC061A0C
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Apr 2020 09:56:34 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id u5so2787083ilb.5
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Apr 2020 09:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=plmET1IH9JYFxtWXwjWHJ9RsXcEM4ZQeYOeUXGy011g=;
        b=JHzvDzqTEWhmKHpLegvsin6kKaWalR/F6V7sts8cnfHGy5LmTJ9ZNMOLZOHz/54yRu
         Pe89jYQH2ISmQM7y9CQVNiJSkUY210BaLnAT9AayRGuaZAuYx8l16xxrNiNQHizsI9u4
         bSz/IJO7siMjr7aUgykwJ59cCkXm1aDI/U+FW5pWGqQC+caRRWQxPunkKUkHHskrNugD
         t+N5gFcjrjdRx6PdnjbKHYpRFAM8uAIXldTkO9IdRlBxFU38aHXVlq4JD7dkEaM9XkhE
         xPKdO5HD8ijgBlgvW5gQDhvO42rlE0/KZOgpOA5FIh4dOU5FQQe5DdfTndOLUKtMv7As
         MOuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=plmET1IH9JYFxtWXwjWHJ9RsXcEM4ZQeYOeUXGy011g=;
        b=EpfrkfcVIkFbarUzvydEHCsBVAPfqb6Fr6A6dJl4AX4AiuO3J+VNRB0AgNY2weejfq
         CjQ61GQw7t7RhYkSqR2z2zcH1v+fBbXyJQJRoteZOF7tbeQTBHVlc8H1KlU/Jp0HuE15
         fBf8k9MjUmQg0oJ0041q5IDls/K15psk3882q0xycLrSkqv2nfZaj7BPrlVjY1rYsdVg
         mu3GdR/GInnauN1vTbDaHIWMXtdAtD5nu3NSthe54J1MnrmPkYMYdVQ1/ROvzTHxCNwN
         Wi93vygAS0qjwjngF6VdA11wukfEEJTxpsGOWi9z/rW8zhsMso+4ySDV6KoUFrySBCLC
         AxPQ==
X-Gm-Message-State: AGi0PuakN3Ok9gAlfzsJxMVljIy2YoKS9lsXW4uGLyF2SOlD6mKGGK8C
        6xlxyDZZofRHW1BMYKm2uGMfzjWbLg/4StMXw7Y=
X-Google-Smtp-Source: APiQypISDjXNAOn5f11J27dDOcRmer+rXb1lSawSWsEh7vSySZdPhy90SevSHQxUvllBedbVuiqlaNY3aBmU+prl9I0=
X-Received: by 2002:a92:7e86:: with SMTP id q6mr4019311ill.9.1587142593613;
 Fri, 17 Apr 2020 09:56:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200410082539.23627-1-amir73il@gmail.com> <20200410082539.23627-2-amir73il@gmail.com>
 <CAJfpegtGDcsBWdXXXgiP2UxU2iz02YSO1vOCkaBq_SvJbFJhFw@mail.gmail.com>
In-Reply-To: <CAJfpegtGDcsBWdXXXgiP2UxU2iz02YSO1vOCkaBq_SvJbFJhFw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 17 Apr 2020 19:56:22 +0300
Message-ID: <CAOQ4uxjR10X5FADiHyCPZEBbS-wYp=Nj8Xqm-hyMiuCNMfmt1A@mail.gmail.com>
Subject: Re: [PATCH 1/3] ovl: cleanup non-empty directories in ovl_indexdir_cleanup()
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Apr 17, 2020 at 5:08 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Fri, Apr 10, 2020 at 10:25 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Teach ovl_indexdir_cleanup() to remove temp directories containing
> > whiteouts to prepare for using index dir instead of work dir for
> > removing merge directories.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/overlayfs/overlayfs.h |  4 ++--
> >  fs/overlayfs/readdir.c   | 13 +++++++------
> >  2 files changed, 9 insertions(+), 8 deletions(-)
> >
> > diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> > index e6f3670146ed..e00b1ff6dea9 100644
> > --- a/fs/overlayfs/overlayfs.h
> > +++ b/fs/overlayfs/overlayfs.h
> > @@ -394,8 +394,8 @@ void ovl_cleanup_whiteouts(struct dentry *upper, struct list_head *list);
> >  void ovl_cache_free(struct list_head *list);
> >  void ovl_dir_cache_free(struct inode *inode);
> >  int ovl_check_d_type_supported(struct path *realpath);
> > -void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
> > -                        struct dentry *dentry, int level);
> > +int ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
> > +                       struct dentry *dentry, int level);
> >  int ovl_indexdir_cleanup(struct ovl_fs *ofs);
> >
> >  /* inode.c */
> > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> > index e452ff7d583d..d6b601caf122 100644
> > --- a/fs/overlayfs/readdir.c
> > +++ b/fs/overlayfs/readdir.c
> > @@ -1071,14 +1071,13 @@ static void ovl_workdir_cleanup_recurse(struct path *path, int level)
> >         ovl_cache_free(&list);
> >  }
> >
> > -void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
> > +int ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
> >                          struct dentry *dentry, int level)
> >  {
> >         int err;
> >
> >         if (!d_is_dir(dentry) || level > 1) {
> > -               ovl_cleanup(dir, dentry);
> > -               return;
> > +               return ovl_cleanup(dir, dentry);
> >         }
> >
> >         err = ovl_do_rmdir(dir, dentry);
> > @@ -1088,8 +1087,10 @@ void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
> >                 inode_unlock(dir);
> >                 ovl_workdir_cleanup_recurse(&path, level + 1);
> >                 inode_lock_nested(dir, I_MUTEX_PARENT);
> > -               ovl_cleanup(dir, dentry);
> > +               err = ovl_cleanup(dir, dentry);
> >         }
> > +
> > +       return err;
> >  }
> >
> >  int ovl_indexdir_cleanup(struct ovl_fs *ofs)
> > @@ -1132,8 +1133,8 @@ int ovl_indexdir_cleanup(struct ovl_fs *ofs)
> >                 if (!err) {
> >                         goto next;
> >                 } else if (err == -ESTALE) {
> > -                       /* Cleanup stale index entries */
> > -                       err = ovl_cleanup(dir, index);
> > +                       /* Cleanup stale index entries and leftover whiteouts */
> > +                       err = ovl_workdir_cleanup(dir, path.mnt, index, 1);
>
> I'd much prefer if cleanup of temp files were handled separately from
> stale index entries.  I.e. only call ovl_verify_index() on things that
> might actually be index files.
>

Ok. fixed tested and pushed to ovl-workdir.

Thanks,
Amir.
