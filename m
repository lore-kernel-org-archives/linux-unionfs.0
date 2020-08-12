Return-Path: <SRS0=do5T=BW=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35AE6C433E0
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Aug 2020 17:15:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEC1B2076C
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Aug 2020 17:15:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VEedD0ry"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbgHLRPE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 12 Aug 2020 13:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgHLRPD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Aug 2020 13:15:03 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B6E4C061383
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Aug 2020 10:15:03 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id b16so3686555ioj.4
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Aug 2020 10:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rKsjxVGA2bKD/sTq28IiTi9mhjatx71mW9gui6lnpXY=;
        b=VEedD0ry+X6Ldafjpdm0FV9UsJr7YniuLAywUN2mMEQfUZ9NrE8pXXE1dMHM6DLO6V
         SVap9eWtPFJnTLfgPz2UYiH3Ua75fp/MxO4ry+i4dYHNgvujvqV3R6dk6vTsCm79Y4Za
         HHcYuBPElD+m4sGmmX/cl5Y7wtAthywwboLaPr2r2w6prmbQ/EU6qEemPElbDgLdpsho
         PBlaz+dhO0ZwB4JsoZRt24l2qiUV1VD7HwzV/OLdKqb49DbQpWbNjPiU9pbcsvaXAANw
         0cahcvJKNZH+mhSnSD88yncUjr1pIRI7Mf7NMdgexH7P6vFOhn5BXr4O+j7NGG3MOtDr
         gZww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rKsjxVGA2bKD/sTq28IiTi9mhjatx71mW9gui6lnpXY=;
        b=YxhT9A4gzw2TXX4nTLU7GuRLVUIC5mKKaVii0DD7jMg3XT2gqTIEkszx/s7zsM7M2g
         MtBlhoynt8IPbWCupt8de9e5txH73bSMLGLWQEyHZDO+rEHVXSyXClEYY3O0WrABrU0j
         LgS6pMrrSg+nD//rWTluO7WlkvjGGYZLTYRZEGLQGgf6N7DceLocdPr3fsKfy0ryxs1Y
         flEyhjrCKx0YSr2ByEZjZqUGfZHBCZ/xz2KwJevihu4Mq1VlKEG//ADm15/+MX9Dfmfn
         0kHG99O2hsJdG8RRdajIWUVGsxKlJgPAFNed9PNiHynPn2kE4JoUE+eYHG5QCmyKfyvr
         OKEg==
X-Gm-Message-State: AOAM532BEh1Z82GRn4o2EYeN8IWzVc1DtHVS1EKJHLXR0JXZE9dNfIc3
        SwGGNfsre62EP6Di5FbyhixqXbluFavqL1F0uWuRmw==
X-Google-Smtp-Source: ABdhPJx42VDIjiJjAdmkIcr51UKw/qhPmGWCOrqxsQrzF3BgX9t1PyoPEhdkwJML0Hf/hcpBEELwCQQliP4jG9WThjg=
X-Received: by 2002:a5e:980f:: with SMTP id s15mr787604ioj.5.1597252501510;
 Wed, 12 Aug 2020 10:15:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200313140843.5C65542045@d06av24.portsmouth.uk.ibm.com>
 <CAOQ4uxgabS0GMaMXHbhXoBv9OXAZv9O2WzZ-h9aWhZm6quASOg@mail.gmail.com>
 <20200812140012.875A711C089@d06av25.portsmouth.uk.ibm.com>
 <CAOQ4uxhf6R2Gr1wV_LGbAuDGuuPmnb0Mvx43MxWc2O1gQkrGUQ@mail.gmail.com> <20200812170001.50BA6A4067@b06wcsmtp001.portsmouth.uk.ibm.com>
In-Reply-To: <20200812170001.50BA6A4067@b06wcsmtp001.portsmouth.uk.ibm.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 12 Aug 2020 20:14:50 +0300
Message-ID: <CAOQ4uxj7JzmKdrV5Z2AHFFk09OwJL_djjE=JOxVOxQU8HVFkVg@mail.gmail.com>
Subject: Re: Getting WIP aops branch(ovl-aops-wip) in shape for merging.
To:     Ritesh Harjani <riteshh@linux.ibm.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> Sure. So here is what I was planning.
> I am about to start going over patches mentioned in Amir's ovl-aops-wip
> branch. My first preference would be to port it to latest upstream and
> start cleaning it up.
> I will update the branch details once those patches are ported to
> latest upstream. Let me know if we should do this in any different way.
>

Sounds like a plan.

> I will also be joining this year's plumber, in case if we want
> to discuss anything on this. Although I am not sure if by then, I would
> be able to get any substantial work done to discuss with a wider
> audience. But nevertheless, we can always have a call/email exchanges
> for this, both before and after the conference :)
>

Nice. I will be giving a talk on new overlayfs features on the containers track.
I guess there won't be much in the hallway tracks this year...

Thanks,
Amir.
