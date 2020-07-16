Return-Path: <SRS0=UrPG=A3=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E7EC433E3
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Jul 2020 13:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3589D2074B
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Jul 2020 13:22:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZBq4BXAc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgGPNW2 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 09:22:28 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:50338 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727044AbgGPNW1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Jul 2020 09:22:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594905746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VYQ3P4Qmt9yiO1Oqv3ZgBkO8+VeoHrsbGfSYDAVsJiA=;
        b=ZBq4BXAcAzkoCQ4rko8TitR6U5nmnAm8NMixSZTrai4stdpeV2nKtibHVbDyr7JFVzXhhM
        yoqRsg8OWxaLY/NgsoyfTVsKLpoEOA4lF8wqe+n5/lq5UZkniRHyV9VYdUlTDWDkSFAaup
        HJ1vN8+fmw9rZBGTHlZsRW6YYYFeOwg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-6DjtKoWlPHue2OzvJCBiJw-1; Thu, 16 Jul 2020 09:22:23 -0400
X-MC-Unique: 6DjtKoWlPHue2OzvJCBiJw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C66318015FB;
        Thu, 16 Jul 2020 13:22:21 +0000 (UTC)
Received: from horse.redhat.com (ovpn-114-241.rdu2.redhat.com [10.10.114.241])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6ABD360C47;
        Thu, 16 Jul 2020 13:22:21 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 0788F225777; Thu, 16 Jul 2020 09:22:20 -0400 (EDT)
Date:   Thu, 16 Jul 2020 09:22:20 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH] ovl: fix lookup of indexed hardlinks with metacopy
Message-ID: <20200716132220.GA422759@redhat.com>
References: <20200715133808.7146-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715133808.7146-1-amir73il@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jul 15, 2020 at 04:38:08PM +0300, Amir Goldstein wrote:
> We recently moved setting inode flag OVL_UPPERDATA to ovl_lookup().
> 
> When looking up an overlay dentry, upperdentry may be found by index
> and not by name.  In that case, we fail to read the metacopy xattr
> and falsly set the OVL_UPPERDATA on the overlay inode.
> 
> This caused a regression in xfstest overlay/033 when run with
> OVERLAY_MOUNT_OPTIONS="-o metacopy=on".
> 
> Fixes: 28166ab3c875 ("ovl: initialize OVL_UPPERDATA in ovl_lookup()")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Reviewed-by: Vivek Goyal <vgoyal@redhat.com>

Good catch Amir. Thanks.


> ---
> 
> Miklos,
> 
> I just ran xfstests -g overlay/quick tests with metacopy enabled
> and one test failed.
> 
> Vivek,
> 
> Do you by any chance run this sort of test regularly?

No I don't. I will start testing this configuration. Actually I don't
have any automated setup and all the testing I do manually. I think
its time that atleast I have a script which runs bunch of tests
always.

> 
> You have asked about running unionmount tests with metacopy before.
> I just pushed a commit to my xfstests 'unionmount' branch:
>   7859f22b ovl: test unionmount tests with metacopy
> 
> It allows you to run xfstests -g overlay/union with
> OVERLAY_MOUNT_OPTIONS="-o metacopy=on", to excercise all the unionmount
> test configurations I created with metacopy enabled.

Nice, I will check it out. Will be nice if this gets pushed to
xfstest tree.

Thanks
Vivek

> 
> Maybe not so surprising that the sub-group overlay/union.nested tests
> fail with metacopy enabled. This is just a test setup bug and I pushed
> a fix commit to unionmount overlayfs-devel branch to fix it.
> 
> Thanks,
> Amir.
> 
>  fs/overlayfs/namei.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 3566282a9199..0c5a624600c1 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -1073,6 +1073,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>  			upperredirect = NULL;
>  			goto out_free_oe;
>  		}
> +		err = ovl_check_metacopy_xattr(upperdentry);
> +		if (err < 0)
> +			goto out_free_oe;
> +		uppermetacopy = err;
>  	}
>  
>  	if (upperdentry || ctr) {
> -- 
> 2.17.1
> 

