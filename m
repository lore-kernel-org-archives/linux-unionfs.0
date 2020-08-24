Return-Path: <SRS0=sCFp=CC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B04AC433DF
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 10:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E30720738
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 10:59:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hXDBLp0x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgHXK7z (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 06:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgHXK7x (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Aug 2020 06:59:53 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D32C061573
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2020 03:59:53 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id w20so4809869iom.1
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2020 03:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B3QXPG4PSE3Mk8ZJNT620tiR24HHg5lPWIv0Q6JU6cA=;
        b=hXDBLp0xZeaUlml8chOdN6XSQnCZvcdvGSZ4jV9FPXHCSA7WC/KEOhgZpbnsKpPNHK
         EZiqpGMHyunxgcxeNLuoRiLpc7R148w1lHa9x15FXfPjfOVNo1agHTVWQsjIGamAmmSN
         eQAzZZm9y9epUmHkqs3cJSVAemEctRTpgO//6O1RuiWULpKI6fHGwxysnJrG4ARkQ5K4
         Dyec56xCee4FJaUsVNK0U91/Sx9QO0n2DeDPg8hnXy02S2d+cZOaBd0LsD4dQzcRe+wA
         RaMC/ECXr03JjaW6EtCS7JlDPzan48SS0zXl3NRR3eMKTlukSu0jAfdnanpd9UtyeYMq
         u3yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B3QXPG4PSE3Mk8ZJNT620tiR24HHg5lPWIv0Q6JU6cA=;
        b=mcNSX+1AINR1SY92Sc1tBhJfafPR/vRVO8aXBrwEzgcV0puZFGcpRYyvRYb6bIdIeG
         dO2gAZUw91ovKDxt0hUL3LYnjtMq7yDcP5R8LGrc8K0gpRx8XHMwjgocbA3KNcJHWIAk
         XDd+ugaN3VhE5x7rPl5IueOWJZ/0nMkDU1bu2RfV3h8BwQs5JOAMezqwv7Cw9HsCbGxN
         vOldZynqy7tJFC9a1rHbzU51+ZSM9OwTp6h6BcKS5AmMYpgcb4KocToorWe/ZKWaFl88
         0wMm/M+H3cV6dA/ivPkcMYdJPsLxa4F6cd7xi/TZRgt4TPnnS0n+mTSAhSfP6Ne98TGe
         KRjA==
X-Gm-Message-State: AOAM531Pn5Y0rMALhrCowcm/JaWqkaJ38HA/xRKOIVVZu4YGTR2SwhYG
        yK55E/qmIcfK2hOjiDccvJh7QdoZTjx7snrXcyE=
X-Google-Smtp-Source: ABdhPJzD7iMf912WZzkZlqjfChOQU6QX0vgMFREsghnqP9GP9R2UPyAmzhrTFac4vr1s1yO8jsXbB9JyalEPh26brF8=
X-Received: by 2002:a05:6602:1405:: with SMTP id t5mr4297147iov.72.1598266792311;
 Mon, 24 Aug 2020 03:59:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200722175024.GA608248@redhat.com> <87h7svyqsd.fsf@redhat.com> <CAJfpegtA-16EFFoqhn25rVmXat5hhNUTAWOf+hJEs5L910oQzA@mail.gmail.com>
In-Reply-To: <CAJfpegtA-16EFFoqhn25rVmXat5hhNUTAWOf+hJEs5L910oQzA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 24 Aug 2020 13:59:41 +0300
Message-ID: <CAOQ4uxj0SF1VRbMEvVm4a9TuUtdMYuZqFkZhkUyEGMagCWk5NA@mail.gmail.com>
Subject: Re: [PATCH v5] overlayfs: Provide a mount option "volatile" to skip sync
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Aug 24, 2020 at 11:15 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Sat, Aug 22, 2020 at 11:27 AM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
> >
> > Vivek Goyal <vgoyal@redhat.com> writes:
> >
> > > Container folks are complaining that dnf/yum issues too many sync while
> > > installing packages and this slows down the image build. Build
> > > requirement is such that they don't care if a node goes down while
> > > build was still going on. In that case, they will simply throw away
> > > unfinished layer and start new build. So they don't care about syncing
> > > intermediate state to the disk and hence don't want to pay the price
> > > associated with sync.
> > >
>
> [...]
>
> > Ping.
> >
> > Is there anything holding this patch?
>
> Not sure what happened with protection against mounting a volatile
> overlay twice, I don't see that in the patch.

Do you mean protection only for new kernels or old kernels as well?

The latter can be achieved by using $workdir/volatile/ as upperdir
instead of $upperdir.
Or maybe even use $workdir/work/incompat/volatile/upper, so if older
kernel tries to re-use that $workdir, it will fail to mount rw with error:

  overlayfs: cleanup of 'incompat/volatile' failed (-39)

If we agree to that, then upperdir= should not be provided at all when
specifying "volatile".

Thanks,
Amir.
