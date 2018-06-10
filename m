From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 23/39] ovl: add O_DIRECT support
Date: Sun, 10 Jun 2018 06:31:42 +0100
Message-ID: <20180610053128.GO30522@ZenIV.linux.org.uk>
References: <20180529144339.16538-1-mszeredi@redhat.com>
 <20180529144339.16538-24-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529144339.16538-24-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 29, 2018 at 04:43:23PM +0200, Miklos Szeredi wrote:
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/overlayfs/file.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 3f610a5b38e4..e5e7ccaaf9ec 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -110,6 +110,9 @@ static int ovl_open(struct inode *inode, struct file *file)
>  	if (IS_ERR(realfile))
>  		return PTR_ERR(realfile);
>  
> +	/* For O_DIRECT dentry_open() checks f_mapping->a_ops->direct_IO */
> +	file->f_mapping = realfile->f_mapping;

Umm...  What happens if upper layer doesn't allow O_DIRECT, while the lower one does?
