Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2AD4CDB47E
	for <linux-unionfs@archiver.kernel.org>; Fri, 13 Oct 2023 07:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjJMH40 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 13 Oct 2023 03:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjJMH4Y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 13 Oct 2023 03:56:24 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0517B8
        for <linux-unionfs@vger.kernel.org>; Fri, 13 Oct 2023 00:56:22 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A0CC433C8;
        Fri, 13 Oct 2023 07:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697183782;
        bh=RCb6hMZzN4e+iHwNOrPV54mbof+7lzstmxJyGMOadxs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PcAD4aTkoocw1RSHW6cuGx7K3ntjmj+hG9QuokLj7rCLADk23ru1Gz1VjbE0K1qmD
         hGGYN5/OKO6d+9KowWkiwWW5iPZBLZiO2mT7UgFkUUzo7jkVhIZCPkHWqz9aN3SVBv
         2IqoKM4ceLhdM6/pWOsu5ZTJ2gCtlh2R5WhvkkbgcvTrb7TBJUMFhir5RN1lAAbaFZ
         GkjG1dDBKZ/4A4uUtAP6mfhc4ktvYNZiVUVvqenlg/bkugSrkIcjS9RmLyI4lPVvel
         vJu+BQFMHERrpD8u0fT6+aswVSP3193dSFOL67y65W5CWjA9nmNB2R9+FAqP51T0Tr
         nvxH97h7RUM1g==
Date:   Fri, 13 Oct 2023 09:56:17 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>,
        Max Kellermann <max.kellermann@ionos.com>,
        linux-unionfs@vger.kernel.org, Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH] ovl: rely on SB_I_NOUMASK
Message-ID: <20231013-erdreich-muschel-9aea347600aa@brauner>
References: <20231012-einband-uferpromenade-80541a047a1f@brauner>
 <CAOQ4uxgEyBaCgmG5q85+kfaVyGDNUkzf_W-Oy7PbCmqe+gNtUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxgEyBaCgmG5q85+kfaVyGDNUkzf_W-Oy7PbCmqe+gNtUQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Oct 13, 2023 at 09:57:50AM +0300, Amir Goldstein wrote:
> On Thu, Oct 12, 2023 at 6:37 PM Christian Brauner <brauner@kernel.org> wrote:
> >
> > In commit f61b9bb3f838 ("fs: add a new SB_I_NOUMASK flag") we added a
> > new SB_I_NOUMASK flag that is used by filesystems like NFS to indicate
> > that umask stripping is never supposed to be done in the vfs independent
> > of whether or not POSIX ACLs are supported.
> >
> > Overlayfs falls into the same category as it raises SB_POSIXACL
> > unconditionally to defer umask application to the upper filesystem.
> >
> > Now that we have SB_I_NOUMASK use that and make SB_POSIXACL properly
> > conditional on whether or not the kernel does have support for it. This
> > will enable use to turn IS_POSIXACL() into nop on kernels that don't
> > have POSIX ACL support avoding bugs from missed umask stripping.
> >
> > Signed-off-by: Christian Brauner <brauner@kernel.org>
> > ---
> > Hey Amir & Miklos,
> >
> > This depends on the aforementioned patch in vfs.misc. So if you're fine
> > with this change I'd take this through vfs.misc.
> 
> Generally, I'm fine with a version of this going through the vfs tree.
> 
> >
> > Christian
> > ---
> >  fs/overlayfs/super.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > index 9f43f0d303ad..361189b676b0 100644
> > --- a/fs/overlayfs/super.c
> > +++ b/fs/overlayfs/super.c
> > @@ -1489,8 +1489,16 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
> >         sb->s_xattr = ofs->config.userxattr ? ovl_user_xattr_handlers :
> >                 ovl_trusted_xattr_handlers;
> >         sb->s_fs_info = ofs;
> > +#ifdef CONFIG_FS_POSIX_ACL
> >         sb->s_flags |= SB_POSIXACL;
> > +#endif
> 
> IDGI, if IS_POSIXACL() is going to turn into noop
> why do we need this ifdef?

Because it's wrong to advertise SB_POSIXACL support if the kernel
doesn't support it at all. It's a minor correctness thing. I'll provide
more details below.

