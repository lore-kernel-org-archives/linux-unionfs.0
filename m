Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49588C432BE
	for <linux-unionfs@archiver.kernel.org>; Wed, 18 Aug 2021 15:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CDCA604D7
	for <linux-unionfs@archiver.kernel.org>; Wed, 18 Aug 2021 15:03:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239630AbhHRPER (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 11:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239752AbhHRPEO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Aug 2021 11:04:14 -0400
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AE3C0613D9
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Aug 2021 08:03:39 -0700 (PDT)
Received: by mail-ua1-x92a.google.com with SMTP id u39so1097720uad.10
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Aug 2021 08:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6OCLZQBwVcpLwcY/DKCJmIdalTErEPwaknULWqkTgYU=;
        b=XFzYhjc12V3mkhM5uroFJxJTQx2njr5xJq4zJ0RaA83UeTJZTMx7hxBZFCPybq/C7s
         eCClrNbsgsgbxrW9WBrUg/y/n8AUyzHDgjnxdpFtPrtIu9b2WP0aOryWMumLrOjaKFVL
         pXkg/VmXgIvbmuyfEFvedk07te9ttq7YgUUR8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6OCLZQBwVcpLwcY/DKCJmIdalTErEPwaknULWqkTgYU=;
        b=FySn8tJ00UsgbaEHnLGUbDuP4JtT5Jr8mb0ow+F0RC6UV+i8K44Y+niz7rJel3KfnO
         XxmpAw+Ezq/m4Ww65dEqBLhqvM8sws0Z1G2emUgNcw1oK669NoKrFuXM5HBVCnAlg+mD
         JtXWMTtFoyokpPxK/nmv8VtPrmAh+P1f503mWEPkgLZZZzPYjj6pJ1F7TLNj95H7AV+y
         0GxYs2ZD4WK1rpzXIWrp/23pgSbf/hcTYebVSNoYZbBVRWykcxJJJ5iKTsEpr65IzY97
         qsCZfBssuJFLs2c0sMmEHjB6PJmYnyn6zvD/zKYENIKruvGV78qCK3Box6C107oUqLbk
         P4uQ==
X-Gm-Message-State: AOAM530xkYwtT7Hvcc/vUZSt178mWzM2kO5MUVFmhXCkxmxmmr6KoC8A
        ym1S2HC19UPcbSLS9L0w6ww1J1ua9kSlqETga0yhd+d+kYs=
X-Google-Smtp-Source: ABdhPJyDTknAMeyHz6aoQlgvyjbpcWmvkXnm1pMSL/rA6R5TLhjnybHbvy47eIc1Q6xlHDljffCdNY/dyRXZ5BoDizo=
X-Received: by 2002:ab0:36ae:: with SMTP id v14mr6764417uat.8.1629299018623;
 Wed, 18 Aug 2021 08:03:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210818133400.830078-1-mszeredi@redhat.com> <YR0YiSP3DliPCPWF@zeniv-ca.linux.org.uk>
In-Reply-To: <YR0YiSP3DliPCPWF@zeniv-ca.linux.org.uk>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 18 Aug 2021 17:03:27 +0200
Message-ID: <CAJfpegsSQv5im4KRN3EfryyNy6aq9eRPPgL_K-1Knj+qtXiaQg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] allow overlayfs to do RCU lookups
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, 18 Aug 2021 at 16:27, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Wed, Aug 18, 2021 at 03:33:58PM +0200, Miklos Szeredi wrote:
> > I'd really like to fix this in some form, but not getting any response
> > [1][2][3].
> >
> > Al, Linus, can you please comment?
> >
> > I'm happy to take this through the overlayfs tree, just need an ACK for the
> > VFS API change.
>
> Looks reasonable enough; I'm not too happy about yet another place LOOKUP_...
> details get tangled into, though.  Do we want it to be more than just a
> bool rcu?

I'd be fine with that change.   Calling with false/true is less
descriptive than calling with 0/LOOKUP_RCU but I guess we can leave
the actual calls to use the latter?

Thanks,
Miklos
