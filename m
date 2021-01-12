Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52055C433DB
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 Jan 2021 10:05:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 161312310B
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 Jan 2021 10:05:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390750AbhALKFj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 05:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390434AbhALKFj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Jan 2021 05:05:39 -0500
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2730C061794
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Jan 2021 02:04:58 -0800 (PST)
Received: by mail-vk1-xa2d.google.com with SMTP id v3so481383vkb.1
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Jan 2021 02:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rS4sdXVHr4l3vGRPMuRvaL1eabkA37lCE2nh9ri+8DA=;
        b=f6Llr2Ei6o9IxbS05Jb89UXoWPqSI2kibVhcgOSycNIT9BHPBbZWtGxXn+WN4i5WCB
         AJOaz8a1xnVBZLXTssdcpIgtFblHkyYiljyiuxZ638ZbcdCEUWce4loVsjZ0tXWMhxu6
         AmEclYLBi87TEBoqp95L0D4aYhWwzlVJWZkj8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rS4sdXVHr4l3vGRPMuRvaL1eabkA37lCE2nh9ri+8DA=;
        b=BC/s6qAbwEq7ptBOB9fqmh5h1IhJMN0xlwiI8QqUXZXs1X88daIPB4LaCuwCfYlmq/
         bcyHSoMW1W3CEEhFJGzT9XmFrQHS+nsxd1PCBHRGewNv4ZCQFUt/zP07hpfy9r96iN+8
         foHG94+MAP1BWLQo3fuDZ/br5lh4+bSP3jYIG+en7LHClq6tbhaWCm1k46wUI1t+sZ/S
         txy9TRDoGXJ/9gwC8J6M84wAGTCOgIPBUrRzZq8tBWz6m5n4Af9do6XGx5+BLTF7Q6Mm
         qXKhxNGX9ZQY+6Pu2E2RE7vIi3GRUM7Dy3LfGM75p+VCpJbInl3t7hzie+ORNWxco40Q
         7nNA==
X-Gm-Message-State: AOAM532tduVzh+7q91FJuzhwTSMFTRGP9oI7R6LIdx/uOrmzn1ol23nl
        jSzt4pSTwk4uxh3dlhKKOcIF/MjUxWELv4N88+uXAw==
X-Google-Smtp-Source: ABdhPJztDdZxYIknYtDyA4L4qWH3qQH8eT1tvdwztKucGwlw6fqzlmexa8qFWsTe/ripf7WrljQs6a1FAY+W8sF9/m0=
X-Received: by 2002:ac5:c284:: with SMTP id h4mr3303695vkk.14.1610445897639;
 Tue, 12 Jan 2021 02:04:57 -0800 (PST)
MIME-Version: 1.0
References: <20201207163255.564116-1-mszeredi@redhat.com> <20201207163255.564116-2-mszeredi@redhat.com>
 <87czyoimqz.fsf@x220.int.ebiederm.org> <20210111134916.GC1236412@miu.piliscsaba.redhat.com>
 <874kjnm2p2.fsf@x220.int.ebiederm.org> <CAJfpegtKMwTZwENX7hrVGUVRWgNTf4Tr_bRxYrPpPAH_D2fH-Q@mail.gmail.com>
In-Reply-To: <CAJfpegtKMwTZwENX7hrVGUVRWgNTf4Tr_bRxYrPpPAH_D2fH-Q@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 12 Jan 2021 11:04:46 +0100
Message-ID: <CAJfpegutxHPuEnUxapcwcwiEiND8Swdi7CSOMaU06qV9=uUdXA@mail.gmail.com>
Subject: Re: [PATCH v2 01/10] vfs: move cap_convert_nscap() call into vfs_setxattr()
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        linux-fsdevel@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jan 12, 2021 at 10:43 AM Miklos Szeredi <miklos@szeredi.hu> wrote:

> The following semantics would make a ton more sense, since getting a
> v2 would indicate that rootid is unknown:
>
> - if cap is v2 convert to v3 with zero rootid
> - after this, check if rootid needs to be translated, if not return v3
> - if yes, try to translate to current ns, if succeeds return translated v3
> - if not mappable, return v2
>
> Hmm?

Actually, it would make even more sense to simply skip unconvertible
caps and return -ENODATA.  In fact that's what I thought would happen
until I looked at the -EOPNOTSUPP fallback code in vfs_getxattr().

Serge, do you remember what was the reason for the unconverted fallback?

Thanks,
Miklos
