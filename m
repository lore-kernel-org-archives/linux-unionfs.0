Return-Path: <SRS0=sCFp=CC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D1AC433DF
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 21:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6F36204EA
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 21:52:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="knlO/o/c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgHXVwI (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 17:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHXVwH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Aug 2020 17:52:07 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B894C061574
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2020 14:52:07 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id r13so8680052iln.0
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2020 14:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8oQY9zeqsURSOJ82LvUdRc3y378MvqUrpnz2xsT3XSg=;
        b=knlO/o/ciEbg8p0lp4FGbCuE3Ow7atzx/xrbb433XldOJtCvR1znAOJBU3g0X3dSw1
         l2dG9kKcPnFoOWAtWgc3ld86w5tlcm4k1knp20qdNV3K2jWfHGEZIXydbgYdlcFX4eYb
         EAKZ2ZBXvN+Gn7qXt1wbnznTNrNJfwarxpZD5R4q/VejJFxr9OUIIZMujQDSRPFdwXHp
         C8xr8CQ3NnBV0OdyjuGawUvVG0Cg1f1bcxFVshP+APklbK3w+K0qmq0nKXQBtxPCmRPG
         S6RyIOhQxg2i/8vif+lIioH9o32ukdSVXsu2uP6u1B7s42Ubp79gkqH196kfyszF2DJ9
         bFfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8oQY9zeqsURSOJ82LvUdRc3y378MvqUrpnz2xsT3XSg=;
        b=frYz5ry6k5sFtQ12cCM55VPXNMS6w/SgpbhOnmS4HqbaRjLmoh352axDYqxWYzWglx
         B8HM2Yk0RinmI3OPXlpFq4qIEAJLlVsB9gcn/PNtIRuqrqPaQRVml6cccvhnZ5Ggw/iE
         D9EN3vW4pAaftOVq6dV9G/76e7ATEHpLNTxzkCVWw19l0MzmQcK3E7jhf0Z6Ij9slYpu
         Uv0/nYZ27WNr+itJW2qlK8uIcCTEUC6IV4NdMttgGRLvLCfOXiChbdfGOswydIkldrbx
         w5F2SSntw+ovFYPdb1NGj++nKrmOi38qk+pnDjkocM2xKYPPprmFvfGxzTnEZiSzUROw
         8qAw==
X-Gm-Message-State: AOAM530ZjxhUMYePbc9LGTAQl73NILOlbbpViBGMA7BfvXEMNe3OPjHC
        UwbZZIgPjUc61DRAXIZ3l86dvPB4XXNY2c8bVaE=
X-Google-Smtp-Source: ABdhPJxDZlJaFOLHMfiJkitIPIMJp13WyoImTyFmLIa6Ha18tRJ4QOw3+dpMeMRLYjMJPlucGPiqGW5CAbHwS3dmxfs=
X-Received: by 2002:a92:1fd9:: with SMTP id f86mr6802602ilf.250.1598305926438;
 Mon, 24 Aug 2020 14:52:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200722175024.GA608248@redhat.com> <87h7svyqsd.fsf@redhat.com>
 <CAJfpegtA-16EFFoqhn25rVmXat5hhNUTAWOf+hJEs5L910oQzA@mail.gmail.com>
 <CAOQ4uxj0SF1VRbMEvVm4a9TuUtdMYuZqFkZhkUyEGMagCWk5NA@mail.gmail.com>
 <87a6yknugp.fsf@redhat.com> <CAOQ4uxg4xmvsoKVBfGJ0SVCXfM6aeNji6c8FSCevxV-FYX3LtQ@mail.gmail.com>
 <874kosnqnn.fsf@redhat.com> <CAJfpegvaUz_M0jtibOk=a6Cx=U9JBnOcVSmF2xM9cyVmCz8CFg@mail.gmail.com>
 <20200824135108.GB963827@redhat.com> <CAOQ4uxi9PoYzWxKF0c2a9zzxnrZMeB08Htomn1eHjYha-djLrA@mail.gmail.com>
 <20200824210053.GL963827@redhat.com>
In-Reply-To: <20200824210053.GL963827@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 25 Aug 2020 00:51:55 +0300
Message-ID: <CAOQ4uxhvi5wHhPKivrWzOJ8ygyETDVqc4h4MW6uYN=h1T2B+BA@mail.gmail.com>
Subject: Re: [PATCH v5] overlayfs: Provide a mount option "volatile" to skip sync
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> Ok, I am wondering why are we concerned about older kernels. I mean,
> if we introduce new features, we don't provide compatibility with
> older kernels. Say "metacopy", "redirect_dir". If you mount with
> older kernel, they will see something which you don't expect.
>

True. We missed the opportunity to do the work/incompat trick
with metacopy etc.

> So why "volatile" is different. We seem to be bending backward and
> using an unrelated behavior of overlay to provide this.
>
> Why not simply drop a file $workdir/volatile for volatile mounts
> and check for presence of this file when mounting?
>

That's an option.
But what's the problem with
  $workdir/work/incompat/volatile/dirty
compared to:
  $workdir/volatile

It's not more complicated to implement is it?
So we get some extra protection with little extra cost. No?

I don't feel strongly about it.

But I must say, according to Giuseppe's description of the use case:
"mount volatile overlay+umount overlay+syncfs upper dir..."
looks like what he is looking for is "volatile,sync=shutdown", is it not?

And if this is the case, I think it would be much preferred to implement
"volatile,sync=shutdown", over documenting how to make a "volatile"
overlay mountable from outside overlay. Don't you guys agree?

Doesn't matter, either way, the same protection will be used.

Thanks,
Amir.
