Return-Path: <SRS0=uqCX=CD=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2EDDC433E1
	for <linux-unionfs@archiver.kernel.org>; Tue, 25 Aug 2020 06:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D35DC20706
	for <linux-unionfs@archiver.kernel.org>; Tue, 25 Aug 2020 06:07:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KdK0/zqm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbgHYGHT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 02:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgHYGHQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 25 Aug 2020 02:07:16 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD507C061574
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2020 23:07:15 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id t13so9412093ile.9
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2020 23:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=xOuKA/nLWUmfq8ntQeSUzNJmhh4coykW6Fou06UznSA=;
        b=KdK0/zqm6la5IovTU6PgfUgJAZJK5MREAE+/i25wVZXyluYy8dLO7ZmGGVQvfhq1xB
         o69IZvK5Udvobi2/Wy80yl63z5mdQju+mFflruZC6Wk+oLxxfsq/5Jp0wHoMGDnzkgOX
         aLqrslIebl0pogTDi+9m/eLlkE3AxtBl0+DVABUHgq52HR6ivGxG+MVQ2+bHwcfuxI8E
         Rgw8Xu+vu/woilLsA92OJMEbXXOTlwqKbjiekbr1hHIgdrjSgkx0Zi8XEj5tpPZxyJfW
         CE2E6d+AOtqjAf6DI6liU57WnYUk695SIn5ZuzPRyuLTzB5WizkIh6wZnasJA7KtUS/r
         47Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=xOuKA/nLWUmfq8ntQeSUzNJmhh4coykW6Fou06UznSA=;
        b=mcWlb7Q/7CWPiJz0f6pTUkHdKgM3tgAnWO7zUl/9HFvc83FNHOrVpIEz/cO8ll+/xH
         0jCJDfXl+fFT+12EBohvI4aC9cDcKK7GJkSB3VXRnIl0c3LGNh4TWcrRhXjKDk43k8k3
         NCXtBytTjgoVFrjU/TCrRlAKmOdGaLfAOkjtrTStEWojRLT1hzPucRB78oHgifMnSDAr
         INgUmxPgugXOEPYniNCpj3Ngtq+421GsqOc/ebfJWx/7EkNzDokhR81cRIo18oV9rjxJ
         xXx0x3CZbBAreFlMUa1V/EEJ/GNRIuREGURimnSCR5mhv0XP5srFbXMVGeXO8e+iueDx
         JaOQ==
X-Gm-Message-State: AOAM530BUW94lhzqtx608e+rNOw/qlfgikZcD/eHuOlZuJKoB8M7Bagc
        qQT4mzyMLPogopOFaeJlcNI2m2RgtQl//SD3Lms=
X-Google-Smtp-Source: ABdhPJwI01DaBkn7rrY65+Pi2VBWl/LSIf14Ra0eN4oszLNE3Hx2HP9vlml0OVSbdB2328BaLra8kCKIiIfRkwZdPt4=
X-Received: by 2002:a05:6e02:dc3:: with SMTP id l3mr8188248ilj.137.1598335635263;
 Mon, 24 Aug 2020 23:07:15 -0700 (PDT)
MIME-Version: 1.0
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 25 Aug 2020 09:07:04 +0300
Message-ID: <CAOQ4uxjXZdXZAaeiJ_p9n7NJziBv2yvWqSDs0hDd1ONUrVKxOQ@mail.gmail.com>
Subject: Overlayfs @Plumbers
To:     Linux Containers <containers@lists.linux-foundation.org>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Guys,

It's been nice to virtually meet with you yesterday.
Some of you wanted to follow up on overlayfs related issues.

If you want to discuss, try to find me in one of the
https://meet.2020.linuxplumbersconf.org/hackrooms
today between 16:00-17:00 UTC
(No need to enter the room to see who's inside)

If those times do not work for you, contact me and we can try
to schedule another time.

Thanks,
Amir.
