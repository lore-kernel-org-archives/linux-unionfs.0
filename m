Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89BE7C433EF
	for <linux-unionfs@archiver.kernel.org>; Mon, 25 Oct 2021 02:34:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 642A661002
	for <linux-unionfs@archiver.kernel.org>; Mon, 25 Oct 2021 02:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhJYCg1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 24 Oct 2021 22:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbhJYCg0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 24 Oct 2021 22:36:26 -0400
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C7CC061745
        for <linux-unionfs@vger.kernel.org>; Sun, 24 Oct 2021 19:34:04 -0700 (PDT)
Received: by mail-vk1-xa33.google.com with SMTP id s136so3028903vks.5
        for <linux-unionfs@vger.kernel.org>; Sun, 24 Oct 2021 19:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nextdayvideo-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=5VJf6wW3Zw2DeMC1uvvUDH5A+ThvxlivtsSu9S+fKR8=;
        b=ZxBHYqHxaFsnTs26SGeNSnwMbo5LFu4r/OMhcciAO4FrnSJCPGfeeWWmymabFicAxX
         6hDzC5I7bHkLqRSChsMOWUHuYALbD8rAW7bGxcQjfTf2mQjH8uHZpomgtkBm7CtjcNsa
         WDult1HzacVqZYJa/MnsPJ+19gkUb8JHDmtlF2az2DGRb1EUDUAj4exz0r82id2m/6Mh
         N0x6Whc9oXfgvF1BXKL9LRjJwfTfTTDWa7IYn0JOwubjmNHPogp2klGBYouLYW6LWyVD
         PPHaEZ2d9UAQ8DmxlH104S3XfBKOBnsBJ2AVfkkJdds78Z19P7w+1BH9WWkOQ7D0uIxE
         ERgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=5VJf6wW3Zw2DeMC1uvvUDH5A+ThvxlivtsSu9S+fKR8=;
        b=QO/YmLCa1tZUaLkeO7jJf4916c98RicRYrDUO2ncdqd+A1O51hS4+Lteul5UeXmL1x
         XHOjtTkzrShFE30m9FgM9M+9vR8scKK/wLumByb+VmYq4mlNyXfDV7jh2UlhEK4yyrLr
         CFfOwpXGD7lxJ4hr36ZMVKtto/P+kwPjQHN8rKxZYm+VNpvgHy072cR2+9dbg/DRGckA
         pErCJuz90HrXiQDoOKxy9Idf5sQLr2lAbejU7UqeWhRbJGtEd+/XHlJP/+pmV7wTnhk5
         0qNCYTs8yIfr71AJa8ot9MJWC6fldYJ8G8Y9oS97lFPwzK1JPR9Nll+/WW3Jle20JxCk
         I8mw==
X-Gm-Message-State: AOAM530toEE6mJHRdzNTIU72uFn0XiOn/ZtvsLq+P3cPZIQZrKTXh3NE
        v8lRbBUwItQfjI3pMYra/EqMTHbKusbDH1y02i0pkyR/Yf0=
X-Google-Smtp-Source: ABdhPJwjeGaJOkOTjJiU9kzNWCo5WRGPgd8EhT7AB1CCOF+vOQ8V2hrSKwjYb95orb5jIwOWRlWlYP9ivKe8emDw1Es=
X-Received: by 2002:a05:6122:550:: with SMTP id y16mr12851508vko.18.1635129242286;
 Sun, 24 Oct 2021 19:34:02 -0700 (PDT)
MIME-Version: 1.0
From:   Carl Karsten <carl@nextdayvideo.com>
Date:   Sun, 24 Oct 2021 21:33:35 -0500
Message-ID: <CADmzSShDEfBz=_uVAKMQw1Jkd7TX=chYg4bBo5srKkkhn3HR1A@mail.gmail.com>
Subject: Overlayroot for pi
To:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

I'm looking for something like ubunt's overlayroot package to install on a pi.
https://packages.ubuntu.com/impish/overlayroot
description:
https://spin.atomicobject.com/2015/03/10/protecting-ubuntu-root-filesystem/

I've found a dozen posts about ro pi fs solutions, they all bother me.
mostly they seem more complex than needed,

I'm hoping someone here can point me to something simple.

My previous questions were about setting up a pxe server and that
seems to be sorted:
https://github.com/CarlFK/pici/blob/main/setup.md (all the good stuff
is in setup2.sh)

Now I need to have a rw fs on the pi, but the base fs is a ro nfs
mount. (for production I want it ro, I'll flip it to rw when I need to
apt upgrade the pi.)

I had hope for
https://linuxhit.com/raspberry-pi-pxe-boot-netbooting-a-pi-4-without-an-sd-card/
except:
todo: Make the root file system read-only and configure the client
image to use tmpfs for ephemeral writes.

-- 
Carl K
