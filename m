Return-Path: <viro@ftp.linux.org.uk>
Date: Sun, 7 Oct 2018 17:06:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] ovl: untangle copy up call chain
Message-ID: <20181007160648.GY32577@ZenIV.linux.org.uk>
References: <20181006041531.30246-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181006041531.30246-1-amir73il@gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Oct 06, 2018 at 07:15:31AM +0300, Amir Goldstein wrote:
> +static int ovl_link_tmpfile(struct ovl_copy_up_ctx *c, struct dentry *temp,
> +			    struct dentry **newdentry)
> +{
> +	int err;
> +	struct dentry *upper = NULL;
> +	struct inode *udir = d_inode(c->destdir);
> +
> +	inode_lock_nested(udir, I_MUTEX_PARENT);
> +	upper = lookup_one_len(c->destname.name, c->destdir, c->destname.len);
> +	err = PTR_ERR(upper);
> +	if (IS_ERR(upper))
> +		goto out;

dput(ERR_PTR(something)) will immediately oops on you...
