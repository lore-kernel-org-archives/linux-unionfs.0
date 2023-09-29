Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B9ADE743E6
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 Sep 2023 04:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbjI2EoY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 29 Sep 2023 00:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbjI2EoY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 29 Sep 2023 00:44:24 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5A81A2
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Sep 2023 21:44:21 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id ada2fe7eead31-4547428694dso604975137.3
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Sep 2023 21:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695962661; x=1696567461; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lpLNx2UGqPOc8utP6CPk2rxpv8+oEtZykUprPPJ8ZgA=;
        b=JP8My77p5UAkxp8BuFmvHtIsfHm2MhqTEv68rG8Jb7Xq49JxuE78LZ4oPt17xISaoo
         K9KISKjdNY3H+kFhSsmzZ23U8HSLIGslLWFZgzYcYYRy1+sdINIFC4BYLx4zNLwE9PXN
         7a4oIxMX/mk6p9hZ7NQaO5tg0mwwyE6voqF6g5F0VZise/7xVbaWnJXhUL6ZQOpEOgKL
         KOSE/RzYe8R0D+h7/FFJOq/pdHVJueTOnSQP9owQIjGkMza9LlDaPcoGL7wPPqkmpDFn
         FGStRXraWnnH4fc8K1l+pR39JR9xdWpiXxSSNyp9iO8WDn25zsfya8+OJrq79bP2OWSi
         QPSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695962661; x=1696567461;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lpLNx2UGqPOc8utP6CPk2rxpv8+oEtZykUprPPJ8ZgA=;
        b=PCIbLY45LHkyqbFq+FqT+b7aRxfwazeFH4Jn2ccPRf47rzqDOHaLiQS2YAJRiKqDXR
         cP0SKCWKVAcogvLxayYvNC76X/dcMAtS7yst03Uiiwc0ApAwyAx/EiUWmQbm3eriDmYc
         qcrV37bJKwjnmLRgsfFb/dtW59lVjJvHOwIfaHPvPKa9Jxoi6EQlY9Ur3UROgW2/TzbV
         6mOeO/BDJfrKqpKGtwdS1n+BIH7N1Jtyo29v7Y8HerdMIFu6/HDZkSd5hxReWhENtYnU
         dO0zVkySz25HDk8S3y9bfH17pu+C+sYuv1sGczxMOPjgnpwD8tXuH0YxnySEnhlZLn1k
         x8tA==
X-Gm-Message-State: AOJu0YwUlznQZBsS2NXBoZt947K+cBBtE2DmruUu1qq/4gha3IUXVoag
        ckqmHYyZ12CKObhGO9d1WvuHp4kZsog23Et8CC8=
X-Google-Smtp-Source: AGHT+IEpa5oYlX6pB14Pcmy3OYvpzQ+EFhPsJ4BcAdu5/jXyqikP3JTyL/DmWcie65b9VtDttoCWuAZJlIzACT56wL4=
X-Received: by 2002:a67:fb09:0:b0:452:70f7:ca4a with SMTP id
 d9-20020a67fb09000000b0045270f7ca4amr3006027vsr.34.1695962660858; Thu, 28 Sep
 2023 21:44:20 -0700 (PDT)
MIME-Version: 1.0
References: <8da307fb-9318-cf78-8a27-ba5c5a0aef6d@alum.mit.edu>
In-Reply-To: <8da307fb-9318-cf78-8a27-ba5c5a0aef6d@alum.mit.edu>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 29 Sep 2023 07:44:09 +0300
Message-ID: <CAOQ4uxhQhzv_LUW89m_BmKf+NjE+XDyY9XtLAt+SWG03M6LmYQ@mail.gmail.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
To:     Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>,
        Christian Brauner <brauner@kernel.org>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Sep 29, 2023 at 4:08=E2=80=AFAM Ryan Hendrickson
<ryan.hendrickson@alum.mit.edu> wrote:
>
> Up to and including kernel 6.4.15, it was possible to have commas in
> the lowerdir/upperdir/workdir paths used by overlayfs, provided they were
> escaped with backslashes:
>
>      mkdir /tmp/test-lower, /tmp/test-upper /tmp/test-work /tmp/test
>      mount -t overlay overlay -o 'lowerdir=3D/tmp/test-lower\,,upperdir=
=3D/tmp/test-upper,workdir=3D/tmp/test-work' /tmp/test
>
> In 6.5.2 and 6.5.5, this no longer works; dmesg reports that overlayfs
> can't resolve '/tmp/test-lower' (without the comma).
>
> I see that there is a commit between the 6.4 and 6.5 lines titled [ovl:
> port to new mount api][1]. I haven't compiled a kernel before and after
> this commit to verify, but based on the code it deletes I strongly suspec=
t
> that it, or if not then one of the ovl commits committed on the same day,
> is responsible for this change.
>
> [1]: https://github.com/torvalds/linux/commit/1784fbc2ed9c888ea4e895f30a5=
3207ed7ee8208
>

That's a good guess.
It helps to CC the author of the patch in this case ;-)

> Does this count as a regression?

"used to work, does not work now" is pretty close to a dictionary
definition of a regression :)

The question is whether we should fix it.
The rule of thumb is that if users complain than we need to fix it,
but it's a corner case and if the only users that complained are willing
to work around the problem (hint hint) then we may not need to fix it.

> I can't find documentation for this
> escaping feature anywhere, even as it pertains to the non-comma character=
s
> '\\' and ':' (which, I've tested, can still be escaped as expected), so
> perhaps it was never properly supported? But a search for escaping commas
> in overlayfs turns up resources like [this post][2], suggesting that ther=
e
> are others who figured this out and expect it to work.
>
> [2]: https://unix.stackexchange.com/a/552640
>
> Is there a new way to escape commas for overlayfs options?
>

Deferring the question to Christian.

Thanks,
Amir.
