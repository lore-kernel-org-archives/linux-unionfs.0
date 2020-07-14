Return-Path: <SRS0=Lx5L=AZ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD9AAC433E0
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 18:07:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B567122527
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 18:07:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AWKouvP5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbgGNSHM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 14:07:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34327 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725906AbgGNSHM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Jul 2020 14:07:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594750030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XrfkS6QSKQhcWTY0Sa0tMsuoxn1wxngj9gDj6chnR1k=;
        b=AWKouvP5KMilTesAXZ3r3YPfcT+OzOnSpnbUWl0DtEzd2H/b5o5UCA0sB5pot9wgaOtjtk
        IDa8v8y6KWrfypUyaZfgD62xCAjThielcx2V/G4uVMxuC7DfbI5GhwAK2ZCR+p1BWsnSlH
        +qoHhh8nfQV6hyZXsi4G/Lw0hyXYxQs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-euj5BIyZPT-oANNv-eqxJw-1; Tue, 14 Jul 2020 14:07:08 -0400
X-MC-Unique: euj5BIyZPT-oANNv-eqxJw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E42F100A8F3;
        Tue, 14 Jul 2020 18:07:06 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-205.rdu2.redhat.com [10.10.115.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 34507710C9;
        Tue, 14 Jul 2020 18:07:06 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id C0EC02237D7; Tue, 14 Jul 2020 14:07:05 -0400 (EDT)
Date:   Tue, 14 Jul 2020 14:07:05 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH 0/3] Misc. redirect_dir=nofollow fixes
Message-ID: <20200714180705.GE324688@redhat.com>
References: <20200713141945.11719-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713141945.11719-1-amir73il@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 13, 2020 at 05:19:42PM +0300, Amir Goldstein wrote:
> Miklos, Vivek,
> 
> Following discussion on following an unsafe non-dir origin [1]
> and in a addition to a fix for the reported null uuid case [2] and to
> Vivek's doc clarification [3], I am proposing to piggy back existing
> config redirect_dir=nofollow to also not follow non-dir origin.
> 
> Like in the case of non-dir origin, following redirects behavior was
> added with no opt-out option in kernel v4.10.  Later security concerns
> about following malformed redirects resulted in the redirect_dir=nofollow
> config option.

So what's the security issue you are seeing with malformed origin? If
it indeed is a security threat, then we should probably introduce
another mount option to disable it (instead of reusing redirect_dir,
because that's so unintuitive, IMHO).

Thanks
Vivek
> 
> Without giving too much thought into how unsafe it can be to follow
> a bad origin, there is very low motication IMO to follow non-dir origin
> with redirect_dir=nofollow, because it is a configuration that prefers
> safety over correctness, so it just seems like the right thing to do.
> 
> The first two patches are independent bug fixes related to read-only
> NFS export, which can be taken regardless of non-dir origin nofollow.
> FYI, I found those bugs because I am using ro,index=off NFS export
> configuration for the new overlay fsnotify snaphsot series.
> 
> Thanks,
> Amir.
> 
> [1] https://lore.kernel.org/linux-unionfs/CAJfpegv9h7ubuGy_6K4OCdZd3R7Z4HGmCDB2L7mO5bVoGd6MSA@mail.gmail.com/
> [2] https://lore.kernel.org/linux-unionfs/20200708131613.30038-1-amir73il@gmail.com/
> [3] https://lore.kernel.org/linux-unionfs/20200709140220.GC150543@redhat.com/
> 
> Amir Goldstein (3):
>   ovl: force read-only sb on failure to create index dir
>   ovl: fix mount option checks for nfs_export with no upperdir
>   ovl: do not follow non-dir origin with redirect_dir=nofollow
> 
>  Documentation/filesystems/overlayfs.rst |  4 +--
>  fs/overlayfs/namei.c                    |  2 +-
>  fs/overlayfs/super.c                    | 42 ++++++++++++++-----------
>  3 files changed, 27 insertions(+), 21 deletions(-)
> 
> -- 
> 2.17.1
> 

