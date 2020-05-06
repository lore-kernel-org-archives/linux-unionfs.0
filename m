Return-Path: <SRS0=Z7uo=6U=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40A43C28CBC
	for <linux-unionfs@archiver.kernel.org>; Wed,  6 May 2020 10:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 135BD206DB
	for <linux-unionfs@archiver.kernel.org>; Wed,  6 May 2020 10:22:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nVR0T47+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbgEFKWj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 6 May 2020 06:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728730AbgEFKWW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 6 May 2020 06:22:22 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB00C061A0F
        for <linux-unionfs@vger.kernel.org>; Wed,  6 May 2020 03:22:22 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id i16so1189397ils.12
        for <linux-unionfs@vger.kernel.org>; Wed, 06 May 2020 03:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qj3nVPUCwbuhHvx3nwdASUowv6V8YuRboXW0ZcMSvoI=;
        b=nVR0T47+RhSHwjk5OaDminQnOWQviuPOguZkoAY/Nulp1tygp8iW34oUYxAwh/L1Oc
         wbbf/JbTcs/Q3y1mqEl62/pDvI9lU2woGcuhSWKtXKr9MQbi6Q/207SOzpOo1Re13SiR
         IMctLdl+vAeypgTBiZLZhVZcS4JopNfqzsE75Y+xLnPhvQX/lOUMzU1t9tYBWy+nkg7R
         UNf3R4F3NkpsB206rrjZArgazh86rvA6BVhSY7ZLO5pp6bi9XU2AcycTVRJEF/lSpeyd
         CmVi8TBr2G/WOa/uwwffHHhy1WwB6vA/I8C0vvgzT0UNbII7cvgUU1O6nSFZoyT59l0f
         zMDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qj3nVPUCwbuhHvx3nwdASUowv6V8YuRboXW0ZcMSvoI=;
        b=iRbgruKQaXrvZWLTsWoC2EdpcJhzcdJOT6O+oNntO2s6Gco/BtbOo7646guh6KBo6U
         IQb6NVvJHxISvSYHM2qagFn3vFsZtL8d6TjeeaDe8dmj8qgi5NjvsYvC4NQ1sDV89aR6
         z/r36Sxu2ys3IKCiumL6nK+oC3dEVoTNeBnrBeR5jMHlnk3u/eVtZWh9QEAOInVB1UZu
         vzKSFUU+5f3cnpKd0ss8UDbIvGII/0j9lI69Qixey5ogywYGiyG3tvA3eeiwHe9pHvNW
         dnq40gBAGSIUhLqwplkLwG3s+dXQV6/4R7Z87OtrE/kRPkJvw1gpDWc+db7QA6g1Q9D9
         i3qQ==
X-Gm-Message-State: AGi0Pub79tK7OeUF4Sb7JwJuoWcf3MgQ7tCR2qu9VQwo8VGlslj/cdj9
        RqAtNuJDz6mZouqkk3Fa2/5nZSulTiVCN3lo3n0=
X-Google-Smtp-Source: APiQypJdlGTlv+fYjrs1gAVvsHkJPLJ+KnQujaN8y9y+yIE1/wxATxEMi4/kM801ZBoaejNx+V56KQXiHBVdof2xbqY=
X-Received: by 2002:a92:9e11:: with SMTP id q17mr8339730ili.137.1588760541813;
 Wed, 06 May 2020 03:22:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200504193508.10519-1-lubos@dolezel.info> <CAOQ4uxhEu+vLrvpnqdCdT+vaLAnaNXBBiQ9fPmN39zC4_UzLSg@mail.gmail.com>
In-Reply-To: <CAOQ4uxhEu+vLrvpnqdCdT+vaLAnaNXBBiQ9fPmN39zC4_UzLSg@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 6 May 2020 13:22:10 +0300
Message-ID: <CAOQ4uxgrLMOu69CUwsxvZWWc0Ly5yixeFdmN9WA-BNU+=ydc8A@mail.gmail.com>
Subject: Re: [PATCH] overlay: return required buffer size for file handles
To:     Lubos Dolezel <lubos@dolezel.info>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, May 5, 2020 at 5:58 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, May 4, 2020 at 10:50 PM Lubos Dolezel <lubos@dolezel.info> wrote:
> >
> > Hello,
> >
> > overlayfs doesn't work well with the fanotify mechanism.
> >
> > Fanotify first probes for the required buffer size for the file handle,
> > but overlayfs currently bails out without passing the size back.
> >
> > That results in errors in the kernel log, such as:
> >
> > [527944.485384] overlayfs: failed to encode file handle (/, err=-75, buflen=0, len=29, type=1)
> > [527944.485386] fanotify: failed to encode fid (fsid=ae521e68.a434d95f, type=255, bytes=0, err=-2)
> >
> > Lubos
>
> Hi Lubos,
>
> Thank you for the fix.
> Please leave greeting (Hello) and this line outside of the commit message.
> You may add extra notes for email after --- line
>
> >
> > Signed-off-by: Lubos Dolezel <lubos@dolezel.info>
>
> After fixing below you may add for v2:
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>

Pushed my v2 to:
https://github.com/amir73il/linux/commits/ovl-fixes

Along with Dan's patch.

Tests are at:
https://github.com/amir73il/xfstests/commits/ovl-fixes

Thanks,
Amir.
