Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58AE4CCA479
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Jul 2022 13:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235322AbiGGNGK (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 09:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234163AbiGGNGJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Jul 2022 09:06:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90B430F5C
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Jul 2022 06:06:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E41BB82017
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Jul 2022 13:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD3DC341C6;
        Thu,  7 Jul 2022 13:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657199165;
        bh=7lSvefrYQkELt7+yP6g0evD2IzaObUOlMIgFbckosH8=;
        h=From:To:Cc:Subject:Date:From;
        b=XfMcAS2eeYLLu0z6lKkV3HkKSo5LqI2UldZaRkWgg/UYLx9ItxWakM6sEaEQDa9Mn
         zYJ2G/7Sv6RMCrt0YAdDd6Kdiq7Rhyu6xyTHjW9VRSe6osecLdV9F0FawBaMUQ8FtE
         wVv4TjYhrfjUesrYZif8b7cG56ZMc2gCrz1PXFSLbr7oTRcTBPUjD4vuVldp9n3qDW
         jecJ9go4BLIkWTATDikevx+8PBzxGIM7DU6qr+ekGPhs85vrU20/pDbJBOA67hxk4T
         TVGl/KG6QlEjWajHU+eIhDd7y96QdEDCJ+MTo3AY1faSLfsHOL21RMiLxt5/exRWCD
         QZj7B/+OuS4PQ==
From:   Christian Brauner <brauner@kernel.org>
To:     Seth Forshee <sforshee@digitalocean.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Aleksa Sarai <cyphar@cyphar.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH v2] ovl: turn of SB_POSIXACL with idmapped layers temporarily
Date:   Thu,  7 Jul 2022 15:05:20 +0200
Message-Id: <20220707130520.321344-1-brauner@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=23820; h=from:subject; bh=7lSvefrYQkELt7+yP6g0evD2IzaObUOlMIgFbckosH8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQdu7lpaur+ePa/z1Kv3IossXWqEsn+vvvJrdIlknvycgo2 bpmf11HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCR/coM/3N79kx2Tmj2d1xp6ftcND Rr2TLu7qu7J/x8Wf7yyh5XTW6Gf2rT8v62T+ScOC1e+Hz0p59zRXZcUrpW1m8Yn2TxPdqvkRUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This cycle we added support for mounting overlayfs on top of idmapped mounts.
Recently I've started looking into potential corner cases when trying to add
additional tests and I noticed that reporting for POSIX ACLs is currently wrong
when using idmapped layers with overlayfs mounted on top of it.

I have sent out an patch that fixes this and makes POSIX ACLs work correctly
but the patch is a bit bigger and we're already at -rc5 so I recommend we
simply don't raise SB_POSIXACL when idmapped layers are used. Then we can fix
the VFS part described below for the next merge window so we can have good
exposure in -next.

I'm going to give a rather detailed explanation to both the origin of the
problem and mention the solution so people know what's going on.

Let's assume the user creates the following directory layout and they have a
rootfs /var/lib/lxc/c1/rootfs. The files in this rootfs are owned as you would
expect files on your host system to be owned. For example, ~/.bashrc for your
regular user would be owned by 1000:1000 and /root/.bashrc would be owned by
0:0. IOW, this is just regular boring filesystem tree on an ext4 or xfs
filesystem.

The user chooses to set POSIX ACLs using the setfacl binary granting the user
with uid 4 read, write, and execute permissions for their .bashrc file:

        setfacl -m u:4:rwx /var/lib/lxc/c2/rootfs/home/ubuntu/.bashrc

Now they to expose the whole rootfs to a container using an idmapped mount. So
they first create:

        mkdir -pv /vol/contpool/{ctrover,merge,lowermap,overmap}
        mkdir -pv /vol/contpool/ctrover/{over,work}
        chown 10000000:10000000 /vol/contpool/ctrover/{over,work}

The user now creates an idmapped mount for the rootfs:

        mount-idmapped/mount-idmapped --map-mount=b:0:10000000:65536 \
                                      /var/lib/lxc/c2/rootfs \
                                      /vol/contpool/lowermap

This for example makes it so that /var/lib/lxc/c2/rootfs/home/ubuntu/.bashrc
which is owned by uid and gid 1000 as being owned by uid and gid 10001000 at
/vol/contpool/lowermap/home/ubuntu/.bashrc.

