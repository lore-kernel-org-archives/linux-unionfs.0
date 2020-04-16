Return-Path: <SRS0=N6pz=6A=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 048D8C2BA2B
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 07:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88E3420771
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 07:10:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="W6Rmxt5Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438365AbgDPHKX (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 16 Apr 2020 03:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2438160AbgDPHKU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Apr 2020 03:10:20 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92AB4C061A0C
        for <linux-unionfs@vger.kernel.org>; Thu, 16 Apr 2020 00:10:19 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id q8so544731eja.2
        for <linux-unionfs@vger.kernel.org>; Thu, 16 Apr 2020 00:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/ju1UwF5e25efrZxszg1rmqYpVN8uKxy6Ab6WjYzv7M=;
        b=W6Rmxt5ZhRlMqSwThLZJ4dcx34KlXpJ4D5+CUSs6A1Kp2gvEDAE9cgTrbn4AjF7pRy
         zUUle3SojRKqHRc7VJv1nL0EkBWudCcxF5QfULJLX/Y4xNPNBBZ+MN0Iw4cymIlx0s9S
         /3pRsvTYlwGcrzrXcndpQYgD6sf5Z1c2eza2g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/ju1UwF5e25efrZxszg1rmqYpVN8uKxy6Ab6WjYzv7M=;
        b=OHIbXmbtlmuKOtXhbaFS78F7EvJruNBwToGhsvmPUxt7RSdwBXD1QBcn/kZi6zCoX4
         gNzpXL/c33kv8dFSiJYdJeQCn6GfcgQZrzlznZe4Z+ZPnveZS4jZH21HwLvWmv6QrRWw
         9RgrTQSRhom1IVyFBykccNfGFQT6cCDxK3tiAhxSpcSUo5H0nLy+8xr7bP5bWtSAK0zd
         DdyF7/2BaIQ0rZPeXXD9OtAVZyKJ0AYcuoCmZbqL0GYWh4zNoi05j+LCqcw1UZx2cRgP
         uvNHlxL28HG3fqJ8HpX5G4NOpkdZyDJPFe32V//E6NHGJQwsCOUVYeIUw6MjKZi+Rfjl
         n2MA==
X-Gm-Message-State: AGi0PuYp6whglwgXb4bQ7NemoDvRHVnxrSyTQZ+ERVKRnx8hxLiwMJOX
        uFVQXHV5Kl3atCbuPsG/8GOgQBJyuBxE6kZjkWs/Lw==
X-Google-Smtp-Source: APiQypLnYs2JWwsjQcs3GK2b9JfhSbJNPGdrRPDrA/K/VNoeUqxbO+QGl78eM/lHh+yFQFBdZrzp9Okvl63gldGNZHk=
X-Received: by 2002:a17:906:8549:: with SMTP id h9mr8101322ejy.145.1587021018270;
 Thu, 16 Apr 2020 00:10:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200414095310.31491-1-cgxu519@mykernel.net> <CAOQ4uxja_CV5SE57GpS5KyBDudBNn8S9VfT=f_O_qNrwKi8RTg@mail.gmail.com>
 <1717b5c51ab.f6b667969599.7086962587723946588@mykernel.net>
 <CAOQ4uxg+ds5O9gHZs3+sgo08Ut84LPn5MeC=duRqPBtuAOtezw@mail.gmail.com>
 <1717cdb4bcf.11544259d10401.8883493846177492528@mykernel.net>
 <CAOQ4uxg0CYuQ-EfOphk-v-o5hvyVr0UbD5nngse9Zi4M5ZxNgw@mail.gmail.com>
 <1717cf65ddb.d406587710513.3094673612298718285@mykernel.net>
 <CAOQ4uxgXtjsZXkm60J2omXmnj-2cHwQZ=jmf3+GYN_KdW8JovA@mail.gmail.com>
 <17181ae4719.11b6a2eaa836.5332868079279852281@mykernel.net> <CAOQ4uxgt=znEgw_V-a+8wJrN_gptoCk8ifZAAOz40wppBtJ2Nw@mail.gmail.com>
In-Reply-To: <CAOQ4uxgt=znEgw_V-a+8wJrN_gptoCk8ifZAAOz40wppBtJ2Nw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 16 Apr 2020 09:10:07 +0200
Message-ID: <CAJfpegtaA6jEc2p1QeQdpUxMJtzYEqWFSYNAW3-K=X0J7pSC8w@mail.gmail.com>
Subject: Re: [PATCH v3] ovl: whiteout inode sharing
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 16, 2020 at 8:47 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> >  > > In case of any unexpected errors, we could set a error limit(for example, 10),
> >  > > if link error count exceeds the limit then we disable the feature.
> >  > >
> >  >
> >  > As far as I am concerned, you may post the patch without auto disable,
> >  > but I object to using an arbitrary number of errors (10) as trigger for auto
> >  > disable.
> >  >
> >  > I do think that it is important to communicate to admin that the whiteout
> >  > sharing is not working as expected and it is not acceptable to flood
> >  > log with warning on each and every whiteout creation, not even with
> >  > pr_warn_ratelimited.
> >  >
> >  > There are several ways you can go about this, but here is a suggestion:
> >  >
> >  > +        if (err) {
> >  > +               ofs->whiteout_link_max >>= 1;
> >  > +               pr_warn("failed to link whiteout (nlink=%u, err = %i)
> >  > - lowering whiteout_link_max to %u\n",
> >  > +                             ofs->whiteout->d_inode->i_nlink, err,
> >  > ofs->whiteout_link_max);
> >  > +               should_link = false;
> >  > +               ovl_cleanup(wdir, ofs->whiteout);
> >  > +       }
> >  >
> >
> > Frankly speaking, I don't like heuristic method to automatically enable/disable feature,
> > so I perfer to disable the feature immediately after hitting any error just like your previous suggestion,
>
> Fine by me.
>
> > and I also hope to add a mount option for this feature to mitigate global effect to different overlayfs instances.
> >
>
> I think that would make sense.
>
> Off topic: from system perspective, the fact that whiteouts take up inodes
> to begin with is a shame. If one had control over the underlying filesystem,
> whiteout should have been implemented as a constant and immutable special
> inode with no nlink count at all and getdents would return DT_WHITEOUT for
> those entries.

Yes, and filesystems are free to implement such a beast.  The
operations are given:  mknod(S_IFCHR, 0) and RENAME_WHITEOUT.  Adding
DT_WHITEOUT handling to overlayfs would be trivial, I guess.

Thanks,
Miklos
