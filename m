Return-Path: <aszlig@nix.build>
Date: Thu, 14 Mar 2019 02:09:28 +0100
From: aszlig <aszlig@nix.build>
Subject: Re: Failure to execute file on overlayfs during switch_root/chroot
Message-ID: <20190314010928.GA748@dnyarri>
References: <20181207121027.GA5996@dnyarri>
 <CAJfpegsu6DUHVVac2PSyGoFW4pAKm3UH0XLg5+SMvN5XZmNzFw@mail.gmail.com>
 <20190202172914.GA17406@dnyarri>
 <CAOQ4uxh0L_u-UzJAcQ=QO+D-9VkoSy2HHofXig4=AqDo0vWTmg@mail.gmail.com>
 <20190203101340.GA6934@dnyarri>
 <CAOQ4uxhBbAX5QizTAaBaSeUUmtOewzFcqb+RpxDxaz_5P5d7fQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="IrhDeMKUP4DT/M7F"
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhBbAX5QizTAaBaSeUUmtOewzFcqb+RpxDxaz_5P5d7fQ@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, graham@grahamc.com, samuel@dionne-riel.com, cleverca22@gmail.com
List-ID: <linux-unionfs@vger.kernel.org>


--IrhDeMKUP4DT/M7F
Content-Type: multipart/mixed; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 03, 2019 at 03:51:53PM +0200, Amir Goldstein wrote:
> OK, what I don't understand and requires debugging is that the print of
> (realfile, IS_ERR(realfile) ? 0 : realfile->f_flags) suggests that realfi=
le
> is not an error value and realfile->f_flags are 0.

Just got back to debugging this properly.

I think you're confusing the same thing as I ded when first looking at the
code, because realfile actually _is_ an error in this case, so the output is
correct (I personally probably also got confused because of the
realinode/realfile variable names).

So after debugging this further (and totally digging in wrong places at fir=
st)
I found that the actual problem here is the O_NOATIME flag that is passed to
the underlying file system. If you look in fs/namei.c in function may_open(=
),
there is a check for inode_owner_or_capable().

Being able to read a file despite being the owner but having read permissio=
ns
is pefectly fine, but due to the fact that O_NOATIME is passed, the open()
fails.

Now in normal situations where the overlayfs is mounted as root, this shoul=
dn't
be a problem, but as soon as you have a networked file system, things go ba=
d.

That's what happened in our case, where we have a 9p file system mounted in=
 a
guest VM and a lowerdir of overlayfs on top of that. If the file owner on t=
he
host is the same as the current uid of qemu process, the open() works
correctly. However if it's not the case, it will fail with EPERM on the host
side (even though you have read access).

The attached patch simply removes the O_NOATIME flag, which fixes the issue.

I originally thought about adding a condition on whether to add the flag, b=
ut I
only see two options here, which IMHO are bad in their own rights:

  * Using inode_owner_or_capable() to check whether to add O_NOATIME, which=
 has
    the downside that it will not work with networked file systems where you
    map different users (I've tested this already with a different patch[1]=
).
  * Check for failure of open_with_fake_path() and retry without O_NOATIME,
    which *could* be an option, but I think that might come with a performa=
nce
    penalty.

Actually, a third option would be to just ignore O_NOATIME in fs/namei.c
instead of returning -EPERM, but I think that could open up a whole range of
other bugs.

In summary, I think just removing O_NOATIME IMHO is the most sensible optio=
n,
because it doesn't cause problems with network filesystems and also leaves =
the
atime/noatime decision to the administrator of the corresponding system.

Or is there something that I've missed where one is in dire need of O_NOATI=
ME?

a!
--=20
aszlig
Universal dilettante

--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="overlayfs-no-noatime.patch"
Content-Transfer-Encoding: quoted-printable

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

--SLDf9lqlvOQaIe6s--

--IrhDeMKUP4DT/M7F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTdUmvHdn26KBbAleVoQInOZ+u2kQUCXImpxgAKCRBoQInOZ+u2
kRSLAQC72fgwO8r543mo5wxIMJxvZDe77wk0/k/7DaRZAU5WXAD/RSaPg9EdxHlb
HJ3015HHIEkCee7Xi6w0rRkUVaSWaQM=
=reBt
-----END PGP SIGNATURE-----

--IrhDeMKUP4DT/M7F--
