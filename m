Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A981E748E9
	for <linux-unionfs@archiver.kernel.org>; Sun,  1 Oct 2023 14:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbjJAOL2 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 1 Oct 2023 10:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234285AbjJAOL1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 1 Oct 2023 10:11:27 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B305A6
        for <linux-unionfs@vger.kernel.org>; Sun,  1 Oct 2023 07:11:24 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id ada2fe7eead31-4510182fe69so6169050137.3
        for <linux-unionfs@vger.kernel.org>; Sun, 01 Oct 2023 07:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696169483; x=1696774283; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3EXkikxpWoIP19hLROjq+2J8LgTscumVxwR2q1sutUU=;
        b=gLH4i1UuSXFklsYnFdA1TTEMaZcvqgLCnu7e445cBj9Aq/2dq0+0fR0yw59I0VlDio
         YFafoYiHB5y39xg/PBnq7ZUMVchdxcC43JLxN1D9hi8mXvMKAGiI2zakfNvqjL7zDCag
         N5ItWbSXhLqNPH7KwAhviJ+DcqX3MSSgUZLgk+Ga0hWp0RNEKC26+ZZvNa8L0VZW7L0c
         yvtR/rMz1PG2JOJAYOPpUgBg0mgrBttojcljz8wvQZyn/6t3k//CI53/rHKitDVPN0ah
         M6R8YN+aMVyQgliLuXrx92LRyrtT3Ri+zTHyJrbttHOmZS404uO8ehbBN8wIeFESS4mg
         Uptg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696169483; x=1696774283;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3EXkikxpWoIP19hLROjq+2J8LgTscumVxwR2q1sutUU=;
        b=Crmyb9RDfk4FU5GQRz1rTPj2ivRiYVjKl+Ui4+CtnpBa2Lso2qX41SEC5pYr65FrCt
         kbAvMT9MNtUfUj5gbOayKDBGe+DXcuPEy7Apnm9EBsezfTFRMOK1pHJSISX6HavtqCKG
         oMzcJj4TejtrkWtKGxWw0+7dnJjoq81CHfLXy0kGwVmPH5GDPQh21rWhEx7MjaxdVLVY
         1wDH/tSrupuhMPUBqM0y1eZBDlM5ldpqnzRJPqNz07P0Jv7Xz1phoVGDhVt9DGFWnH3O
         lrzbAFiFCcl7MPGFS9rPRVMN/ZovBmMw8dSiPCoKoxIOWH9M2NlcZeq29fRhYxCfe6Es
         514A==
X-Gm-Message-State: AOJu0YwszHHs7YR94h3rz+0Jpp4UEggnFyplsrU2ZU8566WKQrfwZRee
        38LnM0CYiANO4r9hwB+EZASyeJV5odZqq4DNJaA=
X-Google-Smtp-Source: AGHT+IHjOsLFRoN82+qqpa/AjFin4KmnsHjiS4Ka1er85Ip/APjOzGvQJXkAqIYJgAu/nKiuVYV3WhYa5Yu9wlb9KCo=
X-Received: by 2002:a67:f818:0:b0:452:6ac0:ed19 with SMTP id
 l24-20020a67f818000000b004526ac0ed19mr6341599vso.31.1696169483540; Sun, 01
 Oct 2023 07:11:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230912173653.3317828-1-amir73il@gmail.com> <20230912173653.3317828-2-amir73il@gmail.com>
 <CAOQ4uxhvztZMeGKy1YSq0+y_uWt7fud7vBw8pvO33sk2K44K0w@mail.gmail.com> <CAOQ4uxi0WVVdsK_DHcfE=XN5STc-pMBkhi1u4jMGR_zaJnW2Xw@mail.gmail.com>
