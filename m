Return-Path: <aszlig@nix.build>
Date: Sat, 16 Mar 2019 04:21:50 +0100
From: aszlig <aszlig@nix.build>
Subject: [PATCH] ovl: Don't open files with O_NOATIME in lowerdir
Message-ID: <20190316032135.GA9179@dnyarri>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <CAOQ4uxipOHT+OzPtFE1ZoSFEJSrEr-MErwp5KX+tBwXq39sx8g@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Graham Christensen <graham@grahamc.com>, Samuel Dionne-Riel <samuel@dionne-riel.com>, michael bishop <cleverca22@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Being able to read a file despite being the owner but having read
permissions is pefectly fine, however due to the fact that O_NOATIME is
passed in ovl_open_realfile (which also affects lowerdir), the open()
fails.

Now in normal situations where the overlayfs is mounted as root, this
shouldn't be a problem, but as soon as you have a networked file system,
things go bad.

That's what happens in NixOS VM tests, where there is a 9p file system
mounted in a guest VM and a lowerdir of overlayfs on top of that. If the
file owner on the host is the same as the current uid of qemu process,
the open() works correctly. However if it's not the case, it will fail
with EPERM on the host side (even though you have read access).

I originally thought about adding a condition on whether to add the
flag, but I only see two options here, which IMHO are bad in their own
rights:

  * Using inode_owner_or_capable() to check whether to add O_NOATIME,
    which has the downside that it will not work with networked file
    systems where you map different users (I've tested this already with
    a different patch[1]).
  * Check for failure of open_with_fake_path() and retry without
    O_NOATIME, which *could* be an option, but I think that might come
    with a performance penalty.

Actually, a third option would be to just ignore O_NOATIME in fs/namei.c
instead of returning -EPERM, but I think that could open up a whole
range of other bugs.

So I'm simply removing the O_NOATIME flag when it comes to lowerdir,
because for now it is IMHO the most sensible option, as it doesn't cause
problems with network file systems and also leaves the atime/noatime
decision to the administrator of the corresponding system. This also
reverts the behaviour to what we had prior to Linux 4.19.

Originally, I had only removed the flag from ovl_open_realfile, but as
Amir Goldstein pointed out, this is also the case when copying files to
upperdir. On NixOS I didn't notice this, because Nix store paths are
never changed and only new ones are added if the build recipe differs.

Signed-off-by: aszlig <aszlig@nix.build>
---
 fs/overlayfs/copy_up.c | 7 ++++++-
 fs/overlayfs/file.c    | 2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 9e62dcf06fc4..e43d2a2e9d49 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -131,7 +131,12 @@ static int ovl_copy_up_data(struct path *old, struct p=
ath *new, loff_t len)
 	if (len =3D=3D 0)
 		return 0;
=20
-	old_file =3D ovl_path_open(old, O_LARGEFILE | O_RDONLY);
+	/*
+	 * Note that this is not using ovl_path_open() because it will use
+	 * O_NOATIME, which in turn could cause issues for networked file
+	 * systems.
+	 */
+	old_file =3D dentry_open(old, O_LARGEFILE | O_RDONLY, current_cred());
 	if (IS_ERR(old_file))
 		return PTR_ERR(old_file);
=20
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 84dd957efa24..3f9b9275267b 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -31,7 +31,7 @@ static struct file *ovl_open_realfile(const struct file *=
file,
 	const struct cred *old_cred;
=20
 	old_cred =3D ovl_override_creds(inode->i_sb);
-	realfile =3D open_with_fake_path(&file->f_path, file->f_flags | O_NOATIME,
+	realfile =3D open_with_fake_path(&file->f_path, file->f_flags,
 				       realinode, current_cred());
 	revert_creds(old_cred);
=20
--=20
2.19.2

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTdUmvHdn26KBbAleVoQInOZ+u2kQUCXIxrvQAKCRBoQInOZ+u2
kRF3AQDn7VqQ6oQysL06bDAuiFpC1JJzDsWalsUcHeQei5RrTQEAn8DoaTFNGagv
kM1DRa9SBKPOLHSs6oMuTFnAWyeYDA4=
=5UvS
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
