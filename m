Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B705BC433EF
	for <linux-unionfs@archiver.kernel.org>; Tue, 19 Apr 2022 14:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbiDSODw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 19 Apr 2022 10:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238692AbiDSODv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 19 Apr 2022 10:03:51 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108C613FBF
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Apr 2022 07:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1650376865;
        bh=/4mM1U2bjx4Fy8z2B7P1fETVi8k09m4ldCezXZViXX0=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=NEdf5BxiZZjOyH2MaDw20C1x/kZrC1awXHddOndL5E8MmW7ZPFFsqRqzY5K0MKxSz
         Csl+ZZ4AHBjbPTimuPQYGu6IoRm1uO9PXVshOoXltLSfDa5A+vFvQ+ZxeFmBRC8TYB
         sUlj14/9GGFyiSUlTgvuRFGnHg+FRfv0j+bcdQAw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [10.54.0.101] ([87.167.92.4]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mq2nK-1oJm7v3HdK-00n7X7; Tue, 19
 Apr 2022 16:01:05 +0200
Message-ID: <330252e9-45c1-26f2-4add-b2dcd2701bb7@gmx.net>
Date:   Tue, 19 Apr 2022 16:01:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: overlayfs: supporting O_TMPFILE
Content-Language: en-US
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
References: <951c68ed-3f0e-8d9b-6c10-690df778ecc2@gmx.net>
 <CAOQ4uxh_P0fiV9gQOs9CLvB+xJpJT4hWfAFyKBx0A-TyxAma8Q@mail.gmail.com>
 <YXvvAMJxj/DlyUqC@miu.piliscsaba.redhat.com>
From:   =?UTF-8?Q?Georg_M=c3=bcller?= <georgmueller@gmx.net>
In-Reply-To: <YXvvAMJxj/DlyUqC@miu.piliscsaba.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:LoYYBKbhPyBu+i6ubqgvwwNPk3vr1QxoyCZe5uiGu/EOmdbqldI
 tVJ6s5Ym7cDO1jIaJX29AcOpAUJ8ZzaBJihpi/AcvWwzpMCZjJI/YQJzyKW8aVyI01uVWwZ
 Ebq0/UBWu5ZoNcKguNbFn9oO3+Ead/FUBj20o0ApW9vg0Qto1tAN8Hm/1jpai81x8wvMsDN
 J8l3PVNrS7dxVGoib7S5A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:kYA+x2WSyxk=:9YxyDTM3oouPU7Uagfpg3+
 acTs2nvFiYMAxowaE1jO9NLb3P8h5adOZGJmvqawdGphhT4Os+eQm6ScC4B5u0kWQm/4hvVnj
 PaAEJ9WPbax+sryVJlcQG16lsTfupMVhez0/WbWzKvuMIujolL2LfBvHGysfwfWycQ0nU5mgS
 O7PfPLc1mNQYkNvJvn3LdUMzlBcgm8oOwVWAG1T4/Jvk69KhyvDJr1ax0xWB5Lxez0LjiFqja
 2zx/bEZQ5qa9MR/0++2/0M7ySGwVOSTBkbzuUq8tjihxt0M8QelvrGlLF/WnvhzyPuyx5WImk
 S1Z4V7FYsMhEESSQHYf0ppu8x2K5l8mxYdFWE9XPbPKVdSys2SBXokeGLBQ//5tjEs/dr81Nn
 K3VhtZAuljYa0QIgCUdQsuKrfsDuPt27BlQI7vEGyFrMy9ClIOr+Ah08h09nBwcqj+G+YEE15
 iwtUTIQ1clBsvLB9wDVihev83SehgWeaXjPEmjIDBwSRn1H63dPKyREBIhmEXZbKFLP7frKiu
 pW/+rYhLxOD23YOKQuNsf6NI5gHjl/T2Yu1jI3kAKPpAyan24IbU3QePmnH8CFWxj9E2ikNBv
 PQrC4fxm04wxhigX0cr55qs1gLfwslXQzST4/P7HLcwqpiOj+9Z67xEUzXK0mB8nqfqmeEwq9
 pSW34RuSUQ6hs5uTUk+dBkXDKz7XNlpdauK/yLZMlESFdGO1vQBOZ7MUKgRQcT7TXkWtVhsoH
 A1U/+GCiBX6J49zKG9zs19fcpl08U273W8+/y1dYOR3UBW2GsGvVTxjSry/yorZ9n8Bl2BnHh
 E88QXZVAtu7d6a/V07HVbg1T72MVBlxFCWpGN9n7nhFs/wbVQ0oLpwdbqImbzqWiVVAKRwte8
 aQWR+1FjpAEFfZiv9KmKBNaoL/Z4qEzF+h6Oe9D4PEBhiyWRz909yMZAe+j8Ws7bOqBOb1Yxj
 ZCKKvBR9L6QEMM6ZzBFuK797q98fglKZANcMlg/DJOLeIBmIH0u9Nj1h/a1ch++8GbHc731T3
 N+IsoVos9AkdtQlMWEoHjXx5L7/H4HoqO75dkFB1a3xeX3DC9mw2HVg2wuYN29OOrwUUZDM6W
 tubPTOqhXZ0lXo=
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Miklos,

Am 29.10.21 um 14:54 schrieb Miklos Szeredi:
> Here's something I prepared earlier;)
>
> Don't know why it got stuck, quite possibly I realized some fatal flaw t=
hat I
> can't remember anymore...
>
> Seems to work though, so getting this out for review and testing.

Is there a special reason why the O_TMPFILE patch from you is not consider=
ed for inclusion?
Are there more tests I could do?

Best regards,
Georg
