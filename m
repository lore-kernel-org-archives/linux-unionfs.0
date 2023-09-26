Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1842BE7F143
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 Sep 2023 22:35:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbjIZWfy (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 18:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbjIZWdx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 26 Sep 2023 18:33:53 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BD565B5
        for <linux-unionfs@vger.kernel.org>; Tue, 26 Sep 2023 14:17:40 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id ada2fe7eead31-45271a44cc4so3955710137.2
        for <linux-unionfs@vger.kernel.org>; Tue, 26 Sep 2023 14:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695763059; x=1696367859; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OQ1R8gxfWRRRGvSocyA+orUsBY0Mkcx6s423dqPGH9U=;
        b=eRR35/mdN+E50dGeNHQ88bvSbO5JZY7QeWQOPkax0x1EdFcMVHcAOyv70XpTeXTwtf
         hP9Yyxr0d4id6ItsBb4umVTbVXJC5EhHdIzmPrnJmZCRJnYsbaCYANl5N09DqQYXShXw
         vbxQO9HYmoxfxi4KBKtPzISSFz6QQgFNrmvMMy3/ofHouJ9NcvcipAxu7WUjQSMCRQFH
         6vvQkID2nykENrGGJUV67BNZ4x+Qs9UOkfA3h8uz91zqAW2FTMMjoRO3Abx/I3x44zcD
         nzxdP+OyHjJeuSByYblTv217TxbpUI0nHbJ1H+dYEZb6VwQGVaj1zbBA7NUOxgLu9Jse
         UbPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695763059; x=1696367859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OQ1R8gxfWRRRGvSocyA+orUsBY0Mkcx6s423dqPGH9U=;
        b=fZUaiumBAQaJF8wyuPcarhXrsqFIa1vrUvi31khvoyf1qZJ+foZcyQhzb2jWVk6b++
         USPvex3QmW4jniqYvBQzyBTU8JqLJMQO3FTe5Z3ZgYdLEbC3ep1tvQ3xaPGMKlvm/Dks
         KpnnPbR10nTNpWMJRn0XbEKyPa3YLhrCRp+K7ac4+pGYO45J+4WHVA/eKOS1xnCJ3TdO
         +hkzkrXZuTEH4/AZglsvseS7bp3u5zennuZXc1adPUPCNUdL/rTb18hseDdz3T0/mBiF
         ronyVj26H5E+ZgkxPRWtuR0b1HCy7djEgU1Memfipayre46lPM/7DCYlpujc0diCwsb1
         UVGQ==
X-Gm-Message-State: AOJu0YzdxFeReHyEDsLd+vLQ8fG5DKQ2e9iNbYC+mytDmhUWF2/YVLrU
        PZVbJAh0WOV44NBwLHznrLmTL62VA4qrhQV4oKQ=
X-Google-Smtp-Source: AGHT+IHNzwOlPxTO3MfmbTA+rmd4o9q06/A40G8AhBcVOEqH0fRbEABRsT4Msz5TbOWYGoDiZBFWU/KWONaRjFspuaQ=
X-Received: by 2002:a67:fa56:0:b0:452:5df8:b94f with SMTP id
 j22-20020a67fa56000000b004525df8b94fmr280854vsq.1.1695763059262; Tue, 26 Sep
 2023 14:17:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230912173653.3317828-1-amir73il@gmail.com> <20230912173653.3317828-2-amir73il@gmail.com>
 <CAOQ4uxhvztZMeGKy1YSq0+y_uWt7fud7vBw8pvO33sk2K44K0w@mail.gmail.com>
In-Reply-To: <CAOQ4uxhvztZMeGKy1YSq0+y_uWt7fud7vBw8pvO33sk2K44K0w@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 27 Sep 2023 00:17:27 +0300
Message-ID: <CAOQ4uxi0WVVdsK_DHcfE=XN5STc-pMBkhi1u4jMGR_zaJnW2Xw@mail.gmail.com>
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

On Sun, Sep 24, 2023 at 12:28=E2=80=AFPM Amir Goldstein <amir73il@gmail.com=
> wrote:
>
> [adding some folks from the multigrain ctime discussion]
>
> On Tue, Sep 12, 2023 at 8:36=E2=80=AFPM Amir Goldstein <amir73il@gmail.co=
m> wrote:
> >
> > ovl_copyattr() may be called concurrently from aio completion context
> > without any lock and that could lead to overlay inode attributes gettin=
g
> > permanently out of sync with real inode attributes.
> >
> > Similarly, ovl_file_accessed() is always called without any lock to do
> > "compare & copy" of mtime/ctime from realinode to inode.
> >
> > Use ovl inode spinlock to protect those two helpers.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/overlayfs/file.c | 2 ++
> >  fs/overlayfs/util.c | 2 ++
> >  2 files changed, 4 insertions(+)
> >
> > diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> > index 4193633c4c7a..c6ad84cf9246 100644
> > --- a/fs/overlayfs/file.c
> > +++ b/fs/overlayfs/file.c
> > @@ -249,6 +249,7 @@ static void ovl_file_accessed(struct file *file)
> >         if (!upperinode)
> >                 return;
> >
> > +       spin_lock(&inode->i_lock);
> >         ctime =3D inode_get_ctime(inode);
> >         uctime =3D inode_get_ctime(upperinode);
> >         if ((!timespec64_equal(&inode->i_mtime, &upperinode->i_mtime) |=
|
> >              !timespec64_equal(&ctime, &uctime))) {
> >                 inode->i_mtime =3D upperinode->i_mtime;
> >                 inode_set_ctime_to_ts(inode, uctime);
> >         }
> > +       spin_unlock(&inode->i_lock);
> >
>
> [patch manually edited to add missing line to context]
>
> Miklos,
>
> I am having latent concerns about this patch, which is currently
> in overlayfs-next.
>
> What was your reason for the "compare & copy" optimization?
> I assume it was to avoid cache line bouncing. yes?
> Would the added spinlock make this optimization moot?
> I am asking since I calculated that on X86-64 and with
> CONFIG_FS_POSIX_ACL && CONFIG_SECURITY
> i_ctime.tv_nsec and i_lock are on the same cache line.
>
> I should note for the non-overlayfs developers, that we do
> not care to worry about changes to the upperinode that are
> done behind the back of overlayfs.
>
> Ovrerlayfs assumes that it is the only one to make changes
> to the upperinode, otherwise, behavior is undefined.
>
> This is the justification for only taking the overlayfs inode
> i_lock for synchronization of this "compare & copy" routine.
>
> Also, I think we only need to care that the overlayfs inode
> timestamps are eventually consistent, after the last
> ovl_file_accessed() call.
>
> The decraled reason (in commit message) for adding the lock
> here is to protect from races in the ovl aio code path, which was
> not around when the ovl_file_accessed() helper was written.
>
> But now I am wondering:
> - Is the lock needed in all the sync calls?
> - Is it needed even if there was no aio at all?
>
> I think the answer is yes to both questions, so the patch
> can remain in its current form, but I'm not 100% sure.
>
> >         touch_atime(&file->f_path);
> >  }
> > diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> > index 89e0d60d35b6..b7922862ece3 100644
> > --- a/fs/overlayfs/util.c
> > +++ b/fs/overlayfs/util.c
> > @@ -1403,6 +1403,7 @@ void ovl_copyattr(struct inode *inode)
> >         realinode =3D ovl_i_path_real(inode, &realpath);
> >         real_idmap =3D mnt_idmap(realpath.mnt);
> >
> > +       spin_lock(&inode->i_lock);
> >         vfsuid =3D i_uid_into_vfsuid(real_idmap, realinode);
> >         vfsgid =3D i_gid_into_vfsgid(real_idmap, realinode);
> >
> >         inode->i_uid =3D vfsuid_into_kuid(vfsuid);
> >         inode->i_gid =3D vfsgid_into_kgid(vfsgid);
> >         inode->i_mode =3D realinode->i_mode;
> >         inode->i_mtime =3D realinode->i_mtime;
> >         inode_set_ctime_to_ts(inode, inode_get_ctime(realinode));
> >         i_size_write(inode, i_size_read(realinode));
> > +       spin_unlock(&inode->i_lock);
>
> My concerns about this part of the patch is that AFAIK,
> all the calls of ovl_copyattr(), except for the one in aio completion,
> are called with overlayfs inode mutex lock held.
>
> So this lock is strictly only needed because of the aio write case,
> but I think we need to have the lock in place for all the other
> cases to protect them against racing with aio completion?
>
> I guess the overhead of the spinlock is not a worry if the
> mutex is already held, even though we do call ovl_copyattr()
> twice (before and after) in some operations.
>
> Anyway, I just want to make sure that I did not make any
> mistakes in my analysis of the problem and the fix.
>

FYI, for now I dropped this patch from overlayfs-next, because
I was warned that ovl_copyattr() could be called from interrupt
context in aio completion.

I will bring it back after I sort out the ovl aio completion context.

Thanks,
Amir.
