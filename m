Return-Path: <cgxu519@gmx.com>
Content-Type: text/plain;
	charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Subject: Re: [PATCH] ovl: adjust memory allocation size for stack in
 ovl_lookup
From: "cgxu519@gmx.com" <cgxu519@gmx.com>
In-Reply-To: <1523418133-93764-1-git-send-email-cgxu519@gmx.com>
Date: Wed, 11 Apr 2018 12:27:11 +0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <9C2904F2-2866-4CCE-9EED-4B302B6C272D@gmx.com>
References: <1523418133-93764-1-git-send-email-cgxu519@gmx.com>
To: overlayfs <linux-unionfs@vger.kernel.org>
Cc: "cgxu519@gmx.com" <cgxu519@gmx.com>, miklos@szeredi.hu, amir73il@gmail.com
List-ID: <linux-unionfs@vger.kernel.org>

Sorry, I noticed number of stack entry is poe->numlower in previous =
version,
so I must be missing redirect related thing here, please just drop the =
patch.


> =D4=DA 2018=C4=EA4=D4=C211=C8=D5=A3=AC=C9=CF=CE=E711:42=A3=ACChengguang =
Xu <cgxu519@gmx.com> =D0=B4=B5=C0=A3=BA
>=20
> In ovl_lookup, the number of lowerstack entry is no bigger
> than poe->numlower, so adjust memory allocation size for stack.
>=20
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
> ---
> fs/overlayfs/namei.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 2dba29e..81dbc3f 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -888,7 +888,7 @@ struct dentry *ovl_lookup(struct inode *dir, =
struct dentry *dentry,
>=20
> 	if (!d.stop && poe->numlower) {
> 		err =3D -ENOMEM;
> -		stack =3D kcalloc(ofs->numlower, sizeof(struct =
ovl_path),
> +		stack =3D kcalloc(poe->numlower, sizeof(struct =
ovl_path),
> 				GFP_KERNEL);
> 		if (!stack)
> 			goto out_put_upper;
> --=20
> 1.8.3.1
>=20
