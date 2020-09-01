Return-Path: <SRS0=Ys2z=CK=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B5A3C433E6
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Sep 2020 18:43:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D45E20767
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Sep 2020 18:43:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T2PgzPTa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730369AbgIASnc (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 14:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgIASnb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 1 Sep 2020 14:43:31 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3FF8C061244
        for <linux-unionfs@vger.kernel.org>; Tue,  1 Sep 2020 11:43:29 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id h11so2200995ilj.11
        for <linux-unionfs@vger.kernel.org>; Tue, 01 Sep 2020 11:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=98EHRQpstma7XmTq8ljKUgWBv/kJUQZ9cLv38HhnMMw=;
        b=T2PgzPTa8OSlfB+YlcN2xWtWL5ZNBb8MaynQAyAwdDceCrSW+yXpZaZVl9c774X1ED
         1WZoZd5PghlCcTWg5Efjo1vMhtLG7leY344lEdaP5PSD+HRK6tOB4bRDtlhhWrGhhaZs
         l5ocBQnaRDK3YepmV9ROab30LNR5FHW+YVhWFd1gfVNHKy87CflQj2EDG50s73HUxdqD
         eau7MKVwh4YoNiTCzFCU8A7So7pJqDHgtRSw66oxlsQwg9hpW+UDhXzIcmm16TRc5pRo
         y6nUThLC1QDEeG/IJZS4wFcxC6vplYzLVoDYSTDcgZc1JB+euVDJMVH7sUQEIa6ke2N1
         VJjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=98EHRQpstma7XmTq8ljKUgWBv/kJUQZ9cLv38HhnMMw=;
        b=WvNiESYqzRZFaAKKQKP3oBPwVK+dYXYqwvMF7+fQnFx9qF4Y/Yo+F25lyW0FFUM5rv
         cAe03J94N2oXkCJOJ4rrcEzHfZnUkXyNudAAOKEIY+XKw/9JtCj/pLm8nHQj1LghcPBj
         2bshn9vrHw+sc2xyTDUnmHnq7aDbXQ82L1A4hOuNpbk8wATlakYfRoHlP418a1YJptVO
         6TTJCspLTtCJS9rmxnEAkZAYwUJH4EAQtH/wqvDeUoDyfLo8fgz9IwAG9sH7PrerZQdG
         Vzq+Q6g8xbf/ehXHrIVImgtTYhV5C+V3m6lwSo9u6ocnwYI7L77kRHZaL0c+Vpc3bbgE
         YHcQ==
X-Gm-Message-State: AOAM533y8OSodE/UKYuf7t36y2d2gGlm2WsxDIwzUf1hwfgU+SoubPBH
        vwd7gLABjY15pKERLQxmTh5l7mfi6cHlcipD9+silN4xSso=
X-Google-Smtp-Source: ABdhPJxRRfT0GJoi7iMSE2U/K39eveSG1xAcLXQqhSQSKHe0QBT3hUAH+Ept/MQFXmr9dkuMTMMU8abKmTaqqnL/t34=
X-Received: by 2002:a92:2810:: with SMTP id l16mr394411ilf.9.1598985809168;
 Tue, 01 Sep 2020 11:43:29 -0700 (PDT)
MIME-Version: 1.0
References: <d5dc093b-71aa-8656-a4d3-c27c14015d79@mclink.it>
In-Reply-To: <d5dc093b-71aa-8656-a4d3-c27c14015d79@mclink.it>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 1 Sep 2020 21:43:17 +0300
Message-ID: <CAOQ4uxgHL2H8RBXbovyFNn_GOC9YE2N6L+AZ6XO=qkA2hhLr=w@mail.gmail.com>
Subject: Re: Frequent errors with OverlayFS on root
To:     Mauro Condarelli <mc5686@mclink.it>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Sep 1, 2020 at 9:01 PM Mauro Condarelli <mc5686@mclink.it> wrote:
>
> Hi,
> most likely this is not the right place to ask, please redirect me as needed.
>
> I'm trying to use OverlayFS to add (limited) write capability to a ReadOnly
> rootfs (SquashFS)
>
> Essentially (actual script is more complex, of course) boot-sequence includes:
>
> # /dev/mmcblk0p5: ext4 (upper+work+nwwroot+newroot/oldroot)
> # /dev/mmcblk0p6: SquashFS mounted on /
> mount /dev/mmcblk0p5 /overlay
> mount -t overlay overlay -o lowerdir=/,upperdir=/overlay/upper,workdir=/overlay/work  /overlay/newroot
> cd /overlay/newroot
> pivot_root . oldroot
> mount --move oldroot/dev /dev
> mount --move oldroot/proc /proc
>
> This works as expected, but, too often for comfort, some file
> (and sometime also directories) become unavailable due to error:
>
> overlayfs: invalid origin (ssh/sshd_config, ftype=8000, origin ftype=4000).
>
> File name changes, of course, but rest is fairly constant.
>
> This always happens when some file is written.
> Error persists reboots.
> Only way I found to "cure" the system is to go on "upper" and delete the file
> thus going back to "lower" version (in this case I should delete "/oldroot/overlay/upper/etc/ssh/sshd_config")
>
> This is a self-built kernel (Linux vocore 5.7.0 #2 PREEMPT Mon Aug 3 09:19:06 CEST 2020 mips GNU/Linux)
> on a custom target based on a SoC (MT7628).
>
> I am available to do any required test, but I have no idea about where to start.
>
> Any hint (or redirect) would be greatly appreciated.

This is probably your problem:
https://lore.kernel.org/linux-unionfs/32532923.JtPX5UtSzP@fgdesktop/

If it is, it should be solved by commit a888db310195
ovl: fix regression with re-formatted lower squashfs
in upstream kernel v5.9-rc1 or in stable kernel >= 5.7.10.

Thanks,
Amir.