Assume the user wants to expose these idmapped mounts through an overlayfs
mount to a container.

       mount -t overlay overlay                      \
             -o lowerdir=/vol/contpool/lowermap,     \
                upperdir=/vol/contpool/overmap/over, \
                workdir=/vol/contpool/overmap/work   \
             /vol/contpool/merge

The user can do this in two ways:

(1) Mount overlayfs in the initial user namespace and expose it to the
    container.
(2) Mount overlayfs on top of the idmapped mounts inside of the container's
    user namespace.

Let's assume the user chooses the (1) option and mounts overlayfs on the host
and then changes into a container which uses the idmapping 0:10000000:65536
which is the same used for the two idmapped mounts.

Now the user tries to retrieve the POSIX ACLs using the getfacl command

        getfacl -n /vol/contpool/lowermap/home/ubuntu/.bashrc

and to their surprise they see:

        # file: vol/contpool/merge/home/ubuntu/.bashrc
        # owner: 1000
        # group: 1000
        user::rw-
        user:4294967295:rwx
        group::r--
        mask::rwx
        other::r--

indicating the the uid wasn't correctly translated according to the idmapped
mount. The problem is how we currently translate POSIX ACLs. Let's inspect the
callchain in this example:

        idmapped mount /vol/contpool/merge:      0:10000000:65536
        caller's idmapping:                      0:10000000:65536
        overlayfs idmapping (ofs->creator_cred): 0:0:4k /* initial idmapping */

        sys_getxattr()
        -> path_getxattr()
           -> getxattr()
              -> do_getxattr()
                  |> vfs_getxattr()
                  |  -> __vfs_getxattr()
                  |     -> handler->get == ovl_posix_acl_xattr_get()
                  |        -> ovl_xattr_get()
                  |           -> vfs_getxattr()
                  |              -> __vfs_getxattr()
                  |                 -> handler->get() /* lower filesystem callback */
                  |> posix_acl_fix_xattr_to_user()
                     {
                              4 = make_kuid(&init_user_ns, 4);
                              4 = mapped_kuid_fs(&init_user_ns /* no idmapped mount */, 4);
                              /* FAILURE */
                             -1 = from_kuid(0:10000000:65536 /* caller's idmapping */, 4);
                     }

If the user chooses to use option (2) and mounts overlayfs on top of idmapped
mounts inside the container things don't look that much better:

        idmapped mount /vol/contpool/merge:      0:10000000:65536
        caller's idmapping:                      0:10000000:65536
        overlayfs idmapping (ofs->creator_cred): 0:10000000:65536

        sys_getxattr()
        -> path_getxattr()
           -> getxattr()
              -> do_getxattr()
                  |> vfs_getxattr()
                  |  -> __vfs_getxattr()
                  |     -> handler->get == ovl_posix_acl_xattr_get()
                  |        -> ovl_xattr_get()
                  |           -> vfs_getxattr()
                  |              -> __vfs_getxattr()
                  |                 -> handler->get() /* lower filesystem callback */
                  |> posix_acl_fix_xattr_to_user()
                     {
                              4 = make_kuid(&init_user_ns, 4);
                              4 = mapped_kuid_fs(&init_user_ns, 4);
                              /* FAILURE */
                             -1 = from_kuid(0:10000000:65536 /* caller's idmapping */, 4);
                     }

As is easily seen the problem arises because the idmapping of the lower mount
isn't taken into account as all of this happens in do_gexattr(). But
do_getxattr() is always called on an overlayfs mount and inode and thus cannot
possible take the idmapping of the lower layers into account.

This problem is similar for fscaps but there the translation happens as part of
vfs_getxattr() already. Let's walk through an fscaps overlayfs callchain:

        setcap 'cap_net_raw+ep' /var/lib/lxc/c2/rootfs/home/ubuntu/.bashrc

The expected outcome here is that we'll receive the cap_net_raw capability as
we are able to map the uid associated with the fscap to 0 within our container.
IOW, we want to see 0 as the result of the idmapping translations.

