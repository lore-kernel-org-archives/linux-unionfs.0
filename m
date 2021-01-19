Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 335EBC10F04
	for <linux-unionfs@archiver.kernel.org>; Tue, 19 Jan 2021 18:27:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDB8122D2A
	for <linux-unionfs@archiver.kernel.org>; Tue, 19 Jan 2021 18:27:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbhASQ2T (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 11:28:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731449AbhASQXl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 19 Jan 2021 11:23:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611073331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=u9Q4y96bo6R543WF3WIb9gh7PSMWrwFibDeVZ11baSM=;
        b=aWpRDpq8kcP1M+uEdcO83pq2NqoMr96CRhRFPK7K8eXL5ETz3R2ZhBm7GqrL4kZPx8pFxi
        uFMO8DKSqws74Yj1Yuq38JLxm10PsXYtFU7giFU000JMV+jlG8py2X7lP/3a7Jm9bmWuST
        86+GLfbMaUdAYtxeyvdMl9F60tcsE3M=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-599-VpBjt93kP_-uFHknjfjVzA-1; Tue, 19 Jan 2021 11:22:09 -0500
X-MC-Unique: VpBjt93kP_-uFHknjfjVzA-1
Received: by mail-ed1-f71.google.com with SMTP id l33so9630476ede.1
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Jan 2021 08:22:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u9Q4y96bo6R543WF3WIb9gh7PSMWrwFibDeVZ11baSM=;
        b=m7tOR/NA+qSofuAazKCyxuONLK645YNTT9sl6PWtbTXzkCPjNrPspc0Mb0HHqZ7udS
         4lgAeXyizaVMyUKdO0OYzK1nccXnsEvOCK8NMuaAMiAtLEzdyw7SZvTEuczQ2mYHyVG2
         yjP+1XYe73qkGKDnmknQWhuORGgswjDXtKEZJ2xL55LD9Mt1Z2FOF/s+OfEOs0FkwqcF
         s0TCYIbvWDnSBdWZfjqTHZtmk96aUNo4OT9CS/HJy+vy6ufyiSC7mH3+yU4gwi5avKrl
         1P9kJ39YRy19SFckxUFru22iKHmj0UDS/Q9yca3PE+yiCcjVzmVbmLVzeMSiAwOpe04r
         iFoQ==
X-Gm-Message-State: AOAM532ZI1un/DibP6jI0VhtfA5lRKdocUl3s/ZYpJA5kOCynhCQPNEj
        si2IJU/CXCn2mnFWAHiHUiUldwp4VqSCo6ve7qoYVNW+KMwSEscw7r84V6i8DZQjChgxPO57DVg
        zbGgi7YAfACpGRxmFwh/iGaGuoA==
X-Received: by 2002:a17:906:b055:: with SMTP id bj21mr3576260ejb.355.1611073328353;
        Tue, 19 Jan 2021 08:22:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzcHzUnJ7YyoKIR+WDesoLPvRjoftwu+C8P2YCi0ehF8psSXAN/K0sAcoG8KXYJcSh2tch14w==
X-Received: by 2002:a17:906:b055:: with SMTP id bj21mr3576247ejb.355.1611073328141;
        Tue, 19 Jan 2021 08:22:08 -0800 (PST)
Received: from miu.piliscsaba.redhat.com (catv-86-101-169-67.catv.broadband.hu. [86.101.169.67])
        by smtp.gmail.com with ESMTPSA id f22sm2168066eje.34.2021.01.19.08.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 08:22:07 -0800 (PST)
From:   Miklos Szeredi <mszeredi@redhat.com>
To:     "Eric W . Biederman" <ebiederm@xmission.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 0/2] capability conversion fixes
Date:   Tue, 19 Jan 2021 17:22:02 +0100
Message-Id: <20210119162204.2081137-1-mszeredi@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

It turns out overlayfs is actually okay wrt. mutliple conversions, because
it uses the right context for lower operations.  I.e. before calling
vfs_{set,get}xattr() on underlying fs, it overrides creds with that of the
mounter, so the current user ns will now match that of
overlay_sb->s_user_ns, meaning that the caps will be converted to just the
right format for the next layer

OTOH ecryptfs, which is the only other one affected by commit 7c03e2cda4a5
("vfs: move cap_convert_nscap() call into vfs_setxattr()") needs to be
fixed up, since it doesn't do the cap override thing that overlayfs does.

I don't have an ecryptfs setup, so untested, but it's a fairly trivial
change.

My other observation was that cap_inode_getsecurity() messes up conversion
of caps in more than one case.  This is independent of the overlayfs user
ns enablement but affects it as well.

Maybe we can revisit the infrastructure improvements we discussed, but I
think these fixes are more appropriate for the current cycle.

Thanks,
Miklos

Miklos Szeredi (2):
  ecryptfs: fix uid translation for setxattr on security.capability
  security.capability: fix conversions on getxattr

 fs/ecryptfs/inode.c  | 10 +++++--
 security/commoncap.c | 67 ++++++++++++++++++++++++++++----------------
 2 files changed, 50 insertions(+), 27 deletions(-)

-- 
2.26.2

