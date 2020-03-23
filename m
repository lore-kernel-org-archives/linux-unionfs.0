Return-Path: <SRS0=0eJY=5I=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F9EC3F2CD
	for <linux-unionfs@archiver.kernel.org>; Mon, 23 Mar 2020 17:27:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7574D20719
	for <linux-unionfs@archiver.kernel.org>; Mon, 23 Mar 2020 17:27:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OSlMfvVV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbgCWR14 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 13:27:56 -0400
Received: from mail-il1-f177.google.com ([209.85.166.177]:46412 "EHLO
        mail-il1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727198AbgCWR14 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 23 Mar 2020 13:27:56 -0400
Received: by mail-il1-f177.google.com with SMTP id e8so13897732ilc.13
        for <linux-unionfs@vger.kernel.org>; Mon, 23 Mar 2020 10:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xirb//ec3gNOEtiQfXcIgvonsOhV1o3oO4bkOXwDVTA=;
        b=OSlMfvVVmrRsDh+27+7xOWaVF3g6bzh0EeP+/8gXo7xCXf/BjTpLeNUXKNVdnKaLbe
         ATN3eODxT6nTy3K/ikVbzRBrcMPnhVeCMLIYdXFknBGapkh3MV0Ifhg/xcL0J64FBK4N
         7mD/QPSEB1hLCPyKqIQATz6qz7VQVubH6c2Mq6w7DqGcTDRDTtebkEC7IUbsyppjrnP4
         kknmBvXj9U0ZK4mcPUEaNjiHy8aDW91k2hrC6jcPXKxn5cZne8AR3c9PTbtBgEtleJaC
         IMDIb62IpbcHhanTQwbf+cQHbVYB3rNEKtayqvAHZBB47wgiSC8EsBVgV5L++a3v1oXA
         TjEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xirb//ec3gNOEtiQfXcIgvonsOhV1o3oO4bkOXwDVTA=;
        b=T3xnD0KsFWbTcDJXhZz9jj18EMZTQ3WkXv19Wj8CMAxyFNY22kKFEzHghTkeNwKBCt
         UAxhLPJozGu0liegyuvZzvFIGPns79tE87ZfDIUlelFZ6FTs3N9RVF2u8dPyaopjLRW1
         Y94Cnn7U58iW9n1TrN0eEdixEzkESek3bTZkk00t1wxCYoUVxlYg7idBbB/2U9/1zwUG
         6S9x4avgGIRdWtfW4R8HamAxf+lb/YhCk0biMZmA782msUGgDpGnRjMVxxtXUHeKTTqA
         OzO1cRNAiKHrjbUuJrefb2byvDkZcI4VtVnUIeQFYpKy1sXMmQTkLq1jsc28CHvQc5EB
         e4Yw==
X-Gm-Message-State: ANhLgQ17c5c/CB4k1HyVOk2DEbrMlEdwFbb+T2zxVqLPSpenafS6Bryq
        jwo8MsmcG0r67huApjMuHdgOnbg03p/Abo4ZYbE=
X-Google-Smtp-Source: ADFU+vty9ceLn4I+LaT8DXSZRuxEC16bn/471QUuwgK0uiDNwC3oTrlo66pVTn+BJ9rmYq6W/1yGt5pYAA6IrrCBy+Q=
X-Received: by 2002:a05:6e02:5ae:: with SMTP id k14mr5791825ils.9.1584984473279;
 Mon, 23 Mar 2020 10:27:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAFkON1U3cXdXFQYdkoQ3OQU+14GX7C88U6qre58vyfhrrFgKXw@mail.gmail.com>
 <CAJfpegsv+GayCtWtsfJZYWqH8DHw76U_cGOuqofgt895FBj0cg@mail.gmail.com>
 <CAOQ4uxiW2-Hh_sfuYXeuQy=a6FYBm7DyWkysgEe1GnC-qWWivg@mail.gmail.com>
 <CAJfpegtCn-HLhuDB98G4dO8L-t2PMcqcwDw+0TiknU5LGvBacQ@mail.gmail.com> <CAJfpeguKujUqW-z75F+6mCh0uwHF6rz2cK4OWUCFe83QNmaSrQ@mail.gmail.com>
In-Reply-To: <CAJfpeguKujUqW-z75F+6mCh0uwHF6rz2cK4OWUCFe83QNmaSrQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 23 Mar 2020 19:27:41 +0200
Message-ID: <CAOQ4uxha8XSB62cq=+X-tCdMUnOTrYpJT1YbjxuLhmrFsRM-Pw@mail.gmail.com>
Subject: Re: Kernel warnings in fs/inode.c:302 drop_nlink+0x28/0x40
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Phasip <phasip@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Mar 23, 2020 at 4:53 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Mon, Mar 23, 2020 at 3:21 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Mon, Mar 23, 2020 at 2:24 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> > > IDGI. coming from vfs_unlink() and vfs_rename() it doesn't look like
> > > it is possible for victim inode not to have a hashed alias, so the
> > > alias test seems futile.
> >
> > Yeah, needs a comment: both ovl_remove_upper() and
> > ovl_remove_and_whiteout() unhash the dentry before returning, so
> > d_find_alias() will find another hashed dentry or none.
>
> Except that doesn't seem to be true for the overwriting rename case...
>
> Attached patch should work for both.
>

It still looks quite hacky.
Why do we not look at upper->i_nlink in order to fix the situation?

For index=on, there is already code to handle lower hardlink skew case,
including pr_warn and several xfstests (overlay/034 for example).
The check is buried in ovl_nlink_end() => ovl_cleanup_index().
It's keeping overlay i_nlink above upper i_nlink.

In fact, if you change one line in overlay/034 it triggers the reported
bug, so we can just fork this test.

-lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
 workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK

How about adding a check in ovl_nlink_start() to fix overlay i_nlink
below upper i_link?
It would be a valid check for both index=off and on.
I will try to write it up later.

Thanks,
Amir.
