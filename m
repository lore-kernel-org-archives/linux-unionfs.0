Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BC2BC4361B
	for <linux-unionfs@archiver.kernel.org>; Wed,  9 Dec 2020 16:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6975323BE3
	for <linux-unionfs@archiver.kernel.org>; Wed,  9 Dec 2020 16:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731962AbgLIQVi (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 9 Dec 2020 11:21:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731898AbgLIQVf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 9 Dec 2020 11:21:35 -0500
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CCCC0613CF
        for <linux-unionfs@vger.kernel.org>; Wed,  9 Dec 2020 08:20:54 -0800 (PST)
Received: by mail-vs1-xe43.google.com with SMTP id j140so1187594vsd.4
        for <linux-unionfs@vger.kernel.org>; Wed, 09 Dec 2020 08:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ftrjIMacRnCDUW60B5wDdWIgLtC6j6ITMAxZ0z4dcsk=;
        b=HgrvSW72NUDBACx2rcJOdsk9j2ywqmTiRhxzfml2ObmeS9/p68ApjmmEUiVuFFixel
         U8V/3sWV/jT/RnYtuN76/jqqa0beH35lqx0GkOdrSQB8kmGRwv6xH/mpxgBW9stqYh98
         TB1KeZ8zKUBTeHyC8I0eCxJ7EFkcfOUQYVVWk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ftrjIMacRnCDUW60B5wDdWIgLtC6j6ITMAxZ0z4dcsk=;
        b=QRNOUB8NWLJh0VQV0ODHah8Sj79EVPHHCLXZC1cCL/kvGtuWFjysd4Frtym3mNTs93
         vgX5hpqoN1/I/4pcK9nuhqmGreosVqNWY45ta3K/+SByZ2UvLyvqVBvCJSHIo+i4d4FD
         I9B+aQ5FNtbyHzpQUo9mkNFesS7jdmLLVe14ndPgiMIBzg5yKu/V8qXh1y/ckJOHjZup
         fEdw+d3aRzDit1pHu+kc+eRg+oTeHP1/4Cu5+i150YIlNgaz38yjc+3mXOpmLSruaZ0w
         eLaKGFVn+kxUc9oZAdsflYN/h5eai/5vmqaeS8CmX8slW6YzLTLm1P/5dSeSu87gyglr
         oA8A==
X-Gm-Message-State: AOAM533LCPJDmV9X+P0ICv1Oi9cuzrTC5Ku6I3UYkePDXZkEXIgDq4rF
        AaeDy0hr+uAlX2Zha4fN7abYEwdUD1/8+sXEptuh+w==
X-Google-Smtp-Source: ABdhPJzZZ3IkQz7rOL8NyykGCELcBs/amTcJ+Xv2OgUQT+RVIeDoKVuHGvs38tWdvxSIhPXmjhSG0BuRFZBayhnap/U=
X-Received: by 2002:a67:ed57:: with SMTP id m23mr2755029vsp.7.1607530854236;
 Wed, 09 Dec 2020 08:20:54 -0800 (PST)
MIME-Version: 1.0
References: <20201207163255.564116-1-mszeredi@redhat.com> <20201207163255.564116-4-mszeredi@redhat.com>
 <CAOQ4uxhti+COYB3GhfMcPFwpfBRYQvr98oCO9wwS029W5e0A5g@mail.gmail.com> <CAJfpegsGpS=cym2NpnS6H-uMyLMKdbLpE1QxiDz4GQU1s-dYfg@mail.gmail.com>
In-Reply-To: <CAJfpegsGpS=cym2NpnS6H-uMyLMKdbLpE1QxiDz4GQU1s-dYfg@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 9 Dec 2020 17:20:43 +0100
Message-ID: <CAJfpeguvt-Mia9YmT55q3R9tSFocpgq7FzjDKJgnaOEQsaBNVA@mail.gmail.com>
Subject: Re: [PATCH v2 03/10] ovl: check privs before decoding file handle
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Dec 9, 2020 at 11:13 AM Miklos Szeredi <miklos@szeredi.hu> wrote:

> Hard link indexing should work without fh decoding, since it is only
> encoding the file handle to search for the index entry, and encoding
> is not privileged.

Tested this a bit and while hard link indexing does work,  inode
lookup is broken since it uses the origin inode as a key (which is not
available) instead of using the origin value directly.  This is
fixable, but needs a fair amount of restructuring, so let's just
postpone this and disable index for now, as you suggested.

Thanks,
Miklos
