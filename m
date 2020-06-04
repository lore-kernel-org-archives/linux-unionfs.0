Return-Path: <SRS0=s+il=7R=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 895B7C433E0
	for <linux-unionfs@archiver.kernel.org>; Thu,  4 Jun 2020 07:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B879204EF
	for <linux-unionfs@archiver.kernel.org>; Thu,  4 Jun 2020 07:25:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="mAa1rRBA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgFDHZR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 4 Jun 2020 03:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbgFDHZR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jun 2020 03:25:17 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0FCC05BD1E
        for <linux-unionfs@vger.kernel.org>; Thu,  4 Jun 2020 00:25:17 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id m21so3803674eds.13
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jun 2020 00:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=miIndVNlOTPdeJt8s3Y3ldTQotNreZeR3Q0h4ZepU7U=;
        b=mAa1rRBAoldVCWaTSzF06cV+P3hcLCX8KkHP3QFGSHokDRK+TWNz503qMs8eIy8HRl
         fcydqW7L8p18rL7w0cBoRhxAq/91+E7ZrXGdqE3h1j3gPL9/MdeL4GkmdDmUPSYbv+aw
         X8jV72IxQ8hMTqSjiFzI50i+CK6/VqJxNN3AI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=miIndVNlOTPdeJt8s3Y3ldTQotNreZeR3Q0h4ZepU7U=;
        b=ar615ixYXXDFmIZtqFvkgHCki1yzomKm72y+a4MM52QfKRBtb45cggAPt2Iscf5abM
         EwdLUoO1p5yYCtETAhU3hwf0R9Ytz6jrVsxnC6HMES9CXymha4OzepC1N2XadkNgxtiq
         +ElLdqD5A7niguSlwdybnvDtJDbmpJ4RaQMBTEEOZinfi/R5P6cxGsDQItCrwubjcRx1
         KQYjZTgnaFrHwynIQONqkzhT3QfB3T4yC0kMh/2kkuN620kpom+cWIG0guOwbkCO5Ic2
         aEXOmeXKjk6Fbyz/iDXaqefwbxdrYyv4lml0MP6vKKnHW7ImZpD+CWprWHUdmXm6xNTb
         xDSA==
X-Gm-Message-State: AOAM5326PP5xfG/dxB1fCg1VHmppxgQrGVik5oTVg7L9a+H4GI1A91xc
        m7dDs4tpkqr6c+kROUuukCUQEcaB0WLC6M7COxEh6g==
X-Google-Smtp-Source: ABdhPJy196feg+e19ifx4UwsjmKKOofjRgAL7oGRoAPn8XgKYTEE6MUuhlg0mZVqYI0t7eU13zZC37ZwyECruh3x8Cc=
X-Received: by 2002:a50:d499:: with SMTP id s25mr3137029edi.161.1591255516019;
 Thu, 04 Jun 2020 00:25:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200603154559.140418-1-colin.king@canonical.com>
 <CAOQ4uxhLW=MSk=RhUi51EdOticfk1i_pku6qjCp2QpwnpyL5sw@mail.gmail.com> <1edc291d-6e63-89d8-d48c-443908ddc0e8@canonical.com>
In-Reply-To: <1edc291d-6e63-89d8-d48c-443908ddc0e8@canonical.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 4 Jun 2020 09:25:04 +0200
Message-ID: <CAJfpegsyGmJYHJr8rmRTxScYGyNQ1ZdPMxprW1zoQmGhXg1wuA@mail.gmail.com>
Subject: Re: [PATCH][next] ovl: fix null pointer dereference on null stack
 pointer on error return
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jun 3, 2020 at 6:15 PM Colin Ian King <colin.king@canonical.com> wrote:
>
> On 03/06/2020 17:11, Amir Goldstein wrote:
> > On Wed, Jun 3, 2020 at 6:46 PM Colin King <colin.king@canonical.com> wrote:
> >>
> >> From: Colin Ian King <colin.king@canonical.com>
> >>
> >> There are two error return paths where the call to path_put is
> >> dereferencing the null pointer 'stack'.  Fix this by avoiding the
> >> error exit path via label 'out_err' that will lead to the path_put
> >> calls and instead just return the error code directly.
> >>
> >> Addresses-Coverity: ("Dereference after null check)"
> >> Fixes: 4155c10a0309 ("ovl: clean up getting lower layers")
> >> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> >
> >
> > Which branch is that based on?
> > Doesn't seem to apply to master nor next
>
> It was based on today's linux-next

Yeah, it's actually

Fixes: 73819e26c0f0 ("ovl: get rid of redundant members in struct ovl_fs")

So I'll just fold your patch.  There's still a change in the loop
count for later errors, but that's okay, since
ovl_lower_dir()/ovl_mount_dir_noesc() use the path_put_init() variant.
Actually ovl_lower_dir() can get rid of that path_put_init()
completely, since now the only caller will take care of that...

Thanks for reporting!

Miklos
