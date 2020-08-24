Return-Path: <SRS0=sCFp=CC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7594DC433E1
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 13:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48E37206B5
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 13:53:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="D/3i5RNk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgHXNxa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 09:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgHXNx3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Aug 2020 09:53:29 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC82AC061573
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2020 06:53:28 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id bs17so8121314edb.1
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2020 06:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E9DTWiQGHH9CACthYWT8TeVj3Uk6eRXuoxENqPnJ3lY=;
        b=D/3i5RNkGDH/R8k+aPNpGtJrwbej/eTm9D7F3njN8AxNgsxP5hh/RjCefsgubqfoX8
         Iv7Rasrw7RRXWJEUQRm+MeYoXKc++KrITqw/JbOFLEVdRka7L5/8owFoyQkEBmdjP2Fm
         cK5vA0qAgtQ+aGZhlTM2zTCsyTbfbD3oeMEXI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E9DTWiQGHH9CACthYWT8TeVj3Uk6eRXuoxENqPnJ3lY=;
        b=f6rMAsJMb51/ak7hIW1ljsYHQVXFWeOvbwUnZjqHaqXjsVK+BJTRCQa/nv3Tyj5UKh
         HPBE4u9KhS0YLlBrjVPyQbpiyHPZvHfZu4/1X/WvJnd+osgN/HkotQry6z1lIM5sMPwT
         cqqrqVgZPV4VKaaMMdwFYpeDkxJ1Hlv/UT5b+lIa+RfPrmZBnkFstf8MqXrem0PY9Gge
         McvKn5lmygtOdcV/pA2lzisgRRImbraZclzdtGd9hWKnRrqq0xR2WyPwAtpHNT7LpR41
         RXXlD+KmHjUZAEo19RyMkSYIYk6ozRH9/676mnpkPEgPu88QdmUqjHi1s3Y8vyXIiNxz
         rlmA==
X-Gm-Message-State: AOAM532WRDy64yp9EE4bFlh9WgYncba5coxsXhYA+ecil72Kp6fcIj1o
        fyM0i5HLNBhD05dDhuIMCSyR1uUt4CC1wK3T6U+EggtKRlw1LQ==
X-Google-Smtp-Source: ABdhPJyTp+JTc/5XX0GjNOjSe6ZPEe7ED8JXipdofF3qmMA7gDQmXTG3Nn7s+c7sbtSthLH+KY4F9hwM5oNTSCImlUs=
X-Received: by 2002:a05:6402:54c:: with SMTP id i12mr5361499edx.358.1598277207670;
 Mon, 24 Aug 2020 06:53:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200722175024.GA608248@redhat.com> <87h7svyqsd.fsf@redhat.com>
 <CAJfpegtA-16EFFoqhn25rVmXat5hhNUTAWOf+hJEs5L910oQzA@mail.gmail.com>
 <CAOQ4uxj0SF1VRbMEvVm4a9TuUtdMYuZqFkZhkUyEGMagCWk5NA@mail.gmail.com> <20200824133948.GA963827@redhat.com>
In-Reply-To: <20200824133948.GA963827@redhat.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 24 Aug 2020 15:53:16 +0200
Message-ID: <CAJfpegvatXE=X-_anCyjVavH8nWcgrNwQpxch9WxVPf3Gk_5Eg@mail.gmail.com>
Subject: Re: [PATCH v5] overlayfs: Provide a mount option "volatile" to skip sync
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Aug 24, 2020 at 3:39 PM Vivek Goyal <vgoyal@redhat.com> wrote:

> /me is wondering why I don't get error with $workdir/work/dir1/volatile
> but I do with $workdir/work/dir1/dir2/volatile. IOW, why in first
> case removal of dir1 was successful despite the fact it is non-empty.

It cares for the case when a directory full of whiteouts is echanged
with RENAME_EXCHANGE to an empty opaque dir created under
$workdir/work.

Strictly speaking it wouldn't need to be able to remove directories
under dir1, but it's just reusing the generic cleanup routine, so
everything is cleaned up upto the second level.

Thanks,
Miklos
