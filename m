Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF299C41513
	for <linux-unionfs@archiver.kernel.org>; Fri, 11 Aug 2023 13:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbjHKNdL (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 11 Aug 2023 09:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235796AbjHKNdK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 11 Aug 2023 09:33:10 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DAEE52
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Aug 2023 06:33:09 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id ada2fe7eead31-44768737671so862878137.2
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Aug 2023 06:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691760789; x=1692365589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T4zlWATACgMq5IwEWFolbM3iWiXS0aconeBmNLoZ5Dw=;
        b=hGtazHUl1o+l1CkBxIN7faOYDRmAlMbNe6/8JnJqHq/Qz0wVXG732pQMkQMvarFySe
         6FgH1O7he0qwKG14yQ/vvXK0UjVClps2bczaeFLZnPwZzlpLNZCBZdFIR/qNOePKugbE
         guWX/JQaXhhKoIQzeRK8Luw0wLeL+jvyqQ01gEhIO5SSIsjitPkIfDGl2zAH6wfyGu54
         jKHaJ6Qpe10/UcDIxvdLYX/1HzfwesDla/SQ2jOtNb4ddI70EVial7TSEcbfxgjFe3bL
         ElgCRniZtxJbAPSKmO6J5jGk9mNJvFkBxvr2CTKwiAGqFO7GXPawUaWXAOZtfR/lVoPI
         3ILQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691760789; x=1692365589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T4zlWATACgMq5IwEWFolbM3iWiXS0aconeBmNLoZ5Dw=;
        b=Zy8RUwh/kXqgy8jem/S3sVvY7Ljvl/XhRAYK5E61sxKsOMTDZCVb+kBy1UmjUmISXT
         Guf/u3zIW2O2erSwavWfYy3oRSMw8N7zdDmU8ZaI0ZLYk0PMu3eRAFxnmxEhAryh30pS
         u6g3tFQKc30H39AnT3ca3oUmfpe7/FrK1u1zNuv5aBD0IYMV2hTpJnYrNJp1W8VX1qEC
         cS2eGeUZabxsOwXrwsywbliKhGAXAMSjfH7BL9pNe5bNtDq5SN8jhRDakpFQXvIXTB2l
         FzT4Dj0ob4H4rVUR0wjiKPZ9t1+DlwGPamWhuKbEiW2V3Z/5u24oeLaSyBaOoALBEe07
         iZsw==
X-Gm-Message-State: AOJu0YyPeflNZIbaCq8063xSSZVeiF0Y9MOUPAk8ziYfkvKi90ztdCFI
        pA8CcWZrs70wekJbtnGpxbjoUIVaenPlmEYeQS3og2BD3W0=
X-Google-Smtp-Source: AGHT+IERPo5VTjCntzyGEibhWn/gZLYz/e5IEqioORfU8ZY0SbVExSVVn0CZ1sxALs3d0w5ojYtyV72RrQnbcHOJqbI=
X-Received: by 2002:a67:eb85:0:b0:447:6c24:7d86 with SMTP id
 e5-20020a67eb85000000b004476c247d86mr1798600vso.4.1691760788788; Fri, 11 Aug
 2023 06:33:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230713120344.1422468-1-amir73il@gmail.com> <CAOQ4uxibDU2Lko2WCFofJ+eQZV8YVBx_w-sm4H1cqO0fefP6Kw@mail.gmail.com>
 <CAJfpegvPQpx_x3omGK=nOtiN=dFvwuZPGbjv6s8pEsFzaks9yQ@mail.gmail.com>
In-Reply-To: <CAJfpegvPQpx_x3omGK=nOtiN=dFvwuZPGbjv6s8pEsFzaks9yQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 11 Aug 2023 16:32:57 +0300
Message-ID: <CAOQ4uxh4VsPVeHW3AWaAAH3WfcvWuOZzCxPC+hzvQJ8XxLDyJQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Report overlayfs file ids with fanotify
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Aug 11, 2023 at 4:21=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Fri, 11 Aug 2023 at 11:44, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Thu, Jul 13, 2023 at 3:03=E2=80=AFPM Amir Goldstein <amir73il@gmail.=
com> wrote:
> > >
> > > Miklos,
> > >
> > > This is the second part of the work to support fanotify reporting of
> > > events with file ids on overlayfs.  The fanotify_event_info_fid struc=
t
> > > reported with fanotify events has an object file handle and an fsid,
> > > so fanotify requires that filesystems can encode file handles and hav=
e
> > > a non-zero f_fsid.
> > >
> > > The first part [1] that was merged to v6.5-rc1, relaxed the fanotify
> > > requirements for filesystems to support reporting events with fid to
> > > require only the ->encode_fh() export operation.
> > >
> > > Patch 1 changes overlayfs export_operations to meet the new requireme=
nts
> > > with the default overlay configurations (i.e. no need for nfs_export=
=3Don),
> > > thus, allowing an fanotify watch with FAN_REPORT_FID on overlayfs.
> > > There are LTS tests [2] for fanotify(FAN_REPORT_FID) + overlayfs.
> > >
> > > Patches 2-4 are not strcitly needed to support reporting fanotify eve=
nts
> > > with fid, because overlayfs already reports a non-zero f_fsid, it's j=
ust
> > > not a unique fsid.  So before allowing to report events with overlayf=
s
> > > fids, I wanted to fix overlayfs fsid to be more unique.
> > >
> > > I wanted to implement a persistent and unique fsid for overlayfs.
> > > I wanted it to be the default behavior, but needed to avoid breaking
> > > applications that rely on an existing overlayfs fsid to persist.
> > > I came up with a solution that is described in patch 4 (uuid=3Dauto) =
that
> > > meets all the requirement above.
> > > There is an xfstest to test the persistent-unique fsid feature [3].
> > >
> > > This patch set has been in overlayfs-next for soaking since v6.5-rc1.
> > > If you have any reservations that we will not be able to resolve in t=
ime
> > > for 6.6, especially regarding the on-disk format and backward compat,
> > > we could also merge only patch 1 and leave the fsid patches for later=
.
> > >
> >
> > Hi Miklos,
> >
> > Any comments on this series (which is currently on overlayfs-next)?
>
> No issues from me on the design.   Will review the patches.
>
> > Please let me know if you want me to take care of the 6.6 PR or
> > if you intend to prepare it yourself.
>
> I'd be very thankful If you could take care of the 6.6 PR.

No problem.

> >
> > Other candidates for 6.6 include:
> > - ovl lock re-ordering
> > https://lore.kernel.org/linux-unionfs/20230720153731.420290-1-amir73il@=
gmail.com/
> > - CONFIG_OVERLAY_FS_DEBUG
> > https://lore.kernel.org/linux-unionfs/20230521082813.17025-1-andrea.rig=
hi@canonical.com/
>
> Yep, those look good, with the exception of the lockdep silencing.
> If it's a false positive, then we should teach lockdep about why.  If
> it's a real deadlock, then let's try to fix it properly (only holding
> sb_writers over operations that need it).
>

Although it's a corner case, I think the deadlock is real.
All it takes is two different ovl mount with the same upper fs,
one is the lower of the other doing
    - upper sb_writers
     - lower ovl_inode_lock
      - upper sb_writers
during copy up.

Technically, to avoid the hack, we can remove ovl_want_write() from
ovl_copy_up_start() and do it individually for every low level helper that
needs to modify upper fs.
I can try to see how noisy this will be.

Thanks,
Amir.
