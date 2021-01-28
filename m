Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5487AC43381
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Jan 2021 09:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E2F564DED
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Jan 2021 09:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbhA1J3m (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 04:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232549AbhA1JZc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Jan 2021 04:25:32 -0500
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7207AC0613D6
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Jan 2021 01:24:52 -0800 (PST)
Received: by mail-vs1-xe36.google.com with SMTP id f22so2637562vsk.11
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Jan 2021 01:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GHgde08YkihGYxHTbnxlFJwIttXp2qz+uYdm53xlAT4=;
        b=lDQs77Ksf73bSwPXA9E2WA5oTAUZ+Br+FOBqtmCiRtAIvgcqf5HoCZC5FLK11gUdD2
         SjpJVSYn6Xb1jqqq5Mcx+sB8yHcmKQZjspJ8++fVP/IuOPMkvnJIRrnS8fh+GPHuoJPb
         XUNt6Zyd6T8tqbzF9iG5x1b+/ORpq6wtZl14g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GHgde08YkihGYxHTbnxlFJwIttXp2qz+uYdm53xlAT4=;
        b=A8rCX+xVVObkW+apo2/HdHGjXQebslza2vDVDm4M9GCfQ4x/nkdVoJY5SFcUo0yNVb
         pkUVv9STPVrd/k1g5+aBETAbgayxw12GIDUZNp4uEQ/xsruRKUfsb1ztN+orIB4tJ3fw
         zAkh98JZygclZbhhZ5PJmyznRr/nWkNZPhWkK0mSX2wh2Gy10D/eW/gcNAyNYOlnqSY/
         SGK/o8qVNFqyGeHehZ5rnTyrX3E9c7c7N0rN1misGiEDOVKvZbQkRXes8iAJKhIauMv5
         asWDU6sjvFaYKxd6YmZg5qFQ/Lg1MxaoaLYNjImdxvKzWa3uTiS2HWsHJGOuwU61NBLw
         RwWg==
X-Gm-Message-State: AOAM533SC44mTwkgvNSJ8ZqFQP2hPNgOEGJw5tUoW6mYTLbvmOTDWPwU
        R+b6Ozo4Z1nyHLoqEhoajnFT0Kdp/A3ZKMO1pOE8Bw0fLaA=
X-Google-Smtp-Source: ABdhPJyPTl5bH3lfTpDfkrqkUAKgqjcglCnYbZzblm9bNof5Bi1KKaWCx/8J6oUTNoxDGGGapo/dfGpTPWoyagYRw0Q=
X-Received: by 2002:a67:fb86:: with SMTP id n6mr11129780vsr.0.1611825891738;
 Thu, 28 Jan 2021 01:24:51 -0800 (PST)
MIME-Version: 1.0
References: <20210126165102.1017787-1-amir73il@gmail.com>
In-Reply-To: <20210126165102.1017787-1-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 28 Jan 2021 10:24:40 +0100
Message-ID: <CAJfpeguK98nVOt9EM0MQMEfWGgCr3CT1Sh=YM+ea8OBHU+F2YQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix fd leak in ovl_flush()
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jan 26, 2021 at 5:51 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Miklos,
>
> This patch is against overlayfs-next which currently fails xfstests.


Thanks, folded and pushed out.

Miklos
