Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CECDC4332F
	for <linux-unionfs@archiver.kernel.org>; Mon,  7 Nov 2022 06:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiKGGkQ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 01:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiKGGkP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 7 Nov 2022 01:40:15 -0500
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C014E5FEE
        for <linux-unionfs@vger.kernel.org>; Sun,  6 Nov 2022 22:40:14 -0800 (PST)
Received: by mail-vs1-xe35.google.com with SMTP id p4so9643043vsa.11
        for <linux-unionfs@vger.kernel.org>; Sun, 06 Nov 2022 22:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MAqeL0PzON61c9ptLCC0g1d3q7wxHoBFenPGcOUAa60=;
        b=iUv//T8B2ST2oN6ehnOQ73XqvBhQyozkTE/gMDmpEgZ4oJR8+c/YY2jB9C0meogo2s
         6xpuDD+Sm7FHrsXpicPGckoDqrPr4TjlowQhOrB/KGRepQMeo3t6t9kR7gein/GH3wIK
         ZPfIVZ9U04Mb4H7FxuJp/TkU5R1UuYyzo6um71rxkKDarfJT0UPJuweE2G+WFcDcBu/7
         SmtDnj64HSH85Tx79gu5Pzq4LlhvKVP07qy+0AHItzAGNLGknigteV5WwnN46yf9AG9F
         e+CS0mZiVD3obfzcXrLrQqvQoXehvuNnkC608ZWmBryA9Yc+c+liSdD6DF4y3bb5UidQ
         pz+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MAqeL0PzON61c9ptLCC0g1d3q7wxHoBFenPGcOUAa60=;
        b=eVfhGg5dPjmG5tXLq3f2XY86jNwn+XaVJ4JFz7in30T7IKQm22QgtXj3/Xq5mNbXkE
         cUt7ILe15sEkKbHUBGheCG7GAZ0n4uL/xH/XG0iwGSJl51EPl4//oonGNfHi/oS7+NbM
         sJLWwVzBWe2ho0XWcNrlq5DaDMXUoQjnOQP/sOBi3qpUvjmZzizBEcFdauFss3XBdy6k
         E9H48b0Rb94OfKkWo8EwUGZ+qOJcQYZ2HXGSH/S+YOh2+Xm0c2aeI8M9/OeS4M9tjSfC
         U+c0MgQfOep06le43bNov9rNSbZy7XbwOBvsGf1Mpv1Gwb+b+BwQb1f2GDrAUIglEgfn
         zd5A==
X-Gm-Message-State: ACrzQf2Ijk4H9/VQrhnTOoUPVwPASf0RFdKgXycYQWH5o0WJemE7hfjq
        eQwtCBp2MpTbXH2Tcp50tMYq0d7d5/mnuJIZwibihl1Y
X-Google-Smtp-Source: AMsMyM4JIJoN5y2cuqXa8EbLgZr3bTRlGytVlYmZZaSAqQbqe1pDTmvHZYZup7l7S5/FlDbaKQBe3DLEOomStpGDrZ8=
X-Received: by 2002:a05:6102:34f0:b0:3ad:7898:aa49 with SMTP id
 bi16-20020a05610234f000b003ad7898aa49mr8686787vsb.72.1667803213783; Sun, 06
 Nov 2022 22:40:13 -0800 (PST)
MIME-Version: 1.0
References: <20221107042932.GB1843153@ubuntu>
In-Reply-To: <20221107042932.GB1843153@ubuntu>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 7 Nov 2022 08:40:02 +0200
Message-ID: <CAOQ4uxipsS3Xf00fvY4fEBgJX8MZK2VW8sHANLA6h8qoEeAiCA@mail.gmail.com>
Subject: Re: Question about ESTALE error whene deleting upper directory file.
To:     "YoungJun.Park" <her0gyugyu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Nov 7, 2022 at 6:38 AM YoungJun.Park <her0gyugyu@gmail.com> wrote:
>
> Here is my curious scenario.
>
> 1. create a file on overlayfs.
> 2. delete a file on upper directory.
> 3. can see file contents using read sys call. (may file operations all success)
> 4. cannot remove, rename. it return -ESTALE error (may inode operations fail)
>
> I understand this scenario onto the code level.
> But I don't understand this situation itself.
>
> I found a overlay kernel docs and it comments
> Changes to underlying filesystems section
>
> ...
> Changes to the underlying filesystems while part of a mounted overlay filesystem are not allowed.
> If the underlying filesystem is changed, the behavior of the overlay is undefined,
> though it will not result in a crash or deadlock.
> ....
>
> So here is my question (may it is suggestion)
>
> 1. underlying file system change is not allowed, then how about implementing shadow upper directory from user?
> 2. if read, write system call is allowed, how about changing remove, rename(and more I does not percept) operation success?
>

What is your use case?
Why do you think this is worth spending time on?
If anything, we could implement revalidate to return ESTALE also from open
in such a case.
But again, why do you think that would matter?

Thanks,
Amir.
