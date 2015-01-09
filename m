From: hujianyang <hujianyang@huawei.com>
Subject: Re: [PATCH RFC resend] ovl: discard independent cursor in readdir()
Date: Fri, 9 Jan 2015 09:43:08 +0800
Message-ID: <54AF322C.8080601@huawei.com>
References: <548901BA.3050401@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:47351 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbbAIBnY (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 8 Jan 2015 20:43:24 -0500
In-Reply-To: <548901BA.3050401@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

On 2014/12/11 10:30, hujianyang wrote:
> Since the ovl_dir_cache is stable during a directory reading, the cursor
> of struct ovl_dir_file don't need to be an independent entry in the list
> of a merged directory.
> 
> This patch changes *cursor* to a pointer which points to the entry in the
> ovl_dir_cache. After this, we don't need to check *is_cursor* either.
> 
> Signed-off-by: hujianyang <hujianyang@huawei.com>
> ---
>  fs/overlayfs/readdir.c |   33 ++++++++++++---------------------
>  1 files changed, 12 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 8087b63..b65e1ed 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -24,7 +24,6 @@ struct ovl_cache_entry {
>  	struct list_head l_node;
>  	struct rb_node node;
>  	bool is_whiteout;
> -	bool is_cursor;
>  	char name[];
>  };
> 
> @@ -49,7 +48,7 @@ struct ovl_dir_file {
>  	bool is_real;
>  	bool is_upper;
>  	struct ovl_dir_cache *cache;
> -	struct ovl_cache_entry cursor;
> +	struct ovl_cache_entry *cursor;
>  	struct file *realfile;
>  	struct file *upperfile;
>  };
> @@ -94,7 +93,6 @@ static struct ovl_cache_entry *ovl_cache_entry_new(const char *name, int len,
>  		p->type = d_type;
>  		p->ino = ino;
>  		p->is_whiteout = false;
> -		p->is_cursor = false;
>  	}
> 
>  	return p;
> @@ -195,7 +193,7 @@ static void ovl_cache_put(struct ovl_dir_file *od, struct dentry *dentry)
>  {
>  	struct ovl_dir_cache *cache = od->cache;
> 
> -	list_del_init(&od->cursor.l_node);
> +	od->cursor = NULL;
>  	WARN_ON(cache->refcount <= 0);
>  	cache->refcount--;
>  	if (!cache->refcount) {
> @@ -298,13 +296,12 @@ static void ovl_seek_cursor(struct ovl_dir_file *od, loff_t pos)
>  	loff_t off = 0;
> 
>  	list_for_each_entry(p, &od->cache->entries, l_node) {
> -		if (p->is_cursor)
> -			continue;
>  		if (off >= pos)
>  			break;
>  		off++;
>  	}
> -	list_move_tail(&od->cursor.l_node, &p->l_node);
> +	/* Curosr is safe since the cache is stable */
> +	od->cursor = p;
>  }
> 
>  static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
> @@ -361,19 +358,14 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
>  		ovl_seek_cursor(od, ctx->pos);
>  	}
> 
> -	while (od->cursor.l_node.next != &od->cache->entries) {
> -		struct ovl_cache_entry *p;
> +	while (&od->cursor->l_node != &od->cache->entries) {
> +		struct ovl_cache_entry *p = od->cursor;
> 
> -		p = list_entry(od->cursor.l_node.next, struct ovl_cache_entry, l_node);
> -		/* Skip cursors */
> -		if (!p->is_cursor) {
> -			if (!p->is_whiteout) {
> -				if (!dir_emit(ctx, p->name, p->len, p->ino, p->type))
> -					break;
> -			}
> -			ctx->pos++;
> -		}
> -		list_move(&od->cursor.l_node, &p->l_node);
> +		if (!p->is_whiteout)
> +			if (!dir_emit(ctx, p->name, p->len, p->ino, p->type))
> +				break;
> +		od->cursor = list_next_entry(p, l_node);
> +		ctx->pos++;
>  	}
>  	return 0;
>  }
> @@ -492,11 +484,10 @@ static int ovl_dir_open(struct inode *inode, struct file *file)
>  		kfree(od);
>  		return PTR_ERR(realfile);
>  	}
> -	INIT_LIST_HEAD(&od->cursor.l_node);
>  	od->realfile = realfile;
>  	od->is_real = !OVL_TYPE_MERGE(type);
>  	od->is_upper = OVL_TYPE_UPPER(type);
> -	od->cursor.is_cursor = true;
> +	od->cursor = NULL;
>  	file->private_data = od;
> 
>  	return 0;
> 

Hi Miklos,

How do you feel about this cleanup?

