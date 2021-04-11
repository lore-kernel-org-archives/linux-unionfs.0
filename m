Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C459C433B4
	for <linux-unionfs@archiver.kernel.org>; Sun, 11 Apr 2021 05:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 534F3611C9
	for <linux-unionfs@archiver.kernel.org>; Sun, 11 Apr 2021 05:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhDKFMw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 11 Apr 2021 01:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhDKFMw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 11 Apr 2021 01:12:52 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C95C06138B
        for <linux-unionfs@vger.kernel.org>; Sat, 10 Apr 2021 22:12:35 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id c18so8178026iln.7
        for <linux-unionfs@vger.kernel.org>; Sat, 10 Apr 2021 22:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9vZvAZJt7zJkruV97Q6iQJd5fFXGrjS4TPL0YjXddV4=;
        b=atQXAjnycqqXz4gA0QfeDmI5Oc301Hsjh9PWP0bpm7+qmXJMZISwCWkoJbkpHhLIz1
         lqUo32JW6djrRVTY5+22vZvXbmEZhNOb1WCCO2HJuqA7+aOogA0D5wxZsq/EPno/KM0T
         DvcSDPh1MIYorDKQW5XZO0tvGzvOZ4FdSbQYInuGeMpzRvtwuCcDHY6eZBGn0xX49YFg
         4p2/16odD9/wFO+Wl/hsKxyuGB1vPz/RJRlaISeobqST+ALhqk4/7XKeP5rMhZDNFG6Z
         yn5EDUtKZQUBNVr/uZiHQhid6drVts4YJxh/6s/G9KwO+eixIvXaIqAiQGkoaCvrZl0L
         Rl9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9vZvAZJt7zJkruV97Q6iQJd5fFXGrjS4TPL0YjXddV4=;
        b=i4c0cOhvU6WU0vTudcbb84i7JKUyqI1Lk98kW9fJYXjV5Uc4p+ZFp25kWf1QtKISj+
         9F9+llRXYJuKkzAz+arj8GMoTssIuG+H0teybgsinECAWHpUnoDIh9LoctgqyEECQ772
         DN9g6NWNykqdNu+lguSiC1gceJGmTqRetAOrbNgHnJm+lwWKjmVsIVVhm1Dr3HL0zW33
         kWLkWzSPyFK/QTlFeAYdehVCiUAcZ5D+F4uN6FNt78Ft7E6Rj2F+kMmA7lk68IktrIuh
         e2wb9N1iS+om9rUn37L+ru9Pg6pABRC9RSk2IkIGAEkjL5PWuAL0Bsp3zyI37RroDHZg
         tWSg==
X-Gm-Message-State: AOAM532LzkuCKZ9sBk2UhdsCimunMo/HAFrRatlZmxC0axh76K2+ZzAs
        +PoK149LsnCg1L2+/hXEPWSS/9WNrJpJCbx+Knf861hMZ7w=
X-Google-Smtp-Source: ABdhPJzKsWLVONr4QAnoAmiRTWnHQPpx7UdfQz0ZWdUvBTYEPsuyPIcrZQOokYvaAkO67QxKxGRIuW5YrVey887jPx0=
X-Received: by 2002:a92:d4c5:: with SMTP id o5mr18476446ilm.9.1618117954916;
 Sat, 10 Apr 2021 22:12:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAJCQCtTp0aXBssEr4ZXGX=DS_+RyGghmoANCKDdxG59QWu8LVA@mail.gmail.com>
 <CAOQ4uxht70nODhNHNwGFMSqDyOKLXOKrY0H6g849os4BQ7cokA@mail.gmail.com>
 <CAJCQCtRGdBzyskifrYLbBGAAm0g7VeC6GeD7xBN-hRqE3GAWYA@mail.gmail.com>
 <CAOQ4uxhU2KX=jKKL5EZ102z_+6KyVKAOoAzSp2K8i0PMGJUg4A@mail.gmail.com>
 <CAJCQCtTHepsUHjCUAwawC6r6txAZ=XypE5rJOizqxMx9zuR4AA@mail.gmail.com>
 <CAJCQCtQshgFBvUF2+DLm0=iHhiONu-QCRnB1uNv2dLigT+WfZg@mail.gmail.com>
 <CAJCQCtTg5Cz_GdSTCX-rZDmoB-PDGr2iV=quPWSofbL-Xixapw@mail.gmail.com>
 <CAJCQCtQDyOh-EWL2QMMgNQeY6KDpHqducVRpn_63O30KuX2diQ@mail.gmail.com> <CAJCQCtSC36c5yNo+H2sy0o1f+XerjDSj-KYxPZS4GX6v5czUgw@mail.gmail.com>
In-Reply-To: <CAJCQCtSC36c5yNo+H2sy0o1f+XerjDSj-KYxPZS4GX6v5czUgw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 11 Apr 2021 08:12:23 +0300
Message-ID: <CAOQ4uxjYQV6gUa3rmsoECSjrZSAJ+ENWDcs0pYrLfocM1B+gVg@mail.gmail.com>
Subject: Re: btrfs+overlayfs: upper fs does not support xattr, falling back to
 index=off and metacopy=off.
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

[removing btrfs list]

On Sat, Apr 10, 2021 at 11:03 PM Chris Murphy <lists@colorremedies.com> wrote:
>
> Keeping everything else the same, and only reverting to kernel
> 5.9.16-200.fc33.x86_64, this kernel message
>
> >overlayfs: upper fs does not support xattr, falling back to index=off and metacopy=off
>
> no longer appears when I 'podman system reset' or when 'podman build'
> bolt, using the overlay driver.
>

I don't see a change in overlayfs that would explain seeing this warning
in v5.12 and not in v5.9 - on the contrary, in v5.12 the warning is printed
only if index or metacopy features have actually been requested.

So it must be a change in the upper fs, which is tmpfs?
Anyway, I don't have enough information and this seems unrelated
to the test failure, so I'll drop it.

> However, I do still get
> Bail out! ERROR:../tests/test-common.c:1413:test_io_dir_is_empty:
> 'empty' should be FALSE
>

Now I'm confused again.

Your reports starts by stating:
"The primary problem is Bolt (Thunderbolt 3) tests that are
experiencing a regression when run in a container using overlayfs,"

But you say that the problem exists with kernel 5.9.
When you say "regression" above, what are you referring to?

Did those tests pass in a previous Bolt version?
Did those tests ever pass in a container using overlayfs?

There is surely a bug in overlayfs, but it's hard to find it without
minimal bisection info. I'll keep looking.

If it's a regression with newer distro, please try to understand
from distro/package managers, what has changed in the container
setup and kernel config w.r.t a container using overlayfs.

Thanks,
Amir.
