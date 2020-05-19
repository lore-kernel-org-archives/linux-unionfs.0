Return-Path: <SRS0=3eGR=7B=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98FC8C433DF
	for <linux-unionfs@archiver.kernel.org>; Tue, 19 May 2020 08:21:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F58220709
	for <linux-unionfs@archiver.kernel.org>; Tue, 19 May 2020 08:21:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="BFj23ItL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgESIVR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 19 May 2020 04:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgESIVQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 19 May 2020 04:21:16 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEC1C061A0C
        for <linux-unionfs@vger.kernel.org>; Tue, 19 May 2020 01:21:16 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id s21so11054337ejd.2
        for <linux-unionfs@vger.kernel.org>; Tue, 19 May 2020 01:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ccvp0UKA18YUUwbPrCJB74eAv5CbqESEGZXqss0korg=;
        b=BFj23ItLM6qHv7UFGIw4Z1tHDlsRy0cE17vc8ryxdCY/TBV3EeSAzz2ARf17Z+2At1
         UjMn6m4tGShREGUTMqco/W3LTIKTRO0BvxZKzJxP3TOy2qxYf/ojdFB/O2eVNeCHkrIe
         XHjr9Z5fTPz/wtjbT/EHgGPHqmjTwag8yEcGI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ccvp0UKA18YUUwbPrCJB74eAv5CbqESEGZXqss0korg=;
        b=rkxiNJR6oO/Q+DHSSZxWr9IdFgr08Plt6ldOPQ/d2BqEz3ynbEAKtq6P3OCZKCwkCE
         /4DGbWFpGvpFDs/Tke1UH0//vZiwgZqqgKNHV7pZlXoWZft4522yqbxvfhHwl5Me1ba0
         WwT9uM02fWP3vmsEM8vHUTJAE72K24MsIV3pcFV7FQpdxivTnHZ542nb+zoY9hchk2oN
         2v2klvBR4Sfzf/wDR+n2MoLjccY+jfvyoEyhl2ADYgteNB/3Fz8CwOGJzi9WMsdTNYma
         9BqVhoM/FSov6MFP6+DNjdHUxZpKydMg/CZ3Moh00X8j3WyRd4e2rTjZZx/c+Fs9yyJ5
         yXtQ==
X-Gm-Message-State: AOAM531Fkp7YWPpJcORINlVc3pI8CfRa8hzrGHy1GOvKyYvDdS0tYvrj
        nmT+pDmucVjtvuhP3aIdkTwxenEBc6TVZn+YiVqCXw==
X-Google-Smtp-Source: ABdhPJxk6mvgGGPc6gMxqKBM2HwfSbIRkvpM0M4MWM0/H4pPLUHTRwKgzq9GqfYRDFAgyGefJw/gtu/j4UXcR9w8mjA=
X-Received: by 2002:a17:906:f9d7:: with SMTP id lj23mr18927763ejb.218.1589876475234;
 Tue, 19 May 2020 01:21:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200515072047.31454-1-cgxu519@mykernel.net> <e994d56ff1357013a85bde7be2e901476f743b83.camel@themaw.net>
 <CAOQ4uxjT8DouPmf1mk1x24X8FcN5peYAqwdr362P4gcW+x15dw@mail.gmail.com>
 <CAJfpegtpi1SVJRbQb8zM0t66WnrjKsPEGEN3qZKRzrZePP06dA@mail.gmail.com> <05e92557-055c-0dea-4fe4-0194606b6c77@mykernel.net>
In-Reply-To: <05e92557-055c-0dea-4fe4-0194606b6c77@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 19 May 2020 10:21:03 +0200
Message-ID: <CAJfpegtyZw=6zqWQWm-fN0KpGEp9stcfvnbA7eh6E-7XHxaG=Q@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/9] Suppress negative dentry
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Amir Goldstein <amir73il@gmail.com>, Ian Kent <raven@themaw.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, May 19, 2020 at 7:02 AM cgxu <cgxu519@mykernel.net> wrote:

> If we don't consider that only drop negative dentry of our lookup,
> it is possible to do like below, isn't it?

Yes, the code looks good, though I'd consider using d_lock on dentry
instead if i_lock on parent, something like this:

if (d_is_negative(dentry) && dentry->d_lockref.count == 1) {
    spin_lock(&dentry->d_lock);
    /* Recheck condition under lock */
    if (d_is_negative(dentry) && dentry->d_lockref.count == 1)
        __d_drop(dentry)
    spin_unlock(&dentry->d_lock);
}

But as Amir noted, we do need to take into account the case where
lower layers are shared by multiple overlays, in which case dropping
the negative dentries could result in a performance regression.
Have you looked at that case, and the effect of this patch on negative
dentry lookup performance?

Upper layer negative dentries don't have this issue, since they are
never shared, so I think it would be safe to drop them
unconditionally.

Thanks,
Miklos
