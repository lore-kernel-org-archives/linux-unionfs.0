From: Jeff Mahoney <jeffm@jeffm.io>
Subject: Re: kernel BUG when fsync'ing file in a overlayfs merged dir, located
 on btrfs
Date: Thu, 24 Mar 2016 11:31:56 -0400
Message-ID: <56F4086C.2050609@jeffm.io>
References: <1443643065-16460-1-git-send-email-lebedev.ri@gmail.com>
 <563C171F.30702@jeffm.io> <20151106031845.GV22011@ZenIV.linux.org.uk>
 <563C26AE.1020403@jeffm.io> <20160324152043.GA22781@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="N0wopiwHSAHOHQP75vjnlKfgD8OXGMwL7"
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20160324152043.GA22781@ZenIV.linux.org.uk>
Sender: fstests-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Roman Lebedev <lebedev.ri@gmail.com>, David Howells <dhowells@redhat.com>, linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
List-Id: linux-unionfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--N0wopiwHSAHOHQP75vjnlKfgD8OXGMwL7
Content-Type: multipart/mixed; boundary="JAigRSWTdpvHxqb0cJkDEuepBg3QtE3ax"
From: Jeff Mahoney <jeffm@jeffm.io>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Roman Lebedev <lebedev.ri@gmail.com>, David Howells
 <dhowells@redhat.com>, linux-btrfs@vger.kernel.org,
 linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 fstests@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Message-ID: <56F4086C.2050609@jeffm.io>
Subject: Re: kernel BUG when fsync'ing file in a overlayfs merged dir, located
 on btrfs
References: <1443643065-16460-1-git-send-email-lebedev.ri@gmail.com>
 <563C171F.30702@jeffm.io> <20151106031845.GV22011@ZenIV.linux.org.uk>
 <563C26AE.1020403@jeffm.io> <20160324152043.GA22781@ZenIV.linux.org.uk>
In-Reply-To: <20160324152043.GA22781@ZenIV.linux.org.uk>

--JAigRSWTdpvHxqb0cJkDEuepBg3QtE3ax
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 3/24/16 11:20 AM, Al Viro wrote:
> On Thu, Nov 05, 2015 at 11:03:58PM -0500, Jeff Mahoney wrote:
>=20
>> I suppose the irony here is that, AFAIK, that code is to ensure a file=

>> doesn't get lost between transactions due to rename.
>>
>> Isn't the file->f_path.dentry relationship stable otherwise, though? T=
he
>> name might change and the parent might change but the dentry that the
>> file points to won't.
>=20
> Sure, it is stable.  But that doesn't guarantee anything about the
> ancestors.
>=20
> btrfs_log_inode_parent() is a mess.  Look at that loop you've got there=
:
>=20
>        while (1) {
>                 if (!parent || d_really_is_negative(parent) || sb !=3D =
d_inode(parent)->i_sb)
>                         break;
>=20
> Really?  NULL from dget_parent()?  A negative from dget_parent()?  Sodd=
ing
> superblock changing from transition to parent?
>=20
>                 inode =3D d_inode(parent);
>                 if (root !=3D BTRFS_I(inode)->root)
>                         break;
>=20
> Umm...  Something like crossing a snapshot boundary?
>=20
>                 if (BTRFS_I(inode)->generation > last_committed) { =20
>                         ret =3D btrfs_log_inode(trans, root, inode,
>                                               LOG_INODE_EXISTS,
>                                               0, LLONG_MAX, ctx);
>                         if (ret)
>                                 goto end_trans;
>                 }
>                 if (IS_ROOT(parent))
>                         break;
>=20
>                 parent =3D dget_parent(parent);
>                 dput(old_parent);
>                 old_parent =3D parent;
>         }
>=20
> Note that there's not a damn thing to guarantee that those directories =
have
> anything to do with your file - race with rename(2) easily could've sen=
t you
> chasing the wrong chain of ancestors.  Incidentally, what will happen i=
f
> you do that fsync() to an unlinked file?  It still has ->d_parent point=
ing
> to the what used to be its parent (quite possibly itself already rmdir'=
ed and
> pinned down by that reference; inode is still busy, as if we'd done ope=
n and
> rmdir).  Is that what those checks are attempting to catch?  And what h=
appens
> if rmdir happens between the check and btrfs_log_inode()?
>=20
> The thing is, playing with ancestors of opened file is very easy to get=

