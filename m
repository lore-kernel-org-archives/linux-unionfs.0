Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6855AC433F5
	for <linux-unionfs@archiver.kernel.org>; Tue, 15 Feb 2022 09:25:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235867AbiBOJZt (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 04:25:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbiBOJZi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 15 Feb 2022 04:25:38 -0500
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE696CA5F
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Feb 2022 01:25:28 -0800 (PST)
Received: by mail-ua1-x930.google.com with SMTP id v5so9511677uam.3
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Feb 2022 01:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pztr6ZjrlMm6SZ2CFckcy5D/+COkYlSBkp7ZDH5NxlE=;
        b=DVKNS09tcQMmgoykdKjbTy9TXc69ELQdOOWpM9+isnzq9AcxllCN6+3cnj87EOEKRp
         e52Rz8CXQVR5NKiYBfhTwZ7nhk9Unkq/0DeYI2gmTC3iYuOhwFll+remTQ0WYDZ5UeoX
         1mxpMF1lI8IlHjG9T7qhHNWVkYsowh/4vhY1A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pztr6ZjrlMm6SZ2CFckcy5D/+COkYlSBkp7ZDH5NxlE=;
        b=Ykk+6Q/RdzR/gq4HmMY7CHPhPpBak6hthuGFTdU3vL95hF2vISw592zfZW29fXoK+C
         fmtQpUyduzPqVPFqZ3tEzYgi9mngTirRkxESgpE6jjTGBoUdPbAS7XV0MaqN4P4ixXnk
         tpqXCvT5S+Bt78H958rMdRlgYIoFpcnfEVOxaUsdDC7t9uEP8aVKropufiKm4YJZMhZR
         +dJb2tCmnTpym/hdwo6PZvfmdf3SWgmr6gibTg3RiGOPOYfMpIZKdlESr8rTsN14vxA3
         BO7j/Hhxjc5VlEoRbB+gXzyCHfpZ3uF0MvWDM56b44y+7po3lQv/VgDRZngFDfpY33cT
         7z5w==
X-Gm-Message-State: AOAM532rX+3K9K9JwZ7lDFpxeFd/iNia4izJfZ68eR9uKKLG1hDJWrZI
        g3IQf45QEeaIfKgtz46uNuElNoEI1N+U8uYRgb3trg==
X-Google-Smtp-Source: ABdhPJzpo81BcjwjAi4JkpMuvtX8237p3398kdXcjI0PcOugjKoZ/ShDIT3/oWPm9RFeUkzm1c5Dre5rJwVAm77+Pq4=
X-Received: by 2002:a9f:31b2:: with SMTP id v47mr991333uad.8.1644917127382;
 Tue, 15 Feb 2022 01:25:27 -0800 (PST)
MIME-Version: 1.0
References: <8d81eae9-1fb9-6c66-2c31-b02540db6af7@mykernel.net>
In-Reply-To: <8d81eae9-1fb9-6c66-2c31-b02540db6af7@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 15 Feb 2022 10:25:16 +0100
Message-ID: <CAJfpegu2L-7wk0ZUHGs5yv8PgEF1mwJ2oCvXwJiNQToLkakwCg@mail.gmail.com>
Subject: Re: Question about fsync in copy-up operaton
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, 13 Feb 2022 at 15:56, Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Hi Folks,
>
> During copy-up when parent dir does not exist then will create parent
> dir first.
> However, I noticed only regular file calls fsync in the end of copy-up
> operation,
> so how newly created parent dir get synced in this case?

Looks like an oversight.  It should fsync parent dir as well.

Thanks,
Miklos
