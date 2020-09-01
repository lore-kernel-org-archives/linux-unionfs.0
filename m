Return-Path: <SRS0=Ys2z=CK=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 979AEC433E6
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Sep 2020 09:45:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CD4D2083B
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Sep 2020 09:45:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ArYXdjdN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgIAJpB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 05:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgIAJpA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 1 Sep 2020 05:45:00 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F45C061244
        for <linux-unionfs@vger.kernel.org>; Tue,  1 Sep 2020 02:44:59 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id z25so523604iol.10
        for <linux-unionfs@vger.kernel.org>; Tue, 01 Sep 2020 02:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fn+xeYEe6ZQOmPqEabIYNCp79b/NOGoXYoFvwBqGQ+o=;
        b=ArYXdjdNRTY7p1txDBM6RVpAYCRNI9clQQA7xiceACIHk9HwvlkqQG6Yf5C25vwZoq
         nG3zlQJdszbPi6NdOy3gC4g+1Q3lbNBtK9xpwZxJpYCXnIuDzvjC0eMa8RwFlsn7S4vH
         x0JBz1poMYvmzydem1RZVphfcDbEzisbpPrXOy5kReknbPaUIfaBIefrwXtC31ofzLsZ
         /0SFVCpCHBH2tHQpbhjsgH+x1R1ARGK9kPPdw1boXMYlu5iuKnGsLiOzJrwU3OhIrpeH
         EnWZmXXkeryJ4kq+HctgeGKevPBNr073kosHmsUlKH8mCbf7H6Kszv7G+yF0ynz9luA5
         Qmew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fn+xeYEe6ZQOmPqEabIYNCp79b/NOGoXYoFvwBqGQ+o=;
        b=GJGk6m4N9DwWrvAcXGWgl3tIiTcy/L+A/3PY6Y4vYZbZzGSz1Illh1tX6jqoZ79Pwu
         afA7dvuQ0ijoWLSpAYcM/FMU3GVBglaphTZRa+2dpo1I6ej1YFq3gHByM3r6yXh3NmJ8
         Lk+99Ob8NPGl2sgxFUaY8SDWfvqQ/CnH1BvcrGhlCw9TlejJuu3xpCU7McW6OZF0DJj5
         OOy8ekzudhEMhGX6qdNPVdcvdtki/Wj59+uVM7d5yxji2oxjgNZqESEpJFPQxQLh5oEY
         UUNLO3AVjv0v+yqQp4lW6AwP+LwKmAvJYP8zgvjUVX0PMt8wvvOJDEvO8CoP1GVTJlrE
         dgZg==
X-Gm-Message-State: AOAM531pSlxjx79Nga5dsap+cfaFu1wwh2LpTaTZPYuQXwQOjRe9I3rw
        jaOK0UTHMUXVWnteDRz5HA1JZuAx3dhqG9N1nyfSMIBHKy4=
X-Google-Smtp-Source: ABdhPJxie1YbqkWNwR0QG98TtyUrnjomSXsZ0Lz2j+2UuRmhRY2o1DWZO8qQzizfWotY1cp6lZ7KwV44irnmznGYiCQ=
X-Received: by 2002:a6b:ec17:: with SMTP id c23mr758318ioh.186.1598953498252;
 Tue, 01 Sep 2020 02:44:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200830202803.25028-1-amir73il@gmail.com> <CAJfpeguB+JeQN-trDY0qLiO4O2WaBfD2Ltxqc8T6-KV-_fwvCA@mail.gmail.com>
