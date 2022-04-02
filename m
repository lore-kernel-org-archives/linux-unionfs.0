Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86CA6C433EF
	for <linux-unionfs@archiver.kernel.org>; Sat,  2 Apr 2022 12:03:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiDBMFC (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 2 Apr 2022 08:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbiDBMFB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 2 Apr 2022 08:05:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A43F141FDA
        for <linux-unionfs@vger.kernel.org>; Sat,  2 Apr 2022 05:03:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE4FCB80761
        for <linux-unionfs@vger.kernel.org>; Sat,  2 Apr 2022 12:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2D7C340EC;
        Sat,  2 Apr 2022 12:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648900986;
        bh=bN9tEaRkwoAFM1MHJpKSrEdAC/1gcj8njuzZpRfw0N0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fJrmidlCQ1p6GxgfdQnu9HEkriklb2syBHaWr04MhZSieYXzYTta5CW9o6Gu3sdL/
         SVWPbpYNWVSQ1yNK4fC3j21JA6/nS4mepXB9P5LK6BWlZD95EP5Bduv7tjnsz1giZ9
         o8O/GNDCcnxM1lDaiT+U3dwzmqw7myABAGifoBL20LKMFRnmmJ8eNru+XlS6aMErYW
         8AkFQ0CJ2OqAwZz9QZwB1luU26vlDsCuT9s/uAZjyyC78qlI1u1pEZDH6Ea0vpYocf
         M1UT0YJpdz1UnYR+mHaPefX2c4wMPKjTLkdWCa90PbXzeLU4sCWMCPK9OKUszTAZ0U
         YEAjTWL42G4AA==
Date:   Sat, 2 Apr 2022 14:03:00 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Christoph Hellwig <hch@lst.de>, linux-unionfs@vger.kernel.org,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigo@sdfg.com.ar>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?utf-8?B?U3TDqXBoYW5l?= Graber <stgraber@ubuntu.com>
Subject: Re: [PATCH v3 09/19] ovl: use ovl_do_notify_change() wrapper
Message-ID: <20220402120300.aqy4b6cltdzb7iy2@wittgenstein>
References: <20220331112318.1377494-1-brauner@kernel.org>
 <20220331112318.1377494-10-brauner@kernel.org>
 <YkdJQp7cEYeWODnX@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YkdJQp7cEYeWODnX@redhat.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Apr 01, 2022 at 02:49:38PM -0400, Vivek Goyal wrote:
> On Thu, Mar 31, 2022 at 01:23:07PM +0200, Christian Brauner wrote:
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
> > /* v2 */
> > unchanged
> > 
> > /* v3 */
> > unchanged
> > ---
> >  fs/overlayfs/copy_up.c   |  8 ++++----
> >  fs/overlayfs/dir.c       |  2 +-
> >  fs/overlayfs/inode.c     |  3 ++-
> >  fs/overlayfs/overlayfs.h | 27 +++++++++++++++++++++++++++
> >  fs/overlayfs/super.c     |  2 +-
> >  5 files changed, 35 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index 2c336acb2ba0..a5d68302693f 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -301,7 +301,7 @@ static int ovl_set_size(struct ovl_fs *ofs,
> >  		.ia_size = stat->size,
> >  	};
> >  
> > -	return notify_change(&init_user_ns, upperdentry, &attr, NULL);
> > +	return ovl_do_notify_change(ofs, upperdentry, &attr);
> >  }
> >  
> >  static int ovl_set_timestamps(struct ovl_fs *ofs, struct dentry *upperdentry,
> > @@ -314,7 +314,7 @@ static int ovl_set_timestamps(struct ovl_fs *ofs, struct dentry *upperdentry,
> >  		.ia_mtime = stat->mtime,
> >  	};
> >  
> > -	return notify_change(&init_user_ns, upperdentry, &attr, NULL);
> > +	return ovl_do_notify_change(ofs, upperdentry, &attr);
> >  }
> >  
> >  int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upperdentry,
> > @@ -327,7 +327,7 @@ int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upperdentry,
> >  			.ia_valid = ATTR_MODE,
> >  			.ia_mode = stat->mode,
> >  		};
> > -		err = notify_change(&init_user_ns, upperdentry, &attr, NULL);
> > +		err = ovl_do_notify_change(ofs, upperdentry, &attr);
> >  	}
> >  	if (!err) {
> >  		struct iattr attr = {
> > @@ -335,7 +335,7 @@ int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upperdentry,
> >  			.ia_uid = stat->uid,
> >  			.ia_gid = stat->gid,
> >  		};
> > -		err = notify_change(&init_user_ns, upperdentry, &attr, NULL);
> > +		err = ovl_do_notify_change(ofs, upperdentry, &attr);
> >  	}
> >  	if (!err)
> >  		ovl_set_timestamps(ofs, upperdentry, stat);
> > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> > index 27a40b6754f4..9ae0352ff52a 100644
> > --- a/fs/overlayfs/dir.c
> > +++ b/fs/overlayfs/dir.c
> > @@ -516,7 +516,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
> >  			.ia_mode = cattr->mode,
> >  		};
> >  		inode_lock(newdentry->d_inode);
> > -		err = notify_change(&init_user_ns, newdentry, &attr, NULL);
> > +		err = ovl_do_notify_change(ofs, newdentry, &attr);
> >  		inode_unlock(newdentry->d_inode);
> >  		if (err)
> >  			goto out_cleanup;
> > diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> > index c51a9dd36cc7..9a8e6b94d9e8 100644
> > --- a/fs/overlayfs/inode.c
> > +++ b/fs/overlayfs/inode.c
> > @@ -21,6 +21,7 @@ int ovl_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
> >  		struct iattr *attr)
> >  {
> >  	int err;
> > +	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
> >  	bool full_copy_up = false;
> >  	struct dentry *upperdentry;
> >  	const struct cred *old_cred;
> > @@ -77,7 +78,7 @@ int ovl_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
> >  
> >  		inode_lock(upperdentry->d_inode);
> >  		old_cred = ovl_override_creds(dentry->d_sb);
> > -		err = notify_change(&init_user_ns, upperdentry, attr, NULL);
> > +		err = ovl_do_notify_change(ofs, upperdentry, attr);
> >  		revert_creds(old_cred);
> >  		if (!err)
> >  			ovl_copyattr(upperdentry->d_inode, dentry->d_inode);
> > diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> > index 816a69b46b67..c1f4ff0553b5 100644
> > --- a/fs/overlayfs/overlayfs.h
> > +++ b/fs/overlayfs/overlayfs.h
> > @@ -122,6 +122,33 @@ static inline const char *ovl_xattr(struct ovl_fs *ofs, enum ovl_xattr ox)
> >  	return ovl_xattr_table[ox][ofs->config.userxattr];
> >  }
> >  
> > +/*
> > + * When changing ownership of an upper object map the intended ownership
> > + * according to the upper layer's idmapping. When an upper mount idmaps files
> > + * that are stored on-disk as owned by id 1001 to id 1000 this means stat on
> > + * this object will report it as being owned by id 1000 when calling stat via
> > + * the upper mount.
> > + * In order to change ownership of an object so stat reports id 1000 when
> > + * called on an idmapped upper mount the value written to disk - i.e., the
> > + * value stored in ia_*id - must 1001. The mount mapping helper will thus take
> > + * care to map 1000 to 1001.
> > + * The mnt idmapping helpers are nops if the upper layer isn't idmapped.
> 
> Hi Christian,
> 
> Trying to understand the code with above example where upper has been
> idmapped to map on disk id 1001 to 1000. My understanding is very 
> primitive, so most likely i have very obvious questions.

Hey Vivek,

These are great questions. I'm happy to answer them.
Please feel free to also peruse the documentation in mnt_idmapping.h and
in Documentations/filesystems/idmappings.rst (the latter needs updating
though as the function names changed).

> 
> Given notify_change() takes "mnt_userns" as a parameter, I assumed
> that notify_change() will map 1000 to 1001 instead. Looks like
> that's not the case. Instead calling filesystem needs to map it
> before calling notify_change().

Usually all of that is done in the vfs. But since overlayfs calls
notify_change() directly on the upper layer this step needs to be done
here. So this is what ovl_do_notify_change() is doing.

As you might know notify_change() is (among other things) used to change
i_{g,u}id. For filesystems only mountable in init_user_ns the i_{g,u}id
values are identical to the on-disk or "backend store values".

I'll use the (slimmed down) systemd-homed example. Assume we have an xfs
filesystem mounted where all inodes on-disk are owned by 65534. We want
to use a part of this xfs filesystem as our home directory mounted as
/home/my-user. Our id on this system is 1000.

What systemd-homed will do is create an idmapped mount at /home/my-user.
The mapping it will use is: 65534:1000:<some-range>.

## Reporting file ownership
If we now access /home/my-user and call stat to look at the ownership we
see that all files are reported as being owned by id 1000.

The responsible higher-level function here is i_uid_into_mnt() which
translates from filesystem ownership into mount ownership. It uses the
lower-level mapped_k*id_fs() which maps any inode owned by 65534 on-disk
to 1000. Ultimately that's put in struct kstat and then reported in the
last step to the user.

## Creating new files
Now assume we're creating a new file in /home/my-user called "my-file".
We know our id is 1000. We know that the idmapped mount makes it so that
files on-disk owned by id 65534 are owned by id 1000.
When we create new files on disk we thus need to create them as 65534.
So if we do touch /home/my-dir/myfile followed by a stat on the file it
will be owned by id 1000.

The function responsible for this is inode_fs*id_set() and it translates
in the other direction, i.e. it maps from the idmapped mount into the
filesystem 1000 -> 65534. The low-level function that is responsible for
this is mapped_k*id_user() (as we're mapping from userspace to an on-disk
value).

## Changing ownership: notify_change()
Now assume we're trying to change ownership for some file on-disk in the
idmapped mount to make it writable for our caller. Again, the idmapped
mount makes it so that all files owned by id 65534 on-disk are owned by
id 1000 in the idmapped mount.
If a (sufficiently privileged over the inode ofc) calls:
chown 1000:1000 /home/my-dir/some-file
in the idmapped mount it's conceptually identical to creating a new file
on-disk. This we covered earlier. We need to translate from the idmapped
mount into the filesystem and thus from 1000 to 65534.
The iattr->ia_{g,u}id need to contain the value 65534 as that's the
ownership that needs to be on-disk. So here we call the
mapped_k*id_user() helper.

So if we do chown 1000:1000 /home/my-dir/some-file
followed by stat on the file it will be owned by id 1000.

If we look at the filesystem from a non-idmapped location all files
on-disk will be owned by 65534.

> 
> .
> > + */
> > +static inline int ovl_do_notify_change(struct ovl_fs *ofs,
> > +				       struct dentry *upperdentry,
> > +				       struct iattr *attr)
> > +{
> > +	struct user_namespace *upper_idmap = ovl_upper_idmap(ofs);
> > +	struct user_namespace *fs_idmap = i_user_ns(d_inode(upperdentry));
> > +
> > +	if (attr->ia_valid & ATTR_UID)
> > +		attr->ia_uid = mapped_kuid_user(upper_idmap, fs_idmap, attr->ia_uid);
> > +	if (attr->ia_valid & ATTR_GID)
> > +		attr->ia_gid = mapped_kgid_user(upper_idmap, fs_idmap, attr->ia_gid);
> 
> Another thing which I don't understand is fs_idmap and its relation with
> upper_idmap. 
> 
> IIUC, fs_idmap is upper dir's filesystem subper block's namespace. That
> should be init_user_ns until and unless filesystem allows unprivileged
> mounting from inside a namespace. Is that correct?

Correct. You can see this clearly in mnt_idmapping.h

> 
> So effectively what we are doing is two translations. A filesystem, 
> mounted unprivliged, and then idmapped mount created and used as
> upper. And then somehow we are doing translations both for idmapped
> mounts and fs_idmap?

The idmapped mount infra was designed to be generic enough so that it is
possible to create idmapped mounts for filesystems that are themselves
idmapped.

It is important to understand that only filesystem that set
FS_ALLOW_IDMAP in fs_flags are able to create idmapped mounts. Currently
no filesystem that is mountable with a non-initial idmapping raises that
flag. But if a filesystem wanted to do this then it is possible.

> 
> If you can shed some light on this, that will help a lot.

Hope this helps!

Christian
