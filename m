Return-Path: <SRS0=S/H/=7P=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3343BC433DF
	for <linux-unionfs@archiver.kernel.org>; Tue,  2 Jun 2020 08:22:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8218206C3
	for <linux-unionfs@archiver.kernel.org>; Tue,  2 Jun 2020 08:22:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Hn1HJLVF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbgFBIWk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 04:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgFBIWk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 2 Jun 2020 04:22:40 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F342AC061A0E
        for <linux-unionfs@vger.kernel.org>; Tue,  2 Jun 2020 01:22:39 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id mb16so11878262ejb.4
        for <linux-unionfs@vger.kernel.org>; Tue, 02 Jun 2020 01:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tx005gF6lcxXnJrZ6kwWz8God4aqWAC9xdIr9d6dhBs=;
        b=Hn1HJLVFGO1dhSG9rxKSGBtmLqOGSqgglQVw+x9s+V+MuL3rof44osmmL75fuev50W
         YDJIfK1jT4QdzptJjkvQHSB8/lEefQx0udotixz226n58jJzM4YFaQGa0NMPzRjMBOIT
         oqqt+ITcMvEwoyMtU4y1Jat8rIZVX4eo/QrWU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tx005gF6lcxXnJrZ6kwWz8God4aqWAC9xdIr9d6dhBs=;
        b=uJIiFmtOyDk4HOJnhp24E/u/XeNyfTHDd6fiF0cQQQWZlqX479/nCKazAsWysa4Ja+
         ZkLawfp0e7J1Dnov/kTioaiT6PpqE2cL6aiIRTbKgNc/PE20Pt+dCtIDawPzyQr3rerm
         FIOvKEk5fFeCk+OkQzZyRTiNmg7OH2s6n+sg34LmK7kAZ7rn6VPjDKH6x0VcEIHqhJ4n
         RreDzGU0w/BQmBVOvoPkMuU+M5ZC7Eul38qCHJ22QvpjY3XxGH493z+uE8GgSIhTv+Ag
         u/MTQkwZELmpfUq8Eq3RyrwgBVBECXyjyaEAoumA7Ez7tAWGYslC2XqxMZpinXUPBgqk
         Ax8Q==
X-Gm-Message-State: AOAM530Oj1R9+/DouK18NpPEZkT4dhIFszu9gdw843Y1oEauuhQil6nW
        AFhRbPTdyDmr50lWCetan8PZ8RA9LRXXUrgzV401Fg==
X-Google-Smtp-Source: ABdhPJwJy2IyvKYD4j+ARlE9VbrjfVcRsTNbUD5TJWBAZ1+1pO1yi+9TvW2XitJ7OCXdPcHKEICwVS+lIrzaID572I0=
X-Received: by 2002:a17:906:6b18:: with SMTP id q24mr11402983ejr.202.1591086158742;
 Tue, 02 Jun 2020 01:22:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200523132155.14698-1-amir73il@gmail.com> <CAOQ4uxg+Omm0uR4uw+vf8P3_CZOZQgOqNAnWr9Gh-9SMqvSO5Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxg+Omm0uR4uw+vf8P3_CZOZQgOqNAnWr9Gh-9SMqvSO5Q@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 2 Jun 2020 10:22:27 +0200
Message-ID: <CAJfpegsG89hDdWH3Q6MvPwTwuF2CmttNB9Y7eTS9Ei2=LRrh3w@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix out of bounds access warning in ovl_check_fb_len()
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 2, 2020 at 10:07 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Sat, May 23, 2020 at 4:22 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > syzbot reported out of bounds memory access from open_by_handle_at()
> > with a crafted file handle that looks like this:
> >
> >   { .handle_bytes = 2, .handle_type = OVL_FILEID_V1 }
> >
> > handle_bytes gets rounded down to 0 and we end up calling:
> >   ovl_check_fh_len(fh, 0) => ovl_check_fb_len(fh + 3, -3)
> >
> > But fh buffer is only 2 bytes long, so accessing struct ovl_fb at
> > fh + 3 is illegal.
> >
> > Fixes: cbe7fba8edfc ("ovl: make sure that real fid is 32bit aligned in memory")
> > Reported-and-tested-by: syzbot+61958888b1c60361a791@syzkaller.appspotmail.com
> > Cc: <stable@vger.kernel.org> # v5.5
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Miklos,
> >
>
> Ping.
>
> > Another fallout from aligned file handle.
> > This one seems like a warning that cannot lead to actual harm.
> > As far as I can tell, with:
> >
> >   { .handle_bytes = 2, .handle_type = OVL_FILEID_V1 }
> >
> > kmalloc in handle_to_path() allocates 10 bytes, which means 16 bytes
> > slab object, so all fields accessed by ovl_check_fh_len() should be
> > within the slab object boundaries. And in any case, their value
> > won't change the outcome of EINVAL.
> >
> > I have added this use case to the xfstest for checking the first bug,
> > but it doesn't trigger any warning on my kernel (without KASAN) and
> > returns EINVAL as expected.

Applied, thanks.

Miklos
