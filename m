Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97ADDC41513
	for <linux-unionfs@archiver.kernel.org>; Wed, 16 Aug 2023 10:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243662AbjHPKeu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 16 Aug 2023 06:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243916AbjHPKee (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 16 Aug 2023 06:34:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D50210D
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 03:34:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADAED650FF
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 10:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1983C433C7;
        Wed, 16 Aug 2023 10:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692182072;
        bh=CxWSgvnjJVzTJnF1xMdt76EShhbBdvHXXDoynXu6F8Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SDOdICa5mwCVkd1ccrJQwy61+lhEd+E3k9oFU4tCXl6UnjmmOhrbj5bcV4L7NG+B3
         rrkDX/fFcXobK5JlXLiXNRYtCzl9ylnLdGksnS8/H600eLpukqkLF0Etr7QCCkHKOp
         phznV79WDcWqtTJqllDQvM170k6MsXJvd0LjdJnqMIQIlsuqFSF3Yg2ls9vZdJ6Ar8
         zAGMF1E+ARSMWYhHaQtOilhXD80OqEsn0SibCKvK4ajjMQgBGQYnHjM9oROZGJehZ9
         IGWOxphw+TI4Y24SYH0VHb0NGVjxyAINZbReAMi5SBh9oGz77xx6SFYJ7nX/9IKZeo
         zguODcttR0SBw==
Date:   Wed, 16 Aug 2023 12:34:27 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>,
        linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] ovl: do not open/llseek lower file with upper
 sb_writers held
Message-ID: <20230816-sekretariat-beipackzettel-6fc4a12b7fdc@brauner>
References: <20230814140518.763674-1-amir73il@gmail.com>
 <20230814140518.763674-3-amir73il@gmail.com>
 <CAJfpegu=-+jA1026KoqrFBX9dsfvQbcjHbkNunkZ6A794mZ1TQ@mail.gmail.com>
 <CAOQ4uxiTtraLVdsKJdty6z89=Lm52DGHFf1i_aL9jQz3L80V9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxiTtraLVdsKJdty6z89=Lm52DGHFf1i_aL9jQz3L80V9Q@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Aug 15, 2023 at 06:59:44PM +0300, Amir Goldstein wrote:
> [cc Christian]
> 
> On Tue, Aug 15, 2023 at 6:12 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Mon, 14 Aug 2023 at 16:05, Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > overlayfs file open (ovl_maybe_lookup_lowerdata) and overlay file llseek
> > > take the ovl_inode_lock, without holding upper sb_writers.
> > >
> > > In case of nested lower overlay that uses same upper fs as this overlay,
> > > lockdep will warn about (possibly false positive) circular lock
> > > dependency when doing open/llseek of lower ovl file during copy up with
> > > our upper sb_writers held, because the locking ordering seems reverse to
> > > the locking order in ovl_copy_up_start():
> > >
> > > - lower ovl_inode_lock
> > > - upper sb_writers
> > >
> > > Take upper sb_writers only when we actually need it, so we won't hold it
> > > during lower file open and lower file llseek to avoid the lockdep warning.
> > >
> > > Minimizing the scope of ovl_want_write() during copy up is also needed
> > > for fixing other possible deadlocks by following patches.
> > >
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >  fs/overlayfs/copy_up.c | 117 +++++++++++++++++++++++++++++++----------
> > >  1 file changed, 88 insertions(+), 29 deletions(-)
> > >
> > > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > > index c998dab440f8..f2a31ff790fb 100644
> > > --- a/fs/overlayfs/copy_up.c
> > > +++ b/fs/overlayfs/copy_up.c
> > > @@ -251,8 +251,13 @@ static int ovl_copy_up_file(struct ovl_fs *ofs, struct dentry *dentry,
> > >         if (IS_ERR(old_file))
> > >                 return PTR_ERR(old_file);
> > >
> > > +       error = ovl_want_write(dentry);
> > > +       if (error)
> > > +               goto out_fput;
> >
> > What occurs to me is why are we bothering with getting write access on
> > the internal upper mnt each time.  Seems to me it's a historical thing
> > without a good reason.  Upper mnt is never changed from R/W to R/O.
> >
> > So the only thing we need to do is grab the upper mount write access
> > on superblock creation and do the sb_start_write/end_write() thing

Yes, that should work for fine afaict. I think that overlayfs
conceptually is equivalent to a permanent writer on that mount where
write access is granted during mount.

(I guess overlayfs could yield write access to the underlying mounts
when it gets an SB_FORCE/emergency remount request.)

> > which can't fail.  If upper mnt is read-only, we effectively have a
> > read-only filesystem, and can handle it that way (sb->s_flags |=
> > SB_RDONLY).
> >
> > There's still the possibility that we do some changes to upper even
> > for non-modify operations.  But with careful review we can remove a
> > most (possibly all) error handling cases from ovl_want_write()
> > callsites when we do know that we have write access on upper.  And
> > WARN_ON(__mnt_is_readonly(ovl_upper_mnt(ofs))) should ensure that we
> > catch any mistakes.
> >
> > Hmm?
> >
> 
> I was thinking the same thing myself, before I went on this journey.
> I reached the conclusion that doing only sb_start_write() would not be
> safe against emergency remount rdonly of the upper sb.
> 
> I guess if upper sb is emergency mounted rdonly, then overlayfs
> sb would also be emergency remounted rdonly, but for example
> ext4 sb can become rdonly on internal errors.
> But maybe that is not the responsibility of vfs or ovl to care about?
> 
> Christian, is there also an API to set the sb rdonly when private
> writable mounts (i.e. ovl_upper_mnt) exist?

No, I don't think so (see my other mail for emergency remount). There's
definitely no public one as private mounts are "invisible" to userspace
and can't be interacted with.
