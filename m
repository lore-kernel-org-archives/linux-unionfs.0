Return-Path: <SRS0=uZ0x=7I=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D20DC433E0
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 May 2020 08:25:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A9E32071A
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 May 2020 08:25:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="onKGObla"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgEZIZ7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 26 May 2020 04:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728248AbgEZIZ6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 26 May 2020 04:25:58 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41F6C03E97E
        for <linux-unionfs@vger.kernel.org>; Tue, 26 May 2020 01:25:58 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id b71so19486139ilg.8
        for <linux-unionfs@vger.kernel.org>; Tue, 26 May 2020 01:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CCoQRlTB5BX4UETF4wINpGrqmx2niEKXBsxk7b5UPpU=;
        b=onKGOblaZDWH92975QhuSdU2M2wO+CkJVHGIjLR5RGVI1W9vk8r/OmEW4fEPeI6OOl
         wj+oskWtheM0scBexL6bzk1Jz6TOptb5IolG+8kjioZHT/845xh5/J6oaESeHIyZyaLB
         wJBcFKPH3yyCldm/YzI9t22QTGCUW14Llyz4yeGTgUeN95feZ1j6awxOBvGa4xRoitaW
         M+LFQ5R/+BDD9xSEnFIqCNg4qoLmilFAc3loEhRPDcf35grZgiJER+7qW78Ww+68/aih
         ZpigAXEHy3FzeZcIRZveUpQtPZ1CllrtTo5wE2iGr9Xag0PYcbsODmUqSfuqwA4dMAUl
         LhKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CCoQRlTB5BX4UETF4wINpGrqmx2niEKXBsxk7b5UPpU=;
        b=iUyg0zm9l92PnGF1+v/A5b3WZz6oyB3okKfwif0GclDUAhOwX2IO8/aoZNvzuQEvlG
         aAVmYtuHcEvnBy7isfSVYAHTJ0jxUhs6kwlKFIVIvRX76pUp5/9NLUgsr6E3X5LQqgHP
         7Q0Y/GqOaeDuosGnM1umtJl9VCVcPUkmI2W/KFmoS/08K4H35QghbOzzAlXhynI/vA3c
         bG2Stpeo4/ChZZ/kl8lT/M+iJneBGs5idsnayt+vMSx9B14nsNFDx9yzxqj5US6ZFw5n
         2tTwYUTXraDt6BmPsVpWKEf86eaO12JA6CJJW7esW3eKKouMgSOpBweIcMbkhiVXG7Ob
         UrAA==
X-Gm-Message-State: AOAM533aN2duEutWcL6KzJ6v1Do2ASIxDLRcAtgnXkMIaU1quhfDCaeC
        VLrWoTZia6Lchop+d1XEx3BAUAtAPEIFl3nJdg64BhnK
X-Google-Smtp-Source: ABdhPJyYS62oj1TULUv3Hx1B3YSK/4f+QbM+oDCy7f3m3G66aOtIbupyq1VRGxqB2A5vdxSc4LQUoRW9N2NlGPiny3Y=
X-Received: by 2002:a92:4015:: with SMTP id n21mr82556ila.137.1590481558148;
 Tue, 26 May 2020 01:25:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200506095307.23742-1-cgxu519@mykernel.net> <4bc73729-5d85-36b7-0768-ae5952ae05e9@mykernel.net>
 <CAOQ4uxi4coKOoYar7Y==i=P21j5r8fi_0op+BZR-VQ1w5CMUew@mail.gmail.com> <6bce615e-b8ef-e63f-3829-e2b785a02f5d@mykernel.net>
In-Reply-To: <6bce615e-b8ef-e63f-3829-e2b785a02f5d@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 26 May 2020 11:25:47 +0300
Message-ID: <CAOQ4uxig6SXJnMKPbA95_JkWnWLU_tY_yKn9vW4mvGqw=qKuzg@mail.gmail.com>
Subject: Re: [PATCH v12] ovl: improve syncfs efficiency
To:     cgxu <cgxu519@mykernel.net>
Cc:     Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Sargun Dhillon <sargun@sargun.me>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> >> In high density container environment, especially for temporary jobs,
> >> this is quite unwilling  behavior. Should we provide an option to
> >> mitigate this effect for containers which don't care about dirty data?
> >>
> >
> > This is not the first time this sort of suggestion has been made:
> > https://lore.kernel.org/linux-unionfs/4bc73729-5d85-36b7-0768-ae5952ae05e9@mykernel.net/T/#md5fc5d51852016da7e042f5d9e5ef7a6d21ea822
>
> The link above seems just my mail thread in mail list.
>

Heh sorry. Wrong link. Here it is:

https://lore.kernel.org/linux-unionfs/CAMp4zn9NsrdByVzWbThBd7Y0DsufJnqp=LdbDscbtyZx82E0Ug@mail.gmail.com/

Sargun, do you have anything to contribute to this discussion from
your experience?
Are you using Ephemeral containers?

Thanks,
Amir.