> wrong, regardless of overlayfs involvement.  And this code is anything
> but clear.  I don't know btrfs guts enough to be able to tell how much
> can actually break (as opposed to adding wrong inodes to transaction),
> but I would really suggest taking a good look at what's going on there.=
=2E.

Yeah, absolutely.  The file_dentry() patch that you and Miklos worked
out the other day fixes the fsync crashes for us when we use it in
btrfs_file_sync but you're 100% correct in your opinion of this code.

>> I did find a few other places where that assumption happens without an=
y
>> questionable traversals.  Sure, all three are in file systems unlikely=

>> to be used with overlayfs.
>>
>> ocfs2_prepare_inode_for_write uses file->f_path.dentry for
>> should_remove_suid (due to needing to do it early since cluster lockin=
g
>> is unknown in setattr, according to the commit).  Having
>> should_remove_suid operate on an inode would solve that easily.
>=20
> Can't do - there are filesystems that _need_ dentry for ->setattr().
>
>=20
> Grr...  Sorry, misread what you'd written.  should_remove_suid()
> ought to be switched to inode, indeed.

Ok, I'll write that up.

>> cifs_new_fileinfo keeps a reference to the dentry but it seems to be
>> used mostly to access the inode except for the nasty-looking call to
>> build_path_from_dentry in cifs_reopen_file, which I won't be touching.=

>> That does look like a questionable traversal, especially with the "we
>> can't take the rename lock here" comment.
>=20
> cifs uses fs-root-relative pathnames in protocol; nothing to do there.
> Where do you see that comment, BTW?  It uses read_seqbegin/read_seqretr=
y
> on rename_lock there...

I must've been looking at old code.  I don't see it now either.

-Jeff

--=20
Jeff Mahoney


--JAigRSWTdpvHxqb0cJkDEuepBg3QtE3ax--

--N0wopiwHSAHOHQP75vjnlKfgD8OXGMwL7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJW9AhwAAoJEB57S2MheeWyhAsP/RLnLP9O99VvS1GNkWDpfEkx
NamJl43gXYNRaIf7L79gOIgImKw8wuR6lRCp4hTa1YlxJqdkHcfuA8ECDfUFAiPw
QP9rsxhfRzsgeJjDbBXhIK/wxIjRQd65ucuceRolDzEv34l/tRPv26yg5LSu2zgK
/GxJ0bhxc2NmNKabNzn2Z72GRczJqYavuO3Wtz5MFxk1MlFz6n74uB8uAhmovvZw
XVwgsoPDMBDnudQB6YyJ4tLZVLVX0ksrZbgastNQhK21ZiwYyq2iAB+N47yj6sPc
bNF9VzrU71wi1PPiH2PzA7092R+8S3UsFsRZiXWN87XnbjhYyMLzTQXchkCYCrFH
oLoPRyQW/SjUGkZs54EfNAq8GCnFlmBNbBxqVAqGXGY4CfM2tb7Iw6iy+1F53WXg
uk7Oiu2bju+lL3m1rGGF37Ok1QF3xr1LQ23rI84X8eqIhH9F1nt67w98Wu+h+RT3
yVFnbVvB8Zwj8oE1hBke+nMmPNiKAG4C5uiDZSmjZ5mdZwJJRUUJoBaiaYnhbUV5
xeA3Lv4eOZEm+KdccqBhvoFzyzNhoBGIcNP/ysRnCTVXGCHlIXtSAIYZxbsZm8lF
yMbhGzH44IrlUYQuluY9glzLBTKdIaj2H4P6lXXR5KX4vQoI3xwKLiJ4bIP1K3Hy
d9qwfAN1bqBY/bdXOqZp
=Mwdk
-----END PGP SIGNATURE-----

--N0wopiwHSAHOHQP75vjnlKfgD8OXGMwL7--
