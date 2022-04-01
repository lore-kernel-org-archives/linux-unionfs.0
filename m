Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3036C433F5
	for <linux-unionfs@archiver.kernel.org>; Fri,  1 Apr 2022 20:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346513AbiDAUTP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 1 Apr 2022 16:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240033AbiDAUTO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 1 Apr 2022 16:19:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BBA102706E7
        for <linux-unionfs@vger.kernel.org>; Fri,  1 Apr 2022 13:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648844243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UF4Hgkl4055+Oo5a2aXAdzLbtK0PwfDMvnscp3phYmA=;
        b=Vl0kXxRC/gJICBs0O2rFeOX6R6nL6oDko1LZSXLOErFtDRV23ZKyd5hWdQfOVp8SwzR18G
        FCKZo1nWxyy/XFEWG9piDoBr7Y7862THFaus8+aiehGtm7ZxgReB19DV1izF2nQksADI+B
        vhbguVLzsWAkHXFWN0JKMubWLL/OUdk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-6_K47eCoPTCgrM3mRBY1pQ-1; Fri, 01 Apr 2022 16:17:22 -0400
X-MC-Unique: 6_K47eCoPTCgrM3mRBY1pQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D59593804522;
        Fri,  1 Apr 2022 20:17:20 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.22.32.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8AF74432897;
        Fri,  1 Apr 2022 20:17:15 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id F3488220EFF; Fri,  1 Apr 2022 16:17:13 -0400 (EDT)
Date:   Fri, 1 Apr 2022 16:17:13 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Christoph Hellwig <hch@lst.de>, linux-unionfs@vger.kernel.org,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigo@sdfg.com.ar>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>
Subject: Re: [PATCH v3 19/19] ovl: support idmapped layers
Message-ID: <YkddyaCtRdTRPtpL@redhat.com>
References: <20220331112318.1377494-1-brauner@kernel.org>
 <20220331112318.1377494-20-brauner@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331112318.1377494-20-brauner@kernel.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Mar 31, 2022 at 01:23:17PM +0200, Christian Brauner wrote:
> Now that overlay is able to take a layers idmapping into account allow
> overlay mounts to be created on top of idmapped mounts.
> 
> Cc: <linux-unionfs@vger.kernel.org>
> Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> ---
> /* v2 */
> - Turn on support for idmapped mounts in ovl_upper_idmap() helper here
>   after we've introduced it earlier in the series and made it return the
>   initial idmapping.
> 
> /* v3 */
> unchanged
> ---
>  fs/overlayfs/ovl_entry.h | 2 +-
>  fs/overlayfs/super.c     | 4 ----
>  2 files changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 79b612cfbe52..898b002a5c6f 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -92,7 +92,7 @@ static inline struct vfsmount *ovl_upper_mnt(struct ovl_fs *ofs)
>  
>  static inline struct user_namespace *ovl_upper_idmap(struct ovl_fs *ofs)

Same minor nit here. Will ovl_upper_mnt_userns() be better for
readability. If it is too long, may be ovl_upper_mnt_uns().

I have this general comment here and other places
where "idmap" has been used. "idmap" is just one property vfs
derives from user namespace associated with mnt.

Vivek

>  {
> -       return &init_user_ns;
> +	return mnt_user_ns(ovl_upper_mnt(ofs));
>  }
>  
>  static inline struct ovl_fs *OVL_FS(struct super_block *sb)
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 9a656a24f7b1..d4cc07f7a2ef 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -874,10 +874,6 @@ static int ovl_mount_dir_noesc(const char *name, struct path *path)
>  		pr_err("filesystem on '%s' not supported\n", name);
>  		goto out_put;
>  	}
> -	if (is_idmapped_mnt(path->mnt)) {
> -		pr_err("idmapped layers are currently not supported\n");
> -		goto out_put;
> -	}
>  	if (!d_is_dir(path->dentry)) {
>  		pr_err("'%s' not a directory\n", name);
>  		goto out_put;
> -- 
> 2.32.0
> 

