Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEDBCE7E649
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 Sep 2023 15:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbjIZPY3 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 11:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbjIZPY1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 26 Sep 2023 11:24:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D8E11F
        for <linux-unionfs@vger.kernel.org>; Tue, 26 Sep 2023 08:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695741814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=foWM0UugyLFv9pmPiACjZ0qxG3GLmlHlix6zXFIpKKE=;
        b=FFn9H8RNQ30Odb7cRaRAcYdejnV0nsY8OdfUjY7CAoCj6AYztexRWMATmHWmFTmfQ+h1fC
        Du15PiPEwte3PkMG5bGcwwrwWY2pq5TTzV5FInwbPsLZ9oG/F8Jzw/ijMrGj2jadf7YQgW
        1nD/+/TRVfDgMLYtYhXC1GXVrMmp7U8=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-iI3Zl3jzPVOCNIh73cwc-A-1; Tue, 26 Sep 2023 11:23:33 -0400
X-MC-Unique: iI3Zl3jzPVOCNIh73cwc-A-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-692c0c3bcc5so7100527b3a.3
        for <linux-unionfs@vger.kernel.org>; Tue, 26 Sep 2023 08:23:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695741812; x=1696346612;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=foWM0UugyLFv9pmPiACjZ0qxG3GLmlHlix6zXFIpKKE=;
        b=OtWccd9eEetLW6WMyc6ulbisU9bwAe4/48cl91bJr54lOlqdWWBh+U4n4xMjF57vBy
         dXebhyUKObqr5NdsDveXz4Mwq1kZRv0bg2MpihI5LeDXg8dF3ZajPLDxHzOfHYckgvbx
         oCVBBo7NM40FPwf6aAAZujb1btYxo/nHmyqvy7PPp3TRcBl+NbkbhnzvmX7IYWAMrGVl
         8Q0cQFTwpbRoatwBkUSiximHSyCS6NV5jKbpF1do9sR7aQnurIPQ9QGEaCPCBcfl9+Su
         Cz59y21VMWN+Yugrp0gPlPuz/mc24kkb6AiPp9hYRP+Cq5552nAOpBxKE4EX2eGK0RwL
         D1YQ==
X-Gm-Message-State: AOJu0YwI/QTLqqF/isuQ24H05tNr4ubNBCt4SXykx8nM51a0Ir3qZaFj
        oc9FMR0fJaRZo65/dP1ztVid9Cfcz05XskSyqJOcplxoGy8F6ySXUsZru+evEy8Tc6wuwu2QPTA
        Tz4mGXgkcNaI6BQ/C3T/rEUs3BQ==
X-Received: by 2002:a05:6a20:101a:b0:14b:3681:567e with SMTP id gs26-20020a056a20101a00b0014b3681567emr7100135pzc.29.1695741812050;
        Tue, 26 Sep 2023 08:23:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFd13muXd3yaFfAafmi9pC48FJu40UOXFB7h+zxJ/SZD6Rc19emz7CdNPFRKJPpxplEzjl3mQ==
X-Received: by 2002:a05:6a20:101a:b0:14b:3681:567e with SMTP id gs26-20020a056a20101a00b0014b3681567emr7100114pzc.29.1695741811749;
        Tue, 26 Sep 2023 08:23:31 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id h6-20020a170902f54600b001c5f7e06256sm7410616plf.152.2023.09.26.08.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 08:23:31 -0700 (PDT)
Date:   Tue, 26 Sep 2023 23:23:28 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: Re: [PATCH] ovl: disable IOCB_DIO_CALLER_COMP
Message-ID: <20230926152328.5vpz7yddmsjahkxt@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <71897125-e570-46ce-946a-d4729725e28f@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71897125-e570-46ce-946a-d4729725e28f@kernel.dk>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Sep 25, 2023 at 12:21:35AM -0600, Jens Axboe wrote:
> overlayfs copies the kiocb flags when it sets up a new kiocb to handle
> a write, but it doesn't properly support dealing with the deferred
> caller completions of the kiocb. This means it doesn't get the final
> write completion value, and hence will complete the write with '0' as
> the result.
> 
> We could support the caller completions in overlayfs, but for now let's
> just disable them in the generated write kiocb.
> 
> Reported-by: Zorro Lang <zlang@redhat.com>
> Link: https://lore.kernel.org/io-uring/20230924142754.ejwsjen5pvyc32l4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com/
> Fixes: 8c052fb3002e ("iomap: support IOCB_DIO_CALLER_COMP")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---

Thanks Jens, the fstests generic/617 works on latest linux kernel with this
patch now.

> 
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 4193633c4c7a..693971d20280 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -391,6 +391,12 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
>  	if (!ovl_should_sync(OVL_FS(inode->i_sb)))
>  		ifl &= ~(IOCB_DSYNC | IOCB_SYNC);
>  
> +	/*
> +	 * Overlayfs doesn't support deferred completions, don't copy
> +	 * this property in case it is set by the issuer.
> +	 */
> +	ifl &= ~IOCB_DIO_CALLER_COMP;
> +
>  	old_cred = ovl_override_creds(file_inode(file)->i_sb);
>  	if (is_sync_kiocb(iocb)) {
>  		file_start_write(real.file);
> 
> -- 
> Jens Axboe
> 
> 	
> 

