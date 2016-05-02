From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC 0/8] Xattr inode operation removal
Date: Mon, 2 May 2016 17:23:19 -0600
Message-ID: <551ED650-CBF8-40D6-85A0-BDB3C281C247@dilger.ca>
References: <1462229118-13123-1-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_FA625B6E-8D68-4467-B0AA-8F8F3DA7B330"; protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36781 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258AbcEBXX1 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 2 May 2016 19:23:27 -0400
Received: by mail-io0-f194.google.com with SMTP id k129so570008iof.3
        for <linux-unionfs@vger.kernel.org>; Mon, 02 May 2016 16:23:27 -0700 (PDT)
In-Reply-To: <1462229118-13123-1-git-send-email-agruenba@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fuse-devel@lists.sourceforge.net, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, James Simmons <jsimmons@infradead.org>


--Apple-Mail=_FA625B6E-8D68-4467-B0AA-8F8F3DA7B330
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On May 2, 2016, at 4:45 PM, Andreas Gruenbacher <agruenba@redhat.com> =
wrote:
>=20
> Hi all,
>=20
> what are your thoughts on this patch set?  It applies on top of the
> work.xattr branch [*], converts the remaining filesystems over to =
xattr
> handlers, and replaces the getxattr, setxattr, and removexattr inode
> operations.  The only way to implement getxattr, setxattr, and
> removexattr with this approach is through xattr handlers.

Maybe I'm missing the point of this patch, but is there a long-term =
benefit
to this change?  It seems to be replacing the ->getxattr() and related =
inode
methods with a generic ->xattr handler list that needs to be =
demultiplexed
on each access?  Is there a net improvement in functionality that comes
out the other end?  That isn't at all clear from your comments or the
patches themselves.  It seems that all of LOC savings is from deleting
the .setxattr, .getxattr, and .removexattr lines from inode_operations
but there is added complexity in the rest of the code?

Cheers, Andreas

