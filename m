Return-Path: <SRS0=ehig=C6=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFD53C43463
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Sep 2020 09:09:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FEDF20773
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Sep 2020 09:09:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n+rdN8pY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgIUJJl (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 21 Sep 2020 05:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbgIUJJk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Sep 2020 05:09:40 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBF2C061755;
        Mon, 21 Sep 2020 02:09:40 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id h2so12938671ilo.12;
        Mon, 21 Sep 2020 02:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/sDkrkrhqpXsn1Gqof4RKPAhDHfhg/8IddrNAB2HIEE=;
        b=n+rdN8pYG5NsF+grD9KNE87KmGb5HVSg6YsQhF4zm3d+nenZlVS+XrgcH/o6Ra6YU7
         199bkREPEbRkiC4yX+1c/+l0uvBfeM4PD5tOuDR/lX4lJ/UlmmnRUm3Nm4rJKlQA5iLY
         PKBOTrtix/7EWnj07KvaaPTVVcLO+KgMQIYz47gqG4EWePyrIJqRTIve/noOtXIymRjO
         SzDxiX2/7ngPfpc/ryQr6eQ6hrBZOgNW1QcLQu8Uc6wyVCSeYDz8YZby1oDxcENf9En/
         RTKrRKAPb14IBe7VRGKZYJWCfUcjsZF7Ll/lmcBrBuKBqTGtL/XxREieSuk1Ii9ZaF2f
         xVIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/sDkrkrhqpXsn1Gqof4RKPAhDHfhg/8IddrNAB2HIEE=;
        b=dDXYK4JOJ81Jn648bd4fCiOm4Dv0cMbWN4Y3u4HsCKtEyPXHF2axnu6xMb2sSnVS2S
         2ZNFhgoTLv991XxoG5zeQWKiyoJ9p2zvC3pjYDg7g1wtlBV3D3QTRWyS1P8TSOBa4aY8
         vha3wYzHTnYGOd4E3I8A8FrnHIcIsnbhXfjPo0cyAr7cSalsh2pAuwC90S0npJ3PDk1m
         k3svtDPptbKgD+QcjWDIwEJBrcVTyneB1RI5X7wBhVUWvqNjgrBlyMSJmTJ/+vrrLbsq
         Ak4rrdj+hKvVwLHo6CLhGzxNUrQF/+3tGFozmCwhUHrKyLvEhozQw1tmdQfM6ySyRGhs
         rY8Q==
X-Gm-Message-State: AOAM532YtrIUhqtzJBj1a+QVAuco3DQqu5w9XgCr3qWUGqRf3lARMF0r
        mM879eEez1Zh7vnvVBDq9SCm/ImQ2b7NJ5Giatc=
X-Google-Smtp-Source: ABdhPJwPrs9N3C7D7CaTfCxDYGAMY80U2ZX5M0PTApU6biwp12t8sVVLVCvIzV5PpLCyl9Bws49JRvm6jlqIXFMB0wA=
X-Received: by 2002:a92:d0c7:: with SMTP id y7mr3445665ila.250.1600679379959;
 Mon, 21 Sep 2020 02:09:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200921072127.373125-1-yangx.jy@cn.fujitsu.com>
 <CAOQ4uxitZDVjbvBnb95UHWD6CzaBeoJ8deqR6nbmgRRJ3P2=UA@mail.gmail.com> <5F686A74.4040002@cn.fujitsu.com>
In-Reply-To: <5F686A74.4040002@cn.fujitsu.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 21 Sep 2020 12:09:28 +0300
Message-ID: <CAOQ4uxhfUbFhecA9ShKUxyjS=LsMoyztXwWUJw-ZXm+Z0eJ6DQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: Support FS_IOC_[SG]ETFLAGS and FS_IOC_FS[SG]ETXATTR
 ioctls on directories
To:     Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Sep 21, 2020 at 11:55 AM Xiao Yang <yangx.jy@cn.fujitsu.com> wrote:
>
> On 2020/9/21 16:17, Amir Goldstein wrote:
> > On Mon, Sep 21, 2020 at 10:41 AM Xiao Yang<yangx.jy@cn.fujitsu.com>  wrote:
> >> Factor out ovl_ioctl() and ovl_compat_ioctl() and take use of them for
> >> directories.
> >>
> >> Signed-off-by: Xiao Yang<yangx.jy@cn.fujitsu.com>
> >> ---
> > This change is buggy. I had already posted it and self NACKed myself [1].
> >
> > You can find an hopefully non-buggy version of it on my ovl-shutdown [2] branch.
> >
> > As long as you are changing ovl_ioctl(), please also take the second
> > commit on that
> > branch to replace the open coded capability check with the
> > vfs_ioc_setflags_prepare()
> > generic helper.
> Hi Amir,
>
> Thanks a lot for your quick reply. :-)
> I will try to read and understand the metioned patches on your
> ovl-shutdown branch.

Please also verify my claim in the patch commit message, that the
the test result of xfstest generic/079 changes from "notrun" to "success".

Thanks,
Amir.
