From: hujianyang <hujianyang@huawei.com>
Subject: Re: [PATCH RFC] ovl: discard independent cursor in readdir()
Date: Thu, 11 Dec 2014 10:20:29 +0800
Message-ID: <5488FF6D.5090402@huawei.com>
References: <5488222C.6080108@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:36188 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932937AbaLKCUp (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 10 Dec 2014 21:20:45 -0500
In-Reply-To: <5488222C.6080108@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

On 2014/12/10 18:36, hujianyang wrote:
> 
>  static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
> @@ -361,19 +358,14 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
>  		ovl_seek_cursor(od, ctx->pos);
>  	}
> 
> -	while (od->cursor.l_node.next != &od->cache->entries) {
> -		struct ovl_cache_entry *p;
> +	while (!list_is_last(&od->cursor->l_node, &od->cache->entries)) {

Seems I was mistake here. The entry which cursor points to could be the
last node in the list. We have finished reading one directory until the
cursor points to the head of the entries list.

Here the condition should be:

"""&od->cursor->l_node != &od->cache->entries"""

Sorry for that, I should be more careful.

I will resend this patch with this fix.

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


