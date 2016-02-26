From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 1/1] OverlayFS: Fix checking permissions during lookup.
Date: Fri, 26 Feb 2016 14:41:43 -0500
Message-ID: <20160226194143.GB13054@redhat.com>
References: <20160224135552.GB8422@zenon.in.qult.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160224135552.GB8422@zenon.in.qult.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Ignacy =?utf-8?B?R2F3xJlkemtp?= <ignacy.gawedzki@green-communications.fr>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

CCing linux-fsdevel as it is a wider issue.


On Wed, Feb 24, 2016 at 02:55:52PM +0100, Ignacy Gaw=C4=99dzki wrote:
> Add alternate lookup_one_len_check function to fs/namei.c which does
> what lookup_one_len did until now with a boolean argument telling
> whether to check that the base directory is traversable.  Modify
> original lookup_one_len function to call the former with true as the
> last argument.
>=20
> In function ovl_lookup_real, file fs/overlayfs/super.c, call
> lookup_one_len_check with false as the last argument, so that failure
> to traverse the base directory does not return -EACCES.  This should
> make lookup resolution work properly in the following setup
>=20
>   drwxr-xr-x lower/
>   drwx------ lower/foo/
>   drw-r--r-- lower/boo/bar
>   drwxr-xr-x upper/
>   drwxr-xr-x upper/foo/
>=20
> when any user not being the owner of lower/foo is trying to access
> foo/bar in the mounted overlay.

So what's the problem we are trying to solve. Why should we able to
override the DAC checks of lower layer if same directory in upper
is searchable for user but it is not searchable in lower layer.=20

Thanks
Vivek

>=20
> Signed-off-by: Ignacy Gaw=C4=99dzki <ignacy.gawedzki@green-communicat=
ions.fr>
> ---
>  fs/namei.c            | 29 +++++++++++++++++++++++++----
>  fs/overlayfs/super.c  |  2 +-
>  include/linux/namei.h |  1 +
>  3 files changed, 27 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/namei.c b/fs/namei.c
> index f624d13..f9486da 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2278,6 +2278,25 @@ EXPORT_SYMBOL(vfs_path_lookup);
>   */
>  struct dentry *lookup_one_len(const char *name, struct dentry *base,=
 int len)
>  {
> +	return lookup_one_len_check(name, base, len, true);
> +}
> +EXPORT_SYMBOL(lookup_one_len);
> +
> +/**
> + * lookup_one_len_check - filesystem helper to lookup single pathnam=
e component
> + * @name:	pathname component to lookup
> + * @base:	base directory to lookup from
> + * @len:	maximum length @len should be interpreted to
> + * @check:	whether to check that @base is itself traversable.
> + *
> + * Note that this routine is purely a helper for filesystem usage an=
d should
> + * not be called by generic code.
> + *
> + * The caller must hold base->i_mutex.
> + */
> +struct dentry *lookup_one_len_check(const char *name, struct dentry =
*base,
> +				    int len, bool check_base)
> +{
>  	struct qstr this;
>  	unsigned int c;
>  	int err;
> @@ -2310,13 +2329,15 @@ struct dentry *lookup_one_len(const char *nam=
e, struct dentry *base, int len)
>  			return ERR_PTR(err);
>  	}
> =20
> -	err =3D inode_permission(base->d_inode, MAY_EXEC);
> -	if (err)
> -		return ERR_PTR(err);
> +	if (check_base) {
> +		err =3D inode_permission(base->d_inode, MAY_EXEC);
> +		if (err)
> +			return ERR_PTR(err);
> +	}
> =20
>  	return __lookup_hash(&this, base, 0);
>  }
> -EXPORT_SYMBOL(lookup_one_len);
> +EXPORT_SYMBOL(lookup_one_len_check);
> =20
>  /**
>   * lookup_one_len_unlocked - filesystem helper to lookup single path=
name component
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 8d826bd..965c5dd 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -376,7 +376,7 @@ static inline struct dentry *ovl_lookup_real(stru=
ct dentry *dir,
>  	struct dentry *dentry;
> =20
>  	inode_lock(dir->d_inode);
> -	dentry =3D lookup_one_len(name->name, dir, name->len);
> +	dentry =3D lookup_one_len_check(name->name, dir, name->len, false);
>  	inode_unlock(dir->d_inode);
> =20
>  	if (IS_ERR(dentry)) {
> diff --git a/include/linux/namei.h b/include/linux/namei.h
> index d0f25d8..0af6775 100644
> --- a/include/linux/namei.h
> +++ b/include/linux/namei.h
> @@ -77,6 +77,7 @@ extern struct dentry *kern_path_locked(const char *=
, struct path *);
>  extern int kern_path_mountpoint(int, const char *, struct path *, un=
signed int);
> =20
>  extern struct dentry *lookup_one_len(const char *, struct dentry *, =
int);
> +extern struct dentry *lookup_one_len_check(const char *, struct dent=
ry *, int, bool);
>  extern struct dentry *lookup_one_len_unlocked(const char *, struct d=
entry *, int);
> =20
>  extern int follow_down_one(struct path *);
> --=20
> 2.5.0
> --
> To unsubscribe from this list: send the line "unsubscribe linux-union=
fs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
