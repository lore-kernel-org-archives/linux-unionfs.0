Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF398C433F5
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Apr 2022 09:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239642AbiDGJcA (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 05:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243801AbiDGJb7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Apr 2022 05:31:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A2D986E7
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Apr 2022 02:29:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 918F861A94
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Apr 2022 09:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B23C385A4;
        Thu,  7 Apr 2022 09:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649323796;
        bh=6Is74VQ9YD71yUWO5Ot7Y7DVIscVtjyvEcXMdbG2k34=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TzvY6jl5XbGngn5zu6B5c3SyOddzs3ybiGBWmD3lVLLQRRTLEGCjHNDWIv5HiilvL
         cWcsqh1qvVvaQdwke8BI/J/zBf0M3p9N4Z+s3Wm8hud7Mhn4Xt7lRqWCuva47kp4Xa
         cC/lJYx8PHhzwQdQ2oZgppaJsqa0sv5fSN8G6NYAkdFDUOmA3yFr7afm6bWxElUwG9
         b3yvKctIn47NMfr8EwWQAFP09aJ2SyFbFFOllO/E/8LIcwy51hSKEL/LUep5LkOxkR
         x4rW5+QbesTDg3qxI7DlVfqGCO2UB5wpX3mfDcqmU+sA/sSjklvWRFPRHWPIEzJBxh
         AfIVe519tnRhQ==
Date:   Thu, 7 Apr 2022 11:29:51 +0200
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
Message-ID: <20220407092951.432a5ps3yev7qc6i@wittgenstein>
References: <20220331112318.1377494-1-brauner@kernel.org>
 <20220331112318.1377494-10-brauner@kernel.org>
 <YkdJQp7cEYeWODnX@redhat.com>
 <20220402120300.aqy4b6cltdzb7iy2@wittgenstein>
 <Yk3ENL0ErGjUPsV4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yk3ENL0ErGjUPsV4@redhat.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Apr 06, 2022 at 12:47:48PM -0400, Vivek Goyal wrote:
> On Sat, Apr 02, 2022 at 02:03:00PM +0200, Christian Brauner wrote:
> 
> [..]
> > > > +/*
> > > > + * When changing ownership of an upper object map the intended ownership
> > > > + * according to the upper layer's idmapping. When an upper mount idmaps files
> > > > + * that are stored on-disk as owned by id 1001 to id 1000 this means stat on
> > > > + * this object will report it as being owned by id 1000 when calling stat via
> > > > + * the upper mount.
> > > > + * In order to change ownership of an object so stat reports id 1000 when
> > > > + * called on an idmapped upper mount the value written to disk - i.e., the
> > > > + * value stored in ia_*id - must 1001. The mount mapping helper will thus take
> > > > + * care to map 1000 to 1001.
> > > > + * The mnt idmapping helpers are nops if the upper layer isn't idmapped.
> > > 
> > > Hi Christian,
> > > 
> > > Trying to understand the code with above example where upper has been
> > > idmapped to map on disk id 1001 to 1000. My understanding is very 
> > > primitive, so most likely i have very obvious questions.
> > 
> > Hey Vivek,
> > 
> > These are great questions. I'm happy to answer them.
> > Please feel free to also peruse the documentation in mnt_idmapping.h and
> > in Documentations/filesystems/idmappings.rst (the latter needs updating
> > though as the function names changed).
> 
> Thanks Christian. Went through idmappings.rst and that helps a lot
> in understanding what's going on w.r.t id mappings.

That's good to hear. Thank your for taking the time to read and think
through it!

> 
> > 
> > > 
> > > Given notify_change() takes "mnt_userns" as a parameter, I assumed
> > > that notify_change() will map 1000 to 1001 instead. Looks like
> > > that's not the case. Instead calling filesystem needs to map it
> > > before calling notify_change().
> > 
> > Usually all of that is done in the vfs. But since overlayfs calls
> > notify_change() directly on the upper layer this step needs to be done
> > here. So this is what ovl_do_notify_change() is doing.
> > 
> > As you might know notify_change() is (among other things) used to change
> > i_{g,u}id. For filesystems only mountable in init_user_ns the i_{g,u}id
> > values are identical to the on-disk or "backend store values".
> > 
> > I'll use the (slimmed down) systemd-homed example. Assume we have an xfs
> > filesystem mounted where all inodes on-disk are owned by 65534. We want
> > to use a part of this xfs filesystem as our home directory mounted as
> > /home/my-user. Our id on this system is 1000.
> > 
> > What systemd-homed will do is create an idmapped mount at /home/my-user.
> > The mapping it will use is: 65534:1000:<some-range>.
> > 
> > ## Reporting file ownership
> > If we now access /home/my-user and call stat to look at the ownership we
> > see that all files are reported as being owned by id 1000.
> > 
> > The responsible higher-level function here is i_uid_into_mnt() which
> > translates from filesystem ownership into mount ownership. It uses the
> > lower-level mapped_k*id_fs() which maps any inode owned by 65534 on-disk
> > to 1000. Ultimately that's put in struct kstat and then reported in the
> > last step to the user.
> > 
> > ## Creating new files
> > Now assume we're creating a new file in /home/my-user called "my-file".
> > We know our id is 1000. We know that the idmapped mount makes it so that
> > files on-disk owned by id 65534 are owned by id 1000.
> > When we create new files on disk we thus need to create them as 65534.
> > So if we do touch /home/my-dir/myfile followed by a stat on the file it
> > will be owned by id 1000.
> > 
> > The function responsible for this is inode_fs*id_set() and it translates
> > in the other direction, i.e. it maps from the idmapped mount into the
> > filesystem 1000 -> 65534. The low-level function that is responsible for
> > this is mapped_k*id_user() (as we're mapping from userspace to an on-disk
> > value).
> > 
> > ## Changing ownership: notify_change()
> > Now assume we're trying to change ownership for some file on-disk in the
> > idmapped mount to make it writable for our caller. Again, the idmapped
> > mount makes it so that all files owned by id 65534 on-disk are owned by
> > id 1000 in the idmapped mount.
> > If a (sufficiently privileged over the inode ofc) calls:
> > chown 1000:1000 /home/my-dir/some-file
> > in the idmapped mount it's conceptually identical to creating a new file
> > on-disk. This we covered earlier. We need to translate from the idmapped
> > mount into the filesystem and thus from 1000 to 65534.
> > The iattr->ia_{g,u}id need to contain the value 65534 as that's the
> > ownership that needs to be on-disk. So here we call the
> > mapped_k*id_user() helper.
> > 
> > So if we do chown 1000:1000 /home/my-dir/some-file
> > followed by stat on the file it will be owned by id 1000.
> > 
> > If we look at the filesystem from a non-idmapped location all files
> > on-disk will be owned by 65534.
> > 
> > > 
> > > .
> > > > + */
> > > > +static inline int ovl_do_notify_change(struct ovl_fs *ofs,
> > > > +				       struct dentry *upperdentry,
> > > > +				       struct iattr *attr)
> > > > +{
> > > > +	struct user_namespace *upper_idmap = ovl_upper_idmap(ofs);
> > > > +	struct user_namespace *fs_idmap = i_user_ns(d_inode(upperdentry));
> > > > +
> > > > +	if (attr->ia_valid & ATTR_UID)
> > > > +		attr->ia_uid = mapped_kuid_user(upper_idmap, fs_idmap, attr->ia_uid);
> > > > +	if (attr->ia_valid & ATTR_GID)
> > > > +		attr->ia_gid = mapped_kgid_user(upper_idmap, fs_idmap, attr->ia_gid);
> > > 
> > > Another thing which I don't understand is fs_idmap and its relation with
> > > upper_idmap. 
> > > 
> > > IIUC, fs_idmap is upper dir's filesystem subper block's namespace. That
> > > should be init_user_ns until and unless filesystem allows unprivileged
> > > mounting from inside a namespace. Is that correct?
> > 
> > Correct. You can see this clearly in mnt_idmapping.h
> > 
> > > 
> > > So effectively what we are doing is two translations. A filesystem, 
> > > mounted unprivliged, and then idmapped mount created and used as
> > > upper. And then somehow we are doing translations both for idmapped
> > > mounts and fs_idmap?
> > 
> > The idmapped mount infra was designed to be generic enough so that it is
> > possible to create idmapped mounts for filesystems that are themselves
> > idmapped.
> > 
> > It is important to understand that only filesystem that set
> > FS_ALLOW_IDMAP in fs_flags are able to create idmapped mounts. Currently
> > no filesystem that is mountable with a non-initial idmapping raises that
> > flag. But if a filesystem wanted to do this then it is possible.
> 
> Following are just some thoughts for my education.
> 
> I think "filesystem idmappings" are little tricky. IIUC, it is

They have their use-cases for pseudo-filesystems or overlay filesystems
such as overlayfs. So I always appreciated Seth's idea and work to
enable this (see [1]).

However, they have too many limitations for a lot of use-cases. From a
pure security perspective as they are not easily useable for fileystems
that parse user provided images. But also because they apply filesystem
wide which renders a whole range of use-cases completely infeasible.

> for the case where unprivileged mounting of filesystem is allowd.
> (FS_USERNS_MOUNT). And once filesystem allows that, that means if
> uid in user_ns will show up on disk. So root inside user namespace
> creates a file foo.txt, it should show up on disk as uid/gid 0/0.

Yes.
Below, I'll be using the 'u' prefix to indicate a raw device or
userspace id and the 'k' prefix to indicate a kernel id generated by
make_k*id() when the inode cache is initialized (same as I did in the
documentation you read).

Now say we have an xfs filesystem with a bunch of files that are stored
on-disk with the following ownership:

dir id:       u0
dir/file1 id: u1000
dir/file2 id: u2000

If we mount this xfs filesystem in the init_user_ns and these files are
read into the inode cache the i_*id_write() helper is called. The
helpers is then passed the on-disk id. It will call make_k*id()
internally and map the on-disk id into a k*id according to the idmapping
of the userns the filesystem is mounted in.

If the xfs filesystem is mounted in the init_user_ns the the on-disk
_value_ is identical to the _value_ stored in i_{g,u}id:

dir i_*id:       k0
dir/file1 i_*id: k1000
dir/file2 i_*id: k2000

If we _pretend_ for a minute it were possible to mount an xfs filesystem
in a userns with an idmapping of 0:10000:10000 then the value stored
on-disk would be different from the value stored in i_*id. The values in
i_*gid of struct inode would be:

dir i_*id:       k10000
dir/file1 i_*id: k11000
dir/file2 i_*id: k12000

So the i_*id values would be mapped into the userns. Consequently the fs
becomes useable for callers within that userns.

So when userns root creates a new file i_*id_read() will be passed
k10000. When the inode is written to disk the mapping needs to be
undone. So i_*id_read() is called which will map k10000 back to the
on-disk value u0 which is then stored on-disk.

> 
> Overlayfs does allow "FS_USERNS_MOUNT". I don't think it ever translates
> them back to user space id using filesystem idmappings. It just passes kuid

Yes, because overlayfs itself doesn't write anything to disk. The fs
used for the upperdir is doing that.

> down to underlying filesystem. And if underlying filesystem
> does not support "FS_USERNS_MOUNT", then files created by
> root inside userns, show up as owned some unpriviliged id
> on host.

Provided that upperdir is writable, yes.

> 
> I guess overlayfs is little special in this sense because it does
> not actually save files on disk and does not have to translate
> kuid back to uid using filesystem idmappings.

Yes.

Christian

[1]: https://www.forshee.me/container-mounts-in-ubuntu-1604/
