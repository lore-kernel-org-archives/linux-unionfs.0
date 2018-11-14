Return-Path: <vgoyal@redhat.com>
Date: Wed, 14 Nov 2018 09:17:32 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] ovl: fix missing override creds in link of a metacopy
 upper
Message-ID: <20181114141732.GA29804@redhat.com>
References: <20181114140134.6996-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181114140134.6996-1-amir73il@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Theodore Y . Ts'o" <tytso@mit.edu>, Maciej =?utf-8?B?WmnEmWJh?= <maciekz82@gmail.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Nov 14, 2018 at 04:01:34PM +0200, Amir Goldstein wrote:
> Theodore Ts'o reported a v4.19 regression with docker-dropbox:
> https://marc.info/?l=linux-fsdevel&m=154070089431116&w=2
> 
> "I was rebuilding my dropbox Docker container, and it failed in 4.19
>  with the following error:
>  ...
>  dpkg: error: error creating new backup file \
>               '/var/lib/dpkg/status-old': Invalid cross-device link"
> 
> The problem did not reproduce with metacopy feature disabled.
> The error was caused by insufficient credentials to set
> "trusted.overlay.redirect" xattr on link of a metacopy file.
> 

Thanks Amir for fixiing this. This fix looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

So this problem happened because looks like kernel enanbled metacopy
by default (in Kconfig) and thence enabled redirect by default in Kconfig.

I am wondering how does that impact docker build process. Because if
redirect/metacopy is enabled, while during diff, docker falls back to
using older naivediff interface as opposed to newer nativediff. I am
not sure how slower naivediff is as compared to nativediff. I am raising
this point here because I am curious. If somebody has that info, please
share.

Thanks
Vivek


> Reproducer:
> 
>  echo Y > /sys/module/overlay/parameters/redirect_dir
>  echo Y > /sys/module/overlay/parameters/metacopy
>  cd /tmp
>  mkdir l u w m
>  chmod 777 l u
>  touch l/foo
>  ln l/foo l/link
>  chmod 666 l/foo
>  mount -t overlay none -olowerdir=l,upperdir=u,workdir=w m
>  su fsgqa
>  ln m/foo m/bar
>  [   21.455823] overlayfs: failed to set redirect (-1)
>  ln: failed to create hard link 'm/bar' => 'm/foo':\
>      Invalid cross-device link
> 
> Reported-by: Theodore Y. Ts'o <tytso@mit.edu>
> Reported-by: Maciej Zięba <maciekz82@gmail.com>
> Fixes: 4120fe64dce4 ("ovl: Set redirect on upper inode when it is linked")
> Cc: <stable@vger.kernel.org> # v4.19
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/dir.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index c6289147c787..82c129bfe58d 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -651,6 +651,18 @@ static int ovl_symlink(struct inode *dir, struct dentry *dentry,
>  	return ovl_create_object(dentry, S_IFLNK, 0, link);
>  }
>  
> +static int ovl_set_link_redirect(struct dentry *dentry)
> +{
> +	const struct cred *old_cred;
> +	int err;
> +
> +	old_cred = ovl_override_creds(dentry->d_sb);
> +	err = ovl_set_redirect(dentry, false);
> +	revert_creds(old_cred);
> +
> +	return err;
> +}
> +
>  static int ovl_link(struct dentry *old, struct inode *newdir,
>  		    struct dentry *new)
>  {
> @@ -670,7 +682,7 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
>  		goto out_drop_write;
>  
>  	if (ovl_is_metacopy_dentry(old)) {
> -		err = ovl_set_redirect(old, false);
> +		err = ovl_set_link_redirect(old);
>  		if (err)
>  			goto out_drop_write;
>  	}
> -- 
> 2.17.1
> 