If the user chooses option (1) we get the following callchain for fscaps:

        idmapped mount /vol/contpool/merge:      0:10000000:65536
        caller's idmapping:                      0:10000000:65536
        overlayfs idmapping (ofs->creator_cred): 0:0:4k /* initial idmapping */

        sys_getxattr()
        -> path_getxattr()
           -> getxattr()
              -> do_getxattr()
                   -> vfs_getxattr()
                      -> xattr_getsecurity()
                         -> security_inode_getsecurity()                                       ________________________________
                            -> cap_inode_getsecurity()                                         |                              |
                               {                                                               V                              |
                                        10000000 = make_kuid(0:0:4k /* overlayfs idmapping */, 10000000);                     |
                                        10000000 = mapped_kuid_fs(0:0:4k /* no idmapped mount */, 10000000);                  |
                                               /* Expected result is 0 and thus that we own the fscap. */                     |
                                               0 = from_kuid(0:10000000:65536 /* caller's idmapping */, 10000000);            |
                               }                                                                                              |
                               -> vfs_getxattr_alloc()                                                                        |
                                  -> handler->get == ovl_other_xattr_get()                                                    |
                                     -> vfs_getxattr()                                                                        |
                                        -> xattr_getsecurity()                                                                |
                                           -> security_inode_getsecurity()                                                    |
                                              -> cap_inode_getsecurity()                                                      |
                                                 {                                                                            |
                                                                0 = make_kuid(0:0:4k /* lower s_user_ns */, 0);               |
                                                         10000000 = mapped_kuid_fs(0:10000000:65536 /* idmapped mount */, 0); |
                                                         10000000 = from_kuid(0:0:4k /* overlayfs idmapping */, 10000000);    |
                                                         |____________________________________________________________________|
                                                 }
                                                 -> vfs_getxattr_alloc()
                                                    -> handler->get == /* lower filesystem callback */

And if the user chooses option (2) we get:

        idmapped mount /vol/contpool/merge:      0:10000000:65536
        caller's idmapping:                      0:10000000:65536
        overlayfs idmapping (ofs->creator_cred): 0:10000000:65536

        sys_getxattr()
        -> path_getxattr()
           -> getxattr()
              -> do_getxattr()
                   -> vfs_getxattr()
                      -> xattr_getsecurity()
                         -> security_inode_getsecurity()                                                _______________________________
                            -> cap_inode_getsecurity()                                                  |                             |
                               {                                                                        V                             |
                                       10000000 = make_kuid(0:10000000:65536 /* overlayfs idmapping */, 0);                           |
                                       10000000 = mapped_kuid_fs(0:0:4k /* no idmapped mount */, 10000000);                           |
                                               /* Expected result is 0 and thus that we own the fscap. */                             |
                                              0 = from_kuid(0:10000000:65536 /* caller's idmapping */, 10000000);                     |
                               }                                                                                                      |
                               -> vfs_getxattr_alloc()                                                                                |
                                  -> handler->get == ovl_other_xattr_get()                                                            |
                                    |-> vfs_getxattr()                                                                                |
                                        -> xattr_getsecurity()                                                                        |
                                           -> security_inode_getsecurity()                                                            |
                                              -> cap_inode_getsecurity()                                                              |
                                                 {                                                                                    |
                                                                 0 = make_kuid(0:0:4k /* lower s_user_ns */, 0);                      |
                                                          10000000 = mapped_kuid_fs(0:10000000:65536 /* idmapped mount */, 0);        |
                                                                 0 = from_kuid(0:10000000:65536 /* overlayfs idmapping */, 10000000); |
                                                                 |____________________________________________________________________|
                                                 }
                                                 -> vfs_getxattr_alloc()
                                                    -> handler->get == /* lower filesystem callback */

We can see how the translation happens correctly in those cases as the
conversion happens within the vfs_getxattr() helper.

For POSIX ACLs we need to do something similar. However, in contrast to fscaps
we cannot apply the fix directly to the kernel internal posix acl data
structure as this would alter the cached values and would also require a rework
of how we currently deal with POSIX ACLs in general which almost never take the
filesystem idmapping into account (the noteable exception being FUSE but even
there the implementation is special) and instead retrieve the raw values based
on the initial idmapping.

The correct values are then generated right before returning to userspace. The
fix for this is to move taking the mount's idmapping into account directly in
vfs_getxattr() instead of having it be part of posix_acl_fix_xattr_to_user().

