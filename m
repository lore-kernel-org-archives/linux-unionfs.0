Return-Path: <SRS0=ds9p=DL=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF66C4727D
	for <linux-unionfs@archiver.kernel.org>; Sun,  4 Oct 2020 19:48:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94A652068E
	for <linux-unionfs@archiver.kernel.org>; Sun,  4 Oct 2020 19:48:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UyxMmPPT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgJDTsY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 4 Oct 2020 15:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgJDTsY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 4 Oct 2020 15:48:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8A2C0613CE;
        Sun,  4 Oct 2020 12:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=OMbsxgtTm3OucAzsWwXDCdUo0myWgb96GxBl2Cc9TAU=; b=UyxMmPPTT6LXrwdFWQrfqymKBh
        g/MqrIjBNzRP6eeZb4uD2UWPzo3JQR/zsrWaH+W4O0xm0qarwq/QZAVAMUapbkem6gHIUjPp+a6h6
        ZnUBJjhfRDUyexWfWPiLAUcVbM/gIyhMTCl+KDkWCsSkIJ21JlOQzYr6qE+1Dr5kqB3BTlWddII4y
        z7+An7KgC99ayO0xC5OuS6OYZpCziLg9Ro5AGGbYkYHbz8nCqgOg04XdAXAlMhpz01lxVtu/Vhibe
        l4UOgFTXXUPn7G9KMDp8UEP9K9nS34R4QPzyj7vTHZKjtHdaGrWG1jJFcBS5E4Tga9EsYscXucCoA
        YY2RYzZA==;
Received: from [2601:1c0:6280:3f0::2c9a]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kP9zY-0000zN-LN; Sun, 04 Oct 2020 19:48:21 +0000
Subject: Re: [RFC PATCH 1/1] overlayfs: add ioctls that allows to get fhandle
 for layers dentries
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        miklos@szeredi.hu
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        David Howells <dhowells@redhat.com>,
        linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201004192401.9738-1-alexander.mikhalitsyn@virtuozzo.com>
 <20201004192401.9738-2-alexander.mikhalitsyn@virtuozzo.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <9cd0e9d1-f124-3f2d-86e6-e6e96a1ccb1e@infradead.org>
Date:   Sun, 4 Oct 2020 12:48:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201004192401.9738-2-alexander.mikhalitsyn@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 10/4/20 12:24 PM, Alexander Mikhalitsyn wrote:
> +#define	OVL_IOC_GETLWRFHNDLSNUM			_IO('o', 1)
> +// DISCUSS: what if MAX_HANDLE_SZ will change?
> +#define	OVL_IOC_GETLWRFHNDL			_IOR('o', 2, struct ovl_mnt_opt_fh)
> +#define	OVL_IOC_GETUPPRFHNDL			_IOR('o', 3, struct ovl_mnt_opt_fh)
> +#define	OVL_IOC_GETWRKFHNDL			_IOR('o', 4, struct ovl_mnt_opt_fh)

Hi,

This needs to have Documentation/userspace-api/ioctl/ioctl-number.rst
updated also.

thanks.
-- 
~Randy

