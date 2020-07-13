Return-Path: <SRS0=r5kD=AY=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEBB5C433E2
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Jul 2020 20:05:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC12820674
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Jul 2020 20:05:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PZyUlBSC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgGMUFS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 16:05:18 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29785 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726318AbgGMUFS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Jul 2020 16:05:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594670716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/vtfQsCCFFEjQ+5YpMppRDvhzEWrL+G8dFFmx0Lgt3I=;
        b=PZyUlBSCTEHjfyxhvtk5nXjcyV+VO8KhCxjOaYCw5StMobSdwsfEGwafq26Aci8rltbLpB
        RWv/irVk+lM2inYOOfWK34ra9rKA5TpQAQNOpeGxn3nY0JIBVLZC+tClvUxd4vFud0oajg
        oVbvsQvtPMjWhK2NMY/UGnrEtc880Vs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221--Z59FWekPmaEBEBJwWJ5Aw-1; Mon, 13 Jul 2020 16:05:14 -0400
X-MC-Unique: -Z59FWekPmaEBEBJwWJ5Aw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1A43100CD09;
        Mon, 13 Jul 2020 20:05:12 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-117.rdu2.redhat.com [10.10.116.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 727FE27CCB;
        Mon, 13 Jul 2020 20:05:12 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 0C49E2237D7; Mon, 13 Jul 2020 16:05:12 -0400 (EDT)
Date:   Mon, 13 Jul 2020 16:05:11 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Josh England <jjengla@gmail.com>, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] ovl: invalidate dentry if lower was renamed
Message-ID: <20200713200511.GB286591@redhat.com>
References: <20200713105732.2886-1-amir73il@gmail.com>
 <20200713105732.2886-3-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713105732.2886-3-amir73il@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 13, 2020 at 01:57:32PM +0300, Amir Goldstein wrote:
> Changes to lower layer while overlay in mounted result in undefined
> behavior.  Therefore, we can change the behavior to invalidate the
> overlay dentry on dcache lookup if one of the dentries in the lowerstack
> was renamed since the lowerstack was composed.
> 
> To be absolute certain that lower dentry was not renamed we would need to
> know the redirect path that lead to it, but that is not necessary.
> Instead, we just store the hash of the parent/name from when we composed
> the stack, which gives a good enough probablity to detect a lower rename
> and is much less complexity.
> 
> We do not provide this protection for upper dentries, because that would
> require updating the hash on overlay initiated renames and that is harder
> to implement with lockless lookup.
> 
> This doesn't make live changes to underlying layers valid, because
> invalid dentry stacks may still be referenced by open files, but it
> reduces the window for possible bugs caused by lower rename, because
> lookup cannot return those invalid dentry stacks.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/export.c    |  1 +
>  fs/overlayfs/namei.c     |  4 +++-
>  fs/overlayfs/ovl_entry.h |  2 ++
>  fs/overlayfs/super.c     | 17 ++++++++++-------
>  4 files changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index 0e696f72cf65..7221b6226e26 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -319,6 +319,7 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
>  	if (lower) {
>  		oe->lowerstack->dentry = dget(lower);
>  		oe->lowerstack->layer = lowerpath->layer;
> +		oe->lowerstack->hash = lower->d_name.hash_len;
>  	}
>  	dentry->d_fsdata = oe;
>  	if (upper_alias)
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 3566282a9199..ae1c1216a038 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -375,7 +375,8 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
>  	}
>  	**stackp = (struct ovl_path){
>  		.dentry = origin,
> -		.layer = &ofs->layers[i]
> +		.layer = &ofs->layers[i],
> +		.hash = origin->d_name.hash_len,
>  	};
>  
>  	return 0;
> @@ -968,6 +969,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>  		} else {
>  			stack[ctr].dentry = this;
>  			stack[ctr].layer = lower.layer;
> +			stack[ctr].hash = this->d_name.hash_len;
>  			ctr++;
>  		}
>  
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index b429c80879ee..557f1782f53b 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -42,6 +42,8 @@ struct ovl_layer {
>  struct ovl_path {
>  	const struct ovl_layer *layer;
>  	struct dentry *dentry;
> +	/* Hash of the lower parent/name when we found it */
> +	u64 hash;
>  };
>  
>  /* private information held for overlayfs's superblock */
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index f2c74387e05b..4b7cb2d98203 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -119,13 +119,13 @@ static bool ovl_dentry_is_dead(struct dentry *d)
>  }
>  
>  static int ovl_revalidate_real(struct dentry *d, unsigned int flags, bool weak,
> -			       bool is_upper)
> +			       bool is_upper, u64 hash)
>  {
>  	bool strict = !weak;
>  	int ret = 1;
>  
> -	/* Invalidate dentry if real was deleted since we found it */
> -	if (ovl_dentry_is_dead(d)) {
> +	/* Invalidate dentry if real was deleted/renamed since we found it */
> +	if (ovl_dentry_is_dead(d) || (hash && hash != d->d_name.hash_len)) {

So if lower hash_len changes, on local filesystem we will return -ESTALE?
I am assuming we did that for remote filesystems and now we will do
that for local filesystems as well?

Thanks
Vivek

>  		ret = 0;
>  		/* Raced with overlay unlink/rmdir? */
>  		if (is_upper)
> @@ -156,17 +156,18 @@ static int ovl_dentry_revalidate_common(struct dentry *dentry,
>  					unsigned int flags, bool weak)
>  {
>  	struct ovl_entry *oe = dentry->d_fsdata;
> +	struct ovl_path *lower = oe->lowerstack;
>  	struct dentry *upper;
>  	unsigned int i;
>  	int ret = 1;
>  
>  	upper = ovl_dentry_upper(dentry);
>  	if (upper)
> -		ret = ovl_revalidate_real(upper, flags, weak, true);
> +		ret = ovl_revalidate_real(upper, flags, weak, true, 0);
>  
> -	for (i = 0; ret > 0 && i < oe->numlower; i++) {
> -		ret = ovl_revalidate_real(oe->lowerstack[i].dentry, flags,
> -					  weak, false);
> +	for (i = 0; ret > 0 && i < oe->numlower; i++, lower++) {
> +		ret = ovl_revalidate_real(lower->dentry, flags, weak, false,
> +					  lower->hash);
>  	}
>  	return ret;
>  }
> @@ -1652,6 +1653,8 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
>  	for (i = 0; i < numlower; i++) {
>  		oe->lowerstack[i].dentry = dget(stack[i].dentry);
>  		oe->lowerstack[i].layer = &ofs->layers[i+1];
> +		/* layer root should not be invalidated by rename */
> +		oe->lowerstack->hash = 0;
>  	}
>  
>  out:
> -- 
> 2.17.1
> 

