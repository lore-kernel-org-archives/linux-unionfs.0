Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA0FC43334
	for <linux-unionfs@archiver.kernel.org>; Wed,  6 Jul 2022 15:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiGFPHA (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 6 Jul 2022 11:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbiGFPG7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 6 Jul 2022 11:06:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 82D231AF06
        for <linux-unionfs@vger.kernel.org>; Wed,  6 Jul 2022 08:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657120015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8Zmbq13/R4OvCMS14M4uq393Y9nt4UUDX+mo55YkGwU=;
        b=FQDPj9De3P+/yR9CcqcRLvMYJ37K40suvtP2fPt3dR2bZezOHCylVfKSa+n4MD3zW+Dwaw
        wXdw6RWAjBpaa70DK0oX1dKVVbppyhOaiCQUt3DVWEv536EaplbcN/LveSZCUrdSOqFy6a
        JUTIPuEbpFjTWU77Fljll31Ce8nZ2Lg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-50-AOBfwnFdNber2Ii2NjBH4g-1; Wed, 06 Jul 2022 11:06:44 -0400
X-MC-Unique: AOBfwnFdNber2Ii2NjBH4g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C43DD1019C8F;
        Wed,  6 Jul 2022 15:06:43 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.22.33.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CBDA1121315;
        Wed,  6 Jul 2022 15:06:43 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 5BE55220463; Wed,  6 Jul 2022 11:06:43 -0400 (EDT)
Date:   Wed, 6 Jul 2022 11:06:43 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Seth Forshee <sforshee@digitalocean.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Aleksa Sarai <cyphar@cyphar.com>, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH] ovl: turn of SB_POSIXACL with idmapped layers temporarily
Message-ID: <YsWlA3Y6M45aPeMW@redhat.com>
References: <20220706135611.257213-1-brauner@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706135611.257213-1-brauner@kernel.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jul 06, 2022 at 03:56:11PM +0200, Christian Brauner wrote:
> This cycle we added support for mounting overlayfs on top of idmapped mounts.
> Recently I've started looking into potential corner cases when trying to add
> additional tests and I noticed that reporting for POSIX ACLs is currently wrong
> when using idmapped layers with overlayfs mounted on top of it.

Disabling posix ACL support in overlayfs if any of the lower/upper
layers are idmapped mounts for the time being sounds reasonable
to me. Anyway this is a new piece of functionality. Once posix
acl stuff is fixed, then this restriction can be lifted.

Thanks
Vivek

