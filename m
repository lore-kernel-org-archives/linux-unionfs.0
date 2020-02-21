Return-Path: <SRS0=Fd6Y=4J=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEDCEC11D00
	for <linux-unionfs@archiver.kernel.org>; Fri, 21 Feb 2020 01:11:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A78FE2067D
	for <linux-unionfs@archiver.kernel.org>; Fri, 21 Feb 2020 01:11:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KLIem2mM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgBUBLE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 20:11:04 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:40354 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729419AbgBUBLE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Feb 2020 20:11:04 -0500
Received: by mail-io1-f68.google.com with SMTP id x1so584250iop.7
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Feb 2020 17:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q6MO28aKAPdXkEbSrSD7stYJ4xXqHQCdnqZOSHYTnHc=;
        b=KLIem2mMTr3BqVyxkEir9GlgyvtnYkKBzwUSSNx8Uu6prUVxx/nizkoL3q5XJhBoma
         yZ5zfwG/88wM62/KBOx7DPy8AebvEeISnYhY5jTQu80v4dY62TuEncmc+GfNw4ovxfJS
         27Wi8670hXDreqKQ3ddiaFWyF5gz/RsAWkm7I2HCHdUKMbE6Jftvk7pD28FUNiOmcOb7
         0xN6KwFeKYzu7epeHfEqVoE+kk0xzKSlVztkku3MBk+34PLWb478VIXS4ahtSDuU3HiI
         HVfUf9wSxeFZfKIwobQhjYrAFwUQT4wm3r7RAIu+ukCPP0dRwk5QJ9WHuUR6csGnL5IY
         YLCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q6MO28aKAPdXkEbSrSD7stYJ4xXqHQCdnqZOSHYTnHc=;
        b=cCDVzzfw6eyOBM6xTmqIqg9j4Tz8sbMSU44dYJZQGnlfbFARITKou2h7Z9FNmCMxf9
         YVtDVkoUo6JAI41mdfAOfwrA48KA/ijhKYsUvlsu1i0aNBSTjQdSWr6WW9/JBzKqw9aW
         lloKVKqABstQIDZ1jsK8m/KERPOSh96AU9VAd3Txu/WgomzPzftDTTO5nX7/6ZkXQoCe
         Id+Bxq+aslHXOc5Tb+QYSapbDLDJqjIsq/h7QvBq0Q2pWd19WlDW9X3OLLkW3ck0Ax/5
         i/rISs/zMEOOM7yuQXa8vxumMQt/WayDpkKy9mWPMXJRcMkCunjL0WvXWPn+vYo+u2r7
         RpuA==
X-Gm-Message-State: APjAAAXWLwDMC8KhF79u0vMzcRzP/JokHeIE0yojRkdESZ9Tsrt1/3yO
        Hu0kYtcx86bAQoU73jSFxKm2x4uHK/BuqBU7HHJQkw==
X-Google-Smtp-Source: APXvYqzPGGHXjR5ybi/HBirFVM1/DrKoQ2TFM9/jQoJd9Z50yQn/+RTB+Umb0LxhAT5NMMUT7loGsMDTxEz/odk0Qj8=
X-Received: by 2002:a02:c558:: with SMTP id g24mr28218296jaj.81.1582247462100;
 Thu, 20 Feb 2020 17:11:02 -0800 (PST)
MIME-Version: 1.0
References: <20200101175814.14144-1-amir73il@gmail.com> <20200101175814.14144-6-amir73il@gmail.com>
 <CAJfpegvPBwBpmcY60CcypYRAGgQr44ONz8TSzdBUq2tPmOXBbA@mail.gmail.com>
 <CAOQ4uxgpR5O-dFKYueHKd_j8bA_k3F06pFQ+qjVfe9htTmyWOA@mail.gmail.com> <CAJfpegvSU8w19XPtMPP7PXac455JWos9O6UrmzgNOQBKcaqkCg@mail.gmail.com>
In-Reply-To: <CAJfpegvSU8w19XPtMPP7PXac455JWos9O6UrmzgNOQBKcaqkCg@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 21 Feb 2020 03:10:51 +0200
Message-ID: <CAOQ4uxgY18Qo-QT=FXg=A95RPqLDXe8e=wiUENSSs_yr5C=mAw@mail.gmail.com>
Subject: Re: [PATCH 5/7] ovl: avoid possible inode number collisions with xino=on
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Feb 19, 2020 at 5:36 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Wed, Feb 19, 2020 at 4:28 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Wed, Feb 19, 2020 at 4:25 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> > > While this makes sense on 64bit arch, it's going to overflow on 32bit
> > > (due to i_ino being "unsigned long").
> >
> > It's not clear here, but on 32bit, xinobits is 0:
> >
> >                 ofs->xino_mode = BITS_PER_LONG - 32;
> >
> > To the expression doesn't change i_ino.
> > Correct?
> > Want me to clarify that by comment or by code?
>
> Ah, missed that.  I think no need to clarify further.
>

Mmm.. only it doesn't seem to be true.
Seems like with xino=on xino_mode won't be 0 on 32bit.
I think we do want to force disable xino on 32bit and send fix to stable -
if only to keep the code in ovl_map_ino() simpler.

What's more, I think there is a bug with xino_mode -
it is not initialized to -1 on the default xino=off mode,
so ovl_same_fs() could be wrong.

I will try to look at this tomorrow.

Thanks,
Amir.
