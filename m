Return-Path: <SRS0=S/H/=7P=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61FBDC433E0
	for <linux-unionfs@archiver.kernel.org>; Tue,  2 Jun 2020 18:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EF542072F
	for <linux-unionfs@archiver.kernel.org>; Tue,  2 Jun 2020 18:39:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RYptHF3M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgFBSj3 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 14:39:29 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38561 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726162AbgFBSj2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 2 Jun 2020 14:39:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591123167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cm11EAcO7VdJtFVbPSig9gscpPnGoWqXtkpeqlkDfVg=;
        b=RYptHF3M/iE0oAS6eXWuMpcmBPwIuRRIhLGu238AQxwj36QZyWFlweEIcu28uqra+9lxvp
        QEOoE845nbnz+rVkjdN+eQgGYE6nmGbEjMV+KWlkSYsEXYIRvdI1FiExmZcQsaj6P9+cY3
        4GsuNJ31Ga3O14cfcv+iVMdvUkLX2tU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-NmQHe6IyNwSXYuuykiK4fA-1; Tue, 02 Jun 2020 14:39:22 -0400
X-MC-Unique: NmQHe6IyNwSXYuuykiK4fA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C2F2835B44;
        Tue,  2 Jun 2020 18:39:21 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-130.rdu2.redhat.com [10.10.116.130])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FFD5D021C;
        Tue,  2 Jun 2020 18:39:21 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id D5E8322063B; Tue,  2 Jun 2020 14:39:20 -0400 (EDT)
Date:   Tue, 2 Jun 2020 14:39:20 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     amir73il@gmail.com, miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org
Subject: Re: [PATCH] overlayfs: Fix redirect traversal on metacopy dentries
Message-ID: <20200602183920.GC3311@redhat.com>
References: <20200602152338.GA3311@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602152338.GA3311@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 02, 2020 at 11:23:38AM -0400, Vivek Goyal wrote:
> Amir pointed me to metacopy test cases in unionmount-testsuite and
> I decided to run "./run --ov=10 --meta" and it failed while running
> test "rename-mass-5.py".

Hi Miklos,

This patch applies on top of the patch series I posted previously.

https://marc.info/?l=linux-unionfs&m=159102703820108&w=2

Thanks
Vivek

> 
> Problem is w.r.t absolute redirect traversal on intermediate metacopy
> dentry. We do not store intermediate metacopy dentries and also skip
> current loop/layer and move onto lookup in next layer. But at the end
> of loop, we have logic to reset "poe" and layer index if currnently
> looked up dentry has absolute redirect. We skip all that and that
> means lookup in next layer will fail.
> 
> Following is simple test case to reproduce this.
> 
> - mkdir -p lower upper work merged lower/a lower/b
> - touch lower/a/foo.txt
> - mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=work,metacopy=on none merged
> 
> # Following will create absolute redirect "/a/foo.txt" on upper/b/bar.txt.
> - mv merged/a/foo.txt merged/b/bar.txt
> 
> # unmount overlay and use upper as lower layer (lower2) for next mount.
> - umount merged
> - mv upper lower2
> - rm -rf work; mkdir -p upper work
> - mount -t overlay -o lowerdir=lower2:lower,upperdir=upper,workdir=work,metacopy=on none merged
> 
> # Force a metacopy copy-up
> - chown bin:bin merged/b/bar.txt
> 
> # unmount overlay and use upper as lower layer (lower3) for next mount.
> - umount merged
> - mv upper lower3
> - rm -rf work; mkdir -p upper work
> - mount -t overlay -o lowerdir=lower3:lower2:lower,upperdir=upper,workdir=work,metacopy=on none merged
> 
> # ls merged/b/bar.txt
> ls: cannot access 'bar.txt': Input/output error
> 
> Intermediate lower layer (lower2) has metacopy dentry b/bar.txt with absolute
> redirect "/a/foo.txt". We skipped redirect processing at the end of loop
> which sets poe to roe and sets the appropriate next lower layer index. And
> that means lookup failed in next layer.
> 
> Fix this by continuing the loop for any intermediate dentries. We still do not
> save these at lower stack. With this fix applied unionmount-testsuite,
> "./run --ov-10 --meta" now passes.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/namei.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index da05e33db9ce..df81ec0e179f 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -913,15 +913,6 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>  			goto out_put;
>  		}
>  
> -		/*
> -		 * Do not store intermediate metacopy dentries in chain,
> -		 * except top most lower metacopy dentry
> -		 */
> -		if (d.metacopy && ctr) {
> -			dput(this);
> -			continue;
> -		}
> -
>  		/*
>  		 * If no origin fh is stored in upper of a merge dir, store fh
>  		 * of lower dir and set upper parent "impure".
> @@ -956,9 +947,20 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>  			origin = this;
>  		}
>  
> -		stack[ctr].dentry = this;
> -		stack[ctr].layer = lower.layer;
> -		ctr++;
> +		if (d.metacopy && ctr) {
> +			/*
> +			 * Do not store intermediate metacopy dentries in
> +			 * lower chain, except top most lower metacopy dentry.
> +			 * Continue the loop so that if there is an absolute
> +			 * redirect on this dentry, poe can be reset to roe.
> +			 */
> +			dput(this);
> +			this = NULL;
> +		} else {
> +			stack[ctr].dentry = this;
> +			stack[ctr].layer = lower.layer;
> +			ctr++;
> +		}
>  
>  		/*
>  		 * Following redirects can have security consequences: it's like
> -- 
> 2.25.4
> 