> 
> I have sent out an patch that fixes this and makes POSIX ACLs work correctly
> but the patch is a bit bigger and we're already at -rc5 so I recommend we
> simply don't raise SB_POSIXACL when idmapped layers are used. Then we can fix
> the VFS part described below for the next merge window so we can have good
> exposure in -next.
> 
> I'm going to give a rather detailed explanation to both the origin of the
> problem and mention the solution so people know what's going on.
> 
> Let's assume the user creates the following directory layout and they have a
> rootfs /var/lib/lxc/c1/rootfs. The files in this rootfs are owned as you would
> expect files on your host system to be owned. For example, ~/.bashrc for your
> regular user would be owned by 1000:1000 and /root/.bashrc would be owned by
> 0:0. IOW, this is just regular boring filesystem tree on an ext4 or xfs
> filesystem.
> 
> The user chooses to set POSIX ACLs using the setfacl binary granting the user
> with uid 4 read, write, and execute permissions for their .bashrc file:
> 
>         setfacl -m u:4:rwx /var/lib/lxc/c2/rootfs/home/ubuntu/.bashrc
> 
> Now they to expose the whole rootfs to a container using an idmapped mount. So
> they first create:
> 
>         mkdir -pv /vol/contpool/{ctrover,merge,lowermap,overmap}
>         mkdir -pv /vol/contpool/ctrover/{over,work}
>         chown 10000000:10000000 /vol/contpool/ctrover/{over,work}
> 
> The user now creates an idmapped mount for the rootfs:
> 
>         mount-idmapped/mount-idmapped --map-mount=b:0:10000000:65536 \
>                                       /var/lib/lxc/c2/rootfs \
>                                       /vol/contpool/lowermap
> 
> This for example makes it so that /var/lib/lxc/c2/rootfs/home/ubuntu/.bashrc
> which is owned by uid and gid 1000 as being owned by uid and gid 10001000 at
> /vol/contpool/lowermap/home/ubuntu/.bashrc.
> 
> Assume the user wants to expose these idmapped mounts through an overlayfs
> mount to a container.
> 
>        mount -t overlay overlay                      \
>              -o lowerdir=/vol/contpool/lowermap,     \
>                 upperdir=/vol/contpool/overmap/over, \
>                 workdir=/vol/contpool/overmap/work   \
>              /vol/contpool/merge
> 
> The user can do this in two ways:
> 
> (1) Mount overlayfs in the initial user namespace and expose it to the
>     container.
> (2) Mount overlayfs on top of the idmapped mounts inside of the container's
>     user namespace.
> 
> Let's assume the user chooses the (1) option and mounts overlayfs on the host
> and then changes into a container which uses the idmapping 0:10000000:65536
> which is the same used for the two idmapped mounts.
> 
> Now the user tries to retrieve the POSIX ACLs using the getfacl command
> 
>         getfacl -n /vol/contpool/lowermap/home/ubuntu/.bashrc
> 
> and to their surprise they see:
> 
>         # file: vol/contpool/merge/home/ubuntu/.bashrc
>         # owner: 1000
>         # group: 1000
>         user::rw-
>         user:4294967295:rwx
>         group::r--
>         mask::rwx
>         other::r--
> 
> indicating the the uid wasn't correctly translated according to the idmapped
> mount. The problem is how we currently translate POSIX ACLs. Let's inspect the
> callchain in this example:
> 
>         idmapped mount /vol/contpool/merge:      0:10000000:65536
>         caller's idmapping:                      0:10000000:65536
>         overlayfs idmapping (ofs->creator_cred): 0:0:4k /* initial idmapping */
> 
>         sys_getxattr()
>         -> path_getxattr()
>            -> getxattr()
>               -> do_getxattr()
>                   |> vfs_getxattr()
>                   |  -> __vfs_getxattr()
>                   |     -> handler->get == ovl_posix_acl_xattr_get()
>                   |        -> ovl_xattr_get()
>                   |           -> vfs_getxattr()
>                   |              -> __vfs_getxattr()
>                   |                 -> handler->get() /* lower filesystem callback */
>                   |> posix_acl_fix_xattr_to_user()
>                      {
>                               4 = make_kuid(&init_user_ns, 4);
>                               4 = mapped_kuid_fs(&init_user_ns /* no idmapped mount */, 4);
>                               /* FAILURE */
>                              -1 = from_kuid(0:10000000:65536 /* caller's idmapping */, 4);
>                      }
> 
> If the user chooses to use option (2) and mounts overlayfs on top of idmapped
> mounts inside the container things don't look that much better:
> 
>         idmapped mount /vol/contpool/merge:      0:10000000:65536
>         caller's idmapping:                      0:10000000:65536
>         overlayfs idmapping (ofs->creator_cred): 0:10000000:65536
> 
>         sys_getxattr()
>         -> path_getxattr()
>            -> getxattr()
>               -> do_getxattr()
>                   |> vfs_getxattr()
>                   |  -> __vfs_getxattr()
>                   |     -> handler->get == ovl_posix_acl_xattr_get()
>                   |        -> ovl_xattr_get()
>                   |           -> vfs_getxattr()
>                   |              -> __vfs_getxattr()
>                   |                 -> handler->get() /* lower filesystem callback */
>                   |> posix_acl_fix_xattr_to_user()
>                      {
>                               4 = make_kuid(&init_user_ns, 4);
>                               4 = mapped_kuid_fs(&init_user_ns, 4);
>                               /* FAILURE */
>                              -1 = from_kuid(0:10000000:65536 /* caller's idmapping */, 4);
>                      }
> 
> As is easily seen the problem arises because the idmapping of the lower mount
> isn't taken into account as all of this happens in do_gexattr(). But
> do_getxattr() is always called on an overlayfs mount and inode and thus cannot
> possible take the idmapping of the lower layers into account.
> 
> This problem is similar for fscaps but there the translation happens as part of
> vfs_getxattr() already. Let's walk through an fscaps overlayfs callchain:
> 
>         setcap 'cap_net_raw+ep' /var/lib/lxc/c2/rootfs/home/ubuntu/.bashrc
> 
> The expected outcome here is that we'll receive the cap_net_raw capability as
> we are able to map the uid associated with the fscap to 0 within our container.
> IOW, we want to see 0 as the result of the idmapping translations.
> 
> If the user chooses option (1) we get the following callchain for fscaps:
> 
>         idmapped mount /vol/contpool/merge:      0:10000000:65536
>         caller's idmapping:                      0:10000000:65536
>         overlayfs idmapping (ofs->creator_cred): 0:0:4k /* initial idmapping */
> 
>         sys_getxattr()
>         -> path_getxattr()
>            -> getxattr()
>               -> do_getxattr()
>                    -> vfs_getxattr()
>                       -> xattr_getsecurity()
>                          -> security_inode_getsecurity()                                       ________________________________
>                             -> cap_inode_getsecurity()                                         |                              |
>                                {                                                               V                              |
>                                         10000000 = make_kuid(0:0:4k /* overlayfs idmapping */, 10000000);                     |
>                                         10000000 = mapped_kuid_fs(0:0:4k /* no idmapped mount */, 10000000);                  |
>                                                /* Expected result is 0 and thus that we own the fscap. */                     |
>                                                0 = from_kuid(0:10000000:65536 /* caller's idmapping */, 10000000);            |
>                                }                                                                                              |
>                                -> vfs_getxattr_alloc()                                                                        |
>                                   -> handler->get == ovl_other_xattr_get()                                                    |
>                                      -> vfs_getxattr()                                                                        |
>                                         -> xattr_getsecurity()                                                                |
>                                            -> security_inode_getsecurity()                                                    |
>                                               -> cap_inode_getsecurity()                                                      |
>                                                  {                                                                            |
>                                                                 0 = make_kuid(0:0:4k /* lower s_user_ns */, 0);               |
>                                                          10000000 = mapped_kuid_fs(0:10000000:65536 /* idmapped mount */, 0); |
>                                                          10000000 = from_kuid(0:0:4k /* overlayfs idmapping */, 10000000);    |
>                                                          |____________________________________________________________________|
>                                                  }
>                                                  -> vfs_getxattr_alloc()
>                                                     -> handler->get == /* lower filesystem callback */
> 
> And if the user chooses option (2) we get:
> 
>         idmapped mount /vol/contpool/merge:      0:10000000:65536
>         caller's idmapping:                      0:10000000:65536
>         overlayfs idmapping (ofs->creator_cred): 0:10000000:65536
> 
>         sys_getxattr()
>         -> path_getxattr()
>            -> getxattr()
>               -> do_getxattr()
>                    -> vfs_getxattr()
>                       -> xattr_getsecurity()
>                          -> security_inode_getsecurity()                                                _______________________________
>                             -> cap_inode_getsecurity()                                                  |                             |
>                                {                                                                        V                             |
>                                        10000000 = make_kuid(0:10000000:65536 /* overlayfs idmapping */, 0);                           |
>                                        10000000 = mapped_kuid_fs(0:0:4k /* no idmapped mount */, 10000000);                           |
>                                                /* Expected result is 0 and thus that we own the fscap. */                             |
>                                               0 = from_kuid(0:10000000:65536 /* caller's idmapping */, 10000000);                     |
>                                }                                                                                                      |
>                                -> vfs_getxattr_alloc()                                                                                |
>                                   -> handler->get == ovl_other_xattr_get()                                                            |
>                                     |-> vfs_getxattr()                                                                                |
>                                         -> xattr_getsecurity()                                                                        |
>                                            -> security_inode_getsecurity()                                                            |
>                                               -> cap_inode_getsecurity()                                                              |
>                                                  {                                                                                    |
>                                                                  0 = make_kuid(0:0:4k /* lower s_user_ns */, 0);                      |
>                                                           10000000 = mapped_kuid_fs(0:10000000:65536 /* idmapped mount */, 0);        |
>                                                                  0 = from_kuid(0:10000000:65536 /* overlayfs idmapping */, 10000000); |
>                                                                  |____________________________________________________________________|
>                                                  }
>                                                  -> vfs_getxattr_alloc()
>                                                     -> handler->get == /* lower filesystem callback */
> 
> We can see how the translation happens correctly in those cases as the
> conversion happens within the vfs_getxattr() helper.
> 
> For POSIX ACLs we need to do something similar. However, in contrast to fscaps
> we cannot apply the fix directly to the kernel internal posix acl data
> structure as this would alter the cached values and would also require a rework
> of how we currently deal with POSIX ACLs in general which almost never take the
> filesystem idmapping into account (the noteable exception being FUSE but even
> there the implementation is special) and instead retrieve the raw values based
> on the initial idmapping.
> 
> The correct values are then generated right before returning to userspace. The
> fix for this is to move taking the mount's idmapping into account directly in
> vfs_getxattr() instead of having it be part of posix_acl_fix_xattr_to_user().
> 
> To this end we simply move the idmapped mount translation into a separate step
> performed in vfs_{g,s}etxattr() instead of in
> posix_acl_fix_xattr_{from,to}_user().
> 
> To see how this fixes things let's go back to the original example. Assume the
> user chose option (1) and mounted overlayfs on top of idmapped mounts on the
> host:
> 
>         idmapped mount /vol/contpool/merge:      0:10000000:65536
>         caller's idmapping:                      0:10000000:65536
>         overlayfs idmapping (ofs->creator_cred): 0:0:4k /* initial idmapping */
> 
>         sys_getxattr()
>         -> path_getxattr()
>            -> getxattr()
>               -> do_getxattr()
>                   |> vfs_getxattr()
>                   |  |> __vfs_getxattr()
>                   |  |  -> handler->get == ovl_posix_acl_xattr_get()
>                   |  |     -> ovl_xattr_get()
>                   |  |        -> vfs_getxattr()
>                   |  |           |> __vfs_getxattr()
>                   |  |           |  -> handler->get() /* lower filesystem callback */
>                   |  |           |> posix_acl_getxattr_idmapped_mnt()
>                   |  |              {
>                   |  |                              4 = make_kuid(&init_user_ns, 4);
>                   |  |                       10000004 = mapped_kuid_fs(0:10000000:65536 /* lower idmapped mount */, 4);
>                   |  |                       10000004 = from_kuid(&init_user_ns, 10000004);
>                   |  |                       |_______________________
>                   |  |              }                               |
>                   |  |                                              |
>                   |  |> posix_acl_getxattr_idmapped_mnt()           |
>                   |     {                                           |
>                   |                                                 V
>                   |             10000004 = make_kuid(&init_user_ns, 10000004);
>                   |             10000004 = mapped_kuid_fs(&init_user_ns /* no idmapped mount */, 10000004);
>                   |             10000004 = from_kuid(&init_user_ns, 10000004);
>                   |     }       |_________________________________________________
>                   |                                                              |
>                   |                                                              |
>                   |> posix_acl_fix_xattr_to_user()                               |
>                      {                                                           V
>                                  10000004 = make_kuid(0:0:4k /* init_user_ns */, 10000004);
>                                         /* SUCCESS */
>                                         4 = from_kuid(0:10000000:65536 /* caller's idmapping */, 10000004);
>                      }
> 
> And similarly if the user chooses option (1) and mounted overayfs on top of
> idmapped mounts inside the container:
> 
>         idmapped mount /vol/contpool/merge:      0:10000000:65536
>         caller's idmapping:                      0:10000000:65536
>         overlayfs idmapping (ofs->creator_cred): 0:10000000:65536
> 
>         sys_getxattr()
>         -> path_getxattr()
>            -> getxattr()
>               -> do_getxattr()
>                   |> vfs_getxattr()
>                   |  |> __vfs_getxattr()
>                   |  |  -> handler->get == ovl_posix_acl_xattr_get()
>                   |  |     -> ovl_xattr_get()
>                   |  |        -> vfs_getxattr()
>                   |  |           |> __vfs_getxattr()
>                   |  |           |  -> handler->get() /* lower filesystem callback */
>                   |  |           |> posix_acl_getxattr_idmapped_mnt()
>                   |  |              {
>                   |  |                              4 = make_kuid(&init_user_ns, 4);
>                   |  |                       10000004 = mapped_kuid_fs(0:10000000:65536 /* lower idmapped mount */, 4);
>                   |  |                       10000004 = from_kuid(&init_user_ns, 10000004);
>                   |  |                       |_______________________
>                   |  |              }                               |
>                   |  |                                              |
>                   |  |> posix_acl_getxattr_idmapped_mnt()           |
>                   |     {                                           V
>                   |             10000004 = make_kuid(&init_user_ns, 10000004);
>                   |             10000004 = mapped_kuid_fs(&init_user_ns /* no idmapped mount */, 10000004);
>                   |             10000004 = from_kuid(0(&init_user_ns, 10000004);
>                   |             |_________________________________________________
>                   |     }                                                        |
>                   |                                                              |
>                   |> posix_acl_fix_xattr_to_user()                               |
>                      {                                                           V
>                                  10000004 = make_kuid(0:0:4k /* init_user_ns */, 10000004);
>                                         /* SUCCESS */
>                                         4 = from_kuid(0:10000000:65536 /* caller's idmappings */, 10000004);
>                      }
> 
> The last remaining problem we need to fix here is ovl_get_acl(). During
> ovl_permission() overlayfs will call:
> 
>         ovl_permission()
>         -> generic_permission()
>            -> acl_permission_check()
>               -> check_acl()
>                  -> get_acl()
>                     -> inode->i_op->get_acl() == ovl_get_acl()
>                         > get_acl() /* on the underlying filesystem)
>                           ->inode->i_op->get_acl() == /*lower filesystem callback */
>                  -> posix_acl_permission()
> 
> passing through the get_acl request to the underlying filesystem. This will
> retrieve the acls stored in the lower filesystem without taking the idmapping
> of the underlying mount into account as this would mean altering the cached
> values for the lower filesystem. The simple solution is to have ovl_get_acl()
> simply duplicate the ACLs, update the values according to the idmapped mount
> and return it to acl_permission_check() so it can be used in
> posix_acl_permission(). Since overlayfs doesn't cache ACLs they'll be released
> right after.
> 
> Link: https://github.com/brauner/mount-idmapped/issues/9
> Cc: Seth Forshee <sforshee@digitalocean.com>
> Cc: Amir Goldstein <amir73il@gmail.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Aleksa Sarai <cyphar@cyphar.com>
> Cc: Miklos Szeredi <mszeredi@redhat.com>
> Cc: linux-unionfs@vger.kernel.org
> Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> ---
> Hey Miklos,
> 
> I describe in detail how I'm going to fix this with the series I intend
> to get ready for the next merge window in the commit message.
> 
> I would just turn off POSIX ACLs until then. Would you be ok with that
> and route this to Linus this or next week?
> 
> Thanks!
> Christian
> ---
>  Documentation/filesystems/overlayfs.rst |  4 ++++
>  fs/overlayfs/super.c                    | 21 ++++++++++++++++++++-
>  2 files changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
> index 7da6c30ed596..316cfd8b1891 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -466,6 +466,10 @@ overlay filesystem and the value of st_ino for filesystem objects may not be
>  persistent and could change even while the overlay filesystem is mounted, as
>  summarized in the `Inode properties`_ table above.
>  
> +4) "idmapped mounts"
> +When the upper or lower layers are idmapped mounts overlayfs will be mounted
> +without support for POSIX Access Control Lists (ACLs). This limitation will
> +eventually be lifted.
>  
>  Changes to underlying filesystems
>  ---------------------------------
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index e0a2e0468ee7..d21b61570cd1 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1960,6 +1960,22 @@ static struct dentry *ovl_get_root(struct super_block *sb,
>  	return root;
>  }
>  
> +static bool ovl_has_idmapped_layers(struct ovl_fs *ofs)
> +{
> +	const struct vfsmount *mnt = ovl_upper_mnt(ofs);
> +	unsigned int i;
> +
> +	if (mnt && is_idmapped_mnt(mnt))
> +		return true;
> +
> +	for (i = 1; i < ofs->numlayer; i++) {
> +		if (is_idmapped_mnt(ofs->layers[i].mnt))
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
>  static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>  {
>  	struct path upperpath = { };
> @@ -2129,7 +2145,10 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>  	sb->s_xattr = ofs->config.userxattr ? ovl_user_xattr_handlers :
>  		ovl_trusted_xattr_handlers;
>  	sb->s_fs_info = ofs;
> -	sb->s_flags |= SB_POSIXACL;
> +	if (ovl_has_idmapped_layers(ofs))
> +		pr_warn("POSIX ACLs are not yet supported with idmapped layers, mounting without ACL support.\n");
> +	else
> +		sb->s_flags |= SB_POSIXACL;
>  	sb->s_iflags |= SB_I_SKIP_SYNC;
>  
>  	err = -ENOMEM;
> 
> base-commit: 88084a3df1672e131ddc1b4e39eeacfd39864acf
> -- 
> 2.34.1
> 

