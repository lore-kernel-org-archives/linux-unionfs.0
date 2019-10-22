From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v14 1/5] Add flags option to get xattr method paired to
 __vfs_getxattr
Date: Tue, 22 Oct 2019 16:13:53 -0600
Message-ID: <8CE5B6E8-DCB7-4F0B-91C1-48030947F585@dilger.ca>
References: <20191022204453.97058-1-salyzyn@android.com>
 <20191022204453.97058-2-salyzyn@android.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/mixed; boundary="===============7052337116276227858=="
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <20191022204453.97058-2-salyzyn@android.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: Mark Salyzyn <salyzyn@android.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>, Hugh Dickins <hughd@google.com>, Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, Mike Marshall <hubcap@omnibond.com>, James Morris <jmorris@namei.org>, devel@lists.orangefs.org, Eric Van Hensbergen <ericvh@gmail.com>, Joel Becker <jlbec@evilplan.org>, Anna Schumaker <anna.schumaker@netapp.com>, Trond Myklebust <trond.myklebust@hammerspace.com>, Mathieu Malaterre <malat@debian.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.com>, Casey Schaufler <casey@schaufler-ca.com>, Andrew Morton <akpm@linux-foundation.org>, Dave Kleikamp <shaggy@kernel.org>, linux-doc@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, Mimi Zohar <zohar@linux.ibm.com>, CIFS <linux-cifs@vger.kernel.org>, Paul Moore <paul@paul-moore.com>, "Darrick J . Wong" <darrick.wong@oracle.>
List-Id: linux-unionfs@vger.kernel.org


--===============7052337116276227858==
Content-Type: multipart/signed;
 boundary="Apple-Mail=_37420EF0-273E-43F4-97D0-62F6238C01CC";
 protocol="application/pgp-signature"; micalg=pgp-sha256


--Apple-Mail=_37420EF0-273E-43F4-97D0-62F6238C01CC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On Oct 22, 2019, at 2:44 PM, Mark Salyzyn <salyzyn@android.com> wrote:
>=20
> Replace arguments for get and set xattr methods, and __vfs_getxattr
> and __vfs_setaxtr functions with a reference to the following now
> common argument structure:
>=20
> struct xattr_gs_args {
> 	struct dentry *dentry;
> 	struct inode *inode;
> 	const char *name;
> 	union {
> 		void *buffer;
> 		const void *value;
> 	};
> 	size_t size;
> 	int flags;
> };

As part of this change (which is touching all of the uses of these
fields anyway) it would be useful to give these structure fields a
prefix like "xga_" so that they can be easily found with tags.
Otherwise, there are so many different "dentry" and "inode" fields
in various structures that it is hard to find the right one.

> #define __USE_KERNEL_XATTR_DEFS
>=20
> -#define XATTR_CREATE	0x1	/* set value, fail if attr already =
exists */
> -#define XATTR_REPLACE	0x2	/* set value, fail if attr does =
not exist */
> +#define XATTR_CREATE	 0x1	/* set value, fail if attr already =
exists */
> +#define XATTR_REPLACE	 0x2	/* set value, fail if attr does =
not exist */
> +#ifdef __KERNEL__ /* following is kernel internal, colocated for =
maintenance */
> +#define XATTR_NOSECURITY 0x4	/* get value, do not involve security =
check */
> +#endif

Now that these arguments are separated out into their own structure,
rather than using "int flags" (there are a million different flags in
the kernel and easily confused) it would be immediately clear *which*
flags are used here with a named enum, like:

enum xattr_flags {
	XATTR_CREATE	=3D 0x1,	/* set value, fail if attr =
already exists */
	XATTR_REPLACE	=3D 0x2,	/* set value, fail if attr does =
not exist */
#ifdef __KERNEL__ /* following is kernel internal, colocated for =
maintenance */
	XATTR_NOSECURITY=3D 0x4,  /* get value, do not involve security =
check */
#endif
};

and use this in the struct like:

struct xattr_gs_args {
	struct dentry	*xga_dentry;
	struct inode	*xga_inode;
	const char	*xga_name;
	union {
		void		*xga_buffer;
		const void	*xga_value;
	};
	size_t		 xga_size;
	enum xattr_flags xga_flags;
};

Beyond the benefit for the reader to understand the code better, this
can also allow the compiler to warn if incorrect values are being
assigned to this field.

Cheers, Andreas






--Apple-Mail=_37420EF0-273E-43F4-97D0-62F6238C01CC
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAl2vfyEACgkQcqXauRfM
H+AxqxAAq6h17WEPF6r1UpAZIwUiPfdUH5qvEj5YwdktQwWuj4vM4AD1SnRYnDv2
erszJKsHxSS8RBP18hvIK3TC7Z1TwOPYxRcZb1KRnxX0TthhtHTNL103RmQvUvKm
8KjV2ZmRZAlgrvw09BGHJF4f4ina+Ua1AQsIg7l+6eGjBHJ3Nvjmv3M/Eca3Y9Gx
eWYOM5vlA7+eVqKpCEyQ+/EN5lhBOWA+qsQhfEyPjSns/VsVae7bWkUrZSIRHpk9
i7HCwOkDj9cmfU4iZ34JePW8dtqHfoq3ECMUvsO681CznbyWB7yDnmX+UL8OFw2s
Vj2n0fIHc/r3SJ87LF/k5JhjWaYM4rCM+1+uzXmukWQWXIU2U2vkLdAPkyibo6nq
5/Z98+GzWMwnP9esRhIM1lAf2Q0QQ/Bmmz5/2rwCEYpleEKInHDZyJ3ddSCC9mxQ
+bf/9EeqBVd7b2R8rQLNcrY9R5zewIE+NovyaCcz71H6lyQ/NwfAAlUrjXN6zjGo
aZYq3D2plzK5PnJwZrmarfiI2Qtge9h2sbFNX2dRT6oLeZNzv/rAx/8AueYIcGjb
bPlf+rGFqzCVPkUQFPYqlsa/oEqUTnmr+6p8FvKO8DJhdVZEuOn/vJZV4e903hHl
VURWEhW1Djzh/zWJVrNeOQRk+0KBXXfgvZ9nHpMRbX0xESTU+cY=
=8Giq
-----END PGP SIGNATURE-----

--Apple-Mail=_37420EF0-273E-43F4-97D0-62F6238C01CC--


--===============7052337116276227858==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/

--===============7052337116276227858==--