To this end we simply move the idmapped mount translation into a separate step
performed in vfs_{g,s}etxattr() instead of in
posix_acl_fix_xattr_{from,to}_user().

To see how this fixes things let's go back to the original example. Assume the
user chose option (1) and mounted overlayfs on top of idmapped mounts on the
host:

        idmapped mount /vol/contpool/merge:      0:10000000:65536
        caller's idmapping:                      0:10000000:65536
        overlayfs idmapping (ofs->creator_cred): 0:0:4k /* initial idmapping */

        sys_getxattr()
        -> path_getxattr()
           -> getxattr()
              -> do_getxattr()
                  |> vfs_getxattr()
                  |  |> __vfs_getxattr()
                  |  |  -> handler->get == ovl_posix_acl_xattr_get()
                  |  |     -> ovl_xattr_get()
                  |  |        -> vfs_getxattr()
                  |  |           |> __vfs_getxattr()
                  |  |           |  -> handler->get() /* lower filesystem callback */
                  |  |           |> posix_acl_getxattr_idmapped_mnt()
                  |  |              {
                  |  |                              4 = make_kuid(&init_user_ns, 4);
                  |  |                       10000004 = mapped_kuid_fs(0:10000000:65536 /* lower idmapped mount */, 4);
                  |  |                       10000004 = from_kuid(&init_user_ns, 10000004);
                  |  |                       |_______________________
                  |  |              }                               |
                  |  |                                              |
                  |  |> posix_acl_getxattr_idmapped_mnt()           |
                  |     {                                           |
                  |                                                 V
                  |             10000004 = make_kuid(&init_user_ns, 10000004);
                  |             10000004 = mapped_kuid_fs(&init_user_ns /* no idmapped mount */, 10000004);
                  |             10000004 = from_kuid(&init_user_ns, 10000004);
                  |     }       |_________________________________________________
                  |                                                              |
                  |                                                              |
                  |> posix_acl_fix_xattr_to_user()                               |
                     {                                                           V
                                 10000004 = make_kuid(0:0:4k /* init_user_ns */, 10000004);
                                        /* SUCCESS */
                                        4 = from_kuid(0:10000000:65536 /* caller's idmapping */, 10000004);
                     }

