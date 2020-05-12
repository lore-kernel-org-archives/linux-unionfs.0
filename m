Return-Path: <SRS0=bzPr=62=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E425CA90AF
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 May 2020 16:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08A85206B9
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 May 2020 16:56:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QzHJnkhQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgELQ4s (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 May 2020 12:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgELQ4s (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 May 2020 12:56:48 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57634C061A0C;
        Tue, 12 May 2020 09:56:48 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id 79so5584930iou.2;
        Tue, 12 May 2020 09:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hogq62i1U88Kidb6dDDuJQM7H4n4/5gG6rcAr56z2VE=;
        b=QzHJnkhQ8+zJkh7Qe+OyaNmHimoPG+wAraH9SFn2hpB+ppSqzLkJm1FbJuR0qPn19i
         IUgxnB+ScEfd0gXjUPVm/ij5tuC0t2aTdjq5ZI2gJL+X6vH2Rbtn/r2aFYNS3CLHh3iz
         OUVIqO4HzAoVWTIqTorxq33sj9QluCchsss3ew2EWfcjAL6liIXkIcRAGy8L/bZggeol
         kAngEo759MBQcTSZ+DT1eTHNRREAEjKPp0ha0z0fMp76YLngQ+xfTE8h3fXSuVWRfgoL
         ObB4Htfcy5GRknTbT+xl+L2vYPbxCr+05p/JhNtaTFcghb5ZQ6ZY6CPukniYAUpFfuLL
         x3Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hogq62i1U88Kidb6dDDuJQM7H4n4/5gG6rcAr56z2VE=;
        b=g8ugr+U9fJioLBbCnf4izFmp8G5YZtj3mISGmt/l1eD3mhFfvmswQIpMsQoOV5pRl6
         YylrjKIh27Eonov3c56TJ4cx50baa9DWWGFcw2ZUzTQPb4XqIJpTHTZyUj2wmOWji4IX
         HI2wB/4e+TLeVA1ossbh1eK5/OaT+UozRrG+ZAS5tnm1PGhUanAmghiWaf8SGzXg7Vpl
         K26Dq62UIXNCsO1vhir0kOMxFg1FKM2vEpap1/pyWPbvxgKhgr3nOqgZa0eSBNgpkV/v
         fBmyX/2vPhfwtGUbpGmnKK/2kvCl6vnSprD5Ehu8cbZe+zSp1lcvXlyz9K/y9QFM+Mdr
         bXEQ==
X-Gm-Message-State: AGi0PuaFPmXyERiDaOvYv9hO9S92C2Y1fzZ2x7HqHLMjfkxrEE7W3jiW
        51nKNWSQFFHDblEdRQW0ZAe8bJABzpEQC75yGQI=
X-Google-Smtp-Source: APiQypL7oNvoPj0SWQ71NokbnD2E7sLnXKIMzemRpkGm+zdPtultSTBQXb55a+hz5EXsone7mgtt2OwKBCSTcWsosWI=
X-Received: by 2002:a5e:840d:: with SMTP id h13mr11392733ioj.64.1589302607727;
 Tue, 12 May 2020 09:56:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200506101528.27359-1-cgxu519@mykernel.net> <20200510155037.GB9345@desktop>
 <172015c8691.108177c8110122.924760245390345571@mykernel.net> <20200512162532.GD9345@desktop>
In-Reply-To: <20200512162532.GD9345@desktop>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 12 May 2020 19:56:35 +0300
Message-ID: <CAOQ4uxiFPrMWrhqjPo3PcgKFiKwSKfh7p+f5hM5fZYKr51HEWA@mail.gmail.com>
Subject: Re: [PATCH v4] overlay: test for whiteout inode sharing
To:     Eryu Guan <guan@eryu.me>
Cc:     Chengguang Xu <cgxu519@mykernel.net>, miklos <miklos@szeredi.hu>,
        fstests <fstests@vger.kernel.org>,
        linux-unionfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> >  > I see no feature detection logic, so test just fails on old kernels
> >  > without this feature? I tried with v5.7-r4 kernel, test fails because
> >  > each whiteout file has only one hardlink.
> >
> > That's true.
>
> I'd like to see it _notrun on old kernels where the feature is not
> available. But that seems hard to do.. Do you have any better ideas?
>

I've got a few.
1. LTP has the concept of require minimum kernel version.
    This would mean that functionality will be not be tested if feature
    is backported to old kernels.
2. We could add to overlayfs advertising of supported features, like
     /sys/fs/ext4/features/, but it already does "advertise" the configurable
     features at  /sys/module/overlay/parameters/, and we were already
     asking the question during patch review:
        /* Is there a reason anyone would want not to share whiteouts? */
        ofs->share_whiteout = true;
     and we left the answer to "later" time.

So a simple solution would be to add the module parameter (without adding
a mount option), because:
- It doesn't hurt (?)
- Somebody may end up using it, for some reason we did not think of
- We can use it in test to require the feature

The one non-trivial thing that this will require is to add Documentation
of the module parameter in the section about Whiteouts and opaque directories.

Thanks,
Amir.