> 
> To me the flag SB_POSIXACL means that any given inode
> MAY have a custom posix acl.
> 
> >         sb->s_iflags |= SB_I_SKIP_SYNC | SB_I_IMA_UNVERIFIABLE_SIGNATURE;
> > +       /*
> > +        * Ensure that umask handling is done by the filesystems used
> > +        * for the the upper layer instead of overlayfs as that would
> > +        * lead to unexpected results.
> > +        */
> > +       sb->s_iflags |= SB_I_NOUMASK;
> >
> 
> Looks like FUSE has a similar pattern, although the testing and then
> setting of SB_POSIXACL is perplexing to me:
> 
>         /* Handle umasking inside the fuse code */
>         if (sb->s_flags & SB_POSIXACL)
>                 fc->dont_mask = 1;
>         sb->s_flags |= SB_POSIXACL;
> 
> And for NFS, why was SB_I_NOUMASK set for v4 and not for v3
> when v3 clearly states:
> 
>         case 3:
>                 /*
>                  * The VFS shouldn't apply the umask to mode bits.
>                  * We will do so ourselves when necessary.
>                  */
>                 sb->s_flags |= SB_POSIXACL;
> 
> Feels like I am missing parts of the big picture?

When a filesystem doesn't raise SB_POSIXACL the vfs will strip the
umask. When a filesystem does raise SB_POSIXACL the vfs will not strip
the umask. Instead, the umask is stripped during posix_acl_create() in
the individual filesystems.

If the kernel doesn't support POSIX ACLs, i.e. CONFIG_FS_POSIX_ACL isn't
set then posix_acl_create() is a nop. Hence, on a kernel without
CONFIG_FS_POSIX_ACL any filesystem that raises SB_POSIXACL will not do
any umask stripping at all: not on the vfs level because the vfs sees
SB_POSIXACL and not on the filesystem level because posix_acl_create()
is a nop.

This complication in umask handling is a side-effect of POSIX ACLs and
one that is really nasty. But the general idea is that you can't get one
without the other. IOW, obviously no one should raise SB_POSIXACL if
they don't intend to support POSIX ACLs...

But as we all know, hackers like us gotta hack. So filesystems like NFS
do use SB_POSIXACL for exactly that. But life without nuanced
complications isn't worth living so NFS v3 and NFS v4 do it slightly
differently.

NFS v3 uses SB_POSIXACL to avoid umask stripping in the VFS but NFS v3
does optionally support POSIX ACLs

#ifdef CONFIG_NFS_V3_ACL
        .listxattr      = nfs3_listxattr,
        .get_inode_acl  = nfs3_get_acl,
        .set_acl        = nfs3_set_acl,
#endif

and so raising SB_POSIXACL makes sense in that case. But in all
likelihood NFS should conditionalize SB_POSIXACL for NFS v3 on
CONFIG_NFS_V3_ACL or - if they want to prevent umask stripping
completely - they also need to raise SB_I_NOUMASK. But I have zero idea
what's correct for them so I trust Jeff and other people interested in
NFS to figure out what they need.

NFS v4 on the other hand clearly doesn't care about POSIX ACL support at
all because they don't support it in any form. So NFS v4 is only
interested in the side-effects of POSIX ACLs on umask handling.

So for them SB_I_NOUMASK is clearly the right thing to do.

My reasoning about overlayfs is that it falls into the same category as
NFS v4 albeit for slightly different reasons. As a stacking filesystems
with a writable upper layer overlayfs can never rely on umask handling
done in the VFS because it doesn't (easily) know up front whether the
underlying filesystems supports POSIX ACLs or not.

And currently it always has to raise SB_POSIXACL to get the side-effects
on umask handling even if the kernel isn't compiled with POSIX ACL
support at all. IOW, you always want the upper layer to do the umask
handling.

So the correct thing to do is to raise SB_I_NOUMASK to communicate
clearly that umask handling will always be done by the upper layer. And
that in turn allows you to stop raising SB_POSIXACL unconditionally.

Because in fs/overlayfs/{inode.c,overlayfs.h} you can also see that all
ovl inode operations are nop-ed when CONFIG_FS_POSIX_ACL is turned off.

I'm not sure enough about FUSE and that would need separate patches.