>=20
> *** Please don't merge yet: this is boot tested only so far! ***
>=20
> Lustre currently also breaks; I haven't succeeded in cleaning up the
> mess there.  Oleg and Andreas, would you like to look into that?
>=20
> Thanks,
> Andreas
>=20
> [*] =
https://git.kernel.org/cgit/linux/kernel/git/viro/vfs.git/log/?h=3Dwork.xa=
ttr
>=20
> Andreas Gruenbacher (8):
>  ecryptfs: Switch to generic xattr handlers
>  overlayfs: Switch to generic xattr handlers
>  fuse: Switch to generic xattr handlers
>  evm: Turn evm_update_evmxattr into void function
>  xattr: Add per-inode xattr handlers as a new inode operation
>  xattr: Add __vfs_{get,set,remove}xattr helpers
>  xattr: Stop calling {get,set,remove}xattr inode operations
>  xattr: Remove generic xattr handlers
>=20
> fs/9p/vfs_inode_dotl.c                |   9 --
> fs/bad_inode.c                        |  33 +++--
> fs/btrfs/inode.c                      |  12 --
> fs/cachefiles/bind.c                  |   4 +-
> fs/cachefiles/namei.c                 |   4 +-
> fs/ceph/dir.c                         |   3 -
> fs/ceph/inode.c                       |   6 -
> fs/cifs/cifsfs.c                      |   9 --
> fs/ecryptfs/ecryptfs_kernel.h         |   2 +
> fs/ecryptfs/inode.c                   |  64 +++++-----
> fs/ecryptfs/main.c                    |   1 +
> fs/ecryptfs/mmap.c                    |  15 +--
> fs/ext2/file.c                        |   3 -
> fs/ext2/namei.c                       |   6 -
> fs/ext2/symlink.c                     |   6 -
> fs/ext4/file.c                        |   3 -
> fs/ext4/namei.c                       |   6 -
> fs/ext4/symlink.c                     |   9 --
> fs/f2fs/file.c                        |   3 -
> fs/f2fs/namei.c                       |  12 --
> fs/fuse/dir.c                         |  40 ++++--
> fs/fuse/fuse_i.h                      |   2 +
> fs/fuse/inode.c                       |   1 +
> fs/gfs2/inode.c                       |   9 --
> fs/hfs/inode.c                        |   2 -
> fs/hfsplus/dir.c                      |   3 -
> fs/hfsplus/inode.c                    |   3 -
> fs/jffs2/dir.c                        |   3 -
> fs/jffs2/file.c                       |   3 -
> fs/jffs2/symlink.c                    |   3 -
> fs/jfs/file.c                         |   3 -
> fs/jfs/namei.c                        |   3 -
> fs/jfs/symlink.c                      |   6 -
> fs/kernfs/dir.c                       |   3 -
> fs/kernfs/inode.c                     |   3 -
> fs/kernfs/symlink.c                   |   3 -
> fs/libfs.c                            |  26 +---
> fs/nfs/nfs3proc.c                     |   6 -
> fs/nfs/nfs4proc.c                     |   6 -
> fs/ocfs2/file.c                       |   3 -
> fs/ocfs2/namei.c                      |   3 -
> fs/ocfs2/symlink.c                    |   3 -
> fs/orangefs/inode.c                   |   3 -
> fs/orangefs/namei.c                   |   3 -
> fs/orangefs/symlink.c                 |   1 -
> fs/overlayfs/copy_up.c                |   4 -
> fs/overlayfs/dir.c                    |   3 -
> fs/overlayfs/inode.c                  |  46 +++++--
> fs/overlayfs/overlayfs.h              |   6 +-
> fs/overlayfs/super.c                  |   5 +-
> fs/reiserfs/file.c                    |   3 -
> fs/reiserfs/namei.c                   |   9 --
> fs/squashfs/inode.c                   |   1 -
> fs/squashfs/namei.c                   |   1 -
> fs/squashfs/symlink.c                 |   1 -
> fs/squashfs/xattr.h                   |   1 -
> fs/ubifs/dir.c                        |   3 -
> fs/ubifs/file.c                       |   6 -
> fs/xattr.c                            | 231 =
++++++++++++++++------------------
> fs/xfs/xfs_iops.c                     |  12 --
> include/linux/fs.h                    |   5 +-
> include/linux/xattr.h                 |  12 +-
> mm/shmem.c                            |  15 ---
> net/socket.c                          |   1 -
> security/commoncap.c                  |  25 ++--
> security/integrity/evm/evm.h          |   7 +-
> security/integrity/evm/evm_crypto.c   |  20 ++-
> security/integrity/evm/evm_main.c     |   5 +-
> security/integrity/ima/ima_appraise.c |  23 ++--
> security/selinux/hooks.c              |  28 +----
> security/smack/smack_lsm.c            |  28 ++---
> 71 files changed, 314 insertions(+), 541 deletions(-)
>=20
> --
> 2.5.5
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_FA625B6E-8D68-4467-B0AA-8F8F3DA7B330
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVyfhaHKl2rkXzB/gAQjF6BAAi3Qd+iU+UkQ+eAuUFbL+L8T+cNmEIsUf
Ypxmo1qdE9s3mxH0lMjyeOC/apSrPr3KQVckuxJ/R7erNx++0ansIwIfOqgfzyD+
mJlC9PDHnBVkoGBJfRDqvRGPo1jr5QmnTBTl45zMir6YtMgWQ5m6Sn/4AenRyR5K
o33xAo20zeTgb9MjknwSKVoFb4d17S6SqhvlJNPdW2GAf/1uQgG7tleieLA/XoIB
crqSC6bqnP6/jL01/S5y8bGXoQ9f4X2236tDCsgm4fOJr8ZG5uiWIyR66d+1tlNr
njDrpFHqd3+Qb01E3dGJH0sjRzOk4OW5cq5as8g+rQt4c2GG6e/s7jMF1xZvxYqh
KdRld8jWJekCzpL4SNiz7vM1w3G81YMKwSqdZQ7sRb73F5DdTHdafHjwLZVQEhxG
usiq7KttHsMzqW/ftc6zIYVPklZxvGtRpQeRZ1Hk+eTvDspVlhs2Af+UJFx0NZ4w
zmtbbNL2X+ekx9KR5fVtaKRY59l8zauCSlRJgYB9ytGHJNnGRVsEvL00OZvrAD24
gO3i89ir0hDYE2zd4NfEcpcTV3O2ddmurs4qGIdZt35jsrCJuqy9LMu6unvRUbET
6gYVoqNVYpo8ge6RdsDNWTphuuSkHvVUfSWPBTGwiHV8m7gSFzL8uPZAV/czWLva
wuAzOLTwA1c=
=+EgV
-----END PGP SIGNATURE-----

--Apple-Mail=_FA625B6E-8D68-4467-B0AA-8F8F3DA7B330--
