Return-Path: <SRS0=KPW4=65=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68227C433DF
	for <linux-unionfs@archiver.kernel.org>; Fri, 15 May 2020 07:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D0D720657
	for <linux-unionfs@archiver.kernel.org>; Fri, 15 May 2020 07:30:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dWNFDS7D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgEOHaj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 15 May 2020 03:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726728AbgEOHaj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 15 May 2020 03:30:39 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E74C061A0C;
        Fri, 15 May 2020 00:30:39 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id f3so1640417ioj.1;
        Fri, 15 May 2020 00:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GSOGA9oY6PhSkFDJgxOPuxZvr89fNX8TEDhZGCvMbyw=;
        b=dWNFDS7DtYo+kufBRvDeEG+f/mwi+gVKaEGQWhHTkKETRZxEmSmuj/NrUxBqrZF2CI
         RV3HP7HubGgL/aV7J1BC7u1I7e0w5KIGgk77K84EV19yVzfjvSnneigR3wtvZh95IiT/
         jMqafFetHnyaI1xUF4AgtZRmSONxqKbPPdf4kwhveazBm5+QnKGsY4UNC5OfzxIDkray
         IwZazhGt3GRt0yeF12IETnYVov0Hh7k1pnB5yn17/8oS7u1eMsIgHGyOfpkonwWSt1y6
         +6P/bf77BVGaBuY2V02geBvd6ZbTN0LhHz4Sa6VWN4F7ESWMOZN4Gy/gfsYJYbemB0tu
         KUxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GSOGA9oY6PhSkFDJgxOPuxZvr89fNX8TEDhZGCvMbyw=;
        b=ko/LLa21/Eh2/IJyEC3X8wwzNr0umN2dINcnHbcjo867JzJwzkqwUgTtIfQUELPkIf
         YyM4Q+a+GNlZD2uY1TQmHtfu53S1WVB7MArAdYZqSNwJnTaoTLUuSRf8btM/OoRpXlOE
         f94XUaMSIU6YFNe8PXFnT4QnRciNJeScOhsm+BpnOuZN1yepTdH9WTZrLI8dhQS8dnbd
         0vfqvmb2khITpeHLsKMO/yKW2qAA4HQLdS7Vaiu7LTQtLWNBOftm7Ej4zOps0WKfJETk
         gMpprOwEeikzruyC6aIXHfu30KlUVE+idE2Ok5IVfGQlZpDSI5hi67hL+2Z1mCCu5YUY
         JC9A==
X-Gm-Message-State: AOAM533FRH/MAGDwFk2rUJ7t9N8Od6x/hRTOmha9vAX2FV1DrTdr0i/q
        BQpVwi2sgPsrcOiVC/DQ6oB2/OpRfw8JEnSPvkY=
X-Google-Smtp-Source: ABdhPJxOn0vNBfq4hMwCoOCVJ7Je9QWR0qH2VcdDZ8S3v1RGB6PQHf33ZMyqlnSr6aDh2uSrI8BeKEqQSOrYy84caZs=
X-Received: by 2002:a5d:8417:: with SMTP id i23mr600573ion.186.1589527838729;
 Fri, 15 May 2020 00:30:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200515072047.31454-1-cgxu519@mykernel.net>
In-Reply-To: <20200515072047.31454-1-cgxu519@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 15 May 2020 10:30:27 +0300
Message-ID: <CAOQ4uxhytw8YPY5WR+txeeHhuO+Hvr0eDFuKOahrN_htXtH_rA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/9] Suppress negative dentry
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, May 15, 2020 at 10:21 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> This series adds a new lookup flag LOOKUP_DONTCACHE_NEGATIVE
> to indicate to drop negative dentry in slow path of lookup.
>
> In overlayfs, negative dentries in upper/lower layers are useless
> after construction of overlayfs' own dentry, so in order to
> effectively reclaim those dentries, specify LOOKUP_DONTCACHE_NEGATIVE
> flag when doing lookup in upper/lower layers.
>
> Patch 1 adds flag LOOKUP_DONTCACHE_NEGATIVE and related logic in vfs layer.
> Patch 2 does lookup optimazation for overlayfs.
> Patch 3-9 just adjusts function argument when calling
> lookup_positive_unlocked() and lookup_one_len_unlocked().

Hmm you cannot do that, build must not be broken mid series.
When Miklos said split he meant to patch 1 and 2.
Patch 1 must convert all callers to the new argument list,
at which point all overlayfs calls are with 0 flags.

Once that's done, you may add:
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
