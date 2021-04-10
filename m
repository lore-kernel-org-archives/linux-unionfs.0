Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF001C43460
	for <linux-unionfs@archiver.kernel.org>; Sat, 10 Apr 2021 20:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEDC661027
	for <linux-unionfs@archiver.kernel.org>; Sat, 10 Apr 2021 20:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbhDJUD4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 10 Apr 2021 16:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbhDJUDz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 10 Apr 2021 16:03:55 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55521C06138B
        for <linux-unionfs@vger.kernel.org>; Sat, 10 Apr 2021 13:03:39 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id f6so8917549wrv.12
        for <linux-unionfs@vger.kernel.org>; Sat, 10 Apr 2021 13:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0UctsG4bXak6mMMEgcxXrMh+zL06FYvDLgkaZaQw7JM=;
        b=gKU09WKVvcNmFW07yvQt0QtvqjCp/9AKgmQFvKUnXyAwNTC7NCxtRw2Eg6Ifp5n3Yq
         T4wC7UwO+AEDfvBdTjhD+F3xxRgTR1mmYnB8sHNFuSm1NIMkVusgnZVcDStjLWGVahqA
         U9X9LsHmEayuo817aI4odU90Zwa7i7UMiAGl1E6+QfhaYJ3NimTGCGBGwBQwvxUolkYb
         3GAwtl8723+i/YiYxZo7alLv0DWldwU/mVYqsukOJKgM3GMlUQNJ2GVymXLv0tkoaB7K
         W66M04vgB4wmsFyI5pPnbzWeCtX8JXgQwb4tK/LQ4yCxwrNY1YzVoZN8n0IGe3mRvWcE
         5ipA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0UctsG4bXak6mMMEgcxXrMh+zL06FYvDLgkaZaQw7JM=;
        b=s4A1KDMHIeECwyXhLcJ0r2BiXNdxB+UiahLrZmsi9uknFqzG5njiGOJtLCSfjrq5hq
         84uYVR7Zrhn1ewzd7abjAuEmh/f9WgWPAFiNls9WOLruh9g8CdfpML2A8HFTFvBztm65
         /eHNMeG0uEmmiRX9EIN4EcMjcG5IuJ92X6ofAuTpsyL1ANUBTvI53T77SYTOrxEsJTVo
         z4ve6+gYDYgFTsQ08Oe4PlNqQja43hc0CrZyDVXfHAHmjgqt9AKLToj8Qiz8Sh1p4/tP
         ac/5iXLnfCaufIK6BF+TxcCWAUwfnuF9w0PyimQorYrTKS094Wl+oOqYF/gDpX48E+ex
         DYJA==
X-Gm-Message-State: AOAM530mHDHOnXbuGs3ryypJTRO/5GIfJOV2EzAhNCAdLqcQKHAwVZ3R
        9iP7UNoARW5jzxqcIejSguWgDWQOq8w2ez4sZsEJCw==
X-Google-Smtp-Source: ABdhPJwDN1LyEX3WLoSkmp6hcjXcR0337kO6ARgrnB4HEkl+URqp+4ezusCeK8E0hFYer6vKIqST9T/9oT69VZfNaOo=
X-Received: by 2002:a5d:610f:: with SMTP id v15mr24049223wrt.236.1618085017879;
 Sat, 10 Apr 2021 13:03:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAJCQCtTp0aXBssEr4ZXGX=DS_+RyGghmoANCKDdxG59QWu8LVA@mail.gmail.com>
 <CAOQ4uxht70nODhNHNwGFMSqDyOKLXOKrY0H6g849os4BQ7cokA@mail.gmail.com>
 <CAJCQCtRGdBzyskifrYLbBGAAm0g7VeC6GeD7xBN-hRqE3GAWYA@mail.gmail.com>
 <CAOQ4uxhU2KX=jKKL5EZ102z_+6KyVKAOoAzSp2K8i0PMGJUg4A@mail.gmail.com>
 <CAJCQCtTHepsUHjCUAwawC6r6txAZ=XypE5rJOizqxMx9zuR4AA@mail.gmail.com>
 <CAJCQCtQshgFBvUF2+DLm0=iHhiONu-QCRnB1uNv2dLigT+WfZg@mail.gmail.com>
 <CAJCQCtTg5Cz_GdSTCX-rZDmoB-PDGr2iV=quPWSofbL-Xixapw@mail.gmail.com> <CAJCQCtQDyOh-EWL2QMMgNQeY6KDpHqducVRpn_63O30KuX2diQ@mail.gmail.com>
In-Reply-To: <CAJCQCtQDyOh-EWL2QMMgNQeY6KDpHqducVRpn_63O30KuX2diQ@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sat, 10 Apr 2021 14:03:21 -0600
Message-ID: <CAJCQCtSC36c5yNo+H2sy0o1f+XerjDSj-KYxPZS4GX6v5czUgw@mail.gmail.com>
Subject: Re: btrfs+overlayfs: upper fs does not support xattr, falling back to
 index=off and metacopy=off.
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Keeping everything else the same, and only reverting to kernel
5.9.16-200.fc33.x86_64, this kernel message

>overlayfs: upper fs does not support xattr, falling back to index=off and metacopy=off

no longer appears when I 'podman system reset' or when 'podman build'
bolt, using the overlay driver.

However, I do still get
Bail out! ERROR:../tests/test-common.c:1413:test_io_dir_is_empty:
'empty' should be FALSE


--
Chris Murphy
