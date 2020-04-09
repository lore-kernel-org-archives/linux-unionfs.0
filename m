Return-Path: <SRS0=VDYA=5Z=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66375C2BA19
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Apr 2020 21:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DF6E2072F
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Apr 2020 21:49:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ft0wUZgn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgDIVtc (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 17:49:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25723 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726666AbgDIVtc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Apr 2020 17:49:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586468970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EBdu4RILO5C4gOvAVs4zNXrstIlJgaELpoZ81tyGkLE=;
        b=Ft0wUZgnpsups/l03F/5zN9PCGZvx0fBkYCefOQTs4kwWvkZR7rwo1eQgXcoWe6iLvHe2l
        EgZW91U34sL2NUXJrLSIllBrpmF4oz/Xat0W+2b9uqT+7y0ZLiI1Z8OTKGnAuFPY7/gIZ0
        YAtJ1mx65FsgHnfEFmNm+Ly9O6VnxIU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-1v13eE59NhC37YVbmIl1-g-1; Thu, 09 Apr 2020 17:49:28 -0400
X-MC-Unique: 1v13eE59NhC37YVbmIl1-g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD49F1402;
        Thu,  9 Apr 2020 21:49:27 +0000 (UTC)
Received: from horse.redhat.com (ovpn-114-247.rdu2.redhat.com [10.10.114.247])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A667610013A1;
        Thu,  9 Apr 2020 21:49:26 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 2A7942202B8; Thu,  9 Apr 2020 17:49:26 -0400 (EDT)
Date:   Thu, 9 Apr 2020 17:49:26 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Chengguang Xu <cgxu519@mykernel.net>,
        linux-unionfs@vger.kernel.org
Subject: Re: [PATCH] ovl: resolve more conflicting mount options
Message-ID: <20200409214926.GA144134@redhat.com>
References: <20200409163902.11404-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200409163902.11404-1-amir73il@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 09, 2020 at 07:39:02PM +0300, Amir Goldstein wrote:
> Similar to the way that a conflict between metacopy=on,redirect_dir=off
> is resolved, also resolve conflicts between nfs_export=on,index=off and
> nfs_export=on,metacopy=on.
> 
> An explicit mount option wins over a default config value.
> Both explicit mount options result in an error.
> 
> Without this change the xfstests group overlay/exportfs are skipped if
> metacopy is enabled by default.
> 
> Reported-by: Chengguang Xu <cgxu519@mykernel.net>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  Documentation/filesystems/overlayfs.rst |  7 ++--
>  fs/overlayfs/super.c                    | 48 +++++++++++++++++++++++++
>  2 files changed, 53 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
> index c9d2bf96b02d..660dbaf0b9b8 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -365,8 +365,8 @@ pointed by REDIRECT. This should not be possible on local system as setting
>  "trusted." xattrs will require CAP_SYS_ADMIN. But it should be possible
>  for untrusted layers like from a pen drive.
>  
> -Note: redirect_dir={off|nofollow|follow[*]} conflicts with metacopy=on, and
> -results in an error.
> +Note: redirect_dir={off|nofollow|follow[*]} and nfs_export=on mount options
> +conflict with metacopy=on, and will result in an error.
>  
>  [*] redirect_dir=follow only conflicts with metacopy=on if upperdir=... is
>  given.
> @@ -560,6 +560,9 @@ When the NFS export feature is enabled, all directory index entries are
>  verified on mount time to check that upper file handles are not stale.
>  This verification may cause significant overhead in some cases.
>  
> +Note: the mount options index=off,nfs_export=on are conflicting and will
> +result in an error.
> +
>  
>  Testsuite
>  ---------
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 732ad5495c92..fbd6207acdbf 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -470,6 +470,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>  	char *p;
>  	int err;
>  	bool metacopy_opt = false, redirect_opt = false;
> +	bool nfs_export_opt = false, index_opt = false;
>  
>  	config->redirect_mode = kstrdup(ovl_redirect_mode_def(), GFP_KERNEL);
>  	if (!config->redirect_mode)
> @@ -519,18 +520,22 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>  
>  		case OPT_INDEX_ON:
>  			config->index = true;
> +			index_opt = true;
>  			break;
>  
>  		case OPT_INDEX_OFF:
>  			config->index = false;
> +			index_opt = true;
>  			break;
>  
>  		case OPT_NFS_EXPORT_ON:
>  			config->nfs_export = true;
> +			nfs_export_opt = true;
>  			break;
>  
>  		case OPT_NFS_EXPORT_OFF:
>  			config->nfs_export = false;
> +			nfs_export_opt = true;
>  			break;
>  
>  		case OPT_XINO_ON:
> @@ -552,6 +557,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>  
>  		case OPT_METACOPY_OFF:
>  			config->metacopy = false;
> +			metacopy_opt = true;

Hi Amir,

I am wondering why metacopy_opt needs to be set for OPT_METACOPY_OFF case.
In this case config->metacopy=false and it does not conflict with
config->nfs_export at all. So there is no need to know if metacopy=off
was specified as mount option or not.

Vivek

>  			break;
>  
>  		default:
> @@ -601,6 +607,48 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>  		}
>  	}
>  
> +	/* Resolve nfs_export -> index dependency */
> +	if (config->nfs_export && !config->index) {
> +		if (nfs_export_opt && index_opt) {
> +			pr_err("conflicting options: nfs_export=on,index=off\n");
> +			return -EINVAL;
> +		}
> +		if (index_opt) {
> +			/*
> +			 * There was an explicit index=off that resulted
> +			 * in this conflict.
> +			 */
> +			pr_info("disabling nfs_export due to index=off\n");
> +			config->nfs_export = false;
> +		} else {
> +			/* Automatically enable index otherwise. */
> +			config->index = true;
> +		}
> +	}
> +
> +	/* Resolve nfs_export -> !metacopy dependency */
> +	if (config->nfs_export && config->metacopy) {
> +		if (nfs_export_opt && metacopy_opt) {
> +			pr_err("conflicting options: nfs_export=on,metacopy=on\n");
> +			return -EINVAL;
> +		}
> +		if (metacopy_opt) {
> +			/*
> +			 * There was an explicit metacopy=on that resulted
> +			 * in this conflict.
> +			 */
> +			pr_info("disabling nfs_export due to metacopy=on\n");
> +			config->nfs_export = false;
> +		} else {
> +			/*
> +			 * There was an explicit nfs_export=on that resulted
> +			 * in this conflict.
> +			 */
> +			pr_info("disabling metacopy due to nfs_export=on\n");
> +			config->metacopy = false;
> +		}
> +	}
> +
>  	return 0;
>  }
>  
> -- 
> 2.17.1
> 

