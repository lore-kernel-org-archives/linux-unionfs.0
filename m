Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F6B7C433E0
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Jan 2021 05:06:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0757120780
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Jan 2021 05:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbhADFFs (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 00:05:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbhADFFr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Jan 2021 00:05:47 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB11DC061574
        for <linux-unionfs@vger.kernel.org>; Sun,  3 Jan 2021 21:05:07 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id q137so23900398iod.9
        for <linux-unionfs@vger.kernel.org>; Sun, 03 Jan 2021 21:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f1GoppzzqPgFKkHgOBFYJaSgNsTsK8yHy0DrAfhJWGs=;
        b=tCbk0ibyPQBNHur7oKj568Jrd3ltU1Yshdc7Z4MY/jEekxfnO/rb3DKk4iiDh8bwW/
         cNNaZhsfIip03sFWvlUP5sGo7IOBAyq29DUpRlA78+aJrshs5/QiPG8gCgl05iEKOc6n
         JlludLD40V8l9po3pnE0GPfw9SNyMxrvpsOibCCKHzc3dwT1mul+LKHlPkD5mZ+cPKvV
         SXzbimot3Jb860d/9bBSi1R3xmrQPGh5nQrTZpgeFpTK4jk24sePuqQY5hSxSkCBHnie
         U/vdlnaOqIsypmLbz+49ZqA+Lx7If/sRe+cdEUBct1d63GixPhPL9SRTMwHPFurGT81j
         qXeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f1GoppzzqPgFKkHgOBFYJaSgNsTsK8yHy0DrAfhJWGs=;
        b=Kih8FS8pSN8meRbuerWopqv9H6Z55JkewgAPgd6EZORSllc4kn0r5TkWsSvT5O7ppM
         dTOQUQ6h6zwxuO6NO2f9QZcgtRhLZYHoeTD38/e70yKGcoF9UCQX6SfGTUsDILnmBdZt
         p7mH+rl8g6/1n7Uz3pNn9q8XGYEU+9suvG2PfV/gfLWv6+MREn/V7yiyYsMX3HvBTYxf
         VOSoDCmp/+Q0J13X2qxeqhZ21VmQIbhmxq+dlBCM6IlOUJ1QyTHPNzC7Z9p/DW2scCQa
         nQATgIVGbITPWmcLroCejF+hyF6niT4Edar7372uHrrA/P0Nhf1wLEDCB5w8ocPhDHOC
         rOvA==
X-Gm-Message-State: AOAM53143fyqvkDLVFnAm2oMRBEUIPHy7xl+IgQi9bgGPcH1gHEwMVwQ
        evuqzBcBKxJ5XoeK9qo4N8QQ9ycBV8ru0slMIbI=
X-Google-Smtp-Source: ABdhPJwpnI42MZYDLOnrZhAwwc1PnpLd1P4ykPkwdgRsg2NjlDqXFS2hFsfAXKJ73BUYaq1fKsKOm5KD82Byz7PjsnY=
X-Received: by 2002:a5e:de08:: with SMTP id e8mr57481945iok.203.1609736707133;
 Sun, 03 Jan 2021 21:05:07 -0800 (PST)
MIME-Version: 1.0
References: <20201226104618.239739-1-cgxu519@mykernel.net>
In-Reply-To: <20201226104618.239739-1-cgxu519@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 4 Jan 2021 07:04:56 +0200
Message-ID: <CAOQ4uxhn1q4ZcW+GgNxLwcSwhQxrQJibPhX8xO2YsbS1et6YiQ@mail.gmail.com>
Subject: Re: [RFC PATCH] ovl: keep some file attrubutions after copy-up
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Dec 26, 2020 at 12:48 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Currently after copy-up, upper file will lose most of file
> attributions except copy-up triggered by setting fsflags.
> Because ioctl operation of underlying file systems does not
> expect calling from kernel component, it seems hard to
> copy fsflags during copy-up.
>
> Overlayfs keeps limited attributions(append-only, etc) in it's
> inode flags after successfully updating attributions. so ater
> copy-up, lsattr(1) does not show correct result but overlayfs
> can still prohibit ramdom write for those files which originally
> have append-only attribution. However, recently I found this
> protection can be easily broken in below operations.
>
> 1, Set append attribution to lower file.
> 2, Mount overlayfs.
> 3, Trigger copy-up by data append.
> 4, Set noatime attributtion to the file.
> 5, The file is random writable.
>
> This patch tries to keep some file attributions after copy-up
> so that overlayfs keeps compatible behavior with local filesystem
> as much as possible.
>

This approach seems quite wrong.
For one thing, mount cycle overlay or drop caches will result in loss
of append only flag after copy-up, so this is not a security fix.

Second, Miklos has already proposed a much more profound change
to address this and similar issues [1] and he has already made some
changes to ioctl handler to master doesn't have ovl_iflags_to_fsflags().

[1] https://lore.kernel.org/linux-fsdevel/20201123141207.GC327006@miu.piliscsaba.redhat.com/

One more thing.
It seems like ovl_copyflags() in ovl_inode_init() would have been better
to copy from ovl_inode_realdata() inode instead of ovl_inode_real().
This way, copy up still loses the append-only flag, but metacopy up
does not. So at least for the common use case of containers that
chown -R won't cause losing all the file flags.

ovl_ioctl_set_flags() triggers data copy up, so that will break the link
to lower flags anyway.

I also noticed that we can lose the immutable flag on lower directory
when copying up parents and it's probably not the only way to
lose an immutable flag on a lower file/dir.

Thanks,
Amir.
