Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C8FC43219
	for <linux-unionfs@archiver.kernel.org>; Mon,  7 Nov 2022 08:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbiKGIuM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 03:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbiKGIuK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 7 Nov 2022 03:50:10 -0500
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57CC15709
        for <linux-unionfs@vger.kernel.org>; Mon,  7 Nov 2022 00:50:09 -0800 (PST)
Received: by mail-vk1-xa35.google.com with SMTP id m18so6144488vka.10
        for <linux-unionfs@vger.kernel.org>; Mon, 07 Nov 2022 00:50:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gCe+V3vnWxM8Fvdjfxrl+xBSBh4TT9H+RqWy8szJZLc=;
        b=P4na/VnHcADbQ7ZJZn4PnqsMUfO6QVKT6sggmlhW/aon/IgdnV4B8AwvLKDuRs0vhh
         v9GjSa7jcvIDE+24UdddsKzRPMuEC3G1wFu+K7lYmlbvoz1y8k69VqYVW0ZDGEj3R1Yc
         1UXHn7JMhTN5BZ4ttJjWiJuo0jCBP2Fr0CBMgQc/dcf2oTd2ct+JjFJz1YRglBNyvFH9
         onlt+wRt+skLHaTEHZYHnYgEXidME8oF00hTX8O239YvD/eF6xYAMbQDf4UtoXBav12f
         aarOBBSNGXroc3JcYKMgwO63cm0DcwsmiU5nHtJ11uQrVdPpRrMDMmZoJ8jQzYB2Og9M
         Wyrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gCe+V3vnWxM8Fvdjfxrl+xBSBh4TT9H+RqWy8szJZLc=;
        b=qBRpi3SJez3poozlZe0J9hWGZEKa7+qBiE16ZkVZhlcCGxEtJpT/JrRziknTHtdLQx
         ogXBnGBQv/kW3tz/Pao/alqEfJNtxSC+mvwpHQzTtTEstlG2wQ/PHCUPP4F9qnZvxqqR
         q6e9DVmuwhvJZ+9y35yKwj5bCrfuSe6i3OE9VbP6rFrxQi5lamaE314Nz6qmfs2yoHMb
         RJVjZ5wDfnczJBspTRjD3zzkq7BFmn7WbUoBZGvzG4D8vVjIfAqPt0nDPgq/cqNneZ8x
         Kq+xETd0AifELTDaiIa5TE5vP1p7EGf7HrdlopdrLdYcDv7aoWYBCaYqRe4tE3PYq8WS
         VYxQ==
X-Gm-Message-State: ACrzQf0G7ATWBKRbpb3aP066EYloVe1yQPg71uOCsIZFXd/6SSNkv/UW
        wTxMuA8Irev8178w1kMXNknDu4Y4dcKdM+GiH08uIgTj+1M=
X-Google-Smtp-Source: AMsMyM6Dm6ExtpuX0RKT7+EcwVJlKSRBDO5t2XBUwEjzOOhSkpjmJBNuvtdefGPSPHvif5vz8/mYOtRxEDUhklI2x5Q=
X-Received: by 2002:a1f:90c5:0:b0:3b8:1bc1:d644 with SMTP id
 s188-20020a1f90c5000000b003b81bc1d644mr23366216vkd.3.1667811008625; Mon, 07
 Nov 2022 00:50:08 -0800 (PST)
MIME-Version: 1.0
References: <20221107042932.GB1843153@ubuntu> <CAOQ4uxipsS3Xf00fvY4fEBgJX8MZK2VW8sHANLA6h8qoEeAiCA@mail.gmail.com>
 <20221107070621.GA1860348@ubuntu>
In-Reply-To: <20221107070621.GA1860348@ubuntu>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 7 Nov 2022 10:49:57 +0200
Message-ID: <CAOQ4uxg6ZsWKqgRBTxfXkfYP0xpf7CvpYsc7aj_1SgvDGYLjJA@mail.gmail.com>
Subject: Re: Re: Question about ESTALE error whene deleting upper directory file.
To:     "YoungJun.Park" <her0gyugyu@gmail.com>
Cc:     linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Nov 7, 2022 at 9:06 AM YoungJun.Park <her0gyugyu@gmail.com> wrote:
>
> On Mon, Nov 07, 2022 at 08:40:02AM +0200, Amir Goldstein wrote:
> > On Mon, Nov 7, 2022 at 6:38 AM YoungJun.Park <her0gyugyu@gmail.com> wrote:
> > >
> > > Here is my curious scenario.
> > >
> > > 1. create a file on overlayfs.
> > > 2. delete a file on upper directory.
> > > 3. can see file contents using read sys call. (may file operations all success)
> > > 4. cannot remove, rename. it return -ESTALE error (may inode operations fail)
> > >
> > > I understand this scenario onto the code level.
> > > But I don't understand this situation itself.
> > >
> > > I found a overlay kernel docs and it comments
> > > Changes to underlying filesystems section
> > >
> > > ...
> > > Changes to the underlying filesystems while part of a mounted overlay filesystem are not allowed.
> > > If the underlying filesystem is changed, the behavior of the overlay is undefined,
> > > though it will not result in a crash or deadlock.
> > > ....
> > >
> > > So here is my question (may it is suggestion)
> > >
> > > 1. underlying file system change is not allowed, then how about implementing shadow upper directory from user?
> > > 2. if read, write system call is allowed, how about changing remove, rename(and more I does not percept) operation success?
> > >
> >
> > What is your use case?
> > Why do you think this is worth spending time on?
> > If anything, we could implement revalidate to return ESTALE also from open
> > in such a case.
> > But again, why do you think that would matter?
> >
> > Thanks,
> > Amir.
>
> Thank you for replying.
> I develop antivirus scanner.
> When developing, I am confronted the situaion below.
>
> 1. make a docker container using overlayfs
> 2. our antivirus scanner detect on upperdir and remove it.
> 3. When I check container, the file contents can be read, buf file cannot be removed.(-ESTALE error)
>
> And as I think, the reason is upperdir is touchable. So it is better to hide upperdir.
> If it is hard to implement(or maybe there is a other reson that I don' know)
> it is better to make the situation is clear
> (file operation error, inode operations error or file operation success , inode operation success)
>

Error on read is not an option because reading from an open and deleted
file is perfectly valid even without overlayfs.

ESTALE error on open is doable and makes sense and I believe it may
be sufficient for your use case.

I have an old branch that implements that behavior:
https://github.com/amir73il/linux/commits/ovl-revalidate

You can try it out and see if that works for you.
If it does, I can post the patches.

Note that the use case that you described does not need the last patch,
but if the anti-virus would have moved a lower file to quarantine
instead of deleting it, the last patch would also be useful for you.

Thanks,
Amir.
