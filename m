Return-Path: <SRS0=9nie=3Y=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE5F4C3524D
	for <linux-unionfs@archiver.kernel.org>; Tue,  4 Feb 2020 19:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C202F2087E
	for <linux-unionfs@archiver.kernel.org>; Tue,  4 Feb 2020 19:16:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="a+K+LZWc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbgBDTQw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 14:16:52 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:44359 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727415AbgBDTQw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 4 Feb 2020 14:16:52 -0500
Received: by mail-il1-f194.google.com with SMTP id s85so13444243ill.11
        for <linux-unionfs@vger.kernel.org>; Tue, 04 Feb 2020 11:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N9/6XU2LpZWsBgzTzP/hhFG+SEvjhrm1Akh+4LB2jFQ=;
        b=a+K+LZWcvBn/Qen+mTbm7223lprh5qcBn4n03M+j1wt01jaRqnWZdiVfg8OXtoJRuv
         jsFJk1c/r2LP7mJnsYPJCuY09T0w7SMu45sZvs8mlUdxbkANMu9bUNkqywhtzLwrWCUH
         Y5I3ZpOtvK5+VQCI2CCizK69Gkl6kx/0lPYyY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N9/6XU2LpZWsBgzTzP/hhFG+SEvjhrm1Akh+4LB2jFQ=;
        b=bf4SEqaTNEdobs8WFyNrvpsdnSnnlmnkDt4DezC3FL8KAQkXHHmCpch7zDXjXCdLhK
         3DN6oWWbDeiHXCbZWZmP/69t50e967OiFUATTGitJF6/Nw6gOZqgdG0k2HE8OxIhBY6o
         CEJkRRH9TyjXlEu78Kwq5K/BS+I4SBHg7r+7/GZ1lt8bOsj8+2xwbDcwVv1ecbpZIPKq
         M2Q0VKrdmz7ufxey6a+a56sztuvbUZIXqmtT14XEpmyIMmUYR1xXCLZV1TOLfVTSd2p/
         YwLgzLE7KA1lPNifmRzgzLKI5r3aTHGjLbjodrXAcQnWaYTAC8w2dU8qoVoOhtMJYuZ3
         shDQ==
X-Gm-Message-State: APjAAAWgODThqq20VVtK1anl6/ZmAd9S5KMmalhjlAJI/3zw8Qrk6UTK
        AvpD6vmdunVxMESVpIzUlVcnyGLj4lxzxSakrbxK7g==
X-Google-Smtp-Source: APXvYqwBCrb0c3k8/h5XEMaUEVvPRrRnwM6U/8qzM3bVAInIClMbhx20heV2frId/eht16ldh1qeEDwL4qHGTjKjEIg=
X-Received: by 2002:a92:3c93:: with SMTP id j19mr20659572ilf.63.1580843809908;
 Tue, 04 Feb 2020 11:16:49 -0800 (PST)
MIME-Version: 1.0
References: <20200131115004.17410-1-mszeredi@redhat.com> <20200131115004.17410-5-mszeredi@redhat.com>
 <20200204145951.GC11631@redhat.com> <CAJfpegtq4A-m9vOPwUftiotC_Xv6w-dnhCi9=E0t-b1ZPJXPGw@mail.gmail.com>
 <CAOQ4uxj_pVp9-EN2Gmq9j6G3xozzpK_zQiRO-brx6PZ9VpgD0Q@mail.gmail.com>
 <20200204184221.GA24566@redhat.com> <CAOQ4uxhfV++XvO17ywftnhLoryYsynF=Y-pHCwmPdymc6naOFg@mail.gmail.com>
In-Reply-To: <CAOQ4uxhfV++XvO17ywftnhLoryYsynF=Y-pHCwmPdymc6naOFg@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 4 Feb 2020 20:16:39 +0100
Message-ID: <CAJfpeguHjd2PMPxgbzFbdGM_7F6L4v+UGorjp2sMFtykR71QaA@mail.gmail.com>
Subject: Re: [PATCH 4/4] ovl: alllow remote upper
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Feb 4, 2020 at 8:11 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Feb 4, 2020 at 8:42 PM Vivek Goyal <vgoyal@redhat.com> wrote:

> > So as of now user space will get -ESTALE and that will get cleared when
> > user space retries after corresponding ovl dentry has been dropped from
> > cache (either dentry is evicted, cache is cleared forcibly or overlayfs
> > is remounted)? If yes, that kind of makes sense. Overlay does not expect
> > underlying layers to change and if a change it detected it is flagged
> > to user space (and overlayfs does not try to fix it)?
> >
>
> I looks like it. I don't really understand why overlayfs shouldn't drop
> the dentry on failure to revalidate. Maybe I am missing something.

I don't remember the exact reason.   Maybe it's just that it makes
little sense to redo the lookup on remote change, but not on local
change...

Note:  I'm not against detection of changing underlying layers and
redoing the lookup in that case.  Maybe we can do it optionally
(because it could be expensive), but first there needs to be a use
case and we seem to lack that.

Thanks,
Miklos
