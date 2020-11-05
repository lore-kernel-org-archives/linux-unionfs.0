Return-Path: <SRS0=HYNE=EL=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E61C00A89
	for <linux-unionfs@archiver.kernel.org>; Thu,  5 Nov 2020 09:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E0A02080D
	for <linux-unionfs@archiver.kernel.org>; Thu,  5 Nov 2020 09:57:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="WVolHjgS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgKEJ52 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 5 Nov 2020 04:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgKEJ51 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 5 Nov 2020 04:57:27 -0500
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8DFC0613CF
        for <linux-unionfs@vger.kernel.org>; Thu,  5 Nov 2020 01:57:27 -0800 (PST)
Received: by mail-vs1-xe32.google.com with SMTP id 128so432425vso.7
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Nov 2020 01:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QxZ90PW1+oVFQ0O3FeX6/uKsgUNUoYbWua49Tkp/fbM=;
        b=WVolHjgSjoQmFke9+T1wD6nspuNZtfPH3UK6u5f7YJ3spRl95nURzFp7GpjWnyjZj3
         pAIp8sR1SbLKYbb+Tv3ODKjw01q+HVwfvynwLKjkbFiV8hJo30OO8shSqUKBJI3J/JMG
         U2oWSYAJafNq+IdfLTbBl9sUtJe7fTJuNRn7s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QxZ90PW1+oVFQ0O3FeX6/uKsgUNUoYbWua49Tkp/fbM=;
        b=VrPSLgWv8Zc2tIJ285uvuoe+XJAJVZniA71haqU5MbRTIU8pOfJCrpfq+EGhpshohx
         GGBLxKtG/PpxV4hoo5IKFvJH1dnjTPN9BJJV/buWJvYwVQeDP8hibTGO7Zar4373IvKJ
         9Na0s8G+2n65/zDW+zaQ7YF/9GdY5lB1WAb/5KDF3aWlV8V6soG6++eXIl+tQeHvNWPA
         j8ytpWElGYkmRY9qQW7fbq+VqtjUUVtu0CVJfm0QpIIQASWoR4xoC930GQs1m1t7AYW1
         f5pkuO0r6y8Jaue/IUdwLUpO8QX6LksaSwp5x9Mx0vgC0sysAwc2N0BsxMnSyrzgl585
         fsbg==
X-Gm-Message-State: AOAM531j77OtqOvmo/w/5k6XhX0XrZMabH3rnlnznbc8j9DsarLZU6qo
        VMctDLnigoChX3OvgxQnqXF9VvCLGmiolaEwM+kI6A==
X-Google-Smtp-Source: ABdhPJwW3z4SV2BcK05akmHjedlGqPbi8cvZ32c6tJhbgb1BGBTG3/Trr8rqLQDUeDbfipM5jlBz07ARZbTWNZR/QbA=
X-Received: by 2002:a67:2b47:: with SMTP id r68mr673182vsr.7.1604570246544;
 Thu, 05 Nov 2020 01:57:26 -0800 (PST)
MIME-Version: 1.0
References: <17596177926.d559c8b77834.5766617584799741474@mykernel.net>
 <CAOQ4uxgpmC_B_uWpnMXDrv9BOQ-rsMxyRTc+qC3dT72sqR8ndg@mail.gmail.com> <17597c5dc4e.fb084b178911.1848736071974456771@mykernel.net>
In-Reply-To: <17597c5dc4e.fb084b178911.1848736071974456771@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 5 Nov 2020 10:57:15 +0100
Message-ID: <CAJfpegu-rqL4-jn9o0+OSj2x+hKS8mLB6GswhL17Ruhb3WuMKg@mail.gmail.com>
Subject: Re: a question about opening file
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Nov 5, 2020 at 10:38 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-11-05 16:07:26 Amir Gol=
dstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > On Thu, Nov 5, 2020 at 6:39 AM Chengguang Xu <cgxu519@mykernel.net> wr=
ote:
>  > >
>  > > Hello,
>  > >
>  > > I have a question about opening file of underlying filesystem in ove=
rlayfs,
>  > >
>  > > why we use overlayfs' path(vfsmount/dentry) struct for underlying fs=
' file
>  > >
>  > > in ovl_open_realfile()?  Is it by design?
>  >
>  > Sure. open_with_fake_path() is only used by overlayfs.
>  >
>  > IIRC, one of the reasons was to display the user expected path in
>  > /proc/<pid>/maps.
>  > There may have been other reasons.
>  >
>
> So if we do the mmap with overlayfs'  own page cache, then we don't have =
to
> use pseudo path for the reason above, right?
>
> Actually, the background is I'm trying to implement overlayfs' page cache=
 for
> fixing mmap rorw issue. The reason why asking this is I need to open a wr=
iteback
> file which is used for syncing dirty data from overlayfs' own page cache =
to upper inode.
> However, if I use the pseudo path just like current opening behavior, the=
 writeback
> file will hold a reference of vfsmount of overlayfs and it will cause umo=
unt fail with -EBUSY.
> So I want to open a writeback file with correct underlying path struct bu=
t not sure if
> there is any unexpected side effect. Any suggestion?

Should be no issue with plain dentry_open() for that purpose.  In fact
it would be really good to get rid of all that d_real*() mess
completely, but that seems some ways off.

Did you find the prototype we did with Amir a couple of years back?  I
can only find bits and pieces in my mailbox...

Thanks,
Miklos
