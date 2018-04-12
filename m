From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 02/35] vfs: add path_open()
Date: Thu, 12 Apr 2018 09:38:56 -0700
Message-ID: <20180412163856.GB24728@bombadil.infradead.org>
References: <20180412150826.20988-1-mszeredi@redhat.com>
 <20180412150826.20988-3-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180412150826.20988-3-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Thu, Apr 12, 2018 at 05:07:53PM +0200, Miklos Szeredi wrote:
> Currently opening an overlay file results in:
> 
>  - the real file on the underlying layer being opened
>  - f_path being set to the overlay {mount, dentry} pair
> 
> This patch adds a new helper that allows the above to be explicitly
> performed.  I.e. it's the same as dentry_open(), except the underlying
> inode to open is given as a separate argument.
> 
> This is in preparation for stacking I/O operations on overlay files.
> 
> Later, when implicit opening is removed, dentry_open() can be implemented
> by just calling path_open().
> 
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/open.c          | 27 +++++++++++++++++++++++++++
>  include/linux/fs.h |  2 ++
>  2 files changed, 29 insertions(+)
> 
> diff --git a/fs/open.c b/fs/open.c
> index 7ea118471dce..8c315f9ec2f6 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -866,6 +866,33 @@ int vfs_open(const struct path *path, struct file *file,
>  	return do_dentry_open(file, d_backing_inode(dentry), NULL, cred);
>  }
>  

This really warrants some kernel-doc.  Let me try to get this started and
you can fix it:

/**
 * path_open() - Open an inode by a particular name.
 * @path: The name of the file.
 * @flags: The O_ flags used to open this file.
 * @inode: The inode to open.
 * @cred: The task's credentials used when opening this file.
 *
 * ...
 *
 * Context: Process context.
 * Return: A pointer to a struct file or an IS_ERR pointer.  Cannot return NULL.
 */

> +struct file *path_open(const struct path *path, int flags, struct inode *inode,
> +		       const struct cred *cred)
> +{
> +	struct file *file;
> +	int retval;
> +
> +	file = get_empty_filp();
> +	if (!IS_ERR(file)) {
> +		file->f_flags = flags;
> +		file->f_path = *path;
> +		retval = do_dentry_open(file, inode, NULL, cred);
> +		if (retval) {
> +			put_filp(file);
> +			file = ERR_PTR(retval);
> +		} else {
> +			retval = open_check_o_direct(file);
> +			if (retval) {
> +				fput(file);
> +				file = ERR_PTR(retval);
> +			}
> +		}
> +	}
> +
> +	return file;

I'd find this clearer written like this ...

+	file = get_empty_filp();
+	if (IS_ERR(file))
+		return file;
+
+	file->f_flags = flags;
+	file->f_path = *path;
+	retval = do_dentry_open(file, inode, NULL, cred);
+	if (retval)
+		goto err;
+	retval = open_check_o_direct(file);
+	if (retval)
+		goto err;
+	return file;
+err:
+	put_filp(file);
+	return ERR_PTR(retval);
