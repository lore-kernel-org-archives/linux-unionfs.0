Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3246C433DB
	for <linux-unionfs@archiver.kernel.org>; Tue,  9 Mar 2021 18:46:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B77716522A
	for <linux-unionfs@archiver.kernel.org>; Tue,  9 Mar 2021 18:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhCISqS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 13:46:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28923 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229904AbhCISpw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Mar 2021 13:45:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615315551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DXzYQho/NfxIsdih9PUU7rn8wEluvEQbR3vAwVIzXmI=;
        b=OCYkfmVVkSeOygk88Bx1wv9lPCck3l28PI/gTRsHzAcevoxeH74yy1R+LnvOXT2TeghFZ3
        6WvKVSim8qNt8IOEobnlYsDKgEfOupGgUYnNynP1kFvAE6aomz6SlRYNvzld04KXb2bB7F
        pQ6ZsVWLkTN72Kj16DvevzX66+/qbgA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278--1ho_Ct_MfGQF20uwI8rgg-1; Tue, 09 Mar 2021 13:45:49 -0500
X-MC-Unique: -1ho_Ct_MfGQF20uwI8rgg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9B0A800D62;
        Tue,  9 Mar 2021 18:45:48 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-126.rdu2.redhat.com [10.10.115.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CAC335D9DB;
        Tue,  9 Mar 2021 18:45:48 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 60E4B22054F; Tue,  9 Mar 2021 13:45:48 -0500 (EST)
Date:   Tue, 9 Mar 2021 13:45:48 -0500
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Giuseppe Scrivano <gscrivan@redhat.com>
Cc:     linux-unionfs@vger.kernel.org, miklos@szeredi.hu
Subject: Re: [PATCH] overlay: show "userxattr" in the mount data
Message-ID: <20210309184548.GH77194@redhat.com>
References: <20210304164515.3735726-1-gscrivan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210304164515.3735726-1-gscrivan@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Mar 04, 2021 at 05:45:15PM +0100, Giuseppe Scrivano wrote:
> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>

Minor nit: I am not sure if subject only patch is allowed. I would expect
           couple of lines in patch description too.

Otherwise looks good to me.

Reviewed-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  fs/overlayfs/super.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index fdd72f1a9c5e..d16120d63240 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -380,6 +380,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>  			   ofs->config.metacopy ? "on" : "off");
>  	if (ofs->config.ovl_volatile)
>  		seq_puts(m, ",volatile");
> +	if (ofs->config.userxattr)
> +		seq_puts(m, ",userxattr");
>  	return 0;
>  }
>  
> -- 
> 2.29.2
> 