And similarly if the user chooses option (1) and mounted overayfs on top of
idmapped mounts inside the container:

        idmapped mount /vol/contpool/merge:      0:10000000:65536
        caller's idmapping:                      0:10000000:65536
        overlayfs idmapping (ofs->creator_cred): 0:10000000:65536

        sys_getxattr()
        -> path_getxattr()
           -> getxattr()
              -> do_getxattr()
                  |> vfs_getxattr()
                  |  |> __vfs_getxattr()
                  |  |  -> handler->get == ovl_posix_acl_xattr_get()
                  |  |     -> ovl_xattr_get()
                  |  |        -> vfs_getxattr()
                  |  |           |> __vfs_getxattr()
                  |  |           |  -> handler->get() /* lower filesystem callback */
                  |  |           |> posix_acl_getxattr_idmapped_mnt()
                  |  |              {
                  |  |                              4 = make_kuid(&init_user_ns, 4);
                  |  |                       10000004 = mapped_kuid_fs(0:10000000:65536 /* lower idmapped mount */, 4);
                  |  |                       10000004 = from_kuid(&init_user_ns, 10000004);
                  |  |                       |_______________________
                  |  |              }                               |
                  |  |                                              |
                  |  |> posix_acl_getxattr_idmapped_mnt()           |
                  |     {                                           V
                  |             10000004 = make_kuid(&init_user_ns, 10000004);
                  |             10000004 = mapped_kuid_fs(&init_user_ns /* no idmapped mount */, 10000004);
                  |             10000004 = from_kuid(0(&init_user_ns, 10000004);
                  |             |_________________________________________________
                  |     }                                                        |
                  |                                                              |
                  |> posix_acl_fix_xattr_to_user()                               |
                     {                                                           V
                                 10000004 = make_kuid(0:0:4k /* init_user_ns */, 10000004);
                                        /* SUCCESS */
                                        4 = from_kuid(0:10000000:65536 /* caller's idmappings */, 10000004);
                     }

The last remaining problem we need to fix here is ovl_get_acl(). During
ovl_permission() overlayfs will call:

        ovl_permission()
        -> generic_permission()
           -> acl_permission_check()
              -> check_acl()
                 -> get_acl()
                    -> inode->i_op->get_acl() == ovl_get_acl()
                        > get_acl() /* on the underlying filesystem)
                          ->inode->i_op->get_acl() == /*lower filesystem callback */
                 -> posix_acl_permission()

passing through the get_acl request to the underlying filesystem. This will
retrieve the acls stored in the lower filesystem without taking the idmapping
of the underlying mount into account as this would mean altering the cached
values for the lower filesystem. The simple solution is to have ovl_get_acl()
simply duplicate the ACLs, update the values according to the idmapped mount
and return it to acl_permission_check() so it can be used in
posix_acl_permission(). Since overlayfs doesn't cache ACLs they'll be released
right after.

Link: https://github.com/brauner/mount-idmapped/issues/9
Cc: Seth Forshee <sforshee@digitalocean.com>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
/* v2 */
- Miklos Szeredi <mszeredi@redhat.com>:
  - Block POSIX ACLs completely by adding checks into
    ovl_posix_acl_xattr_{g,s}et().
---
 Documentation/filesystems/overlayfs.rst |  4 ++++
 fs/overlayfs/super.c                    | 27 ++++++++++++++++++++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 7da6c30ed596..316cfd8b1891 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -466,6 +466,10 @@ overlay filesystem and the value of st_ino for filesystem objects may not be
 persistent and could change even while the overlay filesystem is mounted, as
 summarized in the `Inode properties`_ table above.
 
+4) "idmapped mounts"
+When the upper or lower layers are idmapped mounts overlayfs will be mounted
+without support for POSIX Access Control Lists (ACLs). This limitation will
+eventually be lifted.
 
 Changes to underlying filesystems
 ---------------------------------
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e0a2e0468ee7..0ac664945655 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1003,6 +1003,9 @@ ovl_posix_acl_xattr_get(const struct xattr_handler *handler,
 			struct dentry *dentry, struct inode *inode,
 			const char *name, void *buffer, size_t size)
 {
+	if (!IS_POSIXACL(d_inode(dentry)))
+		return -EOPNOTSUPP;
+
 	return ovl_xattr_get(dentry, inode, handler->name, buffer, size);
 }
 
@@ -1018,6 +1021,9 @@ ovl_posix_acl_xattr_set(const struct xattr_handler *handler,
 	struct posix_acl *acl = NULL;
 	int err;
 
+	if (!IS_POSIXACL(d_inode(dentry)))
+		return -EOPNOTSUPP;
+
 	/* Check that everything is OK before copy-up */
 	if (value) {
 		acl = posix_acl_from_xattr(&init_user_ns, value, size);
@@ -1960,6 +1966,22 @@ static struct dentry *ovl_get_root(struct super_block *sb,
 	return root;
 }
 
+static bool ovl_has_idmapped_layers(struct ovl_fs *ofs)
+{
+	const struct vfsmount *mnt = ovl_upper_mnt(ofs);
+	unsigned int i;
+
+	if (mnt && is_idmapped_mnt(mnt))
+		return true;
+
+	for (i = 1; i < ofs->numlayer; i++) {
+		if (is_idmapped_mnt(ofs->layers[i].mnt))
+			return true;
+	}
+
+	return false;
+}
+
 static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct path upperpath = { };
@@ -2129,7 +2151,10 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_xattr = ofs->config.userxattr ? ovl_user_xattr_handlers :
 		ovl_trusted_xattr_handlers;
 	sb->s_fs_info = ofs;
-	sb->s_flags |= SB_POSIXACL;
+	if (ovl_has_idmapped_layers(ofs))
+		pr_warn("POSIX ACLs are not yet supported with idmapped layers, mounting without ACL support.\n");
+	else
+		sb->s_flags |= SB_POSIXACL;
 	sb->s_iflags |= SB_I_SKIP_SYNC;
 
 	err = -ENOMEM;

base-commit: 88084a3df1672e131ddc1b4e39eeacfd39864acf
-- 
2.34.1

