Return-Path: <SRS0=YYYA=4H=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7094BC34056
	for <linux-unionfs@archiver.kernel.org>; Wed, 19 Feb 2020 19:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E900F207FD
	for <linux-unionfs@archiver.kernel.org>; Wed, 19 Feb 2020 19:45:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="eqs765CY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgBSTpv (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 14:45:51 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:33430 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgBSTpv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Feb 2020 14:45:51 -0500
Received: by mail-io1-f65.google.com with SMTP id z8so1947908ioh.0
        for <linux-unionfs@vger.kernel.org>; Wed, 19 Feb 2020 11:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9OeaSlTXCM8ViuTa60e1bzu7HkQI8QuNIe/o6vd5D10=;
        b=eqs765CYusWeKJfFvZ2+4mCR6Yl6O8lqFF5/FdXrl84D5jZwKCYVJYobJyhOkROaOf
         SG4BPWjrwhWlhcH72jJ5/J7e8R03pFj0zS1dkDMT/YVthVCBYByC06vi3lLejOc3mBvT
         oshUC2QGdIcrENDlkldVcKbWgaBZTZFP7zDOw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9OeaSlTXCM8ViuTa60e1bzu7HkQI8QuNIe/o6vd5D10=;
        b=tZak2jSTmZbpLOUm7uoyMcHXSj4om93UJvwy51ZKCITb6LuKBM6eIOIbXfv0QulAxj
         L5qxszP6aHVwc9qvonHAAxhrjdujEZJ6qkXhoAc1WlJ/e/YpzIiZaZqgeousmhWk4ka5
         BE15wDd9EnzfFgUxZrJYj7QrP2C0AEynYIyuchWmPzmp/5huvuj8kqD290Ufb9paGEIi
         MQhiEnUWYm8RijnUhbi7+VdJs+cj0UZsCPTkrYc1ORjVBIlLKH8iHuKL0WVKV5kY/8Dy
         EgMZtOG8ItGCTyPzcLq1aqwPP+Ibr6Tq9wUPBi+xv+wCrtxffxsjrVQ2nlaPTTs2q+2t
         Eweg==
X-Gm-Message-State: APjAAAWI3t0pI4tD3QpO5MbQeKYj7Y7wO7scf271RPPhjvR3aq/XNh2U
        aNxCxAUoU2EuQEwZJPLrnLzRQMwiVqdHihKyFOMsCQ==
X-Google-Smtp-Source: APXvYqwYwujI+yViC650HU3toqCCzetwAh3ReC8vpB170BF+/ixTBQ4kyTTC+D11DV0HvcUWRu+tEPUSwsZTwcLiiw0=
X-Received: by 2002:a6b:24b:: with SMTP id 72mr19241634ioc.63.1582141550699;
 Wed, 19 Feb 2020 11:45:50 -0800 (PST)
MIME-Version: 1.0
References: <20200101175814.14144-1-amir73il@gmail.com> <20200101175814.14144-6-amir73il@gmail.com>
 <CAJfpegvPBwBpmcY60CcypYRAGgQr44ONz8TSzdBUq2tPmOXBbA@mail.gmail.com>
 <CAOQ4uxgpR5O-dFKYueHKd_j8bA_k3F06pFQ+qjVfe9htTmyWOA@mail.gmail.com>
 <CAJfpegvSU8w19XPtMPP7PXac455JWos9O6UrmzgNOQBKcaqkCg@mail.gmail.com> <CAOQ4uxieagY4hW9jHsHpPVsiRFo3CAThdc6=CcmPR-aOPtnjDQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxieagY4hW9jHsHpPVsiRFo3CAThdc6=CcmPR-aOPtnjDQ@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 19 Feb 2020 20:45:39 +0100
Message-ID: <CAJfpegs=YniZqHLXUkD8zjz5ssjgQvAZE08RzQVw-JwYRVv_mA@mail.gmail.com>
Subject: Re: [PATCH 5/7] ovl: avoid possible inode number collisions with xino=on
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Feb 19, 2020 at 4:59 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> > > Yeh, it's mostly the same. Branch ovl-ino is already rebased.
> > > If you have no other comments, I'll prepare v2 and test it with 5.6-rc2.
> >
> > Thanks.   I've already applied the patches leading up to this and just
> > pushed to #overlayfs-next.
> >
>
> OK, I'll rebase the rest on top of that.
> While you are here, what do you think about:
>   ovl: enable xino automatically in more cases
>
> Do you agree with that minor change of behavior?

I haven't thought about that yet.

>
> BTW, I see that overlayfs-next allows all remote fs as upper,
> without extra restrictions.
> I guess you are not too worried about implications?
> Or intend to fix that up before the merge window?

No, I'm not too worried, but if you send a patch, I'm not against
restricting it either.

Thanks,
Miklos
