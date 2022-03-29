Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20EF0C433EF
	for <linux-unionfs@archiver.kernel.org>; Tue, 29 Mar 2022 12:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236360AbiC2MiN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 08:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233980AbiC2MiL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 29 Mar 2022 08:38:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0630E19235A
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 05:36:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C27E3B816BB
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 12:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1431C340ED;
        Tue, 29 Mar 2022 12:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648557384;
        bh=TvaXDboweTbd99nrBUpEqtfjNGk1nW06RQUcRUDR7hY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zb72geQrSUce89EayUb+/JtZdRjwpeqCuN66Iqb1gKaHvS6voTvIRZbhEqRZBZ77d
         TiYBZNEI9uFu+tDL0UPLrXr9KM5nepmTR1/+lKNZVYpgNbmnFPmlgspjF1zbIyCGr1
         7eC1lw6HykhIFF92O+5YdXfLiR/2rc58kE+KniDBTspLbqDe8YG+Ga2mWDHVap5+aI
         vD328IqB5JB3cP9kijn6PoAKF6af2NEk4cUvu2naPfxsrYC2ebSlhgdBxEKIDbLZCr
         QEyAJwcpkcBk3/dUJWwsxqDzT4lzHLHNlfI0VXOsyqUk+CIrPBWwkBE1WURvzEb4oq
         WcJMGscEmI0nA==
Date:   Tue, 29 Mar 2022 14:36:18 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigoca@microsoft.com>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?utf-8?B?U3TDqXBoYW5l?= Graber <stgraber@ubuntu.com>
Subject: Re: [PATCH 08/18] ovl: use ovl_do_notify_change() wrapper
Message-ID: <20220329123618.33pedgdpxo2zqqdy@wittgenstein>
References: <20220329103526.1207086-1-brauner@kernel.org>
 <20220329103526.1207086-9-brauner@kernel.org>
 <CAJfpegu9z+EVSTjq2-hXLPRJsTpvQpGu=LQrKCgWjs3Wux=e8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJfpegu9z+EVSTjq2-hXLPRJsTpvQpGu=LQrKCgWjs3Wux=e8Q@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Mar 29, 2022 at 01:56:06PM +0200, Miklos Szeredi wrote:
