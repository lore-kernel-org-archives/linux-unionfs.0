Return-Path: <SRS0=Lx5L=AZ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA5CC433E2
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 18:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C056222838
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 18:18:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NTYplmHf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgGNSSL (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 14:18:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51042 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727772AbgGNSSK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Jul 2020 14:18:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594750689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CCtE2YoglMEGexO4/1q8MbbNrKGsfAXp2nyR/hterfk=;
        b=NTYplmHf1IKlRkpCvHJFa/KTX+M1r95eC4zwhDB8eCjpjqDEN582nCPQpJ8w2n5DZccYju
        9w2rNIILhhh4oVTnOnF9PStVY0eIbYDkQy91CKEMwM2iK2kLaTvls20X+2EC09ChlIV7Ju
        eiQ3zwalca+kVavZ5LgilSzq6tREeIE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-QYBPGkeDOo6m5H2WkNiG-g-1; Tue, 14 Jul 2020 14:18:05 -0400
X-MC-Unique: QYBPGkeDOo6m5H2WkNiG-g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFD76800C64;
        Tue, 14 Jul 2020 18:18:04 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-205.rdu2.redhat.com [10.10.115.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B456F7980F;
        Tue, 14 Jul 2020 18:18:04 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 4333E2237D7; Tue, 14 Jul 2020 14:18:04 -0400 (EDT)
Date:   Tue, 14 Jul 2020 14:18:04 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH 1/3] ovl: force read-only sb on failure to create index
 dir
Message-ID: <20200714181804.GF324688@redhat.com>
References: <20200713141945.11719-1-amir73il@gmail.com>
 <20200713141945.11719-2-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713141945.11719-2-amir73il@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 13, 2020 at 05:19:43PM +0300, Amir Goldstein wrote:
> With index feature enabled, on failure to create index dir, overlay
> is being mounted read-only.  However, we do not forbid user to remount
> overlay read-write.  Fix that by setting ofs->workdir to NULL, which
> prevents remount read-write.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

This patch does not apply for me. What branch you have generated it
against. I am using 5.8-rc4.

Vivek

> ---
>  fs/overlayfs/super.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 4b7cb2d98203..41d7fe2b8129 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1374,12 +1374,13 @@ static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
>  		goto out;
>  	}
>  
> +	/* index dir will act also as workdir */
> +	iput(ofs->workdir_trap);
> +	ofs->workdir_trap = NULL;
> +	dput(ofs->workdir);
> +	ofs->workdir = NULL;
>  	ofs->indexdir = ovl_workdir_create(ofs, OVL_INDEXDIR_NAME, true);
>  	if (ofs->indexdir) {
> -		/* index dir will act also as workdir */
> -		iput(ofs->workdir_trap);
> -		ofs->workdir_trap = NULL;
> -		dput(ofs->workdir);
>  		ofs->workdir = dget(ofs->indexdir);
>  
>  		err = ovl_setup_trap(sb, ofs->indexdir, &ofs->indexdir_trap,
> @@ -1884,7 +1885,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>  	if (!ovl_upper_mnt(ofs))
>  		sb->s_flags |= SB_RDONLY;
>  
> -	if (!(ovl_force_readonly(ofs)) && ofs->config.index) {
> +	if (!ovl_force_readonly(ofs) && ofs->config.index) {
>  		err = ovl_get_indexdir(sb, ofs, oe, &upperpath);
>  		if (err)
>  			goto out_free_oe;
> -- 
> 2.17.1
> 

