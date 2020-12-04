Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95DD7C4361A
	for <linux-unionfs@archiver.kernel.org>; Fri,  4 Dec 2020 15:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 618E222B2D
	for <linux-unionfs@archiver.kernel.org>; Fri,  4 Dec 2020 15:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730378AbgLDPDH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 10:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730350AbgLDPDG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 4 Dec 2020 10:03:06 -0500
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933DDC0613D1
        for <linux-unionfs@vger.kernel.org>; Fri,  4 Dec 2020 07:02:26 -0800 (PST)
Received: by mail-vs1-xe43.google.com with SMTP id u7so3372591vsq.11
        for <linux-unionfs@vger.kernel.org>; Fri, 04 Dec 2020 07:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=L8Av0b0tkSDoVYAGA9Ul3UP0kLwwbvt1kNS0v+OC54s=;
        b=Xm5/6uLpgEYar8q6Uww1lyRELI9tbT7fkb8OU6oHeRzLyQOPQAxVUKzCzSv59vRQNW
         ulc5cP7UYGP9yfc0sunyEaE7hejWfb09FT2bLgt3XI8cjbTFkpPRTRknTXIFFhOTViaC
         i2+YxFZNLG2KC7eeA8yPoq4NZgBqGSaJ3/ot4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=L8Av0b0tkSDoVYAGA9Ul3UP0kLwwbvt1kNS0v+OC54s=;
        b=OaSo4dKM3hLR+85xpBgsBtV/QVBHH0maLn0d8DxE2RZODiJJMTixhfKpgOOzqRfRES
         tlW4l9Lv7CigcLixO5a8ecqoLE56FlL5QXtgXDZW+T6y6IgPYORFTqPYc53lMefDAGis
         eM7eon3D4o7oBUEmalLj6BmTvrCx8TxJE0Fl8VGbFJ5DWxALz5W1KQxgHF84VhOoBOiA
         KloIOzE0lOsiZ74jtxZPhX7Ze6QXgAs+e95vRvURwTls5NFd5P24aUVfiWal8KRv4l/T
         sz3bLBf10m3+8ZI8vwtTUhZUQ2XBJy6Oz4QLzwGNCTdQCdc6qa8NHnmrTogf8XsG7jSM
         XHkg==
X-Gm-Message-State: AOAM531z7+w4pir5S1mmhiLf8TPDiPDQPbUaYyNxPIro7KakGtWJyysP
        ZPrYls+iM5vr/YU12BuH0jjFJlh8tCfs8Fzq8fB0KZFzldI=
X-Google-Smtp-Source: ABdhPJxwaq9QG5yLGeL/Oybu4svoQAZwW6p0AtOH1k3WSVCT5wGrFbndLVa39lzuAECYH/4XoNTWvCSFyUHNvAkFJ8I=
X-Received: by 2002:a05:6102:126c:: with SMTP id q12mr3992650vsg.9.1607094145824;
 Fri, 04 Dec 2020 07:02:25 -0800 (PST)
MIME-Version: 1.0
References: <20201113065555.147276-1-cgxu519@mykernel.net> <1762e3a7bce.e28cb82145070.9060345012556073676@mykernel.net>
In-Reply-To: <1762e3a7bce.e28cb82145070.9060345012556073676@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 4 Dec 2020 16:02:14 +0100
Message-ID: <CAJfpegsbb4iTxW8ZyuRFVNc63zg7Ku7vzpSNuzHASYZH-d5wWA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 0/9] implement containerized syncfs for overlayfs
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     jack <jack@suse.cz>, amir73il <amir73il@gmail.com>,
        linux-unionfs <linux-unionfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Dec 4, 2020 at 3:50 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=94, 2020-11-13 14:55:46 Chenggua=
ng Xu <cgxu519@mykernel.net> =E6=92=B0=E5=86=99 ----
>  > Current syncfs(2) syscall on overlayfs just calls sync_filesystem()
>  > on upper_sb to synchronize whole dirty inodes in upper filesystem
>  > regardless of the overlay ownership of the inode. In the use case of
>  > container, when multiple containers using the same underlying upper
>  > filesystem, it has some shortcomings as below.
>  >
>  > (1) Performance
>  > Synchronization is probably heavy because it actually syncs unnecessar=
y
>  > inodes for target overlayfs.
>  >
>  > (2) Interference
>  > Unplanned synchronization will probably impact IO performance of
>  > unrelated container processes on the other overlayfs.
>  >
>  > This series try to implement containerized syncfs for overlayfs so tha=
t
>  > only sync target dirty upper inodes which are belong to specific overl=
ayfs
>  > instance. By doing this, it is able to reduce cost of synchronization =
and
>  > will not seriously impact IO performance of unrelated processes.
>
> Hi Miklos,
>
> I think this version has addressed all previous issues and comments from =
Jack
> and Amir.  Have you got time to review this patch series?

Hopefully yes.

I'm really keen to finish off the unprivileged overlay patches first.
Will test and post a new version shortly.

Thanks,
Miklos