> On Tue, 29 Mar 2022 at 12:37, Christian Brauner <brauner@kernel.org> wrote:
> >
> > Introduce ovl_do_notify_change() as a simple wrapper around
> > notify_change() to support idmapped layers. The helper mirrors other
> > ovl_do_*() helpers that operate on the upper layers.
> >
> > When changing ownership of an upper object the intended ownership needs
> > to be mapped according to the upper layer's idmapping. This mapping is
> > the inverse to the mapping applied when copying inode information from
> > an upper layer to the corresponding overlay inode. So e.g., when an
> > upper mount maps files that are stored on-disk as owned by id 1001 to
> > 1000 this means that calling stat on this object from an idmapped mount
> > will report the file as being owned by id 1000. Consequently in order to
> > change ownership of an object in this filesystem so it appears as being
> > owned by id 1000 in the upper idmapped layer it needs to store id 1001
> > on disk. The mnt mapping helpers take care of this.
> >
> > All idmapping helpers are nops when no idmapped base layers are used.
> >
> > Cc: <linux-unionfs@vger.kernel.org>
> > Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> > ---
> >  fs/overlayfs/copy_up.c   |  8 ++++----
> >  fs/overlayfs/dir.c       |  2 +-
> >  fs/overlayfs/inode.c     |  3 ++-
> >  fs/overlayfs/overlayfs.h | 25 +++++++++++++++++++++++++
> >  fs/overlayfs/ovl_entry.h |  5 +++++
> >  fs/overlayfs/super.c     |  2 +-
> >  6 files changed, 38 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index 2c336acb2ba0..a5d68302693f 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -301,7 +301,7 @@ static int ovl_set_size(struct ovl_fs *ofs,
> >                 .ia_size = stat->size,
> >         };
> >
> > -       return notify_change(&init_user_ns, upperdentry, &attr, NULL);
> > +       return ovl_do_notify_change(ofs, upperdentry, &attr);
> >  }
> >
> >  static int ovl_set_timestamps(struct ovl_fs *ofs, struct dentry *upperdentry,
> > @@ -314,7 +314,7 @@ static int ovl_set_timestamps(struct ovl_fs *ofs, struct dentry *upperdentry,
> >                 .ia_mtime = stat->mtime,
> >         };
> >
> > -       return notify_change(&init_user_ns, upperdentry, &attr, NULL);
> > +       return ovl_do_notify_change(ofs, upperdentry, &attr);
> >  }
> >
> >  int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upperdentry,
> > @@ -327,7 +327,7 @@ int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upperdentry,
> >                         .ia_valid = ATTR_MODE,
> >                         .ia_mode = stat->mode,
> >                 };
> > -               err = notify_change(&init_user_ns, upperdentry, &attr, NULL);
> > +               err = ovl_do_notify_change(ofs, upperdentry, &attr);
> >         }
> >         if (!err) {
> >                 struct iattr attr = {
> > @@ -335,7 +335,7 @@ int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upperdentry,
> >                         .ia_uid = stat->uid,
> >                         .ia_gid = stat->gid,
> >                 };
> > -               err = notify_change(&init_user_ns, upperdentry, &attr, NULL);
> > +               err = ovl_do_notify_change(ofs, upperdentry, &attr);
> >         }
> >         if (!err)
> >                 ovl_set_timestamps(ofs, upperdentry, stat);
> > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> > index 27a40b6754f4..9ae0352ff52a 100644
> > --- a/fs/overlayfs/dir.c
> > +++ b/fs/overlayfs/dir.c
> > @@ -516,7 +516,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
> >                         .ia_mode = cattr->mode,
> >                 };
> >                 inode_lock(newdentry->d_inode);
> > -               err = notify_change(&init_user_ns, newdentry, &attr, NULL);
> > +               err = ovl_do_notify_change(ofs, newdentry, &attr);
> >                 inode_unlock(newdentry->d_inode);
> >                 if (err)
> >                         goto out_cleanup;
> > diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> > index c51a9dd36cc7..9a8e6b94d9e8 100644
> > --- a/fs/overlayfs/inode.c
> > +++ b/fs/overlayfs/inode.c
> > @@ -21,6 +21,7 @@ int ovl_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
> >                 struct iattr *attr)
> >  {
> >         int err;
> > +       struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
> >         bool full_copy_up = false;
> >         struct dentry *upperdentry;
> >         const struct cred *old_cred;
> > @@ -77,7 +78,7 @@ int ovl_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
> >
> >                 inode_lock(upperdentry->d_inode);
> >                 old_cred = ovl_override_creds(dentry->d_sb);
> > -               err = notify_change(&init_user_ns, upperdentry, attr, NULL);
> > +               err = ovl_do_notify_change(ofs, upperdentry, attr);
> >                 revert_creds(old_cred);
> >                 if (!err)
> >                         ovl_copyattr(upperdentry->d_inode, dentry->d_inode);
> > diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> > index 816a69b46b67..eff8a1edb693 100644
> > --- a/fs/overlayfs/overlayfs.h
> > +++ b/fs/overlayfs/overlayfs.h
> > @@ -122,6 +122,31 @@ static inline const char *ovl_xattr(struct ovl_fs *ofs, enum ovl_xattr ox)
> >         return ovl_xattr_table[ox][ofs->config.userxattr];
> >  }
> >
> > +/*
> > + * When changing ownership of an upper object map the intended ownership
> > + * according to the upper layer's idmapping. When an upper mount idmaps files
> > + * that are stored on-disk as owned by id 1001 to id 1000 this means stat on
> > + * this object will report it as being owned by id 1000 when calling via the
> > + * upper mount. So in order to change ownership of an object so it reports id
> > + * 1000 when calling stat on it through the upper mount the value written to
> > + * disk must be 1001. The mount mapping helper will take of this. The mnt
> > + * idmapping helpers are nops if the upper layer isn't idmapped.
> > + */
> > +static inline int ovl_do_notify_change(struct ovl_fs *ofs,
> > +                                      struct dentry *upperdentry,
> > +                                      struct iattr *attr)
> > +{
> > +       struct user_namespace *upper_idmap = ovl_upper_idmap(ofs);
> > +       struct user_namespace *fs_idmap = i_user_ns(d_inode(upperdentry));
> > +
> > +       if (attr->ia_valid & ATTR_UID)
> > +               attr->ia_uid = mapped_kuid_user(upper_idmap, fs_idmap, attr->ia_uid);
> > +       if (attr->ia_valid & ATTR_GID)
> > +               attr->ia_gid = mapped_kgid_user(upper_idmap, fs_idmap, attr->ia_gid);
> 
> I see a similar transformation in chown_common() but I can't say I
> fully understand how this works...

I'll take the systemd-homed example. systemd-homed will keep all files
owned by 65534 on-disk. Now when a user logs into their machine with id
1000 systemd-homed will create and idmapped mount where 65534 is mapped
to id 1000. That means when a user calls ls -al in that idmapped mount
they will see all files reported as being owned by id 1000 since
i_uid_into_mnt() will be called before reporting ownership to the user.
This maps the 65534 to 1000.
Now let's say someone with appropriate privileges will want change to
some file in that idmapped mount so that it is owned by id 1000 when
calling ls -al in that mount. In order to do that they need to write the
file to disk as 65534, ia_uid contains 65534. And that is what
mapped_kuid_user() is doing. This is extensively verified in xfstests in
generic/633 and a bunch of other places.
There's a lenghty explanation also in
Documentation/filesystems/idmappings.rst fwiw (Although I need to update
that since the functions have been renamed.).

> 
> > +
> > +       return notify_change(ovl_upper_idmap(ofs), upperdentry, attr, NULL);
> 
> First argument can use upper_idmap, right?

Yes, indeed.

> 
> Thanks,
> Miklos
> 
> > +}
> > +
> >  static inline int ovl_do_rmdir(struct ovl_fs *ofs,
> >                                struct inode *dir, struct dentry *dentry)
> >  {
> > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> > index 63efee554f69..cf6aebcf893c 100644
> > --- a/fs/overlayfs/ovl_entry.h
> > +++ b/fs/overlayfs/ovl_entry.h
> > @@ -90,6 +90,11 @@ static inline struct vfsmount *ovl_upper_mnt(struct ovl_fs *ofs)
> >         return ofs->layers[0].mnt;
> >  }
> >
> > +static inline struct user_namespace *ovl_upper_idmap(struct ovl_fs *ofs)
> > +{
> > +       return mnt_user_ns(ovl_upper_mnt(ofs));
> > +}
> 
> Ah, here it is.

Ah, sorry. That got messed up my final rebase. Sorry about that. I
usually do a git rebase -x make v5.17 but apparently I missed it after
the rebase.

> 
> Can this function be introduced early in the series, but return &init_userns?

Yes, of course. I had a series like this. Amir suggested to to it a
little later.

> 
> Then when everything in place the mnt userns support can be switched on.

Yes, will do.

Thanks,
Christian