In-Reply-To: <CAJfpeguB+JeQN-trDY0qLiO4O2WaBfD2Ltxqc8T6-KV-_fwvCA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 1 Sep 2020 12:44:46 +0300
Message-ID: <CAOQ4uxg91=1to3nCaT6pemb_EAbPw6vByOQ9SE6QvWsT6znKHA@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: check for incomapt features in work dir
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Sep 1, 2020 at 12:17 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Sun, Aug 30, 2020 at 10:28 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > An incompatible feature is marked by a non-empty directory nested
> > 2 levels deep under "work" dir, e.g.:
> > workdir/work/incompat/volatile.
> >
> > This commit checks for marked incompat features, warns about them
> > and fails to mount the overlay, for example:
> >   overlayfs: overlay with incompat feature 'volatile' cannot be mounted
> >
> > Very old kernels (i.e. v3.18) will fail to remove a non-empty "work"
> > dir and fail the mount.  Newer kernels will fail to remove a "work"
> > dir with entries nested 3 levels and fall back to read-only mount.
> >
> > User mounting with old kernel will see a warning like these in dmesg:
> >   overlayfs: cleanup of 'incompat/...' failed (-39)
> >   overlayfs: cleanup of 'work/incompat' failed (-39)
> >   overlayfs: cleanup of 'ovl-work/work' failed (-39)
> >   overlayfs: failed to create directory /vdf/ovl-work/work (errno: 17);
> >              mounting read-only
> >
> > These warnings should give the hint to the user that:
> > 1. mount failure is caused by backward incompatible features
> > 2. mount failure can be resolved by manually removing the "work" directory
> >
> > There is nothing preventing users on old kernels from manually removing
> > workdir entirely or mounting overlay with a new workdir, so this is in
> > no way a full proof backward compatibility enforcement, but only a best
> > effort.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Vivek,
> >
> > Re-posting with minor cleanups.
> > Also pushed to branch ovl-incompat.
> >
> > Thanks,
> > Amir.
> >
> > Changes since v1:
> > - Move check for "incompat" name to ovl_workdir_cleanup_recurse()
> >
> >
> >  fs/overlayfs/readdir.c | 30 +++++++++++++++++++++++++-----
> >  fs/overlayfs/super.c   | 25 ++++++++++++++++++-------
> >  2 files changed, 43 insertions(+), 12 deletions(-)
> >
> > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> > index 6918b98faeb6..683c6f27ab77 100644
> > --- a/fs/overlayfs/readdir.c
> > +++ b/fs/overlayfs/readdir.c
> > @@ -1051,7 +1051,9 @@ int ovl_check_d_type_supported(struct path *realpath)
> >         return rdd.d_type_supported;
> >  }
> >
> > -static void ovl_workdir_cleanup_recurse(struct path *path, int level)
> > +#define OVL_INCOMPATDIR_NAME "incompat"
> > +
> > +static int ovl_workdir_cleanup_recurse(struct path *path, int level)
> >  {
> >         int err;
> >         struct inode *dir = path->dentry->d_inode;
> > @@ -1065,6 +1067,15 @@ static void ovl_workdir_cleanup_recurse(struct path *path, int level)
> >                 .root = &root,
> >                 .is_lowest = false,
> >         };
> > +       bool incompat = false;
> > +
> > +       /*
> > +        * The "work/incompat" directory is treated specially - if it is not
> > +        * empty, instead of printing a generic error and mounting read-only,
> > +        * we will error about incompat features and fail the mount.
> > +        */
> > +       if (level == 2 && !strcmp(path->dentry->d_name.name, OVL_INCOMPATDIR_NAME))
> > +               incompat = true;
>
> Should the test be specific to "work/incompat"?  AFAICS this will
> trigger under "index" as well...

When called from ovl_indexdir_cleanup(), path->dentry->d_name.name[0] == '#',
because cleanup starts at level 1 and ovl_workdir_cleanup_recurse() is called
with level 2.

>
> >
> >         err = ovl_dir_read(path, &rdd);
> >         if (err)
> > @@ -1079,21 +1090,29 @@ static void ovl_workdir_cleanup_recurse(struct path *path, int level)
> >                                 continue;
> >                         if (p->len == 2 && p->name[1] == '.')
> >                                 continue;
> > +               } else if (incompat) {
> > +                       pr_warn("overlay with incompat feature '%.*s' cannot be mounted\n",
> > +                               p->len, p->name);
> > +                       err = -EEXIST;
>
> EEXIST feels counterintuitive.  I'd rather opt for EINVAL.

I usually prefer to use EINVAL for illegal user input and this is a border line,
so I prefer errors that indicate the state of the object, like EEXIST
or ENOTEMPTY,
but because these errors are not expected on mount, I can live with EINVAL.

Assuming that you agree with my response to ovl_indexdir_cleanup(), let
me know if you need me to post v3 or if you can change the choice of error
and s/pr_warn/pr_err on commit.

Thanks,
Amir.
