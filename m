Return-Path: <SRS0=uqCX=CD=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48199C433E3
	for <linux-unionfs@archiver.kernel.org>; Tue, 25 Aug 2020 09:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE9732068F
	for <linux-unionfs@archiver.kernel.org>; Tue, 25 Aug 2020 09:18:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="BBqTC0rU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729201AbgHYJSU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 05:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726790AbgHYJSN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 25 Aug 2020 05:18:13 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0BCC061574
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Aug 2020 02:18:13 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id f24so8279846edw.10
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Aug 2020 02:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y/WoTV3VYUFeYiCcBgARFBIMV46W6IHj3iwfPZmdq5w=;
        b=BBqTC0rUvpCnixpps1dnSv058yS5/47XVfrcnP0CiS5ZKxBITMtfq3oK/t31LzPHxH
         ueJ6xa1IubayCNdFobckPV7fZuIdQ9SXfQrUaixFOLoqzOj63oXQQLAfd2UdXLQRtWvL
         rqPEWU4ZevlJrnt+Rg7RRc6FlNrCDyOnioSWw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y/WoTV3VYUFeYiCcBgARFBIMV46W6IHj3iwfPZmdq5w=;
        b=pNEixitbl/KPVCWWTSVIsp8C7Dys8Bpn0lBjoKY6d9hZ3xb9tQsqEMFYYQK4G+kxcG
         O8762vuAncOdJynUQnzXj4pjEHZeg92gRip8FrimndzStUbDevyyTMI72gKQ1i5ZE9uZ
         u62XtPynDeH7oS5k1V6kC5BY25Vul+IBi7GCLtqPeknvC5ELCzh1UeaGqQWn0jUP7qCC
         D7L75pyljCleJ0gI2rh8Zz4Zn14UUZw4qrNFwnwnimhcjYxaQiqfof9sh/G0j0ShFsL+
         zsVUcKNyt0GGHUNOuNyypkg424DpvTNitw/YPTXALB+umlFOBIvwAggszV/6qiEinCKC
         CiQg==
X-Gm-Message-State: AOAM530VlTS91iOIYzj3XoJ0ugnIeOtamw7g3ZZ4Xn3YfPXfWs6b2E6f
        JMPHm40CPW/TBcIwcW3QXIC4isc4nM/ffuaJSBpdpw==
X-Google-Smtp-Source: ABdhPJwz6yENj2y8K/FpntE1vVdEoo9Hlu/InjhOl3IHHroClIIzl9wqgwX6Lws/MIN0QK7G30gGj1KEEtX7j/G9l0Q=
X-Received: by 2002:aa7:d688:: with SMTP id d8mr9430332edr.168.1598347092000;
 Tue, 25 Aug 2020 02:18:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegtA-16EFFoqhn25rVmXat5hhNUTAWOf+hJEs5L910oQzA@mail.gmail.com>
 <CAOQ4uxj0SF1VRbMEvVm4a9TuUtdMYuZqFkZhkUyEGMagCWk5NA@mail.gmail.com>
 <87a6yknugp.fsf@redhat.com> <CAOQ4uxg4xmvsoKVBfGJ0SVCXfM6aeNji6c8FSCevxV-FYX3LtQ@mail.gmail.com>
 <874kosnqnn.fsf@redhat.com> <CAJfpegvaUz_M0jtibOk=a6Cx=U9JBnOcVSmF2xM9cyVmCz8CFg@mail.gmail.com>
 <20200824135108.GB963827@redhat.com> <CAOQ4uxi9PoYzWxKF0c2a9zzxnrZMeB08Htomn1eHjYha-djLrA@mail.gmail.com>
 <20200824210053.GL963827@redhat.com> <CAOQ4uxhvi5wHhPKivrWzOJ8ygyETDVqc4h4MW6uYN=h1T2B+BA@mail.gmail.com>
 <20200825005504.GN963827@redhat.com> <CAOQ4uxjHs96Ehoi6JCTMjgGogUw3hgwPOrUJ73S79y9jU68Hjw@mail.gmail.com>
In-Reply-To: <CAOQ4uxjHs96Ehoi6JCTMjgGogUw3hgwPOrUJ73S79y9jU68Hjw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 25 Aug 2020 11:18:00 +0200
Message-ID: <CAJfpegvqSSeKoMS3Dh7RdFvw18AxhQ-ct91hmMdoskB6qTw9ww@mail.gmail.com>
Subject: Re: [PATCH v5] overlayfs: Provide a mount option "volatile" to skip sync
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Aug 25, 2020 at 7:31 AM Amir Goldstein <amir73il@gmail.com> wrote:
>

>
> I agree.
> Miklos accepted $workdir/work/incompat/volatile/dirty.
> I assume the name 'dirty'/'donotremove' is not an issue.
> It's simple.
> Let's go with that.

Yes, $workdir/work/incompat/volatile/dirty is good.

If exists, fail to mount overlay on new kernel (regardless of
"volatile" option); warn + r/o mount on old kernel.

In case mounting as "volatile", create it.

In no case does the kernel need to remove it.

Thanks,
Miklos
