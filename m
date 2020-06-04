Return-Path: <SRS0=s+il=7R=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7B85C433DF
	for <linux-unionfs@archiver.kernel.org>; Thu,  4 Jun 2020 09:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5D78206C3
	for <linux-unionfs@archiver.kernel.org>; Thu,  4 Jun 2020 09:39:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="QYPuNXUX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgFDJjh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 4 Jun 2020 05:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgFDJjh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jun 2020 05:39:37 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07610C03E96D
        for <linux-unionfs@vger.kernel.org>; Thu,  4 Jun 2020 02:39:37 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id t21so1450501edr.12
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jun 2020 02:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J7btnW3tsRxnIcXWy64DJz6nFcHS2EOi2Wpoy2UuEWQ=;
        b=QYPuNXUXgWjqVo65fdSoRHO9CgkgNI76FQMpdvgcNSunnwsKIobrL81g/G/D3F14GA
         xtaIXdN6O9X9bBEBEn4ru62fmVgnFkVqcDxfiNG87C+lwW8+tLFRSV7Btz2DGPiAuLyO
         D+z6aFktaf7jWvDMeM8FMthrfku1de5uPqUPQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J7btnW3tsRxnIcXWy64DJz6nFcHS2EOi2Wpoy2UuEWQ=;
        b=XhwNns1c5Nr5k/L4dLrFwMW5IPWu3709RnBL2W6nQY0nEV+ksWLsQq7HI/de2TKAW6
         hZnPjZdHSPgC37LuHxgDw2B/EgbJJPtvwg/B9bHCaeie3tp+MhC/kNkqEVI9yLcrUG1y
         oxvtIGt8F6L3Bo0uiMFPe/UFYWH3VhkWWVwKjEub3lBl550HZgYJwoKVzZXYyHp6KHij
         cKV/htraquxfdx0DhKeRDH1U63RRLt/6cHaiSzzxbIV8BcFfExQRcsGZvHqoSHLIZEzQ
         5HkImcu9Fks2DK5NqBO19Y/sz2WOBpENR49JbwWrrGWBXL7n4IB+FQQNk7DZhh8SQGSP
         OH0A==
X-Gm-Message-State: AOAM533ZHs2iJ7c4m3qdyZq5jDdsEAW+kQEtIW+YZUKG+2Do9LfNIQHW
        e3Rgzk0upBM6VirYu8ikja18bBcwief4yvt6KCty5w==
X-Google-Smtp-Source: ABdhPJxKDysyrZZSn8pqHQJgaPL3tRQPi8ZTv3ZfjwOOzrRG9lOPs9ai1Upz60g4bD+J/4yiv2Uy2btGEws69dG3mnk=
X-Received: by 2002:a50:ee8f:: with SMTP id f15mr3506384edr.168.1591263575775;
 Thu, 04 Jun 2020 02:39:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200603154559.140418-1-colin.king@canonical.com>
 <CAOQ4uxhLW=MSk=RhUi51EdOticfk1i_pku6qjCp2QpwnpyL5sw@mail.gmail.com>
 <1edc291d-6e63-89d8-d48c-443908ddc0e8@canonical.com> <CAJfpegsyGmJYHJr8rmRTxScYGyNQ1ZdPMxprW1zoQmGhXg1wuA@mail.gmail.com>
 <78e9b4ed-f530-1fd0-07a2-aca5245a6bd8@canonical.com>
In-Reply-To: <78e9b4ed-f530-1fd0-07a2-aca5245a6bd8@canonical.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 4 Jun 2020 11:39:24 +0200
Message-ID: <CAJfpegvnMrYdn0pqZLK7BaPmfwd_8Xf=vECd3GVDa6++bh9D7Q@mail.gmail.com>
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

On Thu, Jun 4, 2020 at 11:27 AM Colin Ian King <colin.king@canonical.com> wrote:
>
> On 04/06/2020 08:25, Miklos Szeredi wrote:
> > On Wed, Jun 3, 2020 at 6:15 PM Colin Ian King <colin.king@canonical.com> wrote:
> >>
> >> On 03/06/2020 17:11, Amir Goldstein wrote:
> >>> On Wed, Jun 3, 2020 at 6:46 PM Colin King <colin.king@canonical.com> wrote:
> >>>>
> >>>> From: Colin Ian King <colin.king@canonical.com>
> >>>>
> >>>> There are two error return paths where the call to path_put is
> >>>> dereferencing the null pointer 'stack'.  Fix this by avoiding the
> >>>> error exit path via label 'out_err' that will lead to the path_put
> >>>> calls and instead just return the error code directly.
> >>>>
> >>>> Addresses-Coverity: ("Dereference after null check)"
> >>>> Fixes: 4155c10a0309 ("ovl: clean up getting lower layers")
> >>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> >>>
> >>>
> >>> Which branch is that based on?
> >>> Doesn't seem to apply to master nor next
> >>
> >> It was based on today's linux-next
> >
> > Yeah, it's actually
> >
> > Fixes: 73819e26c0f0 ("ovl: get rid of redundant members in struct ovl_fs")
> >
> > So I'll just fold your patch.  There's still a change in the loop
> > count for later errors, but that's okay, since
> > ovl_lower_dir()/ovl_mount_dir_noesc() use the path_put_init() variant.
> > Actually ovl_lower_dir() can get rid of that path_put_init()
> > completely, since now the only caller will take care of that...
> >
> > Thanks for reporting!
> >
> > Miklos
> >
> Is there a reason for folding the fix and hence losing the Signed-off-by
> tag?

I generally prefer to fold small fixes for not yet merged patches.  In
this case it's more of a personal preference, but in other cases it
might have an effect on bisectability.

Thanks,
Miklos
