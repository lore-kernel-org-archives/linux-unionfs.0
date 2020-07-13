Return-Path: <SRS0=r5kD=AY=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03DE4C433E3
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Jul 2020 10:57:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7C8120758
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Jul 2020 10:57:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mSVaIOoF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgGMK5o (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 06:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727890AbgGMK5n (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Jul 2020 06:57:43 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B254C061755
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Jul 2020 03:57:43 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id z15so15825292wrl.8
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Jul 2020 03:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BX/TWNv9lyLWNO9o0LNwIveTKBufz8atuzWg5k4ixJ0=;
        b=mSVaIOoFt0QDHxMVQrxywi/tcdurEdyNpVWM9FblAO9zMUxJSj2kG5pX+EzwbDhGyK
         pC4KDdlRKdEODZRFz8DcVhxinaS2deOnfl/yhUDUP3Dp0TmiBrr8JbnJi7rNQBqEsBz+
         Y7PTX1WmieRnqpQc8orijvWOEOtomvWzbtU/quT9O0JfGC0Y2xQ8LlL33joqkcAcrzzF
         OZGsn5iRnupVTPAlBVb1O1PKSJRzVKZ7/iNREfFk3+PLnHRGy48/5Llj8vt8gd0GG8S2
         ppA1ubfssHjNKfiuEEdIsGPHapMHMNCAcDswNR6NnY5C4i3Nsaugq0xQvsc76zYx1HCK
         vTBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BX/TWNv9lyLWNO9o0LNwIveTKBufz8atuzWg5k4ixJ0=;
        b=Zv2BFRhwuFomK8+YL5ra/xsBVYPDtkQI/nu6lo0B9DN08hiwxH0dwtsd4C32rS/imf
         JxXwaUf6pVa3V5V8k6XV+B3SPrSoioMQ2O3/s1hVI398majyXS0sIzUs8Cr75LSjU33V
         NHVb1XK4/MW7sWRZWjeIPqY2jVwywPHn1/zih0im1ChXZ5kAGFff49WGGTAV9E8t/VsF
         cAxKm8GnI/w3Ivvkwxe4LVo/IGHjqE3KvAhYyduRTls2y/YhyPS31xZSjlHZcKOCnm4s
         1KF+IC63bc3IvnfTPv4XjKrfHU3mGOXsHwgHh1e8BtRNHYFgUPsK+qHYGQlpfwCC0tNo
         34Iw==
X-Gm-Message-State: AOAM532oHrqKg1ER18+6lKpkjxH3euX3+tH15YQWNKtiNQu4VJJqCUZ7
        gIw1gK13yIViaGOlJwfJtdE=
X-Google-Smtp-Source: ABdhPJxb18X5FY13gi6duEiy596H7P3b5cbLmPU0FVG7t2VYF7wH567rrRJpuONgb2upQs2oeLSjNQ==
X-Received: by 2002:a5d:4bd2:: with SMTP id l18mr77035116wrt.119.1594637861860;
        Mon, 13 Jul 2020 03:57:41 -0700 (PDT)
Received: from localhost.localdomain ([141.226.183.23])
        by smtp.gmail.com with ESMTPSA id r1sm23099330wrw.24.2020.07.13.03.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 03:57:41 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Vivek Goyal <vgoyal@redhat.com>, Josh England <jjengla@gmail.com>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH RFC 0/2] Invalidate overlayfs dentries on underlying changes
Date:   Mon, 13 Jul 2020 13:57:30 +0300
Message-Id: <20200713105732.2886-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Miklos,Vivek,

These patches are part of the new overlay "fsnotify snapshot" series
I have been working on.

Conterary to the trend to disallow underlying offline changes with more
configurations, I have seen that some people do want to be able to make
some "careful" underlying online changes and survive [1].

In the following patches, I argue for improving the robustness of
overlayfs in the face of online underlying changes, but I have not
really proved my claims, so feel free to challenge them.

I also remember we discussed several times about the conversion of
zero return value to -ESTALE, including in the linked thread.
I did not change this behavior, but I left a boolean 'strict', which
controls this behavior. I am using this boolean to relax strict behavior
for snapshot mount later in my snapshot series. Relaxing the strict
behavior for other use cases can be considered if someone comes up with
a valid use case.

Thoughts?

Thanks,
Amir.

[1] https://lore.kernel.org/linux-unionfs/CAOQ4uxiBmFdcueorKV7zwPLCDq4DE+H8x=8H1f7+3v3zysW9qA@mail.gmail.com/

Amir Goldstein (2):
  ovl: invalidate dentry with deleted real dir
  ovl: invalidate dentry if lower was renamed

 fs/overlayfs/export.c    |  1 +
 fs/overlayfs/namei.c     |  4 +++-
 fs/overlayfs/ovl_entry.h |  2 ++
 fs/overlayfs/super.c     | 48 ++++++++++++++++++++++++++++++----------
 4 files changed, 42 insertions(+), 13 deletions(-)

-- 
2.17.1

