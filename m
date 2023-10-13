Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF484CDB47E
	for <linux-unionfs@archiver.kernel.org>; Fri, 13 Oct 2023 12:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbjJMMee (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 13 Oct 2023 08:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbjJMMee (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 13 Oct 2023 08:34:34 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D52CC2
        for <linux-unionfs@vger.kernel.org>; Fri, 13 Oct 2023 05:34:31 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id 3f1490d57ef6-d9ac31cb051so1859946276.3
        for <linux-unionfs@vger.kernel.org>; Fri, 13 Oct 2023 05:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697200470; x=1697805270; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZAc7kS9hMaD3nmNYfNELGJEcrLxOYDbhkNvijIXo93A=;
        b=ZKTdv6MQE43qxv7fyzoECpl13kfzQveF1FuDHab97inq/4jPsCCjeTXUq5XPGIMxiX
         uu/oiMgD13rE52II1bVCfacTroBKPLc8Wf/VP5fVALR3OBDBZ2faNsWKSb6SF655BiDt
         nDfBINvLVWD3a8SKHkfFIckloP77Fvm+shpKXvu4kVY3GtI0lhP0fyjaiTnniSGoNv9r
         Y83LyJOcSHQwEpKaUGHDkqZO/06eoAcCaX+tTXd/iHWzj5KpIifcVFcTRM8WYTLt5vTC
         VLbHe6RpDaYxf6sAbTu8E7s8QTxnxlbD4IL6wtFXsdzmx4NtWN+RfHbGIA29p1lNRvrW
         MXrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697200470; x=1697805270;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZAc7kS9hMaD3nmNYfNELGJEcrLxOYDbhkNvijIXo93A=;
        b=fQ0VI9ekfSu+bii1JnGjSQ1HaYUkkWecuTpFWeDBWKRklOt7DTr/xZZ8J7sO/s87r8
         SKWH5nQLSourJfbpMSPwLr4Jsapo3d3fq7WGNFDaXeKitzJpIU4T47W3G/BH79Z/Id3r
         B+et11d2cZCoapluCByWvzmiTBafrceOiKRVCzfnpOLjNwF9sNcYmqG+Ci5m/nJgSj4Z
         ztHu4f108f8P/73pegMqsbOqf2RIGv39G7f9+fUY4Sq30yhfEiyobDKpuarRpsn4flzp
         MW4nV3tub0GfekRUyjoUWUpAPjccbiOLUTQ1DnynF2QUf6kKWBEoU2oHU/iQrsz30ukj
         2Ifw==
X-Gm-Message-State: AOJu0Yx7himaR5Awcqd++LCWg85O506BEjuotpnaogE1M4teNk93YgUU
        cfbaVFtavcBApjA1WN5WKsga/KxYSCgLkV5p3BRiCbWcaR8=
X-Google-Smtp-Source: AGHT+IFX+m7ZGRy7jXWMBNRTC2/D9kobzO4P8VDKn5RwbHxnM3uu4MCWiUDt9LXDcNDr5WotedPOoOdql7mK+wcy4x0=
X-Received: by 2002:a25:fb06:0:b0:d9b:351:63ba with SMTP id
 j6-20020a25fb06000000b00d9b035163bamr1961595ybe.17.1697200470045; Fri, 13 Oct
 2023 05:34:30 -0700 (PDT)
MIME-Version: 1.0
References: <20231012-einband-uferpromenade-80541a047a1f@brauner>
 <CAOQ4uxgEyBaCgmG5q85+kfaVyGDNUkzf_W-Oy7PbCmqe+gNtUQ@mail.gmail.com> <20231013-erdreich-muschel-9aea347600aa@brauner>
In-Reply-To: <20231013-erdreich-muschel-9aea347600aa@brauner>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 13 Oct 2023 15:34:18 +0300
Message-ID: <CAOQ4uxh78_DY6odN8L-wDJx10W5hgn+APM2H3K838aNBpgPDGQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: rely on SB_I_NOUMASK
To:     Christian Brauner <brauner@kernel.org>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>,
        Max Kellermann <max.kellermann@ionos.com>,
        linux-unionfs@vger.kernel.org, Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Oct 13, 2023 at 10:56=E2=80=AFAM Christian Brauner <brauner@kernel.=
org> wrote:
>
> On Fri, Oct 13, 2023 at 09:57:50AM +0300, Amir Goldstein wrote:
> > On Thu, Oct 12, 2023 at 6:37=E2=80=AFPM Christian Brauner <brauner@kern=
el.org> wrote:
> > >
> > > In commit f61b9bb3f838 ("fs: add a new SB_I_NOUMASK flag") we added a
> > > new SB_I_NOUMASK flag that is used by filesystems like NFS to indicat=
e
> > > that umask stripping is never supposed to be done in the vfs independ=
ent
> > > of whether or not POSIX ACLs are supported.
> > >
> > > Overlayfs falls into the same category as it raises SB_POSIXACL
> > > unconditionally to defer umask application to the upper filesystem.
> > >
> > > Now that we have SB_I_NOUMASK use that and make SB_POSIXACL properly
> > > conditional on whether or not the kernel does have support for it. Th=
is
> > > will enable use to turn IS_POSIXACL() into nop on kernels that don't
> > > have POSIX ACL support avoding bugs from missed umask stripping.
> > >
> > > Signed-off-by: Christian Brauner <brauner@kernel.org>
> > > ---
> > > Hey Amir & Miklos,
> > >
> > > This depends on the aforementioned patch in vfs.misc. So if you're fi=
ne
> > > with this change I'd take this through vfs.misc.
> >
> > Generally, I'm fine with a version of this going through the vfs tree.
> >
> > >
> > > Christian
> > > ---
> > >  fs/overlayfs/super.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > >
> > > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > > index 9f43f0d303ad..361189b676b0 100644
> > > --- a/fs/overlayfs/super.c
> > > +++ b/fs/overlayfs/super.c
> > > @@ -1489,8 +1489,16 @@ int ovl_fill_super(struct super_block *sb, str=
uct fs_context *fc)
> > >         sb->s_xattr =3D ofs->config.userxattr ? ovl_user_xattr_handle=
rs :
> > >                 ovl_trusted_xattr_handlers;
> > >         sb->s_fs_info =3D ofs;
> > > +#ifdef CONFIG_FS_POSIX_ACL
> > >         sb->s_flags |=3D SB_POSIXACL;
> > > +#endif
> >
> > IDGI, if IS_POSIXACL() is going to turn into noop
> > why do we need this ifdef?
>
> Because it's wrong to advertise SB_POSIXACL support if the kernel
> doesn't support it at all. It's a minor correctness thing. I'll provide
> more details below.
>
> >
> > To me the flag SB_POSIXACL means that any given inode
> > MAY have a custom posix acl.
> >
> > >         sb->s_iflags |=3D SB_I_SKIP_SYNC | SB_I_IMA_UNVERIFIABLE_SIGN=
ATURE;
> > > +       /*
> > > +        * Ensure that umask handling is done by the filesystems used
> > > +        * for the the upper layer instead of overlayfs as that would
> > > +        * lead to unexpected results.
> > > +        */
> > > +       sb->s_iflags |=3D SB_I_NOUMASK;
> > >
> >
> > Looks like FUSE has a similar pattern, although the testing and then
> > setting of SB_POSIXACL is perplexing to me:
> >
> >         /* Handle umasking inside the fuse code */
> >         if (sb->s_flags & SB_POSIXACL)
> >                 fc->dont_mask =3D 1;
> >         sb->s_flags |=3D SB_POSIXACL;
> >
> > And for NFS, why was SB_I_NOUMASK set for v4 and not for v3
> > when v3 clearly states:
> >
> >         case 3:
> >                 /*
> >                  * The VFS shouldn't apply the umask to mode bits.
> >                  * We will do so ourselves when necessary.
> >                  */
> >                 sb->s_flags |=3D SB_POSIXACL;
> >
> > Feels like I am missing parts of the big picture?
>
> When a filesystem doesn't raise SB_POSIXACL the vfs will strip the
> umask. When a filesystem does raise SB_POSIXACL the vfs will not strip
> the umask. Instead, the umask is stripped during posix_acl_create() in
> the individual filesystems.
>
> If the kernel doesn't support POSIX ACLs, i.e. CONFIG_FS_POSIX_ACL isn't
> set then posix_acl_create() is a nop. Hence, on a kernel without
> CONFIG_FS_POSIX_ACL any filesystem that raises SB_POSIXACL will not do
> any umask stripping at all: not on the vfs level because the vfs sees
> SB_POSIXACL and not on the filesystem level because posix_acl_create()
> is a nop.
>
> This complication in umask handling is a side-effect of POSIX ACLs and
> one that is really nasty. But the general idea is that you can't get one
> without the other. IOW, obviously no one should raise SB_POSIXACL if
> they don't intend to support POSIX ACLs...
>
> But as we all know, hackers like us gotta hack. So filesystems like NFS
> do use SB_POSIXACL for exactly that. But life without nuanced
> complications isn't worth living so NFS v3 and NFS v4 do it slightly
> differently.
>
> NFS v3 uses SB_POSIXACL to avoid umask stripping in the VFS but NFS v3
> does optionally support POSIX ACLs
>
> #ifdef CONFIG_NFS_V3_ACL
>         .listxattr      =3D nfs3_listxattr,
>         .get_inode_acl  =3D nfs3_get_acl,
>         .set_acl        =3D nfs3_set_acl,
> #endif
>
> and so raising SB_POSIXACL makes sense in that case. But in all
> likelihood NFS should conditionalize SB_POSIXACL for NFS v3 on
> CONFIG_NFS_V3_ACL or - if they want to prevent umask stripping
> completely - they also need to raise SB_I_NOUMASK. But I have zero idea
> what's correct for them so I trust Jeff and other people interested in
> NFS to figure out what they need.
>
> NFS v4 on the other hand clearly doesn't care about POSIX ACL support at
> all because they don't support it in any form. So NFS v4 is only
> interested in the side-effects of POSIX ACLs on umask handling.
>
> So for them SB_I_NOUMASK is clearly the right thing to do.
>
> My reasoning about overlayfs is that it falls into the same category as
> NFS v4 albeit for slightly different reasons. As a stacking filesystems
> with a writable upper layer overlayfs can never rely on umask handling
> done in the VFS because it doesn't (easily) know up front whether the
> underlying filesystems supports POSIX ACLs or not.
>
> And currently it always has to raise SB_POSIXACL to get the side-effects
> on umask handling even if the kernel isn't compiled with POSIX ACL
> support at all. IOW, you always want the upper layer to do the umask
> handling.
>
> So the correct thing to do is to raise SB_I_NOUMASK to communicate
> clearly that umask handling will always be done by the upper layer. And
> that in turn allows you to stop raising SB_POSIXACL unconditionally.
>
> Because in fs/overlayfs/{inode.c,overlayfs.h} you can also see that all
> ovl inode operations are nop-ed when CONFIG_FS_POSIX_ACL is turned off.
>

All right.

Acked-by: Amir Goldstein <amir73il@gmail.com>

Thanks for the explanation,
Amir.
