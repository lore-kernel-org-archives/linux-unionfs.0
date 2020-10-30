Return-Path: <SRS0=w8z3=EF=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 021A1C4363A
	for <linux-unionfs@archiver.kernel.org>; Fri, 30 Oct 2020 13:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68C062076E
	for <linux-unionfs@archiver.kernel.org>; Fri, 30 Oct 2020 13:51:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="CSsuXYL4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgJ3Nvg (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 30 Oct 2020 09:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgJ3Nvf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 30 Oct 2020 09:51:35 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92324C0613CF
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2020 06:51:35 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id b4so3444580vsd.4
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2020 06:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yofUVWHOSnvISCZR+7DwO00d9gc+hJjq0LnRZ5P8DVQ=;
        b=CSsuXYL4P2oVsw+9t9+MQEfwquMV7REQc2q5OjVtMptjbDY4OdIL/bXDO/2rUQvNxT
         Bn9muFAF1amIkYcKBy6O4mG/t5TnvhnWQ7maAP4MeCmM0mAet7b7I9hifWK2N24SaiBS
         ICyuKX9y5g0ylE8LGuX3pTVcagJN7wKMvRh+g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yofUVWHOSnvISCZR+7DwO00d9gc+hJjq0LnRZ5P8DVQ=;
        b=EpmkbupaA+fQQtk/sNSeYshc2aqQ9sOqBnKjFzzSDL7OlFgfZD4rim+RSSn4u5WKrx
         fwT30k/DWuoVuRcNoK+H8oLgno2XqrNoLqSm4JTzlCcpbv+S7zpP+dOjkAoSGuslLs5a
         lfrm8uJ/Wf6s5J5ue4BZzdoioE0+Wtt0sJ4tu7VHp+dVCzge/zVAgik74kONgoZ/CrpV
         oWbJN114iKJqYDBtoWa36OPK0w3XUBdeawF9qUBpK75la5Jkf6BIdZ0X9nbsKBhxyxVM
         DrrjA2+/icddQ1pXI8d61jTIaHMJSns9/+FJZCOQySySXhDNJXejRgVqo4hITbe74nzx
         Q/zg==
X-Gm-Message-State: AOAM532Do0O+f5j+dva5JVTeumptdyKj6OSePN+B43RuRr03HWUaBKAr
        hwK06HyRnEn8AnJyvZeFjtec2tWLWshvRQnr5Ynhkg==
X-Google-Smtp-Source: ABdhPJxHECrCTkqkwW7Eu72LEP58kNKPVnHp+QhtglWXH0VJsvsFG/xYDBf3K/Ff2OhbDao67XG4bwQy7wN0c4rZ3KU=
X-Received: by 2002:a67:2b47:: with SMTP id r68mr5460991vsr.7.1604065894629;
 Fri, 30 Oct 2020 06:51:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200713141945.11719-1-amir73il@gmail.com> <20200713141945.11719-4-amir73il@gmail.com>
 <CAJfpegvhH+SUn-QModbU23sk3=NGYgxKSekh5B70JfK_=HbHfw@mail.gmail.com> <CAOQ4uxjNtKXFT8CLbgr6hMSiCVVK4x1usYAfOG6Cec7KzdqcQA@mail.gmail.com>
In-Reply-To: <CAOQ4uxjNtKXFT8CLbgr6hMSiCVVK4x1usYAfOG6Cec7KzdqcQA@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 30 Oct 2020 14:51:23 +0100
Message-ID: <CAJfpegvcCCn0UNY6rBgHWQESLZwJtR39DaNM5e6Xr-es=B-05g@mail.gmail.com>
Subject: Re: [PATCH 3/3] ovl: do not follow non-dir origin with redirect_dir=nofollow
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Oct 30, 2020 at 2:20 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Fri, Oct 30, 2020 at 2:05 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Mon, Jul 13, 2020 at 4:20 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > Following non-dir origin can result in some bugs when underlying layers
> > > are edited offline.
> >
> > Sorry, lost track.  What bugs this results in?
>
> Frankly, not in a reported bug, but a theoretical one, so feel free to take
> it or leave it. I tried to rationalize it in the cover letter [1].
>
> The bug is that you can have an upper inode with wrong origin
> lower inode when re-creating lower fs in a way that rewrites the
> unique file handle history of the lower fs. This can result in two non-hardlinks
> pointing at the same origin and possibly worse.
>
> Commit a888db310195 ("ovl: fix regression with re-formatted lower squashfs")
> solved this problem for  re-created lower squashfs by not following
> origin in the
> case of lower fs with null uuid.
>
> The case of lower fs with non-null uuid you said was less interesting because
> re-creating lower would result in a new uuid and therefore origin will not
> be followed to the wrong inode.
>
> However, the uuid=off use case [2] tells us that lower fs with uuid can in-fact
> be re-created with the same uuid when a prototype image is being cloned
> and modified.
>
> The uuid=off feature was proposed because Virtuozzo change the uuid
> of lower image after it has been cloned. But other users may not follow
> this practice. As a matter of fact xfs has mount option nouuid exactly for
> this case (mount a cloned block device as well as the origin).
>
> Long story short, I just thought it would be nice  for users to have a way to
> opt-out of any sort of decoding origin when they want "legacy" overlay
> functionality in case we have any more latent origin related bugs.

Okay, let's just postpone this until a real issue turns up.

Thanks,
Miklos