In-Reply-To: <CAOQ4uxi0WVVdsK_DHcfE=XN5STc-pMBkhi1u4jMGR_zaJnW2Xw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 1 Oct 2023 17:11:12 +0300
Message-ID: <CAOQ4uxgbc82QS5jOWcPRSDPKjk85LN8fg4KY9LWWc=7SoBCiHA@mail.gmail.com>
Subject: Re: [PATCH 1/4] ovl: protect copying of realinode attributes to ovl inode
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Christian Brauner <brauner@kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Sep 27, 2023 at 12:17=E2=80=AFAM Amir Goldstein <amir73il@gmail.com=
> wrote:
>
> On Sun, Sep 24, 2023 at 12:28=E2=80=AFPM Amir Goldstein <amir73il@gmail.c=
om> wrote:
> >
> > [adding some folks from the multigrain ctime discussion]
> >
> > On Tue, Sep 12, 2023 at 8:36=E2=80=AFPM Amir Goldstein <amir73il@gmail.=
com> wrote:
> > >
> > > ovl_copyattr() may be called concurrently from aio completion context
> > > without any lock and that could lead to overlay inode attributes gett=
ing
> > > permanently out of sync with real inode attributes.
> > >
> > > Similarly, ovl_file_accessed() is always called without any lock to d=
o
> > > "compare & copy" of mtime/ctime from realinode to inode.
> > >
> > > Use ovl inode spinlock to protect those two helpers.
> > >
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >  fs/overlayfs/file.c | 2 ++
> > >  fs/overlayfs/util.c | 2 ++
> > >  2 files changed, 4 insertions(+)
> > >
> > > diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> > > index 4193633c4c7a..c6ad84cf9246 100644
> > > --- a/fs/overlayfs/file.c
> > > +++ b/fs/overlayfs/file.c
> > > @@ -249,6 +249,7 @@ static void ovl_file_accessed(struct file *file)
> > >         if (!upperinode)
> > >                 return;
> > >
> > > +       spin_lock(&inode->i_lock);
> > >         ctime =3D inode_get_ctime(inode);
> > >         uctime =3D inode_get_ctime(upperinode);
> > >         if ((!timespec64_equal(&inode->i_mtime, &upperinode->i_mtime)=
 ||
> > >              !timespec64_equal(&ctime, &uctime))) {
> > >                 inode->i_mtime =3D upperinode->i_mtime;
> > >                 inode_set_ctime_to_ts(inode, uctime);
> > >         }
> > > +       spin_unlock(&inode->i_lock);
> > >
> >
> > [patch manually edited to add missing line to context]
> >
> > Miklos,
> >
> > I am having latent concerns about this patch, which is currently
> > in overlayfs-next.
> >
> > What was your reason for the "compare & copy" optimization?
> > I assume it was to avoid cache line bouncing. yes?
> > Would the added spinlock make this optimization moot?
> > I am asking since I calculated that on X86-64 and with
> > CONFIG_FS_POSIX_ACL && CONFIG_SECURITY
> > i_ctime.tv_nsec and i_lock are on the same cache line.
> >
> > I should note for the non-overlayfs developers, that we do
> > not care to worry about changes to the upperinode that are
> > done behind the back of overlayfs.
> >
> > Ovrerlayfs assumes that it is the only one to make changes
> > to the upperinode, otherwise, behavior is undefined.
> >
> > This is the justification for only taking the overlayfs inode
> > i_lock for synchronization of this "compare & copy" routine.
> >
> > Also, I think we only need to care that the overlayfs inode
> > timestamps are eventually consistent, after the last
> > ovl_file_accessed() call.
> >
> > The decraled reason (in commit message) for adding the lock
> > here is to protect from races in the ovl aio code path, which was
> > not around when the ovl_file_accessed() helper was written.
> >
> > But now I am wondering:
> > - Is the lock needed in all the sync calls?
> > - Is it needed even if there was no aio at all?
> >
> > I think the answer is yes to both questions, so the patch
> > can remain in its current form, but I'm not 100% sure.
> >
> > >         touch_atime(&file->f_path);
> > >  }
> > > diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> > > index 89e0d60d35b6..b7922862ece3 100644
> > > --- a/fs/overlayfs/util.c
> > > +++ b/fs/overlayfs/util.c
> > > @@ -1403,6 +1403,7 @@ void ovl_copyattr(struct inode *inode)
> > >         realinode =3D ovl_i_path_real(inode, &realpath);
> > >         real_idmap =3D mnt_idmap(realpath.mnt);
> > >
> > > +       spin_lock(&inode->i_lock);
> > >         vfsuid =3D i_uid_into_vfsuid(real_idmap, realinode);
> > >         vfsgid =3D i_gid_into_vfsgid(real_idmap, realinode);
> > >
> > >         inode->i_uid =3D vfsuid_into_kuid(vfsuid);
> > >         inode->i_gid =3D vfsgid_into_kgid(vfsgid);
> > >         inode->i_mode =3D realinode->i_mode;
> > >         inode->i_mtime =3D realinode->i_mtime;
> > >         inode_set_ctime_to_ts(inode, inode_get_ctime(realinode));
> > >         i_size_write(inode, i_size_read(realinode));
> > > +       spin_unlock(&inode->i_lock);
> >
> > My concerns about this part of the patch is that AFAIK,
> > all the calls of ovl_copyattr(), except for the one in aio completion,
> > are called with overlayfs inode mutex lock held.
> >
> > So this lock is strictly only needed because of the aio write case,
> > but I think we need to have the lock in place for all the other
> > cases to protect them against racing with aio completion?
> >
> > I guess the overhead of the spinlock is not a worry if the
> > mutex is already held, even though we do call ovl_copyattr()
> > twice (before and after) in some operations.
> >
> > Anyway, I just want to make sure that I did not make any
> > mistakes in my analysis of the problem and the fix.
> >
>
> FYI, for now I dropped this patch from overlayfs-next, because
> I was warned that ovl_copyattr() could be called from interrupt
> context in aio completion.
>
> I will bring it back after I sort out the ovl aio completion context.
>

FYI, after applying "ovl: punt write aio completion to workqueue" [1]
to overlayfs-next, I restored the half of this patch that adds
spinlock protection to ovl_copyattr().

But I dropped the half that adds spinlock protection to
ovl_file_accessed(), because I do not want to add a lock to the read
path and because ovl_file_accessed() is not anymore unsafe than
relatime_need_update() already is w.r.t atomic access to struct timespec64
and w.r.t atomic access to mtime/ctime/atime fields, so I guess nobody
really cares so much about being very strict with relatime rules...

Thanks,
Amir.

[1] https://lore.kernel.org/linux-unionfs/20230928064636.487317-1-amir73il@=
gmail.com/
