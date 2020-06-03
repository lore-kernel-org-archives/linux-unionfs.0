Return-Path: <SRS0=ksQV=7Q=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9484BC433E0
	for <linux-unionfs@archiver.kernel.org>; Wed,  3 Jun 2020 16:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72C0420679
	for <linux-unionfs@archiver.kernel.org>; Wed,  3 Jun 2020 16:21:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ohUB6XRm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgFCQVa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 12:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgFCQVa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 Jun 2020 12:21:30 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3822C08C5C0;
        Wed,  3 Jun 2020 09:21:29 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id z2so3107884ilq.0;
        Wed, 03 Jun 2020 09:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cQzWmDpi1wJWr0RAlK2/sz80AqOXD8xVaJIwnGR0WlI=;
        b=ohUB6XRm86g2of7JgBVG2MU0BLZ0blpmOnYXK3ZXp8oSse4caksO/C+X67LsiwT1c/
         PdPRhORlmR9BQNUEDt8RLgIPepqCraQkWZN+J/3pAB2D1xNDIV4perqgDx0gEdKrf446
         4Mych9a3o8xREmPYtEcF6rr1Z6nzBxyRH30UXpqyKJajb88IRVfYOuLUDxyFu/PQtSKO
         GYYdl51AsOskRKzDj2OcstIL9Sx0c3lQapUfLmRpFJ5j9WQNP7FQGmlBE8FUbD+Hl4SR
         6nmme5G8WpmXolqwVoxOWC3N7COBg/IuTzVxTIDVwQ1eCOYkeugKQVFT+udtUMBOTlez
         Cq4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cQzWmDpi1wJWr0RAlK2/sz80AqOXD8xVaJIwnGR0WlI=;
        b=iAnWbClJTi49WdLmimelhmLMT876u5m8pV5PdVTGJ39C5HQoQyMV0scQZyLEYQOWec
         1/ENjbyV+kjUttyiXDRVt0Zwk8zmPerJe9WhxaJVUz4FSIAraC3SmNXRBRm5kQTcO+/f
         XWpy+4UUOsxwp8v+sAaiRwA0rsWxIks0gBO9PnJOciVvxKFTd5R9UbPUPT2Ws6B+ym/b
         MUP45Fd87x1I7KQzOTLl64BPkxaWFLu4ky88ClK2/yAYPbx8wVHEX2d8B+d7Z79DaAYA
         Sg/l93DJfJu4IzcTfBWOAQ6ayUPpBzHW3C3+1a4wXnpRjlD0Ncd72msKl4kmJqsli64t
         WDuw==
X-Gm-Message-State: AOAM5326Tpsf2Z/NENie4PsNXNJFet9uVmsRq047yYYKDsUevL7YkPT/
        ScabTQyv7u3xA3dNysUk6/zuHxQaq/c6QL5cTbY=
X-Google-Smtp-Source: ABdhPJyTdlCHYTTpxOFSyktVrh69KTHXJ6eGz1oRtrU9A3OdrzKYmM3Hma8Io/AqZzE5MUBYw7pgAp0UmOm8eP0HSvI=
X-Received: by 2002:a92:2a0c:: with SMTP id r12mr261189ile.275.1591201289370;
 Wed, 03 Jun 2020 09:21:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200603154559.140418-1-colin.king@canonical.com>
 <CAOQ4uxhLW=MSk=RhUi51EdOticfk1i_pku6qjCp2QpwnpyL5sw@mail.gmail.com> <1edc291d-6e63-89d8-d48c-443908ddc0e8@canonical.com>
In-Reply-To: <1edc291d-6e63-89d8-d48c-443908ddc0e8@canonical.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 3 Jun 2020 19:21:18 +0300
Message-ID: <CAOQ4uxhSKT6dE7JUKMM7Jg2T7HFfUJQFXObtPi+z2G+JxzyRSg@mail.gmail.com>
Subject: Re: [PATCH][next] ovl: fix null pointer dereference on null stack
 pointer on error return
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jun 3, 2020 at 7:15 PM Colin Ian King <colin.king@canonical.com> wrote:
>
> On 03/06/2020 17:11, Amir Goldstein wrote:
> > On Wed, Jun 3, 2020 at 6:46 PM Colin King <colin.king@canonical.com> wrote:
> >>
> >> From: Colin Ian King <colin.king@canonical.com>
> >>
> >> There are two error return paths where the call to path_put is
> >> dereferencing the null pointer 'stack'.  Fix this by avoiding the
> >> error exit path via label 'out_err' that will lead to the path_put
> >> calls and instead just return the error code directly.
> >>
> >> Addresses-Coverity: ("Dereference after null check)"
> >> Fixes: 4155c10a0309 ("ovl: clean up getting lower layers")
> >> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> >
> >
> > Which branch is that based on?
> > Doesn't seem to apply to master nor next
>
> It was based on today's linux-next

Oh, I'm behind.
Sorry for the noise.

Thanks,
Amir.
