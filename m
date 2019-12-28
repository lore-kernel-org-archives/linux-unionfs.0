Return-Path: <adilger@dilger.ca>
Return-Path: <adilger@dilger.ca>
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <BC68C02C-E6E5-4414-A1D2-D36D335738E2@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_421161AC-7AEB-4F46-B74F-685F54147CC1";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v3 6/6] ovl: add ovl_fadvise()
Date: Fri, 27 Dec 2019 22:49:22 -0700
In-Reply-To: <1535374564-8257-7-git-send-email-amir73il@gmail.com>
References: <1535374564-8257-1-git-send-email-amir73il@gmail.com>
 <1535374564-8257-7-git-send-email-amir73il@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>


--Apple-Mail=_421161AC-7AEB-4F46-B74F-685F54147CC1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Aug 27, 2018, at 6:56 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> 
> Implement stacked fadvise to fix syscalls readahead(2) and fadvise64(2)
> on an overlayfs file.

I was just looking into the existence of the "new" fadvise() method in
the VFS being able to communicate application hints directly to the
filesystem to see if it could be used to address the word size issue in
https://bugzilla.kernel.org/show_bug.cgi?id=205957 without adding a new
syscall, and came across this patch and the 4/6 patch that adds the
vfs_fadvise() function itself (copied below for clarity).

It seems to me that this implementation is broken?  Only vfs_fadvise()
is called from the fadvise64() syscall, and it will call f_op->fadvise()
if the filesystem provides this method.  Only overlayfs provides the
.fadvise method today.  However, it looks that ovl_fadvise() calls back
into vfs_fadvise() again, in a seemingly endless loop?

It seems like generic_fadvise() should be EXPORT_SYMBOL() so that any
filesystem that implements its own .fadvise method can do its own thing,
and then call generic_fadvise() to handle the remaining MM-specific work.

Thoughts?

> +int vfs_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
> +{
> +	if (file->f_op->fadvise)
> +		return file->f_op->fadvise(file, offset, len, advice);
> +
> +	return generic_fadvise(file, offset, len, advice);
> +}
> +EXPORT_SYMBOL(vfs_fadvise);
> 
> +int ovl_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
> +{
> +	struct fd real;
> +	int ret;
> +
> +	ret = ovl_real_fdget(file, &real);
> +	if (ret)
> +		return ret;
> +
> +	/* XXX: do we need mounter credentials? */
> +	ret = vfs_fadvise(real.file, offset, len, advice);
> +
> +	fdput(real);
> +
> +	return ret;
> +}

Cheers, Andreas






--Apple-Mail=_421161AC-7AEB-4F46-B74F-685F54147CC1
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAl4G7OIACgkQcqXauRfM
H+CjVxAAhKXjX5m11b4E2eMFMuEYZ5wxLrAnFTwzy3gJBvWmL6OhiqlEPuL/TlDp
9LAofpHJGYG1NV1cD7z+RsXoL6o7Qmek2WcebDreuW4SqWflXUa+WyVaQ2JO6Zed
V4aq09Q9Sa3EDFF0BZDzUUvgbLbSnxQ/hrds0P8jeX3yE4d/+KArxFbzYY2sDFHb
eo60Qj5gQGgW2K+brp9p+p+Ryt7SEUbEKnkwqcNZ3ulqy+pE9YJuKt7KSs+s/BJg
IJysWpg3KY3ZV6g/Uewn0rtJDedHn1C55zHHyTC9wN6FDgC8fiCvsIAs48Srfp/p
xHJJDUIVhlZj3fk9f9yE76X9m5H6jLMEOwH5x7m+mmlxuibc8oT+0GfgHrjF2CkW
ES5/9E7zXLyxIacHEy68Jfa2nnNxxW5ExX7R37rJmvvT1khAfuEsurld209WU4ZU
Jk7WHrryeCRVo+HUjWQvLDYDSAiCMmzHhWpmw7A9yOqGw6gzNeecI0lchZuQCFnD
O79AeQRSJoxw5RvJ2zQY9P58tZwTrbhvYuaePX4vCKii2NycDKQaUOtrljGfZAT0
hGyJQVo0cDupp5Wxcojl9Q3+9qcJHfEc5S5Ww5ipg9D0LmlknRaSBLMl8ezA0bq0
G9uihpfQj2igPXtN/EjbVy6GJpOYeDBh/JMh36zC2SfoZi9Xm+k=
=MTn5
-----END PGP SIGNATURE-----

--Apple-Mail=_421161AC-7AEB-4F46-B74F-685F54147CC1--
