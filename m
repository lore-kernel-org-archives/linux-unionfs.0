Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A80BC433EF
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 Oct 2021 15:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19D7861165
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 Oct 2021 15:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhJ2PTR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 29 Oct 2021 11:19:17 -0400
Received: from mout.gmx.net ([212.227.15.19]:57509 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229527AbhJ2PTQ (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 29 Oct 2021 11:19:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1635520606;
        bh=J2VEsNhC4V/NyE9M4ez//6e3kjcM6JxeE/FpC6QjRs0=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=TyR03GA1gLsHzYw3PXQuGkeRpppdf1rdeNRyILZw0jLw4KwQ/MopYIC1Q06688RSQ
         2sNgn9250EBAzT9OZEttX3iXukTRmy3mM3UIlWNcAY0X1JK2jBsfBM7XFdH+/Zkvsc
         /9MgPd2m+rqKQ54Im1GOnwRpqn8QQp8kPiJva1C0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [10.54.0.166] ([87.167.93.4]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MNt0M-1mIL1Z3uIq-00OCUK; Fri, 29
 Oct 2021 17:16:45 +0200
Message-ID: <24940d86-e279-8586-7be7-52dab9215ead@gmx.net>
Date:   Fri, 29 Oct 2021 17:16:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: overlayfs: supporting O_TMPFILE
Content-Language: en-US
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
References: <951c68ed-3f0e-8d9b-6c10-690df778ecc2@gmx.net>
 <CAOQ4uxh_P0fiV9gQOs9CLvB+xJpJT4hWfAFyKBx0A-TyxAma8Q@mail.gmail.com>
 <YXvvAMJxj/DlyUqC@miu.piliscsaba.redhat.com>
From:   =?UTF-8?Q?Georg_M=c3=bcller?= <georgmueller@gmx.net>
In-Reply-To: <YXvvAMJxj/DlyUqC@miu.piliscsaba.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:SOn5saGGbbRUg6OGcBfheSyr2YSjfoGiCpfG0GlU7msz9k0fN9Q
 FWmiVk+UuBs5WQsmwxxlOY31fY0bu/hoNdD0owd0yROh6Y3Onp+72VZEFQb53wnWFV4gyO+
 v9Xbi2BCY4gdQuIezsCdIQu8HMqpXOy0vKeHT+nH6ApQtvT+NCdtVLqLeaUEu6lnszl1edi
 e76bWQvhAxnOwNDdxhLGw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:aZtoD2qwMeo=:gJdJDayFfrVLG2F5Lg+oyT
 2yrWccjQp+fKY+Oewh5dYDzNjmcgw31ZhFjdgrLXA8/ccXojUSd6DmrmF67wBeHWnGj7cn4Lm
 nIcWnwqzbHgeEgS2p7AVGqKqGorm1CAMA2jQyN+xBATDg+1NaESyWxLDA8pjcR/VIfHhMMdm2
 UIjKxvTmC7AGcu9041NUv6vFSfcpgLNEEROCoSCZA1FFjjNAJQ7iW/xO5gxwIcJu86f2VPvGx
 ufA8yPGwd0AUXflmg7O+eZ5KRXhAzrmga32llXqONyssbEOwt0cp5jeOU7glZJepRUY0dvva0
 c9H1Rrqjl6P6PWTnMKngXD0ImdSC/OdvHr0FCzGdkjmo5VKJeftn7eq2ITiQ/kMktIcLrWXk1
 SID/uZ3cWTuGGjjKhjieNv7BxdRtuATd5KUomKBAKsKVfdL/X/LU7J8lBX/ClzUwriCYFuRHI
 /aod/pueiiwZae9/A3kUL8eMvNPqOOQA7T6ksuMLtsbRRytWMU/cOlaUr299zLeaICh/HgJax
 BA/LWBd4UUFy/dmuARvT34/BbkSutxVaYzaJ3Lk12KlplYfqkDhDNef+MeCNcSBe4dCPZ16T3
 A3j6Hwvf+NOg/QbLnu55JUO0cw9e9vB8NLFJw2PCLnqld9Vsb4oBtBdPojdvvVxubbnOAqsuF
 0cvaDaHw4SAHo9n6oTEKKLKidX1Ik/b2LAI5XrsKjsPScoRz8CLraeJNMdhy/wIGroKoLWblm
 wLV0KsoGUl6QFD5t4ROwrqMeOJ3Isbv8oxqwT6uW0cMrsSSf/GEGjCE6W5GWmU9yB58e6nye9
 rHXFZ4mNXs/kkwTMzvFdrS4uG1CYciy+Kr2Zo1/8Fzf8dmeSbzqB3vbOJhxLQ6Eqc7PzSRo6H
 tAYxjYghwHHZ0h2p7quIF6unb9SPl5aFYvcGmqKp4LfyxSp7SpVmC+r7UP1ui97pzGeI3nKIo
 yWBG0pnFzDIzsJL+KgXyUk0jbMzKNhQPguHkjWXPGXbPAtC2KCNaU/al7+8JZNYMKCeOBM8LJ
 a4zpT6HpP2lUa95KFMmXGJag/a93W0QXUKflWyAPVdW5yNFRqsW31+OgS5H4jnToIFkfmZ/j+
 KDdZdI4wveC93g=
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org


Am 29.10.21 um 14:54 schrieb Miklos Szeredi:
> Here's something I prepared earlier;)
>
> Don't know why it got stuck, quite possibly I realized some fatal flaw t=
hat I
> can't remember anymore...
>
> Seems to work though, so getting this out for review and testing.

The code looks good to me.

I have a small test program which writes 100MB to a tmpfile and then check=
s its contents:

     https://github.com/georgmu/overlaytest

I have tested manual overlayfs creation (make overlaytest) and docker (mak=
e dockertest).

For docker: `docker info | grep "Storage Driver"` should be "overlay2".

I may enhance the test to create multiple tmpfiles in parallel.

Thank you very much for the code. I would add my tested-by.

Best regards,
Georg
