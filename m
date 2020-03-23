Return-Path: <SRS0=0eJY=5I=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75BD9C4332B
	for <linux-unionfs@archiver.kernel.org>; Mon, 23 Mar 2020 14:21:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 476AD20735
	for <linux-unionfs@archiver.kernel.org>; Mon, 23 Mar 2020 14:21:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="YgfeyQk2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgCWOVh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 10:21:37 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:36468 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgCWOVh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 23 Mar 2020 10:21:37 -0400
Received: by mail-il1-f194.google.com with SMTP id h3so13287989ils.3
        for <linux-unionfs@vger.kernel.org>; Mon, 23 Mar 2020 07:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VbgAHyWWYhFlUaZxvcGOTu0BCAGdrJV0KXEcrMjMwjM=;
        b=YgfeyQk2H8tb0WHZU+uz3MkuHumY/3lj7Zk8kPx13iGxva4Hb1SWT4na+dlp+bnhbp
         celfYiPZ0fnjJNaA+alkXQzwdxqvoUAoI5K9+i0uooI7jvBThbHMQYnX5s+C97QsmjvF
         rImes4vugJ0T21hnWg92Fiomq0LcFnO5VpJok=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VbgAHyWWYhFlUaZxvcGOTu0BCAGdrJV0KXEcrMjMwjM=;
        b=Mu7Meusp7qceOsDTQuYy952JlL3ScBLuQzvEfRdi6IAlQ3EGhFAG9uJSdPHHGqlQUf
         18DylcqY4bFO4z4Eehu2w9YcqxMYOyFy/Dt6pEA2gDpj2sl6g+N/OspOBL4ctS6lTQO9
         lLAPuw0VKvh0TxO4PbWHgk4b6nF2DCsYnBQE7i36BKRLunrWc+6nM/3EOWsr+DTpEjam
         tZ6KB8UaYTJcTy54GCLjU190mW7LITFsufkYfTKY7+8bKFcrbKZnySGLsHnbT3yiTF3v
         aLxaTY/6kkGB172TAhLhRHb2Ya9aR7jE5r5J3pqchs2sKIxoX2HXhK6mvTXZqYWc9MZj
         UoMg==
X-Gm-Message-State: ANhLgQ2eKYzwpyl2/nbgC3o7gYvuk3bKfSedsd8BhQHsu7phH962vv11
        HjHZecZyadUZUWsEGdKEdCSWygd8vZY6qjunLbBKZQ==
X-Google-Smtp-Source: ADFU+vsFMT+S+U7nK36+eXq8DVWgcweV2kDtl53uTpfy5o9OfLZiPdJ+J6UXhF+SmoFfzugK8OA99dTM2O6sTCKN+Zk=
X-Received: by 2002:a92:9fd0:: with SMTP id z77mr21886603ilk.257.1584973295633;
 Mon, 23 Mar 2020 07:21:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAFkON1U3cXdXFQYdkoQ3OQU+14GX7C88U6qre58vyfhrrFgKXw@mail.gmail.com>
 <CAJfpegsv+GayCtWtsfJZYWqH8DHw76U_cGOuqofgt895FBj0cg@mail.gmail.com> <CAOQ4uxiW2-Hh_sfuYXeuQy=a6FYBm7DyWkysgEe1GnC-qWWivg@mail.gmail.com>
In-Reply-To: <CAOQ4uxiW2-Hh_sfuYXeuQy=a6FYBm7DyWkysgEe1GnC-qWWivg@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 23 Mar 2020 15:21:24 +0100
Message-ID: <CAJfpegtCn-HLhuDB98G4dO8L-t2PMcqcwDw+0TiknU5LGvBacQ@mail.gmail.com>
Subject: Re: Kernel warnings in fs/inode.c:302 drop_nlink+0x28/0x40
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Phasip <phasip@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Mar 23, 2020 at 2:24 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Mar 23, 2020 at 2:53 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Mon, Mar 23, 2020 at 9:50 AM Phasip <phasip@gmail.com> wrote:
> > >
> > > Hello!
> > >
> > > I have stumbled upon two ways of producing kernel warnings when using the overlayfs, both seem to be results of the same issue.
> > >
> > > The issue seems to be related to handling of hard links that are created directly in the upperdir.
> > > Below is my system details and then two samples with a list of commands to reproduce and the corresponding kernel warning
> >
> > Hi,
> >
> > Thanks for the report.
> >
> > The problem is that i_nlink is not kept in sync with changes to
> > underlying layers.   That would not in itself be an issue, since
> > modification of the underlying layers may result in
> > undefined/unexpected behavior.  The problem is that this manifests
> > itself as a kernel warning.
> >
> > Since unlink/rename is synchronized on the victim inode (the one that
> > is getting removed) it is possible to detect this condition and
> > prevent drop_nlink() from being called.
> >
> > Attached patch fixes both of your testcases.
>
> IDGI. coming from vfs_unlink() and vfs_rename() it doesn't look like
> it is possible for victim inode not to have a hashed alias, so the
> alias test seems futile.

Yeah, needs a comment: both ovl_remove_upper() and
ovl_remove_and_whiteout() unhash the dentry before returning, so
d_find_alias() will find another hashed dentry or none.

> We better replace the WARN_ON() with pr_warn_ratelimited().
>
> >
> > We'll need an xfstests case for this as well.
> >
>
> Please forward the part of the email with the test case to the list.

Okay.

Thanks,
Miklos
