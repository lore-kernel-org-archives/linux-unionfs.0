From: Jeff Mahoney <jeffm@jeffm.io>
Subject: Re: kernel BUG when fsync'ing file in a overlayfs merged dir, located
 on btrfs
Date: Thu, 5 Nov 2015 23:03:58 -0500
Message-ID: <563C26AE.1020403@jeffm.io>
References: <1443643065-16460-1-git-send-email-lebedev.ri@gmail.com>
 <563C171F.30702@jeffm.io> <20151106031845.GV22011@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Xr5rJmaJ47IiOEQceKpCsah59bDCA9nGK"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:35104 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965917AbbKFED7 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 5 Nov 2015 23:03:59 -0500
Received: by ykek133 with SMTP id k133so169702326yke.2
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Nov 2015 20:03:58 -0800 (PST)
In-Reply-To: <20151106031845.GV22011@ZenIV.linux.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Roman Lebedev <lebedev.ri@gmail.com>, David Howells <dhowells@redhat.com>, linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org, Filipe Manana <fdmanana@suse.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Xr5rJmaJ47IiOEQceKpCsah59bDCA9nGK
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/5/15 10:18 PM, Al Viro wrote:
> On Thu, Nov 05, 2015 at 09:57:35PM -0500, Jeff Mahoney wrote:
>=20
>> So now file_operations callbacks can't assume that file->f_path.dentry=

>> belongs to the same file system that implements the callback.  More th=
an
>> that, any code that could ultimately get a dentry that comes from an
>> open file can't trust that it's from the same file system.
>=20
> Use file_inode() for inode.
>=20
>> This crash is due to this issue.  Unlike xfs and ext2/3/4, we use
>> file->f_path.dentry->d_inode to resolve the inode.  Using file_inode()=

>> is an easy enough fix here, but we run into trouble later.  We have
>> logic in the btrfs fsync() call path (check_parent_dirs_for_sync) that=

>> walks back up the dentry chain examining the inode's last transaction
>> and last unlink transaction to determine whether a full transaction
>> commit is required.  This obviously doesn't work if we're walking the
>> overlayfs path instead.  Regardless of any argument over whether that'=
s
>> doing the right thing, it's a pretty common pattern to assume that
>> file->f_path.dentry comes from the same file system when using a
>> file_operation.  Is it intended that that assumption is no longer vali=
d?
>=20
> It's actually rare, and your example is a perfect demonstration of the
> reasons why it is so rare.  What's to protect btrfs_log_dentry_safe()
> from racing with rename(2)?  Sure, you do dget_parent().  Which protect=
s
> you from having one-time parent dentry freed under you.  What it doesn'=
t
> do is making any promises about its relationship with your file.

I suppose the irony here is that, AFAIK, that code is to ensure a file
doesn't get lost between transactions due to rename.

Isn't the file->f_path.dentry relationship stable otherwise, though? The
name might change and the parent might change but the dentry that the
file points to won't.

I did find a few other places where that assumption happens without any
questionable traversals.  Sure, all three are in file systems unlikely
to be used with overlayfs.

ocfs2_prepare_inode_for_write uses file->f_path.dentry for
should_remove_suid (due to needing to do it early since cluster locking
is unknown in setattr, according to the commit).  Having
should_remove_suid operate on an inode would solve that easily.

fat_ioctl_set_attributes uses it to call fat_setattr, but that only uses
the inode and could have the inode_operation use a wrapper.

cifs_new_fileinfo keeps a reference to the dentry but it seems to be
used mostly to access the inode except for the nasty-looking call to
build_path_from_dentry in cifs_reopen_file, which I won't be touching.
That does look like a questionable traversal, especially with the "we
can't take the rename lock here" comment.

-Jeff

--=20
Jeff Mahoney


--Xr5rJmaJ47IiOEQceKpCsah59bDCA9nGK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIcBAEBCAAGBQJWPCaxAAoJEB57S2MheeWyvhwP/j/hc+9TOQmmV774fnhJ+o0x
/TYfVNhNKuV2aibFkYltSPf37ECrtx/3lQXep/JCANPHfQwWsxfxvrJgMA1Q7gCl
Y0AGw1UidFaJ33eqkTRhZdX6oB1yKr6vrkMQpGLA5xeClj8OXu8u00b9x2ZmjMSg
o+5gR6Kr5I/IK0QeZ29fe7J5UsaVzDTUw3s977Vy1fA65GrrJi8kdI1GyourbMdr
m6DsP0aWQN5d7rkFQUs2YvIp7E/nlBNgBBT+fp9b+F2vwiCgnHYBSmsRyhdOxXzw
EBZKm/nBRczgoI0UE/k1Infp96rjChd0+cpro3/6LfJhm53rydCQrdKweaeLA542
ywJKmE4M7EnGqkbNziHAqJ3XdGkv0soxiYsn5E27pUqIfM5UBbsY3ls8re5+lbq/
n/0VBQPVPGdQVuYQWwDQOSeUYi7T4p081notqE5RBhnXPmTnQmM2i5AtTYJhgIyC
QFzT1DTE7GROkLNO6MsmxlLmp9hzBAD7Z0I9G/MWKJkqZjzlvrIlwz0NSXyYSmdd
G3psj0IiHR8BjTXYgNHy5ntBrG/jeG+omR0Qxg2u25ZIBFS1l7fAam2EUz6iGEXb
Gv3t13xZyZX4x7G+7ONPKITXoPiwKD2XrT9CzSvV5zHaW0hurnewzd9HN7nTlSTj
I1dyuuTFTfr79pRK1u6p
=UJuw
-----END PGP SIGNATURE-----

--Xr5rJmaJ47IiOEQceKpCsah59bDCA9nGK--
