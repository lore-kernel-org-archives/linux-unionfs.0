Return-Path: <SRS0=0eJY=5I=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0260FC4332E
	for <linux-unionfs@archiver.kernel.org>; Mon, 23 Mar 2020 19:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5D53206C3
	for <linux-unionfs@archiver.kernel.org>; Mon, 23 Mar 2020 19:15:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="icqF0/uC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgCWTPa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 15:15:30 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:42682 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbgCWTPa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 23 Mar 2020 15:15:30 -0400
Received: by mail-io1-f67.google.com with SMTP id q128so15512461iof.9
        for <linux-unionfs@vger.kernel.org>; Mon, 23 Mar 2020 12:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6qjt3tOTpTkCadoLmRyd0WlPaO2sndLsTPYlubINSJs=;
        b=icqF0/uCvcIASg7KwMtOmgkH+gWdJ2L15TICEkaS2pYA67eqRFf+PhKBT7yFpbf4ml
         zRRnop32ZDGPmyCNZp8Dh3Qlnu3Svm1KQ+9yPdiyMfyC7Oy6JTwr9SCnShbBKy4rXaaN
         NXaHMmLqd+mt/aey7e1wJUEqLutnsTYIhrMDGePopo1PWIVCy7Bsx0dVU/JEt23w7AG/
         rh3XtvqGci1itB9y+gr8ELMrvkWSZ6fbHE3Ids2NoS5L+gyGEu1izgyGBMQwwl5Tq98m
         BLwGV+bbActsVpXf5zkcWJ/lv/ybRv/JMylw6gzRCrTBSKau4vrKXF/zk6iy/vjchtCy
         U64g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6qjt3tOTpTkCadoLmRyd0WlPaO2sndLsTPYlubINSJs=;
        b=p25d9FiKQ95n8lQ3tz+GamnGpZwZKaKio+OMjgkp7WHAawTH5wn6nYnv4kQR3rRXoy
         /vn2yH8YYaSLPGWRJ79VwkhiRIituntK/NqldSRllbznfI+wRt/gfL1YlKHbOlYfy/8r
         3CQxsc97MgNRCnOtpxKbu4iodcWEftGXB21bZEO/HQyuIAUPTCXDasSG+VRVk72pXSw5
         sIvCZrkrUrxZPn/KdbqOW6G0+zh4WxiINAGkbK50PRnUraUX7X+F+9DBTC1+Imgyh12c
         wOIKL8Hd9C0A6matscBWJ8m1IQOVf1bha2Oqs+x2xz06DQX3Qqx3zNc+Pv+FIQJlWag4
         9N9A==
X-Gm-Message-State: ANhLgQ2cFT7wD64PWVKHGocc8oDEqJZMxgPq0u2fc7jYLelKuJe6pwl2
        IYkoWQyeYwVRQBjHcQPB14kHCkB0/NfU8AerE2s=
X-Google-Smtp-Source: ADFU+vsTPxnHJYF9N4DWvN6jIBPabldaHoeKoGkckvsOz/5ZJhq8xCXnol1gD6/Kw2sCZtrOeXFqRQegtxK26Mg34kM=
X-Received: by 2002:a02:304a:: with SMTP id q71mr21306789jaq.123.1584990929308;
 Mon, 23 Mar 2020 12:15:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAFkON1U3cXdXFQYdkoQ3OQU+14GX7C88U6qre58vyfhrrFgKXw@mail.gmail.com>
 <CAJfpegsv+GayCtWtsfJZYWqH8DHw76U_cGOuqofgt895FBj0cg@mail.gmail.com>
 <CAOQ4uxiW2-Hh_sfuYXeuQy=a6FYBm7DyWkysgEe1GnC-qWWivg@mail.gmail.com>
 <CAJfpegtCn-HLhuDB98G4dO8L-t2PMcqcwDw+0TiknU5LGvBacQ@mail.gmail.com>
 <CAJfpeguKujUqW-z75F+6mCh0uwHF6rz2cK4OWUCFe83QNmaSrQ@mail.gmail.com> <CAOQ4uxha8XSB62cq=+X-tCdMUnOTrYpJT1YbjxuLhmrFsRM-Pw@mail.gmail.com>
In-Reply-To: <CAOQ4uxha8XSB62cq=+X-tCdMUnOTrYpJT1YbjxuLhmrFsRM-Pw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 23 Mar 2020 21:15:17 +0200
Message-ID: <CAOQ4uxhEU=y=m49Vii=iRigXJ_ofhQ+me9QdF4kTFTMfMu_fpQ@mail.gmail.com>
Subject: Re: Kernel warnings in fs/inode.c:302 drop_nlink+0x28/0x40
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Phasip <phasip@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Mar 23, 2020 at 7:27 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Mar 23, 2020 at 4:53 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Mon, Mar 23, 2020 at 3:21 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > >
> > > On Mon, Mar 23, 2020 at 2:24 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > > > IDGI. coming from vfs_unlink() and vfs_rename() it doesn't look like
> > > > it is possible for victim inode not to have a hashed alias, so the
> > > > alias test seems futile.
> > >
> > > Yeah, needs a comment: both ovl_remove_upper() and
> > > ovl_remove_and_whiteout() unhash the dentry before returning, so
> > > d_find_alias() will find another hashed dentry or none.
> >
> > Except that doesn't seem to be true for the overwriting rename case...
> >
> > Attached patch should work for both.
> >
>
> It still looks quite hacky.
> Why do we not look at upper->i_nlink in order to fix the situation?
>
> For index=on, there is already code to handle lower hardlink skew case,
> including pr_warn and several xfstests (overlay/034 for example).
> The check is buried in ovl_nlink_end() => ovl_cleanup_index().
> It's keeping overlay i_nlink above upper i_nlink.
>
> In fact, if you change one line in overlay/034 it triggers the reported
> bug, so we can just fork this test.
>
> -lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
>  workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
>
> How about adding a check in ovl_nlink_start() to fix overlay i_nlink
> below upper i_link?
> It would be a valid check for both index=off and on.
> I will try to write it up later.
>

https://lore.kernel.org/linux-unionfs/20200323190850.3091-1-amir73il@gmail.com/T/#u

Sorry, Phasip, forgot to CC you.

Thanks,
Amir.
