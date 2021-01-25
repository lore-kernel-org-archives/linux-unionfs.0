Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A9E5C433E0
	for <linux-unionfs@archiver.kernel.org>; Mon, 25 Jan 2021 13:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D60642087E
	for <linux-unionfs@archiver.kernel.org>; Mon, 25 Jan 2021 13:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729054AbhAYNsw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 25 Jan 2021 08:48:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58673 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729059AbhAYNsH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 25 Jan 2021 08:48:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611582375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g+lH4jVBEWj7kNZTyZRP0Sg2RcVoDFoIqR+KnfPse8w=;
        b=Quhl5Mqly2kujXVcjuNre/spHkyR56pwcDjrDnWP4hi1m3NGSBOsehJufKLpkIcAp3dJHB
        LTl/7as29bmFPhZ38CQFofGddVRoSDwHxeJ9kK9McH0fntIBBqnXJU3rNdDJIBEvGsBcyv
        ll6M5Z/q0jtiaEVQ0Tf5vkzuBvufMJA=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-vHkBZSzMMNe3BjLf9NxlbA-1; Mon, 25 Jan 2021 08:46:13 -0500
X-MC-Unique: vHkBZSzMMNe3BjLf9NxlbA-1
Received: by mail-qv1-f71.google.com with SMTP id c3so9192353qve.15
        for <linux-unionfs@vger.kernel.org>; Mon, 25 Jan 2021 05:46:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g+lH4jVBEWj7kNZTyZRP0Sg2RcVoDFoIqR+KnfPse8w=;
        b=G/O7pDXmBB2Guqcd1fpL3z1eCTxwS0JRLSIarTRgqiL+nyuOCmfO6hgbDernq6NUlE
         Oy/622wiRqFJdnIq5SFtQkfMN3d87uxsZF1YdpmFjS/5jJBbw2UWYUNm5yy6LOr/MVUI
         bVms4b9q6XEHDqlBxevn8cGpLamlEsN+kb72LYF6ahl+/7MkMvbTxtgLbERIU1YuHI07
         zFM5ZInUH04GCdPzug0vsTBpA2tBhADXSQHVI8JsQtA/8ObVWbXkjW4QmKGTvN2Zd+LE
         5e2NSsZks9EAgYPHOV1WRwm4dpjOlVaq4JJuQ5bkWkyF0/xnSlL6X561jKl+D0Wq2qHS
         PHsg==
X-Gm-Message-State: AOAM531EhMDGzNXwGK9rRZgxvc9IhETP2Bo+zauQ6yRUE/sPNpAvBKgQ
        o9c1gIKOP/Lbv8xdFqtFGkFvLCX4m7nl93onfMTAMvH0jgwAHOXAo6yikv282rfNHpZtK34UCII
        qydxAztPKvrTDVnjPSW2BmEiaX9K59TwV1+cfOdHsUg==
X-Received: by 2002:a05:620a:24cd:: with SMTP id m13mr708436qkn.273.1611582372374;
        Mon, 25 Jan 2021 05:46:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzGFrUDAGOGavT1DgCTfWNXl/5gNkCr9sSWhUA52UIjWH/BAh3BdpRyQaPXiC8jDJV9kH2sQ3NHpmwBPpiZwxY=
X-Received: by 2002:a05:620a:24cd:: with SMTP id m13mr708419qkn.273.1611582372176;
 Mon, 25 Jan 2021 05:46:12 -0800 (PST)
MIME-Version: 1.0
References: <20210119162204.2081137-1-mszeredi@redhat.com> <20210119162204.2081137-2-mszeredi@redhat.com>
 <20210122183141.GB81247@sequoia> <CAOssrKd-P=4n-nzhjnvnChbCkcrAaLC=NjmCTDRHtzRtzJaU-g@mail.gmail.com>
In-Reply-To: <CAOssrKd-P=4n-nzhjnvnChbCkcrAaLC=NjmCTDRHtzRtzJaU-g@mail.gmail.com>
From:   Miklos Szeredi <mszeredi@redhat.com>
Date:   Mon, 25 Jan 2021 14:46:01 +0100
Message-ID: <CAOssrKd04WaFjM1=qyUVnxwM9k_4Mc=OvvuCeN9HvYJnq91wWA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ecryptfs: fix uid translation for setxattr on security.capability
To:     Tyler Hicks <code@tyhicks.com>
Cc:     "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-security-module@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Serge E . Hallyn" <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jan 25, 2021 at 2:25 PM Miklos Szeredi <mszeredi@redhat.com> wrote:
>
> On Fri, Jan 22, 2021 at 7:31 PM Tyler Hicks <code@tyhicks.com> wrote:
> >
> > On 2021-01-19 17:22:03, Miklos Szeredi wrote:
> > > Prior to commit 7c03e2cda4a5 ("vfs: move cap_convert_nscap() call into
> > > vfs_setxattr()") the translation of nscap->rootid did not take stacked
> > > filesystems (overlayfs and ecryptfs) into account.
> > >
> > > That patch fixed the overlay case, but made the ecryptfs case worse.
> >
> > Thanks for sending a fix!
> >
> > I know that you don't have an eCryptfs setup to test with but I'm at a
> > loss about how to test this from the userns/fscaps side of things. Do
> > you have a sequence of unshare/setcap/getcap commands that I can run on
> > a file inside of an eCryptfs mount to verify that the bug exists after
> > 7c03e2cda4a5 and then again to verify that this patch fixes the bug?
>
> You need two terminals:
> $ = <USER>
> # = root
>
> $ unshare -Um
> $ echo $$
> <PID>
> # echo "0 1000 1" > uid_map

NOTE:  <USER> is assumed to have uid=1000, so this and following
"1000" values need to be fixed up if it's not the case.

Thanks,
Miklos

