Return-Path: <SRS0=w8z3=EF=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1678C4363A
	for <linux-unionfs@archiver.kernel.org>; Fri, 30 Oct 2020 13:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39DB12075E
	for <linux-unionfs@archiver.kernel.org>; Fri, 30 Oct 2020 13:17:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="ao9kqffH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgJ3NQ7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 30 Oct 2020 09:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgJ3NQ6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 30 Oct 2020 09:16:58 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27078C0613CF
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2020 06:16:58 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id n189so1447428vkb.3
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2020 06:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K9PQq7INF35OYV48DeGKYJyLgcV7A07mFkDwC/Z5Dlo=;
        b=ao9kqffHlw/SG4Lje0AmpcP5kpC31ihU1PHVVsIKEAZJXiOWUprQXEc4GUmaJCf/uf
         A8Yh/PLycDyqOovaj2RoLgec4e0qzQm5LVWIzF0BVcHErbKyogfFXOJPLAWc6taGcszr
         7xKuHD32E7lhBRx46gA7SahEkCv0U6rLDT0yk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K9PQq7INF35OYV48DeGKYJyLgcV7A07mFkDwC/Z5Dlo=;
        b=ds9mV7ad37t6kbFT0bo47tIV+NiuMYrCOxLjeDzD+QC/PEDV0wtHAkLxiKW3UUaXOQ
         9F4HuL+y8pKR/0LsRYgudFpezLgrba9uGVKsWGyZSi1Q/JcOWqNNk7smJyeaglnWxgJf
         6IG1DmKa5F1lX2SCJicbzaoe8zcaHGiC58dDrrs8aN3Ae/Jq5AvMEyoiyzXhSpQtPO+U
         26EFjCrqyCEO+jTxAi+tbhG3VKsgER8QXb2fAJpCXzdDRqno4aGi/zwguBZ9oqi0i7qC
         zBKVRjvzFSzI/f+vxV1HrsRdPNgf7YMTaLBm/0xUAd0YvV6b8wgiFq1AD3rTLkt4F2bv
         kNYg==
X-Gm-Message-State: AOAM530GpwY1Cv0klHCWWPtdnRzQNpzIZOOnNo3MwXL+bFIlEPeQB9JJ
        A1rGwnkDqx1trgKtyVYgQwT9SforEWnCIgSAyC7OQw==
X-Google-Smtp-Source: ABdhPJxSMjn1orzYmsXJScr+64oWgZ1O+ERwkWAJLxzPmESNYZi6opNInzBnY73JPBYtjdmOeKJWOcan5ux4tU6w7T8=
X-Received: by 2002:a1f:23d0:: with SMTP id j199mr6737722vkj.11.1604063817240;
 Fri, 30 Oct 2020 06:16:57 -0700 (PDT)
MIME-Version: 1.0
References: <82b537e0ca5fa38b492413bd665c0198e6761015.1597944769.git.kevin@kevinlocke.name>
 <fe78446e6565cda29cc2c87f3e3c1b2a16f5d5cc.1598149357.git.kevin@kevinlocke.name>
In-Reply-To: <fe78446e6565cda29cc2c87f3e3c1b2a16f5d5cc.1598149357.git.kevin@kevinlocke.name>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 30 Oct 2020 14:16:46 +0100
Message-ID: <CAJfpegvakND7=_8eDdu9TAgXwYNN-vZi1pdY-gLzuF-Dn6C0_Q@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: document lower modification caveats
To:     Kevin Locke <kevin@kevinlocke.name>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Aug 23, 2020 at 4:23 AM Kevin Locke <kevin@kevinlocke.name> wrote:
>
> Some overlayfs optional features are incompatible with offline changes
> to the lower tree[1][2][3] and may result in -EXDEV[4], -EIO[5], or
> other errors.  Such modification is not supported and the error behavior
> is intentionally not specified.
>
> Update the "Changes to underlying filesystems" section to note this
> restriction.  Move the paragraph describing the offline behavior below
> the online behavior so it is adjacent to the following 3 paragraphs
> describing the NFS export offline modification behavior.
>
> [1]: https://lore.kernel.org/linux-unionfs/20200708142353.GA103536@redhat.com/
> [2]: https://lore.kernel.org/linux-unionfs/CAOQ4uxi23Zsmfb4rCed1n=On0NNA5KZD74jjjeyz+et32sk-gg@mail.gmail.com/
> [3]: https://lore.kernel.org/linux-unionfs/20200817135651.GA637139@redhat.com/
> [4]: https://lore.kernel.org/linux-unionfs/20200709153616.GE150543@redhat.com/
> [5]: https://lore.kernel.org/linux-unionfs/20200812135529.GA122370@kevinolos/
>
> Signed-off-by: Kevin Locke <kevin@kevinlocke.name>

Thanks, applied.

Miklos
