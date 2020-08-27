Return-Path: <SRS0=xPSr=CF=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EE14C433DF
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Aug 2020 06:42:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7459822B47
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Aug 2020 06:42:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mLwlpDb/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgH0Gm3 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 02:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbgH0Gm2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Aug 2020 02:42:28 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34080C061263
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Aug 2020 23:42:28 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id j9so3972219ilc.11
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Aug 2020 23:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BhpV+I//QOdJG2j/Wk9iIW/dP7QQet+JLKodRht+gVM=;
        b=mLwlpDb/iZ81wJoRfuVlQBP/kvPehrCMR6DMGrdFCPQDTKaoi0S/quOhdFiF4LGH1j
         RFRtNMWpYGNZ/kyHyR0rynMem7DL3eWxFcQmGCE7hLGQPOtqHFqWjuvTvtHcfxZ3PQgf
         Ol0L3oXhQG/lAkN2SgSZd7Zdz8PHmoCLwDqiPVD9yeofFv/wKseoV9dO2U+TPIsFoUiD
         y3qnxaTB+iBkzq1XNf4O4oq9JpNJEWgVPpaMnumnMUiBcmri27nnZ4vQz3Ww95K2mbPK
         7ryq78pT5ceK2S0CzWWyKWdclteHpiVz0ZhP2D3Vk4DZh0XJkyJlpb1abnx8YJkZZYwW
         5+pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BhpV+I//QOdJG2j/Wk9iIW/dP7QQet+JLKodRht+gVM=;
        b=tO81gOHqCuQKCeADU0Rupj+bMvrl6oTwMbkpnvWNZ3UGJZ2EFYqD5N1OE4H+Rt69ek
         0MuAYyKM9z8zclbCC3BxNzqkdzb7gJeItNPBcfRzIRkDyhj+050WQl3POWSTFd1CiAaJ
         od7h68beN5zXxbZS4Lzq0b+4HMUiyxNlzBRzuVUuIxJvisQjGHxlTxyYz3MbBDdUdyyE
         XkEbaLNn/53uYcIAN2GS5xPB8hbTvSaC44YcBIOojVE5KzSJon3SSNGlKme2B+gMXxUH
         1ZeRBsxLGYNaQbcHCDIUYYxieMdiyZQKitKkmCoLekNNxRpSQ1hrwVuk3gtXrG4FRd7F
         HDOQ==
X-Gm-Message-State: AOAM533c6YnaVZPNiy5b5p2Nt783uIjB467uArpCnMIvI93awx/RvtA/
        IDsnvQtdww+LS+WB44exIJIGoyP5ZifcCkD10Eo=
X-Google-Smtp-Source: ABdhPJyRY7gOu/jll7wBvRx3u/Y03CDlqqnHRES1EZavYzR+QMFtd3e3TtC7OMgIr+34iJUrpm3gSrZPDt8zBzkGCgo=
X-Received: by 2002:a92:2810:: with SMTP id l16mr16773720ilf.9.1598510547460;
 Wed, 26 Aug 2020 23:42:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200313140843.5C65542045@d06av24.portsmouth.uk.ibm.com>
 <CAOQ4uxgabS0GMaMXHbhXoBv9OXAZv9O2WzZ-h9aWhZm6quASOg@mail.gmail.com>
 <20200812140012.875A711C089@d06av25.portsmouth.uk.ibm.com>
 <CAOQ4uxhf6R2Gr1wV_LGbAuDGuuPmnb0Mvx43MxWc2O1gQkrGUQ@mail.gmail.com>
 <20200812170001.50BA6A4067@b06wcsmtp001.portsmouth.uk.ibm.com>
 <CAOQ4uxj7JzmKdrV5Z2AHFFk09OwJL_djjE=JOxVOxQU8HVFkVg@mail.gmail.com> <20200826142714.2CA0FAE067@d06av26.portsmouth.uk.ibm.com>
In-Reply-To: <20200826142714.2CA0FAE067@d06av26.portsmouth.uk.ibm.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 27 Aug 2020 09:42:16 +0300
Message-ID: <CAOQ4uxjCPQF4LxE4kmMuOf3sa7Xrkcm-ZvdjBBtKgNWjY7Qb6g@mail.gmail.com>
Subject: Re: Getting WIP aops branch(ovl-aops-wip) in shape for merging.
To:     Ritesh Harjani <riteshh@linux.ibm.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Aug 26, 2020 at 5:27 PM Ritesh Harjani <riteshh@linux.ibm.com> wrote:
>
> Hello Amir,
>
> On 8/12/20 10:44 PM, Amir Goldstein wrote:
> >> Sure. So here is what I was planning.
> >> I am about to start going over patches mentioned in Amir's ovl-aops-wip
> >> branch. My first preference would be to port it to latest upstream and
> >> start cleaning it up.
> >> I will update the branch details once those patches are ported to
> >> latest upstream. Let me know if we should do this in any different way.
> >>
> >
> > Sounds like a plan.
> >
> >> I will also be joining this year's plumber, in case if we want
> >> to discuss anything on this. Although I am not sure if by then, I would
> >> be able to get any substantial work done to discuss with a wider
> >> audience. But nevertheless, we can always have a call/email exchanges
> >> for this, both before and after the conference :)
> >>
> >
> > Nice. I will be giving a talk on new overlayfs features on the containers track.
> > I guess there won't be much in the hallway tracks this year...
>
>
> I went over almost all patches which you have in ovl-aops-wip branch.
> For now I have only ported some of the straight forward patches,
> since I had few queries on those other patches and one was mainly
> w.r.t. metadata only feature functionality.
>

Those questions you can also ask Vivek if you find him in LPC...

> Do you have sometime today to discuss about it in any of the LPC hacker
> room? I was thinking maybe discussing this in person will help a lot.
>

I agree that a video meetup can be useful to kickoff this effort, but
it is preferred if Chengguang can also attend, because it feels like
you guys need to collaborate.

> Any preferred slot? I could not find you online on LPC chat area,
> we can as well discuss the slot there. But I am fine with any of the LPC
> timings.
>

I cannot do LPC times today or tomorrow, but the hacker rooms are
open and judging by the time of your email you may be closer to my
time zone, so if you want to schedule a meeting somewhere in the next
5 hours, I can join. (7:00-12:00 UTC).

Otherwise, we can always schedule a call outside of LPC, where
participants not registered to LPC will be able to join (Chengguang?).

Thanks,
Amir.
