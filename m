Return-Path: <SRS0=r5kD=AY=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEEF3C433E3
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Jul 2020 19:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E60920663
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Jul 2020 19:25:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fs5DpJ0c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgGMTZ2 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 15:25:28 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51076 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726356AbgGMTZ2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Jul 2020 15:25:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594668326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rRhJgNvHHQvMIJx8hF1PJiPE5xtzX3zPhFxWDzfe6VM=;
        b=Fs5DpJ0ctrKjXHASov/It2FwBHc3eMM722DyntEr1Cr2J6EMyAOUcsc9qhqgCdr+kxoxZk
        ZG9NGK5f6PMBoeFPWuBP8vN+aqH8R7MWuDb0O85MNt1H2czR1JLit4X/n3wbLqOjwJKh7U
        RdGmx+2B/vsDwqdJHQee9RnNedBnjWQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-5lk2pRkYMF6QYsigznBD3g-1; Mon, 13 Jul 2020 15:25:21 -0400
X-MC-Unique: 5lk2pRkYMF6QYsigznBD3g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 920AD184C608;
        Mon, 13 Jul 2020 19:25:18 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-117.rdu2.redhat.com [10.10.116.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62B3879251;
        Mon, 13 Jul 2020 19:25:18 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id E3A8E2237D7; Mon, 13 Jul 2020 15:25:17 -0400 (EDT)
Date:   Mon, 13 Jul 2020 15:25:17 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Josh England <jjengla@gmail.com>, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH RFC 1/2] ovl: invalidate dentry with deleted real dir
Message-ID: <20200713192517.GA286591@redhat.com>
References: <20200713105732.2886-1-amir73il@gmail.com>
 <20200713105732.2886-2-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713105732.2886-2-amir73il@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 13, 2020 at 01:57:31PM +0300, Amir Goldstein wrote:
> Changes to underlying layers while overlay in mounted result in
> undefined behavior.  Therefore, we can change the behavior to
> invalidate the overlay dentry on dcache lookup if one of the
> underlying dentries was deleted since the dentry was composed.
> 
> Negative underlying dentries are not expected in overlay upper and
> lower dentries.  If they are found it is probably dcache lookup racing
> with an overlay unlink, before d_drop() was called on the overlay dentry.
> IS_DEADDIR directories may be caused by underlying rmdir, so invalidate
> overlay dentry on dcache lookup if we find those.

Can you elaborate a bit more on this race. Doesn't inode_lock_nested(dir)
protect against that. I see that both vfs_rmdir() and vfs_unlink()
happen with parent directory inode mutex held exclusively. And IIUC,
that should mean no further lookup()/->revalidate() must be in progress
on that dentry? I might very well be wrong, hence asking for more
details.

Thanks
Vivek

> 
> We preserve the legacy behaior of returning -ESTALE on invalid cache
> for lower dentries, but we relax this behavior for upper dentries
> that may be invalidated by a race with overlay unlink/rmdir.
> 
> This doesn't make live changes to underlying layers valid, because
> invalid dentry stacks may still be referenced by open files, but it
> reduces the window for possible bugs caused by underlying delete,
> because lookup cannot return those invalid dentry stacks.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/super.c | 41 +++++++++++++++++++++++++++++++----------
>  1 file changed, 31 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 06ec3cb977e6..f2c74387e05b 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -113,21 +113,42 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
>  	return dentry;
>  }
>  
> -static int ovl_revalidate_real(struct dentry *d, unsigned int flags, bool weak)
> +static bool ovl_dentry_is_dead(struct dentry *d)
>  {
> +	return unlikely(!d->d_inode || IS_DEADDIR(d->d_inode));
> +}
> +
> +static int ovl_revalidate_real(struct dentry *d, unsigned int flags, bool weak,
> +			       bool is_upper)
> +{
> +	bool strict = !weak;
>  	int ret = 1;
>  
> -	if (weak) {
> +	/* Invalidate dentry if real was deleted since we found it */
> +	if (ovl_dentry_is_dead(d)) {
> +		ret = 0;
> +		/* Raced with overlay unlink/rmdir? */
> +		if (is_upper)
> +			strict = false;

> +	} else if (weak) {
>  		if (d->d_flags & DCACHE_OP_WEAK_REVALIDATE)
> -			ret =  d->d_op->d_weak_revalidate(d, flags);
> +			ret = d->d_op->d_weak_revalidate(d, flags);
>  	} else if (d->d_flags & DCACHE_OP_REVALIDATE) {
>  		ret = d->d_op->d_revalidate(d, flags);
> -		if (!ret) {
> -			if (!(flags & LOOKUP_RCU))
> -				d_invalidate(d);
> -			ret = -ESTALE;
> -		}
>  	}
> +
> +	/*
> +	 * Legacy overlayfs strict behavior is to return an error to user on
> +	 * non-weak revalidate rather than retry the lookup, because underlying
> +	 * layer changes are not expected. We may want to relax this in the
> +	 * future either for upper only or also for lower.
> +	 */
> +	if (strict && !ret) {
> +		if (!(flags & LOOKUP_RCU))
> +			d_invalidate(d);
> +		ret = -ESTALE;
> +	}
> +
>  	return ret;
>  }
>  
> @@ -141,11 +162,11 @@ static int ovl_dentry_revalidate_common(struct dentry *dentry,
>  
>  	upper = ovl_dentry_upper(dentry);
>  	if (upper)
> -		ret = ovl_revalidate_real(upper, flags, weak);
> +		ret = ovl_revalidate_real(upper, flags, weak, true);
>  
>  	for (i = 0; ret > 0 && i < oe->numlower; i++) {
>  		ret = ovl_revalidate_real(oe->lowerstack[i].dentry, flags,
> -					  weak);
> +					  weak, false);
>  	}
>  	return ret;
>  }
> -- 
> 2.17.1
> 

