Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4FA7C7EE29
	for <linux-unionfs@archiver.kernel.org>; Tue, 13 Jun 2023 05:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234109AbjFMFTF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 13 Jun 2023 01:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbjFMFTE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 13 Jun 2023 01:19:04 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A64E78
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jun 2023 22:19:02 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-56d06711fccso20219287b3.2
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jun 2023 22:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686633541; x=1689225541;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jgKvakDEhEGzV06YHsozOqejrE3rMDlfFMcpSiZpB04=;
        b=cx6CHM0Lsdl3w8hA3uIHBk24pHR+g7aBBnE2vYAfps5adpmpPrld928bY6u0sXkApy
         NFDWTo5FaUl1B4ZwojwIp+BTptf8yTz6a9TwETfcEDIz+QUeMDnT+bY3tHl/Gfyg0Rr9
         ve+gdT9PROWl+V+yyQtUSOn+OuJDQ7TTQpNicl2yAHfMIJRhkNUAK86sTixKtlKWnXcE
         nyijnErjeRXXIYcbWJpctkr/EcRG/vTMhmREMCVZObJ0I8Bm8VtKWMoxclJkAD/4/h4f
         sVXWDUqLzb87sWIoR8Nl25myhvF+lbkOLpAH3FPvdaLmPsu3x82cZFif9/FrhtDw3Pqn
         2s6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686633541; x=1689225541;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jgKvakDEhEGzV06YHsozOqejrE3rMDlfFMcpSiZpB04=;
        b=PgZQil0yzMk30+3aWtZZTI6/KdfW7uy3L8/C5xw7/9eQCm117FWboql90rgV3Htqbg
         RjK9YMvFttAUeB9folrFfB1fXA4ukpTu3CDZ1dx2j97OhEqznRevUK53D8WcYBhS4T2m
         TjwQ/TL2csApFuLvfMz9jYWF/VP4V09vVkAgVCVfETn4AlsKdPjph5NqBrboPpTdcr7d
         fI848VvdKeyti4KwQJuT+F0wTY5KnK3959DLWtIew0QbtHNWQ1VaMWUoloKk/dZD1tIs
         I1Hvu9WgQifMk1QmhIrGcKXcRvmFyo3GPuJvVjxCdOSMa5LZ2lISZLDljik2jFaiivl4
         +kEQ==
X-Gm-Message-State: AC+VfDxqYJahzCp0YiGPOlZMFcarh6BmTJc7H675MlW0Wuu+kKQHTCjR
        483Y7LssRfOUeAuZkV9LR0Swzj0ctHCDjIk+VlE=
X-Google-Smtp-Source: ACHHUZ5T+jevThYxjEuz/ujRECT0knXFOba5qJXKxW1rX1miX8BuWlTeElaLZzUYOJ7tVzP65Wgy0H219i9ZaHJbQX4=
X-Received: by 2002:a0d:ca82:0:b0:56d:4f45:a8e5 with SMTP id
 m124-20020a0dca82000000b0056d4f45a8e5mr783494ywd.30.1686633541655; Mon, 12
 Jun 2023 22:19:01 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1686565330.git.alexl@redhat.com> <03ac0ffd82bc1edc3a9baa68d1125f5e8cad93fd.1686565330.git.alexl@redhat.com>
 <20230612163216.GA847@sol.localdomain>
In-Reply-To: <20230612163216.GA847@sol.localdomain>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 13 Jun 2023 08:18:50 +0300
Message-ID: <CAOQ4uxjS5-7_PaoxM41YaXW+KxwLK_K8AyJMaoi1m-3P-vZ9Kw@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] ovl: Add framework for verity support
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Alexander Larsson <alexl@redhat.com>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, tytso@mit.edu,
        fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jun 12, 2023 at 7:32=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Mon, Jun 12, 2023 at 12:27:17PM +0200, Alexander Larsson wrote:
> > +fs-verity support
> > +----------------------
> > +
> > +When metadata copy up is used for a file, then the xattr
> > +"trusted.overlay.verity" may be set on the metacopy file. This
> > +specifies the expected fs-verity digest of the lowerdata file. This
> > +may then be used to verify the content of the source file at the time
> > +the file is opened. During metacopy copy up overlayfs can also set
> > +this xattr.
> > +
> > +This is controlled by the "verity" mount option, which supports
> > +these values:
> > +
> > +- "off":
> > +    The verity xattr is never used. This is the default if verity
> > +    option is not specified.
> > +- "on":
> > +    Whenever a metacopy files specifies an expected digest, the
> > +    corresponding data file must match the specified digest.
> > +    When generating a metacopy file the verity xattr will be set
> > +    from the source file fs-verity digest (if it has one).
> > +- "require":
> > +    Same as "on", but additionally all metacopy files must specify a
> > +    verity xattr. This means metadata copy up will only be used if
> > +    the data file has fs-verity enabled, otherwise a full copy-up is
> > +    used.
>
> It looks like my request for improved documentation was not taken, which =
is
> unfortunate and makes this patchset difficult to review.
>

Which one?
IIRC, you had two requests.
One very broad to get the overlayfs.rst document up-to-date:
[1] https://lore.kernel.org/linux-unionfs/20230514190903.GC9528@sol.localdo=
main/

But I assume you mean the specific request about this sentence:
[2] https://lore.kernel.org/linux-unionfs/20230514192227.GE9528@sol.localdo=
main/

I must say, I re-read this paragraph and the email thread and I don't
understand what it is that you are asking for.

I am not trying to dismiss your request, I am trying to understand.
I understand that overlayfs.rst is not a high standard spec and that
"metacopy files" is not well defined and I am not saying that we cannot
improve the documentation.

But since you already spent the extra time understanding the inaccuracies
of overlayfs.rst during v2 review and we already tried to explain the
details of metacopy in v2 review, please elaborate what information
is actually missing that made the review of v3 harder for you, so
that we can try to improve those parts.

Let me try to tell this story in a different way

Imagine a feature:
   send/recv email attachments by reference
   instead of attaching files, drop them in a network share
   and send/recv a URL to that share with optional verity sig.
verity=3Doff:
   do not include verity sig when sending emails
   do not verify verity sig when receiving emails
verity=3Don:
   include verity sig when sending emails (if available)
   verify verity sig if it is included in received email
verity=3Drequire:
   same as verity=3Don, but if verity sig is not included
   in received email, do not follow URL.
   if verity sig not available when sending, attach the
   file itself instead of the URL -
   that is what "otherwise a full copy-up" means in the
   context above

To me this sounds exactly like the documentation above.
Is this story clear?
If it is, what in the doc above is missing to make it also clear?

Thanks,
Amir.
